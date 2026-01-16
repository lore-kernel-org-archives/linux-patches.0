Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A752313293
	for <patches@lists.linux.dev>; Fri, 16 Jan 2026 09:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768557419; cv=none; b=MvqaSdsVSog97E1y7MhFjFntxMcQyMi3CEp5iIfFzxizw/WVjQ2hJE6BrzZMJWXN4KEGw24D96OQ3x+nWok9cNEKIEbdiyXvDF6yn6LMhvqEmqKkMp9LlWiZPG+RXVdr+BQx91Wmk7jf8O6OLlVshfSLCECFqYFjqwpmKuL6nN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768557419; c=relaxed/simple;
	bh=I4rDDMbLLa3iKeu7sFsJWr9blyUrVMtreTK0Aptvy18=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dPYK2N/07yLy0FoA1UoMCMnMIjE2yJI/g1N3VfBy0wGKAdgN1DRel7e6hQu1y4BX4HU4NYQqrtnon2WVrei5nrqI6ttOJ0KWbwPTJuXlFcwh9kM30ryrod32rORQpRCulUAL+1rV3yMJs4imCzdkA4jXPx60GsCQmAvipWy5jPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=wA3nqvDT; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="wA3nqvDT"
Received: from eig-obgw-6007b.ext.cloudfilter.net ([10.0.30.166])
	by cmsmtp with ESMTPS
	id gVquvl0XAKXDJggZcvgNly; Fri, 16 Jan 2026 09:56:56 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id ggZbvhkjhh8QWggZbvywn8; Fri, 16 Jan 2026 09:56:55 +0000
X-Authority-Analysis: v=2.4 cv=Mcdsu4/f c=1 sm=1 tr=0 ts=696a0b67
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=yLgqrl2s3EH9fNXCsX4A:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=jn3QOhAKMGOBGWIh9YgigVxZOXZhMygj+Rwv8s2YbBg=; b=wA3nqvDTp2NN/ukCOMwIc3eXl+
	XHTXOCow3MtpKk+dHdnCoDNjj7rQytV9ZNAzhWV3rJAHeZLYv3CVTmlgCiKc4ugDAXL5tCgO6nTak
	YOIwiKUkQZ8RikpVJyMMf4jLNehxyF9bvBUOIr5dBba/WoAx5aORPz9T4lCyPpyJaNlHuQZhACmAl
	ADtflPozI9WBkCfzFkLTMNcBZTJCvogwDpvKAdkfDw3u1QMtfiq9n9xQz2iHxnxuy247E7aWIXgtH
	m0G63sfwW1uF+mbp2l80FkDkRpSDlztCzQl76338nbTNmanpkBpLOZ4Mip8SEKMs3AUxEXKB6qeSl
	KDWhhWbw==;
Received: from c-73-92-56-26.hsd1.ca.comcast.net ([73.92.56.26]:39176 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vggZa-00000000AiF-3zzQ;
	Fri, 16 Jan 2026 02:56:54 -0700
Message-ID: <cd04dcb3-276d-411d-be15-9e39e59a7a78@w6rz.net>
Date: Fri, 16 Jan 2026 01:56:52 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/181] 6.18.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260115164202.305475649@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.92.56.26
X-Source-L: No
X-Exim-ID: 1vggZa-00000000AiF-3zzQ
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-92-56-26.hsd1.ca.comcast.net ([10.0.1.180]) [73.92.56.26]:39176
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfOLuGNL6DWaiNadvEuqy+cdmSLZT5lUiwyPhSYFIO/DxGH8NTEpcjV2Ye9ffszPUyfO3O0/Ak1Hm7CZEJLj3XKBERUoPS8iegx6B1mARopXrLFcB05G3
 A2xs2Jg9fAHgyXirKvw7QLlEo88DrRM6XX12XdN/wqxTufZXjC/gncuUaSdjVFsDwXHOvDJZHZ+cIA==

On 1/15/26 08:45, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.6 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 17 Jan 2026 16:41:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

