Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BADD81C0DFB
	for <patches@lists.linux.dev>; Fri, 27 Sep 2024 15:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727452387; cv=none; b=lnfneeHpvsdpf2AKNjCCsomPCHvO3ARPzAdQ8ha187gnQwb+cLQOsLEkEKIuP+T7B/GjpNP1oC0AW4yS11dtEUbpoIUpUSE0CufECsUqutZJ8Z8eHNYGKWb9CJnUd5lnUrlrgJZ1Y2SyMAxIDcw1aIIScuyq9p+0g6scZRAxW3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727452387; c=relaxed/simple;
	bh=mjGIhCqeh99aX0Y0fr4FUsgwcFlLw+CZQnGWXM90iBI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lqaXJmDxIi9dK9ayavrfS3lUflATzk7pSKTGBQJYLkxoh7QV3OOYPVapAEaeDZZ3/Q3YvvPcrzuf0OJwru/AOlLLhFOM+mSeWroPM35QPBSF0rRfLHZPlYAqVi7sj4HuW7lP3Hm4HN7dkvgSUwn+zPChZnqy/ZhwLz8i46IgP+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lp2vtTgl; arc=none smtp.client-ip=209.85.217.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lp2vtTgl"
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-4a3a5cc3903so145174137.1
        for <patches@lists.linux.dev>; Fri, 27 Sep 2024 08:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727452385; x=1728057185; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4BiMluZUmH1JGlBxZinaGp4urWPsU4oh4J8N2PfMdr4=;
        b=Lp2vtTglq8IOFPFVtOuzTHJ5zfwfILQQKLRv4XmpRldB+LUi8dd5XQYQrwGuw8aRji
         +x8Z1BVXodLZACxJvChtwAwH/9Iyh5byEkFfGPQ2Is0oSL4LJtx/ZnWhp8KcsEspSOu+
         QGKYUlveLvPPwmwHaybUMpwLo+R7qVxyVddgL913fQJNK2mWEwuGDJfyBopc45WZGlYh
         MFhyGm3nH3ADjxXhoEZn+4ntkPg64LyN6IuhJb+m0sk8oxpe+JcdIG7TRUsOChA348EX
         IvepQuFkvTy0BvCJJ2f18GElUW8U3KsybjGPLsbj6s1nURuiTt9fXvUJq/eDrGDgpmNY
         7o7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727452385; x=1728057185;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4BiMluZUmH1JGlBxZinaGp4urWPsU4oh4J8N2PfMdr4=;
        b=R98Q5tsDWlKpJYoMd+ba5tlbinehCIyak+VN7aNRaFCsw6IFdiwaPZE9HbGQzajFhD
         nSpdv1l8LYa+Wt3UVUJQCb7npVmgX75X1RhmuthEctQbN12uvTkiInSTqLi63/T9Vsau
         L4wnrkaqmQ0VyS70oxYqZfi6VgGqL2LG4eDvRgWY5vU4+xEKjW/gFnj2TgzhB5OwPwcz
         rf6zFheeSHlvE7V1QfB9h1yd6SJ6FI64Elmgis6ZULJjzkk13sk7+xxhU3DWSDUXYCl2
         xDclo4gKhppVJHguNb2XkrxUtW8/nRgKFdmmY/BrZErexzsiYEkdte+UiJv2w7AOllWA
         5a/w==
X-Forwarded-Encrypted: i=1; AJvYcCWzTWP9P9LK1EGqp/B0y5TnNhBplvFmr6ddoWSSe2esgmRxbkHi0UoMLOiSYPj1GEEaxQbGaKO2@lists.linux.dev
X-Gm-Message-State: AOJu0YxDipMV1Cm8uZBvVCisxsjpm0/pkZfvlQjg4fjm/FpCQZ+J9yLH
	gPCAgy8wN4JuB8jvP6ZJBJUPESxftbZFNQv79xolZ4s88YOcBmdG/UNuwhYzL4h9XsqHAgKq9eM
	8miOORru5wmZ5Ox4OUz9uC7qgmSk=
X-Google-Smtp-Source: AGHT+IF5LtoCyQonXFQos63YxjWAqziR360Po3cMod+Wzt0mpCqneWqx47LlZAcAKVWzNjcZ1JM3nDXlSzixSss2UtU=
X-Received: by 2002:a05:6102:3a0a:b0:49c:1060:78b5 with SMTP id
 ada2fe7eead31-4a2cefee0famr2889730137.4.1727452384622; Fri, 27 Sep 2024
 08:53:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240927121719.897851549@linuxfoundation.org>
In-Reply-To: <20240927121719.897851549@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Fri, 27 Sep 2024 08:52:53 -0700
Message-ID: <CAOMdWS+OW55rWa4FnHgVG0wVFA5TB6Qq-auLC0ty5dUMHLBnOQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/73] 6.1.112-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.1.112 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 29 Sep 2024 12:17:00 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.112-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems.
No errors or regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
