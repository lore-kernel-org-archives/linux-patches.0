Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525E04A2E3F
	for <patches@lists.linux.dev>; Fri, 21 Aug 2026 14:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787321011; cv=none; b=Tw+2O0ycM0AHsy/QelIREovE5ot9I9jlMMe3PcWrKAIwEsC71B5FTeK29yZhtkwyJmxbSkKP3oOuk+YtzC0kdEVL2TyOrkonJt/BYYTTR/wX0xP7EQ0A26I8yvAmli3bzY0fosYyHi7ZQf6L69fmlhdZcE+40F5WrmLmH1Hkkvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787321011; c=relaxed/simple;
	bh=ETcc3jXcy8ESxA96o6WWcnNXSAvOQVkbw3eTw+IdiQw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G6NYel5qW9fI12sEffznwdeXNb1Zvx84lMrbhe5B4kC2ErRaoC17bM7nG6esFlG5llqziR0Js40pUEgl5R3G5zYHnELPYgVF0TnjO/74shqwbIQ2Cp01CfRdzVfpXPHBbbuz2lLoYgGVQGoaxF6j4k0oL1OEqZEhhuZns/8NBSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=4vS8lp/D; arc=none smtp.client-ip=35.89.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="4vS8lp/D"
Received: from eig-obgw-6003b.ext.cloudfilter.net ([10.0.30.175])
	by cmsmtp with ESMTPS
	id xPDIwyswRaC0UxPq8wuDbZ; Fri, 21 Aug 2026 14:03:24 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id xPq7wqK2tqLljxPq7wpoQD; Fri, 21 Aug 2026 14:03:23 +0000
X-Authority-Analysis: v=2.4 cv=ZLHXmW7b c=1 sm=1 tr=0 ts=6a885aab
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=0jzcPXITRvVNNchQp9EA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=1Bz95jDO8pF5b/2sa0+RGv4K1LHBgYVFE3dxVjSbTdw=; b=4vS8lp/DoW4LHdE54tovkgD1ZM
	o3tNE1D4bctuiIa4WO4hG9O2gxFOxBbXLjzZ2NexpEQBJL6wfyzFbQxa9x6Ze17atnChj18tXHHhU
	VlYXXt6ACqSqp0NofHlGryQbFMTF1uwJCI8PXPH1YoPFLSGwKNKerA3+aO/Tnu7pE9om7UdoBdkXn
	4Lm5fAGcn6cJ5v0IreAVQ+aHCAsEOv7w/NlyxtPqeTU8btO2HkGYHGD8yArZcGTNs/VwocnUGPgH3
	xj1c7ocL52x+Y0/2BDcMtvsU0Q/BKS2DhbYGW5IAR4D+b7ir+cIOHCgVeFP2Z4ah5qnRPx9i9kxZF
	NDiAcb0g==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:53828 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.5)
	(envelope-from <re@w6rz.net>)
	id 1wxPq6-000000021rY-2Ukc;
	Fri, 21 Aug 2026 08:03:22 -0600
Message-ID: <fd99f306-c062-4d89-aaac-3dd142cd10b0@w6rz.net>
Date: Fri, 21 Aug 2026 07:03:20 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/166] 6.6.153-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260820145211.194104353@linuxfoundation.org>
 <ef63dced-7dc3-4436-823d-8a912f2d3b7a@w6rz.net>
 <2026082132-cape-customary-fc07@gregkh>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <2026082132-cape-customary-fc07@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.162.206.103
X-Source-L: No
X-Exim-ID: 1wxPq6-000000021rY-2Ukc
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:53828
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfKE+gQshhP+C+F985KDARV07Hj6Rs6qnZGhym/9bKDg00kZt7FUOUxsu9V8jWQ17a2vLy6uIL4W1inHFunn4Z9lO55wNkF8nlQAIlmI+5qGlv7h91ajw
 6H8q9B5ZPwsjh7DCVHsZ04A8I29jtvUq1jT+VR/h71cfIwVe/jcvcvyxqATtZZfU+gkb9eICRHavFA==

On 8/21/26 06:59, Greg Kroah-Hartman wrote:
> On Thu, Aug 20, 2026 at 10:34:59PM -0700, Ron Economos wrote:
>> On 8/20/26 07:54, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 6.6.153 release.
>>> There are 166 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Sat, 22 Aug 2026 14:51:11 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.153-rc1.gz
>>> or in the git tree and branch at:
>>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>>
>>>
>> The build fails with:
>>
>> drivers/net/ethernet/intel/ice/ice_switch.c: In function 'ice_aq_alloc_free_vsi_list':
>> drivers/net/ethernet/intel/ice/ice_switch.c:1816:23: error: implicit
>> declaration of function '__struct_size'; did you mean 'struct_size'?
>> [-Wimplicit-function-declaration]
>>   1816 |         u16 buf_len = __struct_size(sw_buf);
>>        |                       ^~~~~~~~~~~~~
>>        |                       struct_size
>>
>> This can be fixed by reverting commits:
>>
>> "overflow: Change DEFINE_FLEX to take __counted_by member" a5c50a3af39c74eef1a15c39924b0e1f4c6a43a6
>>
>> "ice: make use of DEFINE_FLEX() in ice_switch.c" 858a287aeaf8a690fd3c769e0ee2247f40e44b62
>>
>> Unfortunately, the Bluetooth commits have to be reverted also (because they
>> depend on "overflow: Change DEFINE_FLEX to take __counted_by member").
>>
>> "Bluetooth: hci_sync: Fix advertising data UAFs" 50d4431fab38c15c9ef405b6c7e13c0491f29928
>>
>> "Bluetooth: eir: Fix possible crashes on eir_create_adv_data" c4fedbbb5b925228321a359b8a3949b207cc0a62
>>
>> "Bluetooth: hci_core: Fix not handling hdev->le_num_of_adv_sets=1" cf931b0c0a6a5b8b70da339101c0df17cc068488
>>
>> "Bluetooth: hci_conn, hci_sync: Use __counted_by() to avoid -Wfamnae warnings" 88dd9093e398c68467d8e9c8b7fb630aab05be05
>>
>>
> This is odd, because this builds here for me just fine.  Let me dig...

You have to have CONFIG_ICE enabled. I have a fixup patch that avoids all these reverts. I'll send it if we agree there's an issue.

