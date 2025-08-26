Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523612E336E
	for <patches@lists.linux.dev>; Tue, 26 Aug 2025 19:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756235904; cv=none; b=tFsoLouVnUFAJpBLzPsr56EbW19QD4GryLjUN3+CacNkonPwVGyOUvQvT6Fcm+0mUKoWY08JY0ygxu9Uv963GdCMjp3U2fk/5Tl+IgZ100zzmwEQORBSfIQSU0+/bk8tMMzgaUXDh8fDPGgtia/N6nRFwHqixaN6bdh6cc02L7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756235904; c=relaxed/simple;
	bh=r4n9AlJI9GSrAECXKbJumCIgbljlrp0PpU/p5zYJvXI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OEwNHTZaZ8Lu4WqcDZNaoR8mvGAHvXcKiEV1e8q2BeYieSbe80JySwxBkEEylIAPcsiTlssBQO/r0zAy1vpWLefGq+X95yUNMS8AIXAd6q34g6FvsvCMx27xi1Mhi82opctNQL8gvN2HwX+TErJtFOgY1kKtCMI10hPufRnGev4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=j7yiu1S7; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="j7yiu1S7"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-45a1b065d59so34810605e9.1
        for <patches@lists.linux.dev>; Tue, 26 Aug 2025 12:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1756235901; x=1756840701; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UrQoPThZjJ7Y9Fz9FPppmTbdMlPby6bxNAJJKC56oKU=;
        b=j7yiu1S7V9Hx90lGOwQJpCwmpJWNCKX7ACuyR4YIko3o5lgtUj9g/Sr7aljstCVSOD
         lliEdQ0jVlmr1c2Sa2G25CGryvTQf+ObAbGjI5BtWhMtwBy3DAFJt2HRcNoDu4ze0aXS
         +sCe+FOruXp58iKZtxYfDIE9lUDhXxLIzYTgl/emfOvMMXwbC6KTRsvGeePReEUFzlPt
         JQ3UN1Dk62Fc1OxoJytUsBKkds0plDBnILKFBRx//69YLeWQp9+iesbg3JzCwh+RNoIz
         9TtX0oIabwM08ETRAdxr3G/K4cTBz2+9z4DHlvugqjh2313Go7yogC0/ZxPn6bb8UifL
         sxOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756235901; x=1756840701;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UrQoPThZjJ7Y9Fz9FPppmTbdMlPby6bxNAJJKC56oKU=;
        b=C3Jav9VIQ3L2nt3vL1JRSNclE+YdSsLSEkHLokEhSKQFIUPtDCYL+8JvBrUaDdUnUK
         OQzDJqhzkYVdqfDRukc5s3D0sn/wb6RX9FfNyi8KYS9ok6q5ikVhmabD1x2pZbv/Ztws
         iIb/AsMGLP7C0/C2aKK++tQ1xsEe9lbPgGLM9lj86WqNFyhZsZCeZLwN+jurJDkqLsxk
         3n/HC5dr19y/aEzHS0vG9YKDCNx9srO+GdkRLMc1u+Yk5xsuv6hiXq6eRENo/gU2yds0
         nUkjotUhO6t3to6ThBcHH28uQnF/+yoC7rS38ugYqQmInG3zvlnLW8ALp6hHGkf14zva
         9jtw==
X-Gm-Message-State: AOJu0YwcplXEynALxVII4a8iT3udgLGk8ih+cT46u4FKuKtk4elYEpsA
	3/uxMtNYIJC4pC4WM6t6hFYZ+n+BU2CYf/3y6QTa9akJgXPwpLQtA0o=
X-Gm-Gg: ASbGncvIgTrk2nfArDKRuzcnFqQv3H9j0AvUBHKQqfVhZ+1DV/rNW+t5TqSTUp6PnNB
	3WFRxVM89Un/kBrvdUE/IVJFHyX22JQnmSUzhaatG/JcTFMkGJ4OhQW0jrK/pY4EUV1kG5z/jax
	2Z+dksoDvgUz7NqO8GlinwZXqCcvBOwcBYlGqHM++JgZrMhK6+YN9RNjasTZIK2RAHdJIX0VD6G
	NNrP1OM4EmU1XBE5KmeIutUuAVSIHRR3iVU6O/gwAL0mdS91M84VWEIIaZNOjsEJfXGcHKHCwRH
	OSmg3DJp6LC7bIpsU0HpOQrT9IiY+MCJ61Qa9vsOw32yU+ftagbOR7/4ByjXJNPgnaZJMF2SUde
	/7Wwj+UEPQjNPdjyvQWRglxRwuv0fxaLyGiZpIHeRjc3qsQ0rqLrTAznPuS3PvvnbUo6B8Qv84j
	kjvuxwHWX6nRB9VBKEWbc=
X-Google-Smtp-Source: AGHT+IEzVl8BZCib+8G1pZUV+hzUECdFSzGakztyZIS9Nsbt7lyHyXZ1qO9z0MNcP8N/hRARQjADpQ==
X-Received: by 2002:a05:600c:c48f:b0:459:dfa8:b854 with SMTP id 5b1f17b1804b1-45b5fbee605mr76053925e9.5.1756235900446;
        Tue, 26 Aug 2025 12:18:20 -0700 (PDT)
Received: from [192.168.1.3] (p5b057219.dip0.t-ipconnect.de. [91.5.114.25])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6c53dff9sm4672385e9.18.2025.08.26.12.18.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Aug 2025 12:18:20 -0700 (PDT)
Message-ID: <e06db79e-809d-408c-a862-a6f90c6a35e1@googlemail.com>
Date: Tue, 26 Aug 2025 21:18:19 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/587] 6.6.103-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20250826110952.942403671@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 26.08.2025 um 13:02 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.103 release.
> There are 587 patches in this series, all will be posted as a response
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
