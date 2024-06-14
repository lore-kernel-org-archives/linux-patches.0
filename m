Received: from omta034.useast.a.cloudfilter.net (omta034.useast.a.cloudfilter.net [44.202.169.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41E21957F3
	for <patches@lists.linux.dev>; Fri, 14 Jun 2024 11:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718365721; cv=none; b=Ed6bAcgRownsqMk6fwNCa0AS3c6tV5iqq0ozA65h9x6MOZ1mwiYLn29e11/7SC6XbnB3K05qpPqhUhOAXLWrVo4xkTIXg86US94D2khmXND8myVbltm1/nEl+Jv9jqDjPVrTlM8xnm/1EFOY4hWF97bLupS3QaNX/pCwUYtYyws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718365721; c=relaxed/simple;
	bh=dc4g/FqLqnkZCzzdzH720GqY3gChKJlhIjv3pnXkus0=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=fkUISMgltxr4zPhMGM2LHeFP9dEySC+GuPP2oVEz/9faEXQyJIDqadZShKsUtPMckjEJ4VNX4mSbDZ2Mtnj7Va3/KhNt6q/Hb0bMcxWcVSg77Ccbmh0qdbh+L+/Dhifi6xdRoAQeuVM3PAGldRWiuZLLGcqxMLrKHMzL3o4LLC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=V5QB/vCL; arc=none smtp.client-ip=44.202.169.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="V5QB/vCL"
Received: from eig-obgw-5001a.ext.cloudfilter.net ([10.0.29.139])
	by cmsmtp with ESMTPS
	id I225s53edxs4FI5Q1sfoUu; Fri, 14 Jun 2024 11:48:33 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id I5Q0sXLsJCaXoI5Q0spQx8; Fri, 14 Jun 2024 11:48:32 +0000
X-Authority-Analysis: v=2.4 cv=deBL3mXe c=1 sm=1 tr=0 ts=666c2e10
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=T1WGqf2p2xoA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=k_VYlBbNjbJsBR3UXVkA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=SJ211wi94nGDCWHRpcjXc8Qrb8ZidlVEgUpOOYb6Bwg=; b=V5QB/vCLPaMiQyJs4dk7FWo7jK
	8+qrudK5miSI2x1VAkhl8Ie6M/RR3x3RSvzgbx8aJXJfbXXysOGmT3TkOdLRdF8YUlsrnd3y8ClxW
	1CuVPDxngS9yVczt077nv1x2G9BIIs44JNi0T5euF4ULn9L2HXEfPYzZ0ilPkYJiSsjD2rIfSBVNb
	zF1F4k+Bdf9iBWinaIE5XpEaP2YI+4y8wRcgeDijxr7ykmZih62tPPdhl8OL6ynp4Os0Cm2C7zprm
	6nJr7jzFPbrLA/8BntLwrzau3YhgTKNVuJVqc7ZkBgObChIYGnT6/dqGL9/uhZVsrtBTjBs4jKUTi
	Jun9tNJQ==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:43674 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1sI5Pv-001f4w-2O;
	Fri, 14 Jun 2024 05:48:27 -0600
Subject: Re: [PATCH 6.6 000/137] 6.6.34-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240613113223.281378087@linuxfoundation.org>
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <44fdf34f-1689-c622-ff33-bc3709c920d4@w6rz.net>
Date: Fri, 14 Jun 2024 04:48:22 -0700
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
X-Exim-ID: 1sI5Pv-001f4w-2O
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:43674
X-Source-Auth: re@w6rz.net
X-Email-Count: 22
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfJRQjx5RelEf6hs2iOpz03+fyY+a18itrG3kxFIWb9mlxDv++08GPzPN+KJxjOoGQ5J2JOkKhCC24sHZPDKAk1fkPdR4mnqkiL/JcL4tYDjBRC0bR+66
 nzRNw0bv9iv6XhDgKigrGyjeUUnWOzb6wOkC6IMafm9utZ9IHiFjcEufiRFXat8+2LxbKTYbzHBX8w==

On 6/13/24 4:33 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.34 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 15 Jun 2024 11:31:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.34-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

