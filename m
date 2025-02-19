Received: from mail.itouring.de (mail.itouring.de [85.10.202.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224BD1EFFAD
	for <patches@lists.linux.dev>; Wed, 19 Feb 2025 13:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.10.202.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739973328; cv=none; b=Hsm1KG4GoSuOMg8KsLzF92JWroyKeb86AYCs6R4eBf6EHn6GHm31sGNq0dk02ZiFlQnsR7OoBAQmnnigSKGTyqgzEc17YkSWS+fM1FJ8bjZ7wZJVOCI5ryPy+7VY1O3ljtvMlUPwB5+QWvk2T/56tlQ/TwMGtbLW/ITbHGJq3pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739973328; c=relaxed/simple;
	bh=6m/fwI3BhbMMPWW2Vnhjz67waLHR/CPCXFqXcj/PrGM=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=PJ+ox7bQP+id33CltpXLKJ8lXUVdXTHP4jVEBdaC8K+uKgIfHJSYZQjAVOTEChSr2NaB/r3EAT7cld4gNZjoVhoogKkmwbG9N2leCaJzX3M+QBWJ9FXjLyHAfjJa7eRAkQQvKejEm10JuP1EmrFqOy5Hdouf8I/HIzDFj+IQnJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=applied-asynchrony.com; spf=pass smtp.mailfrom=applied-asynchrony.com; arc=none smtp.client-ip=85.10.202.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=applied-asynchrony.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=applied-asynchrony.com
Received: from tux.applied-asynchrony.com (p5ddd71dc.dip0.t-ipconnect.de [93.221.113.220])
	by mail.itouring.de (Postfix) with ESMTPSA id 606FA11DD6F;
	Wed, 19 Feb 2025 14:55:17 +0100 (CET)
Received: from [192.168.100.223] (ragnarok.applied-asynchrony.com [192.168.100.223])
	by tux.applied-asynchrony.com (Postfix) with ESMTP id C2B74601853AD;
	Wed, 19 Feb 2025 14:55:16 +0100 (CET)
Subject: Re: [PATCH 6.12 000/230] 6.12.16-rc1 review
To: Jon Hunter <jonathanh@nvidia.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 linux-tegra@vger.kernel.org, stable@vger.kernel.org
References: <20250219082601.683263930@linuxfoundation.org>
 <b5a72621-a76a-41a1-a415-5ab1cabf0108@rnnvmail201.nvidia.com>
 <9836adde-8d67-48b5-944b-1b9f107434a8@nvidia.com>
 <2025021938-prowling-semisoft-0d2b@gregkh>
 <b686ddb5-aeff-47c2-ba94-b6be9dbafcc1@nvidia.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <2bb3354c-7f77-b07f-55b2-ac3bf5159532@applied-asynchrony.com>
Date: Wed, 19 Feb 2025 14:55:16 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <b686ddb5-aeff-47c2-ba94-b6be9dbafcc1@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit

On 2025-02-19 14:32, Jon Hunter wrote:
> 
> On 19/02/2025 13:20, Greg Kroah-Hartman wrote:
>> On Wed, Feb 19, 2025 at 01:12:41PM +0000, Jon Hunter wrote:
>>> Hi Greg,
>>>
>>> On 19/02/2025 13:10, Jon Hunter wrote:
>>>> On Wed, 19 Feb 2025 09:25:17 +0100, Greg Kroah-Hartman wrote:
>>>>> This is the start of the stable review cycle for the 6.12.16 release.
>>>>> There are 230 patches in this series, all will be posted as a response
>>>>> to this one.  If anyone has any issues with these being applied, please
>>>>> let me know.
>>>>>
>>>>> Responses should be made by Fri, 21 Feb 2025 08:25:11 +0000.
>>>>> Anything received after that time might be too late.
>>>>>
>>>>> The whole patch series can be found in one patch at:
>>>>>     https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.16-rc1.gz
>>>>> or in the git tree and branch at:
>>>>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
>>>>> and the diffstat can be found below.
>>>>>
>>>>> thanks,
>>>>>
>>>>> greg k-h
>>>>
>>>> Failures detected for Tegra ...
>>>>
>>>> Test results for stable-v6.12:
>>>>       10 builds:    10 pass, 0 fail
>>>>       26 boots:    26 pass, 0 fail
>>>>       116 tests:    115 pass, 1 fail
>>>>
>>>> Linux version:    6.12.16-rc1-gcf505a9aecb7
>>>> Boards tested:    tegra124-jetson-tk1, tegra186-p2771-0000,
>>>>                   tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
>>>>                   tegra20-ventana, tegra210-p2371-2180,
>>>>                   tegra210-p3450-0000, tegra30-cardhu-a04
>>>>
>>>> Test failures:    tegra186-p2771-0000: pm-system-suspend.sh
>>>
>>>
>>> The following appear to have crept in again ...
>>>
>>> Juri Lelli <juri.lelli@redhat.com>
>>>      sched/deadline: Check bandwidth overflow earlier for hotplug
>>>
>>> Juri Lelli <juri.lelli@redhat.com>
>>>      sched/deadline: Correctly account for allocated bandwidth during hotplug
>>
>> Yes, but all of them are there this time.  Are you saying none should be
>> there?  Does 6.14-rc work for you with these targets?

> The 1st one definitely shouldn't. That one is still under debug for
> v6.14 [0]. I can try reverting only that one and seeing if it now
> passes with the 2nd.
Most certainly not - you need all three or none:
https://lore.kernel.org/stable/905eb8ab-2635-e030-b671-ab045b55f24c@applied-asynchrony.com/

> [0] https://lore.kernel.org/linux-tegra/ba51a43f-796d-4b79-808a-b8185905638a@nvidia.com/

I was about to link to that.. please try 6.14-rc and see if it works for you.

Alternatively we should remove the whole series again because it's obvious that
_something_ is still wrong somewhere. Maybe something specific to Tegra's topology?

-h
