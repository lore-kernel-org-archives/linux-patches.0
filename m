Received: from omta034.useast.a.cloudfilter.net (omta034.useast.a.cloudfilter.net [44.202.169.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F2B6BFC2
	for <patches@lists.linux.dev>; Tue, 16 Apr 2024 06:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713249294; cv=none; b=s+oCa3apvgwW/VVm6jhT5QDmCwGtbKwh5nj+YCdsADMJLERnlHQvzlk34GD0bJ0aI67jnnIWABRsHn3WC9NrkW0B2ytMPuJBvM5yzuM1TgaLKwezy8SaFvaeQdiz4UleQu4uKsA4m69rQxBjuvpCT4Ds5yd6YlfNyV+88cWekCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713249294; c=relaxed/simple;
	bh=XCgkOzhMsbOJzuLqpLn/8nLxmZnMaMR41pjiI3ASrQs=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=HyhB02ILyC7kR2wzAJHKO/cmfwR+hnRP9k/p4yteDB71nccWCFTWJ93UKMFzNQPcrAVeLNGzpipblCdtYJM8FDt2dXzbNix5V3yqrEpZ46B8SosBFIEBmNCfaeGBFDip5tFksU/oPYkFFnElWI7BpYp9Xx+fKRX1vca+z7iVHTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=4KBpnldg; arc=none smtp.client-ip=44.202.169.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="4KBpnldg"
Received: from eig-obgw-5006a.ext.cloudfilter.net ([10.0.29.179])
	by cmsmtp with ESMTPS
	id wawnrMMlRs4yTwcOyrKmBZ; Tue, 16 Apr 2024 06:34:44 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id wcOxr3SKZqaR9wcOxr8ftN; Tue, 16 Apr 2024 06:34:43 +0000
X-Authority-Analysis: v=2.4 cv=MqZU6Xae c=1 sm=1 tr=0 ts=661e1c03
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=raytVjVEu-sA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=+07axyW+ZbRmTBe2i4OgzTYThRnKslRKgz/+xUnb+zg=; b=4KBpnldgPubUrhB/pVoJRWn1vB
	yvVmv6mjoxeD5sKVvqwzXY3x/hWQOSJrTy8bF4jb/h0NzRsMxN1T4rMp4D/k86QhOPsqx5qQA2/DV
	KhYeSu9W15cltXDix4uxdylVodHooMIH/Ua09oZ6hQIQRtvOnfp1Gh+TZxnH8lXg+rcti1jHEbgj1
	E8l5EzS2ihW92W2c/s+Xpafh7Jet3U8lEPsIhXJxjCasaPNDLKuk2tf8BPCeLNot8o9h0mEVhDFMV
	Ys7QfNh9ZLvHFS/i1YPs/icnHGdjg/W+xUHrtMuK0BgrNqykxTGOYImU2NolB7uQx7+LZwzKNZlyO
	Md+PspSg==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:57908 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1rwcOv-002DPv-1Y;
	Tue, 16 Apr 2024 00:34:41 -0600
Subject: Re: [PATCH 6.1 00/69] 6.1.87-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240415141946.165870434@linuxfoundation.org>
In-Reply-To: <20240415141946.165870434@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <4ad06e18-5f5f-7b21-f96a-0502b1fffe6a@w6rz.net>
Date: Mon, 15 Apr 2024 23:34:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux armv7l; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 98.207.139.8
X-Source-L: No
X-Exim-ID: 1rwcOv-002DPv-1Y
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:57908
X-Source-Auth: re@w6rz.net
X-Email-Count: 41
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfOvSzqPM9QYgMJrMM0kYaquu2SZET19cWHXGSXubW4HAbm1PShYCzcYqC/emHsyoE1DcRT+wqJEXdsey/nNJzf6rkIbjFIXeKgf3rBEYShXximNgCden
 F1TUVLt3VNRJGK3QhYRYKCtMvRTXNtBjYF5njupqwaKbbI5GMeJgOM9YCxZrav1MkgiMJm6LI8g8Sw==

On 4/15/24 7:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.87 release.
> There are 69 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 17 Apr 2024 14:19:30 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.87-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

