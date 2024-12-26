Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C0684A2F
	for <patches@lists.linux.dev>; Thu, 26 Dec 2024 10:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735207699; cv=pass; b=gIiOgdaRe2r4qfZv/cUYhtrkIpUodLXEmLEszhhtqOHJqbzrjjmZJ3IKEsI337DELG9SYuw4o1Nd4vC/3W8wtmwtZGHx0+kS5GJDlwDdMGpgu47+zHtmF6ihVSIOvskWdtjWZ44YiYGu97RBKO4O6B6ahm7WQsFjk43E+DI7cU8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735207699; c=relaxed/simple;
	bh=PWzU/W2Hi91NGUWFiAzTS9VoD5SXnsIFtIVEV/Fu7tI=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ij8f6KpDBqLl5di64lPGKcgnZCXo2oQH76gQ5bRTRxnHmH9Tir6X/BnXflO/mCicaRYPdtgZEzIrEL/gGfK3mhe/jzco2lI1Go85v/CFxWvYODXTKjizzfPOYsAUsA98sVZwuPbOpjFaO1ujgN6EzgztHeukcQfeIGjU5EV+hgU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b=bUyeY8Qk; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b="bUyeY8Qk"
ARC-Seal: i=1; a=rsa-sha256; t=1735207683; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=VlXPqmm380EUd2sJZp6cD2iPfrGfc8AFdKWKi57FFTkW+db9546DkqqpKSZpwjjUE8m7u2VgNVwtlazrwlcmh2ysToKFnmoTk7GS4G8QWEdYVkUEDbJ1zmlvPps0Dge2O3AWA8ieZBCeUpTtYSVaOlVYTtAn9iyqm1QHCDD3Z6w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1735207683; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=zH6WzViKJYCMEuf+VYNI13WOkySlAYlA7jKJEkgzWmA=; 
	b=VEYX4Hjt8FQGeo5odwc2J/tQyxWJhI1wpJUCEEBRAzPvF7EHzWYU48X4y2QCLOctztYnlWaXHMX3BpoWSN8jhbi3db+qLCbRnQhoO2kCjZeQZHxQIMu0MFv3S4PstascG5pujJDBt+3aECjWw/rN3Nxjx9inD4mMLYvNH5/M2zo=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=Usama.Anjum@collabora.com;
	dmarc=pass header.from=<Usama.Anjum@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1735207683;
	s=zohomail; d=collabora.com; i=Usama.Anjum@collabora.com;
	h=Message-ID:Date:Date:MIME-Version:Cc:Cc:Subject:Subject:To:To:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=zH6WzViKJYCMEuf+VYNI13WOkySlAYlA7jKJEkgzWmA=;
	b=bUyeY8QkydFZgu/RQwN1OLYA6vbeRVDEgn3POsTsXG9843F7lSTfvAxe0cWuV+tu
	/ELVsZOMY0Pi/pyQxI4DJb+/ZRQUVTOl8GOb9JCXtihvAVdkzjJidtDJw5Ui663B7H1
	CqmADQZRUHPUJMyO+j93FtiHGTOSRWCZ9sNhOiTc=
Received: by mx.zohomail.com with SMTPS id 1735207679968710.0329553934757;
	Thu, 26 Dec 2024 02:07:59 -0800 (PST)
Message-ID: <1416c0bd-99d1-4f12-8c4e-cd23b887c307@collabora.com>
Date: Thu, 26 Dec 2024 15:08:09 +0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: Usama.Anjum@collabora.com, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.12 000/160] 6.12.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
References: <20241223155408.598780301@linuxfoundation.org>
Content-Language: en-US
From: Muhammad Usama Anjum <Usama.Anjum@collabora.com>
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External

On 12/23/24 8:56 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.7 release.
> There are 160 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 27 Dec 2024 15:53:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
OVERVIEW

        Builds: 42 passed, 0 failed

    Boot tests: 571 passed, 0 failed

    CI systems: broonie, maestro

REVISION

    Commit
        name: v6.12.6-161-gc157915828d8
        hash: c157915828d8f4b0a4f2e60fffed2459c27f3003
    Checked out from
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y


BUILDS

    No build failures found

BOOT TESTS

   No boot failures found

See complete and up-to-date report at:

    https://kcidb.kernelci.org/d/revision/revision?orgId=1&var-git_commit_hash=c157915828d8f4b0a4f2e60fffed2459c27f3003&var-patchset_hash=


Tested-by: kernelci.org bot <bot@kernelci.org>

Thanks,
KernelCI team
