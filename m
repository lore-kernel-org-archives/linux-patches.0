Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B480027D780
	for <patches@lists.linux.dev>; Wed,  1 Oct 2025 03:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759288270; cv=none; b=iJPg4lD5Q4/SkgoOi57EB66NjSxuQC6zMn6pJr600l+A9tT1XGh9bdCjBldH7PdkKEI2zEEIzsQDOyptyNJos55O/5kyaI8dUxll/zl2xDZGAoedc70n0mxdua/ji8PwmMKiOKovfhBx77IgzIrhPRqWMI+xW0LBihVkIW8gKd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759288270; c=relaxed/simple;
	bh=NdInzNWUx515W8nENQ6iJFPF2gXS0WK4xE9ekkcxHRw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Uw141Z0Yh8RkC0TNo+2CgIZWJhV+aDj3si2nKPBCRagZllXgwAC9FXc3YTmta8sZYcupEScTK4tKe8hzdQG9U1XWds55dY8bxVg3BLhzdTVf322PhnUFj2p0pNfTW0ejaEPQQFlyo9/UkOIlj/S+z6DwxSukQDjf7TWSYsTF3To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=To3KF0sW; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="To3KF0sW"
Received: from eig-obgw-6005b.ext.cloudfilter.net ([10.0.30.162])
	by cmsmtp with ESMTPS
	id 3esavK7Mzv7243nFDvogmA; Wed, 01 Oct 2025 03:11:07 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 3nFCvyalxLidY3nFDvEZHa; Wed, 01 Oct 2025 03:11:07 +0000
X-Authority-Analysis: v=2.4 cv=bq1MBFai c=1 sm=1 tr=0 ts=68dc9bcb
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=Cyuvsrd2OJRF7bCfhtsA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=pX/2X4nwuzShjCXn7DBYBSD5Fqqf+aTcr+T6gBkYj3E=; b=To3KF0sW93764Puq2iIobaASU5
	fvm7k73oPdARPZmp0Ne9ewe17o5DFwygeB+ScGJVBD7JU2K9KziPtFDzgHMlc315YxStAWsKOTAXI
	2ZPYRn4yZJh4NLAqYceGqRM0sqPQIHjErIpMofmyADrlpxX57Fwo4oGvK+kwbQaMofyE8bo8Kfy+n
	69CEIO80fy6pLerummrsrg4eZxcd7yH1w3tIjTuWY8QDGI1lZTnmX4f8HhmdmImyKApDuI8UGbsfD
	Detv3wKJBOTplU53CXs5p1E7N6+GVuzJTeH+KwRamWglnQxiZXbdFbkBYW5CeoV5C6+VoS9hN3P2R
	2tNV3nFQ==;
Received: from c-73-92-56-26.hsd1.ca.comcast.net ([73.92.56.26]:41480 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1v3nFC-00000000ecz-0ec4;
	Tue, 30 Sep 2025 21:11:06 -0600
Message-ID: <a26f77a1-bd89-41c0-86ec-6bdfb1728ff4@w6rz.net>
Date: Tue, 30 Sep 2025 20:11:04 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/151] 5.15.194-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250930143827.587035735@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
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
X-Exim-ID: 1v3nFC-00000000ecz-0ec4
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-92-56-26.hsd1.ca.comcast.net ([10.0.1.116]) [73.92.56.26]:41480
X-Source-Auth: re@w6rz.net
X-Email-Count: 36
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfB9oyJH3t4h0sWAnGPy7DREFozNW98Z/p0crdyo+iY4VD23hMRc+BRWZaE6C3DXQOH9BOZ7F58agLo2MBg+cTSqLCGFenvPBCKhalIalgaLVDlKPzD62
 5rrUYKOkdsfgujoKXLFcgFr8U8A1O6LMsJE+x0KUFZ3ZwE7u7pPTk7JZvhICb4Vfl9vtVp1AaJvFPA==

On 9/30/25 07:45, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.194 release.
> There are 151 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 02 Oct 2025 14:37:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.194-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

