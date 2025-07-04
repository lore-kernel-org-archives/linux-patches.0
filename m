Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E098121C9F1
	for <patches@lists.linux.dev>; Fri,  4 Jul 2025 06:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751609495; cv=none; b=M9BpOEsdCceC7z5vV06gxCakDvoQLWQhUyek6qGEJ4ZKrqlZyj/dW/GLFZTEYkOO38Au46DACBlnEghSnJFZvldozNR2XpGmWXEradmc76oSRYZTFw3X6rG6srbnkc9PYtxEgZzfbBjvWxkxFjTnotJYUFlV6ES4zb6skJWtX3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751609495; c=relaxed/simple;
	bh=O6LXBFbCwIJaDin+zzb+0raOCWqTDDFp2Cm5kHSUdTY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RySifcHBhf5pwEFMZu0hvtExg3J8VZ0FDY2OcWhvX7ZiwJUZY9H3YJycZYQSVYYHwUBLlxmSB/SnAgFE/JDNQLbxFzu+rnXlv+8n/JWdEKcVejNxMm9vd/kKllfeiaIxW9DDFs+qphKcd5bXHM5l5WLLzgTeV+HyclFT6FG2FO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=cleKjt69; arc=none smtp.client-ip=35.89.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="cleKjt69"
Received: from eig-obgw-5010a.ext.cloudfilter.net ([10.0.29.199])
	by cmsmtp with ESMTPS
	id X3kNufMzkWuHKXZe1uCV3V; Fri, 04 Jul 2025 06:11:33 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id XZe0u4GfHAd8ZXZe1u63Kq; Fri, 04 Jul 2025 06:11:33 +0000
X-Authority-Analysis: v=2.4 cv=JN49sdKb c=1 sm=1 tr=0 ts=68677095
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=ZJCAKeS_rTr8ZDEThcMA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=LwZAWYloBXc3Pm9ESwZeSkYQftvpmTtLdDVeFx9GEfg=; b=cleKjt69V9QB0FxbyhP9Jcm7nb
	/rIyTNZBkirZkXxUJvcbRmHpyeGJYPzdZFCrMtUGToPqMaF9uH4HWo2u1tu1jW8JSkd1W2v7E8ONL
	nboMReChR60zfXtdRdgXzA/CI+Hs2+cKXYxkiNxcF7KHbFEWz6ULw3HTOiNZBP2zuEW79nbitiVgR
	YLvlb7Yh0N4s6SnOWcjs3kaLFQOEB5uFRRziefGWXtOQouH/BGkjaz7NFa2HclHYoZ4aQjkyI1zGm
	W/IE5hphQKPPRB12yyatpZOwCzZvsX6h4u3jXwz0vOj9tJdy0NJXYCfc3P4s+EK5tJzr4DsGTCtEP
	KGNTxIrg==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:46382 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1uXZdy-00000000xFS-0jNn;
	Fri, 04 Jul 2025 00:11:30 -0600
Message-ID: <a320110a-47bc-4d1c-b1cd-325f7f1b2e8b@w6rz.net>
Date: Thu, 3 Jul 2025 23:11:22 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/132] 6.1.143-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250703143939.370927276@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
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
X-Exim-ID: 1uXZdy-00000000xFS-0jNn
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:46382
X-Source-Auth: re@w6rz.net
X-Email-Count: 36
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfCePWrg1M9tK/mzz4E8vZ5ON+DYQZLadpHsvDKxes4QHh4cVlZjUQ3NdZ8tSgFEPqmV5kjNcBCzq9hLlEbtsGwFGka5eKozFtgliN0bsYgI9/N4guH63
 G/wnTJWChjZiYNVxGOoyvAK+T6Ge1cyw1gObGAIb4rAYlCdXwWHQ5Eic4v3s40NjNTE3xu2bnCINeQ==

On 7/3/25 07:41, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.143 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 05 Jul 2025 14:39:10 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.143-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

