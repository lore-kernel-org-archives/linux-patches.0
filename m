Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78603E9587
	for <patches@lists.linux.dev>; Wed, 25 Feb 2026 17:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772039543; cv=pass; b=O3PNYu2hFswTEUx7ffKXlQyZDUFqOMMs8G8xuQiG9ajd9DFmetfkAEZ94aX+M4ykNWOBGKlj4d3X/Oo1OUNKEpstQPcrIQwPz8fJVjrfSsC1nO5nVJLS1RZ0DNDTVi1mnPYuFswEXR/oJiA1a3Sy1nLZFusXooLZ3NQgo365wpE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772039543; c=relaxed/simple;
	bh=RlxeLXdmicJJqqSBt7535w6GmLiOvBVYNdBa7/H6kQo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LSaFlLEL5oGbhXgnn9MJ2mexOVG6TSUQBOIyorfP0PfJsbvWPLYUpoqQJ4Uwpz5/ofHajKc346Z3fcrtQAvzPAPPVkyVdPATy2U7PZftPwtOMwae38MR/aBHFInxNYNmoDRDmROn78NCF5QrOaMd0OdwJXSfrR65mCw3DvuL0tc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=FbaO7seE; arc=pass smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="FbaO7seE"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b8fbb24a9a9so179962066b.0
        for <patches@lists.linux.dev>; Wed, 25 Feb 2026 09:12:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772039540; cv=none;
        d=google.com; s=arc-20240605;
        b=ZOsHMmlqYfxBbfURsPGS4XJmSWqelSC7S5zBKLQM2B27L75biQPXKZHy6i6XUhHrSk
         xJ3ej+zVOZma2+LaKRY1MDlFHZgW9OWcAXAJUHLO+Vt1K37EdYCL9FEnhm2dqoMEP+9O
         hvgkLEcj4QvCuMv1lU7SizOdVTdPQeC56LgBEtgr833yfupO5vicNizNoVlqE51o/7/j
         t78w736vR3L3l5gv2muuGqU2U59tTJotperogxnf1/h+9fA6an0YrS9iIaXtobZw6qvD
         +qRCtXRTc26qfLxLDLENZzGC+dpMX4Fg0P6pekRHPff2yjjJHda7vSeOgA/j9QkyPgSQ
         D9gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=8D0KlaQHiURMd3qMJO2dOqNEElEs7vHAzHYmLzebY7A=;
        fh=XaRfFee+jNFbwIOGIpbZDTf2GDjUQM3hyZ0gUQSrLyc=;
        b=LmWAhxBRPOk/tk3iUU8EeSvb/PA+6g2Sr/MR7hRU9CC1/+ReeodADK7i6haop0CJ89
         mjMKvZ+yKbNM8Gve9ZULFz6ESfZxLfdGZ94DTo0f1Nklk9FLY6EurGocmKmqiNokx23Z
         fNpLe7DrLyKpGWARMCd9FMjeLF5TyCdemR6CtJ1REl2XNxmTsu6OmbONPIe5Y/CtUG9N
         ujbC2VfaMS+CElKHl1fxsnTjwqfeoSNeVMACrtK7MGVXmbtWMuvgen9KoHe1+dncHkeI
         0ugjwKo4Gb+Zlnk4CG2+2Ofmireiav1in1KwpsGLmpXUm2dIh26aC4ub7YEfABuboAbW
         Z71Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1772039540; x=1772644340; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8D0KlaQHiURMd3qMJO2dOqNEElEs7vHAzHYmLzebY7A=;
        b=FbaO7seEuwRSBWQLLd1XPOoQrBCaVjkfZy7x2Foxqu6crmveVh3zev3MkY4LTfT4Ov
         CzhZcAQUWTwso5eXHtsU0/wRpCaiMl3Z8fcA90ScoQBEQLxuAQxErB6kytrhnXiT184H
         4SuD6Ma6IhcX43kCAaE96PCPhWzw2QwOwSPuTxhDXTY5vMgIv2B4OnAdulJPXpaeGIDz
         9tuggTwkXyt0KMhwJDCw2eWbUzbLh9ruSw6C7UE6SdzGaJNNJ9ME2CoTWMI5kJVKzxub
         89hu4EaRkaooKPnxBgIisrI8udF1yVxoVE5fWizCJCj24M7ukww9if9ejfOc0EitI9Dd
         uABw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772039540; x=1772644340;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8D0KlaQHiURMd3qMJO2dOqNEElEs7vHAzHYmLzebY7A=;
        b=RyWojV/VFM8qQ4EjikehOL/ufb9LmPFLRzlV4IvKzQ6sU+6hLoJkjrLBVi5uJ0sdiZ
         jsKKqjYGX6IJEY721rFMQBVqNSJcHKuQmxJ/EolBkyGnMPFiPMAUVd55lWoyuQvzHtzf
         E+fNqOeRg5znTBhRgN91HIwvP6N05UasUh4ZrX/hA1POlFmL/aNb80BJ4WJEB6mCHcYM
         IX1zJKVDX+M9zLaajIJNCMmjWkdSnn79oRt4sejv8X/29ScDH5ECAAJDTz8ae6k4EyaK
         ieEVpnEukoFqT+zib1U5Q3OVmfsj0/Oag42vCMfZHXFwnz9DnGedtL2Bkhj6r81jpGcu
         FKBA==
X-Forwarded-Encrypted: i=1; AJvYcCX1zN6+han6E5tPblXHGlrE9eB6Yq1nb/3pOMkVNBT4s0/6W8QdFIw2ouuLXuJs5R349auWEIja@lists.linux.dev
X-Gm-Message-State: AOJu0YzfbsxXjLbBgwthyDyGPT0k+lgnLdqhbK6DYtqdOB6iowr4Oq8D
	BFAB+NhIRS3CPDNqaeJH9RQlQw2dbo237KFczL+GJGzQJtuqR8vtCjDtr0BjHFE2MZ3wNGijgZK
	BP+x3rImoYvU+U9/CFvvrIWFgNaJAE/l5QQs09wyUjPAFAlV3FkAR6hs=
X-Gm-Gg: ATEYQzyDICvYnHJBV2KlGILJowm/ogHs3gsOtGeFfaeGJr3YLS6U8fQS7EX+Us138nC
	vRpCnbrfSiYEw6fQgoxwdGH3aTMftqIcqeh3zdRiqV53l020PjT8k3t9Bf7MzaXCXzDngtvHcMX
	l3G0uryS7X9eVJk9VMNufVRsBk8tEm9E+AY1IgjxAb6ZNi6xRrXGeXdt6WXmFuKIymYvQNc3Jik
	y5CEYjw+cZHnqxZq+x4saG+iqawutGte4s0Q2WXpZThfhcilCprDxOomu8oVfSuAbszHNGNF+fw
	3jSYBNoQsivf0RZmWWdx18nO+uBdTyQxZctwczXaIkmW76/eT7t/IgQYRLDW0Jl0mW9gZyI=
X-Received: by 2002:a17:907:86a2:b0:b8f:c684:db37 with SMTP id
 a640c23a62f3a-b933cb9cd35mr285540266b.9.1772039540109; Wed, 25 Feb 2026
 09:12:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260225155341.094945851@linuxfoundation.org> <CAG=yYw=0DgvXdfhEzeBYguw72gHy5R0ZiTeLZ61iy6uixKe++A@mail.gmail.com>
In-Reply-To: <CAG=yYw=0DgvXdfhEzeBYguw72gHy5R0ZiTeLZ61iy6uixKe++A@mail.gmail.com>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Wed, 25 Feb 2026 22:41:43 +0530
X-Gm-Features: AaiRm510e6YQdvZJgaYW5-8K1wppbn25FfQOzC2C4iZ4Av-78QdAqwYgQG4Gp4A
Message-ID: <CAG=yYwmq3UZHr9wRRX=FNM5PVohZc-3f3MshxFAayJy5oKa9tA@mail.gmail.com>
Subject: Re: [PATCH 6.19 000/781] 6.19.4-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"

please ignore my previous mail . very sorry

i did not test 6.19.y



-- 
software engineer
rajagiri school of engineering and technology
