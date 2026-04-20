Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D7233A380B
	for <patches@lists.linux.dev>; Mon, 20 Apr 2026 21:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776719491; cv=none; b=DiN+LsBh6vV9VHVVJI7SC+VMEsJxN4Usuey+KRxextrrBcdXN9UkIXJKGKK+hrWSM48m6TaxXF12TEaUnKe7uWGGkR4hUIoVWWNpC0/18Alczld2PCVbmuALmW3KB+ecrfGVCCJJY3fvTTCQ6Iz6FgqdiIQpc5X6LP4rww58v6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776719491; c=relaxed/simple;
	bh=gdzTnvS9DmWAOPRcBV/I51nbRld7uOjeUjuYv6BYRqQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LYx/ljwAOx+Gtz28BvrbIIRfFxA+zrMwLn/mKXRsir6MRBOjQG+2hdmRKQ7rYwh1XAF48z4GI9hg0NV37MrMBUF2BHqAAff0CgcayCPTJYSHNLAlo5OlB2mQm4ZsUa6ydtJjFnCsZ2daVke9R8CPDkY21PowoRVMDIz/tu4kHak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=K8AMQayL; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="K8AMQayL"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-43cff5dafc3so2949646f8f.1
        for <patches@lists.linux.dev>; Mon, 20 Apr 2026 14:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1776719488; x=1777324288; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+SYHR/pFJErvzIVkYe1WxM4A01QV2snUewU47c9pZOY=;
        b=K8AMQayLTlphGAQQ8Q1CyNNuMK5WdOcGfzk2DsbEpOGH9UQ+ODCwjxa19MmkPn9yzR
         844AnWG9XhC/oKECO/Scuy6i6/ur2uex7ynbsONenkbM0N1MOAaGNNZ8koMeHoA4QbO4
         4tid8oK+9x0Fvo9up0zY2ED+s57q4+Ck49KlpFm8VTRzq0rSIom3BZHmH0Mjpy4+eSlz
         sw2awd3aL+8Lngu0Fi0E9dh0F7eqXcUL5oti/3fM2tHk6MTfr1Y2G7P1nEird65Dcbuw
         Rs35tJslwHdqaTK3LjR1kglrgyv9DFZ5TRp98PIyG+CobmP5AWdLXC4c+dCTCJC6933Z
         bDTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776719488; x=1777324288;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+SYHR/pFJErvzIVkYe1WxM4A01QV2snUewU47c9pZOY=;
        b=jNiWhmQUMsdKKBP5aNfMcP6grAOZT4/I4viEJ9TlUTHc6OqhB9H3L/dq5avRedsc25
         jq3STjj29o3CA/vcM1kbpn6AjbRIXDV2UOYZ3IRxKFwPrIVuvcT0gALBtLJMSTrwZ1Xo
         sGz3OCZCXTk2huBh/YDGPPov2x2tlY6UcLiht7/NSOUjIxD9iSXQQ4HB7AeEfNs1CI6Y
         OGe2PzqsZtsXy5PsbYqpel8kZMwZ+i+UjBuVuxemMfbdrb+UHFgu1MZcGF4NR+/APFzd
         mStoSEvT4b2INi5Xl7zF5FKSZNu2RjZ6ZEVOJ+a1gE3Mab+5Aj/2qnrdrk9/qdEcinyx
         y4XA==
X-Gm-Message-State: AOJu0YwM1QSMlqsIC97PDXFMK4dKwY8xJKAoIiBg26zKRtA/NZ2xY6vN
	LMl4kr79BbgA+jk5jKKEpTdk6x4riWNzaAldDqBdwpWCSlgfryPX8Ng=
X-Gm-Gg: AeBDiesRkYNc8CfNbNZxDwbXyjoEcBWl2lKVLJcMcTf8Bttla3BBdOWZ5rsEsTvO4WJ
	NNCBW9hDMJjvODbk4KMijD5cB26nCnxt1Vxi6AWa2PjsJdMW/UP74OSCQxNy6xt0beMHEwtSJvm
	UJt0p3PnAZMnetVXFZ15RAzhLIpQcDvLV8AT6tMrQpuz7JEGhWYoaeNzTmHhPQFKGlcS99xT6hE
	E5t0hC0Pdrj8Je2YwIJyTdQ7ibSLBhjXVr/JjhPguz78z2IpP7y8o5ikFYqMIwtcrg+j+5DDtGZ
	2Q/D0IRTGgBhX6wpA+xEeYyNoB+E08nfmWriy7UF9noC/kADP4NzuE3ApN2BSydKph9t2DeKFPA
	VQowUxivW7u/F1kwJlBn/loY/HZF/R70uzhLpzaUl2rLZZcuhpikP2R4k9EDn9hEJytJ8S9TKpR
	v1QFW+L0O+B2P0z/Q0hDyjN72OL8aTJLo+aOhlLn770v8NFTMPrzY51i4/lCLqINzmVlLxXGq7Q
	E6NnEZ5oKx3IlIgkjDuMtsC
X-Received: by 2002:a05:6000:40dc:b0:43b:5672:efe with SMTP id ffacd0b85a97d-43fe3dc7acemr22745537f8f.9.1776719488305;
        Mon, 20 Apr 2026 14:11:28 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b42df.dip0.t-ipconnect.de. [91.43.66.223])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4cb11b4sm32675843f8f.2.2026.04.20.14.11.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2026 14:11:27 -0700 (PDT)
Message-ID: <78d77bf7-7b06-4c69-b876-63871efd058e@googlemail.com>
Date: Mon, 20 Apr 2026 23:11:26 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 000/198] 6.18.24-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260420153935.605963767@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 20.04.2026 um 17:39 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.24 release.
> There are 198 patches in this series, all will be posted as a response
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
