Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363203358DE;
	Mon, 19 Jan 2026 11:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768822208; cv=none; b=HwufoXPhTLomv3ElyGgIbdfrBs8vo/RtmtntmEyiGQQm0Q+NgbxPGhmVNWzl3WrNvEghtnfgtXLgDRYEErw9iYGKCENemQmjHB4gbabUU0/gWw4PoPyooQPCpQRcAke7I3OQToXaHghgHkZ6wz/uyZv/7YQVT0B/VZQc/4ArLIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768822208; c=relaxed/simple;
	bh=IKFDGW8lNcZi3zEEJBJVSWj4Ti5K2bDsuJwwecGzZzs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lqx58DHz4sEyy8+YkymiP58cdbbOEBtihZBGVUyuVLXwf/u2dSEkBHYRI279dswCCHAYDD1M3JD66/fR6Gu4uisKUBv0E6ylQnpJvJ1j4Z31vZ67ajRT3bn7KAGkC9IcEd2fgDbQeeaYCQIJdcYFRFRrebG6NNidApdmL7ooOhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=htf5bfdk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="htf5bfdk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3834BC19423;
	Mon, 19 Jan 2026 11:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768822207;
	bh=IKFDGW8lNcZi3zEEJBJVSWj4Ti5K2bDsuJwwecGzZzs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=htf5bfdkn+ubJogV6iYVq4qM9Hp2bUXslJJCuPWAhagra6dTMT5JLMs4ESArmR4Qe
	 6Xdz0kipvgQKrkhAc2DAGf5UiMZiR+t3YOOF5WLwSSaW6HSbJwWTxZYlhZrpRV9lAW
	 CF4ZzKWY//TEMnoqvGvHnVQpM/iZeUjoOCwTq8Bc=
Date: Mon, 19 Jan 2026 12:30:04 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 122/451] NFS: Label the dentry with a verifier in
 nfs_rmdir() and nfs_unlink()
Message-ID: <2026011944-june-lustily-ba89@gregkh>
References: <20260115164230.864985076@linuxfoundation.org>
 <20260115164235.336895912@linuxfoundation.org>
 <d33f96006e6641fe7a1adbd617dc6ed8a2adcf93.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d33f96006e6641fe7a1adbd617dc6ed8a2adcf93.camel@decadent.org.uk>

On Sat, Jan 17, 2026 at 04:48:47PM +0100, Ben Hutchings wrote:
> On Thu, 2026-01-15 at 17:45 +0100, Greg Kroah-Hartman wrote:
> > 5.10-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Trond Myklebust <trond.myklebust@hammerspace.com>
> > 
> > [ Upstream commit 9019fb391de02cbff422090768b73afe9f6174df ]
> > 
> > After the success of an operation such as rmdir() or unlink(), we expect
> > to add the dentry back to the dcache as an ordinary negative dentry.
> > However in NFS, unless it is labelled with the appropriate verifier for
> > the parent directory state, then nfs_lookup_revalidate will end up
> > discarding that dentry and forcing a new lookup.
> > 
> > The fix is to ensure that we relabel the dentry appropriately on
> > success.
> [...]
> 
> It looks like we would need a further fix on top of this:
> 
> commit f16857e62bac60786104c020ad7c86e2163b2c5b
> Author: NeilBrown <neil@brown.name>
> Date:   Fri Aug 19 09:55:59 2022 +1000
>  
>     NFS: unlink/rmdir shouldn't call d_delete() twice on ENOENT

Yes, I had tried it, but it didn't apply properly.  I've fixed it up now
by hand as it should be added there, thanks.

greg k-h
