Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B708826;
	Fri,  3 Nov 2023 08:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nNNyOoFx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=EPKbN/fAcNBie4nAiJk8hvrFfMadPTWNEWxizjzYh/k=; b=nNNyOoFxo0uwwVvNH/wBj6zyxi
	AAmkgPQPchCj3Moaubf3St2OGjUZ57ikTinRRjirtZGFU4gjc2/lXJ/sMLpSWhyq6Xd9vFgj370K7
	nWATYHpJlFWLlX4oYvz6APkQi38bApywqw116dvcerAEuqtGxAX4vMIlEjH9TUc9oclP+jENuvh8H
	rxbsnDBlCBtYqw9s4g8nNkJRsLhrFwzmllYGoYaFEHfsMWs5Ckn1fL7gaMyU084ZZgoWfoKO6Ue2X
	FfugdaZCdHPS5/wlzaIeM4cjoKzc46QMKLvKz8f6A3VqNBDq1iVgTvkoMnq5eUEdAv7gUi6xDFCKD
	ScKIZBag==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1qypRN-00AyPo-38;
	Fri, 03 Nov 2023 08:22:05 +0000
Date: Fri, 3 Nov 2023 01:22:05 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: edumazet@google.com, davem@davemloft.net, dsahern@kernel.org,
	kuba@kernel.org, pabeni@redhat.com, ndesaulniers@google.com,
	trix@redhat.com, 0x7f454c46@gmail.com, fruggeri@arista.com,
	noureddine@arista.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
	patches@lists.linux.dev
Subject: Re: [PATCH net] tcp: Fix -Wc23-extensions in tcp_options_write()
Message-ID: <ZUStrQCqBjBBB6dc@infradead.org>
References: <20231031-tcp-ao-fix-label-in-compound-statement-warning-v1-1-c9731d115f17@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231031-tcp-ao-fix-label-in-compound-statement-warning-v1-1-c9731d115f17@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Oct 31, 2023 at 01:23:35PM -0700, Nathan Chancellor wrote:
> Clang warns (or errors with CONFIG_WERROR=y) when CONFIG_TCP_AO is set:
> 
>   net/ipv4/tcp_output.c:663:2: error: label at end of compound statement is a C23 extension [-Werror,-Wc23-extensions]
>     663 |         }
>         |         ^
>   1 error generated.
> 
> On earlier releases (such as clang-11, the current minimum supported
> version for building the kernel) that do not support C23, this was a
> hard error unconditionally:
> 
>   net/ipv4/tcp_output.c:663:2: error: expected statement
>           }
>           ^
>   1 error generated.
> 
> Add a semicolon after the label to create an empty statement, which
> resolves the warning or error for all compilers.

Can you please just split the A0 handlig into a separate helper, which
shuld make the whole thing a lot cleaner?

