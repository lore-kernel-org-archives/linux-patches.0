Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28FFDC7C
	for <patches@lists.linux.dev>; Fri,  4 Mar 2022 16:17:43 +0000 (UTC)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
	id 8E3BD92009C; Fri,  4 Mar 2022 17:17:41 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by angie.orcam.me.uk (Postfix) with ESMTP id 8807592009B;
	Fri,  4 Mar 2022 16:17:41 +0000 (GMT)
Date: Fri, 4 Mar 2022 16:17:41 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@orcam.me.uk>
To: Randy Dunlap <rdunlap@infradead.org>
cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
    kernel test robot <lkp@intel.com>, Paul Burton <paulburton@kernel.org>, 
    Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
    linux-mips@vger.kernel.org
Subject: Re: [PATCH v2] mips: DEC: honor CONFIG_MIPS_FP_SUPPORT=n
In-Reply-To: <20220304161036.16008-1-rdunlap@infradead.org>
Message-ID: <alpine.DEB.2.21.2203041614260.47558@angie.orcam.me.uk>
References: <20220304161036.16008-1-rdunlap@infradead.org>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Fri, 4 Mar 2022, Randy Dunlap wrote:

> --- linux-next-20220303.orig/arch/mips/dec/setup.c
> +++ linux-next-20220303/arch/mips/dec/setup.c
> @@ -746,6 +746,7 @@ void __init arch_init_irq(void)
>  		dec_interrupt[DEC_IRQ_HALT] = -1;
>  
>  	/* Register board interrupts: FPU and cascade. */
> +#if defined(CONFIG_MIPS_FP_SUPPORT)
>  	if (dec_interrupt[DEC_IRQ_FPU] >= 0 && cpu_has_fpu) {
>  		struct irq_desc *desc_fpu;
>  		int irq_fpu;

 Can you please make it:

	if (IS_ENABLED(CONFIG_MIPS_FP_SUPPORT) && 
	    dec_interrupt[DEC_IRQ_FPU] >= 0 && cpu_has_fpu) {

so as not to add more #ifdef's where avoidable?

  Maciej
