Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8941E25A354
	for <patches@lists.linux.dev>; Sat, 18 Jul 2026 03:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784344768; cv=none; b=SapHQnPCyi+OQgWYLAOGh8RC018zZFMhxOdCS0zWNasQY9x5mACdiV3hXWWCYcvV2GFgNrojS/r6HxtJo8YdAAzbqPReFNgx2gFIvsGJK1du2L1jLKInU3U/UAddTWFa0Sm0UX6O0WbCOkqBZXXFOTM4gRqY7la2WIChCEVhDkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784344768; c=relaxed/simple;
	bh=jMKeFhJ2gJYiQ2a7B/MZdYTlnZqh4byeTe9ypGhGzZs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ko7Zwb2/Ii7fD3qhypa4MokBZJHTQmzoPf8PMo7sXfmVMvNmq+z6TAGF4VFJCWyiAmgn87kZ3QT48jtQ4CUlc4O5LzGa/UB2+wBV48ACQz40G9r6crq3X9C4+8sp258yxmkV8uG3gCTtF5AzSNqB3vZPWpjxqaAyy/74ahwcOZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=LfaOzjbI; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="LfaOzjbI"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-495437bb891so14976485e9.1
        for <patches@lists.linux.dev>; Fri, 17 Jul 2026 20:19:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1784344765; x=1784949565; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7MZoof7cDAoZkq0M3AxNvmUn9E2JO8aGJgWTXOJFjQo=;
        b=LfaOzjbI0J6mHJwbcZj/QA57Cyw0tJNrzX1fnE+5Hu0ziAKY1PBIKR8TgM5ZVU+Eo5
         VOt5xv8SOYzcN8WNAh9gkuaZQxlzmuIKtBs3KEvIgtWMTcsujjCArSH/HQVujom9d0aq
         zf0+6uXEYpFC2+EgdLipSmbWXV2aAEDqfsNtGN6kFehCKJCrOTismIruCypFsAKmLTyd
         mGoGoiRlSOv5MuaFUSEMAAiAvhv1NzN6TTNU3cgh+5jlS21M7ULROeS2XANhfbOKErKO
         xNVqX8140y4JnStzeC8vV5kZfIFPnkmd6w9YlD7qKPgMF6ZdlvKwaApJ0SS9GY+FVZqJ
         7tLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784344765; x=1784949565;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7MZoof7cDAoZkq0M3AxNvmUn9E2JO8aGJgWTXOJFjQo=;
        b=hLf1uE4bd/6d57GyA/yuL0mp8y1BbeAkcdKStbfu+6+gf3qqdYZG9TBmY/YaZ7F2Jh
         cPJNo2Y+CyLG47WSDOtoeJydbKT3yjcYtaTmJoZt0O3Gv/xB6l4oHlHdzeat37YNt+Fy
         63F+M1HWCzw5BQyTs/Zf00unBG+B8dOuj3C0v6UbZ95IbnaGCg16aWgUibbTuwt4cepA
         EN2yFxND3d66RqFoesjYRyq6j7GOYNuWH0NbHn4dGPb7t6PpAZ0P5ghqj0LMuV8LJXYu
         LRuNbAzgAA7erPNV2czolZc5VLM0JnDjFSThUTlamz8VaikZvmyZQU7FzSTYFgY/YYUL
         g18g==
X-Gm-Message-State: AOJu0YyydG0sSNLc5c15dWqb3Eznoiwh60Q2t2ctBPdKzycwd3qo3z8r
	BV0mKh99W360xEw+eIuyyiGCsKWdyYwESsHSUBwZuuaL61HvGGdXdXk=
X-Gm-Gg: AfdE7cl9JqhhGpIY+WP/TaqR/Z+XezeFn1eYi6olzq8uQ3dulci1SzdlUeelSFJdzeD
	wgU/ENkz1OFUuS7DSkSzASd+/cX8m3EKlXQB5ijrGkpwADL0vVknRPA6h02hhNArsuEQtvP5jLt
	uKxywjPVCIPl2rUx0ZDVdg7HzyPIH8yVunrLby9RKl79k4pxioCoH9c6PFTnc9ZXP5QwgbWOYiK
	EV9/XC6kHFKar/bn6AZbB2YR/U5Alt32lvmigwO8CANuySMA3vlZySt4ldqCZ4Ej2XgUqcUoSY6
	OZcozSTw5NBR6RpGPKI/BtHgO+3zTMo0kbCNQ+WN7M8GSX/nDtotC+9Zqq5Khgk0bFtjx4kPZmi
	xDjwQZEpDYTXxkNJw59jVfgewCf3fJOtdzUa0gQL7edJ1N8mUnSds6Gp8/vm1DPFBQ/iZ0FNFYj
	oOqAEXeyabc6NvsVYBh6LoSgUpam6i5Pi1T+wyG2Rl9wvYvHZ75YuDPQ==
X-Received: by 2002:a05:600d:104:b0:493:e49f:1541 with SMTP id 5b1f17b1804b1-4954288e0d9mr81342365e9.6.1784344764453;
        Fri, 17 Jul 2026 20:19:24 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4ae2.dip0.t-ipconnect.de. [91.43.74.226])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f63edcf8dsm9529444f8f.27.2026.07.17.20.19.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jul 2026 20:19:24 -0700 (PDT)
Message-ID: <34d1572a-b7f2-409a-b681-37c63f37e6f3@googlemail.com>
Date: Sat, 18 Jul 2026 05:19:23 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 7.1 000/533] 7.1.4-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260717101912.682013354@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260717101912.682013354@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 17.07.2026 um 12:41 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 7.1.4 release.
> There are 533 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Just like rc1, rc2 builds, boots and works fine on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or 
regressions found.

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
