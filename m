Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98CE210E7
	for <patches@lists.linux.dev>; Fri, 31 Mar 2023 00:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Bsq3wEcOulT/kb6ObY0dkGOm0WZ/hf3lfMKiW2+fj5g=; b=gmZ6EEsdS7/8hkcgrwN8l+O5PC
	sC2HikdUJA+fbQSr/jiJHyK/7yUe/mF8iQpgfoAc1p8GL3CkWXCbv6MsPrsK9G2VgGQuxC9rrOrEp
	u4ydvexq59sgIEyx1UfnfF4xGqGs0Avx3cOB69TQpZdRPTp5A9dMkjcaPF+wv6gUj2Bv0WHQzFl8s
	FROQNhEm6o5mpQvPANXnnQncMP62z+KpZP0E85lcgtXcEPZClBHpu9RyLxs3YWdu+5RZvMDgjocwf
	kMErhsTFbwmMNUl1ynuSavCZNp69f1zEuE0HinB0GNmKr4AihcOTfjsCWsvH8F56V17Rw1MeW1uCW
	JG2nzotQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1pi2vk-005TIe-0I;
	Fri, 31 Mar 2023 00:47:48 +0000
Date: Thu, 30 Mar 2023 17:47:48 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Adam Manzanares <a.manzanares@samsung.com>
Cc: Fan Ni <fan.ni@samsung.com>, "jlayton@kernel.org" <jlayton@kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH] build_qemu: Build and use target arch qemu
Message-ID: <ZCYttC1QS7vwL5Qo@bombadil.infradead.org>
References: <CGME20230330214200uscas1p12bfa2436a1a5b2fc7650d7671b628d8a@uscas1p1.samsung.com>
 <20230330214146.614373-1-a.manzanares@samsung.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230330214146.614373-1-a.manzanares@samsung.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Thu, Mar 30, 2023 at 09:41:56PM +0000, Adam Manzanares wrote:
> Assume the target Linux architecture is also the assumed architecture
> to build and use for QEMU
> 
> Time to build qemu on an x86_64 system before this patch:
> 
> real    6m45.901s
> user    105m18.576s
> sys     12m16.630s
> 
> Time to build qmeu on the same x86_64 system after applying this patch:
> 
> real    2m11.166s
> user    14m32.722s
> sys     2m19.130s
> 
> Signed-off-by: Adam Manzanares <a.manzanares@samsung.com>

I can't see an issue with this now, pushed! Oh it's nice to just
be able to 'b4 am -s' the message ID now :)

  Luis
