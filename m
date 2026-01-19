Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3016230F953;
	Mon, 19 Jan 2026 11:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768822327; cv=none; b=tBC7f05FlCIjib9dWBLnRjAfTPjhP1RhtzYeQxE6yXceL5T88r/fW54D/xblW0xUQN14EdKhhcO2HnvjGYRXw/SDYHuOMXx/rBoUzavR5FhOOwN6O0V/sThasou0+YVBIHccCfIHE1YJqFzK0otbiMDfCmJbTYtoTRy7FBXWUWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768822327; c=relaxed/simple;
	bh=w03RCh+yQbOX2kGsn583YEfErBqGvtpU5aUckYIJ0Pw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E0xAolFzbCn3LNjR6EXbAN+V0RmGwG+ZYUFw91s8akNGQ7Rtm7lbEwYL2GzgBZCt0UWZCgfJoLFXvvCcJdrsye+To+bhm93w/Lsyd6WGuAX8MsXeoq6o/8QHR/JaXMwcPbGkPRLnHgvJ3v4khBy+Stk+WzvRhygq93rZgMzze4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XQt26dhJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XQt26dhJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B74C116C6;
	Mon, 19 Jan 2026 11:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768822326;
	bh=w03RCh+yQbOX2kGsn583YEfErBqGvtpU5aUckYIJ0Pw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XQt26dhJWCeVbHxHmgZGGKI/LwpnKK21ln38z5fllI4iHjLtEKyaKqXMbRQonvy8P
	 lXlCADOtPE0XlwnWcPUhBYUNC1ANHcVc5BH2ndlnjuLBzq/WVy1g69x6aWwuZXZqnH
	 IKmrideSWi8mocGzt9dYYZlsT+Ow3JDovvVy38ro=
Date: Mon, 19 Jan 2026 12:32:04 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 123/451] NFS: dont unhash dentry during unlink/rename
Message-ID: <2026011949-petal-quicksand-6817@gregkh>
References: <20260115164230.864985076@linuxfoundation.org>
 <20260115164235.372390370@linuxfoundation.org>
 <99bc0d89d837b64727ccfce7e93fe3bd89f29cb5.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99bc0d89d837b64727ccfce7e93fe3bd89f29cb5.camel@decadent.org.uk>

On Sat, Jan 17, 2026 at 04:50:32PM +0100, Ben Hutchings wrote:
> On Thu, 2026-01-15 at 17:45 +0100, Greg Kroah-Hartman wrote:
> > 5.10-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: NeilBrown <neilb@suse.de>
> > 
> > [ Upstream commit 3c59366c207e4c6c6569524af606baf017a55c61 ]
> > 
> > NFS unlink() (and rename over existing target) must determine if the
> > file is open, and must perform a "silly rename" instead of an unlink (or
> > before rename) if it is.  Otherwise the client might hold a file open
> > which has been removed on the server.
> [...]
> 
> It looks like we need yet another fix after this:
> 
> commit 99bc9f2eb3f79a2b4296d9bf43153e1d10ca50d3
> Author: NeilBrown <neil@brown.name>
> Date:   Tue May 28 13:27:17 2024 +1000
> 
>     NFS: add barriers when testing for NFS_FSDATA_BLOCKED

Yes, I had tried it, it had failed.  But I fixed it up by hand now,
thanks.

greg k-h
