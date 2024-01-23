Received: from mail-vs1-f52.google.com (mail-vs1-f52.google.com [209.85.217.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24BAD7F7ED
	for <patches@lists.linux.dev>; Tue, 23 Jan 2024 17:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706030594; cv=none; b=qQoxfkkdfYTzg2Je4jB1Vm6oagQw8Vsi8ETrr8A+NfZkr6p+5A765md0YlS4tXfJs1tgmsT37PrCI/BNXTseMAn6H/SQ+H7QrPtoEDZgwl0M5ymIZKKFnS/8QK7n9O9toqQKom1KP2+iQlb49rE4M0UpSiUdw2vTjWyQfUyfz4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706030594; c=relaxed/simple;
	bh=VjOCCRvjZlcp3HeswXG7ccqi11RQB5jbqUpjgpCOhJ0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mSNQH9bSsLV3F6wxyk5aSWPSze34Ms0lNKXxovQ7N8swVUaeS5fJrts/4XtfPxMD4Add6XRGyNfkoPXDuzQmfN/VrFzbVMwjIEmx7pB33flUYsoDOmOQLlSyrzNGztlL/Vj1eiC2q7k1jisCpobN8WDuopiaFzvwO2b/RY7vKTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I9ff+zPl; arc=none smtp.client-ip=209.85.217.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I9ff+zPl"
Received: by mail-vs1-f52.google.com with SMTP id ada2fe7eead31-466fb179334so1043966137.1
        for <patches@lists.linux.dev>; Tue, 23 Jan 2024 09:23:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706030592; x=1706635392; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6xcKiR/+YbtLA6pfdjopUwXRfL0HZKEeurjCoSWtgW0=;
        b=I9ff+zPlbRn/D31HwwUc8i5Uwn3t0z0m12ronvO/6bpd2RBtawoVhq6daS2WVi7ike
         lDMD8xA/9s7HAhE/ePZ5Gmd9mMAYoTwyB8MlJd+2ZvK0PTPQOP8qAITLeMrZaPcyM+g9
         YgPfKSbLtHQlFSkEPDCnv5jtTADBroribjQraVDsmf1RSm6N96Yd+j2AwK25p+y9D0Qw
         bMk37TYq5H0AGJuUY0nZL8/kQ2B5b/AxyRs28+sy+mPKR7+G1T7Nmcb4wRsHxo6v6KzH
         HEn8RjGj5xWB91R4MsRPAq6rB5kuUOGhTvkc2iOizgISACKLEpyDypwPh5LBxBrwJ1jb
         FOyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706030592; x=1706635392;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6xcKiR/+YbtLA6pfdjopUwXRfL0HZKEeurjCoSWtgW0=;
        b=bqTC+NvPBTiWsqKXwSv304Y1dv1KsQGPgWPXIbLMsgyWfoflyDv6qEjRWLE2tFKI7J
         Nat/u9FhFuQCvGmEpt1xrLAUjlfoP4n4dM3qZhWsxv5knayO5htDvT/x5y8Fy0hdGfMy
         saLMsX8N9tn/8YIcpRS/SFN6jlr2QsWt78H3sIQfHTCxGRBMuK/9GbDP7OJ6xgIQGWsx
         GAaRNSc6S+xPqvyxnvSQYhjbt+SgiruOjYySDqPKcgYaxuHrzS4alK5EuyOhuaTBZq4T
         KWVORJCp0/1fijBLrfKzJJeY6/WBnX2ryrfcMjRXaQWpnODNUkAws9ndOKg9UeW0H+Ky
         0XsQ==
X-Gm-Message-State: AOJu0YxCV9Iv3nSCj0vxFZ2UF92fIvT5T2zFmNCamXVetjYVG6BvWKLO
	rfIER8LpOMHNQfOr3WkUvMijEb1W9XXg3ke8eEW4n58npxnrvqezdC3xmAk98FPHk/8PAkqnEjP
	q5eZ8wsIxPfony+ucAJt+MCq2k6U=
X-Google-Smtp-Source: AGHT+IHjgo3cj9PLdsHSv0ggSy4V8ICI051ObNLrpQ237v0h/6xIeo/EGJSigc7wW4w2VNylO9y3DQOcCC238V/AJu0=
X-Received: by 2002:a05:6102:52a:b0:469:4f37:8a10 with SMTP id
 m10-20020a056102052a00b004694f378a10mr3397622vsa.11.1706030591931; Tue, 23
 Jan 2024 09:23:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240122235812.238724226@linuxfoundation.org>
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Tue, 23 Jan 2024 09:23:00 -0800
Message-ID: <CAOMdWSKRaYnYDf4Jgf0fsBXhCfhuf1Jnj3S3Vd59TsQKw-35CA@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/583] 6.6.14-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.6.14 release.
> There are 583 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 24 Jan 2024 23:56:49 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.14-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
