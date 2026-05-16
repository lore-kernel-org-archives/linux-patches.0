Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A1C35E1A6
	for <patches@lists.linux.dev>; Sat, 16 May 2026 21:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778968138; cv=none; b=P5C+cY9j97FSpWEnkhMAu28tzGPHQWI/f3HDaXUNvuL0V4CIuarocbTY+9r96cAyQv3Lmt95YmibtKf0S9StozSDFymVkslE6yvfI3kP6aA4lRevDUEvLONTj2Zv/Qk83UcueYGalD9+RUGUT4zmvB6MjmCFtJnGgj5r/b5TjNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778968138; c=relaxed/simple;
	bh=FclIENS2fxg7pWh0ItmJ+eXDx30lEd7XXSW1ZRK4Fa4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cohwkOth02aleMoa8d8ScFhdBv3winj+Mfn4hbmFNq1Dy7EE4lTxeBJ+nU/QwscWKyErrsrbfJVjVaNk0p7yhpqDFtlssM7KcUd9Mies2WHawf5J0NZIiEKcftk3o3WN8VrweHDDJAn2q5N16HvcMwP66w5scUc2j8wRFl7oS00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=TucoH1Kj; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="TucoH1Kj"
Received: from eig-obgw-5002b.ext.cloudfilter.net ([10.0.29.226])
	by cmsmtp with ESMTPS
	id Ne67wFl2w4RkpOMsMwyby7; Sat, 16 May 2026 21:48:50 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id OMsLwUU8PZYlBOMsMwaq0a; Sat, 16 May 2026 21:48:50 +0000
X-Authority-Analysis: v=2.4 cv=MJRgmNZl c=1 sm=1 tr=0 ts=6a08e642
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=k86uETLcIcJWqY6WC1nuiDctm2jq7Lj0/A/HU1EH2Ew=; b=TucoH1KjhafBSEbEQq/FeyUKom
	SxUaYz3UkZ2A4EnsNmglqHXz+QRPeXJEUfQzFInAUfe3J2y+d/zwIdG9NG1ud4Yf5XB7IgSrWM6Sw
	Oi56X3kp3rKcxdJ2diBLNqlemL+UNHhsvs+RLwmjnIEoDeL1d9bP+lluNm49B7NYWgU64bpedvlhc
	XGNGesxfqUOldmwWojrcAMNiBOhYUbHLFpWbcQDZBxbBjAMXOLQMc6rgghz8x09u1BSvWr/kWUjWf
	uF8LtpgV4bw7Pkv0KB8NJeZu3nBGQKAulnoOKLOmkB2Hhbje15X+OO6U6xeeRsGeRNEB3ScgOwkPx
	3pA7zb+A==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:54378 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.2)
	(envelope-from <re@w6rz.net>)
	id 1wOMsL-00000002kfR-0dnE;
	Sat, 16 May 2026 15:48:49 -0600
Message-ID: <c8335086-9669-4b1e-aba5-d0694255c4af@w6rz.net>
Date: Sat, 16 May 2026 14:48:47 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.0 000/201] 7.0.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260515154658.538039039@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
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
X-Exim-ID: 1wOMsL-00000002kfR-0dnE
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:54378
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfJjtnEjfhtwsuHGe5l01vYCp4aduGtSi4x8MbFVZR56lKaEvE3L3N2A6D0e8U0admufVSgGbL/ik6i4GLLEfsM1yJZrTzoF6sC19ob2FKCJ8YJWtL0vX
 OgwxjsOQ5yRivR9A3oymnikV/D4e+oWgBoWACwzq6p6evcas7vZ13GzF3Iy0H4WxoL+T4IsCAY/+zg==

On 5/15/26 08:46, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.0.9 release.
> There are 201 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 17 May 2026 15:46:37 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

