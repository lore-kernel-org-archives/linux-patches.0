Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8E82F22;
	Sat,  8 Oct 2022 21:42:32 +0000 (UTC)
Received: by mail-qk1-f170.google.com with SMTP id v17so4835331qkv.5;
        Sat, 08 Oct 2022 14:42:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XB90Z1qj3kPK5TTwJuNvzg1Gu7i5Rnz3wWrq9Xc3CzQ=;
        b=EumsjgKwMc2Jw8Mczz4R6dcA2SGR+dlJiih8Ckk15eXQbl1ssNNcUUrPo+6xLg3PJJ
         ACJZlZtsMQ8qHF+g94jmQvqwnd0JN02OtmaV0630S04pQ33UTiRtB3d/9RZxV3IEWRUS
         2r7jZGZp8PRabENWrLu/RcNXt+h8W/EQbCXY+rIwGHkU8CMyznzvzkw9HGkZzTxMPx8w
         xr6afYXFnKmA95gCiWV/Ff4HwGyaoBIjl31rvLZlakhTDvtM9Lwa0DyWxf0sryHaK1o0
         LvM2pyhtabu/3Ucoe1BChll32HfoeeOvRbBxpmidXxDJ1YSjQ/R5moFvf8yAnsYhmD4z
         nBbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XB90Z1qj3kPK5TTwJuNvzg1Gu7i5Rnz3wWrq9Xc3CzQ=;
        b=6vEwRWSp6JWbDAiFx00R8Pa1gb0yp488cOuNKkyv1JBAJH5IgpIuHmOuA5KWoaTH4h
         ZMksyFTt2OB9zBp+fH4h7IU40DL30NB8dJgyETVagJywC8S1UHfOxOdpAiwtNIowBGiB
         USyXBOBtJMZ1DtSlWLSB7abfaGpd3eHBLLCXy+YivOIhBGSaE4secUJn9fktk4ZjhvkP
         C0cd5E7+0ekoqhQxCOruJ8iwiVZqN1g4uc2r+sb+g9fBOluS2Ikk+s7alkRIcI+V2dK+
         iDAJiT+Pm416F4u5Qg/QiFxyg/ALnrWhHYaNTtbCmlvEeTq/y43PCjdCuV+wAnH+uSYp
         3c4Q==
X-Gm-Message-State: ACrzQf0Xfd2KQ8+lqwbuomKAw7lwRPmC21fCeEGddFa6LEfDKah0PMMH
	7Fuivn0FO/jITJ95gM4K+q8=
X-Google-Smtp-Source: AMsMyM7nAvlv/cx8tIjuG0BzVtQBP7E1oOPDn/AxmQr3oNkBQsYkcM4WMSw6/AtojLZMWFu7HL2rZw==
X-Received: by 2002:a05:620a:46a4:b0:6ce:c4af:5a54 with SMTP id bq36-20020a05620a46a400b006cec4af5a54mr8239989qkb.377.1665265351668;
        Sat, 08 Oct 2022 14:42:31 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:2270:4fea:6b67:9485:addd])
        by smtp.gmail.com with ESMTPSA id j1-20020a05620a410100b006cfaee39ccesm5821626qko.114.2022.10.08.14.42.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Oct 2022 14:42:31 -0700 (PDT)
Date: Sat, 8 Oct 2022 14:42:30 -0700
From: Yury Norov <yury.norov@gmail.com>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	Andreas Noever <andreas.noever@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Borislav Petkov <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christoph =?iso-8859-1?Q?B=F6hmwalder?= <christoph.boehmwalder@linbit.com>,
	Christoph Hellwig <hch@lst.de>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Dave Airlie <airlied@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Florian Westphal <fw@strlen.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Heiko Carstens <hca@linux.ibm.com>, Helge Deller <deller@gmx.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Huacai Chen <chenhuacai@kernel.org>,
	Hugh Dickins <hughd@google.com>, Jakub Kicinski <kuba@kernel.org>,
	"James E . J . Bottomley" <jejb@linux.ibm.com>,
	Jan Kara <jack@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jonathan Corbet <corbet@lwn.net>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	KP Singh <kpsingh@kernel.org>, Kees Cook <keescook@chromium.org>,
	Marco Elver <elver@google.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Richard Weinberger <richard@nod.at>,
	Russell King <linux@armlinux.org.uk>, Theodore Ts'o <tytso@mit.edu>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Thomas Gleixner <tglx@linutronix.de>, Thomas Graf <tgraf@suug.ch>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	WANG Xuerui <kernel@xen0n.name>, Will Deacon <will@kernel.org>,
	dri-devel@lists.freedesktop.org, kasan-dev@googlegroups.com,
	kernel-janitors@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mips@vger.kernel.org, linux-mm@kvack.org,
	linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
	linux-nvme@lists.infradead.org, linux-parisc@vger.kernel.org,
	linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-um@lists.infradead.org, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	loongarch@lists.linux.dev, netdev@vger.kernel.org,
	sparclinux@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v5 0/7] treewide cleanup of random integer usage
Message-ID: <Y0HuxsLysThhsaTl@yury-laptop>
References: <20221008055359.286426-1-Jason@zx2c4.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221008055359.286426-1-Jason@zx2c4.com>

On Fri, Oct 07, 2022 at 11:53:52PM -0600, Jason A. Donenfeld wrote:
> Changes v4->v5:
> - Coccinelle is now used for as much mechanical aspects as possible,
>   with mechanical parts split off from non-mechanical parts. This should
>   drastically reduce the amount of code that needs to be reviewed
>   carefully. Each commit mentions now if it was done by hand or is
>   mechanical.
> 
> Hi folks,
> 
> This is a five part treewide cleanup of random integer handling. The
> rules for random integers are:
> 
> - If you want a secure or an insecure random u64, use get_random_u64().
> - If you want a secure or an insecure random u32, use get_random_u32().
>   * The old function prandom_u32() has been deprecated for a while now
>     and is just a wrapper around get_random_u32(). Same for
>     get_random_int().
> - If you want a secure or an insecure random u16, use get_random_u16().
> - If you want a secure or an insecure random u8, use get_random_u8().
> - If you want secure or insecure random bytes, use get_random_bytes().
>   * The old function prandom_bytes() has been deprecated for a while now
>     and has long been a wrapper around get_random_bytes().
> - If you want a non-uniform random u32, u16, or u8 bounded by a certain
>   open interval maximum, use prandom_u32_max().
>   * I say "non-uniform", because it doesn't do any rejection sampling or
>     divisions. Hence, it stays within the prandom_* namespace.
> 
> These rules ought to be applied uniformly, so that we can clean up the
> deprecated functions, and earn the benefits of using the modern
> functions. In particular, in addition to the boring substitutions, this
> patchset accomplishes a few nice effects:
> 
> - By using prandom_u32_max() with an upper-bound that the compiler can
>   prove at compile-time is ≤65536 or ≤256, internally get_random_u16()
>   or get_random_u8() is used, which wastes fewer batched random bytes,
>   and hence has higher throughput.
> 
> - By using prandom_u32_max() instead of %, when the upper-bound is not a
>   constant, division is still avoided, because prandom_u32_max() uses
>   a faster multiplication-based trick instead.
> 
> - By using get_random_u16() or get_random_u8() in cases where the return
>   value is intended to indeed be a u16 or a u8, we waste fewer batched
>   random bytes, and hence have higher throughput.
> 
> So, based on those rules and benefits from following them, this patchset
> breaks down into the following five steps:
> 
> 1) Replace `prandom_u32() % max` and variants thereof with
>    prandom_u32_max(max).
> 
>    * Part 1 is done with Coccinelle. Part 2 is done by hand.
> 
> 2) Replace `(type)get_random_u32()` and variants thereof with
>    get_random_u16() or get_random_u8(). I took the pains to actually
>    look and see what every lvalue type was across the entire tree.
> 
>    * Part 1 is done with Coccinelle. Part 2 is done by hand.
> 
> 3) Replace remaining deprecated uses of prandom_u32() and
>    get_random_int() with get_random_u32(). 
> 
>    * A boring search and replace operation.
> 
> 4) Replace remaining deprecated uses of prandom_bytes() with
>    get_random_bytes().
> 
>    * A boring search and replace operation.
> 
> 5) Remove the deprecated and now-unused prandom_u32() and
>    prandom_bytes() inline wrapper functions.
> 
>    * Just deleting code and updating comments.
> 
> I was thinking of taking this through my random.git tree (on which this
> series is currently based) and submitting it near the end of the merge
> window, or waiting for the very end of the 6.1 cycle when there will be
> the fewest new patches brewing. If somebody with some treewide-cleanup
> experience might share some wisdom about what the best timing usually
> winds up being, I'm all ears.
> 
> Please take a look! The number of lines touched is quite small, so this
> should be reviewable, and as much as is possible has been pushed into
> Coccinelle scripts.

For the series:
Reviewed-by: Yury Norov <yury.norov@gmail.com>

Although, looking at it, I have a feeling that kernel needs to drop all
fixed-size random APIs like get_random_uXX() or get_random_int(), because
people will continue using the 'get_random_int() % num' carelessly.

Thanks,
Yury
