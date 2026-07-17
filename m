Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395041DED42
	for <patches@lists.linux.dev>; Fri, 17 Jul 2026 11:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784287845; cv=none; b=ErtEDQGBljjPWQOwxvrIROmB/sXMpzaUh/7MZM2HsCslxCIzXEEeRPFzo8uoxySLRvD20Q6zB5TEC+3wQsBPYEqKP/iW4EGS/XRxvoBDg7m9Qpqzu3zWlXjLD0Ge0YJWQ0RXZxqm/OVm4lxo9jlrojH96ySWrFBoXv9hwA2l4MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784287845; c=relaxed/simple;
	bh=SSebE+ST6hsckt7BsoZWaCrfWED87E2Ve65oZGO3YSg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z1tVJT9O6iZD8dUXlqOH4C1M/sQmrF4Et+9qIcE+5U2dBs4mtItK+M4o54VW4eUFNhKeK6osNbJnopO9myqY4WXlMJLcKjG88iOWWXuYTcpoXO58CA+IqDXjgqqJVnsKEXJXJjFnoy0u37vVnLg+yxdiZ610BrZN8sTalD8IFBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=mBNv/ytj; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="mBNv/ytj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1784287806; x=1784892606; i=rwarsow@gmx.de;
	bh=SSebE+ST6hsckt7BsoZWaCrfWED87E2Ve65oZGO3YSg=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=mBNv/ytjNbDr0wR546lzk4QG+j+0GFCVTniWUobNeHTwUoZi3aBAyEkuuNN4fi3D
	 Oldu4CPJVGYkkYIdEPDEcbLSY9cLGejKoVtMigJsDnNwXlMNDPt+KygiP6/h9X0XP
	 I6tBhlCwVe9ASJRuLHQPFiBMof/vKpouy9o0Eys8e5BrtsafkTgSfmmdZlIKVBGZ9
	 kR2xQRz4GTq42dyytEBFlbRVAYgg9gyvouoe8RxYHxcdmd0tGXPGyfGe5uCKTkpEc
	 mc3xj5Edg8OHfdfhDlYxenptPd2GOFVIHyXAPbWqfbG5Z2gTKuu+8z4hzekVnbXu3
	 upTfEwDDDkb3AjoXCQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MMXQ5-1wTzGD1YBT-00VC2G; Fri, 17
 Jul 2026 13:30:06 +0200
Message-ID: <ee34babe-20d5-4883-afad-d260dc935dcd@gmx.de>
Date: Fri, 17 Jul 2026 13:30:04 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.1 000/533] 7.1.4-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260717101912.682013354@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20260717101912.682013354@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:Vidxil+cgbvADGbC7KGtvJaPhBiVegTSCzpgT/xEeVmiktnUQHh
 CLXcsHGd70n5XoDioBDK19As8UP7aVg5P24OlHdDlMTROdCb6IHl1S39hWGAdDBPMFp3UpH
 SCP+Yty+MAWSanrH2knBfESUxSlgjab8OkToPvAZhOkGebo8Y1vRbvS6YaTn06JOOKS/6dH
 JEQlrzqkj3TaMg2ehm5kQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:mgCvTlyGask=;joMJAPhXjJqu/9mNN6OVWjXEOMs
 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
 n6+k0SHa+QXKXKwECw=

Hi

kernel build / boot test on x86_64 (Intel).

No regressions here.

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
