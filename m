Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 721AE20322
	for <patches@lists.linux.dev>; Thu, 27 Mar 2025 00:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743033815; cv=none; b=tSKaqqIXkRW1ITyfDCoL4pvgX8BO5Plv58no5knuoFQOE0NXnBHI5hXShWAMdkF2NJFIFcxWN072MjJwvOu2pg3n25GCVnAj3UxkceaWlakdrBfMHPvJGAcLXNTI0iWyj3paQ+3P2yCeaD7h0ChRKjGQt3Js0+J9VtrPZyOt3p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743033815; c=relaxed/simple;
	bh=htb/S+ZRiTwzP4pBgtK5fDRVA5do0TWaJU3ztrMHz74=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F8Qg8et5z3FgXmbjKzDHGtIFmwB19To8aydCOe7EEl5KgdpZg1YIQLluDucrIJUpzjFx6EPbZjc8BVWhkGt/uMvaxB4Mz9i44lurz7BYYZK26/JUpowmDQewyMT+8SL6U9/WuPD8z/WKOAkeJeovS1ZeJVFr6FFxRUq8KMw0vcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=PbNCQWU9; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="PbNCQWU9"
Received: from eig-obgw-5001a.ext.cloudfilter.net ([10.0.29.139])
	by cmsmtp with ESMTPS
	id xaCJtaH50AfjwxaiVtZctz; Thu, 27 Mar 2025 00:03:27 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id xaiCt7U51RxIGxaiDtIHSj; Thu, 27 Mar 2025 00:03:09 +0000
X-Authority-Analysis: v=2.4 cv=N/viFH9B c=1 sm=1 tr=0 ts=67e495cf
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Vs1iUdzkB0EA:10 a=7vwVE5O1G3EA:10
 a=GbADBbLF9kGFZ1da6xcA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=tVHrW2e/AoqyF452N5nVLVSp8tcM0SyxkR0ST/C9luY=; b=PbNCQWU9Dskq6IY9VssaMJEp6h
	XQiFqufIRAcRxNz9LehXKu+RHL37B37uSDvsslOY07eaoKVB0GBwMfEI9uzYf06QPVqQWBTocYMSs
	7ALpth02E0kAnR+zF2egH9SokdP0SZykWNX3CZ2t6C178424TiqkKkLykCtXzrkRlHzQvCrKYw7DD
	V5uw7RAs/QoZMD90RfchUngNPJKAo+YzC7ckwD8FyloSKweJmQ4p0JoakNrjr18IzNT+nhVFkNT+Y
	3YLOgJRVvVU6XCbPQqm0UCD5b2qXXrvXxTRNzI8n/EdhrL6UXWwXJ5tIzhbRUmVmtlEpuqgDWVTIo
	APTcgrPw==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:42036 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1txaiA-00000000syi-39PO;
	Wed, 26 Mar 2025 18:03:06 -0600
Message-ID: <c254f837-69a9-45df-8780-113ebfbf16f0@w6rz.net>
Date: Wed, 26 Mar 2025 17:03:03 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/197] 6.1.132-rc2 review
To: Peter Schneider <pschneider1968@googlemail.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250326154349.272647840@linuxfoundation.org>
 <9dd8bb33-465f-4417-b179-10fdf7f8b440@googlemail.com>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <9dd8bb33-465f-4417-b179-10fdf7f8b440@googlemail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.223.253.157
X-Source-L: No
X-Exim-ID: 1txaiA-00000000syi-39PO
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:42036
X-Source-Auth: re@w6rz.net
X-Email-Count: 17
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfE5Jc47NRkUjP+/pFP64jkpNQ6xDP5ZkFp28WZQ65XOYbsuBDsNh0dBj2K2PegRcxprKn6yM9IE5pSUCjGVNd1cZIjEMeRyi6QBNLRflHna43qUIaWmP
 DSBX3K/apSAF4/qEFm9+J/7EqmocDoYwje3QTYrDwOR7JCjw0+ZpXyRKzKTGA3YA/VUr5EJQ4Z+Iow==

On 3/26/25 13:10, Peter Schneider wrote:
> Am 26.03.2025 um 16:44 schrieb Greg Kroah-Hartman:
>> This is the start of the stable review cycle for the 6.1.132 release.
>> There are 197 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>
>
> Trying to build on my 2-socket Ivy Bridge Xeon E5-2697 v2 server 
> (X86_64), I get a build error:
>
>   CALL    scripts/checksyscalls.sh
>   DESCEND objtool
>   DESCEND bpf/resolve_btfids
>   INSTALL libsubcmd_headers
>   CC [M]  fs/xfs/libxfs/xfs_alloc.o
> In file included from ./include/linux/string.h:5,
>                  from ./include/linux/uuid.h:12,
>                  from ./fs/xfs/xfs_linux.h:10,
>                  from ./fs/xfs/xfs.h:22,
>                  from fs/xfs/libxfs/xfs_alloc.c:6:
> fs/xfs/libxfs/xfs_alloc.c: In function '__xfs_free_extent_later':
> fs/xfs/libxfs/xfs_alloc.c:2551:51: error: 'mp' undeclared (first use 
> in this function); did you mean 'tp'?
>  2551 |         if (XFS_IS_CORRUPT(mp, !xfs_verify_fsbext(mp, bno, len)))
>       |                                                   ^~
> ./include/linux/compiler.h:78:45: note: in definition of macro 'unlikely'
>    78 | # define unlikely(x)    __builtin_expect(!!(x), 0)
>       |                                             ^
> fs/xfs/libxfs/xfs_alloc.c:2551:13: note: in expansion of macro 
> 'XFS_IS_CORRUPT'
>  2551 |         if (XFS_IS_CORRUPT(mp, !xfs_verify_fsbext(mp, bno, len)))
>       |             ^~~~~~~~~~~~~~
> fs/xfs/libxfs/xfs_alloc.c:2551:51: note: each undeclared identifier is 
> reported only once for each function it appears in
>  2551 |         if (XFS_IS_CORRUPT(mp, !xfs_verify_fsbext(mp, bno, len)))
>       |                                                   ^~
> ./include/linux/compiler.h:78:45: note: in definition of macro 'unlikely'
>    78 | # define unlikely(x)    __builtin_expect(!!(x), 0)
>       |                                             ^
> fs/xfs/libxfs/xfs_alloc.c:2551:13: note: in expansion of macro 
> 'XFS_IS_CORRUPT'
>  2551 |         if (XFS_IS_CORRUPT(mp, !xfs_verify_fsbext(mp, bno, len)))
>       |             ^~~~~~~~~~~~~~
> ./fs/xfs/xfs_linux.h:225:63: error: left-hand operand of comma 
> expression has no effect [-Werror=unused-value]
>   225 | __this_address), \
> |                                                               ^
> fs/xfs/libxfs/xfs_alloc.c:2551:13: note: in expansion of macro 
> 'XFS_IS_CORRUPT'
>  2551 |         if (XFS_IS_CORRUPT(mp, !xfs_verify_fsbext(mp, bno, len)))
>       |             ^~~~~~~~~~~~~~
> cc1: all warnings being treated as errors
> make[3]: *** [scripts/Makefile.build:250: fs/xfs/libxfs/xfs_alloc.o] 
> Error 1
> make[2]: *** [scripts/Makefile.build:503: fs/xfs] Error 2
> make[1]: *** [scripts/Makefile.build:503: fs] Error 2
> make: *** [Makefile:2010: .] Error 2
> root@linus:/usr/src/linux-stable-rc#
>
>
> I have attached my .config file for review.
>
>
> Beste Grüße,
> Peter Schneider
>
Seeing this on RISC-V also.

