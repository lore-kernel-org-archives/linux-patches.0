Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996083D7246
	for <patches@lists.linux.dev>; Thu, 15 Jan 2026 17:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499813; cv=none; b=E8tuFoFHneC7kMzcLW5nISjx8nAlEb74dTfFceQeBZgVv26CxNSGAR85BYl+12aS13n6nDUAQogWKZGCown/yWest2K8B4KhGiAjUSr3do5/n5qlSpAUzm71Hx6sSVd15hmwA7yIpPwu3wJ3j2pNegwPtyU8AkH8RAXPpVqA9sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499813; c=relaxed/simple;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M1I1k/vovj4Q99fxzJeQ7uTt+u3NX4LWtSvG3bbknfhmTp9/IDCiOK4npocufpMzY0FEEOQtdZl+jMv0Xo/DterpNf7LHbHUbrinWpqDyeqmNxYVC4yoLe0qDUyHcODZ5eUppdoc27oYJrXTA4gxEvrQdGJADjKTZt9DVmN+tAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=WJyQbtAK; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="WJyQbtAK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1768499779; x=1769104579; i=rwarsow@gmx.de;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=WJyQbtAKyI+GaWGk99SGrjiEpoT1ipKv38cUIPP9amBblEN1OAK0tZt2D/5j+jXx
	 b1i6UEV1iaDN4TABh0SK+DnBi4M7Y1fhKmrXQO0mVO6ETSQQF8FdoighCj2mH9cag
	 2rOdfigFqjtM1TGO2JXBAdPEqY3ADUK1RgtFlrFG4KR8/aPZ7jZP8RmGTLbSYUn8Q
	 3H7wBVwSdbx7+yul4PXzUZgKD+1YGbmTN40WcHdJrxF2KCJXTMakXevbI0g91LB6T
	 yRz6Qw0m25s7q0ZF9qjmnh/crT7YoZ6Y0mL3/JODZU9SRZJBYwXFL/euEx6cmGDEQ
	 KPP35GzTD3N3b1Ll4g==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.35.82]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N7QxB-1vsSEg1Tpt-010UgQ; Thu, 15
 Jan 2026 18:56:19 +0100
Message-ID: <b0a7d3cc-2c3f-44f9-850e-7d08658ea79f@gmx.de>
Date: Thu, 15 Jan 2026 18:56:17 +0100
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
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260115164202.305475649@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:6FNhzW92prKAzNmabWeUY4MVzEFrzPxOF2kRUH6Tpe7eYt34v6x
 xFiNtZfphCTYjrGOTesVOg2UwXY2ycGX2pOHQb5fZqZKKistC9kRAjM3pH9PqTQQpuTYvT6
 sWVuqdM0lY9MrO81n4+A73X+g5Sl96+K23K0Rg7Pif1TG7TOm4i8MLvxDcwk2fuDCaEilH2
 MVFizHU2xN9MBOUQ6vUhg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:PL9lPYt+3O4=;M/zuZmCOZS9kuZfmju+kuAVcEzm
 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
 ruUYW8lmXDhwayMEvtsXuSSuMU=

Hi

no regressions here on x86_64 (RKL, Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
