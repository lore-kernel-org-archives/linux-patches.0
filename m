Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E03F214214
	for <patches@lists.linux.dev>; Wed,  5 Feb 2025 21:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738792758; cv=none; b=rKL5bGnnXLK0YgoAGKFMoZePLXnTycNScoofaL02WKjt4uw4ls6L1Cm6YKNyxYM9mLyIUfbgnXweTPUN/UgF+h6vEeXNm2fUuw84JcnM7nG3yEPT5kBMcWLziH0gn+miVWMsIfy86liqcbL7+bfbQSLnJLmBuYkBzNAFV/bX0LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738792758; c=relaxed/simple;
	bh=+/HaVGqS9hPz+c0CBR2hXGAzuLCFsS66mg4KzaiJc84=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=amgmb9GKbsnjI2fhuhLJXA+iZHlePFeitLcEep2pKoN6yECdMmLalysQo3UQ90caSPNVC4PFHlEV9ZKKDePcG5QbQudnFDcMkoqcjNy7OTzGrcMGp/pGOQhjsZclqBcUlxJIMxtgjE5k2KrH0VmkqUeS4/rNXwqveHwguMXXEC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=YLcv6bdW; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="YLcv6bdW"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-436a03197b2so1486565e9.2
        for <patches@lists.linux.dev>; Wed, 05 Feb 2025 13:59:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1738792753; x=1739397553; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bL029lQXje26EjRmbzipveomf3qqdFr3G9Ff/kItIb4=;
        b=YLcv6bdWIPATnwMVSENmKNJZdjQsJSGl0695drRPqAc4zPgZ5Jek/vMrGn9W3BRFEW
         9tO4e51MLzBXf9nS/gmEQ3RKj7S/ECTj9+6gCCy7lgDOcut/3DIPDD5+F26t5ytjiX2O
         I5oR+6hFFI44CJV3M7ccXkZADxzp6s6Qih9D9Mu+K+69PDed0DOWKhYiaZ+PyF50O7J7
         9s8vCjNnRTSDWk9GXKYVWWA4CBCwYYjKV7wH/Acs4TXbnV3nC2nNdzID1nOmSt4VQo5P
         542IBp4WrdSXqUY9Ni0rXBfxXzr2lafg1inrHcUoEwdRyLKBbdkIogFnVVsqGQbQYGKp
         taIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738792753; x=1739397553;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bL029lQXje26EjRmbzipveomf3qqdFr3G9Ff/kItIb4=;
        b=TvUudBDE5IVINgicTrOv8uVywUSi2RklDI8Xy1XnltD4j5w+4Woo80pB1cNWa8+VTE
         8tIkIfH8jKx8k0C8Rdx4Za27JlUy3z0CKHLcYRLWxlU9/EGmERsrgeHNfv3gLBwDv599
         0CdvWyddiTqw8dNepIL+VUjMcq3uCD9tpTt7Ck03JKvO94CUy0AD5+z5acfEdWReg8DC
         xMtNxpIN4R+THSBFsANJ8+PmFJCTvxqKKVT+diuS1uzjg582yTBENSKthMdNbUAX3A83
         hGoNw2sC60ESbF+Vw1EF4iTSMv+u4mcdrS9sUDfUU/xxtxyB5XWsgPg2jMCbt6KChEpl
         h7OA==
X-Gm-Message-State: AOJu0YxUKqZbs9SWaFJG2EhyVv+zqZayBgOiijnWfIgHZRsl5oCo3sSk
	drMep84r7/zjJ3lYLj2V6l1HJzwU1XPEqqXVEE5HucKP5sHYDTo=
X-Gm-Gg: ASbGnct2GKTsBcSiFjZzqol4LqlKRNUMzIli1qsYf1DH/Gx1zx4lifMRgB8Oi6EuQv6
	L3mhpx6e1seGQeONWnL9Ww4pIDf5/ZTzP4fLt0Eg/hEQ6t6cATUDwsBpj95OmFkcVlQH8fGsfri
	l1fGYIL1Zmm2NLM3mmUAanRjpAC43gYklDrhri53dH7P2SCRudgyruN4ZBkjEd5i+qYBZ5redKu
	Z30Ucrw+CQYJZBli/4SmMJtiJdnLxmPAsq3oIONCoR4nqsonJZvGwxU9HejlgDP6MYuQ++sQsjG
	ir3xkpH26odc8NdKCnEEkq3iGkPr7g7LasT2MqWQkUE8aEsotUZwypFgQ1QG2eQ9iqqK
X-Google-Smtp-Source: AGHT+IFoEmOafnmgI2ErEgGZN/fjvVWQLPszsj7LiHyQgikNEYkGssxptvECnW8C9xZE+kGYjoiJnA==
X-Received: by 2002:a05:600c:1897:b0:434:a315:19c with SMTP id 5b1f17b1804b1-4390ef68f6amr32778505e9.3.1738792752496;
        Wed, 05 Feb 2025 13:59:12 -0800 (PST)
Received: from [192.168.1.3] (p5b2b4bac.dip0.t-ipconnect.de. [91.43.75.172])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38db14ece84sm4413898f8f.9.2025.02.05.13.59.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Feb 2025 13:59:11 -0800 (PST)
Message-ID: <2869bf74-b377-453c-8a22-43835c798bcf@googlemail.com>
Date: Wed, 5 Feb 2025 22:59:10 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/590] 6.12.13-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250205134455.220373560@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 05.02.2025 um 14:35 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.13 release.
> There are 590 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

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
