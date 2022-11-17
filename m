Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D838F6A
	for <patches@lists.linux.dev>; Thu, 17 Nov 2022 21:58:26 +0000 (UTC)
Received: by mail-pg1-f170.google.com with SMTP id n17so3282965pgh.9
        for <patches@lists.linux.dev>; Thu, 17 Nov 2022 13:58:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=r2vqsefxvlQpm7YoDJQXEXeeHIkQ6S5JMCMQ5S8aLio=;
        b=k2i7Pob22XCdE3eYvjx4pPufwTb8mTPjukR1UCSAv0kmL6U29qZrcajtJc3GiwR25C
         GxngyGxuAOe8R1u2fG07FDvUurbqbhzNNAvQ0bvvdjotWAgaJxTe1J6rbJlEzDLOD/Zm
         f5ROj4ZQvL1a3wZkcDpdW1XiI4mqzUly58q/U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r2vqsefxvlQpm7YoDJQXEXeeHIkQ6S5JMCMQ5S8aLio=;
        b=Qy698s5AI1iSC12TmBrLTvPZbaVHHCYcRuSrsjSrMYwBb00Gtr+xzJxpWbX+0dXHhr
         ZxQhjnuHUn9Yoz60V+ce5s3eRVWv4cYvL4/WQbwbhI8TJRgDiEbuDFiPeD5IMdtOwWWw
         JIgU/45iiQ8QeIWvGX8NUMPAC0K2dYN1BJVA4JyrPsaor4meUXVC41GMb/P5yo84LfH9
         16iDhvso4VHMjfMIwKEZEvyvwsW5HCh2+prpc066u4ZZ56Ej3xLItsvTyKef6M34QGn1
         1ukZJniHhXHKZPEDgvumrNY96tP6QOWx6sohAAXr/gX68jI388iOYPZuRPj981GGfTjF
         VD3w==
X-Gm-Message-State: ANoB5pk/IvKnKMTJtiNh3x18fSBiD00jYLwvqXXiInqf+c5zFI9k2qGM
	Ra62BkCB/0ZNycKxlZUKJ2CbDg==
X-Google-Smtp-Source: AA0mqf6OLZEOM+uadHNHyZ4glxVpWyLO25QJV2wWHbf4ZbABty2OM80CQ8wN7Ibt7qgRI014DYHeJw==
X-Received: by 2002:a63:5c0f:0:b0:470:8e8a:8e11 with SMTP id q15-20020a635c0f000000b004708e8a8e11mr3843188pgb.490.1668722306503;
        Thu, 17 Nov 2022 13:58:26 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id k3-20020a17090a3cc300b00200461cfa99sm3966446pjd.11.2022.11.17.13.58.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 13:58:25 -0800 (PST)
Date: Thu, 17 Nov 2022 13:58:25 -0800
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
	linux-parisc@vger.kernel.org
Subject: Re: [PATCH v3 2/3] treewide: use get_random_u32_{above,below}()
 instead of manual loop
Message-ID: <202211171358.4B4E0E2F17@keescook>
References: <20221114164558.1180362-1-Jason@zx2c4.com>
 <20221117202906.2312482-1-Jason@zx2c4.com>
 <20221117202906.2312482-3-Jason@zx2c4.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221117202906.2312482-3-Jason@zx2c4.com>

On Thu, Nov 17, 2022 at 09:29:05PM +0100, Jason A. Donenfeld wrote:
> These cases were done with this Coccinelle:
> 
> @@
> expression E;
> identifier I;
> @@
> -   do {
>       ... when != I
> -     I = get_random_u32();
>       ... when != I
> -   } while (I > E);
> +   I = get_random_u32_below(E + 1);
> 
> @@
> expression E;
> identifier I;
> @@
> -   do {
>       ... when != I
> -     I = get_random_u32();
>       ... when != I
> -   } while (I >= E);
> +   I = get_random_u32_below(E);
> 
> @@
> expression E;
> identifier I;
> @@
> -   do {
>       ... when != I
> -     I = get_random_u32();
>       ... when != I
> -   } while (I < E);
> +   I = get_random_u32_above(E - 1);
> 
> @@
> expression E;
> identifier I;
> @@
> -   do {
>       ... when != I
> -     I = get_random_u32();
>       ... when != I
> -   } while (I <= E);
> +   I = get_random_u32_above(E);
> 
> @@
> identifier I;
> @@
> -   do {
>       ... when != I
> -     I = get_random_u32();
>       ... when != I
> -   } while (!I);
> +   I = get_random_u32_above(0);
> 
> @@
> identifier I;
> @@
> -   do {
>       ... when != I
> -     I = get_random_u32();
>       ... when != I
> -   } while (I == 0);
> +   I = get_random_u32_above(0);
> 
> @@
> expression E;
> @@
> - E + 1 + get_random_u32_below(U32_MAX - E)
> + get_random_u32_above(E)
> 
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
