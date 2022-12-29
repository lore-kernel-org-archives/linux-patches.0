Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F18EA1
	for <patches@lists.linux.dev>; Thu, 29 Dec 2022 02:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1672281284;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SsWFLz4dJqUeB0j6WDhqmZGDIF0qcVHAi59EJBSjqP8=;
	b=JVl5tXwNOKF+LxhYVEdsM6mxuyUvVxa6WqXR8Mhc6zdJMpMdB5saMVvBndZlvpIebyK0jL
	VN+oFIwJVHnA5H8T3EA6ovx3V3SGese+IcunNhWbAiFwlk0aCnrPEKx27xIIqrjTLn1cTo
	7/tk9FIEAzVTU9W8c0QgCByVn5Q7R0c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-266-lK1U9ABTPKyySl3zXADAqw-1; Wed, 28 Dec 2022 21:34:42 -0500
X-MC-Unique: lK1U9ABTPKyySl3zXADAqw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DFBD480D180;
	Thu, 29 Dec 2022 02:34:41 +0000 (UTC)
Received: from T590 (ovpn-8-22.pek2.redhat.com [10.72.8.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8F1532166B26;
	Thu, 29 Dec 2022 02:34:34 +0000 (UTC)
Date: Thu, 29 Dec 2022 10:34:29 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>,
	Chao Leng <lengchao@huawei.com>, Sagi Grimberg <sagi@grimberg.me>,
	Hannes Reinecke <hare@suse.de>, Chaitanya Kulkarni <kch@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
	Changhui Zhong <czhong@redhat.com>
Subject: Re: [PATCH 6.0 0853/1073] blk-mq: move the srcu_struct used for
 quiescing to the tagset
Message-ID: <Y6z8tXYQ9ZEVVuNk@T590>
References: <20221228144328.162723588@linuxfoundation.org>
 <20221228144351.187844650@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221228144351.187844650@linuxfoundation.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6

On Wed, Dec 28, 2022 at 03:40:41PM +0100, Greg Kroah-Hartman wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> [ Upstream commit 80bd4a7aab4c9ce59bf5e35fdf52aa23d8a3c9f5 ]
> 
> All I/O submissions have fairly similar latencies, and a tagset-wide
> quiesce is a fairly common operation.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Keith Busch <kbusch@kernel.org>
> Reviewed-by: Ming Lei <ming.lei@redhat.com>
> Reviewed-by: Chao Leng <lengchao@huawei.com>
> Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
> Link: https://lore.kernel.org/r/20221101150050.3510-12-hch@lst.de
> [axboe: fix whitespace]
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Stable-dep-of: d36a9ea5e776 ("block: fix use-after-free of q->q_usage_counter")
> Signed-off-by: Sasha Levin <sashal@kernel.org>

commit 8537380bb988 ("blk-mq: skip non-mq queues in blk_mq_quiesce_queue")
is required for backporting this patch, otherwise kernel panic can be
triggered.

Thanks,
Ming

