Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85AD0296BD8
	for <patches@lists.linux.dev>; Tue, 21 Oct 2025 22:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761087466; cv=none; b=EtPUfjFnsSXte7IuTlnxQGryhqPzOJP5sbqEPfOYOzEh6r+xphU3dyZtxWX5+WD/7fAGrRCPOEsZ37XZps+5wzm9CJkNzWfNF6kZq8vBeXvWjVQxxb6W+mFxq6Nb1+sqURxPM5e9dHxFOGS46pN9aif1gagkGjfx6GVU0Gdkmd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761087466; c=relaxed/simple;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DDeyK5q8kyBdTlmMaBo4V65+UGWR20mEWzF5x0ZoGzL/fwD1krG7m0McoZgSpyTP7cvgn9XdqMPHkqEWohfn+7Y2LWrBtouZx0KogEtnUuDAXsd3113ARX3YJafg9Yis3hjLa/xtUS58/BwZOMsGX0irChTEl3AFkitgPy51ebc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=hy7B04aU; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="hy7B04aU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1761087433; x=1761692233; i=rwarsow@gmx.de;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=hy7B04aUXm2PtF6bqdoeZHXbYBQ1ZkKbSmPXe4KOb3iWBLxay79Ky/aTVITFeAvy
	 JD/JjqPJsfcMePbEFfwu25BnPRiHsJKpakxw3NVpS6qDO8f64ER7uJE5iAg6f9zGD
	 luwBuCvQIIrfmC0m7+bALwVU4wi7L/cU2DcBqlkjSUmHoeg3SUQMEnlUvGr1emqhb
	 srIg6MSUNyIzCOZRNTBwxdjvaHOIdXR7Jy7G5jhZNRNdlMaYkS6L9bYkbV1RfIait
	 gtq4tH1QZvCsyLzkxGv3D9I1IxdqC4ZNKHADl1hIttTMjSE70APM3P3ibntFlrY9b
	 4uhndMDBv1LfRUqNOw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.33.216]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MKsjH-1usyOK2QjF-00QMUA; Wed, 22
 Oct 2025 00:57:13 +0200
Message-ID: <2acbcd59-87ec-4cb6-9244-aa184d03f623@gmx.de>
Date: Wed, 22 Oct 2025 00:57:11 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 000/159] 6.17.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251021195043.182511864@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:y13vKs8A19CBVRjV4k5d8N2DTAEH/aMYNJRrvO34aj3jxCKB9Xd
 yIQ7MfcjZ22IbVH8keEQ8beEfrYdX4XwCenco7+p631zDM1UVeHbSZQcxpA4szeT0wXfOO/
 SNPlJdW7vw6K64t50FwnHPg6yDoGi6PLVzhOpJw/8m2O7E+6Ld01pkouFldYTQdMxP5N9cF
 TXEW7sTxxrsEVANzRLKBA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:3KcB0Kc4+/Q=;Ro6RSahjcUqxzknmKiw9JfIBqrV
 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
 CBHVf/1AR9w+0x7GIgQZ24A==

Hi

no regressions here on x86_64 (RKL, Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

