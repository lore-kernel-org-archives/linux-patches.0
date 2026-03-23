Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B9C285417
	for <patches@lists.linux.dev>; Mon, 23 Mar 2026 17:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774286869; cv=none; b=T5hCihMtS3PuF05u+n64XfRDiu4tCfPwqpYZCgxONqbBNMOKgYlpvFbiwHn+98Ms4z32pwigDcNXrVnGf8ywFF1hFGw+Cfs7XzMNDNd7itb5DmJDb/AuI1yBVfcqBMNe7YQfaja/2FrO3ShxkiXhcj1c9A2R7th1CjAU8vnuB+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774286869; c=relaxed/simple;
	bh=2FNIH37roEjwP8dn0JRZR7mE1v4axVzwU7scBVjXiXk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VOLSaM47rVpXb6/q0d/o9+bKBiEZ938jmYaIaWe182jw3hSfXFu6kRaVyZLBv2RadKsPozqMdXFR4MpzKlAtU+cCv4oOduQMqXqdYWM/r+9ZqNXMOFBTS/ShlQEFrZsMEpdy6RkplHMzYcn8ohDju+L0OrvoxIVWg6912OlsaEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=DHzs9zX+; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="DHzs9zX+"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-439cd6b09f8so3297385f8f.3
        for <patches@lists.linux.dev>; Mon, 23 Mar 2026 10:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1774286866; x=1774891666; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+BBiFenQ7EEIN1irT/UYc2jb5/+zKTJdZZ71A2NrC3I=;
        b=DHzs9zX+XSxzrg7oV0RvycnHKo2yi64DPbgxsHVUx9NUdB2OWacjHlQKwk7ZHGVII6
         ZR0HIE7doB0tZlJGskzKKCmRn0usoh06J4ycrdncCBPfzhH4fNVCNbznqWuxLO48aNJ9
         yiBGrujBrptyDULJEApAteCsG8UHk4R8wa3BuuBmfW+RYH12uxcKLspLvVcXjtxYdP5m
         rq1e9hb4eS0jkO+WS9ROL2hurBQDKTAmTlYO7uuRqTkXvVi79fdd5O5rIO/wQjPAAiWT
         oSQ2d/z1WKnSfesIpCzD27RYgBjwr5ZuXEzdJIPEVwD0faXoNDYJ8PLwmc73S1lTrsnQ
         BBpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774286866; x=1774891666;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+BBiFenQ7EEIN1irT/UYc2jb5/+zKTJdZZ71A2NrC3I=;
        b=oYAXqp12o67kLW008Duzy5yNOtNuGKzAeWzgOqV+KwffuJaHb1CUX81/y2WYa/DoVN
         gh0WtAW1qpE2GGgfS6wtL/ZMqG7e3ilej3KVrN+bzTfn4nnASiqiKvLR3ZqZQ8a0dmnP
         sM4x7D6VRqpkOPP/mTatA8irspQarOCC/zBk5gPDt8rHnHyFhBOMXQ1zK5uCzDbP0Vd7
         fB3bEiVwDv7fdlm2e7t/VMiOijZEdoZTUuwOlupab3rtcDZ9YBWl4JStVVMTpK4b2FRK
         ZK/w53mClNTzJAXZDU7P0EPJw899sf+rK4oIDcnlfRVos2fTkqdJqlLPp0ks0HYWoWQ3
         2Urg==
X-Gm-Message-State: AOJu0YwEc4bsJ+w0ydKPFfojwgI+MPfQH2Z1sm6fe+FnbwTjCaN7b/Ai
	fgzd+bclT8kQmNkw5OXAJ3LTEbQ1x0qxYhBuafZ3OYtjxy+pgJhB7co=
X-Gm-Gg: ATEYQzzaWe2bOMXkkRfr3zWo124d4OjjcSTSTUuYwTa5zxgLfGoebAr+0mpJSYPsF0J
	QeUF+/slSgMfvk/TtZ93hVkLJjN3sGDLvWmubVzDMHtGIJ1WcVfc9COMXy07EwMld90ejPavO9B
	imicxkbPcEiyptLPkLaIVkIIeL4dQLgedkdPzSlVDOL8TbRZG4O6bL4zsDYAMJQy4UrBSjAS6cs
	ZAF8qXN2vKKCi0oArF2yIw41mwtNdeWdYXykrPGT7qoFkO0r+g2UHjoSO408BIV3YWBp9pn67VY
	vO7mdw8dWyMcmHamUDrunC1hgYxe+Y1zKI6l9REFkCR946WhOP0PiYDf3QyJSQ6SwVtiT7cmo33
	nkeYBYqmjMMQEaBVgQFQrJYqTNJAtN7pt2LijXKm+bEKMRaccd0kzmFVhEcejqE68wY07TiSFeF
	V9zmPixGV0csTLlksYxkR7xaijVP9rhg79S0AJjk3yHiQhYqUSgHccPfzKpNfbc7pleYMRgYNEk
	bUiZGX3PlT3
X-Received: by 2002:a5d:5f86:0:b0:439:936b:bff4 with SMTP id ffacd0b85a97d-43b642824c1mr21258835f8f.46.1774286865928;
        Mon, 23 Mar 2026 10:27:45 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b444d.dip0.t-ipconnect.de. [91.43.68.77])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b646b0d3dsm29358657f8f.16.2026.03.23.10.27.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 10:27:45 -0700 (PDT)
Message-ID: <900133d6-08f5-4272-b5a4-cfc69909ce55@googlemail.com>
Date: Mon, 23 Mar 2026 18:27:44 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/567] 6.6.130-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260323134533.749096647@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 23.03.2026 um 14:38 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.130 release.
> There are 567 patches in this series, all will be posted as a response
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
