Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428ED30ACE3
	for <patches@lists.linux.dev>; Tue,  3 Mar 2026 12:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772541146; cv=none; b=FgTFZB76RmCqi0ViCv26PofRAWv25n2icExjWYcUOcSZpvAhp2QRDo3poDxklgZXsC9nP4l84H+AFXkzsYh7WfaFP5OVX72D6xvzhpiM2iQO3+b5HvZqvsyL3T0npJ31/CkMIxHctFDbhR/DM2goy3mJuY5SlEK9Tuh3EX02dSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772541146; c=relaxed/simple;
	bh=th8xVIuP73AP6j51cnSLUNWB4pp5rFxRTb5w+CJOLF8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mxJ0iQG2wnjwV85d+u8gFQSk/jd921tpHKVGj3xSdq3d8IRepMM421Qz0EJed1eybRXgkZ3SnYMfkrgUmcTWJ1dOTk5J9QBTC3WNc0GrEDsh/Hr1ZLulaJzhslOOsS4PaH+pBBroiwYgm5g1NSNuqlATTYPk3pR1zvHEYBoX6R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=EH6uHbih; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="EH6uHbih"
Received: from eig-obgw-6004b.ext.cloudfilter.net ([10.0.30.210])
	by cmsmtp with ESMTPS
	id xKuCvuE1HKXDJxOvIvGVnz; Tue, 03 Mar 2026 12:32:24 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id xOvHvSZSvK8vzxOvHvjKkY; Tue, 03 Mar 2026 12:32:23 +0000
X-Authority-Analysis: v=2.4 cv=cJDgskeN c=1 sm=1 tr=0 ts=69a6d4d7
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=nNnJKXQrKSxacFBDYX03YGazfo4UHnibGZdGKaFIx9s=; b=EH6uHbihUfXhgHgltkG3zUjaI7
	vcJwd7EKc1d22oA1gDZFWQQLauGbT0V15DAy3frkRd0MINEBI6+NmCl8HAFMuSBFlJ9gs8EeZK5VC
	SajK8fPL5LJJB42BAczxaVLVq25hwoMlIdlo30e9xyBOQDT4GJHc2jaBNgt9JKP9V+0sAhcNVW6Km
	n95dYsku+aptbSwAN4qXoc89MyOctV4EP9mN9jR0f7uVohB+3inYKieKSMoLHAwYxt5viMPozHgAn
	XxjN2YcG/+FozsB7KuVJo/ZTy0/t7588vZMBq91O8UESIe53sL3Ddc/5MvYJh0YnzWxMf4dOIjDju
	kVcIL6nA==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:32956 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vxOjs-00000000jLM-22j1;
	Tue, 03 Mar 2026 05:20:36 -0700
Message-ID: <0f64c673-a6de-4eae-94aa-50afea13ec05@w6rz.net>
Date: Tue, 3 Mar 2026 04:20:30 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/684] 6.6.128-rc2 review
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260302160934.2521545-1-sashal@kernel.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260302160934.2521545-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.162.206.103
X-Source-L: No
X-Exim-ID: 1vxOjs-00000000jLM-22j1
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:32956
X-Source-Auth: re@w6rz.net
X-Email-Count: 84
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfO+jdSntYHvp0ds821ubP76/jDVMmXDVfVfpzCQalUmCwCF4bZrKTkrFTcl6RADKsh+Axiu8FnirlJ+knYhSvBwId94kssvK6/LNhPcljD2utWUWgJq/
 XolVhQx0Dm+KEUbFPPgyWNivUXNdkbsBvNm5FEtWM0Gy9Q4AuCfi05Vea56P5fXdmKdMsoM9UOmNaA==

On 3/2/26 08:09, Sasha Levin wrote:
> This is the start of the stable review cycle for the 6.6.128 release.
> There are 684 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed Mar  4 04:09:32 PM UTC 2026.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-6.6.y&id2=v6.6.127
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> Thanks,
> Sasha

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

