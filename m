Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0C4803
	for <patches@lists.linux.dev>; Wed, 13 Sep 2023 02:42:37 +0000 (UTC)
Received: from eig-obgw-6001a.ext.cloudfilter.net ([10.0.30.140])
	by cmsmtp with ESMTP
	id g4HUqRJHZQFHRgFoKqSYzV; Wed, 13 Sep 2023 02:41:00 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id gFoJqtvFdQUPPgFoJqGPoF; Wed, 13 Sep 2023 02:40:59 +0000
X-Authority-Analysis: v=2.4 cv=eIYAMVl1 c=1 sm=1 tr=0 ts=6501213b
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=OWjo9vPv0XrRhIrVQ50Ab3nP57M=:19 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19
 a=IkcTkHD0fZMA:10 a=zNV7Rl7Rt7sA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=504k68WCX5tYkObjFpkA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=WkCiSDofcRtH4Hj4Pgo6OqgDxOIsk2IWwYXJTpQIvS8=; b=NwHcIjYd7xuVARkokso6gURETd
	C0cz81miR3vrMBN0coNAM2mnTdktfQ3nFffvH65QHz2qp086Ns7OCUzOpcrWa1J/1ceGc/IJRqEMV
	pH+a7aZ08MGuVp8o1PfzLqQ3JC+ND7OeqoZQwZkakXC54+5mZlmS8L6hN1fchRA/HHLUQ18OcPu6G
	QtFtYtH8V7b9JUfyxVPj3IaNQeZWgZiWuTzTT8wizuxh73X2kMbUqgibfsgtS+llL2C9fVfdiCybc
	SGYAXbqiGTGbzuiizDb31A4gYyAgJC1dlVYolo+0ThnZToEtASEHKZST57/1UNy7I6yKzkUbTo8GA
	e4u6R5rw==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:55190 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <re@w6rz.net>)
	id 1qgFoH-00083B-1A;
	Tue, 12 Sep 2023 20:40:57 -0600
Subject: Re: [PATCH 6.1 000/600] 6.1.53-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org
References: <20230911134633.619970489@linuxfoundation.org>
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <57ea9454-dd92-9a67-6947-5ef958a6f560@w6rz.net>
Date: Tue, 12 Sep 2023 19:40:55 -0700
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
X-Source-IP: 73.162.232.9
X-Source-L: No
X-Exim-ID: 1qgFoH-00083B-1A
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.47]) [73.162.232.9]:55190
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfKKMNA/gTvikWidnhS0n082FUpCdF2k8z+VcuW7/dQAreCmxmlqLYDX27ZBhEDD71qraX1qaDxn8Lp1UXtPOlTNe8mcszibtuoDQz1tuYkC9vVUTFs4w
 eIxetnjR9+GBVpK8n3jVx55SsOT/0TXH7K/s+YCVZGCByIscNYbY18BQISpKdEGxDxVshbTdl8BfSg==

On 9/11/23 6:40 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.53 release.
> There are 600 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 13 Sep 2023 13:44:56 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.53-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

