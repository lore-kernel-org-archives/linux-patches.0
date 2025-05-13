Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40FAA171CD
	for <patches@lists.linux.dev>; Tue, 13 May 2025 12:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747140647; cv=none; b=hXhmNG6ZZvRnRKsinOb4NUSn93fRoBNx8o3MgMYdeCm8d4J1JVH4Pl101VQLkpvIMcJ9XDxFnyVJJ8g9f6M6jI0Rs2K8Plx5VznvajYsbo9oYD6d8we6wtCeyB6kTMD0Mhu+lblaUDwslLdjXxcI7S4v+l6Epsc6Go+jNC474Lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747140647; c=relaxed/simple;
	bh=cbkNHpfCazDp/U2uIDhXT83+u8gzdMCgbpu2J3wJRIs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RnmNBLrL9wUekZlcaoq8OzhDZ0Q97uXyGiV0fpJJDrpbVPj0dZrI3sWO095huz9DRcS489UC1LJ8tQFCT/E7Rs64pIilR7uJFkBLVFkrodM00hWJH2HUtUDYzqKk3k6ajZFxhpVGyoJxVtCOdq8Rh1MqTShEaGydTWnVw1Htmqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com; spf=pass smtp.mailfrom=ciq.com; dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b=o6wcaFPv; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ciq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b="o6wcaFPv"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-7c5e39d1db2so363187785a.3
        for <patches@lists.linux.dev>; Tue, 13 May 2025 05:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ciq.com; s=s1; t=1747140645; x=1747745445; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6fIGxDjB0SYqfDID/zzJ+9sqlaZDZdlnVxHTIBP3fm0=;
        b=o6wcaFPvSpeFONf4cidwNJ+GIygcgqKniaQ2Bc6hOvJ/huw485iK5SwvNj+RFoxc8Q
         sZ8ODmFO+k0XgtjmwoLyqLglVyaFuPydZlHn25XWudKFEUOxEfq+lhKMTDy0k3TxTQvD
         /H7bPPtCP2VR47NHiFhp/54f3l4Ga/Dk3rT+VLXmSiFn4Sar2Ihe2oFnsSNppH/Km/lD
         qt9jVBb9csVly6P4pKnJ3PGOOPmKIv+LlcXfjmYSB0JUfr3ZhOVLoF0mNW6NDxyHuEUv
         2DtHcoi0rYe8HChfNaA9/SacrolvrJieESSTsZwgAnB0cwgf+8NOinqVpCPU9X4dYnLW
         zWlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747140645; x=1747745445;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6fIGxDjB0SYqfDID/zzJ+9sqlaZDZdlnVxHTIBP3fm0=;
        b=wrVdvivI6JTH+Kxna3gKjTGUSz3qW++LRJ2ODFOydyTF2HxLTUP4vImNz/PlFjiaWB
         fGJp2sTyVgfn9+J7P61D1nw28L/z+vk9mwTLFU9cIvdP5P90HdFefIZHhYxA6W49KFjZ
         GGD/C9nsLw/F2qvwQgkHJIDg6Wqrpg35HzdTTjna545yMHO10lKHbRMM1TNzXcP1JxAQ
         xI9EsM1MU8nhMLPpmjo3ozIiIVDYafopz2MHWh9u04wr9J7qtdbXSrjMejPhNp56zGLW
         t8gzxpSxbIbGgUs6Pgj3Xc/u9MLUqv/i/mCVKhwlT9++R+5V34D9cc1zUTzA2OopbyLc
         PUWg==
X-Forwarded-Encrypted: i=1; AJvYcCWIVE5wZuzCc8E4cxdqTZ0BHcD9OZS6QBY9hcJogszjA6cQlZXaXJNH8GdHzHcXSma0D7gWNYHp@lists.linux.dev
X-Gm-Message-State: AOJu0YxqbY1dnieyBNK/ipBfxP21gMpRnpH8GjQBHPmN8yIonad58WGb
	lir3wlfV3HKGQ1gCVnxachwPntfpHcV5tI2k9FNgB/GYgAjhmbVZtyNJQ9SftPTu7gi0ifNwnpE
	vKZZARj8uET0dxDr+d8BFjVNPOdmByyrN2cN9Nw==
X-Gm-Gg: ASbGncuIm6tEDbr5yTVSTXxFfsJnhk9BRvUiR3E5vlmUKpRLCn/G+5Llsu8obFqPzGr
	VywTPoBOhAX2gh883aqfsr9IqhqwvFSONnxR2XvmelXI4T4hSaR7Vn1DH96pOYJrisufHx9h/Q/
	e+S4Zn7VeqwgDqjVERKNE+5KaUKaxa5YN1
X-Google-Smtp-Source: AGHT+IHBEdsF6gSFx1qwBk8MOhT+FX89ZCga3+pTyELVVHANhV/m9TZ/cnRgBn5szaUnkrhaLYyUlGiH0Cn/NnATxfw=
X-Received: by 2002:a05:620a:4403:b0:7cd:92:9f48 with SMTP id
 af79cd13be357-7cd0114f73dmr2851585985a.52.1747140644988; Tue, 13 May 2025
 05:50:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250512172041.624042835@linuxfoundation.org>
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
From: Brett Mastbergen <bmastbergen@ciq.com>
Date: Tue, 13 May 2025 08:50:34 -0400
X-Gm-Features: AX0GCFujP5y8odal_JrTQezDnw3_S4uS2-SeBQTOZ8FQ5LfW4rl2-L89_wnvi1c
Message-ID: <CAOBMUvgh215jYs+YzZ6+MxM3VNGL1_ZQ-yx9k9Fjn7NxSdbXCA@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/184] 6.12.29-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 12, 2025 at 1:58=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.29 release.
> There are 184 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 May 2025 17:19:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.29-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Builds successfully.  Boots and works on qemu and Dell XPS 15 9520 w/
Intel Core i7-12600H

Tested-by: Brett Mastbergen <bmastbergen@ciq.com>

Thanks,
Brett
