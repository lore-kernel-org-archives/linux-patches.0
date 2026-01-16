Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D2631DD96
	for <patches@lists.linux.dev>; Fri, 16 Jan 2026 09:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768554888; cv=none; b=KralMT9chT+bzJy8InTM2/P4SscSvzzIQzxgXg3vjgishsTV3MWjZQ7pfe8ARIuzJodsrfFPjBtPXEXNwOqP0Xpgv82f/8vN8u1NcsS8hbMhSvlPCWwgb2T8fA5OzNDxJ+EuwfjCT+M6Bwm0hOEg+GWyJStRbf2yBJ0QTcHkmP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768554888; c=relaxed/simple;
	bh=qkrxZVaIq8u/ULsagBD6RpwPgBipJU+x9xSTgkJmnz0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cP5E7aSyWWUCrGm/HkO4kqfwkmwiTTPv9DUe0qtophycf4/2zweNm/bsedkT2Tn5i2c9jL3iIaz8EOR3xh4lLaGI87tVWyMa3x2gvTjWjg4e+507vXRxz4OBS+WmrCDLzAvm1BxXCuuby+VeJUSayplcNmxhB+3wultsdgn1CnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=YiaSN2+E; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="YiaSN2+E"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-42fed090e5fso941217f8f.1
        for <patches@lists.linux.dev>; Fri, 16 Jan 2026 01:14:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1768554886; x=1769159686; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nZRvucjqJSUAPELpYM57ftgOzdeRyS0xf9BHStfw3N8=;
        b=YiaSN2+EjCbFfKGvjh+eQ2kliRM727j82Skec2u2zPI2O9Cub4y9JucjLiXCF4SLS3
         PH5HdvaQDzw3KioEoc1j61eYMkCWht4jvKhmMUuAyZSjPFpbJ/ns/xdV3vcykZxZPQtM
         q0dB09xX6hXkfNstytlfE+q+jCkbx4e6LpgkJW8V0LYuK/l1DTePEAYzYoTxmgO60s+n
         MZZ99+HHvI7jyHFm0GkUpGTRYs1OmUGUuu1Bui5ApdNV+oRWu/ge4cOAbKyAEscUfBGI
         QgEUe+vqaFGtUeBKpt4QGUzjmqSFgYdc3uVlgOAx0gGo+m+SiAkCOen7Rt/2pZdVpy9F
         WOaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768554886; x=1769159686;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nZRvucjqJSUAPELpYM57ftgOzdeRyS0xf9BHStfw3N8=;
        b=k9CiGQTXyDpCfhY1evcd5zyhS1LSc0u9q0msvzX9KN8AqAGo6IgWsNRe7S8DFQ03Es
         BH/gfc4E2+KBSBJPYdB64X6eG+m7U6ojZyr/9yBJ0v45AysYhH7oMam4KCz1dM2fpvSq
         pKgDkArXPXKYzGi/IYykTrPx+n1Lb/RNTF4J2yig0l/rdXN1RMjWMH9OQLYDPPbMkZa1
         g9YKFyD+f3QEf8IIrx41QnPUW3ArZMuh0VPeSULzSbpwiTjnnTlUdE7uJiBPXV7IosLE
         u+fWJ+I1u4X8FwgWZEPVJotE6vQSNuFSbj1diU0XbFFUpeHHlhl2wcPXb8E5Ji0uxOk0
         0Ahw==
X-Gm-Message-State: AOJu0YxYEedVNa8+TS1nMNE4YlwZ07c7Pc9G3Gj/NcFVS7/90qGgRLQe
	rpSNF253xzOa3edwW6ohqtuBVdkR+UNrZ2s/Acfl2eZ5k4T5VeUV5gU=
X-Gm-Gg: AY/fxX6uWgJWpAxkqSV96CGwMmUrLuFa6HWVV6nG9zCgkescAiN2jyzHelmtApNP6VZ
	43ATMZztBg9YTapx9mply4ir3RBOUuzy3NZastMuDoil7sgIRl1rEAwu5wRDtm2q6XjB4ZzBGV2
	/kDqjIshez88ct1OssW8r/0OBroVNXUjl9K2QbFQ+U3MamVd0WFskrzFiSiPmFR/eDFeSa3Ilpi
	bFGY5JN8KZXzy57f9naxFyhfn9IioInbX4OuUBkggxPCSsRlZbVs9Am1yJPvaLSwQwlG0XjT6CL
	wXJ3i5+nshQPLdUvLt8GmgZU8n70JRuDKTEfz+HqoeCGjrRH/oZYpjKvb5kASGGXPTMTunreXkm
	Csqq4j4yKVYqCnee9UdhWSwB56c5ocHhs1Bp+noi+hGeGV8lODyyBBMD+SbAH4qEWs3F0zjOKru
	c4Fzc3bYU4xhlnLww2/HkWU3UHazenyZaPN99kJQTon2zEC1JTIiwyLjtOx52dvRhK
X-Received: by 2002:a05:6000:2484:b0:432:8651:4071 with SMTP id ffacd0b85a97d-43569990a1dmr2173102f8f.18.1768554885574;
        Fri, 16 Jan 2026 01:14:45 -0800 (PST)
Received: from [192.168.1.3] (p5b2ac8bd.dip0.t-ipconnect.de. [91.42.200.189])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435699982aasm4071341f8f.42.2026.01.16.01.14.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jan 2026 01:14:45 -0800 (PST)
Message-ID: <88058798-4a8b-4224-9f19-34b92acff783@googlemail.com>
Date: Fri, 16 Jan 2026 10:14:44 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 00/72] 6.1.161-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260115164143.482647486@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260115164143.482647486@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 15.01.2026 um 17:48 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.161 release.
> There are 72 patches in this series, all will be posted as a response
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
