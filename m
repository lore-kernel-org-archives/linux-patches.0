Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E78E6D19
	for <patches@lists.linux.dev>; Tue, 22 Aug 2023 07:56:15 +0000 (UTC)
Received: from eig-obgw-6007a.ext.cloudfilter.net ([10.0.30.247])
	by cmsmtp with ESMTP
	id Y9vFqryCPbK1VYMFFqUXbf; Tue, 22 Aug 2023 07:56:09 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id YMFDq3gmeNdJPYMFEqZTvV; Tue, 22 Aug 2023 07:56:08 +0000
X-Authority-Analysis: v=2.4 cv=L+sO/sf8 c=1 sm=1 tr=0 ts=64e46a18
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=OWjo9vPv0XrRhIrVQ50Ab3nP57M=:19 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19
 a=IkcTkHD0fZMA:10 a=UttIx32zK-AA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=EQwu3T12zX-_ASVHoRwA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=H7+HYOErNMxVNmb4FYKHuiMVtBoeYXHep00xSz+JHho=; b=RVtiiA831CbuYK7EtJUSMqi+JF
	MFOur2OU0uDo52qhctGGiWN32sRF063JmqaX9nfWlyNMMKs2ZTxtgFL3uoaY0TcOtcvuWjmM86qGL
	Jk2CZOhAqP8+5SUIYi5QJ9yOdOn1h4aUT3eacnXC3TxQ2LDk1YuuZC90HP31KHL2alfCYCcsvQE/K
	Fb27x8nMNK1VWJ//VIs/Fs5ruIRx5sklnmRfzra5AF4pByvLhf5VweAQXk6YM8WcAcGYmVosaYYwz
	On/VttS4tIixcg011pTCy0hh4EMXKBBO6MhorFrktN2m0eiYqm6gWXYi71jmsbVqt/luMIjv4LfHd
	j9tfhABA==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:52638 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <re@w6rz.net>)
	id 1qYMFB-000UXM-1B;
	Tue, 22 Aug 2023 01:56:05 -0600
Subject: Re: [PATCH 6.4 000/234] 6.4.12-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org
References: <20230821194128.754601642@linuxfoundation.org>
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <d4baed15-d37a-0234-329b-c3b0f9aeecdb@w6rz.net>
Date: Tue, 22 Aug 2023 00:55:59 -0700
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
X-Exim-ID: 1qYMFB-000UXM-1B
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.47]) [73.162.232.9]:52638
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfHuDcOZTwHiFgm4OYUXhy9ATc1EyrlaAzDpNxpazH4MQs8RVw9rhoHJIHLcts3rRyCw5rtnYwTtw2vkJ/ldESBcv4/4ys0jOqZO1jK3aRiV8KOpBBO6N
 vEQMf2ehEEaV/beg2XEEmYWOTHqXCZsWiPYKLhD81BqR+9mg9KZPEShMBUQgk2QSzb+Sh2o1gfDm6A==

On 8/21/23 12:39 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.12 release.
> There are 234 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 23 Aug 2023 19:40:45 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.4.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

