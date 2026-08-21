Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF12434E56
	for <patches@lists.linux.dev>; Fri, 21 Aug 2026 23:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787353836; cv=none; b=H8Elyd7suTj8vQ3l9O+kjU2biiZ1Wr4SUXWB3te84GaDXOoGys4CbS3KPVlReYWNWxuY+szt4vp1CpSAipjcjg+ubn+w+Ko1ZWlsxrkIOqAja+OOoKEtT4gQbLCEtHQUWk22GImoaZARpxWicruzJu7WZm4vgzI2saCcOq+z3As=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787353836; c=relaxed/simple;
	bh=Xep87mApWHzd6PbNdGYErtvDfuTFljrhRU4oL34+25k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VCcT00tannmh+iVEGupF3Im8G9PFB0fe4RzTvLBSoY/dDgbJexC4ewWzh7Hx+JgYghxBYXASYVtBwsh82FF72Mh92CfmHx+YIOn9YNc5fCmEm1RTQmaA/mRlzTp0HuD4Bla6a2R8LWgJwGyC6QZVlh9eACGPlqWve8PHFM5Y83A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=ESuRtsV7; arc=none smtp.client-ip=35.89.44.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="ESuRtsV7"
Received: from eig-obgw-5003b.ext.cloudfilter.net ([10.0.29.155])
	by cmsmtp with ESMTPS
	id xWy5wgob0hJKMxYNfwPsVE; Fri, 21 Aug 2026 23:10:35 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id xYNewjH2NlkAWxYNew2rup; Fri, 21 Aug 2026 23:10:34 +0000
X-Authority-Analysis: v=2.4 cv=dbGA3WXe c=1 sm=1 tr=0 ts=6a88daea
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=wW6ImR35bRNOjldo0A8A:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=SdAFuoOiN4r9DUvE0TkoTWOeZqmSJCBJ5YTLT0mQ88c=; b=ESuRtsV7KQZE0wWZ6SvpwPep1O
	RkRYvWG4VqXD7Y1fRTOYGysdBfW28BdDva3fwtKzb/Z6dqeVrzmV+NHB/ZiSVVgwOuSmp1wYo7vos
	nwkIs3FdCt7HVLFZ7xlzvtZsJJSLcJ9nxNtrwQTV9nA/Ma8UgQ+6fpluafnyuMIZCQH68dF0fPTxN
	5WfXKinIzDVJMPL/7pjPpq+KJUw5xr/l38X4xsEhYOS6GK4moeUaNgkdpZe0MOSfvVukoma09nwtk
	iphYPAisDyuhYLhqHx2hOU0wL15vrw4zfjOFdb3m1yRId1tfgA42KUbRLPmEJqqne4AKrM5BNLJ0+
	riVTBiFg==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:45276 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.5)
	(envelope-from <re@w6rz.net>)
	id 1wxYNd-00000002ZaN-32q0;
	Fri, 21 Aug 2026 17:10:33 -0600
Message-ID: <565ad2e5-a2c4-43f4-9703-7232a6be31b0@w6rz.net>
Date: Fri, 21 Aug 2026 16:10:32 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/272] 5.15.217-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260820145231.229664293@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
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
X-Exim-ID: 1wxYNd-00000002ZaN-32q0
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:45276
X-Source-Auth: re@w6rz.net
X-Email-Count: 38
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfLuygRmisB6xQLZ9ke7GxuWFJITBgazXZZ567/UDej4NmHLLbGKqJUOjsF8Ri2fJWJnpn7pONO9Qbt3DExeKphJAH+47GSrETIJb7ohSDhyFgoeUQ6fF
 KNp9/QjqE+ZZcrOdqi4XBgU/CdHSe3z+BArRcdED3IbXiNxz+LWQZkSjYREdYCu4ryJapIilfAR59g==

On 8/20/26 07:53, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.217 release.
> There are 272 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 22 Aug 2026 14:51:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.217-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

