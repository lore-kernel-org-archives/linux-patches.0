Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1001FCFF1;
	Wed, 14 May 2025 20:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747253208; cv=none; b=LD7XJt6qVQO+riY4F1ymio7x8cYFKGANw5TZaQgsDF8fOi36meNF9amNGEGYu7fKNqahhGV+ZcqsD4hejp1hhz4bJGRCu/p5q2aEoctDELKZ/mPUe+g7j0K65SqtKpRokG79XXiWoEdYv9q085nNF+208s+Y5qUHgNXXcTghShc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747253208; c=relaxed/simple;
	bh=Q3ENDXfchZV+NN1RzPq+ghze710jH6K369GY38RYmf0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BnCemEx90itdhKx+kRQK+7/LAySLP3+UMv7oD95wDkpX+9MbKWJY3mcr9cyBCRKl1dug2xOnN6OfRrDBEX+3AhwTzTTNZQc5FOw31T1DYPkhnrrEs0GJksS+4jHCyN3GmVUeaKggxQ+4cIqGTAKtBkTWWF2wM5/5YncC61IZETs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MLJ6Wf1H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MLJ6Wf1H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E28DC4CEE3;
	Wed, 14 May 2025 20:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747253208;
	bh=Q3ENDXfchZV+NN1RzPq+ghze710jH6K369GY38RYmf0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MLJ6Wf1H8VjNMyJxXlxS/E0F1S/vN+m1+QbtIOfDo0EUjlRp8G4+v3K8GBqKDHhyN
	 W0gHHkbfNAR0tAb/lNQZRHFrqHeyXN+84MmGVi5K310HygmPmAW8+jwiQBuSxDTJUS
	 vO2z9KdeGtxK4AQDg7QGU+K6Gy6DZgdYsPC+1SP0=
Date: Wed, 14 May 2025 22:05:00 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	Darren Kenny <darren.kenny@oracle.com>
Subject: Re: [PATCH 6.6 000/113] 6.6.91-rc2 review
Message-ID: <2025051440-sturdily-dragging-3843@gregkh>
References: <20250514125617.240903002@linuxfoundation.org>
 <861004b4-e036-4306-b129-252b9cb983c7@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <861004b4-e036-4306-b129-252b9cb983c7@oracle.com>

On Thu, May 15, 2025 at 12:29:40AM +0530, Harshit Mogalapalli wrote:
> Hi Greg,
> On 14/05/25 18:34, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.6.91 release.
> > There are 113 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 16 May 2025 12:55:38 +0000.
> > Anything received after that time might be too late.
> 
> ld: vmlinux.o: in function `patch_retpoline':
> alternative.c:(.text+0x3b6f1): undefined reference to `module_alloc'
> make[2]: *** [scripts/Makefile.vmlinux:37: vmlinux] Error 1
> 
> We see this build error in 6.6.91-rc2 tag.

What is odd about your .config?  Have a link to it?  I can't duplicate
it here on my builds.

thanks,

greg k-h
