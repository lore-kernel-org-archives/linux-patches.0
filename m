Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E01C2EEDE
	for <patches@lists.linux.dev>; Wed,  9 Jul 2025 10:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752058416; cv=none; b=aAcxMjQgp4IoPKsuXLHU8Mv+EsJ1uCPWX5Vs62gg6xSWbueT1aj8BBqpaocRkzePr1cw6D8Ru/LastamFyRA6dPO+CMLfLp5cuiu/oD94hs6hS1l6q/CNrMj7ZpWvbvr4A4nzuMZuaHDZbUhuXS1XrXbSTrqdDKmHoyLTD70iCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752058416; c=relaxed/simple;
	bh=z1NonGCwFNHSslLRrC3a77FwRB114PAvIGd97MFBOQw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=udWREZNR6GhiOVxnMn+lBuQ3GQ/RRxtsYizctxtj+kIJ5f04Og1/xRUoutg6em9CLBwp0qFFOChY77vCDnDMdil32nzfPHPFH+j3Cej3sCvUqhANIy0fkPC+yU///n+KSF5tvBfgfSJuBk3tPm1BTX6VK+T9vSJ8pRSWTQUbHG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=JUcMmPbp; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="JUcMmPbp"
Received: from eig-obgw-5003a.ext.cloudfilter.net ([10.0.29.159])
	by cmsmtp with ESMTPS
	id ZMHquSBWSVkcRZSQZuBzZ0; Wed, 09 Jul 2025 10:53:27 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id ZSQYuIEDTn1UKZSQYu4WCb; Wed, 09 Jul 2025 10:53:27 +0000
X-Authority-Analysis: v=2.4 cv=UIcWHzfy c=1 sm=1 tr=0 ts=686e4a27
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=7vwVE5O1G3EA:10 a=NEAV23lmAAAA:8
 a=badPxlQgyaJOncwre8UA:9 a=QEXdDO2ut3YA:10 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Tlr6v9PxHau51PRgCsTb4NzXUuuNhIcSwEVy4gSiwhk=; b=JUcMmPbpeUXVMVmNKpOaISfIVB
	iLUHBVsvOHyepsYpCj+O3b1SHTedCgjHXabden2N2KRLOm0qaHYGarRxRtwtcPDMl/0uY8EpnFfk2
	vrguUrCWjRyxsKL/qkqoiEIhH7g/p4GY74D31ck4XTjVrLbgfb0avHtE+IsVs/kXeQx9tHRWTMdz0
	BYrDptRHvDOUYzPzK4cNcOQmotPgIqLwhdiWK1yTmH68XzkJL+hdDPk5/0MQIW/Coqt9T1vD4rISu
	+DSSSgs/HaC4JNlJLjBZtSgAQoch2pXtc/KEbo5HiorzdT6FUHm1ivzOeDN9ZzqxIUOu3pyCdnByZ
	s2f7OLeg==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:49570 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1uZSQX-00000003qOF-0XsK;
	Wed, 09 Jul 2025 04:53:25 -0600
Message-ID: <081ac1f2-2d47-4029-a2a3-f3a975083785@w6rz.net>
Date: Wed, 9 Jul 2025 03:53:18 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 129/139] scripts: clean up IA-64 code
To: Greg KH <gregkh@linuxfoundation.org>, WangYuli <wangyuli@uniontech.com>
Cc: chuck.lever@oracle.com, masahiroy@kernel.org, nicolas@fjasle.eu,
 patches@lists.linux.dev, stable@vger.kernel.org, dcavalca@meta.com,
 jtornosm@redhat.com, guanwentao@uniontech.com
References: <20250703143946.229154383@linuxfoundation.org>
 <E845ABA28076FEFB+20250708032644.1000734-1-wangyuli@uniontech.com>
 <2025070857-junkman-tablet-6a45@gregkh>
 <572685AD12256749+e24050a6-dde6-4447-8b45-69578b352e5f@uniontech.com>
 <2025070914-hankering-saucy-ec33@gregkh>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <2025070914-hankering-saucy-ec33@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.223.253.157
X-Source-L: No
X-Exim-ID: 1uZSQX-00000003qOF-0XsK
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:49570
X-Source-Auth: re@w6rz.net
X-Email-Count: 24
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfMyCyTtbZyj5sYLJHBQuns3oQc6BJDExjWF9ApNsQD5AbfYIllNvEXaO7QBWXSAJcC25bv1iS5FuvQP6ItZlGYffzeWUNNaoTCSK0b/eLyouf/AEXgoz
 Stcm9hohSyF4C8LlL5q9t5GgZObNXzamq+ygc1lQ4NxWrfO9BrUrT84sRcc1zf+Op9b3ouKPN68PBA==

On 7/9/25 01:47, Greg KH wrote:
> On Tue, Jul 08, 2025 at 03:45:16PM +0800, WangYuli wrote:
>> Hi greg k-h,
>>
>> On 2025/7/8 15:20, Greg KH wrote:
>>> Is ia-64 actually being used in the 6.6.y tree by anyone?  Who still has
>>> that hardware that is keeping that arch alive for older kernels but not
>>> newer ones?
>>>
>> I'm afraid I don't quite follow your point.
>>
>> In v6.7-rc1, we introduced the commit to remove the IA-64 architecture code.
>>
>> This means linux-6.6.y is the last kernel version that natively supports
>> IA-64, and it also happens to be the currently active LTS release.
> 6.12.y is the "currently active LTS release", along with 6.6.y and older
> ones.  So are all ia64 users sticking with 6.6.y only?
>
>> In any case, I'm quite confused by the current situation because we've
>> essentially broken IA-64 build support in this kernel version.
> Sorry, I didn't realize this, it came in for a different patch that
> fixed a different issue as the thread shows.
>
>> If you genuinely believe that no one is using IA-64 devices with
>> linux-6.6.y, then it might be best to directly backport commit cf8e865
>> ("arch: Remove Itanium (IA-64) architecture") to completely remove IA-64.
>>
>> This would avoid any misunderstanding.
>>
>> Otherwise, someone in the future will inevitably assume linux-6.6.y still
>> supports IA-64, when in reality, it's no longer functional.
> Who assumes this?  Again, who is still using/maintaining this arch for
> 6.6.y anymore?
>
> I'm all for reverting this, but would like to see some reports of real
> users first :)
>
> thanks,
>
> greg k-h

I think IA-64 is maintained by Frank Scheiner <frank.scheiner@web.de>. 
There's repos for stable and mainline.

https://github.com/linux-ia64/linux-stable-rc

https://github.com/johnny-mnemonic/linux-ia64


