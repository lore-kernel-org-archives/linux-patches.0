Received: from qproxy5-pub.mail.unifiedlayer.com (qproxy5-pub.mail.unifiedlayer.com [69.89.21.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B09B15AC
	for <patches@lists.linux.dev>; Tue, 13 Dec 2022 02:51:49 +0000 (UTC)
Received: from progateway7-pub.mail.pro1.eigbox.com (gproxy5-pub.mail.unifiedlayer.com [67.222.38.55])
	by qproxy5.mail.unifiedlayer.com (Postfix) with ESMTP id 73C92803365F
	for <patches@lists.linux.dev>; Tue, 13 Dec 2022 02:28:20 +0000 (UTC)
Received: from cmgw15.mail.unifiedlayer.com (unknown [10.0.90.130])
	by progateway7.mail.pro1.eigbox.com (Postfix) with ESMTP id 7A3AF10046174
	for <patches@lists.linux.dev>; Tue, 13 Dec 2022 02:27:44 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTP
	id 4v1EpM3GGPmV94v1EpRwth; Tue, 13 Dec 2022 02:27:44 +0000
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=N+7fP/bRQQgVoPJvAKgSsxxh7fQbFWp0IBG6nzw7i3Y=; b=F/P6gbS1Bsz4nLUUFgZ3qHNoj6
	q9esYckOKdXSVz5fOxt+tJ2U5gskUT2DMQrWDq+WXblJo0sdjY4VUmB1ykHKnaBa+4kLT4ZyptuSk
	28dA2gAD4P2gIU4/xdlXUQsIghBKbh/v4RefJzam12KWO13FK/Zw47SzFEqtaB9MSqobG7rOIwTVO
	FLVNIRSRxc5J25XKdjUG9mHLb4fw2PKBjYxx8oXp0VWxZ6ipUTVXvNZeO0NVZHmbu+ZLoLj0w39on
	3X1Pm8l6pziBoqRwPGCitnSirC/pwcbIhbBm8Lfp8MlBEZq2RfD6iIMNUxN4Q6SqD1CJB7j/VuR1i
	Np0ajE+A==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:32828 helo=[10.0.1.48])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.95)
	(envelope-from <re@w6rz.net>)
	id 1p4v1D-002qgr-65;
	Mon, 12 Dec 2022 19:27:43 -0700
Subject: Re: [PATCH 6.0 000/157] 6.0.13-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de
References: <20221212130934.337225088@linuxfoundation.org>
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <170a1794-ff53-b620-af4a-1e856a6c8fb3@w6rz.net>
Date: Mon, 12 Dec 2022 18:27:37 -0800
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
X-Exim-ID: 1p4v1D-002qgr-65
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.48]) [73.162.232.9]:32828
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes

On 12/12/22 5:15 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.13 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

