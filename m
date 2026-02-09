Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C89630C61D
	for <patches@lists.linux.dev>; Mon,  9 Feb 2026 22:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770674653; cv=none; b=PI5nYKYQqTa+lvgw1Ab26NP5oT0M6A20rmx6ZczeDHBLXjbW63QqFoqLsYl8hkOMWWnObwYoEWofsqm+tHrxWZ3rHCdjuW6jjJbTPCK233UsIqW/m6ERJuR/U3+zeCGWkdnGpK52RTIaIWQIzV8JHcojq5O79sER0gfYJT/koEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770674653; c=relaxed/simple;
	bh=3x8AAsHfz48he51RVQ/eEzf4Joxph77j0tttP4mDhPg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rrmnvFFjpZLvOQUGJ8qxZtulc4ThPZzgU0xfhDB8AnhRe0ATqcj4cyP7LUIvZ2dXXekUIUirZla9Jpfc8jy6fLUzSQaFru6uz+e37OVK225Qp0vdiL0YDFabVJzgqln6RyerEze0nh/yddmcl8q7Kz7/E88d99PVGgcrTpFzaKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=WXNRh4sl; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="WXNRh4sl"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-43767807cf3so1305807f8f.1
        for <patches@lists.linux.dev>; Mon, 09 Feb 2026 14:04:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1770674650; x=1771279450; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aBqcKC3wfnXy65yCZ/Dqr7YWpQyYvOy83IsALMdIYww=;
        b=WXNRh4slXxwZAtuBhpm667Flp3OYle+jQbeppEGJwDnwuY3dPVghMcWW6HEcTz0qyh
         BrHyknkefiLSGhj4uofhpbgUpILmTZF50FFP40llSEm79Yq8aCjw9Hhs/WCIKItc12ED
         UGbY6H+1ASTQYfWekDGg7LnO0B5A089K3YgIlxdN18y12jnMasvFqpYsXMXQfnlUC501
         dEMZlRFZ9fk0LJ3Ph4vORU0o4EF35vsA35MLxGKuF+ga8p/wbcHBLbaCI9khC47bcxD5
         mWuj8NKF/Wuuj6sRPQjOVXZXtGfO69nU/2wymwVSjM6rP7NTeJ8Z9zeCrp23fOXLdqc7
         e+yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770674650; x=1771279450;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aBqcKC3wfnXy65yCZ/Dqr7YWpQyYvOy83IsALMdIYww=;
        b=h3FM4WSp9K17zAPuRFEQ8whdtRTK4JwjN6djtSRCWAUFDr9QtPJmGOzIMkZ6mGflb2
         yyMe8MpRm+QRe6DHDPYA3LsZDNZkZ2xddKgPsrOwI2FpasTS5CcuRjstfhixJ3iFbQDv
         R04Y37NZEPy16fjKnQqu4gJY7eAFI/PYh3Sz/Oq5Ks89vIt0jVU6KPVeqON6gNrrzWv/
         c7J4T48puuo86KeJX/uf6aPYom64aKs4YKorkQ9n41cLtGONk8TrWj0CkPq0u5glK8Kg
         gxA+C3Hw/e2dKi8XKMoxabPRpByoyI88/W2Ne1npqdA1W7UZSgbv3ogPS32hQ16m+TRV
         M9gg==
X-Gm-Message-State: AOJu0Yy4qw/fChWIXsS39ks3WZsVIjeSoLKCXtR/x/6Jxevnkeb1N2Kq
	ji5n5O1sa09PL/pi1TflEsjDQGO8OF4Q08YCDTErNx/jYjcIrotgFMc=
X-Gm-Gg: AZuq6aLRxzTKnxDmuaG5wespgiEFriI15OU/UgzWcQ6dZoC2OOyNU6PMRvggwwgO5jI
	GJNuw0PugjCFkNjyGlermZHTQ8CwNwwRMhd3K64IqlAxsh5Pt9hVqbC7SIWRkoDsD6luuxiwZAL
	hY/olfVSAV29aLYSA6T9vcfdjuUA9WGKUMW21RaWy9nCm1OOAfQm82sFW6qfH54goNhDFoMItne
	pNsYi7WDIcDeXbPo1OsCRISTvw0XKZVf0VS3HCjO+qSyDypWBkYzgnd958gdZRP5GlIwwP36BMp
	BbKxgoRn81bSEuv0ygoK6BsQlfRPJDZ7a3nItl8e6Zi3lrH54Bt+P9QA6tmJ+5d5Y7D+eNBdDqr
	YtURKjHBu3Nk6s9bRM8UU8M7lJyLsBe9kjdM0/MXPBBFlN4TXNzayI/ZbIj2aU7i23d5KWsr3CI
	5TXCuGeeJxpKUmwIiXMlU+ae+1TDETGXGpAv5F8vYcvrJpxzjcprS80IX/D44Z17KgG44eujJ2Q
	A==
X-Received: by 2002:a05:6000:2585:b0:436:1a2e:9f1c with SMTP id ffacd0b85a97d-4362937847emr19223698f8f.19.1770674650438;
        Mon, 09 Feb 2026 14:04:10 -0800 (PST)
Received: from [192.168.1.3] (p5b2b41e3.dip0.t-ipconnect.de. [91.43.65.227])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-436296b20fasm29227652f8f.6.2026.02.09.14.04.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Feb 2026 14:04:10 -0800 (PST)
Message-ID: <fc5a15e2-773a-49ea-8b2c-f896a197f7a4@googlemail.com>
Date: Mon, 9 Feb 2026 23:04:09 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 00/69] 6.1.163-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260209142301.913348974@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260209142301.913348974@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 09.02.2026 um 15:23 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.163 release.
> There are 69 patches in this series, all will be posted as a response
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
