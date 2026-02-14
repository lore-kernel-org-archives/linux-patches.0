Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F902C15AA
	for <patches@lists.linux.dev>; Sat, 14 Feb 2026 10:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771065773; cv=none; b=JTKG09bbmfwdj4EvR6m+w+IkIQxomUkkJSuoPIaoujFZcGvdzE/qaUMXWt+37Yg8SIhmjeaa4hanZw2P4ilKW/ecPVUlzHkAxfG6T12Bri8zwRQtFRJqIAIVkpoZed1xMjFegYiSoxkpvUBdu3zLlLX3stUsimI3dPz9i+2qpXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771065773; c=relaxed/simple;
	bh=3orRuYCBjhN1+v+hhmqiWrfq+AwTfM5T+sUQDqDDC/c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jk44/9SWbWg/b+8LhsuhDUkUJTTrgncyUQETeyYvVzLUAXBSGioQMWPDKApt56AsIxq/i8RDeyBQ10JXZh8Er8LpRvwuJ0UD9bVE+f45Dp0reALloZowDQXR1km1cD3szreOck8iwW9h6r9++pVoEVbl0jVpnHvUPNIju4ZaEHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=fweGiA7/; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="fweGiA7/"
Received: from eig-obgw-6005b.ext.cloudfilter.net ([10.0.30.162])
	by cmsmtp with ESMTPS
	id qaKJvCnSECxrGrD6xvEzvi; Sat, 14 Feb 2026 10:42:51 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id rD6wv8us4HSQMrD6wvMk8z; Sat, 14 Feb 2026 10:42:51 +0000
X-Authority-Analysis: v=2.4 cv=GIQIEvNK c=1 sm=1 tr=0 ts=699051ab
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=gq9DnTLsTDy6HNLTkQGLdX+iSnsJ28f9iyJnpIeF2fM=; b=fweGiA7/AOcx0UR4pQdAlTbxe5
	TrtxNx+RhPAKdGrAEz7lprgFw0LmEcRzfmD6FgO2ZfKkfsQfA+2UNzM7k8mCh8OwEjaUYOK+5nVVJ
	IJJTi3kc3SUbaDn8VP3/dyXzpGeXEdop+1S+7tCyFoSsqQi1k/P7p5q2LVIgIS5+qLRzj5Kcn3Pz5
	L30TIhAOs6epmvn9zd0a9IoaNykyVhSq/zccfr8iyCDS7HG4Hrmyj6InI1ngwquEMzDGyftti6UPh
	vxkc/RA2k2MH8P99H4vOilzzZk8tY8uJnke0ovJ9m1yyDJNz+U/vYzev162nquAiQhQLaDgN3kWhV
	8dRa2Yng==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:41778 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vrD6w-00000003WBS-1ODi;
	Sat, 14 Feb 2026 03:42:50 -0700
Message-ID: <227c95da-2c1c-42a1-a2bb-a87c023ad492@w6rz.net>
Date: Sat, 14 Feb 2026 02:42:48 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/24] 6.12.72-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260213134704.728003077@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260213134704.728003077@linuxfoundation.org>
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
X-Exim-ID: 1vrD6w-00000003WBS-1ODi
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:41778
X-Source-Auth: re@w6rz.net
X-Email-Count: 58
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfLp3mNnchJp4goEFw1sIHmdQNgBe+MTx2L+o4KwUzI8t+4xwXeNjdSZbaCxre+jHaOZ6z6DqNzvhn/uEOZJ2uOvlYzVJggiPfWucd9ldfdBflKf9t5Q7
 YP7+qsDikKJWcjgOesuJ8ieIFW6+j9Q20d9v0iwksEbr0MaxFzLeMchuppLb1IzgsSNCwY4iORA7Bw==

On 2/13/26 05:48, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.72 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 15 Feb 2026 13:46:52 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.72-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

