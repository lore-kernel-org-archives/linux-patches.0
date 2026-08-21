Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6BAA4052B9
	for <patches@lists.linux.dev>; Fri, 21 Aug 2026 05:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787290511; cv=none; b=CZjI8FnvqzKCMw/Wnj19x3a/I368hKydiwkCqKqymq5f+SrMj0wrY4o966mmDo9MRxF0eJrJ4yRf4AmstIqDewYOiQzBWmdr8c0Byy0e0qEQcjU+ZcATPrmbkZjM2cBb0BMcbfJ6hD6RCO/5nn8tpzGwfmwNrk80loib6b6/DSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787290511; c=relaxed/simple;
	bh=4BY1nuF8sywWXXecXVHNFOw7DPlSzg4p08rPhLdMOI0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JQdo2blvQDWIbunnnWJ+nqr1iIu7njNyAYuUauoCnQ4sIHWjSQsImODIqtP2HzuP226BNo7u5FxANYDwtZW6msUHsV8RgcYR6HEMHTDiaA2TTjazpGJC1trOfqs9AlUNA97naSiXxBpuFVKOGeU3jcjBOjabB4BzUAQIGEg5RCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=v/7KVjaw; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="v/7KVjaw"
Received: from eig-obgw-6006b.ext.cloudfilter.net ([10.0.30.211])
	by cmsmtp with ESMTPS
	id xHnCwZdoKuFzgxHuAwThy8; Fri, 21 Aug 2026 05:35:03 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id xHuAwdz62XLlMxHuAwNui2; Fri, 21 Aug 2026 05:35:02 +0000
X-Authority-Analysis: v=2.4 cv=IJ4CChvG c=1 sm=1 tr=0 ts=6a87e386
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=7zlW5CcJN2upRH6XaXYA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=k+XrP/ak2MMwy1i48cv4u2z4Oy1Opd/ytq5W32JSyzY=; b=v/7KVjawlaVJ2gtpXl7vsNAAYo
	EOXwoYmhL2JLFJYw94Z2PRYh8JZYz0sIQAFgArvYGptF5Fv1q0wXBtzJjrpXLmX2BHup5+uDDy4wL
	aA4JS3fA9or5skkKT7tOKkifoZQYOl0kMKCVCWYsyetFuSLnHOukHBX+X/7Skrz8X5OlFcYB8+Gwc
	lv/BWAx2St6zhwN5UtEFrQMppRIN6/9Cl7KaJ1vVYy33cRK1QR67LIH8RKM979dHF+KRoZ1E6WXLY
	06rQeEbo0O2aR+sXSLSK8BPUWGqKhnAPsmk0EuDxWC0WB2r+RWKbkeBPbfFGArC6aIG2rtQBTqx1R
	aXGUJVig==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:56056 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.5)
	(envelope-from <re@w6rz.net>)
	id 1wxHu9-00000001hQk-1UxA;
	Thu, 20 Aug 2026 23:35:01 -0600
Message-ID: <ef63dced-7dc3-4436-823d-8a912f2d3b7a@w6rz.net>
Date: Thu, 20 Aug 2026 22:34:59 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/166] 6.6.153-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260820145211.194104353@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
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
X-Exim-ID: 1wxHu9-00000001hQk-1UxA
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:56056
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfDYfTMSxjMAfsmX1fdyC4dqLoOfRoPgMUvBgtSh1Wsk323alJzTrgK6ZMvqiykmECYROUu4Ne8F+FObiAPJFY+qJLHTvpbHvbJqPo72dTfmyoQ77YLft
 fB+hR+/aTWz4fPVS6QTbRFquGr8UjCLS5fophpTRdAPJrApRABEVl8bOGTPDWC2rWq8xzFgoEEmf0g==

On 8/20/26 07:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.153 release.
> There are 166 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 22 Aug 2026 14:51:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.153-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
>
The build fails with:

drivers/net/ethernet/intel/ice/ice_switch.c: In function 'ice_aq_alloc_free_vsi_list':
drivers/net/ethernet/intel/ice/ice_switch.c:1816:23: error: implicit declaration of function '__struct_size'; did you mean 
'struct_size'? [-Wimplicit-function-declaration]
  1816 |         u16 buf_len = __struct_size(sw_buf);
       |                       ^~~~~~~~~~~~~
       |                       struct_size

This can be fixed by reverting commits:

"overflow: Change DEFINE_FLEX to take __counted_by member" a5c50a3af39c74eef1a15c39924b0e1f4c6a43a6

"ice: make use of DEFINE_FLEX() in ice_switch.c" 858a287aeaf8a690fd3c769e0ee2247f40e44b62

Unfortunately, the Bluetooth commits have to be reverted also (because they depend on "overflow: Change DEFINE_FLEX to take 
__counted_by member").

"Bluetooth: hci_sync: Fix advertising data UAFs" 50d4431fab38c15c9ef405b6c7e13c0491f29928

"Bluetooth: eir: Fix possible crashes on eir_create_adv_data" c4fedbbb5b925228321a359b8a3949b207cc0a62

"Bluetooth: hci_core: Fix not handling hdev->le_num_of_adv_sets=1" cf931b0c0a6a5b8b70da339101c0df17cc068488

"Bluetooth: hci_conn, hci_sync: Use __counted_by() to avoid -Wfamnae warnings" 88dd9093e398c68467d8e9c8b7fb630aab05be05

