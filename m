Received: from elvis.franken.de (elvis.franken.de [193.175.24.41])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A39DB16400;
	Tue, 20 Jun 2023 13:22:55 +0000 (UTC)
Received: from uucp by elvis.franken.de with local-rmail (Exim 3.36 #1)
	id 1qBaqt-00087y-00; Tue, 20 Jun 2023 14:52:55 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
	id F1BACC0346; Tue, 20 Jun 2023 14:50:37 +0200 (CEST)
Date: Tue, 20 Jun 2023 14:50:37 +0200
From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To: Nathan Chancellor <nathan@kernel.org>
Cc: ndesaulniers@google.com, trix@redhat.com, jiaxun.yang@flygoat.com,
	linux-mips@vger.kernel.org, llvm@lists.linux.dev,
	patches@lists.linux.dev
Subject: Re: [PATCH] MIPS: Mark core_vpe_count() as __init
Message-ID: <20230620125037.GC10520@alpha.franken.de>
References: <20230615-mips-mark-core_vpe_count-as-init-v1-1-99c124367ea8@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230615-mips-mark-core_vpe_count-as-init-v1-1-99c124367ea8@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, Jun 15, 2023 at 09:21:18AM -0700, Nathan Chancellor wrote:
> After commit 96cb8ae28c65 ("MIPS: Rework smt cmdline parameters"),
> modpost complains when building with clang:
> 
>   WARNING: modpost: vmlinux.o: section mismatch in reference: core_vpe_count (section: .text) -> smp_max_threads (section: .init.data)
> 
> This warning occurs when core_vpe_count() is not inlined, as it appears
> that a non-init function is referring to an init symbol. However, this
> is not a problem in practice because core_vpe_count() is only called
> from __init functions, cps_smp_setup() and cps_prepare_cpus().
> 
> Resolve the warning by marking core_vpe_count() as __init, as it is only
> called in an init context so it can refer to init functions and symbols
> and have its memory freed on boot.
> 
> Fixes: 96cb8ae28c65 ("MIPS: Rework smt cmdline parameters")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  arch/mips/kernel/smp-cps.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/mips/kernel/smp-cps.c b/arch/mips/kernel/smp-cps.c
> index bea6a13ea464..92575222713b 100644
> --- a/arch/mips/kernel/smp-cps.c
> +++ b/arch/mips/kernel/smp-cps.c
> @@ -29,7 +29,7 @@ static DECLARE_BITMAP(core_power, NR_CPUS);
>  
>  struct core_boot_config *mips_cps_core_bootcfg;
>  
> -static unsigned core_vpe_count(unsigned int cluster, unsigned core)
> +static unsigned __init core_vpe_count(unsigned int cluster, unsigned core)
>  {
>  	return min(smp_max_threads, mips_cps_numvps(cluster, core));
>  }
> 
> ---
> base-commit: 5cad8323040bb8d47e130c10ea4dcb7175c7602a
> change-id: 20230615-mips-mark-core_vpe_count-as-init-600dc73e367d
> 
> Best regards,
> -- 
> Nathan Chancellor <nathan@kernel.org>
> 

applied to mips-next.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
