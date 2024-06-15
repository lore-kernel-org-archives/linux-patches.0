Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4016C31A89;
	Sat, 15 Jun 2024 11:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718449768; cv=none; b=PiP0uuLXhqvFuDCWUgPVG4+nrQA/shzBPo3KVqj+Dp5+jWW+y6aaG2Bt5YpSanhrX5QAupThncqjpgugDotb0WkjZt9axbiZ9htLTA8aPLNkltpU4BZ7JAAlB+sySO3COOkToTqaE7IggjzfJe1ygyqz/srUDSaHhA4sKDxruXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718449768; c=relaxed/simple;
	bh=D+vQsSCO/rewqAQdoV1Nl4D+kHhcqq0cfadGqVrhblU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d+P62g/NMepmDVRe1I7bOT/kDa/D/2+kDcxcd/4NOpbzhbHYsZgSsyZLfjYw2dqq2al86+zhDJXly7yTCuJrfE1Bkh01uRGHjR6efZgqTqldyftxuILUu7x9DBcyDDpohMz0vYpTni27ySI7/Y7uC/1B+/KeGDco+2d5MG1OVko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gB6jJ/5n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gB6jJ/5n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37C67C116B1;
	Sat, 15 Jun 2024 11:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718449767;
	bh=D+vQsSCO/rewqAQdoV1Nl4D+kHhcqq0cfadGqVrhblU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gB6jJ/5nReLiROhE1NW9OMX+nmz9qMw96PGgdjGWwtbcTGuPcACOnLWxDUNgQuDEF
	 r2NiKt0m1n/D3sVSSF+hIEQThbXBtufuaX4ThXWeexgLmbeBJ6NDnK8Exmg8pqGCzz
	 EqFKJRmVfjVnQkIscaRAqfbch9RnP6OEWR2cKIBM=
Date: Sat, 15 Jun 2024 13:09:25 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 00/85] 6.1.94-rc1 review
Message-ID: <2024061514-veneering-facecloth-8508@gregkh>
References: <20240613113214.134806994@linuxfoundation.org>
 <ddc06737-e271-400d-bf9e-c78537e0e8db@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ddc06737-e271-400d-bf9e-c78537e0e8db@roeck-us.net>

On Thu, Jun 13, 2024 at 10:43:37AM -0700, Guenter Roeck wrote:
> On 6/13/24 04:34, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.94 release.
> > There are 85 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 15 Jun 2024 11:31:50 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Introduced in 6.1.93:
> 
> Building csky:allmodconfig ... failed
> Building m68k:allmodconfig ... failed
> Building xtensa:allmodconfig ... failed
> --------------
> Error log:
> In file included from kernel/sched/build_utility.c:105:
> kernel/sched/isolation.c: In function 'housekeeping_setup':
> kernel/sched/isolation.c:134:53: error: 'setup_max_cpus' undeclared
> 
> The same problem also affects v6.6.y, starting with v6.6.33.
> 
> Commit 3c2f8859ae1c ("smp: Provide 'setup_max_cpus' definition on UP too")
> fixes the (build) problem in both branches.

Now queued up for 6.6.y and 6.1.y, thanks.

greg k-h
