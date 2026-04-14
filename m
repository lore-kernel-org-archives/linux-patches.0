Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179DD3DC4B1
	for <patches@lists.linux.dev>; Tue, 14 Apr 2026 11:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776166394; cv=none; b=lQ5ZewywoWArXjEpoj/GVlo4IRhbaprP2MxjwIR1jpMW/RqMjLiQngfRh7aBN4G+6Yu57bJbF17p5fROkzwCr6/+ot0KDGZUmRLJcyIUst9xLV60Kvo8KAx8vlWIs5saeWEp8S/id8p0ABtRtcNlra4XWuObpMKGtvw6+v4a5Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776166394; c=relaxed/simple;
	bh=kDrG1mZv1073SRD/Qo2iyABO+aorcvn1OOmNL4YNAK0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fj3x5EoYzf0X0YOspD77LYNUIiewoaOYkV5u9toLWS9x9jyTPQhTFMTMv3goyJfdZXpaHyprPFMDcoHaUBMC3X/AuXcqVTpEFT/v7L0Y40dBCwDWsOWo5sIRgemReTvwzDwGyfvFzQmpptSAxnKPgFLuEEHdgDKbFrSnf5VgbFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=1Tc6cY74; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="1Tc6cY74"
Received: from eig-obgw-6005b.ext.cloudfilter.net ([10.0.30.162])
	by cmsmtp with ESMTPS
	id CUhzwhE8mObRfCbzUwTd8a; Tue, 14 Apr 2026 11:31:36 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id CbzQw6UFSFeDMCbzQwyyRc; Tue, 14 Apr 2026 11:31:32 +0000
X-Authority-Analysis: v=2.4 cv=aq2yCTZV c=1 sm=1 tr=0 ts=69de2598
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=eZnwr+yP3qyvn5oInOxqVTDl+nDcXx1U9YmckguPEQ4=; b=1Tc6cY74yppmstO+btPi6iSHUZ
	lYQv++DDGXu5OSPgUu9MuIF2O5yXWbuqYxrFSLWeWfGa8vyhcsoir8MXa4lto2BCZmip11x8DkgQ5
	gRnew4VPPCRMNCFaCMBUGgtPdPzAOzUWK8S9wpyj6YQPwndIAdOmLU/OkzZCBTfEXfAAm5QileQpu
	LtJ6//hCD4pS79KMX1+FmA67/jgVoj+KDILohTN2NNJZHo+jaGjheOHhg/z3kVRJtXbREjZrOb30f
	/3vpnY2iJyaulccW9FhqnXI6fff0S9NuSiFVC4v1MFxJUxWjPTItesDnceOus84v1pQyPJl6oJYgk
	rq36gZ9w==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:38724 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1wCbzP-00000002e1c-40ta;
	Tue, 14 Apr 2026 05:31:31 -0600
Message-ID: <ce1ddbb9-deb1-4f1a-9016-0c726a0e522f@w6rz.net>
Date: Tue, 14 Apr 2026 04:31:30 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 00/83] 6.18.23-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260413155731.019638460@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260413155731.019638460@linuxfoundation.org>
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
X-Exim-ID: 1wCbzP-00000002e1c-40ta
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:38724
X-Source-Auth: re@w6rz.net
X-Email-Count: 38
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfKBEsQ/y7QfiFAHl7vuA+f9h6CdSwNYjAGp78k19csuoAu1kjKczy860a/X0AoaOzXxkR2y7Pf9tRcSumw3o/PpoTKSUN+LBU9evSzHEwrcoMm1IZ9Ew
 zxQzFogkHysK/m0sAxvUpEZP+dXfN0C+UuNEjaHkj8hGNhYI2cIBRkDsJ8/hppzeqd2oxurx6vD1zw==

On 4/13/26 08:59, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.23 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.23-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

