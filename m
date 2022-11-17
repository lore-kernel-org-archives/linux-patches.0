Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A22EB07
	for <patches@lists.linux.dev>; Thu, 17 Nov 2022 10:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=2BgNwLdh+HBA4xrzyykRGd8e3nHfE6jHoZjPyIO7tQ8=; b=vf0GDy8lKzIs95KZT9hTDN9bLB
	KkkakBOovK/EhU72ZwXcJFd6ZXnYeh5hWZFAO+QwAUy+Iil38BRQKWQA/ovqtD2R3k/zIRWUVleNY
	mI6EufB0EHT9QlEKH1MxQI8dlYgzNxWxQ/KJJ0HUSUpP7NgTBBgzbRiK7voh4pixtxFai3XdS+4CH
	KUkR3sQ10UY1J1DLrBw2+xk4ToBWEQq3GT1Ou599VPaU5ywBw9TAIVKjU75NdNZTSPprpMUx5CQP1
	Y51nu+1iINv9JXk8aPYDqbEhMoPEahldPraSq7QM6Racs8sRYiTunUTXpT5cPjddHYjb4UQdEZEgF
	MxQo2C5A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35306)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1ovcCQ-0004Iz-Pt; Thu, 17 Nov 2022 10:32:50 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1ovcCG-0006jE-Em; Thu, 17 Nov 2022 10:32:40 +0000
Date: Thu, 17 Nov 2022 10:32:40 +0000
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Heiko Carstens <hca@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Christoph =?iso-8859-1?Q?B=F6hmwalder?= <christoph.boehmwalder@linbit.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Richard Weinberger <richard@nod.at>,
	"Darrick J . Wong" <djwong@kernel.org>,
	SeongJae Park <sj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michael Ellerman <mpe@ellerman.id.au>, Helge Deller <deller@gmx.de>,
	netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-mmc@vger.kernel.org,
	linux-parisc@vger.kernel.org, ydroneaud@opteya.com
Subject: Re: [PATCH v2 3/3] treewide: use get_random_u32_between() when
 possible
Message-ID: <Y3YNyJ8oeixYuvdI@shell.armlinux.org.uk>
References: <20221114164558.1180362-1-Jason@zx2c4.com>
 <20221114164558.1180362-4-Jason@zx2c4.com>
 <202211161436.A45AD719A@keescook>
 <Y3V4g8eorwiU++Y3@zx2c4.com>
 <Y3WW2lOgoYLKQeve@zx2c4.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3WW2lOgoYLKQeve@zx2c4.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>

On Thu, Nov 17, 2022 at 03:05:14AM +0100, Jason A. Donenfeld wrote:
> On Thu, Nov 17, 2022 at 12:55:47AM +0100, Jason A. Donenfeld wrote:
> > 1) How/whether to make f(0, UR2_MAX) safe,
> >    - without additional 64-bit arithmetic,
> >    - minimizing the number of branches.
> >    I have a few ideas I'll code golf for a bit.
> > I think I can make progress with (1) alone by fiddling around with
> > godbolt enough, like usual.
> 
> The code gen is definitely worse.
> 
> Original half-open interval:
> 
>     return floor + get_random_u32_below(ceil - floor);
> 
> Suggested fully closed interval:
> 	
>     ceil = ceil - floor + 1;
>     return likely(ceil) ? floor + get_random_u32_below(ceil) : get_random_u32();

How many of these uses are going to have ceil and floor as a variable?
If they're constants (e.g. due to being in an inline function with
constant arguments) then the compiler will optimise all of the above
and the assembly code will just be either:

1. a call to get_random_u32()
2. a call to get_random_u32_below() and an addition.

If one passes ceil or floor as a variable, then yes, the code gen is
going to be as complicated as you suggest above.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
