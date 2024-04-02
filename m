Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1AD31865A
	for <patches@lists.linux.dev>; Tue,  2 Apr 2024 05:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712034085; cv=none; b=NuWwh57piMfVc0JzPa/scjxN6O7nfPEWzD55pNubfYWLK9rbiNS/uck3FG5vaSeqU/Dumt6npvngO7y1Bw4yQ6sC8PoNIKs/P5RnICVBsdQdIaWKsTYUNxTTUQLdA82BS2OLsoyjUYDnJ1rK6WKXif+1Jhm8lQiRE5LFDvAF0R4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712034085; c=relaxed/simple;
	bh=NlyBxPHAyNv7/T8iQ/z8RSMGympsoOOW1QAfZRFQQYM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mbrVBMljrd9By557O0YFNWSnZhwK5wwiUSKd2xYqW1l8LUymmPPs1gNM5WwIbbKDQQ1MBQ+9b+ChuY2sWeIDAWZCRjtzZ8u95MJH95yjHm3b18Z54yKUAggJlR/ybB/VTAznOYseY7x4RxsMxW19O+d0GT5sDnzog1VfFmJMlTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xHeEiwnS; arc=none smtp.client-ip=209.85.221.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xHeEiwnS"
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-4d8881c4668so1450537e0c.2
        for <patches@lists.linux.dev>; Mon, 01 Apr 2024 22:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1712034083; x=1712638883; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Q1gSlS8fLmBzxegVrsxC5VK6VZWbcNLQNxJqECmZ5UM=;
        b=xHeEiwnSfnUZsvtA9cz8uNWkR0XgbRX0IfXsPFwrmH4G4f8hZcPnfBgzD16CMRIuTX
         5wrkjQiH4GpFBnieUZtdsIpGlb9kVp4J4OUpSfkgJrPP+Qmipx4SVKkaBn4NqGpYo3Zh
         qHzdvPQlbCBsxejhGSaxLx0c7+unj4krbJSk2ZTJCe9RMHLMRGsBPS3g17/tqgkNOHFK
         cN+1Cmq8JgO8uazNbnNaS6L5Gn3e5DA5222orxZnl7x4VSK4qT8pckG8AEF+CUSSsEyJ
         kDp5NsVf6x7zOmINjsbAVwSdrxgc36FV3sw5McRPJuOVOzURHclT1PBCXBaOSLwNYI9r
         tswQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712034083; x=1712638883;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q1gSlS8fLmBzxegVrsxC5VK6VZWbcNLQNxJqECmZ5UM=;
        b=iSexBD7ZGuz1H7E8KcIQj8boQ9qHxsc0ahhoEgp5f8Jtx7xRKpA7rJCSpSYuLX+3B6
         RusA1Ztr7suJUmZ0OGxDiIFb9zDcScTuWG5kelt9vfiF3fb2t/Uyz9YKTv+VcG7OoLGw
         7C55ZHORTl9s9so5OVeFP1ITqNATbwDOpLmR4bek9AlAu1rJ2QBP1/hRwh62YSDK80UD
         cCJrLU6u2GQ3UmOYseVTdi8r+XSvFUEkDuxGQYyKbXckTdTvwuWMi69LOKeVbgIGCVDs
         MTRilWszsdV67JXzBzRotLbBeOotTB3s4xxq2Kzb3SGnv5DsIkPwGgatFTv3nU4MFq1N
         8Cew==
X-Forwarded-Encrypted: i=1; AJvYcCWEc2ZMszQkMH8AER8fVR5M2pYZK/hz9lCMbaa+Xwlk94Srogfjsb55nZPJ+mzLUVM4OzgSZPLeG9D/qasUzBtuSCXF9dAmpw==
X-Gm-Message-State: AOJu0Yz8ToS58Kpz4RtItLtWoZu+OHeyRz3nUyU7QgTOmJl4eLUFLVkj
	ME2cMPYOYC0GnhjBlUG9VBr2++dHtdXPhWdwSnUre6NgHmcsbOP0KhVZAmAyaTEhGBYyBlMfzvC
	yu0PO9JwqZ7l8+8/jpBYw/XcAwY5NvlSlsqyVBQ==
X-Google-Smtp-Source: AGHT+IFbWd87Vw4lUKJrcGZtFq6L8tz7Pk5A3fnIVM0X6MCy+GrJJQRDnUgtXO3nhQHsmMS7Qn2OwbW+bWyfrDvPcd0=
X-Received: by 2002:a05:6122:a05:b0:4d8:787c:4a6c with SMTP id
 5-20020a0561220a0500b004d8787c4a6cmr9108749vkn.5.1712034082741; Mon, 01 Apr
 2024 22:01:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240401152549.131030308@linuxfoundation.org> <CA+G9fYuHZ9TCsGYMuxisqSFVoJ3brQx4C5Xk7=FJ+23PHbhKWw@mail.gmail.com>
 <20240401205103.606cba95@kernel.org>
In-Reply-To: <20240401205103.606cba95@kernel.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 2 Apr 2024 10:31:11 +0530
Message-ID: <CA+G9fYu+U1kkxt+OGyg=qSr3PfZipuazaANNTdfKvdY_zQBxyg@mail.gmail.com>
Subject: Re: [PATCH 6.8 000/399] 6.8.3-rc1 review
To: Jakub Kicinski <kuba@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org, 
	Netdev <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Arnd Bergmann <arnd@arndb.de>, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 2 Apr 2024 at 09:21, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 2 Apr 2024 01:10:11 +0530 Naresh Kamboju wrote:
> > The following kernel BUG: unable to handle page fault for address and followed
> > by Kernel panic - not syncing: Fatal exception in interrupt noticed
> > on the qemu-i386 running  selftests: net: pmtu.sh test case and the kernel
> > built with kselftest merge net configs with clang.
> >
> > We are investigating this problem on qemu-i386.
>
> One-off or does it repro?

one-off.
I have tried reproducing this problem and no luck yet.

- Naresh
