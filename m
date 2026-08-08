Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5792F0C62
	for <patches@lists.linux.dev>; Sat,  8 Aug 2026 22:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786229566; cv=none; b=o8V8zhE95ybJxi82SQZMJ7F1DwPBnOzyVQcPo699eZet8AUSQeOcrZave/feXiu4MZKijBuSUGkCLXerS2EeJ3PCQjKPqixwL/FN7DbcH0+4hP2MIb+TQnxmUwcm19xZey8Cm0MjF2ft2t3qY4mFOBAxnEOmsTjBGflG1xv/aLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786229566; c=relaxed/simple;
	bh=K6Pn+rPb2s7BlongMO6KCKcvNDiUEQ/pPrgH3kNEhTg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oMDqdx0AHlUgPBv7zFSAM8OHLLMvaW9Sgf6vkbUJwt737IoLVy21qV9y2IsMsCp7/XokQpA8raOUTyL8m6pNIZao47UK17vMDFiuWwJVId/elKnopKC7I/jbAWfrluMAS1UkEas5SaBPAxDB8G8G3TfiYk9Ng6QcRUWeDxvHBbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=YZ443aKo; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="YZ443aKo"
Received: from eig-obgw-5005b.ext.cloudfilter.net ([10.0.29.189])
	by cmsmtp with ESMTPS
	id sodIwfztCuFzgspuGws5Ua; Sat, 08 Aug 2026 22:52:44 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id spuFwelCTFb3lspuGwS356; Sat, 08 Aug 2026 22:52:44 +0000
X-Authority-Analysis: v=2.4 cv=Xo36OUF9 c=1 sm=1 tr=0 ts=6a77b33c
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=H6oE9ECGMSqyuQMmobJdeKc+B2L7kEbKlbU7c9ENX1M=; b=YZ443aKot03NEqELfSXyXfA1ub
	mATjvRDm1HkG4zlcMHfA+YYRtoeYuo79Rpsv2M7vUs4Zhqv1sj4457KECF0IuIVUpmCWw6lzaeniB
	qCsSAHnFY1WbfNyMvjk40+eIWRXp3Q04DzJnRJoZxYQWRdzw76dEPTQhrfyjxcSeXDNsRqvC8Ly1w
	+gWNn93sI0C+VfkH13iEWuJylb7MpHWLlhUFdHZ62ApJzE050xTHJ9IvvWreF+PknPFRwgWnlgVtJ
	6KEHs6JsbW7XjuD2+4Lj/QARcV84uXqVpcdBEDf5BjS6YW+F7/12OTGRyoXcsMOV236xXUwDJM4W2
	LX6Em+lw==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:58536 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.5)
	(envelope-from <re@w6rz.net>)
	id 1wspuF-000000035nT-0woM;
	Sat, 08 Aug 2026 16:52:43 -0600
Message-ID: <c142a0d7-e722-4a54-a1be-2cc59d14b9be@w6rz.net>
Date: Sat, 8 Aug 2026 15:52:41 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/337] 6.12.103-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com, Ilya Maximets <i.maximets@ovn.org>,
 Pablo Neira Ayuso <pablo@netfilter.org>, Sasha Levin <sashal@kernel.org>
References: <20260807143418.516897842@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
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
X-Exim-ID: 1wspuF-000000035nT-0woM
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:58536
X-Source-Auth: re@w6rz.net
X-Email-Count: 61
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfNo4f/6X8QwEG3H6aedVoCoAVzhUckdzuobwWNVI/ac/LYKzmTu+a+6SKgHDiSF5/3kBwkzH/x8IT3S0hfmyI9SvaxcpAI+B5TwEpsvElh0qFft1VvQ4
 sFjnR+TSKt9RJ1B+dwBK+Of/nB9hmOlnZblf1Pp0qAC/XYDH+5M83ME1hb6qV4UTG3JCyLZLd0WJSw==

On 8/7/26 07:33, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.103 release.
> There are 337 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 09 Aug 2026 14:33:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.103-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

