Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F021B1389
	for <patches@lists.linux.dev>; Sun,  9 Oct 2022 03:41:16 +0000 (UTC)
Received: by mail-pg1-f182.google.com with SMTP id u71so282208pgd.2
        for <patches@lists.linux.dev>; Sat, 08 Oct 2022 20:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Jc9wqi9hH7sDAuXmZMPHByefEvgO0MbR3+ZEqDB7Wuk=;
        b=ZhbF7aukJSn3TNMRwCJkZSqm1r+X38mJ2RxvPJW6Z+9mn1TOlxypOyituNx8mz1HVC
         FGqxSiHSDomVzpOPFi9kka3+6Rdn9v0XaNwqyXLdtOhmQI0POv0z39c8Rsj4C7/d+KIP
         fJKzHg6Na0ETg2nVHR+d6vQT/rsL3lGZwlInw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jc9wqi9hH7sDAuXmZMPHByefEvgO0MbR3+ZEqDB7Wuk=;
        b=fecjm0dZII5qkKEFYShWuMcH1yWzGRhiF++6v95HCarcPFu+eT/8lOUQqtKR6Y+cfW
         TESFYuzAXnZYJ7C8HBeCJ4jo6QPLFlZpEh1bnLeS2MyS6QD/6+t0YIk/lLaVI+buLBiA
         Dmx5r1yRSp8F8xx2eIG6Bnfwa8iyWffUnHTk3sfrIZqpJ+bCs/uzdo9ax4k7heSxJmw3
         sXaleWLrLGv1VSPRPI5vfo6iSgFb4HWLJ406KY8kwIzeZEc5m+6TINwUjfUGAq7GbpZ1
         a15VhWh07iDbWNm7OyD1UMWcgMcDagzyIPlgckxXIvtTauINXn4lsOiXKMGQxtJtjQ6O
         G1FQ==
X-Gm-Message-State: ACrzQf3XrOsj2YC8OFv0JQ1ntixz1CBY6vmY5GV8AeWV6vevpXvcIaGh
	oUxEr/fdgVZ/dZbbf+VEFXGSYA==
X-Google-Smtp-Source: AMsMyM5FGTaJNFEGPbumoaD5MBb6Q7fQgfiKiCpnvelFpTCgpDJD/BqrIxkvX1O2Yt8qSiE6wtg/9Q==
X-Received: by 2002:a63:1a45:0:b0:439:49b4:9672 with SMTP id a5-20020a631a45000000b0043949b49672mr11177300pgm.551.1665286876512;
        Sat, 08 Oct 2022 20:41:16 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id h129-20020a625387000000b00561ed54aa53sm4353776pfb.97.2022.10.08.20.41.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Oct 2022 20:41:15 -0700 (PDT)
Date: Sat, 8 Oct 2022 20:41:14 -0700
From: Kees Cook <keescook@chromium.org>
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
	KP Singh <kpsingh@kernel.org>, Marco Elver <elver@google.com>,
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
	Yury Norov <yury.norov@gmail.com>, dri-devel@lists.freedesktop.org,
	kasan-dev@googlegroups.com, kernel-janitors@vger.kernel.org,
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
Message-ID: <202210082028.692DFA21@keescook>
References: <20221008055359.286426-1-Jason@zx2c4.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221008055359.286426-1-Jason@zx2c4.com>

On Fri, Oct 07, 2022 at 11:53:52PM -0600, Jason A. Donenfeld wrote:
> This is a five part treewide cleanup of random integer handling. The
> rules for random integers are:

Reviewing the delta between of my .cocci rules and your v5, everything
matches, except for get_random_int() conversions for files not in
your tree:

diff --git a/drivers/gpu/drm/tests/drm_buddy_test.c b/drivers/gpu/drm/tests/drm_buddy_test.c
index 7a2b2d6bc3fe..62f69589a72d 100644
--- a/drivers/gpu/drm/tests/drm_buddy_test.c
+++ b/drivers/gpu/drm/tests/drm_buddy_test.c
@@ -729,7 +729,7 @@ static void drm_test_buddy_alloc_limit(struct kunit *test)
 static int drm_buddy_init_test(struct kunit *test)
 {
 	while (!random_seed)
-		random_seed = get_random_int();
+		random_seed = get_random_u32();
 
 	return 0;
 }
diff --git a/drivers/gpu/drm/tests/drm_mm_test.c b/drivers/gpu/drm/tests/drm_mm_test.c
index 659d1af4dca7..c4b66eeae203 100644
--- a/drivers/gpu/drm/tests/drm_mm_test.c
+++ b/drivers/gpu/drm/tests/drm_mm_test.c
@@ -2212,7 +2212,7 @@ static void drm_test_mm_color_evict_range(struct kunit *test)
 static int drm_mm_init_test(struct kunit *test)
 {
 	while (!random_seed)
-		random_seed = get_random_int();
+		random_seed = get_random_u32();
 
 	return 0;
 }

So, I guess I mean to say that "prandom: remove unused functions" is
going to cause some pain. :) Perhaps don't push that to -next, and do a
final pass next merge window to catch any new stuff, and then send those
updates and the removal before -rc1 closes?

-- 
Kees Cook
