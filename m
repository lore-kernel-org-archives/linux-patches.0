Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C2B313532
	for <patches@lists.linux.dev>; Wed, 18 Mar 2026 09:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773824576; cv=none; b=ueVPpFURzG6sqZGJcY7CitfswfvCE0iFJdSy0oYf4qE6gL6f+qEl6ySCUGyxoZoWQ0zaHk/5Knjlst99tddSw8fis+TasOb1Ofe8wEIuKJ4BiuoOor5riaGJCtsLQaf3MaT5qz4dxvXwDZHTd6SFb1yGOOprysA0TGjfLyosw1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773824576; c=relaxed/simple;
	bh=WvRMkvjlyA86P8EnzAPqknyHzwOOB2P8vacobpna3yg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UwBWE65YFVoZ3+b778EFylnCCWR/l1M9PsoFJQ47lV9yqca4Kn7nVoZ3CjX2G3YTtb/2JYG4494K4ObqOhXFAJcVTkJWiHa4EaRFpNCZsaXSwAgt4h4QdNORk2tLR/UOCCteIeWkhtBGCLCk7dgXQhPYJYRVP+DT7833C6PsFVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=KyfrWx96; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="KyfrWx96"
Received: from eig-obgw-6004b.ext.cloudfilter.net ([10.0.30.210])
	by cmsmtp with ESMTPS
	id 2m8SwacALJ9SZ2mnmweFEA; Wed, 18 Mar 2026 09:02:54 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 2mnlwoBslK8vz2mnlwDnyU; Wed, 18 Mar 2026 09:02:53 +0000
X-Authority-Analysis: v=2.4 cv=cJDgskeN c=1 sm=1 tr=0 ts=69ba6a3d
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=YlFsy8CyaHjNQos-U68A:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Sg7BMjV17IkX6wqAwFUOCQ34ob21tgtLEs44vKQeEGs=; b=KyfrWx96OMU29+YCDJk6EkeL0D
	QGWcS+vmBrAzZmwDMZcyHI+qtsEwrr3iiSNNH2zsSCfSarCJ5h+dR4jFM5uV2yUOIsPJTanT8pmrj
	PsvXl+zpbhOqGOH3VH6IbxM0ryPkR0mXXPAdUdvatA6Fs5ERu0fIrxK1vj9xWsh5M6vsOhKEpFeIC
	UvSOkcLmlJJicmHceYUT9hhXkyi8JLdFKXKvLYK4os0lQPFDUtgEwcs1yR/9wkelXXsmYM6f+9B5j
	oKeGTSSdRgv2JASu1vlu64xe8FZxKAq2OCEso9kRhQhvfp5JUZELAqQRupMw4NCxQqgwMbKyyy2PZ
	R86UJHDQ==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:59946 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1w2mnk-00000000QID-3VQl;
	Wed, 18 Mar 2026 03:02:52 -0600
Message-ID: <4f5e5f91-3331-4393-af81-c8e926423d4e@w6rz.net>
Date: Wed, 18 Mar 2026 02:02:51 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 000/378] 6.19.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260317163006.959177102@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
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
X-Exim-ID: 1w2mnk-00000000QID-3VQl
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:59946
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfMzYjLuH+jj304evOcLbGjiLWb1RF392NcifY/E/yuyq5uwXKqrpjmXw9Q297HUIMeBhynSA5Gg2P5KTXVYBiP8R8A5fkJLCedL2ast1eEAckTfmqNpt
 Ue4FfKdm6SM8kIKIt//3irf8jBuKVPygqmVbb+xupI/dnoiP3BNdXVxRgzClSCu9UTMwaINCSz4n+g==

On 3/17/26 09:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.9 release.
> There are 378 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Mar 2026 16:28:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

