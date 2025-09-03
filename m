Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87F61A9FA4
	for <patches@lists.linux.dev>; Wed,  3 Sep 2025 09:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756890555; cv=none; b=Jcl4bv+R+9MhbN3enCsStWcGX4dE1Gsgz62rakbaWe62EGcVGUNHhtsYJJdr3OMeHrNl2cbw+5G185dAWxQq9+5UAJ1+T0ziQ8p4CPvQqAyD1YUDPSIQjaKdH+aBUc81L8jJwKKnuPD3xF9y1aMjOZ+oCe4AKmKxl5giyiZT+9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756890555; c=relaxed/simple;
	bh=bwYsT9DRK4gMXi7T8w5+6oIzELlAX350IPrYb/+9gHQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rzrkkeSItDCPNxhv7lXhhVTqEGGVzJYk3LJeRAq1Os7ekFtlpexOrk1hSsv0aIkhPoXvq/BxOJYdE5v3PX2teSKkDSYATl3TVm8ctDDWfUUVl26h4PU2Xn8pcMOU0O///PxR3LYvZIqlHSPKg0Cj8kXd3whLbq+caIXImWgw9CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=iP7h23AG; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="iP7h23AG"
Received: from eig-obgw-6005b.ext.cloudfilter.net ([10.0.30.162])
	by cmsmtp with ESMTPS
	id tfbIuo3BTeNqitjUOuMqkH; Wed, 03 Sep 2025 09:09:12 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id tjUNudUoEbrw6tjUNu4HgT; Wed, 03 Sep 2025 09:09:12 +0000
X-Authority-Analysis: v=2.4 cv=KKlaDEFo c=1 sm=1 tr=0 ts=68b805b8
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=wQHQzwf_Hs2TCVCgcZgA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=0VACGC7nInLv4TntWsXXWM0H3z/snzT0lh0knaPTms4=; b=iP7h23AGnqHvJccwB9uzxlAE5P
	U1eRv4nOO9/UVAVxGCzEodCIcco7K0dYTyOknQ16UTJ5s2QNpF6VqCEip471TBF5Oy8IJ7okOEVnf
	afxU/7FDwyUdRvQdigSNXhs63hDzv7/8T8kQbPJhOED+8jse8QU/Kux51c/vEBTliEpTdgdE1cj5E
	ZwbR5s9shLjl4HJdzMT0G6pBpZoM22ZhjZ10HyHw9cd0Vxumra9Y+NZ+Ym4ZYWdlPGbc+a8W6baY6
	1cdqutBPACLOSSjRuo9nPmjIziz+8jJfI6OAuf2s5AemdERelACbUL5V10rZU4J5Q+lSvBGF4P3wE
	RgmWeS0A==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:39874 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1utjUM-00000000orH-3Rho;
	Wed, 03 Sep 2025 03:09:10 -0600
Message-ID: <76bb67bb-f8f0-466d-8566-d5f69f7ad6e9@w6rz.net>
Date: Wed, 3 Sep 2025 02:09:08 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/50] 6.1.150-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20250902131930.509077918@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250902131930.509077918@linuxfoundation.org>
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
X-Exim-ID: 1utjUM-00000000orH-3Rho
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:39874
X-Source-Auth: re@w6rz.net
X-Email-Count: 38
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfEcIzTSKfhRb+NLm0jU2XJpL9/9gSEPL7uDVXhF5D0ftNWvo+XHqMZe+t/oaLwwbwKm+WWBmf6B27iS6u+cUUaXJv+F9ci8dWXMSN8jNQgXd3qbP9O7f
 qtZ5GCQltRskculZScgxNA/Qmj7s7BufguiMh8e9mDkiTpzG6Gk+nDmETXU4BLvkzPP9e25PRRJWUw==

On 9/2/25 06:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.150 release.
> There are 50 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 04 Sep 2025 13:19:14 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.150-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

