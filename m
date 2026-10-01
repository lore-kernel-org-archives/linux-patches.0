Received: from omta36.uswest2.a.cloudfilter.net (omta36.uswest2.a.cloudfilter.net [35.89.44.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393D93955C6
	for <patches@lists.linux.dev>; Thu,  1 Oct 2026 10:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790850677; cv=none; b=oVJhDzGQQs9Y28YOajxaYn7XrNqmmK7bvehTVZv1LsMYGfCoh4aSKJXToUWAcBAL0EDZqgRmad8zBujV6E+ZH1FN2rPHnZ6mM5D4m7e/aUXCioknmEPnMJtrUD1ViNCyA+v5oJwKuexmkrE2G4m+kYQnBOQa2VyVTsfrKG67Bls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790850677; c=relaxed/simple;
	bh=sP/DbQmp3AVdY02b3JNmJFPkJpOWFYAVJ+aoLcNuDzc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lLeHHAwB4reWvC/1LrhQtm0am1w7wanJn3gxXIzyp6QuyTG/M9ojxjVOots8xBdqVw0vUNlAV/EBbcj4rrbPQqW9YR/Xv/DlDvNbwCKVWDwaaGHSXUasLcwNJKj8TCPESgHVD6uEKQaGG8T3zslpjkkc15+YI+8s546bRAMynz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=GEqOTacT; arc=none smtp.client-ip=35.89.44.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="GEqOTacT"
Received: from eig-obgw-6004b.ext.cloudfilter.net ([10.0.30.210])
	by cmsmtp with ESMTPS
	id C8tnx1NSbusRSCE2mxb4m5; Thu, 01 Oct 2026 10:29:40 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id CE2lx195mouFZCE2mxXkgz; Thu, 01 Oct 2026 10:29:40 +0000
X-Authority-Analysis: v=2.4 cv=Zd4dNtVA c=1 sm=1 tr=0 ts=6abe3614
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=1U6l_maTE9sjzKSKvmAA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Unsubscribe-Post:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=W/lt9wqsWakalvOip/DfM/77f/a+Tpu1hx0kRdRuBTQ=; b=GEqOTacTW4T2Z5vGWjEDBhnz26
	pMaxxu6cprKxVyDRblfzQqtWKey4cA0Vdr3Siu7YFA093VEjCYswWCqaTEphiWlSF6b/gS2sxLiln
	DdbcTWkOMdK3mCsSyFfKcUvvWUqBGL7MhaCvy5HnkTQA96FnrFiYbh1vaW4aLL03SgamUy/XEWdJj
	ThDUJtxNJYxPZHtGODQILcfeVDhOuWFOM82iH6enQC31JXQNoKoyLPVLGZBwYy0y3yi/nAWy6+n2u
	hT7FtEcEc3mNuXGfi9cmJnm+ZN63Vmp6GTpcEtpdFsKai9SHIwLeoApT5UE7ARlkr1+ynEE+D2e0k
	LWpP8ABA==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:47712 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.100.1)
	(envelope-from <re@w6rz.net>)
	id 1xCE2l-00000002DAR-0mPT;
	Thu, 01 Oct 2026 04:29:39 -0600
Message-ID: <688c0ec0-6a22-401e-924b-384758c6f383@w6rz.net>
Date: Thu, 1 Oct 2026 03:29:37 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/752] 5.15.222-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260930152358.131179731@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
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
X-Exim-ID: 1xCE2l-00000002DAR-0mPT
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:47712
X-Source-Auth: re@w6rz.net
X-Email-Count: 98
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfEa3DTx5PoLn7MvSI81KSE5kZg3Ftp10cHSDbR9IQ6I7nHexsL2JuuW2AvJTpcgQ3a9rKs/c+tiz81PccSQCutOmpYXUvQLx6x/2nX8rT4cvpWpUH5oR
 NjhydMpL7iEl2jUa6x7xeVBGeg/NhEZpq/c13JM75lo7xQx6vxv90zA7ygEnn0zv3I6HjzFGWV9U8w==

On 9/30/26 08:17, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.222 release.
> There are 752 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 02 Oct 2026 15:23:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.222-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

