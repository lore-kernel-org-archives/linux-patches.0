Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBABC3AFAE3
	for <patches@lists.linux.dev>; Sat, 17 Oct 2026 16:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255654; cv=none; b=VWUV6Pj1ERYU7GO6oPjGesVHM01yFKXWYOioTmU2ckybmGEWrs7lmne9zQagPCyZBQGjbnOXx6tXZEZygvuPCC4SslMoRQG6Cc24r/nGrAu4/MK4zYkEPvGErRAfykGGttavrl2x6/wURFkjEyN4hnREBjj8LCOvtfB2iepGrEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255654; c=relaxed/simple;
	bh=SSebE+ST6hsckt7BsoZWaCrfWED87E2Ve65oZGO3YSg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UMOINsLuLaVrVg8G76WeAAs4PpejfKavJUe3BlAsHVKyXpPE4/JkqKi5LzOtlSB5HmhnB8EOcPitIDP3vBjBIjM2JQtNzphebSpl+hWEZ84vFoJda0dUaYqoaR2wuIV2o2GEWYMZGTwL7k4BPPWhGLJmRsfUoQrNrFDRsJlM11k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=U8rtwGAv; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="U8rtwGAv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1792255627; x=1792860427; i=rwarsow@gmx.de;
	bh=SSebE+ST6hsckt7BsoZWaCrfWED87E2Ve65oZGO3YSg=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=U8rtwGAvlVYMP2T5zBk0RiCDunb2T63pYlYoMBSWymfHUW8uHeW928rXinPl5D4a
	 QwcsN7ow9olJsZiholYg3DbYsUVx0yDxZ3By1gEgegBtF6dqbw2O//HKCT+ZZ0pEO
	 N/SxBcutMZ8prla974mG6pxG7M3KQ+F+329yZZpqMzEqTMZAXVF07zqdpDXCdOSay
	 sIYx3c1Zv3Jc8OnXG5nutRJjihPR/hQ3vZnsdcSaKtAcmOeG9s2HP5kJpY1DVwIKE
	 dqXGj1e4eGGy3QH/HiTNybcErMxTCbOHwm3dNNxtCsJiTR60Q9YJeQvupasGxBSdL
	 zKbmvDcYpflIBPOdMw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MvbBu-1wRnae3GVS-016MDA; Sat, 17
 Oct 2026 18:47:06 +0200
Message-ID: <f740160a-8ca9-4c4d-bc42-a0cead5d0a2c@gmx.de>
Date: Sat, 17 Oct 2026 18:47:04 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 00/10] 7.2.12-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261017155059.698368299@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20261017155059.698368299@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:lV0JbnilSxgxYEDA7pX4G7qvedqmMoBMe89adxKUuJUzijZLNMw
 FjfEIOnG6YXDz3Gqo9xz++iT8666XldIP/XPxXYTre75tiRfqsGMlWpBoq2by57nPFlD14y
 RDHie6f7X/oDLy9vkMYbC3RxEI28cgT8A5CkUumPS3f5iRVyPJegPC2XLRZQjksFq/9sT4U
 dFGy4syJsGwq1n5K7ffHQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:oRoPR6nfV4E=;S4mbD1DJTDHRoQ8ZIq5JCuwymfK
 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
 ST3Z

Hi

kernel build / boot test on x86_64 (Intel).

No regressions here.

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
