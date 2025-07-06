Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96172E371A;
	Sun,  6 Jul 2025 06:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751784689; cv=none; b=OQP+wweDi11eDlzVQ22lJVU61l7xd7fpFi7VuR4zjxHsBTvGIyuNH7PhSOQJUr1EOQkmQMg7oUwXU5L4m+2TJh+458oJSk1m2b1esLH700lWQhFPopF12Aw5rcLZi241rO/qIZgO88IzI+XgSL2FaaIjQ9K87JvFJt9FY3mZSr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751784689; c=relaxed/simple;
	bh=upUy0d1WA/Xc8zitClR7qwrNXfZW7l3tBw2d5pzSSxw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d+NHxyi1ZioV4T/VDB78yjDZeWXZgaTo0sWMkG+Ilrrs0paxTQQr8H3kIk6oo45bfTlPSfiLPNQTmlHUvYcgkxErbTfSTxR/GgQWZBGt+XnGqPAVy2S1NJB80r/ab0pqhlnEaR4pwSAe/sx78CjTvZsu8tPWIqkL/7JlMunzGus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VoYOParV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VoYOParV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0067FC4CEED;
	Sun,  6 Jul 2025 06:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751784688;
	bh=upUy0d1WA/Xc8zitClR7qwrNXfZW7l3tBw2d5pzSSxw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VoYOParVbOR3lvbXd5lzZCyK2Z1UK8NEkzlLbHP7FBZMhctmEnNKXso0uVf2O65JN
	 qAmAQGubjnoGb6DP8nN70K6odJukibYg80oziDbf/ypc/8NJf502JfoWHyNZtUUuL9
	 bGhu7bqej+EEWYiJgBSX3pXLu7t9KHyCgNpR4slM=
Date: Sun, 6 Jul 2025 08:51:25 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pascal Ernster <git@hardfalcon.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.12 000/218] 6.12.36-rc1 review
Message-ID: <2025070618-outbreak-badge-bc22@gregkh>
References: <20250703143955.956569535@linuxfoundation.org>
 <3ca03800-3d4e-41ca-897d-a0d05d6499ba@hardfalcon.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ca03800-3d4e-41ca-897d-a0d05d6499ba@hardfalcon.net>

On Sat, Jul 05, 2025 at 03:50:32PM +0200, Pascal Ernster wrote:
> [2025-07-03 16:39] Greg Kroah-Hartman:
> > This is the start of the stable review cycle for the 6.12.36 release.
> > There are 218 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 05 Jul 2025 14:39:10 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.36-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> 
> 
> Hi Greg,
> 
> 
> there seems to be a divergence between 6.12.36-rc1 and the current state of queue/6.12 or stable-queue/queue-6.12 (five patches dropped and two modified), but there doesn't seem to be an rc2 - is this intentional?
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/diff/?id2=08de5e8741606608ca5489679ec1604bb7f3d777&id=4c3f7f0935ba0c1ca54be4e82cc8f27595ab8e61
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/diff/queue-6.12?id=c0bc2de2a5416da11ffadb0d10da975d1bdb1ada&id2=e1bd69ff09807d5bf80f17f3279240cb223145a6
> 

Yes, intentional, I only do new -rcs if people are reporting build/run
errors on -rcs, but we drop patches that people ask us to drop or fix in
the queue without doing new -rc releases as that's not really needed.

> In any case, I've applied all patches from the current version of stable-queue/queue-6.12 (commit id c0bc2de2a5416da11ffadb0d10da975d1bdb1ada) applied on top of a 6.12.35 kernel, compiled the result with GCC 15.1.0 as part of OpenWRT images for various platforms, and I've booted and tested those images on the following platforms without noticing any issues:
> 
> - x86_64: Intel Haswell VM
> - MIPS 4KEc V7.0: Netgear GS108T v3 (SoC: Realtek RTL8380M)
> - MIPS 4KEc V7.0: Netgear GS310TP v1 (SoC: Realtek RTL8380M)
> - MIPS 74Kc V5.0: TP-Link Archer C7 v4 (SoC: Qualcomm QCA956X)
> 
> Not sure it that qualifies for a "Tested-by" though because of the divergence to 6.12.36-rc1.

A tested-by would be great if you want to provide it, thanks!

greg k-h
