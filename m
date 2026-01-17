Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0855A13A244;
	Sat, 17 Jan 2026 15:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768662608; cv=none; b=PPEAgLCNcc1g0e7Ulbpc5QLfM2Xpc2LMuHTM735DCmkCts3uQEV+O+qBYDD/bbkA/3CyOKY3cA3YDhcW7/WV92roySC1KK1Cv7RHqniWFPGt7kSSucL7VFf+aST+dD8gooxX3BMa2WoHr99gvAQrEFl4LQNHeomRcAt27ehRcu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768662608; c=relaxed/simple;
	bh=Kh40MeaBqbeav/9dXtYMPDwAbRp5y/bATSNnXP0GG1Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eynqLXQVnE1vCnbn8bDrUfzrCeQfwy2LkeIPaU8O8YI3gLbmJtQVaVjObjCnjVI3vWJf74jbanD0pciWPcKXynv/LsTshTnT1MdmW1mEm59qK1rxl2CNS4Wgxod28LO4UMddTN0URmBvfnLbsxMue3zERn2DotvbMuymPZr1HOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dyN5iN+T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dyN5iN+T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B7FC19421;
	Sat, 17 Jan 2026 15:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768662607;
	bh=Kh40MeaBqbeav/9dXtYMPDwAbRp5y/bATSNnXP0GG1Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dyN5iN+TvmDRYD7Ux/QHHuy4DEEJuf27xI10lrOlSmPGkMIFnRa+yPyhp+JW4in/I
	 sH2wlBbII6uAvTlhkPr/UC+0zgDWq4VPbQIeCfWCjhiguVHyGxk7IgPjM2q1MBPIPX
	 hRBQdoj9btoEZWy0k3scK+0WQxC9tuzEKNQXUoQQ=
Date: Sat, 17 Jan 2026 16:10:04 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 023/451] samples: work around glibc redefining some
 of our defines wrong
Message-ID: <2026011757-regulate-context-a18f@gregkh>
References: <20260115164230.864985076@linuxfoundation.org>
 <20260115164231.729022046@linuxfoundation.org>
 <47a757bb4d86fb40f14d83adabda441ada44ad16.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47a757bb4d86fb40f14d83adabda441ada44ad16.camel@decadent.org.uk>

On Fri, Jan 16, 2026 at 07:05:58PM +0100, Ben Hutchings wrote:
> On Thu, 2026-01-15 at 17:43 +0100, Greg Kroah-Hartman wrote:
> > 5.10-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Linus Torvalds <torvalds@linux-foundation.org>
> > 
> > [ Upstream commit a48f822908982353c3256e35a089e9e7d0d61580 ]
> > 
> > Apparently as of version 2.42, glibc headers define AT_RENAME_NOREPLACE
> > and some of the other flags for renameat2() and friends in <stdio.h>.
> 
> This is not relevant to 5.10 or any branch older than 6.12, because
> <linux/fcntl.h> only started defining these macros in 6.12.

thanks, now dropped.

greg k-h
