Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87A62F8E99
	for <patches@lists.linux.dev>; Thu, 25 Jun 2026 18:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782410772; cv=none; b=mqYcn6y8nISPHTRvju/5YWR2u0icACV6Sm6J5KLvdC1rpLvWr39iTaHyy/aep8wT/o3uyUTR7m7MstyvqAqMhkPvJIzw3sMM33bGNXsa6FSZApGONeOoYlkwujmAxLywiqK5mXtjfHbqsO0nSHBR2jiATjKLc7JEH/f6rRGmXRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782410772; c=relaxed/simple;
	bh=vNUEyXjI+o2ULLsnXqs69swoN53hDEw1zQ/dE1XtBWQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZLR8XhwDEqpDJWBKqHUauQmx1nOJwFphgri+yeEHww4i7A7ORklj8FeKsv47JJvugSVA8qcEFnYiqXuLUy1vQ+UZu501R3hzGxRPrqRW/9Np/kIa6Mvqj13H+HpTx4W0qS1r/CTOnvO9jVt3Y/CJ53rVL568ljZ7Dg55SodYmfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=b+Kl1jvv; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="b+Kl1jvv"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-46e22950091so30122f8f.0
        for <patches@lists.linux.dev>; Thu, 25 Jun 2026 11:06:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1782410769; x=1783015569; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=E7e773YfIkcg4yEZ+1XCZxKsk2ksJY4vhy6afCr86ys=;
        b=b+Kl1jvvPSNjYoNGwUXm3wci3rSBICmhSdDHZf80AeNFcQoCHw0O8G7r3On9p2+W1C
         yMlwzfsNqQ8CJkqP5y+Ky0pJ6CM21CuPuWFhENu04ATBg/M5OCuTUrUwUeRgOepJJkt0
         K8dw4YP0ZpsBqZU+5ovZaylgGU+l9Ai3y8kPjT7H0zcy5JbaQJPL2dxVrOfapPPyQmSf
         8bMHD+Bgw8rMUE3g5Ay1Rn4v6toAx8bgfgYoehabfHL/dMpODCKMjePKeRxYK+9/fIpg
         60enJ3Hxtc4fzNrF9VFzJ0+4oOOUWLb7g1gRK0Wr1BqZO7NKsxQqd4n3yej4u1N+N9Xm
         7WdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782410769; x=1783015569;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E7e773YfIkcg4yEZ+1XCZxKsk2ksJY4vhy6afCr86ys=;
        b=ki2LfpNddfHrN/iULvf8/IqnWMCL0K1Mc/HTZdU7APNzx7XKjMtVxEzLrqTbmyKiw6
         5zEwSF9Py4htrHg1AR282k5WYf0OXmcV9dy0LqLeQ6OoOF7h3JI/KwEoc5eeU0FmWTII
         VcnU0si54Pt6D0YgEE1DTl1eihVjmaKRvMrncSotuhC7+wFtrPTErX/G2DjasD4ImTmo
         SjMT6ywCbh1KCg0FDDuRBjeGFESEUsNWqRK++WrkxjQFXn8KxDdhX7+Id/7SCRENJ87X
         sGyJGZhqGcOxxa3McC+DERXEmPnPYmwbDEUKtdOsE9SwxBLibZncy9gXySprwm9I2fS9
         RniA==
X-Gm-Message-State: AOJu0YxGs3kHPKZ3i7bgLIehTVjjgxNZAgVdGeqMMtRobY3RTGcPyPiW
	JSQebEgHqyjarb3spm95qcvsCnY+7CbPDDoZkiBVB4ClyJUmJqoCdW8=
X-Gm-Gg: AfdE7clP7IUI165mdo0BZjTIWHF+hd/2mdH9leLPgx0RGLhs4l0N0hSxERQV8EUPh8v
	RadceG5Oiar1AknLWn/B01KVVKoifKd8fBbOIcIBFgq6zLsaiadETQU+0WR8VW1g/hvK6R81QTI
	sK0/E4FYOV7ArUHFcvO3d82FXQR4l3t6r+rU5i5mlK/GXZ8ZH3+IfOCUhLJHYJhD03iX1RDTFPi
	xDkPOaOoJiR6iaRCL1JXRlDgcPFHD0NyWzk70CrpOHSADXDVH0vDluY6yv2MQ487Gu3JYmKYHUl
	+bhjRZQ1WsBzs6stCpkAK1YwKC/unoWtUsORnx5GGYI5BkQTmUBH+N7JYrS/usq9sd77rEdA+W1
	cOrkc9H18tPPIO7xhBZNl1WJhDRngPRt93EwhgOA8/KOj5+yK+W4KDgWlPXBYV2ZRCDDq5Ke7Na
	HxKntDWkxL5HoQ+pMhrJsB5LGL7DyickivrlgOjgsJydeo7WGb1tiGqFtBh+iJ4znz
X-Received: by 2002:a05:600c:3b1e:b0:490:b115:e03f with SMTP id 5b1f17b1804b1-49266865fabmr49746325e9.8.1782410769354;
        Thu, 25 Jun 2026 11:06:09 -0700 (PDT)
Received: from [192.168.1.3] (p5b0572d8.dip0.t-ipconnect.de. [91.5.114.216])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46caad603b3sm15878126f8f.7.2026.06.25.11.06.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2026 11:06:08 -0700 (PDT)
Message-ID: <6d2851a2-b767-4177-9f31-956dea5a37fd@googlemail.com>
Date: Thu, 25 Jun 2026 20:06:07 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 7.0 00/49] 7.0.14-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260625125637.527552689@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260625125637.527552689@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 25.06.2026 um 15:03 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 7.0.14 release.
> There are 49 patches in this series, all will be posted as a response
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
