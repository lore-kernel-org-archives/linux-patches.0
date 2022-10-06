Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8888181E
	for <patches@lists.linux.dev>; Thu,  6 Oct 2022 13:31:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2127CC433B5
	for <patches@lists.linux.dev>; Thu,  6 Oct 2022 13:31:10 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="dCt1XlLR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1665063067;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=19y9yEzpIVCdXeybhvKA7dJEvUCmehig1gThjjfIZlg=;
	b=dCt1XlLRhK46o65EhJYBSpRmYOT4n7MeVXGzqEAmpcGdWyuxeH5sPJp8L+8s50v59qatMG
	Pop9Q+fWN3pqL5OpRxJVaBL/44G7A5DyWYXHpzYYf1aO4M481jtYlUZ2z2P2gTZK51QEX3
	xI04TaxnmVtdtVX+upl/OVmNZ34Lghg=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 220e1c04 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
	for <patches@lists.linux.dev>;
	Thu, 6 Oct 2022 13:31:07 +0000 (UTC)
Received: by mail-ua1-f45.google.com with SMTP id p89so623797uap.12
        for <patches@lists.linux.dev>; Thu, 06 Oct 2022 06:31:06 -0700 (PDT)
X-Gm-Message-State: ACrzQf19/bxgHvPXFm/aKs4daQl4XSe1cMgzGsfG1qigZfLGVmu5ak8f
	4HYNliVoXz7reQpwfCajmxRRRGsudiHBGGS8y4g=
X-Google-Smtp-Source: AMsMyM5LOcwlCqLDJ8Sdf5AH9P6p8LW9hstCcin8XnWJVl2TEMHnjzVUue7OZJku+oxVakLrWA9vu3wGp+73FInbltY=
X-Received: by 2002:ab0:70b9:0:b0:3d7:84d8:35ae with SMTP id
 q25-20020ab070b9000000b003d784d835aemr2699257ual.24.1665063063460; Thu, 06
 Oct 2022 06:31:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221006132510.23374-1-Jason@zx2c4.com>
In-Reply-To: <20221006132510.23374-1-Jason@zx2c4.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Thu, 6 Oct 2022 07:30:52 -0600
X-Gmail-Original-Message-ID: <CAHmME9pXuGKNsm3cCOMLSOMJoX2XJnHffpiF_rr32mW2ozShhw@mail.gmail.com>
Message-ID: <CAHmME9pXuGKNsm3cCOMLSOMJoX2XJnHffpiF_rr32mW2ozShhw@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] treewide cleanup of random integer usage
To: linux-kernel@vger.kernel.org, patches@lists.linux.dev
Cc: Andreas Noever <andreas.noever@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Borislav Petkov <bp@alien8.de>, 
	=?UTF-8?Q?Christoph_B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>, 
	Christoph Hellwig <hch@lst.de>, Daniel Borkmann <daniel@iogearbox.net>, Dave Airlie <airlied@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Florian Westphal <fw@strlen.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "H . Peter Anvin" <hpa@zytor.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Hugh Dickins <hughd@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, "James E . J . Bottomley" <jejb@linux.ibm.com>, Jan Kara <jack@suse.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>, 
	Johannes Berg <johannes@sipsolutions.net>, Jonathan Corbet <corbet@lwn.net>, 
	Jozsef Kadlecsik <kadlec@netfilter.org>, KP Singh <kpsingh@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Marco Elver <elver@google.com>, 
	Mauro Carvalho Chehab <mchehab@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Pablo Neira Ayuso <pablo@netfilter.org>, Paolo Abeni <pabeni@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>, 
	Thomas Gleixner <tglx@linutronix.de>, Thomas Graf <tgraf@suug.ch>, Ulf Hansson <ulf.hansson@linaro.org>, 
	Vignesh Raghavendra <vigneshr@ti.com>, Yury Norov <yury.norov@gmail.com>, dri-devel@lists.freedesktop.org, 
	kasan-dev@googlegroups.com, kernel-janitors@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-media@vger.kernel.org, linux-mm@kvack.org, linux-mmc@vger.kernel.org, 
	linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org, 
	linux-rdma@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, Oct 6, 2022 at 7:25 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> This is a five part treewide cleanup of random integer handling.
> [...]
> Please take a look!

I should add that this patchset probably appears bigger than it
already is, due in part to that wall of motivational text. Keep in
mind, though, that the whole thing is only "305 insertions(+), 342
deletions(-)", so it should be conventionally reviewable.

Jason
