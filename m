Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A4918E1F;
	Wed,  4 Jun 2025 14:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749049046; cv=none; b=bp6UDPdBjF97vJwSVsfzFSClXZgmHdSncrncluojQF5FJanVfVo6OvzRVkrkTMKOyQeGJ+zmzYcvlfJMM/4WuwJmrvB1oHsjpvruaDIbIS4tpy8cvPqB6ehujuqGOynEHHZvcOeSomF/nQmUBXSCPSwOmkt6tZoYyBZlrWnAfzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749049046; c=relaxed/simple;
	bh=UhPTibu2IhtkcKdHuNBFIISA2CSr5AomV//Yoh1cW5I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HjfEkbaO9vNNeJCPgwL/zq7RsqYPBt/+y0KjgaY/aoBqd61Dl3VPoqblcn9vFqdTGF6mLxK5af0xhHDN1MF9BmdZwkQKJobcdFucv3ld2mRYHLJI5v3ob9tcR331y+qx84TU9DO7BSplFePzETFKBHTTVSc6p3EUHdD2lJSq5cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eouLETmS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eouLETmS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 090C3C4CEE4;
	Wed,  4 Jun 2025 14:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749049045;
	bh=UhPTibu2IhtkcKdHuNBFIISA2CSr5AomV//Yoh1cW5I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eouLETmStjV448LcUxr0zSk3b5b6OBdg2nwOMQO0gNWKXj1HtvkHTT4f9d8bCkiZ3
	 PivTAnqQ+wDxw+8M1ReVDqRIU32ERhrm9JyA0Ta344a6mmPGQAB/1KQRrhdEViflgG
	 +zH9/AgxZzH8oS4ggb86yUA6E+hpIxU8vT8UZnMI=
Date: Wed, 4 Jun 2025 16:57:23 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	syzbot+c8cd2d2c412b868263fb@syzkaller.appspotmail.com,
	Jeongjun Park <aha310510@gmail.com>
Subject: Re: [PATCH 5.4 009/204] tracing: Fix oob write in
 trace_seq_to_buffer()
Message-ID: <2025060425-saddled-sliceable-fd12@gregkh>
References: <20250602134255.449974357@linuxfoundation.org>
 <20250602134255.842400124@linuxfoundation.org>
 <20250602103639.6d9776d5@gandalf.local.home>
 <2025060414-dreamily-reentry-ab52@gregkh>
 <20250604104549.32f980db@gandalf.local.home>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250604104549.32f980db@gandalf.local.home>

On Wed, Jun 04, 2025 at 10:45:49AM -0400, Steven Rostedt wrote:
> On Wed, 4 Jun 2025 14:31:49 +0200
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
> > > Note this will require this patch too:
> > > 
> > >    Link: https://lore.kernel.org/20250526013731.1198030-1-pantaixi@huaweicloud.com
> > > 
> > > commit 2fbdb6d8e03b ("tracing: Fix compilation warning on arm32")  
> > 
> > Thanks for the link, I'll queue this up once it hits a released kernel.
> 
> Oh, stable patches have to be in released kernels now? Just being in
> Linus's tree isn't enough?

Yes, unless a maintainer or developer asks for it to be added sooner.

thanks,

greg k-h
