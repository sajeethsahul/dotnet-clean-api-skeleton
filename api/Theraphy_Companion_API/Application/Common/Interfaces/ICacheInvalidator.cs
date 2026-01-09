namespace Therapy_Companion_API.Application.Common.Interfaces
{
    public interface ICacheInvalidator
    {
        Task RemoveByPrefixAsync(string prefix, CancellationToken cancellationToken = default);
    }
}


