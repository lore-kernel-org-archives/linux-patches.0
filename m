Received: from mail-wr2-f34.google.com (mail-wr2-f34.google.com [74.125.225.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8306A4BE43B
	for <patches@lists.linux.dev>; Wed, 30 Sep 2026 21:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790804455; cv=none; b=KhHGijFgYQx+Mbvu1m9zS9LkAiP2XSRXJUXn1SrUEfJkiS8QBeffF/ClRVqu1cjoTSsspCZZfCxklf3Afi3A4lvO537TegzgAhGaSyfqby9UjHT/eh258rZddczV6UeRnp8fKGojBrfrTZJLPmEmweAhQGM9kKjMTswxI8jK+7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790804455; c=relaxed/simple;
	bh=lu1+SJCXQ2EpuIPYLuobvbha9EEZ2hsucDtrScwJEVg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u3bxJuaaf7kH5sVaWbYUlZ8YRH5ThlaesYDXqrKjdXXuLamgb6aAn5XqORgbVlvlVj8lqcWosLReJZ8cUbAblqhOzIPJv3+o+r0B49Ouou09xBlIcviMqFh4Z26WBAfm9EkbBdcVfObgxivNka6qLmV5gaRG41UaxtYPTE63zC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=olsYzvxQ; arc=none smtp.client-ip=74.125.225.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="olsYzvxQ"
Received: by mail-wr2-f34.google.com with SMTP id ffacd0b85a97d-48b01c41135so804441f8f.0
        for <patches@lists.linux.dev>; Wed, 30 Sep 2026 14:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1790804452; x=1791409252; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PGfnmzZ1b/kZEE0OkLpLBVu8C0jcPTvby9i4SQKX6jk=;
        b=olsYzvxQcpPt2Iv8Pg3/mwm/T8B9JDW5pJwWVkiXdNRlOsM4uprNnas5YS63K91vQt
         Ya6OTkLGvvBlpv3HvisVEsQYCh80CBv7j2BPUufZQK8mF1O6UC5nTuRBMiYzhD6QBjno
         B9mGhMix+7wawcoIDZjo46Y9hIiHVBno0J1OraOQsQ3F/rR5WBbhwBOc0ty6OTQckDtJ
         fhXYNZ3V0s74Z0/516sF1woRLburcYYMj9LLqzeD0zdRU4ocdDMu9X+QHw0SM+tesiST
         GFKz8TeEG4XCKiwFbcbgeBIriiuldnVKKyPCzyBz2vMGIG47iBovgViX3MnkOCTXO/NQ
         4lww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790804452; x=1791409252;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PGfnmzZ1b/kZEE0OkLpLBVu8C0jcPTvby9i4SQKX6jk=;
        b=UqlQ8k24RU40U8d9r+Y6P0REyloiBeR/hHe8Bzmv7tc8UVh4sD0YldXo0zKbUENrI7
         mh3ZAZxYd+pSvG+jXRDGI/+fvbIOQhdqy5AN5MgJexNnjLuop2nck6tFJEQC7LImSPx+
         Hg1Lzmx136qCAu7CelXwiRKhiHZn9opKhEQrxP4hm2xzVoP1+zH9OZRe+U4SFNW8wSc3
         xPHQYdc0d5bWudl9Li+PeDZSvmY5IjxKWf9zkoJ70Vk/2C62hwALI6+S3Lfes3GQcsd5
         mxj7Suo5iLLdKEXXujUU0/3YfNpL1R3pIP/ck+u9MzRR+ptoS2hOWKDrwO0vaj2iPVvB
         4/pA==
X-Gm-Message-State: AFq9FYJks4Hmq7EJ/lUonsntzzILV0ODpZCYuu7YRM6PghjIrLSmOkmJ
	mROuxW/cPSesZaWB1jC8Yb9Vrtb48kW9OX3vHVokAQzx+zb6pmQmoFM=
X-Gm-Gg: AYBFou2TQIHhePEIngI+r0E93bB2r9/aQ2aeNcWL+f4oMx4OF/teVfb5AyuOFezbTW9
	aQcOo2Z9f35PDtdc+HE9x8WXchpIeq4Avp1kmSWSGKvAaCHQ6trmXxK8jPRiKknX+t2eixw/nho
	Vsws1X+CfdOvUjSo/hdKqF7Zn1Q4a5MVNsRt/WYOPgfAXc35K9+5xXt9c9wbIgpJS+qE0gPGajA
	nfVxLiqYeTj+SfQekUHcOPivwFitSTsZqMNxRl+Uw/0EEZ/9h9uRgeYq0pm96T5+xOU7a0rVDJc
	87R1wt4stwkpKHaseXlwa9uEffjoV94DFOWAWx77drEmKSIICBCqfeyqHf2mm/cqcATLWUICW/F
	tHHXaWwAmxHKC3W0LNxRGpBY26ABZgugPEUlY7xpcVhaGnyobONsujfkq9DXd5/WAJNapSyy6w5
	cvTwJ8YYGrUyUEttLS2EjMO10IsYuO7Q4I1Q3LCcGv8vWJE/rKhEErIVMsjVY251GgYthhq8x5k
	myST3nuR8hOOvU1n2XcIM86bBm+NfW+zIKzRPWMWtzt7yMI8iU=
X-Received: by 2002:a05:6000:1ac7:b0:488:823d:5060 with SMTP id ffacd0b85a97d-48b02544bf6mr4972784f8f.48.1790804451479;
        Wed, 30 Sep 2026 14:40:51 -0700 (PDT)
Received: from [192.168.1.3] (p5b057568.dip0.t-ipconnect.de. [91.5.117.104])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48b06a2fc98sm1736606f8f.35.2026.09.30.14.40.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2026 14:40:51 -0700 (PDT)
Message-ID: <b6209a1e-953e-40b9-a893-64a54e475728@googlemail.com>
Date: Wed, 30 Sep 2026 23:40:50 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/982] 6.1.189-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260930152416.775402466@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 30.09.2026 um 17:12 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.189 release.
> There are 982 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697v2 server. No dmesg oddities or regressions found.

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
