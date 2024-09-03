Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19DE205E28
	for <patches@lists.linux.dev>; Tue,  3 Sep 2024 07:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725348718; cv=none; b=RMWEa3MAQhM7lHuZj7qtw129l4pxlPb7Vj8G2tJM/qOpUNxebVIruWV6V0jS7X/NHo0hOoA6G8vBWrtMESe017GzVWFE1xYfWtbH9ixTAVV1uLoo+ER9IrWzmhV0AHtE2Qsr0v//RYJmen+MqwTwjPOIK8PXgKPfraWttDLAtKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725348718; c=relaxed/simple;
	bh=oaOtF3mnOGhPPknWuchy+VG4R9Md2oOdD/wELS/3P+0=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=BLtklD05XGEiS+sOE9F8F3geQ6WuSEYm0GMvVqQyHGvrXvDPR+ygZDb4AkURZ5Ng3TxikY9qeJSUNFmwL5ruF83Xa7rctXkH5D9bUKIEq7CKpkS8wtOsVXHr7BY0oPejUW1W35nzwOS5mU0HgMTfvRYnDOl1EX5d5kPCTTTsrmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=PbKTKQVW; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="PbKTKQVW"
Received: from eig-obgw-6006a.ext.cloudfilter.net ([10.0.30.182])
	by cmsmtp with ESMTPS
	id l6JBszflunNFGlO10sTLKd; Tue, 03 Sep 2024 07:31:50 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id lO0zsfs2F37DYlO0zsVXvJ; Tue, 03 Sep 2024 07:31:50 +0000
X-Authority-Analysis: v=2.4 cv=dNqgmvZb c=1 sm=1 tr=0 ts=66d6bb66
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=EaEq8P2WXUwA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=/JdGR1ElBqWoLMmUPKNOcI9zGa/tpf3safM59qtOubc=; b=PbKTKQVWWrpyNlg6JS12ZJwKHc
	bZ7Ts9OADmy3Z/xGnnnRsYDdEYhm2ttsflpkGgs4DySgvOFE7H7zLJ6lpGLETl5yW4yiprZAf9w7E
	g0O4ymuIBptQBScNGlCYtKjclHDZhpE7XT3v7Yctgc28q12s7JQSga5kiqh9kaggzOrzXsHY325OJ
	cdV3gE3W+ZFWIYaDRz8rcOjLVOcy63KszVjA2gQcyE0G7X2mLgHW7Snw2PfcpnBHTLB5ivSAUnoMf
	lqvqY0zVvzDRQHQT+jkstvYrKkAJ2hgccjiB7LsMNEYkqgbthwtzZZwQgu9n5YmSdENhjARrsFHs0
	vDKsJKCQ==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:38110 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1slO0x-003tmn-1Z;
	Tue, 03 Sep 2024 01:31:47 -0600
Subject: Re: [PATCH 5.15 000/215] 5.15.166-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240901160823.230213148@linuxfoundation.org>
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <4fbb6c1d-bb54-778f-810d-8c6816ee01d7@w6rz.net>
Date: Tue, 3 Sep 2024 00:31:45 -0700
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
X-Source-IP: 73.223.253.157
X-Source-L: No
X-Exim-ID: 1slO0x-003tmn-1Z
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.47]) [73.223.253.157]:38110
X-Source-Auth: re@w6rz.net
X-Email-Count: 60
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfGM8t+OuBH8OUZRfHFqlBLzArFxfGrvrmNyHRomkSPcOhSCNixPvHgz91g9IipeiZkCmJNJKc9BFJGYAUVqxyBjRJ1OdSatSij1n2k3QV0jE9iUpMDyT
 mx4qg7wWaVIkn+IN5uf+i8q9X0JFvo/L04cSgpy4p844xZnVAItTzWRV4uyrDs17LMdd+WAHaHfNmQ==

On 9/1/24 9:15 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.166 release.
> There are 215 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 03 Sep 2024 16:07:34 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.166-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

