Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C393D525F
	for <patches@lists.linux.dev>; Wed, 25 Feb 2026 15:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772033012; cv=none; b=aMhpoiNhi6I68RzCWInwxdZSzfred1i6z6XSWgNUnxFxE84QdWjpaA9FhgROGs/ZiDtC/yJG07vhd6eNBswk/g6wpNmG8cf3gPZz2/ZdnsytOue6Y94O/YsBmTJ/bxqQ7HyK+g++tsOSPRAEOtWSw8x60SPRY93saNkfEObfBj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772033012; c=relaxed/simple;
	bh=1R+q0brxT5FCSRMOO/LqKS2K1GLvRDjYnI692aiflvw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Zfe70EGantuaVJs3uAP5TPBCUFXgfEEGDNGUvrpEmAld/sy+ZAbwG901R6nfUFyqqb6CDzCcC+J1TKYmY/UPC4YuCkMcTtoeM/i4zhIywyHnT5LLTXX4hq19uELY16PU7NfpNLAQoPBGvpS/Ba7gFrwnzQCqDNbOnVln+sC/eew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=CTxCXBeR; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="CTxCXBeR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1772032970; x=1772637770; i=rwarsow@gmx.de;
	bh=1R+q0brxT5FCSRMOO/LqKS2K1GLvRDjYnI692aiflvw=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=CTxCXBeREbYxpPEuY0kYhqtEHzRlRC4fN5fIOEnpQl3Njbc2Mp20bx9OTA73CUTf
	 riOu2NiC97fNfIiex7F8QI4441aVAbTIA0WYy1pVBOHU5kMgNvEIL4jV4k2SF2clM
	 W0hfvtI7mGkNdZjO1W4NTBDUlJRIJKSDU3xZ9fm3YVGJDDVe56wwYPBpKDQzQCgpH
	 6uuXhbF9ydvJigYIjCcTSWRgDuVSkvcBe7W5qfDgnJl1wITMyKTH6loc4xlouGFNQ
	 uOvveuFUFgEN8ga24mWKl+HATl53y26MDxfjteNtpryPvrC3/kBI/KaB1KLIHWcgT
	 Yl59udiwOkUMiOVHkQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.34.196]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MWASY-1wEbrs2bb0-00HxYd; Wed, 25
 Feb 2026 16:22:50 +0100
Message-ID: <f293295e-718e-44e4-963a-5ff449b238fb@gmx.de>
Date: Wed, 25 Feb 2026 16:22:46 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 000/781] 6.19.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260225012359.695468795@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:toxi38npCJhzhyb15vvBzYV/2Kb3Xn9kFLleRjj2y5nmitq4HLd
 IkckTVrfo1YeC1l6inD0aDMbEQ2alj+ZW9PlCwJemvjh0v/499KBssGlmgeE/fsQ9LNIBLe
 YV+uXK5Mf0NoqFmRsw++WXTYsyZYIYosptVPSwbsKVMpLo93WqgkcRPd/7qoxavO5YOnYdx
 56C6DN0V56evV9gJ3f0hQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:+2y516H32bk=;qi9B/Py7gi3xS33+LQscQsy7UwD
 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

Hi

no regressions here on x86_64 (Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
