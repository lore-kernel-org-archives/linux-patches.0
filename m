Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6415A3A5459
	for <patches@lists.linux.dev>; Tue, 24 Mar 2026 18:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774378702; cv=pass; b=takaUPSgvyb8Bv0c5mxJWmEkEAQ2TfLZ25qCrnFthBJlIgVRi+RiRSk9iXLXQ7+Qn2KYn/1ycke1A9yPCbgpp0gzIojaGt3KXfON+JKm85phRh8RMzWA9nAprqn6pGTRnWbP3RM5uUuYcq6zexbtD62+6Pc84m6rZLNoaJVHw6g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774378702; c=relaxed/simple;
	bh=2iXPRWZSJC6WzIlggftcRWzcicMPT/WOw7wXj0KhMEc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qOncSi9Of+B+/QwjsZmFHTEtTHKms/1k4K/CTGToT6Kkma2s6gJnuhacBuZnqbN63j8khyhBrlZQYP4B+0fhCYxqtHA3VXZo8OG9YdDooZCFbXKG3IQ2ryRy6+v769b42zgn1ab6WCViNHojNV3hZUMYwHqgqZWioau/++DzrXI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iuQgjISw; arc=pass smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iuQgjISw"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5a29b4404a8so284892e87.2
        for <patches@lists.linux.dev>; Tue, 24 Mar 2026 11:58:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774378699; cv=none;
        d=google.com; s=arc-20240605;
        b=ZZxHA2/fKY0aKqCw0q3tf/U/3veqKQ7CoSCsBo1RdQz3niHTr6V8XteHclGyjTxSLd
         65geWf56REyU1jp7yWRxagcjsNq4M2rjpKGNJtBsYNTeviESf5hO2R8phFVY8RPHdHO7
         /ULaIhEaNInSGNgI4hg67YhtHh2L7rOFf7YGoUoqA1heAHlXt83y9ZHCIXB648CnzJAH
         WomGuZg4r1P9oRNtgfBKpRxqqsmj+YnVnJ6fXZ7yncglJoTZ/VDKfACy6eQlfcLfNBkg
         GhJ/l2f/eIUIeaVbg2SHTKPy9Cj/fV27wtSzXFbPmEGMMuuukYX/TodPpnXnJcfU7XMr
         JwDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FjZ6lxukDkmg6wVk2rmcoTc2DBbvTaAH3QRjijoBVmw=;
        fh=tG6IcQ4gJ63EHBFs5/mLCImiwn8HBkCduw3VDmis7gg=;
        b=S/0Jxf6cNRhE/BMFshiDMvgPL8fc9MLhhAmFhAS0XLYFVZI7jueb2Ng90q56R/S3L4
         SXxe6NRnQ5hRKYQgDtCObNlkJ8zq5wFeA/8gV29C6t+jUHVfdQdQds6tnqNKNAHk6+Oa
         aELpcfuXPdtPePEhFbtDyZRoYxYHQqa8xXErormuucH/dRtrT7m4qwCk3gQRZhHxftVZ
         E1NAHYgCni68jl348M5mvOeTbFmPdsmELov260TQdxvjHMBWu6IZwh/QFiwpy0rXmzLu
         n1X280xTyFEOthrApWv4UXCykdTPtrPL0mj2M24P+4/Di00gm8ToeOFFK/dXKaY3iuAn
         8NOA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774378699; x=1774983499; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FjZ6lxukDkmg6wVk2rmcoTc2DBbvTaAH3QRjijoBVmw=;
        b=iuQgjISwKWm4NXwvRTZRsjzto0kpqVEBE6vi1mEPA3pZUFOv/ftnsm8qIlqGUnWvQW
         2VxxW92xO6IHeHRg9EbCNUT90JkP0A79go3qlWSDrS9tmQTsk3OxVtiBkeHPfPxWh0Yq
         sHnADaSbkimtT05iQu44V6iyE+7yFmFd0Uygkh9/nFQQz0ZL7j2TBusFSr8Ag17G5gpK
         UqEY/qcGTykXIthfVsw3Lil2QD2WiQwFAD7JZ2h5hwH9sDEepZYZ682oWdURMDwHEnwq
         mKYTfdiuFd+EVek4RncRZ0jxT3m37p+niE/+Bx80Kw/9PjZSzQGch5MWimeXz7AOo+CO
         Z5lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774378699; x=1774983499;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FjZ6lxukDkmg6wVk2rmcoTc2DBbvTaAH3QRjijoBVmw=;
        b=o0hFsW9lQfgaZOq0U6JRh0T9aFYWGpPdCeZx6WelKRlo1v9LbPalDTce876e38s/x4
         3UrJfHC/aBn9KGxye5RjDnZy7Gr/gch2jDJeP6+40zgml4t8l9ZSqCmVFgcwg2qSiIj6
         JZbh+ttS5mJg9gdNvUmHTMXKxbXo/rSlIIhyX5HoOk4cum1A0lV6IOOFWwJwun9NL5Gt
         sYNGq2gDqp2kWGdhy/qwUCfsiWqzBNyrdNxiqD4DDv5RoTqHFqbaQb+HApG/uzevjpR+
         18o+VjKs5cFoZWbtOoSP8MHsguJMXdWkPVg6Y0p1CWX1GfvYLo/oykt+pWnZBMypbOzR
         kFfg==
X-Forwarded-Encrypted: i=1; AJvYcCWKfXnWjYzOURmnIjCUU6ga9lAgEPaop50TN5zDIlVcmTFLWgMoZfbVgmap0HUjF3WXesnwO4A+@lists.linux.dev
X-Gm-Message-State: AOJu0YytCnlnEyObCaZ3zE8iB9n7/O8DYAeyig78IM0EI1I+wg8UtNmR
	JJjc41iCEj52CbKcx14CU/02y4PIijcYHIieeKHauRtKMXXluNVWAaHmMc5EttNB5u+g2qOtg7P
	PP3l/0nXqczLY+qVor9qCrqcwNXRmRS8=
X-Gm-Gg: ATEYQzyizj12n75eW3s/UmjVsxyVIlrUM6a+NzYoAI6wi1t54AkeIwlkdbl0bdOVIdk
	xHUykfkTBKPp+EBTJv4B6ePr+7wwh0C2MczgB6BE3fO6MIBH8WiY5V2C43UjWL3qyPTNlyvWyhP
	0uXKPoByZy0tZFsvwOWXpopz/9e1jerWg4VLyL/pWfPMmHeJhQuRMdeibwC/JBSE+pM+7eNM87U
	kQKLvegUsYqSC6rc0jhhB2+lgKog0z2p2Oxwk4Qjb8CT/LJym2Mk5blfrZNqCSRzrkMQGJxzbb5
	bh0pjszzxYRulMym0BdetjRBft+3eS16zpIYI3sgIcYGW3YW4I0=
X-Received: by 2002:a05:6512:2244:b0:5a1:5762:4cfa with SMTP id
 2adb3069b0e04-5a29b98a8d5mr239198e87.21.1774378699217; Tue, 24 Mar 2026
 11:58:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260323134503.770111826@linuxfoundation.org>
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Wed, 25 Mar 2026 00:28:07 +0530
X-Gm-Features: AQROBzAQg5jx7m2vmyOnwSzeZOEDkYEtQdW4GU4jGqIkkzOhnv-cdm0plaBec_4
Message-ID: <CAC-m1roz+Z_abZ=0_sQpf6Mnm7D1TvaZ+4Q47-mdu2QM=Ek0zw@mail.gmail.com>
Subject: Re: [PATCH 6.18 000/212] 6.18.20-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 23, 2026 at 7:44=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.20 release.
> There are 212 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 25 Mar 2026 13:44:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.18.20-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------
Build and Boot Report for 6.18.20-rc1

Build and boot testing was performed on version 6.18.20-rc1 using the
default configuration on both x86_64 and arm64 architectures in
a virtual environment. The kernel built and booted successfully,
and no dmesg regressions were observed.

kernel version: 6.18.29-rc1
Configurations: x86_64_defconfig, defconfig
Architectures: arm64, x86_64
Kernel Source: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux=
-stable-rc.git
Commit: 81b464548274640c3c68993f4bc8d17369263096

Tested-by: Dileep Malepu <dileep.debian@gmail.com>

Best regards,
Dileep Malepu
