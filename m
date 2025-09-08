Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF95146593
	for <patches@lists.linux.dev>; Mon,  8 Sep 2025 01:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757296175; cv=none; b=MDMp2+8MZrnUWTVNGyCJECjrc4Ku3tizv1hcFIyyWXqxkKFmFeDc9xboJo20l3xTlFN/UB6JUEizbVgH/Q9TeHAKbZztq3JJVP+ggzQmOn3VpZqiJKG+pSPhuTOH5IjYj+pbB6BPQUs2FBautIh5omNtqARLNccA95ULf7PhkAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757296175; c=relaxed/simple;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UidK5SvrMisACBQtkh9MFDFb+z1g4tDD1qfwJkwp898qmCcFzZSYq+wo9jlq68ARB6A6rL+HqXNnouz01yEMV58HSIdlT5a9ck/sCicloopaEiOzowPCuW2SbY6StxjzH44cwdIQ4vepfsaAHBckMr9r38uRpjykwbO+qMqijXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=HAETxp+u; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="HAETxp+u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1757296170; x=1757900970; i=rwarsow@gmx.de;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=HAETxp+uW20B8dHWXhK2rFCuotFq1nC2Inl3iILeEQF6+AjuO0JY1Mm7YdjD8rhK
	 5RpLCn8fX0dGj6USgqH+hR+MLN4HTAzasOEX7PM0z51G4zyovdVeyh3V5BTVVgJl0
	 BSrVQ3ykGtDfdilNIAbh9p4T8Vq/nWXm/I/IfxWD5JEBo/uStLAeqeGXsns+YLC1Y
	 rex6Rr50RTbZSkJrCb4pjthHiwlKjyNlz4HuIrEl96y+D2mVBQwP4mS0QDB1JAMiX
	 yJPli7qfI7bzi/L9b770LECW1R9MjCHTPZb1w7ldlbpo2VzsBzDn7PC/TqNd+e6UP
	 TrEg1S2orqN7/nZOeA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.34.157]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MBlxW-1ujIz018bU-003qCo; Mon, 08
 Sep 2025 03:49:30 +0200
Message-ID: <c84aa1b1-8492-4090-89d6-6f68cf3344c8@gmx.de>
Date: Mon, 8 Sep 2025 03:49:28 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.16 000/183] 6.16.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250907195615.802693401@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:tYtJ0oqFxttt3K4NUam+wgPthhBwh04J33y9p3I0XiidOPq50Z2
 rS1927Ocbyr9eomTZOtuvqqhJx+FlFXuTl1vKmE3JLhvlcijH9Cbfb0ON6fcwQhfiMQe3WO
 sYOHAx6i2ypv2FjoJObvJqRPHMP49+kUkHnwKbh86vg5poHwjCRFCpZf7OC74qMdAT1Nci+
 nrRTNgHivL4HfZalTkG0g==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:q0+aBeo38xU=;yPI+pwN/eHN6IiLShjY6lNzoo0z
 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

Hi

no regressions here on x86_64 (RKL, Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

