Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D0443F095
	for <patches@lists.linux.dev>; Thu, 30 Jul 2026 18:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785435802; cv=none; b=ao07bK4WEGWncimstlM437xkpkaRmoWohW/7QyIu7IMz8VWxWeTIlrw6eaPTtqIaUkntoQ/EeYbPbL5U3qEL+Mzvu8Y4GJdWbgJMb5pLxNgnCgDe43MyJDsMPOllaaf7LmgAR6lgEvoZrzaffN5a2SW8Xbqsx6G3Sx78U/kW7/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785435802; c=relaxed/simple;
	bh=xCJhnHpVwOTvaL/DW/gllYM+iIXcd40BoQJSe+AulWA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QisKp4iwHfk8Z8saj0rkVxb0SfyRwvpTBAyD2fhS5QiJo0XXqG3v83cxJQiWhWg9TR22GnguWKcezmbdRj9J1J//PWch8JSrtqfh0OgngmoklWHBKdzI1DxZGn1WrSXx24kg50ZXWM2PoODY6hTC8mw0QZ6uK0NwHeGbWH9WbEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=Wtjh4vfF; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="Wtjh4vfF"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-495590dde14so887475e9.0
        for <patches@lists.linux.dev>; Thu, 30 Jul 2026 11:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1785435799; x=1786040599; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DqfbmiEZ/jbsyui/HXGCKKp3cbCCYufKhVYiKs6CwOs=;
        b=Wtjh4vfF02S6WBew3gZmwoYT7uq1Dq38Sp1Gj38AjNY8+XIpYIUDCRwgdkcgvr5oUW
         OYcTKdmbo2YQAKzGXhU5zvplxM0hM2IzRWrK6De+0AVvjHPwqbZEJyMZJwxlrPXwlrjX
         TG8uxtvGO0+UVOT9kMkf37MMftQqJLwXY3/jNC3dmZYnK0aghwPmlquxQ6cG7SVtsN63
         Q5U1s++mIgdwL/viKqMZSheQmxJmzqtKiizgv9C1gIxrJoPkjeUBcQqElAv6vKQ8HLXx
         BwS5I/7vct1bBCO4kzEoRai8Jg4v8L6hjk2KR9GRLPz5MjBhAaXWPEQRRL3/YopPcpT2
         X8tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785435799; x=1786040599;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DqfbmiEZ/jbsyui/HXGCKKp3cbCCYufKhVYiKs6CwOs=;
        b=mgaQYQ+CIrDa/iACCBcO6UutP1C29WM5ary37WkeX2Iekfsn6NlL6DHoFFEWDgKx4I
         H3Rg+o/UwxMiizDeXvK6twx2NsVAjmrl9PzacQJ2+RVRMyTRxs4i9pCU7APK1oLigFYF
         qMgaWUcJBP6c23GIQg5rpL1PG8gXoOdd3Z4b/hRYEuodydKIzUOCKyjOLaHD+Eh62tU9
         Mdlc0xCRjaQuj/2/PLvRBEXwpmBNhjRMs2B7JiqMM6ruMHZ4Kg18NHE1/Lhp0ws+1SiR
         rTL7/KHEHvtf48GlurPH4dMnUB+TX9QA46nq4jXjM8BTtuQATdi7QOo6+2V1BPkphwh4
         Xmcg==
X-Gm-Message-State: AOJu0Yzjiz8g3atMmuK82BXcIPid8grnTpI5ETs4rkJQGMOV6/QZksST
	ptvTMoGt9if4Az1omWVYx9uOWS1Pw3fAbnYlt6/lwIbziVw9BvK8VjE=
X-Gm-Gg: AR+sD12ozAtpCA3RnYrgIWOMJfScNkvjgiibACVl06Z6bgUFw0zQGfWhT3h11ASyb3W
	Vo4WzmYNGiEJWialWS6N+H8AH0vEELCSQQu80iNaXCMSSBTrBn1bhRGe1ft2E07cznEdjk6mKS9
	UuahSGrnCH8Y0REowUP3BC3sM68tmBNI3EhhYrlD1i9J7JKdj75EkJRUS/JEEEZ6vKkZJMCRC7J
	HPAp+auAdSxChZnyvgve+aQjDFElUww5MjnajdmOt70QEFcwbb6ASLsYubSDlpxfLiGqFTlnc19
	MPpyMmq5LwVld3BySMQ7rzIMFBz3SuyetllnP1UBShYi5exkOQl5y+dFeCG8ZvTsWaNDWad1RPB
	6W5vjtpkZs+eXycZMBkHzapjMxzuE3Hoo79sCMQe7wOSlQrbtHupucaQFC9pLB1oi1AVrnHOF21
	7bKjAfQXWMiGtbJcqEuMAD4WNxXO1sP55X5y9q5YblFxspdJhmjd+fa0sCLGjcF7PU6/Pwns5Co
	aEv8FWhuxGg2REB1r40o5ROnTIbsa+U++XluiKAZQ==
X-Received: by 2002:a05:600c:4ec7:b0:495:6934:414c with SMTP id 5b1f17b1804b1-49804c531bamr23186975e9.19.1785435799385;
        Thu, 30 Jul 2026 11:23:19 -0700 (PDT)
Received: from [192.168.1.3] (p5b2aca7f.dip0.t-ipconnect.de. [91.42.202.127])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49801216694sm72464365e9.13.2026.07.30.11.23.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2026 11:23:19 -0700 (PDT)
Message-ID: <9ba2d3bd-593d-4d72-9654-5a6e4d76c0d4@googlemail.com>
Date: Thu, 30 Jul 2026 20:23:18 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/484] 6.6.148-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260730141423.392222816@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 30.07.2026 um 16:08 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.148 release.
> There are 484 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


Beste Grüße,
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
