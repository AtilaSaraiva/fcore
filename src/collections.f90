! collections.f90

!> @brief Provides types supporting various collections of objects.
module collections
    use iso_fortran_env
    use ferror
    implicit none
    private
    public :: list
    public :: items_equal
    public :: compare_items

! ******************************************************************************
! TYPES
! ------------------------------------------------------------------------------
    !> @brief A container type allowing storage of any Fortran type.
    type container
        !> A pointer to a polymorphic variable allowing storage of any type.
        class(*), pointer :: item => null()
    end type

    !> @brief Defines a generic list.
    type list
    private
        !> A collection of container objects.
        type(container), allocatable, dimension(:) :: m_list
        !> The actual number of items in m_list
        integer(int32) :: m_count = 0
    contains
        !> @brief Cleans up resources held by the list.
        final :: list_destroy
        !> @brief Gets the capacity of the list.
        procedure, public :: get_capacity => list_get_capacity
        !> @brief Sets the capacity of the list.
        procedure, public :: set_capacity => list_set_capacity
        !> @brief Gets the number of items in the list.
        procedure, public :: get_count => list_get_count
        !> @brief Gets an item from the list.
        procedure, public :: get => list_get
        !> @brief Sets an item into the list.
        procedure, public :: set => list_set
        !> @brief Pushes an item onto the end of the list.
        procedure, public :: push => list_push
        !> @brief Pops the last item from the end of the list.
        procedure, public :: pop => list_pop
        !> @brief Clears the contents of the list.
        procedure, public :: clear => list_clear
        !> @brief Creates a deep copy of the list.
        procedure, public :: copy => list_copy
        !> @brief Inserts an item into the list.
        procedure, public :: insert => list_insert
        !> @brief Removes an item from the list.
        procedure, public :: remove => list_remove
        !> @brief Reverses the contents of the list.
        procedure, public :: reverse => list_reverse
        !> @brief Tests to see if the list contains the specified item.
        procedure, public :: contains => list_contains
        !> @brief Finds the index of the first item in the list that matches
        !! the specified object.
        procedure, public :: index_of => list_index_of
        !> @brief Finds the indices of all items in the list that match the 
        !! specified object.
        procedure, public :: indices_of_all => list_indices_of_all
        ! Swaps two items in the list
        procedure, public :: swap_items => list_swap
        !> @brief Sorts an array into ascending order.
        procedure, public :: sort => list_sort

        !> @brief Stores an item in the collection.  If the collection isn't 
        !! large enough to accomodate, it is automatically resized to 
        !! accomodate.
        procedure, private :: store => list_store
    end type

! ******************************************************************************
! FUNCTION PROTOTYPES
! ------------------------------------------------------------------------------
    interface
        !> @brief Compares two items, and returns a logical value signifying
        !! the comparison results.
        !!
        !! @param[in] item1 The first item.
        !! @param[in] item2 The second item.
        !!
        !! @return Returns true if the comparison is valid; else, false.
        function items_equal(item1, item2) result(rst)
            class(*), intent(in) :: item1, item2
            logical :: rst
        end function

        !> @brief Compares two items, and returns 1 if @p item1 is greater than
        !! @p item2, 0 if @p item1 is equal to @p item2, or -1 if @p item1 is
        !! less than @p item2.
        !!
        !! @param[in] item1 The first item.
        !! @param[in] item2 The second item.
        !!
        !! @return Returns 1 if @p item1 is greater than @p item2, 0 if
        !! @p item1 is equal to @p item2, or -1 if @p item1 is less than 
        !! @p item2.
        function compare_items(item1, item2) result(rst)
            use iso_fortran_env, only : int32
            class(*), intent(in) :: item1, item2
            integer(int32) :: rst
        end function
    end interface

! ******************************************************************************
! INTERFACES
! ------------------------------------------------------------------------------
    interface
        pure module function list_get_capacity(this) result(rst)
            class(list), intent(in) :: this
            integer(int32) :: rst
        end function

        module subroutine list_set_capacity(this, n, err)
            class(list), intent(inout) :: this
            integer(int32), intent(in) :: n
            class(errors), intent(inout), optional, target :: err
        end subroutine

        pure module function list_get_count(this) result(rst)
            class(list), intent(in) :: this
            integer(int32) :: rst
        end function

        module function list_get(this, i) result(x)
            class(list), intent(in) :: this
            integer(int32), intent(in) :: i
            class(*), pointer :: x
        end function

        module subroutine list_set(this, i, x, err)
            class(list), intent(inout) :: this
            integer(int32), intent(in) :: i
            class(*), intent(in) :: x
            class(errors), intent(inout), optional, target :: err
        end subroutine

        module subroutine list_store(this, i, x, err)
            class(list), intent(inout) :: this
            integer(int32), intent(in) :: i
            class(*), intent(in) :: x
            class(errors), intent(inout), optional, target :: err
        end subroutine

        module subroutine list_push(this, x, err)
            class(list), intent(inout) :: this
            class(*), intent(in) :: x
            class(errors), intent(inout), optional, target :: err
        end subroutine

        module subroutine list_pop(this)
            class(list), intent(inout) :: this
        end subroutine

        module subroutine list_clear(this)
            class(list), intent(inout) :: this
        end subroutine

        module function list_copy(this, err) result(rst)
            class(list), intent(in) :: this
            class(errors), intent(inout), optional, target :: err
            type(list) :: rst
        end function

        module subroutine list_insert(this, i, x, err)
            class(list), intent(inout) :: this
            integer(int32), intent(in) :: i
            class(*), intent(in) :: x
            class(errors), intent(inout), optional, target :: err
        end subroutine

        module subroutine list_remove(this, i, err)
            class(list), intent(inout) :: this
            integer(int32), intent(in) :: i
            class(errors), intent(inout), optional, target :: err
        end subroutine

        module subroutine list_destroy(this)
            type(list), intent(inout) :: this
        end subroutine

        module subroutine list_reverse(this)
            class(list), intent(inout) :: this
        end subroutine

        module function list_contains(this, item, fcn) result(rst)
            class(list), intent(in) :: this
            class(*), intent(in) :: item
            procedure(items_equal), pointer, intent(in) :: fcn
            logical :: rst
        end function

        module function list_index_of(this, item, fcn) result(rst)
            class(list), intent(in) :: this
            class(*), intent(in) :: item
            procedure(items_equal), pointer, intent(in) :: fcn
            integer(int32) :: rst
        end function

        module function list_indices_of_all(this, item, fcn, err) result(rst)
            class(list), intent(in) :: this
            class(*), intent(in) :: item
            procedure(items_equal), pointer, intent(in) :: fcn
            class(errors), intent(inout), optional, target :: err
            integer(int32), allocatable, dimension(:) :: rst
        end function

        module subroutine list_swap(this, i1, i2, err)
            class(list), intent(inout) :: this
            integer(int32), intent(in) :: i1, i2
            class(errors), intent(inout), optional, target :: err
        end subroutine

        module subroutine list_sort(this, fcn)
            class(list), intent(inout) :: this
            procedure(compare_items), pointer, intent(in) :: fcn
        end subroutine
    end interface

! ------------------------------------------------------------------------------
end module
