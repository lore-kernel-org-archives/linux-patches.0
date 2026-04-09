Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38C1307AF4
	for <patches@lists.linux.dev>; Thu,  9 Apr 2026 06:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775717172; cv=none; b=jOFf7Ic+6rKjmpi2XitcyQaVyLh20ILGmx7amIXQQF04PpvI+K3er2WXnvXVdH5322karLuyu7tDJDn+6mnbLCZLE0Tw22E89EuF9C5fVHMdd0xLEIKMkqKIk/2isnAHjSN85gaxwD5YAxYxduJQiFr/iIRga1trIBiqWROTWUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775717172; c=relaxed/simple;
	bh=AbeQZ6rUWFA9gZ2YX7LL909ATfLt1k0tZVS04LIVbHs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o3gMp7plnPqZYVVObRuhAe0/WBAFOjqxcMwPRimQGFms62C3K+FyduV2Ks6JhH3Xb7EDV6icPSZfa78G0zYMnD5HszmyJpXIaDIcMZJnESgTaqNaJDcRis2DwZN4xFU7ByDIz7BK5wwe2BBCrofN0H5TLmnKXMqPqxW+4PWwRFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=rDvjBTcF; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="rDvjBTcF"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-48374014a77so6250155e9.3
        for <patches@lists.linux.dev>; Wed, 08 Apr 2026 23:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1775717169; x=1776321969; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UnyQbQKBjyYXbB61Mzrd+iZB35C0pj6iNDpeLUpCeLA=;
        b=rDvjBTcFEQ4ZYnXiuatmx9owsR+sdd/+xXTwXPwJmq4+/vau2LE4vYHf7BEgk8fHMH
         qPOE1frvtHojK5i1q/AS/7S4BuSzpc1fA5PQpBDnW9YNYBC+yL6hYHvnV+n+3fRbRZn/
         Mxd9ktB6UcHt2psZXHvOnKlqvwrK4hXhBKAyB1WBsIyM0og9S+mGvCBUH6Jj4RYf7Plh
         5gXBKZEufAnqYBQSs4lUfSEp3LtCXXNF9thXGIp18WAmu563IBUpYoE3ir7ka/aIL5qq
         F+26J9m3X6v70ALO4w456fZ4JrqKygZpSm7ynGTPoKl35lCyXnFaYLQQeKL97AJ+Ri7E
         Bo+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775717169; x=1776321969;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UnyQbQKBjyYXbB61Mzrd+iZB35C0pj6iNDpeLUpCeLA=;
        b=hJzg3gDFpltgZyMLi0KfqxSJ1eea10rHte4b2CpY7T+JowN9kz8rYBA3kWp1GJZU+8
         KrlMXnK7z5Z0T45W83d2/Z8dHEnEGGLHlKPNrr/6WUuUCV62ZPGthPBtIUxHB8FgN8PP
         78YmtwIRAyHwabqHAOEKLwGOfKESHxwLv/86inT43G2iEqB8ODzH17i8qF8gBaFhoNgL
         zomJWg8a1iyjtMNKAcyCEF7PB417xUQZzJ8Cj+Cvzqo69qADoSr+y7wI9Hti06cgVQXu
         cN2YYkuEq6RRJcvq8R1JduD6IqlX0FvHO46kIXHxukWRgmnC68Mj08eQlLPUIsKlVEm0
         cTOw==
X-Gm-Message-State: AOJu0YzlzZ+zBSuNecGx5qqSOlQIgXqFCJv8w6SpaASDEOOAK3QCtLR2
	YrAr/w7TtQhiWmY7CBfxh+1BdHtTi0d2YQerVdO8u6WHA0JKURu0UgHIm+Sw
X-Gm-Gg: AeBDies6m8femTfEfr+tgCTjIpqb5Aq7p+1rX/ikFuutrJSiFMBlvSqxcnRr3f+Mjzq
	sfGlK+Su+l0UOTmmIUromDd5ikS0JTlGMnFJNejV5rbmNYoKbELgmpEv2ANNv3xpas/63ld2zXc
	1kjcH3ahJiH9cBhEYXM79S51CJJPAR6Mdr8RBc1tzL//fklArw1KBzlqb7RZ0mxEsDJ52lAdoU1
	i8Ht45Y0jfwIWQqEIhqg3DnwW8HSZy1OtjpeKDR1Ypf2Mv6D6/WumYekBdGnNelZ3SNlhoi1e82
	nvwQMJkD71h4RKhzelKQhKU+5A12SUOLMDFlzczwKRTiE9inIvu7cB3R4cXMxvUGhtsO4j6Bg4T
	urlVTzmfepiqT3Pw90rfaD1AbsllzUMTHJULWy+gJYh8rSc8+8HMEv/FoSVPY0vrnbq1a3ZEmZl
	r8dLcIffs8LzrLNt/+J8arRI/zKIovUNsr7tqUGHV0z7knnwT+9A2Yc8i4LbrC/ONrhhhu+B6qT
	a8=
X-Received: by 2002:a05:600c:4f0d:b0:488:b187:d898 with SMTP id 5b1f17b1804b1-488b187d996mr209985355e9.14.1775717168957;
        Wed, 08 Apr 2026 23:46:08 -0700 (PDT)
Received: from [192.168.1.3] (p5b057c8b.dip0.t-ipconnect.de. [91.5.124.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488cd23058dsm49990515e9.13.2026.04.08.23.46.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2026 23:46:08 -0700 (PDT)
Message-ID: <80c1d385-b3ec-4960-b119-b5cb2b209d9b@googlemail.com>
Date: Thu, 9 Apr 2026 08:46:08 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/160] 6.6.134-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260408175913.177092714@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 08.04.2026 um 20:01 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.134 release.
> There are 160 patches in this series, all will be posted as a response
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
