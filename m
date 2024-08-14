Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517851B86D5;
	Wed, 14 Aug 2024 17:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723657559; cv=none; b=H/DMu9naSY2iz3aSBKS7lI0lBFAoxpBDdrCh1WQ/T3SPFbVEt+rWZ7hryo162FqeQu6cdmB1bs9a/2WxC1oDY4YtfGClskGdyq3BzDEef/FNrQpCsvsjiBrDKdtB0CFLwH7WEg9dqgCrFQh6qJRca7a2MVV/j9nlc7nRDmY/xlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723657559; c=relaxed/simple;
	bh=wAC4ea+KpwuxNBnHFtKKO81lp4kma60H6+z4P6Yf80U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kWYG2GBX21WjcKnzW8rb9JRpH0oa22Ep2+W4TmXtP5YCcCCCuFPt+CkGdKSfz4vmb+e6YXgvo1Tox90ww7MUlLBK1voXM071g3NscbGzH5xwbwOREhTcjFehTtOz+l8wwZlxv6ahJQY9/IoyKdDHxWs+EyI7LtBnmn6cQSwvJig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LHrXekoR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LHrXekoR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64492C4AF09;
	Wed, 14 Aug 2024 17:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723657557;
	bh=wAC4ea+KpwuxNBnHFtKKO81lp4kma60H6+z4P6Yf80U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LHrXekoRzEW6OnKWDuyOFxj4KPWM6L9rkbkfo+ISgMd+CiB1lwDSzrddy0RZiR4Kt
	 XcX6HghXF3FRzVZ4q6SB6s6NCqphZwMWfjhGRSWlSAGkwVa00aBpCyPxBd3SQZXAeC
	 pfLHpRIay4rFSRnwmsq+4k+1DcsU8iv7YtK/uVGE=
Date: Wed, 14 Aug 2024 19:45:54 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>, Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 017/568] cgroup/cpuset: Prevent UAF in
 proc_cpuset_show()
Message-ID: <2024081444-outwit-panic-83fa@gregkh>
References: <20240730151639.792277039@linuxfoundation.org>
 <20240730151640.503086745@linuxfoundation.org>
 <xrc6s5oyf3b5hflsffklogluuvd75h2khanrke2laes3en5js2@6kvpkcxs7ufj>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <xrc6s5oyf3b5hflsffklogluuvd75h2khanrke2laes3en5js2@6kvpkcxs7ufj>

On Wed, Aug 14, 2024 at 02:05:59PM +0200, Michal Koutný wrote:
> Hello.
> 
> On Tue, Jul 30, 2024 at 05:42:04PM GMT, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > ...
> > Fix this problem by using rcu_read_lock in proc_cpuset_show().
> > As cgroup_root is kfree_rcu after commit d23b5c577715
> > ("cgroup: Make operations on the cgroup root_list RCU safe"),
> > css->cgroup won't be freed during the critical section.
> > To call cgroup_path_ns_locked, css_set_lock is needed, so it is safe to
> > replace task_get_css with task_css.
> 
> This backport requires also the mentioned d23b5c577715 to be
> effective (I noticed that is missing in 6.6.y at the moment).

It is in 6.6.44.

thanks,

greg k-h
