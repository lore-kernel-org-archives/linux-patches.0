Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F58EBB
	for <patches@lists.linux.dev>; Wed,  2 Aug 2023 06:46:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A4A3C433C9;
	Wed,  2 Aug 2023 06:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690958794;
	bh=A1+PFjhOPH5Yb8jZHB2wYEMuO8AT2eLLkDrDsOPjyXg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=S7QwMLDGc+QI0uigNs38q5g4jMT0N72JCaoFUHFyBFm1O2AKxgiqJ4hZpreBiGwvW
	 wSKf7Ce6QK+s2OWT+pz+SVVb8GL11cZGiSfbX7Eihan25XxqcvA/Dv9gTwOIJwkwAA
	 0v+e0cTNcfjQlTmZzk+HBSJyDubo/0K4pfr8z3+I=
Date: Wed, 2 Aug 2023 08:46:31 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jan Kara <jack@suse.cz>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>, Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 047/155] jbd2: remove journal_clean_one_cp_list()
Message-ID: <2023080255-absence-sliced-7fc9@gregkh>
References: <20230801091910.165050260@linuxfoundation.org>
 <20230801091911.867814225@linuxfoundation.org>
 <20230801130944.7e3hhyosweufeuaf@quack3>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230801130944.7e3hhyosweufeuaf@quack3>

On Tue, Aug 01, 2023 at 03:09:44PM +0200, Jan Kara wrote:
> On Tue 01-08-23 11:19:19, Greg Kroah-Hartman wrote:
> > From: Zhang Yi <yi.zhang@huawei.com>
> > 
> > [ Upstream commit b98dba273a0e47dbfade89c9af73c5b012a4eabb ]
> > 
> > journal_clean_one_cp_list() and journal_shrink_one_cp_list() are almost
> > the same, so merge them into journal_shrink_one_cp_list(), remove the
> > nr_to_scan parameter, always scan and try to free the whole checkpoint
> > list.
> > 
> > Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> > Reviewed-by: Jan Kara <jack@suse.cz>
> > Link: https://lore.kernel.org/r/20230606135928.434610-4-yi.zhang@huaweicloud.com
> > Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> > Stable-dep-of: 46f881b5b175 ("jbd2: fix a race when checking checkpoint buffer busy")
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> This and the following patch (46f881b5b175) have some issues [1] and cause a
> performance regression for some workloads and possible metadata corruption
> after a crash. So please drop these two patches from the stable trees for
> now. We can include them again later once the code has stabilized...
> Thanks!

Thanks, turns out there were 3 patches here (2 prep patches, one fix)
that needed to be dropped from all queues.  Let us know when the fix is
in Linus's tree so we can add them back in.

thanks,

greg k-h
