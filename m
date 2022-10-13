Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC463C29;
	Thu, 13 Oct 2022 16:21:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5671C433D6;
	Thu, 13 Oct 2022 16:21:28 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="GP4P33Go"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1665678086;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kPntWr7A6bA616PExnbnx5reDbccdV4V+F7u1oTVbdw=;
	b=GP4P33GoTZTXwgHWO1z/FqyjryY8qsqfXNBCumID69G06rmzAbuflrmGXm0knLxOwy6AOV
	r5Se8is8rcJ8teWZq2zoRDvfJGTZawQk7FulxMoGHupIBrT9us1rnRt6jRmg3GIbXoJ/w6
	20UjSRmQn/6S5nyrDvb7rvSacSvCVHE=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 5f752f1b (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Thu, 13 Oct 2022 16:21:25 +0000 (UTC)
Date: Thu, 13 Oct 2022 10:21:18 -0600
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Florian Westphal <fw@strlen.de>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
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
Message-ID: <Y0g6/sIJMq/JRe6y@zx2c4.com>
References: <20221010230613.1076905-1-Jason@zx2c4.com>
 <3026360.ZldQQBzMgz@eto.sf-tec.de>
 <20221013101635.GB11818@breakpoint.cc>
 <11986571.xaOnivgMc4@eto.sf-tec.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <11986571.xaOnivgMc4@eto.sf-tec.de>

On Thu, Oct 13, 2022 at 01:40:40PM +0200, Rolf Eike Beer wrote:
> Am Donnerstag, 13. Oktober 2022, 12:16:35 CEST schrieb Florian Westphal:
> > Rolf Eike Beer <eike-kernel@sf-tec.de> wrote:
> > > Florian, can you comment and maybe fix it?
> > 
> > Can't comment, do not remember -- this was 5 years ago.
> > 
> > > Or you wanted to move the variable before the loop and keep the random
> > > state between the loops and only reseed when all '1' bits have been
> > > consumed.
> > Probably.  No clue, best to NOT change it to not block Jasons series and
> > then just simplify this and remove all the useless shifts.
> 
> Sure. Jason, just in case you are going to do a v7 this could move to u8 then.

Indeed I think this is one to send individually to netdev@ once the tree
opens there for 6.2.

Jason
