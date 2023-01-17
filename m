Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1811B1FC2
	for <patches@lists.linux.dev>; Tue, 17 Jan 2023 10:15:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7565FC433D2;
	Tue, 17 Jan 2023 10:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673950551;
	bh=lhx/KUqrh5e3ZOehwPrxoQA/EnH6CB7TxUNOKTl/iE4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PfhP5kBvoHRj9gkK8gF/GM9GVVQS3FHUzc34oTv4oZFNH+xIdhP4eNyJvE7pDAwvS
	 J40kdignJbvzWrtRvrpBP8+ji6xhbgZIaumIC8nQrkz/4Kj3VPzU96MXq7osKZu2kO
	 AJqVgCh1yguL2MY6SfO525B6Jd0+E+pB52UxkNVQ=
Date: Tue, 17 Jan 2023 09:40:00 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.14 097/338] wifi: mac80211: fix memory leak in
 ieee80211_if_add()
Message-ID: <Y8Ze4AARrZEpN2J4@kroah.com>
References: <20230116154820.689115727@linuxfoundation.org>
 <20230116154825.125747074@linuxfoundation.org>
 <eddd4836e1f1835ea887ed91e49bb5e6ab65395f.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eddd4836e1f1835ea887ed91e49bb5e6ab65395f.camel@sipsolutions.net>

On Mon, Jan 16, 2023 at 06:14:35PM +0100, Johannes Berg wrote:
> On Mon, 2023-01-16 at 15:49 +0000, Greg Kroah-Hartman wrote:
> > From: Zhengchao Shao <shaozhengchao@huawei.com>
> > 
> > [ Upstream commit 13e5afd3d773c6fc6ca2b89027befaaaa1ea7293 ]
> > 
> > When register_netdevice() failed in ieee80211_if_add(), ndev->tstats
> > isn't released. Fix it.
> > 
> 
> Please drop this wherever you still can - we just reverted it because it
> was actually based on broken analysis.

Thanks, will drop it from 5.4 and older queues.

greg k-h
