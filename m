Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1DFC314A69
	for <patches@lists.linux.dev>; Tue, 14 Oct 2025 14:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760450847; cv=none; b=MgLm8w6N5mWyy95niikm1BGQr/ikZTds7ZMdoII7Jq5XH0ObKj78SfQjpqA3wEb/cIvu04hzdxj2r23pxBE2doymvmNMC5Dk+CcI5vzfdN5xsr+5s1g9sjvKsIp2/Xm9/OkbVnhoQAWkPyJRhbCF10jlbQk8f+NTlG6g/wUnPsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760450847; c=relaxed/simple;
	bh=6sKVOPgAzUgWvKI/ZBPihiUgRU/gjgvXflO03UBRI4w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bxBJYsZapDdi1ClBlZWkmgAKrltyahOoDFIyzLbQn+td9+KpYhBjRNYoRLlHnkZnPO4P46Xd8FE4hIXS6xEq3VrAp9Y1Cqp0zNKiCT8AGkH4dsRhsvqHI9fd7NKAdgDmE4oqQG3uyAbcj6w2mITJ6oxZ6AN+V1diVtx24YMTISM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=pdv4IrEg; arc=none smtp.client-ip=44.202.169.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="pdv4IrEg"
Received: from eig-obgw-5007b.ext.cloudfilter.net ([10.0.29.167])
	by cmsmtp with ESMTPS
	id 8f6Jv7wyhSkcf8fgRvygSF; Tue, 14 Oct 2025 14:07:23 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 8fgPvwMP2FT7u8fgQv92Po; Tue, 14 Oct 2025 14:07:22 +0000
X-Authority-Analysis: v=2.4 cv=Du5W+H/+ c=1 sm=1 tr=0 ts=68ee591a
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=7mImUwZGDDb17UAjreoA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=pEwZ1wB0XVK3HMVObxxAtytr2yexg9RDlZxxS5uZ2DQ=; b=pdv4IrEg1A0Q6o4TN4GO//BEBo
	2YGlLsnF5Giod9SrL33RuuP/H1zpyI4I0HRLtuX82Tp8FxVZU/R3Xy2CWmTfVQZaI1mhQ0nvjxQ1N
	ysNFsU4Yos8FQHhJYz4Tn2jrF/0ZgsoYocdscmG010LagkMJ1MRLeQ771YLssVZG21IbPcDIn0Da6
	1EH6nsy4omwNljlagf9J6Pdui048jtYxzSI1K30Y0wkVbqC8Yx7oa8Bn+4ji6tR0PgDdSfIUxFCy4
	3rRq8Oc265kEUuSfG2P7DtZUCJQkIszxhfguthyoyHW+8r7EowyrzQdpVezFdLnqoqot+Ea/5p7bE
	K1AnS5OA==;
Received: from c-73-92-56-26.hsd1.ca.comcast.net ([73.92.56.26]:38648 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1v8fgP-00000001oEH-1zfg;
	Tue, 14 Oct 2025 08:07:21 -0600
Message-ID: <5e43f6e0-91d5-4954-94ad-ef20c3d9131a@w6rz.net>
Date: Tue, 14 Oct 2025 07:07:18 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/196] 6.1.156-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251013144314.549284796@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.92.56.26
X-Source-L: No
X-Exim-ID: 1v8fgP-00000001oEH-1zfg
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-92-56-26.hsd1.ca.comcast.net ([10.0.1.116]) [73.92.56.26]:38648
X-Source-Auth: re@w6rz.net
X-Email-Count: 17
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfGWb8fZnUsxWllZQNYpoCJv0oJOjUyTytVbUCK8M1O1nB/1Kkbf4UTsKneCYflKInZPw22wQV9TIttycoHzdXsRE1QtpYn6GOKKBNT4D9qGXmiSUaRPt
 aoNHsOR6aWMXrGxmcC49Vt1am5baSJoiaKH1lhpQfmc7zZ6U1rRjuhCwcUUjo4qSeY6IIo2kdc0yNA==

On 10/13/25 07:42, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.156 release.
> There are 196 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 15 Oct 2025 14:42:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.156-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

