Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C57C17A938;
	Thu, 18 Apr 2024 20:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713472355; cv=none; b=A3YdQxntT3vvqWk+9Ggc5phAAq82HQLbJGzP9FcJ820yo2/NSD0blPHm7z2G9i06QeZDwf9xu7COYJaz+UT2zKL/1dMxSWlzhxuwMUEs0qzjdtGyyQvEVh81/Wd4Fg29EeefgxYvTSVskQMcjjvvV4GmtC4xZ949r7CvPWWXDLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713472355; c=relaxed/simple;
	bh=i6IHCK7Y8d6u6GANr3/DxbBo5khouz5aFu33Kjmu+/Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MZ5/9c7kQTwWOqf9dpzy/H1o+fvf+YBCO7G/Lo2MkjG0RlXLE8z/grJ/XRPnhtjVKkN5nc8n8/VtMdrGmwmVIp1BsdM6lAGpGnDBFXKc5/CtnBEkH14qa1b6QfNyDUZWpbQH7sEER+koCp1KfqShLuQtDdjKWhAr520BzLSoB/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jcu3C3rj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jcu3C3rj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D53C113CC;
	Thu, 18 Apr 2024 20:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713472355;
	bh=i6IHCK7Y8d6u6GANr3/DxbBo5khouz5aFu33Kjmu+/Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jcu3C3rjY9LFfERyGgNHl8DlmNsLigxeBPR9EZpb9xk970H77vQLgB69t0/BpqWeW
	 O8cIt8I3CwT7N0zZ8v//yXlpOtDc7pI4kFWxtimZVY+hBtkkaV/mPqvInZS/GQyLpY
	 8BSs2MPPEGvuzChKpNQVGsEpBKw05tUtfFi0VhbMe/0uoXozbOdkbglsUyfpPEr0pR
	 WWFqBL6qdz+9nG9KqWYvOFmISQyxIeoykVDYmFH0yEpGR2QaL8LuHv2w6FNo/D9xvD
	 5rsiWROIzH9e00wSyBeEJDbeh8cpfcykJCZF0jiOTLz8poQXEhSEqdD65wwys1HuV7
	 YHBKGkG+P5USw==
Date: Thu, 18 Apr 2024 13:32:32 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: akpm@linux-foundation.org, arnd@arndb.de, gor@linux.ibm.com,
	agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
	svens@linux.ibm.com, wintera@linux.ibm.com, twinkler@linux.ibm.com,
	linux-s390@vger.kernel.org, netdev@vger.kernel.org,
	llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH 1/3] s390/vmlogrdr: Remove function pointer cast
Message-ID: <20240418203232.GA2962980@dev-arch.thelio-3990X>
References: <20240417-s390-drivers-fix-cast-function-type-v1-0-fd048c9903b0@kernel.org>
 <20240417-s390-drivers-fix-cast-function-type-v1-1-fd048c9903b0@kernel.org>
 <20240418095438.6056-A-hca@linux.ibm.com>
 <20240418102549.6056-B-hca@linux.ibm.com>
 <20240418145121.GA1435416@dev-arch.thelio-3990X>
 <20240418151501.6056-C-hca@linux.ibm.com>
 <20240418153406.GC1435416@dev-arch.thelio-3990X>
 <20240418192100.6741-A-hca@linux.ibm.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240418192100.6741-A-hca@linux.ibm.com>

On Thu, Apr 18, 2024 at 09:21:00PM +0200, Heiko Carstens wrote:
> Hi Nathan,
> 
> > > > > > > -		/*
> > > > > > > -		 * The release function could be called after the
> > > > > > > -		 * module has been unloaded. It's _only_ task is to
> > > > > > > -		 * free the struct. Therefore, we specify kfree()
> > > > > > > -		 * directly here. (Probably a little bit obfuscating
> > > > > > > -		 * but legitime ...).
> > > > > > > -		 */
> > > 
> > > That doesn't answer my question what prevents the release function
> > > from being called after the module has been unloaded.
> > > 
> > > At least back then when the code was added it was a real bug.
> > 
> > I do not know the answer to that question (and I suspect there is
> > nothing preventing ->release() from being called after module unload),
> > so I'll just bring back the comment (although I'll need to adjust it
> > since kfree() is not being used there directly anymore). Andrew, would
> > you prefer a diff from what's in -mm or a v2?
> 
> I guess there is some confusion here :) My request was not to keep the

Heh, yes, my apologies for being rather dense, I was not interpreting
the comment or the thread you linked properly... :(

> comment. I'm much rather afraid that the comment is still valid; and if
> that is the case then your patch series adds three bugs, exactly what is
> described in the comment.
> 
> Right now the release function is kfree which is always within the kernel
> image, and therefore always a valid branch target. If however the code is
> changed to what you propose, then the release function would be inside of
> the module, which potentially does not exist anymore when the release
> function is called, since the module was unloaded.
> So the branch target would be invalid.

That is super subtle :/ I can understand what the comment is warning
about with that extra context. I see Arnd's suggestion which may fix
this problem and get rid of the warning but if there are other ideas, I
am all ears. I guess we could just disable -Wcast-function-type-strict
for this code since s390 does not support kCFI right now but since it
could, it seems better to resolve it properly.

Thanks a lot for the quick review and catching my mistake, cheers!
Nathan
