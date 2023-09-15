Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5B21B28A
	for <patches@lists.linux.dev>; Fri, 15 Sep 2023 21:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=OjslU8SUhgdXrUcRZYaungvHohmhC3Ah4nEZHFd9adc=; b=bZ9XHGdy3Y7tSqtQxGArjIHu99
	8kyAqRjluuRgG3KHxex8I4xiq3tAQyfHXU6OUOYO4aOnVd9K7ypyRYVTJcyS7lC5Q8sFGMcDdQfcP
	krALeBAXuf+bzNrpPgO3aVJSLmR3k6Z5eobP3l2hv7fUvDznXWgfaknRvsZo/0M2/LNu0J4f1ATOn
	IfT2RYKBE23DIUd3dXYHTNHJyh1z78S/SAZypfU4TRtFENyEl9ydqQRvWUxLAsrF0brhLBxqy6ygl
	oHRcvq4RgkBebxdsz6lv7FjpijkXALeo0ut2wL+jdzHUsIo/bRxm8/kM97kpZwHQG0f6FVhVJKOZu
	q/jXYcKA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1qhGiW-00CHbh-9D; Fri, 15 Sep 2023 21:51:12 +0000
Date: Fri, 15 Sep 2023 22:51:12 +0100
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
Message-ID: <ZQTR0NorkxJlcNBW@casper.infradead.org>
References: <20230915213254.2724586-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230915213254.2724586-1-mcgrof@kernel.org>

On Fri, Sep 15, 2023 at 02:32:44PM -0700, Luis Chamberlain wrote:
> However, an issue is that disabling CONFIG_BUFFER_HEAD in practice is not viable
> for many Linux distributions since it also means disabling support for most
> filesystems other than btrfs and XFS. So we either support larger order folios
> on buffer-heads, or we draw up a solution to enable co-existence. Since at LSFMM
> 2023 it was decided we would not support larger order folios on buffer-heads,

Um, I didn't agree to that.  If block size is equal to folio size, there
are no problems supporting one buffer head per folio.  In fact, we could
probably go up to 8 buffer heads per folio without any trouble (but I'm
not signing up to do that work).

