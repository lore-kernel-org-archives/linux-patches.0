Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC94C298987
	for <patches@lists.linux.dev>; Fri, 21 Nov 2025 23:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763768213; cv=none; b=aEoSb3/Zxt5Z9dTGyJb04SWQSBy4tY/s0RYeqZe4Ahbx3xaX0atYY2JCkqhA+pn+vy//JbfXXEPcDKQzufYYN2XpK4GS5ld+S/P/vHH4ZCVW7ypsUd6B2EKwQph5CAuiW2Bmb0iCCNZAZNJnwfA78mtzSB+beFOWOktf+NXUZ3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763768213; c=relaxed/simple;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dFZSTMlJf+FftAtGXMB9vsxCLfwDOshkkegTM3mx5l5ZEVlgOjZ31ZkkQKM2PS0CWqt5iS4mSQBCKWbFxyiFCF+IOXBn0lMFS1LelxwjLMXS3/r/fVHy5HkWEZoZyxHit/yXrvhtCIGhMuYXH2rpYWwlQM7ifVqL1p4PHusppAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=F0faFFG8; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="F0faFFG8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1763768205; x=1764373005; i=rwarsow@gmx.de;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=F0faFFG8K+C8qq7tz4NQTuU8aI9v7S8VjLtyHIiQBwFMgYx3IAzHzHrAM9xXfzBF
	 rndgiec3lpeYo90zIrpc8uR1DhdFQqg9y3oscx0KRT/fXBoiWhNg6swUL5wA0lw/V
	 /O0nYHmCDnn1YWK/8Q2GXjApE/YpiPXJmY0xiHJyI4TJ3+siz2MbYYh6w6XIv+vkc
	 nJ4QwGwe1aPNR6mrZc5nta6aZFDfIpiBvAgZF+srMQxDpm7EGc4z3gp4l7EAwYHmV
	 5RO/R143icSdTOqyAOM0g7qgEogzWWAifWUCYNfPyibildeAipsQpH+DnEv8pMjcj
	 7rSvReuvA9lnidaoHQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.33.160]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N17YY-1w76T03Juc-016Xdp; Sat, 22
 Nov 2025 00:36:44 +0100
Message-ID: <71afbdd2-65ac-41dc-a875-7702d89dc600@gmx.de>
Date: Sat, 22 Nov 2025 00:36:43 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 000/244] 6.17.9-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20251121160640.254872094@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20251121160640.254872094@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:To3bkroBWi1ENSfLDpITcBxa89vYidtPDb+6BIW9hwy0ON4xKSn
 8GnTPgSSoviccmUqcwoT8fKMEpnHUbsBXNiVqqCR1fYYgsNUc+rwZT+74AeQnn0AFknXkG2
 Bh4D4DvXdljizE+h4fR7cx0zQW0VqPq/ev4T2shYZOypbbMR9tigrRAPdlLxaJcQ2VaBwTZ
 C79ESEP/Mv3MmQM6sQe4A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:4aZPheLWxmA=;nNoAGO3i3fwFf6EZ9TOZsWwqRpe
 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
 5KEbA==

Hi

no regressions here on x86_64 (RKL, Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
