Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B7F68F6A
	for <patches@lists.linux.dev>; Thu, 17 Nov 2022 21:59:07 +0000 (UTC)
Received: by mail-pg1-f179.google.com with SMTP id q71so3292539pgq.8
        for <patches@lists.linux.dev>; Thu, 17 Nov 2022 13:59:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5js234S10qtjTG5ViD8Z5NsYYM8xXfh9lDGiYeYzTNk=;
        b=FgMUyRzC1HQVet+tDCWA8ljDeGrHXk7NWmfvGzfwmovUinDK9knhVBWqOEaxR/WKhH
         wwHz/N4KP6pHF44qAgHaZHzh9z++AStihN6Ao5uRAf+yYgVBMZnVIZpD5gjuBWFIjThJ
         QsnQdQgUO9c1DQGCG/8tbnX/sYDH6HkHB7Fks=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5js234S10qtjTG5ViD8Z5NsYYM8xXfh9lDGiYeYzTNk=;
        b=7835F/b9rc++hpvUfP61P9MlX9gjfDEOIWg2uqQVUBcNjJwuAKLmExj+rlcWuCRgJ0
         ZvY4Pt3q2+67wPsCWVmJMhkv2k1ZA1pWmNZOe1dvq9+UcYylFtqrdPdOj0DnMVHHlnUi
         YW8fSRT7kTxG6wYVgFWacVDmG2Azpq6tab05rwwe7Y7OCmhD8sVwJqpDUxOWfRIooKeX
         XoPjJojsS6HPjtd+5frzbBHJX/aEVcw+2CgRSeaYZ4UnMnwVeEUsmeSeWTWk9nbMBTvP
         WKrPL8iL1TvAhhM5wR4/28VgfsSDcm+2zHvlJtA1ZhEnR6D+GUED8EF37QiPXN3h8qqO
         oO5Q==
X-Gm-Message-State: ANoB5pmdLOW//w2duEGKGNgpZQzBSRlvVlA47qilyEqAJlrALaIxJEBS
	A+MtFBmu33IPLtCVXZVb9SuD2Q==
X-Google-Smtp-Source: AA0mqf7QpiIvhVAGN52Mpwqa6vfs4EXQo0/q1js7mM6/xkzmq3rihpfcQy2O/U405oXjhY2LdIG4eg==
X-Received: by 2002:a63:f00d:0:b0:458:f364:b00e with SMTP id k13-20020a63f00d000000b00458f364b00emr3876253pgh.577.1668722346647;
        Thu, 17 Nov 2022 13:59:06 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id u5-20020a17090341c500b00188fce6e8absm156864ple.280.2022.11.17.13.59.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 13:59:06 -0800 (PST)
Date: Thu, 17 Nov 2022 13:59:05 -0800
From: Kees Cook <keescook@chromium.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
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
	linux-parisc@vger.kernel.org,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v3 1/3] treewide: use get_random_u32_below() instead of
 deprecated function
Message-ID: <202211171359.412AEEE0@keescook>
References: <20221114164558.1180362-1-Jason@zx2c4.com>
 <20221117202906.2312482-1-Jason@zx2c4.com>
 <20221117202906.2312482-2-Jason@zx2c4.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221117202906.2312482-2-Jason@zx2c4.com>

On Thu, Nov 17, 2022 at 09:29:04PM +0100, Jason A. Donenfeld wrote:
> This is a simple mechanical transformation done by:
> 
> @@
> expression E;
> @@
> - prandom_u32_max
> + get_random_u32_below
>   (E)
> 
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Acked-by: Darrick J. Wong <djwong@kernel.org> # for xfs
> Reviewed-by: SeongJae Park <sj@kernel.org> # for damon
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com> # for infiniband
> Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk> # for arm
> Acked-by: Ulf Hansson <ulf.hansson@linaro.org> # for mmc
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
