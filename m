Received: from james.steelbluetech.co.uk (james.steelbluetech.co.uk [78.40.151.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C1EA33F8D4
	for <patches@lists.linux.dev>; Fri, 17 Apr 2026 15:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.40.151.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776440091; cv=none; b=koCfYXhWZf691MHmWqL2ZWEh7lI+T0fCjkxjEQRrSV4PFyeSxKIarG6mcrKgJzSZw38FutHb0gWTjpzmcGOBrDJK+ACNMb6OMnY7aifXtSuQyZmh6sjaI9l/v9f5EFGwN6+BkMnZp3gih5OoUSNl7+Zd91DMkeyet605J+L3A0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776440091; c=relaxed/simple;
	bh=UvEnnGVnAl6uzFHCVhtpZ0w7r047UYq5JM45UNESAM0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BcMsiHbhaW1XEiYRPrsKtEvA4MajK14fxnpoyXi0nosELKaEJlKntPAKlB9yjwODm4P1drxE8u7a2DNe/AQAVOttTtYrA+/bFS6vRaHkWLU/vC0eENO4vh4qLeVfuc4byMmFd1Uq9nWjHo0/Efah23CrUGTziGRTukv6uFIWXkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ehuk.net; spf=pass smtp.mailfrom=ehuk.net; dkim=pass (2048-bit key) header.d=ehuk.net header.i=@ehuk.net header.b=H5DN4j02; arc=none smtp.client-ip=78.40.151.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ehuk.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ehuk.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ehuk.net header.i=@ehuk.net header.b="H5DN4j02"
Received: from [10.0.5.25] (tv.ehuk.net [10.0.5.25])
	by james.steelbluetech.co.uk (Postfix) with ESMTP id 0EEB2BFC14;
	Fri, 17 Apr 2026 16:34:46 +0100 (BST)
DKIM-Filter: OpenDKIM Filter v2.10.3 james.steelbluetech.co.uk 0EEB2BFC14
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ehuk.net; s=default;
	t=1776440086; bh=W1yDXO8OMwNHOA1eKZOCKDrQbH41rIyMbiA1zfcPux4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=H5DN4j02PS36Jp56c+2A/LIaUCjMqTrttcgDAuW8cn346tHwkL8CwO66m/FaAdlQY
	 GKuCIOqGfnCQ0X5+dfsp0r+RjP9nk1Uq2ZXEOcrE1IUK/IJ9VUJVGbRTYTxELpFKpe
	 JfaUKNg5behgL8NTPuAp7/NKtp0A5FtxF7umCbBuCOklIa2sGNelymjGv7buBbsdjt
	 SpOg2gNk8zlamWKFPLIHm1YtWm90XW2/VMHKbUqGIKpKWNuGUI2mxySf1cYFSP07hu
	 ymmlObvtq8sQv8M4HRHo7t+eT/5N7CQ0GGxtQWjVjznb9CoIxkUyg2fxZ1U1d+/O4Z
	 4srBlNWXRZgsA==
Message-ID: <2b619b76-2b73-4787-84c5-78f52dc316a2@ehuk.net>
Date: Fri, 17 Apr 2026 16:34:45 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/70] 6.12.82-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260413155728.181580293@linuxfoundation.org>
 <172f1405-0094-4957-9758-e700ec76516f@ehuk.net>
 <2026041742-armrest-clicker-84fd@gregkh>
Content-Language: en-GB
From: Eddie Chapman <eddie@ehuk.net>
In-Reply-To: <2026041742-armrest-clicker-84fd@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang

On 17/04/2026 07:25, Greg Kroah-Hartman wrote:
> On Thu, Apr 16, 2026 at 07:55:19PM +0100, Eddie Chapman wrote:
>> On 13/04/2026 16:59, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 6.12.82 release.
>>> There are 70 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.82-rc1.gz
>>> or in the git tree and branch at:
>>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>> I just wanted to point out that the revert of "PCI: Enable ACS after
>> configuring IOMMU for OF platforms" is missing here despite being queued in
>> the 6.1 & 6.6 rcs (it is meant to be reverted from 6.12 as well). I noticed
>> when updating to 6.12.82-rc1 today as I was bit by the regression (all my
>> IOMMU groups messed up).
>>
>> The revert for 6.12 is in fact here:
>> https://lore.kernel.org/stable/20260320172335.29778-1-john@kernel.doghat.io/
>>
>> but unfortunately easily missed as shown by the confusion here (same
>> thread):
>> https://lore.kernel.org/stable/99426bd8-32e5-4246-9d3b-772e136bc078@leemhuis.info/
>>
>> subsequently clarified by the patch author here (also same thread):
>> https://lore.kernel.org/stable/5hng5r6q525scbclramuv2h2hphljbcsscwohvrs7teuedgfvl@ncr7tqhr4l4z/
>>
>> Other than that 6.12.82-rc1 boots and runs fine for me on the one AMD Ryzen
>> system I've tried it on.
> 
> That was not obvious at all, please don't make us dig through email
> threads to know what to and not to apply, it doesn't scale when dealing
> with the email volume we get.
> 
> Can someone resend that patch, properly marked fro 6.12, so we know to
> apply it there?
> 
> thanks,
> 
> greg k-h
> 

Adding Manivannan Sadhasivam who is the author of the revert that is in 
the 5.10, 5.15, 6.1 and 6.6 queues right now.

Manivannan, not sure if you are able to provide an updated patch for 
6.12 where the revert is missing right now?

FWIW I applied the patch at
https://lore.kernel.org/stable/20260320172335.29778-1-john@kernel.doghat.io/
on top of 6.12.82-rc1 today and booted on an AMD system to test. It has 
context issues but still applies fine, and I can confirm that my IOMMU 
groups are no longer messed up. As a result have been able to pass 
through 2 separate PCI cards to 2 separate VMs which I am unable to do 
without the revert.
