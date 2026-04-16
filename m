Received: from james.steelbluetech.co.uk (james.steelbluetech.co.uk [78.40.151.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0133348898
	for <patches@lists.linux.dev>; Thu, 16 Apr 2026 18:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.40.151.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776365912; cv=none; b=btezC4ENee8GguKzuVWdLYeW+HKII6yBqvBDOFYxwABLIvoMXzkqmdSQjrA5XNtc/MODzc6TXIFia0/iHlyyHhCQYq8mv9tG/S3YBczQiIdOcz+CQPy9gn/WdLDp68rYsp/39lfS41kBjrOSzH4TWlojqYcfvwY7EvGRezoQEGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776365912; c=relaxed/simple;
	bh=pKAfoM3iQd4d3Pvz0ihfInuTbvgYkVlBfNrHPtW1rew=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nDd2eNBt5qMv9QNFWJ51PXAtDdC4PBvqAw+J9WJGqc83zruNPA8W33Z9qQ+V/LwYH+BsPnlSTnWZ0lHKeUhc12sfJIuzpxu3t3G/3l+NQ9wJSRdabnpHePdOw/CO26IUogjOKrDvFecYbSDzq78Q8s0atNVeq23f/FJlmGUxVDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ehuk.net; spf=pass smtp.mailfrom=ehuk.net; dkim=pass (2048-bit key) header.d=ehuk.net header.i=@ehuk.net header.b=Ss9IB/nK; arc=none smtp.client-ip=78.40.151.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ehuk.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ehuk.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ehuk.net header.i=@ehuk.net header.b="Ss9IB/nK"
Received: from [10.0.5.25] (tv.ehuk.net [10.0.5.25])
	by james.steelbluetech.co.uk (Postfix) with ESMTP id 7DF9BBFC14;
	Thu, 16 Apr 2026 19:55:19 +0100 (BST)
DKIM-Filter: OpenDKIM Filter v2.10.3 james.steelbluetech.co.uk 7DF9BBFC14
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ehuk.net; s=default;
	t=1776365719; bh=je7F5uCIXmm6y2OPbC+xbMc7O/fNY4uLAiFmFqlSZTA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Ss9IB/nKtnW/SoTDDVlZhLomH6koCN7bh+eAq/9DZcqw0Yn4119fgDvgts7zIXkxi
	 n473TsOXdnczpgUQ8erPOqwA4eMLMRc0ebhshrgYUe0B/+eyTVraJRNBLswQUiJ1BD
	 evViADwQtxL1o8caL20v3iTiWqTolvcM9a2yPVk3PSL2QLS/fHusoKehtvg/4NG/PE
	 tFkhWqrg0Rx3juE6q/C1ByYwJLcd+vYCqfnK/BiBCNbOjLVb2zPg70SMCgorCxBPy3
	 it/fFLp6Vtjsf8e6Zg45ovcaVNs8MWHPUOmgopwsRKEZX2Y9JtAtMAvGLjq/vCWZzB
	 DXNKETZ4EDIuw==
Message-ID: <172f1405-0094-4957-9758-e700ec76516f@ehuk.net>
Date: Thu, 16 Apr 2026 19:55:19 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/70] 6.12.82-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260413155728.181580293@linuxfoundation.org>
Content-Language: en-GB
From: Eddie Chapman <eddie@ehuk.net>
In-Reply-To: <20260413155728.181580293@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang

On 13/04/2026 16:59, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.82 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.82-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
I just wanted to point out that the revert of "PCI: Enable ACS after 
configuring IOMMU for OF platforms" is missing here despite being queued 
in the 6.1 & 6.6 rcs (it is meant to be reverted from 6.12 as well). I 
noticed when updating to 6.12.82-rc1 today as I was bit by the 
regression (all my IOMMU groups messed up).

The revert for 6.12 is in fact here:
https://lore.kernel.org/stable/20260320172335.29778-1-john@kernel.doghat.io/

but unfortunately easily missed as shown by the confusion here (same 
thread):
https://lore.kernel.org/stable/99426bd8-32e5-4246-9d3b-772e136bc078@leemhuis.info/

subsequently clarified by the patch author here (also same thread):
https://lore.kernel.org/stable/5hng5r6q525scbclramuv2h2hphljbcsscwohvrs7teuedgfvl@ncr7tqhr4l4z/

Other than that 6.12.82-rc1 boots and runs fine for me on the one AMD 
Ryzen system I've tried it on.

Thanks,
Eddie
