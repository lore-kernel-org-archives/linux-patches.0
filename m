Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3D033C518
	for <patches@lists.linux.dev>; Thu,  2 Jul 2026 20:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783025208; cv=none; b=AQ7iDTkYQ7TA89c7IRDwNqTW6M/A+9zQSL7xXLpEEh/tVPMO5Vl193jBtQtSiBoCvbjTmMzqKT5JoUMK6zCtJuPOoSbw0L2H6kFYNzqXyqz/5IeUaamdoIth3Q1+WEq/AcV/KmfwrL1e4e+Tkg+OlImYkINO0lue+4mfeUqRk2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783025208; c=relaxed/simple;
	bh=mzfMrKegHTcQ3RSy166F0rX9swRFELx8+9bHvnCtMOs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o9vhAkVdA+qF5fXgwUXjuorJyfu/7xAZoZS4PgkT/CfHcFpfr55jGpCqVddm/ePBgig8onnhZ7eWenkyzIy7sKMi0JYJQxi1KdPqfCsSHkNaPsS4ZLYWuWGDXTjd2h+Qm+URfo2zu02fU4wRDKlf2GV9ye+MdhpWu3gOX3Nhwnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=YMNy7nCT; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="YMNy7nCT"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-473ba028d46so2282517f8f.1
        for <patches@lists.linux.dev>; Thu, 02 Jul 2026 13:46:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1783025205; x=1783630005; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OJVX8JRPAX+8aFg3xElLxvZtOlGVWEW18wH1utQChXk=;
        b=YMNy7nCTJv6AjesMuT7kh593ZZhRs5iY0ob3eo2LO/B+nAComI33U75Qn40US4k/vg
         iIp7c1jckKYX28dhNXDj8jWU1N84sn3YwB8b2f+OQnzc5YZB1egt0XYe2/JlT5eK/oLw
         pxPPyNFg03NJ1LJ/QaJKjKgFDgFyGQmdHhXZjbXgTCS8vESMc2McvaS+zm6TrNqpuxPj
         JuO1FOj2OPpqXt3tJz4EIOh8wTemlDEVjhZ9uDSDTku18QUEA1/g25GqjqLeNZdoXYgt
         nu32YTaNjBkgivbQnqKwLMbvCmYd0UBogOQZ2l6JbcfP9eaDMzju4l+cQUPkquZc9UB3
         nLBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783025205; x=1783630005;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OJVX8JRPAX+8aFg3xElLxvZtOlGVWEW18wH1utQChXk=;
        b=c99ak7XbFL4re4jRaYRwh+iGr/ilv0PhisxbDTrX9Y6AYhx0GgQDNbRRx9mhitkTW2
         r/w12yl7XVWYiFUxxMtKYsD0sK/31Ms0TSSxMOqy/5GnfypniaGDhtABE5we3J6uEGTm
         frMe5r1qkH/TD6JDLQVoOWYxBopZZC1QnYgmZKlDeL94cb2GJUj1Op4tG+xRjXzpNvHo
         O+Wuw3v9/CmWt7/Vaoxmyeyl5bwATluuoWtkOg7Xmy4rGkV4A/C/4G5JfY0v3erGn8An
         eXYZ7xoSAkjN2/7ZA+pHbiZP37o5kzTiNzTbSkrk4V4ResggOd+jHpjKvSjvV0bra3e3
         RMIg==
X-Gm-Message-State: AOJu0Yw4HWE+4/FotQVdKaBQoBLQgMM9MSZu4HN0rGq3qiAcduiGy/0h
	Mednhiudv3jDy3cXzRfuvH+fO5o+6NSjvwwD2ETohGS7eIwFh0TJsRc=
X-Gm-Gg: AfdE7cmfCHNF1KhmJjZDK8/1OAMM8LGQzUq+12RLztkuf/p0RtwF/gGmi9NWvWN49mg
	oWISuz9L+Y/gegam/I2wsqDBPLG9w6EPt+9tWQi6aYLSE+rjPaQpQDfgszwfFSjHE4V49vjDT+D
	aqQ64JZL5ss2nJA7xGI4HiXOl19MmyPBHNfOuAoRQ2/jrRSyZxn6BSpqTQcmG2zjpLLwP9f9sLE
	rSj+0K9+O1u35RGOcjR/kapbFCwwbyP8oYDy3Ww57BWDOeKWk4SbF9GzAX5x78JNYm9P6jXTBVI
	qEtHk5qWxklwPNMZGXt++9b0xUaAMIb0iESVq82PWs5Te7zl8/hMBW1oSk+/ufnK+dlBUunLPiD
	kzjNfeCvRmCMoO9PjUToRQefpdk2kVqL/9S3sOx68w3l0UtaqWxlr4jn3wXmXy3jeRAuPanjnTn
	ootvFlUPw+EMqjCmnHMKtb91lwoRktMvxxGjJm4191E0VdcannVd67NKM7p+0VsEc=
X-Received: by 2002:a05:6000:2203:b0:470:c049:b444 with SMTP id ffacd0b85a97d-477550090a8mr11611351f8f.0.1783025205255;
        Thu, 02 Jul 2026 13:46:45 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac307.dip0.t-ipconnect.de. [91.42.195.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-477dde1a4fdsm12963775f8f.26.2026.07.02.13.46.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jul 2026 13:46:44 -0700 (PDT)
Message-ID: <becf13e8-600c-4f10-ba82-e8bcc972d8ca@googlemail.com>
Date: Thu, 2 Jul 2026 22:46:44 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/175] 6.6.144-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260702155115.766838875@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 02.07.2026 um 18:18 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.144 release.
> There are 175 patches in this series, all will be posted as a response
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
