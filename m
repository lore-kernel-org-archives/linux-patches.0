Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D3833CC;
	Tue, 11 Oct 2022 23:01:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9723CC433D6;
	Tue, 11 Oct 2022 23:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1665529308;
	bh=gCI+X2WOw4l6GrJak35sDaAf8gDE0fXgutS5wo82m0c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=AJFptayVxOqteJVOLykn7hUdHTEFBSFYdPDnURZs6EbQ5lnc5EDwMPEWLIY2Zkc6k
	 ToDJ69GFb03nJ1ZHa3Bu1XZh90AT8husNifCGxqExcBTtq73zRbzdbLGz1yV1PS0BR
	 YgADbRNTz4kaxl1FPtL5h69IOLIEA3uAgLFu6LoZOj6vAhrzGGJogNzed4iTNoQ9kU
	 RplOVmj/pT0WrloWUBcPNyJldLUtdrL9BReJJkpTFUke93m8zD4dIphjguaBr6M6BU
	 xC/9Fc6Zmo9mtTlbNcRQZT+mur3mj5hpEnCkCHrxZUfVSrUfpxEhWQqxTOA+fraPtq
	 COtQHCYR1WDtw==
Date: Tue, 11 Oct 2022 16:01:44 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev, Andreas Noever
 <andreas.noever@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Andy
 Shevchenko <andriy.shevchenko@linux.intel.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>, Christoph
 =?UTF-8?B?QsO2aG13YWxkZXI=?= <christoph.boehmwalder@linbit.com>, Christoph
 Hellwig <hch@lst.de>, Christophe Leroy <christophe.leroy@csgroup.eu>,
 Daniel Borkmann <daniel@iogearbox.net>, Dave Airlie <airlied@redhat.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, "David S . Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Florian Westphal
 <fw@strlen.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "H . Peter
 Anvin" <hpa@zytor.com>, Heiko Carstens <hca@linux.ibm.com>, Helge Deller
 <deller@gmx.de>, Herbert Xu <herbert@gondor.apana.org.au>, Huacai Chen
 <chenhuacai@kernel.org>, Hugh Dickins <hughd@google.com>, "James E . J .
 Bottomley" <jejb@linux.ibm.com>, Jan Kara <jack@suse.com>, Jason Gunthorpe
 <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>, Johannes Berg
 <johannes@sipsolutions.net>, Jonathan Corbet <corbet@lwn.net>, Jozsef
 Kadlecsik <kadlec@netfilter.org>, KP Singh <kpsingh@kernel.org>, Kees Cook
 <keescook@chromium.org>, Marco Elver <elver@google.com>, Mauro Carvalho
 Chehab <mchehab@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, Pablo
 Neira Ayuso <pablo@netfilter.org>, Paolo Abeni <pabeni@redhat.com>, Peter
 Zijlstra <peterz@infradead.org>, Richard Weinberger <richard@nod.at>,
 Russell King <linux@armlinux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Thomas
 Bogendoerfer <tsbogend@alpha.franken.de>, Thomas Gleixner
 <tglx@linutronix.de>, Thomas Graf <tgraf@suug.ch>, Ulf Hansson
 <ulf.hansson@linaro.org>, Vignesh Raghavendra <vigneshr@ti.com>, WANG
 Xuerui <kernel@xen0n.name>, Will Deacon <will@kernel.org>, Yury Norov
 <yury.norov@gmail.com>, dri-devel@lists.freedesktop.org,
 kasan-dev@googlegroups.com, kernel-janitors@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mm@kvack.org, linux-mmc@vger.kernel.org,
 linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org,
 linux-parisc@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-um@lists.infradead.org,
 linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev,
 netdev@vger.kernel.org, sparclinux@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v6 0/7] treewide cleanup of random integer usage
Message-ID: <20221011160144.1c0dc2af@kernel.org>
In-Reply-To: <20221010230613.1076905-1-Jason@zx2c4.com>
References: <20221010230613.1076905-1-Jason@zx2c4.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 10 Oct 2022 17:06:06 -0600 Jason A. Donenfeld wrote:
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

Acked-by: Jakub Kicinski <kuba@kernel.org>
