Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DBD9274FE3;
	Fri, 16 Jan 2026 11:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768561730; cv=none; b=uCPJqFHqpZVoQQfhLvqRpPzc3fnkBpuVd18J+hvqD27KqkZHMNAqfyQqd3gou7m4TbUkeKesm/KO8uLTTbTo9gbNJPGKtaq7sbXC6J3+Q0ngqtfTgJ3GftfR/nIMMSlbs/EZUfmY1wx3xeh6A8Yj4yS/adZVHyCDpG/rDxDiiD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768561730; c=relaxed/simple;
	bh=8sJpBDOr/csL9A2Qo90+s/brtpPK4jqFu9kWPTq2H8o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O9h25O7DRSl14m+FQeOaXxB19HY7bt+LkYXh9n2MgslSspzge50GZqFc2lExeza7b7RiEp6ndwQxI5PI2ndzhblqABFKmwTlRuiv2w65GHHa57u+8ZDPDZiuuHzZg9dDUO87sLUCXFsAUrh+3VGFXuXITTx+ErYk/rPcCL+9jec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qfFp4YKl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qfFp4YKl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A27DC116C6;
	Fri, 16 Jan 2026 11:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768561728;
	bh=8sJpBDOr/csL9A2Qo90+s/brtpPK4jqFu9kWPTq2H8o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qfFp4YKlFm1HFNFeKo+xEHEIfGnMM3BPtrSOjkbeVbjWmgaFtw9z1XcCi4ieiVsR2
	 JhcgXCTL5+tYmZdveSdCMhYk4VRoV8g4966Z3wZw2b2J5gCWS6J8wUef1oalWdW/cV
	 r/YZOljE2YFKYAYlc4pREJdtE3hPiH8B4cnjkhTc=
Date: Fri, 16 Jan 2026 12:08:46 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org, sr@sladewatkins.com,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.15 000/554] 5.15.198-rc1 review
Message-ID: <2026011633-straw-wow-a35d@gregkh>
References: <20260115164246.225995385@linuxfoundation.org>
 <18a459de-dd95-47cf-bf53-d7e743810e54@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <18a459de-dd95-47cf-bf53-d7e743810e54@nvidia.com>

On Fri, Jan 16, 2026 at 09:45:18AM +0000, Jon Hunter wrote:
> Hi Greg,
> 
> On 15/01/2026 16:41, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.198 release.
> > There are 554 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 17 Jan 2026 16:41:26 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.198-rc1.gz
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
> > 
> > Wentao Liang <vulab@iscas.ac.cn>
> >      pmdomain: imx: Fix reference count leak in imx_gpc_probe()
> 
> 
> I am seeing a build failure for ARM with multi_v7_defconfig ...
> 
> 
>  drivers/soc/imx/gpc.c: In function ‘imx_gpc_probe’:
>  drivers/soc/imx/gpc.c:409:17: error: cleanup argument not a function
>    409 |                 = of_get_child_by_name(pdev->dev.of_node, "pgc");
>        |                 ^
> 
> Reverting the above commit resolves the issue.

Now fixed up, thanks.  I'll push out a new -rc soon.

greg k-h
