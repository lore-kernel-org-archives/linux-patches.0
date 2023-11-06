Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE1EDF57;
	Mon,  6 Nov 2023 07:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SSznQCH/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JsR9ayW5W/B/juTQaypftAOI6FoM2p6JwLFtaaXiYeY=; b=SSznQCH//sjs76e1wLV444srrk
	IjB9fGYRmpH98jSF6D9OGwcgvbQaqTdm5CXHbU/Ves9131e8i7/fW7YMAGIBhViM6Azlh2HiGHZZ8
	ScO1bEes4pdl4jnHCJlzr0zoI1oTJOXkbgRR9u5bi6OQwXwXAYDOsmxsjGvDY7DeUXiBMSx5NEmUn
	2Tr/uf8AN4z3twUhnZZKV8AuvnvPBWc/RkkjUVZ3X9iXzkh5psGgYL2/4+Z66RPlWXbUN2le8YYb0
	hr/mmhXZjnD6O9ZNH5xmrvdY6bL7shMS1Zc+C46kXVZqrjgO/Nyp2WWYqAdCI7rRELn6VYJwcaVS3
	qjfAMdCA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1qzuMZ-00G1sz-1b;
	Mon, 06 Nov 2023 07:49:35 +0000
Date: Sun, 5 Nov 2023 23:49:35 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, edumazet@google.com,
	davem@davemloft.net, dsahern@kernel.org, kuba@kernel.org,
	pabeni@redhat.com, ndesaulniers@google.com, trix@redhat.com,
	0x7f454c46@gmail.com, fruggeri@arista.com, noureddine@arista.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH net] tcp: Fix -Wc23-extensions in tcp_options_write()
Message-ID: <ZUiaj9qCKD/U2KLp@infradead.org>
References: <20231031-tcp-ao-fix-label-in-compound-statement-warning-v1-1-c9731d115f17@kernel.org>
 <ZUStrQCqBjBBB6dc@infradead.org>
 <20231103165312.GA3670349@dev-arch.thelio-3990X>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231103165312.GA3670349@dev-arch.thelio-3990X>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Normally the kernel keeps the ifdef outside the function body and adds
a stub.  But this already looks like a huge imrpovement over the
existing version to me.
