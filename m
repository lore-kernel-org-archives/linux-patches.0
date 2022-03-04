Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6B2DA33
	for <patches@lists.linux.dev>; Fri,  4 Mar 2022 09:13:56 +0000 (UTC)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
	id 0709A92009C; Fri,  4 Mar 2022 10:07:48 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by angie.orcam.me.uk (Postfix) with ESMTP id F3FB992009B;
	Fri,  4 Mar 2022 09:07:48 +0000 (GMT)
Date: Fri, 4 Mar 2022 09:07:48 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@orcam.me.uk>
To: Randy Dunlap <rdunlap@infradead.org>
cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
    kernel test robot <lkp@intel.com>, Paul Burton <paulburton@kernel.org>, 
    Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
    linux-mips@vger.kernel.org
Subject: Re: [PATCH] mips: DEC: honor CONFIG_MIPS_FP_SUPPORT=n
In-Reply-To: <20220304011328.27459-1-rdunlap@infradead.org>
Message-ID: <alpine.DEB.2.21.2203040857500.47558@angie.orcam.me.uk>
References: <20220304011328.27459-1-rdunlap@infradead.org>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Thu, 3 Mar 2022, Randy Dunlap wrote:

> Include the DECstation interrupt handler in opting out of
> FPU support.
> 
> Fixes a linker error:
> 
> mips-linux-ld: arch/mips/dec/int-handler.o: in function `fpu':
> (.text+0x148): undefined reference to `handle_fpe_int'
> 
> Fixes: 183b40f992c8 ("MIPS: Allow FP support to be disabled")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: kernel test robot <lkp@intel.com>
> Cc: Paul Burton <paulburton@kernel.org>
> Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> Cc: "Maciej W. Rozycki" <macro@orcam.me.uk>
> Cc: linux-mips@vger.kernel.org
> ---
> This builds OK. Is it enough for runtime interrupt handling?

 There's:

#ifdef CONFIG_32BIT
	lw	t2,cpu_fpu_mask
#endif

earlier on that needs to go too, and code in arch/mips/dec/setup.c below:

	/* Register board interrupts: FPU and cascade. */

(we don't want an unhandled interrupt unmasked).  Are you happy to do such 
an update or shall I?

 I cannot verify that change at run time, because any program that does FP 
will then crash.  Maybe init(8) and sulogin(8) won't.  I can check that.

 Thanks for doing this stuff!

  Maciej
