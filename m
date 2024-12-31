Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2A81B3926
	for <patches@lists.linux.dev>; Tue, 31 Dec 2024 23:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735686019; cv=none; b=N7YXLQstM4HGcvzOw+ecthFMl4WXjq+wBI5KW6odnUawXdqs0qe3eXay8Ko0+ULwuEdIr/Qe68B12wNvU3T+QK9HUFY2CFm9xf1xaIy0f/zJ5PRCablktTjnUgxQtS7/2gQEEGKB35SCYfS/lySGOncr0yqIS62WHCH86sIH9Z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735686019; c=relaxed/simple;
	bh=jHihmVRZLf1YVS19gnqBQGrusajJ9B1O/JkNrZuO7M4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LRVYeVP7m7A+8BqfjeHpBSV3Y/ATcbe0S4QwZr3L5FxoKCCewkbt4jAgvRV/OPr3VDJIyjAgjG35a019cp6gy2tr77iFhdNYUMKle6AjOvJ1HuhsJzOsff4IgPcX4hu88vnjASAcKMy/TyxH1NFMuhX0KyE0d7CGpfYy2sN7Lvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=tYx0DFCa; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="tYx0DFCa"
Received: from eig-obgw-5008a.ext.cloudfilter.net ([10.0.29.246])
	by cmsmtp with ESMTPS
	id SjDEtpdORxoE1SlDkt8lRn; Tue, 31 Dec 2024 23:00:16 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id SlDjtEjb9N0LRSlDjt080G; Tue, 31 Dec 2024 23:00:15 +0000
X-Authority-Analysis: v=2.4 cv=erfZzJpX c=1 sm=1 tr=0 ts=6774777f
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=RZcAm9yDv7YA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=hdbwlJg4FSus6MSG9S8A:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=uk5LxAx+dOJZxc0V9Wa2L84vfwVyFGJHDXPwUs3sv1w=; b=tYx0DFCaRxQ30SAVBiazGVEfN8
	UemomesOzL0/k0ekp2cgh9RB9i+AdFxHcpx3giFDVsgjwtJhygIbsQzKDRrDvh9TsXGcNnd/HuzLs
	Rm+TZHOD+0gffNA1nhEA0gpThFRzpaBimufMWkc7THgWgvxDNEh5XEXMLNnLHXq341WXyS6EFBzIG
	DWXPKn9Er+HKMDCkM6g9im9YOoDaeUxbFz/grVjM01DG7De4FVMeYpB7VZScvVZ2SFY5I1Xe18Bdx
	A5Kv3PBatapkYj+1Voi6XAj+IdBbgvYEhowFT8DlP36LWZ52p/7rKkL9NMwtI1+lxVKpieEOjUsSs
	nGlZ1f8Q==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:51894 helo=[10.0.1.115])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1tSlDi-002m17-0R;
	Tue, 31 Dec 2024 16:00:14 -0700
Message-ID: <2b1c16e8-c34e-49d3-bf4f-442462b7be8d@w6rz.net>
Date: Tue, 31 Dec 2024 15:00:11 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/60] 6.1.123-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241230154207.276570972@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20241230154207.276570972@linuxfoundation.org>
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
X-Exim-ID: 1tSlDi-002m17-0R
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.115]) [73.223.253.157]:51894
X-Source-Auth: re@w6rz.net
X-Email-Count: 17
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfH5E9xHg4E6OUvG9jsDBHplysOOpyRPCsBDtbf6TYJIXcTo/wxTpzhpM50eDhE36fTEo4BWO11TzVLdkG7W1XR2h0bY5lw5fggna1Y0HGBCfQ1V9yMyd
 VGEY3ue3I6kfzu2qeY2Jpdi1xR1tawqejrt2q2uox1dTSdaHfp/uQ9jjPXcWD6VkBOrkCtZN0LqbDA==

On 12/30/24 07:42, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.123 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 01 Jan 2025 15:41:48 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.123-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

