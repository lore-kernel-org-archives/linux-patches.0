Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [193.142.43.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D705290F;
	Thu, 13 Oct 2022 10:59:33 +0000 (UTC)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1oivGV-00028B-QF; Thu, 13 Oct 2022 12:16:35 +0200
Date: Thu, 13 Oct 2022 12:16:35 +0200
From: Florian Westphal <fw@strlen.de>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Florian Westphal <fw@strlen.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Thomas Graf <tgraf@suug.ch>, kasan-dev@googlegroups.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
Subject: Re: [PATCH v6 5/7] treewide: use get_random_u32() when possible
Message-ID: <20221013101635.GB11818@breakpoint.cc>
References: <20221010230613.1076905-1-Jason@zx2c4.com>
 <20221010230613.1076905-6-Jason@zx2c4.com>
 <3026360.ZldQQBzMgz@eto.sf-tec.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3026360.ZldQQBzMgz@eto.sf-tec.de>
User-Agent: Mutt/1.10.1 (2018-07-13)

Rolf Eike Beer <eike-kernel@sf-tec.de> wrote:
> Florian, can you comment and maybe fix it?

Can't comment, do not remember -- this was 5 years ago.

> Or you wanted to move the variable before the loop and keep the random state
> between the loops and only reseed when all '1' bits have been consumed.

Probably.  No clue, best to NOT change it to not block Jasons series and
then just simplify this and remove all the useless shifts.
