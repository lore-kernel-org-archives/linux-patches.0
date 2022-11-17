Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C6F8F69;
	Thu, 17 Nov 2022 22:11:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D29BC433C1;
	Thu, 17 Nov 2022 22:10:57 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Q4bD/XUA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1668723055;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vJhj9Z3si41Okh7QjFL8sfRqIMi0Yk5+ouF0KwmQggU=;
	b=Q4bD/XUAYdzoxgYLg+XIn4Lk+1x+8orB3IGL4+URLKCwS8OvQEFHtcJHobQ1IjE5hZQeq5
	VnSTrX5zHZ2fE16n1KLU+eanYkc3vTgMFIfA+ELQ9AAw9UvTlkFM7FU8Z1ElmoQ046TyID
	RHhzi0IVhFVn9STyoQTnIxbYkGv6Iw8=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 1cf8d90d (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Thu, 17 Nov 2022 22:10:54 +0000 (UTC)
Date: Thu, 17 Nov 2022 23:10:50 +0100
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Heiko Carstens <hca@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Christoph =?utf-8?Q?B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
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
	linux-parisc@vger.kernel.org
Subject: Re: [PATCH v3 3/3] treewide: use get_random_u32_inclusive() when
 possible
Message-ID: <Y3axaspOlt/oEDhw@zx2c4.com>
References: <20221114164558.1180362-1-Jason@zx2c4.com>
 <20221117202906.2312482-1-Jason@zx2c4.com>
 <20221117202906.2312482-4-Jason@zx2c4.com>
 <202211171349.F42BA5B0@keescook>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <202211171349.F42BA5B0@keescook>

On Thu, Nov 17, 2022 at 01:57:13PM -0800, Kees Cook wrote:
> The only comment I have is that maybe these cases can just be left as-is
> with _below()?
> 
> > -             size_t len = get_random_u32_below(rs) + gs;
> > +             size_t len = get_random_u32_inclusive(gs, rs + gs - 1);
> 
> It seems like writing it in the form of base plus [0, limit) is clearer?
> 
> 		size_t len = gs + get_random_u32_below(rs);
> 
> But there is only a handful, so *shrug*

Okay, I'll drop that one.

Jason
