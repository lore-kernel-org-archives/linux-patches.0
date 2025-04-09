Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3111DDC07
	for <patches@lists.linux.dev>; Wed,  9 Apr 2025 06:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744179948; cv=none; b=PG0pCcYA3d1kIfFXJvxN32eCObMmqFkR6Qt7Rb7eRcJmGxpe8pXgGNQe5EKtn4Zu/7a57Ka/IyI8Cbqip1DNtFcUi/8J8+fbqbZK5OLSJOHxKw7Hmwdt4WmNbXSoUonReGQ7787q+ofO/UNlUnabMpUBEgoSJ/bHIAaHRzfGJ6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744179948; c=relaxed/simple;
	bh=NsWrE+0Nrfeur0/TbObeaAVwt8826Bm3KC7dJ5b1ANA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dRSBPKszSMrcY4QXrRskjqaUn+fC3rq+ROPQBcBrFKUSrCPUOFib2LYyPdH9HyPT46YvDs4lGgbw0BRcz66w/I3yge16rl1MQzPIluK6y4HYdO3NX9S/ZbGnX87DPntUI2nZ+KIi6KjdEAtR6hIaUnOBfrtQawHOYPjAc++yimQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=Frwh3oMH; arc=none smtp.client-ip=44.202.169.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="Frwh3oMH"
Received: from eig-obgw-5002a.ext.cloudfilter.net ([10.0.29.215])
	by cmsmtp with ESMTPS
	id 2JGZuRSGtiuzS2OsVubkHX; Wed, 09 Apr 2025 06:25:39 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 2OsUuDqXEJ4Pg2OsUuHOyN; Wed, 09 Apr 2025 06:25:38 +0000
X-Authority-Analysis: v=2.4 cv=ZaLWNdVA c=1 sm=1 tr=0 ts=67f612e2
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=pwdEqUWduaeIAd35nA2kUnPGDo/IkIRjulH3VUmv4wA=; b=Frwh3oMHFK38xSmd43wbUEB2Fs
	o4BGKOzv9cCFrC2upww4TNAVYkiVMfpOXocS/2FuYyPnZkV0KSbUyaomlmI5eoGpMLynTDJOFE+YW
	9JQkMo0AMf8aNLBOyGeHzkI14Homf2N1fqAvTX/x9m2ifLRzRMJu/7amQymZKoSTx/tOknDgP02Md
	nsPCpNMg24ivgdkIuloF4eUKw97DGtMcoUJHZ7HrHhyHQSxMJqhkZWn7N8tLO7umnr+jjv9C27mFz
	F23Lv9m9Zc2m2yvCG6lSg/FHIa1KvNTfqAtWjYG34zTIU/YBgea5z3UHcj3/RBpoIruJVRH9uxsp3
	6TIQ+tsA==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:58370 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1u2OsS-00000000Csj-1fZW;
	Wed, 09 Apr 2025 00:25:36 -0600
Message-ID: <71b8ce3d-32c8-43cc-93ee-f776ff7fa2b8@w6rz.net>
Date: Tue, 8 Apr 2025 23:25:33 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.14 000/728] 6.14.2-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250408195232.204375459@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250408195232.204375459@linuxfoundation.org>
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
X-Exim-ID: 1u2OsS-00000000Csj-1fZW
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:58370
X-Source-Auth: re@w6rz.net
X-Email-Count: 17
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfLkW3NPVwPUlsOLI+EDbuCPT6yH4I68FOwCKw+Aju97IohFkOaytSbboPN2WT/7QBidTByg8sS9Cpp1ShCjpPynRG75x5nujM6HMPYW19gv/q+MlRvh4
 zotQEhXWfsJknvrB1+9Xi1ZhKIMkptvmmGq/OvJUiyPdk9sTQVx4Fc3XILlYg8eoyx2octNHLazkEg==

On 4/8/25 12:55, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.2 release.
> There are 728 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Apr 2025 19:51:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.2-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

