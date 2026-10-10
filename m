Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE3330E828
	for <patches@lists.linux.dev>; Sat, 10 Oct 2026 07:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791617207; cv=none; b=rLsjbaJUK+bsiZ7BIwZZANAqp8jH2LQmRLMTkdlVQlREUA5IAFgz6Jy234+84HgvJ9lSlF2Dg+Xk1zK8vtWMAtg2OTcNqfcFRjunQTsuSozD2DLcMTlMWnx0oAN0WQac9eyYKfG1QGDSZwwpUVjamM0iSfJCMdi1pYViPz/YiJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791617207; c=relaxed/simple;
	bh=Zrb8fF83ihwCy5E64vD7+UdNPyX6korPq7gOC+OVVPg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jn0stkvPulv9vGhn1yUDfB1UrqSIK4dF9Ryda7ZA3PYEEHTJiUAIlpHM3I4MBDM4Wny7IVU4hOa4q5TRjZ3cBMC8ssaCjnGETqIuK6Bq/MKCZgIAmNIo5+kMzBfD0DJm/B8BO9CQqQ/K3oi0XkJxVvMpj2gOr8PQ+AweqO5V7YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=rtYa5qxi; arc=none smtp.client-ip=35.89.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="rtYa5qxi"
Received: from eig-obgw-6005b.ext.cloudfilter.net ([10.0.30.162])
	by cmsmtp with ESMTPS
	id FIkhxiJm5aC0UFRTixSSQR; Sat, 10 Oct 2026 07:26:46 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id FRThxxWIIvvPpFRThx4I2s; Sat, 10 Oct 2026 07:26:45 +0000
X-Authority-Analysis: v=2.4 cv=WqUrMcfv c=1 sm=1 tr=0 ts=6ac9e8b5
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Unsubscribe-Post:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=CQiSQOokz4LWgZwaj9OnPw7iZq1kF3GjFfNI9gqb7II=; b=rtYa5qxiANZvwwpOSfj0B2oPq4
	gtAIp2k+hEUO5Nq6/RHXObygzE7fZ2f42efLqVqGRB2pj8IaOsLa8BjCFNSLIcX0go+KesslsAXwr
	Nz5YZchLPWp9peUOIP9HtcCb05NbXk6HkrPThNlWGxJW4UbyqQedx2GjlM0e9omfyz4NVvnWih08q
	SJ9i8MYIizUaBMvcX5zAd0nUPvPReo42FnZjFnoyQ4QHT+bwZyyne5lRW6PutnyAMo2SHVlHDsa1S
	Q4k0X/3uyrAaLzA5O+kmBb9MM8kH5VvfLshePDfOM8eizpFOVRXcIfSoFGK6YPPPLeGRiIm6o28A6
	uVYHQo0w==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:39670 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.100.1)
	(envelope-from <re@w6rz.net>)
	id 1xFRTg-00000001lDx-1ptS;
	Sat, 10 Oct 2026 01:26:44 -0600
Message-ID: <96eb4021-e133-4690-af8c-905587b94593@w6rz.net>
Date: Sat, 10 Oct 2026 00:26:42 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/403] 6.18.56-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261009140952.119038291@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
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
X-Exim-ID: 1xFRTg-00000001lDx-1ptS
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:39670
X-Source-Auth: re@w6rz.net
X-Email-Count: 38
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfJEyW1n46hAFieeQPWIGHliiAIdFoPyHjFA8yniRtbz/sVNsGIus7/7l+V+ZSN6XBm8rkdb+woVUN5i6hGsv28Nu1jSeinWA6k5Mm2TcC46MEvAKfkxe
 op9GtMHKGPti17+1fVFGZCounuq+angEEuw8AITdOM0tze/6xv6Z39RcHFn+HFsz2y0MhxCoT7shsw==

On 10/9/26 07:06, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.56 release.
> There are 403 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 11 Oct 2026 14:08:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.56-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

