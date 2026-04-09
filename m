Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A421E2FF66B
	for <patches@lists.linux.dev>; Thu,  9 Apr 2026 08:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775721870; cv=none; b=UPE89pZ6VAthPkAluH831+oFZzrSQajX7MCjzjcofVJ26f8OyS35Q5/VbIYzXs/WV7lLNQTYVwZNieGmx6ZNuteDkQ3CdK/9GmLtRphO5Ugp9nNKvaUji4Z+v+fOAoRgjloCeYY+VuFePD1VGHC9sTsEH2WllRFM8Wq1Vjr6OsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775721870; c=relaxed/simple;
	bh=DAjGfGNhTLUWGHJkAzrmGT3q5uYITREul4k8BNoPzcY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XS4gZ7MgOBZ1GBxWeko8JW2oUKwu3bEojKRAnlss19JGSROTUQlpdxx0osHF4GTxl4X4+OiQ2Xzw7eqbhLYaPWhbnjEHS0RtXYUJqaNJniFfC2PLX+NsKYQ8VrkVDrCP3F819qDauFita8pCRuhfLMmmKkBYLXkF0OIZAvV1wZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=ISJMtDb0; arc=none smtp.client-ip=35.89.44.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="ISJMtDb0"
Received: from eig-obgw-6002b.ext.cloudfilter.net ([10.0.30.203])
	by cmsmtp with ESMTPS
	id AhPDwEwpJshqQAkNJwinjN; Thu, 09 Apr 2026 08:04:29 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id AkNIwNcokwWe6AkNIwVls2; Thu, 09 Apr 2026 08:04:28 +0000
X-Authority-Analysis: v=2.4 cv=RfSQC0tv c=1 sm=1 tr=0 ts=69d75d8d
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
	bh=9Tqn9AUVQInYdLDqjz6sHTb9iOj57lRCPIqCNLhhAGw=; b=ISJMtDb01oqXfOxGMuxOlNXRRW
	fXgUg79DXJuIRkQj5xXjfmAuBv+NJ9IpDsEtML9D/xNk2/1rYhnj2sng7lro5m4CAiq0XpYZyx+1E
	wl4qc2o1Yx3n36sbu5Q+KnabjwJvcSWE3QVHcpWeMaDTHIAjhNQXp4vafw4NkW/Iim+QUGSPF8UwX
	3qZqHdkZSpuZG9M2AQe0ZVH4XydHR3KaG7v8n1npHc0Oc5cPeOc33FKU/2SUU1aeodHGZe5HJf2LW
	nltaF1iglEbBWRsPggu//5xSalKTX81g7xwB9Cqpm8WmctzHqBsLCHYmPKNFsBgBXcKutbG5QHsqG
	Isv0vY1w==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:40974 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1wAkNH-00000001y0s-2vhY;
	Thu, 09 Apr 2026 02:04:27 -0600
Message-ID: <76dff695-827c-419d-990b-5b7845a46c3f@w6rz.net>
Date: Thu, 9 Apr 2026 01:04:26 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/160] 6.6.134-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260408175913.177092714@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
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
X-Exim-ID: 1wAkNH-00000001y0s-2vhY
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:40974
X-Source-Auth: re@w6rz.net
X-Email-Count: 78
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfLcORTpDN5TU9g2R24j2Yivk+oWgkPQFhtdikIOVy74/r/t7SMKvOZY6MU5rygnawrubkZuiDn9JfzfulMu1mV+7ivtJT5c541lTwnAEanx2pamkVL26
 I48EA/meBTm5ts1kjiSjDqgiQBzEAku3HwMkPJZy/UBsXdaRgI0wirkcvNANQhTgZ/PWiQYKTJuV/Q==

On 4/8/26 11:01, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.134 release.
> There are 160 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 10 Apr 2026 17:58:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.134-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

