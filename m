Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D8458ABC
	for <patches@lists.linux.dev>; Sat, 25 May 2024 16:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716654401; cv=none; b=Brq+zfQuNw4FtxGdD/zEI4n5rL/0tItrCSEKYroDglO5YGP11xbE9UT6j3K9CWTsNOpael94PMM/RDnwKgmU4mstkVPPzbsP9ZGTJQQb/K09U+XEBGLCUfdtA6EgSLQbXu+EDtjChGBpbps4hG1CM/QgUOSxw0hrZPFU55QUlmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716654401; c=relaxed/simple;
	bh=0tlMPX6pKVegbdDRsC5185TnEuGv0EPstndADHcDnVQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QXhp7mfDvErZHuBYp5HxFuWhR1KRc5ftyaR0nsn5t69lvQggj36VwQiBk3yu1NxIaFG5E8n46S9SxWiMRTV8zfr+PrO62WfkYOitZzRlpXfTaCLNWhN2wIgbmmuTe0tmZToUT5czOh73rkyBbG2klRog6IlWp9laqjn5QC5I0C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gdOR+4EK; arc=none smtp.client-ip=209.85.217.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gdOR+4EK"
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-48a39aa0564so481548137.3
        for <patches@lists.linux.dev>; Sat, 25 May 2024 09:26:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716654398; x=1717259198; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mKf5sUaP65S0QiB6MPT5XlN7Ji2S0ts+rReTIXBK/9Q=;
        b=gdOR+4EKggEu1qAUWtiwDRAcHCwuZGVGzw245qeRQ2oaNCM7mSWn2oiDH7adfQ4XiB
         UguZToMeal94QCFxg357/j9FFCFIqaWLVIBbhGIPwRBJP6ahKD0gnq8c/y+ruj6mHc9v
         mV/LyXjeH0x9SU9fsJ9YABoVLMkungnndbGSErbX12avj8IJkEezmcBCxhgUb1vE/WCS
         9cbDzLt6Dn5yLhvc0UMB43Q63NwZKrUzZcUTfDHs7+v23VeQdQLRjb+mHbr3dA1qA7j+
         UfjP8ntghBo+RE2/HNs40bz5I3cjFctReeIJsYo+6jY0/f3VIeeIBRveC25JWIthM81h
         iZTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716654398; x=1717259198;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mKf5sUaP65S0QiB6MPT5XlN7Ji2S0ts+rReTIXBK/9Q=;
        b=hjpqQ2QopkRtd4ZE92J73U9X8Nw/Czj95jWz2ZvyXyheFtF55wb6OKp7BvWdiziAKH
         YIAWo+vrtOqjJopa6I1tV5YQy8BZaic1hw/0tgA+0AcNkJ455aAkMwezRFo1+WKNYxJZ
         xZ06UxlNIGi/PkWybkRyM3ykVqZis4QIeLJ4deRTtZTwZ+jZKnbL0DwQv9AyfbcikM3P
         sUu9gg1CblFmCVUlqcPaf4NU1tbBiXp2mdntQMI55W3SDnL2xJqItx//CYiWElCCEjcA
         wE/XlGLcxrrF2w/EvbC7UUGBvp9DY9zf+4qlVVHcyGvzlzrC/nkc7MM0GxZTp8DpkWL2
         LAPA==
X-Forwarded-Encrypted: i=1; AJvYcCWDYYW/KPEwF6NbxY+PIbHeCUCv5/pbFvLBu2N5QEPEwD/A3kWXszDGKv3Ttc2AyJNIaW8RkbCkTqfwUZCtf7/UXuqVPyAjmQ==
X-Gm-Message-State: AOJu0Yw1XfkIgHnyVNuv9uZJM2+4cEkBoD5ymAZFKbu6vmB5YQvGgotD
	YUHOMzrRaXmqec+sm7vM+mijDecMhqMsUXOtW4FC52XfmxOYCxAw2KN6AoyJvGyUrl/Wht4JOxb
	n29HG6l1cOfJCGdSt90EmGRrxL30=
X-Google-Smtp-Source: AGHT+IGH6zvOvxdG02BDd4XJMmzu25FAulQG0edcfbV31ZUG8F3+QqEbE4GVxagFz3kYZ/ptgWy5QIUU1Qa2tcAildk=
X-Received: by 2002:a05:6102:50a8:b0:47c:549c:d6a3 with SMTP id
 ada2fe7eead31-48a38516f78mr7186945137.2.1716654398560; Sat, 25 May 2024
 09:26:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240523130330.386580714@linuxfoundation.org>
In-Reply-To: <20240523130330.386580714@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Sat, 25 May 2024 09:26:27 -0700
Message-ID: <CAOMdWSKZPBvDmzSsVdrJANaNeo525B5keoqPMod9eu0uTy0MAg@mail.gmail.com>
Subject: Re: [PATCH 6.9 00/25] 6.9.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.9.2 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.2-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
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
