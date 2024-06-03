using Microsoft.Extensions.Logging;
using NLog.Extensions.Logging;

namespace IssueDemo
{
    internal class Program
    {
        static void Main(string[] args)
        {
            var loggerFactory = LoggerFactory.Create(builder => builder.AddNLog());
        }
    }
}
