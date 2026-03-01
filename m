Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 569612561A7
	for <patches@lists.linux.dev>; Sun,  1 Mar 2026 21:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772402135; cv=none; b=OXW+7UApYbBu2hUhXqXEvfo2kQlIY74TFC1YApvpTiI33OXX2Y2WP8uXjpFn/5+cgdC1L4moJaSF0eEb5SVecZAIVS5fWkOLQDyNUpvB7pYMiSiJ70RVH7VrvGPcPH0rrrIHYn8mZENLDAxHnzZaKokj58kstO82jMbAYpLFQP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772402135; c=relaxed/simple;
	bh=nQxflxD3Ka/RcGafz6arawvbVsIrrFU2RttBOtj0fAc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bQAhyDPhlDux/YwatUShu4Uemol6O+S9gtLIjXru3N91ybxdLhiMiD0/yXn5IAWRhElGbmPwu/O4/xiOlSYiGLjZMhWVTAIbln0vbP2Khud3+bsfeWJWjGWHEGIcgGzknXxKNC4TP+dEC8D/NWZGU9j8R/IPyAWYzD4XLP6t8WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=AjZ7zY0T; arc=none smtp.client-ip=35.89.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="AjZ7zY0T"
Received: from eig-obgw-5006b.ext.cloudfilter.net ([10.0.29.217])
	by cmsmtp with ESMTPS
	id wbiev3Gp7KjfowolCvDBkN; Sun, 01 Mar 2026 21:55:34 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id wolBvMd6AOs9RwolBvlbVh; Sun, 01 Mar 2026 21:55:33 +0000
X-Authority-Analysis: v=2.4 cv=HPPDFptv c=1 sm=1 tr=0 ts=69a4b5d5
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
	bh=iDiSn3xpxzVfyEpb8cxw8xsHsaM/vVKTndQxlMXXd8I=; b=AjZ7zY0Tz6L07nOwWKhSgDIleh
	AUXzHY6nW1cPcRQWV8pCtm9XnIUZieECEyJxf8UmqsW3cN/l+vB94XQxhJfEkeRKfCUWKtpWwnhoE
	9+sYaZL95k9DAf0yiecj+iGNW7BDaUb2wj+QW0yLTnkBBkEB4V4NUD4ZU8QShabsDKUa0jMsIXxno
	kLsKFUSfGpStvHx1TtcZvMyX37ciHI6l14TGyOq+3EL/QCym5d77EWWxQvpnABQnOJWvW+IScHK4T
	NETwJR8SEge7aLMAXY644sPihZhp+p+DLoZA5Zk/T9i/pKMBaDrAAKd/pYEy1FhkaHaUnqpKKW9aR
	uNBvlESw==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:39204 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vwolA-00000001cKp-3DvL;
	Sun, 01 Mar 2026 14:55:32 -0700
Message-ID: <c4557772-9e26-4653-a93f-afea8ab75414@w6rz.net>
Date: Sun, 1 Mar 2026 13:55:31 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/752] 6.18.16-rc1 review
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260228174736.1542240-1-sashal@kernel.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260228174736.1542240-1-sashal@kernel.org>
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
X-Exim-ID: 1vwolA-00000001cKp-3DvL
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:39204
X-Source-Auth: re@w6rz.net
X-Email-Count: 38
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfGmofAn2MW7INtc3uA2jhSNRPer68wbM7di95z7ifylWYWR38xI0vYRdWin3hdJqb+/3WIZiIZ0JZpv5QOnejUeN98N8T7QRm+4lwYguza9Yy4CKULKN
 OyaQc2Mo0+AEoV3EwZWxXD/Js/mL4zfaxxiWBlMuvF8YP3YgOkMhB7yeWoJtE7gNR9SdEbmJDk4dGA==

On 2/28/26 09:47, Sasha Levin wrote:
> This is the start of the stable review cycle for the 6.18.16 release.
> There are 752 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon Mar  2 05:47:08 PM UTC 2026.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-6.18.y&id2=v6.18.15
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> Thanks,
> Sasha

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

