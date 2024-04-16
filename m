Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5B612BF2E
	for <patches@lists.linux.dev>; Tue, 16 Apr 2024 13:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713272865; cv=none; b=lmKzOvzMTs6Ztw9xtizhwRO7L4DxYln0qXzs6jGlIApGoTwqYKCBh71IYQdOshh3c/534YwbI3eQ6MPDckIP7J+4IWDJebM3P37oyoTcC2zZQ3g53z+rU5HeqUiGC1Vfmj1MvSmFESsX0QAFuiJ9IZABAebYXhowPCLDzikSgXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713272865; c=relaxed/simple;
	bh=7uLnhRptJhIlL/WoucKKi6qhTOkpC62d1wAP3c/jHHE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mYMihu54CBrbM32OPHPFqzJqqMvWDXfohi7872GfZafhID8F8ud35q/BdxB5Xk97eCnobkqEQ6oGzKNwJpApYircF/Il5MJJGlIfcjKX457subI4v3PCXO5VxLaAaopYhTCubVx4D2difGBQKRgKvQ9ftEdVFhJzg+KvpYvosoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qwyhSOlb; arc=none smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qwyhSOlb"
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-5a49261093cso2327612eaf.3
        for <patches@lists.linux.dev>; Tue, 16 Apr 2024 06:07:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1713272862; x=1713877662; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Ea6CgGbzHVftCIUlE44bhMIJf3xGIJgS5bdRui+rEss=;
        b=qwyhSOlbAnLHMDrgVnGb6mBGLxIbsaUXAdFPzMTawc5Wca971s9l+T9LN+gEtcvigf
         6EUWsE2mG8XhIqtMsuvzKzPt0pvd7tU5UYW+Fmvt4qGBdBo1a67eF1pilFy0g5nSmJGY
         VI5qd+EBXWSkIbCxz11oRID+ftABnubtYP1v5fHAzIjAD1LUtlbAZ2R7wHWTjcXoJWek
         dVyuogpnXVM9d/2xs3SXMfBYIUaSrgpB+Sr+T0zw/UdgJEEXhS8EIAiM60CjCsggCIFK
         fa0iUf3EiO1IA9vKgLGP5x2QuqDK2WUPAPQ19YYV3WWkSeyWYUE4/+W+4q5BYdatWbHl
         SUYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713272862; x=1713877662;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ea6CgGbzHVftCIUlE44bhMIJf3xGIJgS5bdRui+rEss=;
        b=bqN0pVAZ4yAJ3KbWGOi1BYJBp5H06EzL0zdblUp+/pJKfPUQGeloniuxCAs7qe8McN
         qRn/b3EZPwoD2t7LxN5P4R9zVJHFDB7De6jdFUamh82SfuAoPvwnY0CGT40khZMbhcuN
         zUW5fFqq5oTeQ0I8paO5dGL8PuCIaaBIDu7N9ONTxpgUKr9cwLk4MC4I/LmMhFXX7dP6
         Y4pJZpNaJLVExmCzfVnRio+33gIuWSngKEC4lyWzSRsoGKBucA2NFRyy6hZi4OHywFvl
         jlw8UnW3OyGvTfsn6qXtwijZC3XKvlZByu4rJDiqoy7ACuJflQ2PEtqn/VxeFe9/j8z0
         cstw==
X-Forwarded-Encrypted: i=1; AJvYcCUvV9TcrAq7jTH6baXA0dlBYrswx4wv5KAWgoQmz748Z0ZzPOpJkQkcuthmQUZ18+RErruI4psLANSCbc32V2H3IhFcMWdARw==
X-Gm-Message-State: AOJu0YyoxVEHdRR43dtrd6wOQS31F/4USlgr1qynNnF/6L2VDlA3RG5D
	2Q2cC/gEFETtUv3X8T9T8PR3rxKu+KiXPyNVc1H5MlN9j0fLd522HlngYy1fT/+xNVU6sYMaJ0J
	/aUHNAMoVHVEcWUEWLzU7sc3q339gIy9neF984g==
X-Google-Smtp-Source: AGHT+IH7nHIwoL3TWj/tf4kEGG9jfaQ98hAGzRADAS0JU5ClDVgTBcndZ1ImALsskvzSGFQFySrHCtTqVF/FVHBvAsY=
X-Received: by 2002:a05:6359:4b89:b0:186:3ae:e13c with SMTP id
 oi9-20020a0563594b8900b0018603aee13cmr15909727rwb.0.1713272861886; Tue, 16
 Apr 2024 06:07:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240415141953.365222063@linuxfoundation.org> <Zh5UJh31PlBkpZWd@finisterre.sirena.org.uk>
In-Reply-To: <Zh5UJh31PlBkpZWd@finisterre.sirena.org.uk>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 16 Apr 2024 18:37:30 +0530
Message-ID: <CA+G9fYu-AjRm-BBA=8fWS8oCbBJ5W443JHPh3uddD7ea7MY-YA@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/122] 6.6.28-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	Yihuang Yu <yihyu@redhat.com>, Marc Zyngier <maz@kernel.org>, Gavin Shan <gshan@redhat.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 16 Apr 2024 at 16:04, Mark Brown <broonie@kernel.org> wrote:
>
> On Mon, Apr 15, 2024 at 04:19:25PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.6.28 release.
> > There are 122 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
>
> The bisect of the boot issue that's affecting the FVP in v6.6 (only)
> landed on c9ad150ed8dd988 (arm64: tlb: Fix TLBI RANGE operand),
> e3ba51ab24fdd in mainline, as being the first bad commit - it's also in
> the -rc for v6.8 but that seems fine.  I've done no investigation beyond
> the bisect and looking at the commit log to pull out people to CC and
> note that the fix was explicitly targeted at v6.6.

Anders investigated this reported issues and bisected and also found
the missing commit for stable-rc 6.6 is
e2768b798a19 ("arm64/mm: Modify range-based tlbi to decrement scale")

--
Linaro LKFT
https://lkft.linaro.org
