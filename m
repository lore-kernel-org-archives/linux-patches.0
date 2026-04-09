Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80AD53BED1F
	for <patches@lists.linux.dev>; Thu,  9 Apr 2026 10:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775732078; cv=none; b=Vu+/rrkJSn+dkadckIakYksqlh9tiovV32Gi6hZ43bx9tOmtwcgTXXcrgiNJjo3uSFVN/Gm8uS43u8U6yhdpOyrz0g/EkKztpMC9IPu4km29XKCYTYWZ4QlnaHVZekip6WRZbJ0b1te+MbiQKK3tRrgqsGDbg3DkVkUINNGRifQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775732078; c=relaxed/simple;
	bh=1R+q0brxT5FCSRMOO/LqKS2K1GLvRDjYnI692aiflvw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AJ02uSNcrIvRa4D53zlDzh4KH7vWdEXArWcAkiRvI3trIzGZYuKubigzfH+UxeZ9PzP0VRfmOCM9kAib4FuBuJRVnw+VqTtSK9w1fgVsslRXw27I81R9+f2vHv20TuFnsFi8Q29xGrzqf5b7Y8R9cGNyPoIL0pdmtPB/v1dd82A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=Wh+ahUY6; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="Wh+ahUY6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1775732065; x=1776336865; i=rwarsow@gmx.de;
	bh=1R+q0brxT5FCSRMOO/LqKS2K1GLvRDjYnI692aiflvw=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=Wh+ahUY6RtMZ1Do0qnYBN4Y+q0nJGWrlBYM1pjfkBBlR9q2K94U9PZJYMOGvE08n
	 1yU2p1QOkBWRWke76WSrMHmQ3NlArR3HBMxl2XQBsN4sEMmKgNsK+aBpUHA8rxKD0
	 5hgQjaPzhSMN1YG0KOLqN219+oYmms95MhHJgVXfsihPrIEHR31dIPXp+FpDmbWGx
	 duLztFLz6xa+BAJCJ2881Nio47lfyt5dP4aFajjRUF2bByZfFnP7qUOKD3uAmGp73
	 BQq7KMBuDCfIzN/kx02QabszrJ58URKHgT9HLMMMByrGPYcjnwbeegetgAo8jX0/5
	 V/BESGNQedLVAUU/9w==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1N0XCw-1vERDZ2g56-00z7Bu; Thu, 09
 Apr 2026 12:54:25 +0200
Message-ID: <730e7298-6f6d-4247-bc92-e0cd13cf725c@gmx.de>
Date: Thu, 9 Apr 2026 12:54:23 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 000/311] 6.19.12-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260409091742.514769762@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20260409091742.514769762@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:x3341pJNDQeWG4tdwkbocXjTcYHUTnG84kfxiv8aABy2ryflgaw
 3tKhpiWm7T9IeIKjQJdm7vMltw1K64rw3/lgdNk7PJLTbKhEyg0HVQyBhetIc8uIbWl2bZd
 Vcf59ZYphPKGj7yfbQ/K9I0QpvIT+BGHWMWkWvdTPxZvmtKQnxmBTbOlJu7mvupMCM0y1C+
 NEBsnyrj88VLd4wXaRcTw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:TrnaVu355pc=;nHPyMFRpgo7pG2KGWnJKy6GuIMo
 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

Hi

no regressions here on x86_64 (Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
