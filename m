Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C0B12B82
	for <patches@lists.linux.dev>; Thu,  8 Jun 2023 13:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xOPYSXMA8FBLUr/kv5jx92kSAsnGM8wPCIzb12nVRAE=; b=trZXP2L/CRzLAzLlukIAZK+ZVo
	b0WD+QldBAq8BmccB4sqpjbEjxXsNpL9t9YcWRrTY0EiBUkyjQTfirKUJlDBtgGYUnpSmXzG4iKYQ
	DVu/M6LbvR2MFk4X5XTYDh0pXKj6Iyvr77AjrpfvsdD6YlA3KGc69HQrCXRaSaEQpxTcVak/5gzRm
	y0EOCoExHbY8F0HWZZXZxUOGaXrsOIdbIRkaeapUzeyZ5YuHKn8/IQ5BIZ96ZSX+eLX/zaYzcWt96
	EWPec8d8F8byohHzbJRz/9BgDu1SyYxfN+0p3+aL8WuUuPhZkkvGeK64G1GcCDsE5ubTfTjt+FoXW
	FbJQjilg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1q7G5C-009X2C-2I;
	Thu, 08 Jun 2023 13:53:46 +0000
Date: Thu, 8 Jun 2023 06:53:46 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: hch@infradead.org, djwong@kernel.org, dchinner@redhat.com,
	kbusch@kernel.org, willy@infradead.org, hare@suse.de,
	ritesh.list@gmail.com, rgoldwyn@suse.com, jack@suse.cz,
	patches@lists.linux.dev, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	p.raghav@samsung.com, da.gomez@samsung.com, rohan.puri@samsung.com,
	rpuri.linux@gmail.com, corbet@lwn.net, jake@lwn.net
Subject: Re: [RFC 1/4] bdev: replace export of blockdev_superblock with
 BDEVFS_MAGIC
Message-ID: <ZIHdavOjpLpUC4cy@infradead.org>
References: <20230608032404.1887046-1-mcgrof@kernel.org>
 <20230608032404.1887046-2-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230608032404.1887046-2-mcgrof@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jun 07, 2023 at 08:24:01PM -0700, Luis Chamberlain wrote:
> -extern struct super_block *blockdev_superblock;
>  static inline bool sb_is_blkdev_sb(struct super_block *sb)
>  {
> -	return IS_ENABLED(CONFIG_BLOCK) && sb == blockdev_superblock;
> +	return IS_ENABLED(CONFIG_BLOCK) && sb->s_magic == BDEVFS_MAGIC;
>  }

So while I'd love to be able to make blockdev_superblock, I think
the existing code is the better idea here.  BDEVFS_MAGIC can easily
end up in any other s_magic as it's a free-form field.
blockdev_superblock can't accidentally have the same address as a
random non-bdev sb.

