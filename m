Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5778B29AC
	for <patches@lists.linux.dev>; Wed, 25 May 2022 22:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=2LbSngeeObuFPL7ErF2AoPAHTv4dJXye4aEdBeQeQNc=; b=pKt+abZAcRwTjLPiIuUJ63udl/
	LnZRnektXGIrQifOO2P7wqD5PIlFZuz1FEsn7dG3uIrD0Zcm9nJmRg6jzQ00L28dKnVvU64/SnM0V
	WgngpftvIhbvNa1nF/R2cpMNn3GHQsnpskfqcbowHfbfnCnG1RrjqLx3YEKODPnz/gZccpnduZ+6k
	cHd90+71zdAoZiw3qkosD0UdzDJHfo8IRph+0ZBS+nlISrFAZFqB3LRXClk3O3Qm5udZsMgkKdDCD
	1Y1R04KKoSlNcDEDVZAsI/f126QGimL6tkIM7vsK6kH7EaZ5DS6vQWIFBmABtfvqfKaQQ/st2szcq
	5SRd4ZOA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1ntzqR-00CuyK-CE; Wed, 25 May 2022 22:51:11 +0000
Date: Wed, 25 May 2022 15:51:11 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: patches@lists.linux.dev, linux-modules@vger.kernel.org,
	live-patching@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Aaron Tomlin <atomlin@redhat.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Lecopzer Chen <lecopzer.chen@mediatek.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>, Song Liu <song@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Christoph Hellwig <hch@infradead.org>,
	Matthew Wilcox <willy@infradead.org>,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [GIT PULL] Modules fixes for v5.19-rc1
Message-ID: <Yo6y37M4oyv5z4+D@bombadil.infradead.org>
References: <Yo6kboq8M8nUwy45@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yo6kboq8M8nUwy45@bombadil.infradead.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>

Sorry the subject should say "Modules changes".

I also forgot to itemize possible merge conflicts and resolutions
which linux-next reported:

powerpc:
https://lkml.kernel.org/r/20220520154055.7f964b76@canb.auug.org.au

kbuild:
https://lkml.kernel.org/r/20220523120859.570f7367@canb.auug.org.au

  Luis
