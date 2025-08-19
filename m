Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92DF325524D
	for <patches@lists.linux.dev>; Tue, 19 Aug 2025 13:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755610446; cv=none; b=I6pGiq0TLYBw7fgOOnAl9itD/3V+us47rk9fiJLMI3+Xnwi917mIu2U6UO7swDQAVF7tQ3wYTr6HDXk/CcDFAuwodNMpN0NwDHVC2jT9X7JGfD8C59a4K8ZO262VZokubjVPkvdXG/AFT8D89rf/uw2SJK9x4qtmqX5J3S7Ra5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755610446; c=relaxed/simple;
	bh=MWXq9VOomp2DQvGtRoxuj8RooMO765vG+1jEaxttcbE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QIpMs0OOXDZTtB7OMrZ3y1786xvCFa8chxArhMCw3jZYcWptTMy3b10jtr/3Gyk/RydVxZ9gRNVIs2NX4pwGPk06dZla20gltXMV2iJp+OXxu/dayWEfZtyzgY0maVcHOjtmfBDxd/eYC1VLcYZ21vKGaV4OWaLZivntquCttrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=WKcM+nFh; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="WKcM+nFh"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-afcb78f5df4so875013666b.1
        for <patches@lists.linux.dev>; Tue, 19 Aug 2025 06:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1755610443; x=1756215243; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PMkS39Gi4zmwPHBP8zrSol7/0clLz5vuWWWUq0yrTRE=;
        b=WKcM+nFhtkHxX7hw7eNGNZYafdgbcKUe4HCC+hIsGG60V1c1uH9WsyJ5uBRb51936b
         /Dt6JNSAt9qPStYqyzyoNlFQVl51/7n9araphswFZ9RDlJ48o5P9QUOC/wtHoSbfOwpL
         YcyxBLMEYw+br5DuJS39eiXcUsRR/sd+diM6aAPrX1GjjcOALJlvQdtfBbjdIR5Af03v
         ckTRsF28RlwI+rc+31ilMp3XDrxM/Do3HoPoTGuQo1yOUD6qsesftHhjC95t4Tq/j4t0
         UhHblgRdl2Pe6zsOVQEz2hYFVT0VsThrcgBZwL8UW0il72njpAG/+49J7oSSE/I4+P9/
         ceIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755610443; x=1756215243;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PMkS39Gi4zmwPHBP8zrSol7/0clLz5vuWWWUq0yrTRE=;
        b=AKz6brOG2+tUaUthj7ynbvE7O14+/L25nlNlZkQe4jwKm5X5aEGLau3Drfrf/KCbD9
         KfDIuHM8OaaZRQ31NUOMdXxU/s49dzDN62en/6nOuksb7b6q/JrKTYQwScigHb8M+ina
         bEHZMTzatMC5gElA/YIMW/ugNI0xKdiSVx+LLxtkCO/MBS6fK9EwPeuBDkRB2z5IKyiz
         UEq3cmd+D/n5ikkDoxPZI61WAiH4FyRjP7zSPuIeE720G/nReFN7D103GKYkMO3CRmn1
         RUL97k3eZJlEBHXbMP4puSXwOT2WNmghxiinqc0iR5HoCdwNYU/7VtcS6tQywXrFJnEB
         Xy2w==
X-Gm-Message-State: AOJu0YynJ8kHj5b16uinnSsQOfHr3D23gNZ6Sraz0NLzVGMOn2t0RXhv
	5ucREIyGlAuGlRafnA6NIx3O4tkmZqvbrqiHI8QN5jERQmAY1sSto1s=
X-Gm-Gg: ASbGncviV4WWpX8XTHXkGsn6spcLPeDF1piwKBe05BdUoO5NaYdtwNEI1pCYFT5CdPd
	RnYG+8hiN+8y+pj4LmR7yiwF8tBQVlp+Iyb6M/oHgmMWKSLwJoDXD22yEVjy9hexMP5cV9CdgZy
	ifN51s9tGtmAUnDTyrauxtvhRay3pp01jNB6ub9cWuQ+WB0UIdWLbHV6kvmR8VV/1Ek0poFj2+M
	oQWgfReb6GKqL6ZiE0L9yNB94BNWq1Rr0EZXhW6bex/QbkNPQjqqOe0VzlCDlYl3XYzf22PxvWS
	/RaGBtSwmW6YNLci3eZiZZADPpqdrzkUAFjVZSWajZc9l9lpemtoq2waaJ3k5XIu83f91aQgCYW
	kmB0q2sDeBq4H19cci9Mx1w7H0yMcceXeneLhUMSCZhaEceFfPAXcrn2mK8NdI7gjBV7H/1urh+
	co
X-Google-Smtp-Source: AGHT+IHqb65cxZhCI23Qs7ElnV2Fp1AewHXJ5M8S9mU/JU4c1+05mdgft4OeUeZc8+F+7RhCjRM65w==
X-Received: by 2002:a17:907:9801:b0:af9:2f26:4f80 with SMTP id a640c23a62f3a-afddd1eb10bmr287721666b.46.1755610442504;
        Tue, 19 Aug 2025 06:34:02 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac4f3.dip0.t-ipconnect.de. [91.42.196.243])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61a757b9b39sm1697593a12.48.2025.08.19.06.34.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Aug 2025 06:34:01 -0700 (PDT)
Message-ID: <ece58364-ba74-4182-90c0-4d9b63567684@googlemail.com>
Date: Tue, 19 Aug 2025 15:34:00 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/438] 6.12.43-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20250819122820.553053307@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250819122820.553053307@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 19.08.2025 um 14:31 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.43 release.
> There are 438 patches in this series, all will be posted as a response
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
