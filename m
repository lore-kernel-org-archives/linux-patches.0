Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFCC519D8BE;
	Thu, 15 Aug 2024 10:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723716338; cv=none; b=hiscoEoxRo0rliw/gg8MqOJ9IaDzFnKayMXDWHuBdxXPnOX+zgY17F9lPtmXfGdNo3y56ZKBIzzd+mzY9Abh5Z/9B4rZaeizeu59gqnWSVA/i0b0RzQCJXalUjUrS6KaHS1QtI35LzNC6y2+yml3engck8igJwNdByZbv4gcbkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723716338; c=relaxed/simple;
	bh=/Mhx7fqpfBgz9lkTDvF49NMocLDDVPwZC+fM3UOkncU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n7VLxt+zO+ZoKFyS7MBwkBRgIqtyMWSH+JRS10zEDvMmmBNq5gyIRVKwffNAqOa66Zuly5jqD5J9VtO2gsrExQuH1OFF7XdLvVr50HO6mzN51oHXlvzt+UKnNDXT4E0x6J8hXk3VSt+xJZ4J0Qo0pQG5D2eZqRlWcvqX234dBME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WAtMkurg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WAtMkurg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D90C32786;
	Thu, 15 Aug 2024 10:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723716338;
	bh=/Mhx7fqpfBgz9lkTDvF49NMocLDDVPwZC+fM3UOkncU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WAtMkurgpCXcM4b46WUbWp6i6oAfx0wqnrkcmPPuopaGjFincEmTeH5c9jV5fLnST
	 fq7NeiPpYAVG7cl1dhCLhAgnBX5R4IZhB6dAABYNTq7oMPF9yQqRGTjSb+tXnRon0d
	 Z+7mMoLc7yzoUNsOO1Aajp6tr5VQSZbc6/s6/isU=
Date: Thu, 15 Aug 2024 12:05:34 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>, Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 017/568] cgroup/cpuset: Prevent UAF in
 proc_cpuset_show()
Message-ID: <2024081523-unseen-spongy-fb96@gregkh>
References: <20240730151639.792277039@linuxfoundation.org>
 <20240730151640.503086745@linuxfoundation.org>
 <xrc6s5oyf3b5hflsffklogluuvd75h2khanrke2laes3en5js2@6kvpkcxs7ufj>
 <2024081444-outwit-panic-83fa@gregkh>
 <vxrjoloxbtddsmdqybntugwocztrjrnu4urqdfkcm3oybusyeq@4rqtm5foijgs>
 <2024081552-stellar-map-2491@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2024081552-stellar-map-2491@gregkh>

On Thu, Aug 15, 2024 at 12:05:00PM +0200, Greg Kroah-Hartman wrote:
> On Thu, Aug 15, 2024 at 12:00:35PM +0200, Michal Koutný wrote:
> > On Wed, Aug 14, 2024 at 07:45:54PM GMT, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > > It is in 6.6.44.
> > 
> > I meant the commit d23b5c577715 is missing in the backports:
> > 
> > git grep "list_del.*root_list" torvalds/master -- kernel/cgroup/cgroup.c
> > torvalds/master:kernel/cgroup/cgroup.c: list_del_rcu(&root->root_list);
> > 
> > git grep "list_del.*root_list" v6.6.44 -- kernel/cgroup/cgroup.c
> > v6.6.44:kernel/cgroup/cgroup.c:         list_del(&root->root_list);
> 
> Ah, yes.  Is that an issue?

Ok, I see it now, let me go queue this up to fix it...

thanks,

greg k-h
