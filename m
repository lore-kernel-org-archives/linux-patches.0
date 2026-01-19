Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60DA295DAC;
	Mon, 19 Jan 2026 11:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768821013; cv=none; b=ddLgxWjhWzm6d+WBc4V//CCWzrvB8w5f+oICjXoijZzcUqsDCRC/WaHpkqwtDgYC4Wla2p/fhoHrIqbEx10MlX54DosqMdSVCROJ3e83Qqk3++FWTeYX2ru7Z+Bk8MO0jtq4E58MkMhv/g99+6G4IuiJjzPi/0J5SPA2boVFnKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768821013; c=relaxed/simple;
	bh=y6hYskb+WkOdrehv19go7tMG5lhiHysvftS7J6ftVZY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CA3SQZRIhF2zqhdLjQhhGHbgg/jJiAane7OpFQuv66cKo8f8LmPxi4FI6aDG7v4flZ8G1lx2yZDv2BmhSNKO2OEvSjWBngIeiCRMZimIyNb9z3avZmEHjB+y6N2/En84R83incAl3VOiK1c2AEyNyS7gESgxgD/wVf2Wk7binwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TIAH5cij; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TIAH5cij"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03DB3C116C6;
	Mon, 19 Jan 2026 11:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768821013;
	bh=y6hYskb+WkOdrehv19go7tMG5lhiHysvftS7J6ftVZY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TIAH5cijyuiTxGLuC+D3QbAhR2KxrzZh9WkjFgXT30qTVOCesjqgHJKiQUWarAdla
	 Y3ydjAOstSYn4R7FOlN4eNqiuxR4YrhwCsA/bsVqJZS8l1QjCUiIMOSj+XAoH/WyMZ
	 aamylvNYDoKQQuJNAvKO3TDGToxZ479b4sQhyUts=
Date: Mon, 19 Jan 2026 12:10:10 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	syzbot+00e61c43eb5e4740438f@syzkaller.appspotmail.com,
	Prithvi Tambewagh <activprithvi@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 5.10 262/451] io_uring: fix filename leak in
 __io_openat_prep()
Message-ID: <2026011920-washday-opossum-6c8b@gregkh>
References: <20260115164230.864985076@linuxfoundation.org>
 <20260115164240.364183352@linuxfoundation.org>
 <2283a941e03c614f1a2fcdadb22dba95c5857dc1.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2283a941e03c614f1a2fcdadb22dba95c5857dc1.camel@decadent.org.uk>

On Sun, Jan 18, 2026 at 12:54:20PM +0100, Ben Hutchings wrote:
> On Thu, 2026-01-15 at 17:47 +0100, Greg Kroah-Hartman wrote:
> > 5.10-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Prithvi Tambewagh <activprithvi@gmail.com>
> >
> >  __io_openat_prep() allocates a struct filename using getname(). However,
> > for the condition of the file being installed in the fixed file table as
> > well as having O_CLOEXEC flag set, the function returns early. At that
> > point, the request doesn't have REQ_F_NEED_CLEANUP flag set. Due to this,
> > the memory for the newly allocated struct filename is not cleaned up,
> > causing a memory leak.
> [...]
> 
> This patch is missing a reference to the upstream commit
> (b14fad555302a2104948feaff70503b64c80ac01).

Oops, don't know where that went, will go add it now, thanks!

greg k-h
