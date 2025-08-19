Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C857C27A121;
	Tue, 19 Aug 2025 12:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755605679; cv=none; b=oVQ6J1G/3VVR92hDVI4PGRldRPAVPKIsATisZ8MqRI34tZHeSx17/bEtw/WPJomNPFh2dcRIL99ZIf4rFidrlG1g+YKxiGlaANO0qQZLR3A5xmS8yt88ZVrpdp8ID+H5N5fMd/MVO3IQDmKqEgeHjleLL0EAsT6uZpMhieVQxu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755605679; c=relaxed/simple;
	bh=Y8Jn4mldOerXZWNycyZAZ0gfc61rH7TinefRWSsa2R8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BOCynIVgWnq1M5cONh+ZiycL20FrdSuwlEvJbJyDX27E+708X0vdsBeZRg5r4lc8l9K2/nJDcj3hciIAWNg/DBSzZ8OcU2IZkg9axDuLhRDbjXD2UtrCSgWYJVVdZD0+jBBNYHsiM+JVITQqT3bOLk7BQNKCUJKqbaV40A/uc0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K/D4Exje; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K/D4Exje"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D562AC4CEF1;
	Tue, 19 Aug 2025 12:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755605679;
	bh=Y8Jn4mldOerXZWNycyZAZ0gfc61rH7TinefRWSsa2R8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K/D4Exjez33bwpIzlVrCudsVqm6LZvYTDSs8OjXxZaJuvxjjw4hJNh0nsSeXTfM4L
	 ENFy5jk3spLRo0cFQu8IbFveB38Vvw3Yow2W8fsHIbwsqe3ZTh/O3XLUPKyne96A2P
	 Pi8LBZ5rHCgwXD45oL7KeRKqKTqXzSpOig4rqY5g=
Date: Tue, 19 Aug 2025 14:14:36 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Wang Zhaolong <wangzhaolong@huaweicloud.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Enzo Matsumiya <ematsumiya@suse.de>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 429/444] smb: client: fix netns refcount leak after
 net_passive changes
Message-ID: <2025081912-blooper-afraid-5b2c@gregkh>
References: <20250818124448.879659024@linuxfoundation.org>
 <20250818124505.034228404@linuxfoundation.org>
 <df2f04b0-2caf-48a0-9817-a3cd07ae1bda@huaweicloud.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df2f04b0-2caf-48a0-9817-a3cd07ae1bda@huaweicloud.com>

On Tue, Aug 19, 2025 at 07:21:28PM +0800, Wang Zhaolong wrote:
> 
> > 
> > Timeline of patches leading to this issue:
> > - commit ef7134c7fc48 ("smb: client: Fix use-after-free of network
> >    namespace.") in v6.12 fixed the original netns UAF by manually
> >    managing socket refcounts
> > - commit e9f2517a3e18 ("smb: client: fix TCP timers deadlock after
> >    rmmod") in v6.13 attempted to use kernel sockets but introduced
> >    TCP timer issues
> > - commit 5c70eb5c593d ("net: better track kernel sockets lifetime")
> >    in v6.14-rc5 introduced the net_passive mechanism with
> >    sk_net_refcnt_upgrade() for proper socket conversion
> > - commit 95d2b9f693ff ("Revert "smb: client: fix TCP timers deadlock
> >    after rmmod"") in v6.15-rc3 reverted to manual refcount management
> >    without adapting to the new net_passive changes
> > 
> 
> 
> Hi Greg,
> 
> This patch depends on the preceding patch 5c70eb5c593d ("net: better
> track kernel sockets lifetime").
> 
> I have noticed that version 6.12.y has not imported this patch,
> so I believe it should not be merged.

This is in the 6.12-rc release as well, so all should be good.

thanks,

greg k-h
