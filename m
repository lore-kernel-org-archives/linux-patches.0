Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F3A282F29
	for <patches@lists.linux.dev>; Mon, 17 Aug 2026 15:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979373; cv=none; b=Qj5Zn2zKP+fgsbE4OW4mV0rYfbG4ylOIXJFnaVXSluKnoh84wYgiNb0S+H93gdKD20PWQ0Ycmk7F/SqZ7aN4f9EhK130lP5ML2HM+2orGfRc/yZCDegUpN6sNYr3joWl3gbd9lfW96mAPi46lumcQvG1TTOYQ8e4jEhmXltPTlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979373; c=relaxed/simple;
	bh=SSebE+ST6hsckt7BsoZWaCrfWED87E2Ve65oZGO3YSg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MRq0FgDzQZfzBrVCIeTYXIfQNpCERnbVYqcEhMYtOY2POPTBWjMrtsFfj6i2VkYkGP2cHcgDjL/4Z9vEKBYOzLP7I3R1hkKdtNFfKDUjQF+/jZxzw/pdlnz45rwYqpnm8+ByiYJQXwTP3ATzVrO8nRsXdYFlpR7108gUlLqHk7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=aPVPgS2R; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="aPVPgS2R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1786979352; x=1787584152; i=rwarsow@gmx.de;
	bh=SSebE+ST6hsckt7BsoZWaCrfWED87E2Ve65oZGO3YSg=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=aPVPgS2RbyMcTh5M/sV8+dpcIw3qWsMy9EMVouqPrgvGjWhZAM9JcMBaYoM8EneW
	 LQhEGTrwiMPqGIOKaICFacOD14OZS48+Qila2ifHAUDyfqc+tGUEpavYPV3H2MBzC
	 XbV9fKIAbknzpkMRj4VG/WVaGL4AqvLfrpK4BLuRpaJgSFyWcZWoCyX2vmhwx0hHq
	 OuHcSD6XqNx+hRPA3DHVrT4CB7SdXShx65xi6NtdZYZD4vlJhYHputXvWOI3dBWzw
	 rDIwuQ7uBGBMAnP8E4+y7gWJVzG74b/1ZxQtPe9rOqUG9vi2DRDirF8dVul7N3lIm
	 kkUZLeyyHEcGtB+kYQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MysW2-1wiSXy02WA-013yuh; Mon, 17
 Aug 2026 17:09:12 +0200
Message-ID: <08b2ca8f-154a-43cf-89c7-827ed1ddb56f@gmx.de>
Date: Mon, 17 Aug 2026 17:09:10 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.1 000/271] 7.1.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260817132536.752504388@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:YE0n+pWb6sl8hVyvq8uHLgT8zlha3O5ixzSrNDoR13+aW5PpYPP
 4/IoYAmbXDrSSKDiHL4bnCFIQVyEJrb7lw4d5KBxTL9Mk23OxjJNCQodMSx6FsWTQ48xtVR
 wAOiY2evErLfP3VrYisRxFheay3IBqXC1CIIHf/moa1iKn/YtyW+Nrl40g4L9fe6xDqv/zu
 x7lwJznraC3cvQHvhYFdg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:ynEAZI6SQ1w=;kb9mAS6sSpUnbQHhzFag+nYOWqV
 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
 zxw

Hi

kernel build / boot test on x86_64 (Intel).

No regressions here.

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
