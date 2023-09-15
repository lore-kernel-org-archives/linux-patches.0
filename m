Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D01D11CAA
	for <patches@lists.linux.dev>; Fri, 15 Sep 2023 22:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8LC9ABYMtvMooE79NbP16TEYzDeGtu70GqKcQJq0kq8=; b=yvjb2o6tPz1MXMBAeSj5x0aIeX
	cSyGmvEkgi9faScHYHoY7w2yGKAMnNLOrG7feAdQ0cZfW75y5sLVzItObHcbaA/wCbNeC7u9i7Vb3
	qVDqisy5tG+YMgMDi1CyH/XCPBPSVguSQJ7wZMp+4qsQK42Uf4LLP+6hCaYjmZLJMqDi3EhMjv/0N
	7T0Bk4kV6enU9TwwKEPuV/91RFgY2hBsV/hsFaqrU1Vmv3k179SqOkLfZj/J2KvTIygP9k3HJBb5i
	9iBIo7uUEM24yU59PUtlrUf3IHvGSg+AbdAG4MWXzCNGJN9bvnComXGA1VWmb50RdGbAqA9KuFJu1
	iudWUlVQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1qhHI6-00BUEa-2Z;
	Fri, 15 Sep 2023 22:27:58 +0000
Date: Fri, 15 Sep 2023 15:27:58 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Matthew Wilcox <willy@infradead.org>, Jeff Layton <jlayton@kernel.org>
Cc: hch@infradead.org, djwong@kernel.org, dchinner@redhat.com,
	kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
	brauner@kernel.org, hare@suse.de, ritesh.list@gmail.com,
	rgoldwyn@suse.com, jack@suse.cz, ziy@nvidia.com,
	ryan.roberts@arm.com, patches@lists.linux.dev,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org, p.raghav@samsung.com,
	da.gomez@samsung.com, dan.helmick@samsung.com
Subject: Re: [RFC v2 07/10] nvme: enhance max supported LBA format check
Message-ID: <ZQTablZ1mHzb/MJl@bombadil.infradead.org>
References: <20230915213254.2724586-1-mcgrof@kernel.org>
 <20230915213254.2724586-8-mcgrof@kernel.org>
 <ZQTYt9qG0AxhgR4I@casper.infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZQTYt9qG0AxhgR4I@casper.infradead.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Fri, Sep 15, 2023 at 11:20:39PM +0100, Matthew Wilcox wrote:
> On Fri, Sep 15, 2023 at 02:32:51PM -0700, Luis Chamberlain wrote:
> > +/* XXX: shift 20 (1 MiB LBA) crashes on pure-iomap */
> > +#define NVME_MAX_SHIFT_SUPPORTED 19
> 
> I imagine somewhere we do a PAGE_SIZE << 20 and it overflows an int to 0.
> I've been trying to use size_t everywhere, but we probably missed
> something.
> 
> Does 19 work on a machine with 64kB pages?  My guess is no.

Let's ask someone who *might* have access to a 64k PAGE_SIZE system or
might know someone who does.

I definitely don't!

  Luis
