Received: from omta36.uswest2.a.cloudfilter.net (omta36.uswest2.a.cloudfilter.net [35.89.44.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E02A30BBB8
	for <patches@lists.linux.dev>; Mon,  2 Mar 2026 05:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772428728; cv=none; b=IuBiM+vk+Il29LhNp1X3EsVIEDhmaDXU+8AF2N3BFyQBJL7srW4u42HlRxvHT7qR3HF6lOG1kPsyQ2ofJdJyt5drSfWxgDMakBaBsHutnFDUncgf6ozM/Hk3Pae3oCeqguL56qGzUREXcVOwJG60d4GWvQJXhMrrudJc6dPFiik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772428728; c=relaxed/simple;
	bh=Q75ZmdLlia7sEiGJLLDfNyYoHRBMGUFe8pXR9H8tlYk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p9/GNQJ1cYLEDR2pHdaQKx9J/yLoG9nx0NkEaTb/z/3/SCm7Hrv/3jQ4Ln9h/fG9EjIgkqSRiVRMPfpogv7FpnO29k11oRnF3bZq+6eFiqSO0XhqUAlnf8hoQIMVOxAZJfCCO+a2qI5a8XKt5HW2OpH9kF6Y8ACbnB+Fx25oTao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=KOlKjNAU; arc=none smtp.client-ip=35.89.44.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="KOlKjNAU"
Received: from eig-obgw-6007b.ext.cloudfilter.net ([10.0.30.166])
	by cmsmtp with ESMTPS
	id wmm4vOJlmVCBNwvg6vTup6; Mon, 02 Mar 2026 05:18:46 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id wvg5vcAzRh8QWwvg5vTnhZ; Mon, 02 Mar 2026 05:18:45 +0000
X-Authority-Analysis: v=2.4 cv=Mcdsu4/f c=1 sm=1 tr=0 ts=69a51db5
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
	bh=iSCEMxFwHz8iC8jQE04FzLO1+phOm2JeE/ol0ybRx/c=; b=KOlKjNAUqaqaGrN+7vlvrfvMgI
	kQIHMDCp65nhpfOed1W6GuQA7hWGKpW68Fqu6irTOPxyCVRDp00+RBcm1iNJshEqXHUN6t44y3LUf
	GEbSu0MHsWSsuHsUbnijAeAD9kp0SAiJOCwnxY3Ch31t3TIlRaYT0sRfVYBrcfi2VJZ8OnEu3TEc5
	tJcHuW4NO/vZOHPb3NEs/PeVnhSEvX9ppssgWJ2zxyAjaYM4NRjGdPDo2KbjSiHNlRc62MqW/6LnN
	z2+tW6fAppYO/NuDuxncuq1jBwKb/8HA21Xhu90+X4s8XYXxjbSOgmfIZUdzDoSmaAVXm2d/mbT9E
	vCJwZ+HA==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:44622 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vwvg5-00000000MC9-0E5w;
	Sun, 01 Mar 2026 22:18:45 -0700
Message-ID: <b36e2b64-714f-4865-86fa-58e89f4e4ad9@w6rz.net>
Date: Sun, 1 Mar 2026 21:18:43 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/164] 5.15.202-rc1 review
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260228181458.1600528-1-sashal@kernel.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260228181458.1600528-1-sashal@kernel.org>
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
X-Exim-ID: 1vwvg5-00000000MC9-0E5w
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:44622
X-Source-Auth: re@w6rz.net
X-Email-Count: 17
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfCBaWGvNwDNkKb7nPyIsYEFnuAlm8BTpwBA1hraNdIm0SodsL+X7I2Sraj8RkTqKqdTZdvYotkTRQZ9xjoprSptCOwmynntkfy1jWtgsLQGAd6KtAk/Y
 YBNR6EJ9nXBWJ61A+lwsrUouk9ksPjmmmvI2dNhHGLyLAdtghfUJYPysPocbkSwzRd2rGtO4NQaqWQ==

On 2/28/26 10:14, Sasha Levin wrote:
> This is the start of the stable review cycle for the 5.15.202 release.
> There are 164 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon Mar  2 06:14:56 PM UTC 2026.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.15.y&id2=v5.15.201
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> Thanks,
> Sasha

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

