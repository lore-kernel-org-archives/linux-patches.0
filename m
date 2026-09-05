Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702A24F0554
	for <patches@lists.linux.dev>; Sat,  5 Sep 2026 18:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788633621; cv=none; b=Q36YwkJPpUikI6NVRYwKsy1Qc3ZNsKIzN1A/+ss1Sz5BtOyq6TDDsYTcmy/x0UPxVcJVzVHbAanLWK2hIvIu8qK29E0j5KMjler/uDc36EBVxqOhh/NQvJw5P+i0KpYxCX1dThM2whvj+RyPYgHYjJe0fJzPqnJNkE3Q/y77ml0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788633621; c=relaxed/simple;
	bh=vdTyZNyfSIyq4CLkO3uXENZ6xhUhmmZP0fKuJPU5Z9o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OPxY/VCxfUUBfw2MkmIf8z759fGDwj08qYERBs6XhUFZ1m32ZApungLVO49g/t0YeUygc4/kNQKj2eoeFm1g74sMuSu2B8BmXeExZSPGS7GUxlc+j+vMlzYtWQ013UiKrqsPJxcwEmBjJngtHWvj0YZNn28z1/qO2sxSL9Ss0Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=QpVAFtSl; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="QpVAFtSl"
Received: from eig-obgw-5005b.ext.cloudfilter.net ([10.0.29.189])
	by cmsmtp with ESMTPS
	id 2qw7xRmz8v0nd2vJDxYRB5; Sat, 05 Sep 2026 18:40:11 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 2vJCxkxmMrpsL2vJCxpTut; Sat, 05 Sep 2026 18:40:10 +0000
X-Authority-Analysis: v=2.4 cv=WJZ/XmsR c=1 sm=1 tr=0 ts=6a9c620a
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=E96Kx0X+4zgNMaUc81mHH8LGkvMndRM5B5hRiRMrV3M=; b=QpVAFtSl4Xrs7HrGpRVeKtXWSY
	XMtN/2v55/GEljcKk0OaODW0QJtQ8zi5Qrotzay/ysZ5Gw2G24g7VHomcU4XVGBHRAoNHaNnBYKc+
	WoVYtMYjqz7muMmYNCs2r3/7iTuGLg8JAXNUD1X7O89+1p6913cisV/hKPi4HYmvRo2iZuL7LNcdz
	nBjKKYzVZzXJa/V4YY8siyH2kyylVU1+QfCqb2wruhAeNm6iXswzQgc+ZjG57WbYBlgZ4obgaAj62
	Z4o+9KU0bCLYXfCL43svaYsnOxIo4PUKrOuGUpvVbAWOMRoz/B9ZtDRgxm5w1Rth7pdlqTwNKfaNX
	/z3r7DxA==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:58894 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.5)
	(envelope-from <re@w6rz.net>)
	id 1x2vJB-000000007MR-3FvI;
	Sat, 05 Sep 2026 12:40:09 -0600
Message-ID: <2a532274-08ec-4dd1-97e0-de9a4a885c3e@w6rz.net>
Date: Sat, 5 Sep 2026 11:40:08 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/551] 6.18.50-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260905115635.269562615@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260905115635.269562615@linuxfoundation.org>
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
X-Exim-ID: 1x2vJB-000000007MR-3FvI
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:58894
X-Source-Auth: re@w6rz.net
X-Email-Count: 38
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfFJ10SlxPa5y59UuCHwiIPGzpUktyNgn5QlqJH8SSIMgyOzWrD26MD/rt9JusfFNc987mDb1yPD68eObciMEjrbxTPBBYipcsEKmRqp+BYiacNW8RaMq
 sMzzeFEAHRQRXbTHZSHZH43bHloRX45YvW5B+6Pc9x328ZNvwOWVxVwDo6pXNnNnHYRQ1UiOVQ5WaA==

On 9/5/26 04:58, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.50 release.
> There are 551 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 07 Sep 2026 11:55:07 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.50-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

