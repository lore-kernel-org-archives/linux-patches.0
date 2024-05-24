Received: from omta36.uswest2.a.cloudfilter.net (omta36.uswest2.a.cloudfilter.net [35.89.44.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470E42C6BD
	for <patches@lists.linux.dev>; Fri, 24 May 2024 20:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716583496; cv=none; b=Af2VYLlGXXiMn3UgFtw5+lUyI4+JkbRIrwHFjxSAbbiYHZUK5OCe2GGRIaXaFCJ1VDz/uXWNkPDUlDqa3M4/HZDeIsX5koOoUcdYP/TLTGrGfc4XpOsjcQjjPwIxpymkImMkQwe4RbL1avee/2RLkZUkWIpexWhiWjBMxq+Hb7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716583496; c=relaxed/simple;
	bh=4x0p5bsNLSURfwYYVm4OqUI4PejUZ1jbNs2Y393OLJE=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=HqLPtwiv2wvAsmZj6GyrZZGEp+pX488HtQQrF5NpP8pycPB9o7D2aZe4QFdYrss8avTZvw8ooddVuWcVaARq/Ha5tO9pu5ppxpFKiYwastR+YOJI0+M2ba5/cDjZ5Uc2rNMHyC6mgzrTys4mzpLm4GxGfn1jF7+nZ3N09G8UClU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=YRrsmH9+; arc=none smtp.client-ip=35.89.44.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="YRrsmH9+"
Received: from eig-obgw-6004a.ext.cloudfilter.net ([10.0.30.197])
	by cmsmtp with ESMTPS
	id AYb7sDBygJXoqAbmXs5zh2; Fri, 24 May 2024 20:44:53 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id AbmWsmN3kuv6XAbmXsGC4O; Fri, 24 May 2024 20:44:53 +0000
X-Authority-Analysis: v=2.4 cv=YbZ25BRf c=1 sm=1 tr=0 ts=6650fc45
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=TpHVaj0NuXgA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=BXyYjBD0cXuZo9oD7aYA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=ubkw6X+8K6edrA1kunDek4yU9WxcX0prhTjNRso+A/g=; b=YRrsmH9+uS7zRqkAu4QJY2AI2e
	Hkky9Q2Onsk9NS7Jf5DNsf7cOKEvzGAYpBli5EG/l9Om5aVxVKA4NM2aRR8+WjmLD6sBK4q3JoV69
	Fxu+z7jVuYC6NMl7VpPStWJz2S0Wz7gVd0SVM+eT2dCup93mbgARVc4kBDzp45HWbzfVSKctrUjsv
	MrKD4d90eUmleK0KOT72doH6jG/qMLk40JMLjb+tEM/ffTxXF6hd8DOz/Nt7y3etwmVK58zzbUHEK
	7xH4H1ObLJU/RVh9jEdeo8saXIEhbuB9jlrW8CfhMgqfUGVcmtaYaFVh9JjEiijm86wwIosmQeBpw
	4+W/+TGA==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:39810 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1sAbmU-0037NB-31;
	Fri, 24 May 2024 14:44:50 -0600
Subject: Re: [PATCH 5.15 00/23] 5.15.160-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240523130327.956341021@linuxfoundation.org>
In-Reply-To: <20240523130327.956341021@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <cf69c5c8-af13-d381-8866-41ac2aa33d56@w6rz.net>
Date: Fri, 24 May 2024 13:44:48 -0700
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
X-Source-IP: 98.207.139.8
X-Source-L: No
X-Exim-ID: 1sAbmU-0037NB-31
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:39810
X-Source-Auth: re@w6rz.net
X-Email-Count: 41
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfCUC4I6le6u7DaJxoMvxy0UbtQnoLvQSoiuXMFkwipZg7SS58sohSARzBygS3Dg7fBdkf0O4kseGqEPHbMrHILEA0ufZZAC9Z/1uxKLJO9DtBy/a5WCs
 I78c47KtGHbii7fh0/6iE6YDvNGROQfZ2h+WO9mFkE3uo8QFsiuQnf/+wTv69ZTHLV1WTM8An8D0oQ==

On 5/23/24 6:12 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.160 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.160-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

