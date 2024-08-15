Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF3B1C9EBC;
	Thu, 15 Aug 2024 10:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723716304; cv=none; b=gP/SWn8Uip/+xIhlpWtwheyIbX/0w54yEpshbThDWQDcaZG9hB378ULWXvxp2AuvsMY7/pRbGG9ywxWIZivodxavlX32bOnXyRcw4bJKQ2UezHctG7piR2X75fgJ+7/cqDVxfsqCuwZQzXJp8J564FXnMZJL5OKkFIxXqgjQcdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723716304; c=relaxed/simple;
	bh=9LNoCQvdLVH+eKGbnWlwFk75y5xaI/feBMqan62fG7A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M/GvMrhvdFWg9DF5VfWa3ndB6uCb/iGjZl1grjKb2NKLrD7XOsr3CX1QYP3FFYeZy+DguDVM+q7QRCIJkn4/EFYyj6pjgmMvgVzgUw3mqTlLCIjhj3hvz2F02JfA7T4qBcdW4efyBjsMvSguo+Slof1+I7qd9c5wfKmoW17PqkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CR+727ws; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CR+727ws"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 705B6C32786;
	Thu, 15 Aug 2024 10:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723716304;
	bh=9LNoCQvdLVH+eKGbnWlwFk75y5xaI/feBMqan62fG7A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CR+727wsrzpx0O6e8CaqKWqDf1T2LVyP470txs6EnVIdxfdYWlnLLRZBEgZnVT1wf
	 cFc4i8oQ3ZQsio0d76sBPG2ZYp1v2rFG9W9ITFfQRRVPoh9Ylz3Q7Kihkk2H7fSrPW
	 //z5JH1lM7yN0YYnZbV5N10PAY4LXE6GIT+2pCO0=
Date: Thu, 15 Aug 2024 12:05:00 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>, Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 017/568] cgroup/cpuset: Prevent UAF in
 proc_cpuset_show()
Message-ID: <2024081552-stellar-map-2491@gregkh>
References: <20240730151639.792277039@linuxfoundation.org>
 <20240730151640.503086745@linuxfoundation.org>
 <xrc6s5oyf3b5hflsffklogluuvd75h2khanrke2laes3en5js2@6kvpkcxs7ufj>
 <2024081444-outwit-panic-83fa@gregkh>
 <vxrjoloxbtddsmdqybntugwocztrjrnu4urqdfkcm3oybusyeq@4rqtm5foijgs>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <vxrjoloxbtddsmdqybntugwocztrjrnu4urqdfkcm3oybusyeq@4rqtm5foijgs>

On Thu, Aug 15, 2024 at 12:00:35PM +0200, Michal Koutný wrote:
> On Wed, Aug 14, 2024 at 07:45:54PM GMT, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > It is in 6.6.44.
> 
> I meant the commit d23b5c577715 is missing in the backports:
> 
> git grep "list_del.*root_list" torvalds/master -- kernel/cgroup/cgroup.c
> torvalds/master:kernel/cgroup/cgroup.c: list_del_rcu(&root->root_list);
> 
> git grep "list_del.*root_list" v6.6.44 -- kernel/cgroup/cgroup.c
> v6.6.44:kernel/cgroup/cgroup.c:         list_del(&root->root_list);

Ah, yes.  Is that an issue?

confused,

greg k-h
