Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030BD35AC18
	for <patches@lists.linux.dev>; Wed, 20 May 2026 17:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297634; cv=none; b=IQ6CPLY4pLk8qtszLK+qoAdlnqMENoAeO+dw5FpOZqcGBAAyJ0KXoFRM+6RTMyu53KG5P25uFnMv8XKiV0wjfhfvpUe/6mMJ31buWYuY4fwYS7XbnzikU5rg/WEWiwIMZqAwarTYbVUJ2fjCighS2uwovx+XDztbEwPinkKFa+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297634; c=relaxed/simple;
	bh=Fvlz1dUOy7ZFO3An+hQhHRgsq1GAZhXCFEWTsYxWw4c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GLBkLpfnbIUbzl0kz3eeDK9PBQxlWwFYZaEfbS1DnbIlsA/ZjVtPTCKCvVGVAYYFEEusbW8jUbqaXoC994dwNoBslRy4LixR1VC74bAqgyDZTUOIAYn45Z+g/SUFa1r7kzQL7KxJkQ9U3IBV0egfJPWyjUDG/iVqWgHM4O+UnFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=sroCoJ0N; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="sroCoJ0N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1779297604; x=1779902404; i=rwarsow@gmx.de;
	bh=Fvlz1dUOy7ZFO3An+hQhHRgsq1GAZhXCFEWTsYxWw4c=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=sroCoJ0NGzJCpfB5Dt1mQ/jDtvB8U2TCly33rJ4XB2Oe2BwLRpUxuW1RJTPfvStt
	 ijv2E9qBTLps6qOAMiTXW988qPZCZDysV7h1pqY5rg14sSqvn12ofaWov2VrMNGH7
	 WqJkUdnvOllQJ0NqXXr5153kETui03wvhWneWwutlrA5q5I+WxkV3c4JfZi8PfcRg
	 2+7h5DclA7K0IbUHDNG2QoPLMz2bjQR1kwfUHHlHfvQF3VxhXvmqmnJjgfuCYLUXI
	 soa4A1Wf6WAslvEksRRNPm7MZsVIOpp+STGhBhi+DnB6vQHEyauv2h1mseOfXyVfB
	 lbJJQEoyehA6CKlCIA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MyKHm-1xHRfs2r0O-010fkO; Wed, 20
 May 2026 19:20:04 +0200
Message-ID: <865853ab-206d-40c0-ade0-9ca8a257a096@gmx.de>
Date: Wed, 20 May 2026 19:20:01 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.0 0000/1146] 7.0.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260520162148.390695140@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:hvvN/0i3VOcTJw60IzssBpCHCTtIvPOjbKvgQ/PKqq7Y9b99TDp
 UNz/0W9tr5OLlC8mBTLP/6L+DqqWJ2me3pVCw+vR2kSOssciK1pgo2sjPf9Oxa3B5Baxi4H
 HcM8O0kHRGRb7gRSdi0SV1tRFzZ5uGFZvDR9+j+AtggFVs7w5pOKdvqWQ5sJl5apIxcU1nC
 6MFzv3soYInVxeWNW+IFw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:FyQvHeBxTVo=;zfizb2uiOT3LZC8z4fksHVMJ4id
 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
 0HTUfW58V3OuKa/uMWqoXuOg==

Hi

kernel build / boot tested

no regressions here on x86_64 (Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
