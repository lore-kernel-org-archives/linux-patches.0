Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9C9BA3E
	for <patches@lists.linux.dev>; Tue,  4 Apr 2023 15:19:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 518C4C433D2;
	Tue,  4 Apr 2023 15:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1680621572;
	bh=nuJTFJGIsbVfytQ1dEZ5dUc8pyR/VtbceXSR+Jw9H/o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pI6KF+KDRQ9n3cMnn/xrHPLrP0Os6RSDqn2lmDfyr9Ndcq7n8+zKJ0dDL0YXDi7Y6
	 BzlCBvAkfi155dBSzxUGdM1bin88pzkTOud6fecYJBuOqvFVvTrC2uXPBhYdvL73XT
	 /u6NxgGVXyD3EhBOO/Wo8wP0CUq3RjENVkFvAhJLMvqqWRe2CFCNm4ow724VAxQs1Z
	 5lIdWTNHAHWQeHlFwaHu6vavXPeR5tUekKdpBBX1RgcnnpKjhsFbRQ9xk0FHQWnB6f
	 jABq6ATNRK1SI0laDAEuJ/goKp/K0jotbpDUSIO1saSBvAyJgGVT91yb6JgQLLatYo
	 MJZpVoPnEEvdA==
Date: Tue, 4 Apr 2023 11:19:30 -0400
From: Sasha Levin <sashal@kernel.org>
To: Pascal Ernster <git@hardfalcon.net>
Cc: Ming Lei <ming.lei@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>,
	Chao Leng <lengchao@huawei.com>, Sagi Grimberg <sagi@grimberg.me>,
	Hannes Reinecke <hare@suse.de>, Chaitanya Kulkarni <kch@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 6.1 021/181] blk-mq: move the srcu_struct used for
 quiescing to the tagset
Message-ID: <ZCxAAkotxZ+VBHkS@sashalap>
References: <20230403140415.090615502@linuxfoundation.org>
 <20230403140415.825266522@linuxfoundation.org>
 <401a5df3-b13b-fb56-a305-9c82f5f0ca77@0.smtp.remotehost.it>
 <ZCt6vpfpJCk0J451@ovpn-8-16.pek2.redhat.com>
 <2f2bcc75-e46b-6849-734c-2e646d9bb382@0.smtp.remotehost.it>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <2f2bcc75-e46b-6849-734c-2e646d9bb382@0.smtp.remotehost.it>

On Tue, Apr 04, 2023 at 07:56:10AM +0200, Pascal Ernster wrote:
>[2023-04-04 03:17] Ming Lei:
>>On Mon, Apr 03, 2023 at 11:06:53PM +0200, Pascal Ernster wrote:
>>>On systems with their (btrfs) root filesystem residing on an LVM volume,
>>>this patch is reproducibly causing a complete freeze during shutdowns and
>>>reboots.
>>>
>>>I had previously replied with the same message to patch 022/181 instead of
>>>this one, but had gotten the subject mixed up actually meant this patch.
>>
>>That is because the dependency patch is missed:
>>
>>commit 8537380bb988 ("blk-mq: skip non-mq queues in blk_mq_quiesce_queue")
>>
>>https://lore.kernel.org/linux-block/Y6qpwYaPOxgsZjp9@T590/
>
>
>Thanks a lot Ming, this does indeed fix the issue for me. :)

Perfect, thanks for the report and the fix.

I've dropped these two patches from the 6.1 tree for now with plans to
re-do it along with the missing dependency for the next release.

-- 
Thanks,
Sasha
