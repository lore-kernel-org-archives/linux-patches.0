Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C572A1D3;
	Sat, 25 May 2024 14:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716646809; cv=none; b=sJo7TtRsJqkfui0v/DjA/Amug5vnIZdI8I3dKzeYNmu92nl+9pIDGwQM21tR+hhx54+tOYicwXeVEl9px0Ua10qBiO3FlSp6I/2+siwJ3nRgzPlg7Nm7eeJoIZwel/7rMNINuB1auvDczZ3U6Cisg/xTpNrXMeMXyCA8Qf8yEoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716646809; c=relaxed/simple;
	bh=LELYlH2TsI85qd++YmKvIhQ9XuKF1OIKFsdx17FkjiI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=phoDsoAliUYOVZ7Blec92rQVeOqIPu8VZCVFldmQpm5s9RShprg8xHSOiCoChuf1PGT5fL2H4o92lWjBoj8zGevGbgq8df6fhpx6hsEwEN1O66P/vs8PVbiwingTpW/ob6vKlLgKoU7hVIEgj9rK2XrCJK2cEinJSs1vdz1Ajgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2kh15BzI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2kh15BzI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B84B7C2BD11;
	Sat, 25 May 2024 14:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716646808;
	bh=LELYlH2TsI85qd++YmKvIhQ9XuKF1OIKFsdx17FkjiI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=2kh15BzIPBuLlRPBXaHB4Dy1/gmVoFQXxljXDgarBPk0lKUElf75IWsdAOOodu69m
	 qX2BNqodLPpQPN5gaKo/H6lZIWHvXkn/G5ur7kq1a8PXqtbNpH9ZFOp1kCcVlX8YS2
	 vJBcqs0o1KvfMmSHGOkBlqz3ZxMPWU+xTtDX2/uo=
Date: Sat, 25 May 2024 16:20:05 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.15 00/23] 5.15.160-rc1 review
Message-ID: <2024052541-likeness-banjo-e147@gregkh>
References: <20240523130327.956341021@linuxfoundation.org>
 <8e60522f-22db-4308-bb7d-3c71a0c7d447@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e60522f-22db-4308-bb7d-3c71a0c7d447@nvidia.com>

On Sat, May 25, 2024 at 12:13:28AM +0100, Jon Hunter wrote:
> Hi Greg,
> 
> On 23/05/2024 14:12, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.160 release.
> > There are 23 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.160-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > -------------
> > Pseudo-Shortlog of commits:
> 
> ...
> 
> > NeilBrown <neilb@suse.de>
> >      nfsd: don't allow nfsd threads to be signalled.
> 
> 
> I am seeing a suspend regression on a couple boards and bisect is pointing
> to the above commit. Reverting this commit does fix the issue.

Ugh, that fixes the report from others.  Can you cc: everyone on that
and figure out what is going on, as this keeps going back and forth...

thanks,

greg k-h
