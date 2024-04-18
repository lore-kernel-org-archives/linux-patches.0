Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3229C16C6B1;
	Thu, 18 Apr 2024 15:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713454449; cv=none; b=qZz7zD3wbfsufqOju+uSwMKUqioy1HqntfjjNl76kAK5yHYE09xLJy5GTOgITUPpghE8Fnzzu/gpLNFJjTGcfFS1COC8e8InONxbYQEfxAB4fj7wYyuOUBn87fjtGUbD4O2nf5LdXwz3bAbDB518L9Se6uuRcINXGAQlQ1+UyOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713454449; c=relaxed/simple;
	bh=vg4Qlt/Y9xtKES/hpBiuoGKsulseP9UqrUFMo9Ixo1A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AhR4josoyLnCidC1S/NiH13OfxuFFtlTP4LowyrUMSw8TePbg6s0wkLmR4ScmfvES13V+CSOjStvd/+seWwsG1BfRR/qOYJq55ZNYpKBLUJRjPjuIWdE9UO+REWavTt7qE2QP30vKP16XjDlzmXMaMtQDTwO3pSh1DnnqrQRBvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fBW2Cdgl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fBW2Cdgl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D8AC113CC;
	Thu, 18 Apr 2024 15:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713454449;
	bh=vg4Qlt/Y9xtKES/hpBiuoGKsulseP9UqrUFMo9Ixo1A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fBW2CdglSwCiQcnjggV9goby5Pi0ukJlB9vAgq/NnPobnVJGDOUdvT0LNloAsjVRG
	 iz/Ck4yP54mtvv2ewejtww5mZ37l6IJPvcKFp0JJDY25EHRFqwJ4+7A4teKNTFN83R
	 28X3uODSXZdiRfJ9x2UKYOF3Mxurp1eskBSiq6BVE5DICPe2G2zklzqctUWkoTFa0X
	 WJoiu8XCIbQtXRV2Ff7YXQPQoVlK5L7A2jU6iF35q0RK0PT7NeCLPG6cB7jDOKWmBB
	 4hlIauFSYRLmA3zmcy7mV1gYmNx6KE3fp7dXi1cRW+8mFWuVQCxkAexuhLbRAiXdXk
	 xyDtgj5uYKDdg==
Date: Thu, 18 Apr 2024 08:34:06 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: akpm@linux-foundation.org, arnd@arndb.de, gor@linux.ibm.com,
	agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
	svens@linux.ibm.com, wintera@linux.ibm.com, twinkler@linux.ibm.com,
	linux-s390@vger.kernel.org, netdev@vger.kernel.org,
	llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH 1/3] s390/vmlogrdr: Remove function pointer cast
Message-ID: <20240418153406.GC1435416@dev-arch.thelio-3990X>
References: <20240417-s390-drivers-fix-cast-function-type-v1-0-fd048c9903b0@kernel.org>
 <20240417-s390-drivers-fix-cast-function-type-v1-1-fd048c9903b0@kernel.org>
 <20240418095438.6056-A-hca@linux.ibm.com>
 <20240418102549.6056-B-hca@linux.ibm.com>
 <20240418145121.GA1435416@dev-arch.thelio-3990X>
 <20240418151501.6056-C-hca@linux.ibm.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240418151501.6056-C-hca@linux.ibm.com>

On Thu, Apr 18, 2024 at 05:15:01PM +0200, Heiko Carstens wrote:
> Hi Nathan,
> 
> > > > > -		/*
> > > > > -		 * The release function could be called after the
> > > > > -		 * module has been unloaded. It's _only_ task is to
> > > > > -		 * free the struct. Therefore, we specify kfree()
> > > > > -		 * directly here. (Probably a little bit obfuscating
> > > > > -		 * but legitime ...).
> > > > > -		 */
> > > > 
> > > > Why is the comment not relevant after this change? Or better: why is it not
> > > > valid before this change, which is why the code was introduced a very long
> > > > time ago? Any reference?
> > > > 
> > > > I've seen the warning since quite some time, but didn't change the code
> > > > before sure that this doesn't introduce the bug described in the comment.
> > > 
> > > From only 20 years ago:
> > > 
> > > https://lore.kernel.org/all/20040316170812.GA14971@kroah.com/
> > > 
> > > The particular code (zfcp) was changed, so it doesn't have this code
> > > (or never did?)  anymore, but for the rest this may or may not still
> > > be valid.
> > 
> > I guess relevant may not have been the correct word. Maybe obvious? I
> > can keep the comment but I do not really see what it adds, although
> > reading the above thread, I suppose it was added as justification for
> > calling kfree() as ->release() for a 'struct device'? Kind of seems like
> > that ship has sailed since I see this all over the place as a
> > ->release() function. I do not see how this patch could have a function
> > change beyond that but I may be misreading or misinterpreting your full
> > comment.
> 
> That doesn't answer my question what prevents the release function
> from being called after the module has been unloaded.
> 
> At least back then when the code was added it was a real bug.

I do not know the answer to that question (and I suspect there is
nothing preventing ->release() from being called after module unload),
so I'll just bring back the comment (although I'll need to adjust it
since kfree() is not being used there directly anymore). Andrew, would
you prefer a diff from what's in -mm or a v2?

Cheers,
Nathan
