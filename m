Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F31B1F5E9
	for <patches@lists.linux.dev>; Mon, 18 Sep 2023 18:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bJs8GAFpWgBUplH+H7BOE7c4QYwKvsPnLGmmT4zwnIE=; b=Vr34XwU7ZL4fQoEk9kow9Lq+5x
	cRKNFtvrvhOEQ3CNMowCtrLeWe6RdRDsn8q+wXZkHUKQ+EC2Ay4FbU3uI0QYkAhlMk1GYKSEbBOC7
	35nnx6LP33x6UkTwxvuFE8VAbkOgb5PRVCaKsJaiclQW6PGoKPdqdyVYBLkAo85YMwKZbFdqXI7MX
	wCp7xK9d5Qrio0pLxEJmtEYuHIuIKmCjPj2FrU2lamMPmBQST+NLbNecBFcBZ2AvY/pJfVTaadbZ7
	mA9EUmzWV4aNZ2CDu69HYwwY4Eji+odGQ4RHg7C5fWGNM+WD9rsw9weOD9uwo/zuLY4+CBABHVUPC
	vedOj9hg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1qiImS-00CU5P-Dl; Mon, 18 Sep 2023 18:15:32 +0000
Date: Mon, 18 Sep 2023 19:15:32 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: hch@infradead.org, djwong@kernel.org, dchinner@redhat.com,
	kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
	brauner@kernel.org, hare@suse.de, ritesh.list@gmail.com,
	rgoldwyn@suse.com, jack@suse.cz, ziy@nvidia.com,
	ryan.roberts@arm.com, patches@lists.linux.dev,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org, p.raghav@samsung.com,
	da.gomez@samsung.com, dan.helmick@samsung.com
Subject: Re: [RFC v2 00/10] bdev: LBS devices support to coexist with
 buffer-heads
Message-ID: <ZQiTxGxpzPBETLTw@casper.infradead.org>
References: <20230915213254.2724586-1-mcgrof@kernel.org>
 <ZQTR0NorkxJlcNBW@casper.infradead.org>
 <ZQiE5HHTLdJOsVPq@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZQiE5HHTLdJOsVPq@bombadil.infradead.org>

On Mon, Sep 18, 2023 at 10:12:04AM -0700, Luis Chamberlain wrote:
> On Fri, Sep 15, 2023 at 10:51:12PM +0100, Matthew Wilcox wrote:
> > On Fri, Sep 15, 2023 at 02:32:44PM -0700, Luis Chamberlain wrote:
> > > However, an issue is that disabling CONFIG_BUFFER_HEAD in practice is not viable
> > > for many Linux distributions since it also means disabling support for most
> > > filesystems other than btrfs and XFS. So we either support larger order folios
> > > on buffer-heads, or we draw up a solution to enable co-existence. Since at LSFMM
> > > 2023 it was decided we would not support larger order folios on buffer-heads,
> > 
> > Um, I didn't agree to that.
> 
> Coverage on sunsetting buffer-heads talk by LWN:
> 
> https://lwn.net/Articles/931809/
> 
> "the apparent conclusion from the session: the buffer-head layer will be
> converted to use folios internally while minimizing changes visible to
> the filesystems using it. Only single-page folios will be used within
> this new buffer-head layer. Any other desires, he said, can be addressed
> later after this problem has been solved."

Other people said that.  Not me.  I said it was fine for single
buffer_head per folio.
