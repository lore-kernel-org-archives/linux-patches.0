Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8B8347FEF
	for <patches@lists.linux.dev>; Wed, 22 Oct 2025 18:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761159375; cv=none; b=HOw4/OotuI/Ci/NAlv9US2q7o6bv14M1ykptPIn/hGiBJdQevH/aLqgfOYG2S9ljmT5QDpH4MjEETnVNNSUq+6g7kbmQezVkIDzwm/R+XfZSbtmjsITekG6n60Qc64pFRED+0bO961tHN9z2BmSevLOPXUTVvEiqo/cQzhDWNWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761159375; c=relaxed/simple;
	bh=8+jnRCt38ZENX1NztlGe9YStpU+b5/SB937qYnXD5N0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hJD5+4nNuhbGzF8x6Stvh+WcWphw3nHgnqMN13XzD2XAKwPEuOAfvKmkUjQf/5w14aF3Iz5W7vhjGieiLMGPfeq7ZW2W/cRtiAHvnJB34kPy89baRMnbFF7xmZ9OwVJ1+fbstHjonWMhRZlrKlsuHNhMZaVqkPxUzV9Cq8QiPxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PfFM8ycj; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PfFM8ycj"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-57e36125e8aso6842217e87.2
        for <patches@lists.linux.dev>; Wed, 22 Oct 2025 11:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761159371; x=1761764171; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ycqI0zLskmdJ9GL89kNkCWpDO4WHedc5HuGOuYMuhxQ=;
        b=PfFM8ycjliMIyLtBK1fFY58PmRufb4MUlm4C+v3LgHE6lASGU60v2m/VrQ/bOj6QOz
         pkyM1YxRse5wcd8pRbDo6KCImeIagLsdMbulw4KQA5IZGxmngYeK8tLjXAFwOTaIgz4g
         +8/ommJ7uHp22pYxIgMneblm0JHPa2NAXIQkuq5hu1YSAvG8Qo1Hbh74rQL4YUK2IYXs
         SreRWFEQs+xCNsrEQxZIu6DE41gmHCzWSs54mV2Dtxv4/kwjzasa9DJ0Duxqb3IJBdiW
         8qsi14yXqsJIawWNBfACDqBfNIVuyg8sczuZ4y8ReL+GUU5qwK8KmRuYmj29cYlh9sfe
         s/gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761159371; x=1761764171;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ycqI0zLskmdJ9GL89kNkCWpDO4WHedc5HuGOuYMuhxQ=;
        b=PHybMyNDOs5CAOQPJOQie9RIN1nphODO5UzMlDWccq27WIZHxG0hb51eaicD9/C/4T
         HPeAqy1BCTUw5xXv6KO/Y5gpo4T6pePGAhUBUA2dcrWJxYFrRfMhz0j0Q54/yhNmmFXK
         2/hruuxD9H2h2ZCS4JDTyaAmO/h8UHNwYX8LRL5pvp2S1tYGQhk4YzNU1qbll+1cNEwl
         YNWQ1MpduaNpzFnJ3YYqSgqMwHhz54gVi0rKtl3RC7MwJH1jcwWC06UqKgPbPSc2RDpC
         Kk1xzWKE+boTAgEwsqKCummSzkgVVwWMgbq4hUjKKs9FXzeyX2ObbUeiWmWrtwl7761i
         0viA==
X-Forwarded-Encrypted: i=1; AJvYcCW40p8iWdHweWjXEpORrNEjXD8YUdjh09PQ4cv7BQYBrDaDEYTj+l+/v923SIDnmGHukIT22yn+@lists.linux.dev
X-Gm-Message-State: AOJu0Yz+Q+SymgPpM7hywmj8BMutEN8+MrBikWLiIpgy3G0nIILtwLlf
	cxT3aer2fAEOv35uyYLbBKit9NV4WpqN+8NdPqnO7dxtBg9G3A8QITv1GZnPauYSszRBlNsXHNd
	2b5ai/M7JXZ0KqKbiagp5lVV1Lgi0BZs=
X-Gm-Gg: ASbGncs/O1O7hzLzT9ZDRpk82XSu1kM5Kkhfr+vjjgzanrdAUpo37n74NOtU9exbKGe
	Md3ggBETKMPHLumNzxKCkjLOg/or4I4skuV9dQ9jeRVQCKxFFKsxwE4xWiHcmyxkmkZ0/4bezeW
	cDApLI4bRVXQygp3r+5ys8MyHo/sd2Eew0o7J5lPpnAF0fINzujiSWc+GnWKAe8PIVH04deTXmw
	FUev36lDZ13+iIxyqH5P8OteXxfIHDYBmWqxYFiHQ/Hl1m4ZUPLARuWPYV5uZLwlxnkez6sM6qy
	s9YYdduEs7Vn2dsIxZlGfmM+Ng8k
X-Google-Smtp-Source: AGHT+IEQK4lS7wTENTmg3d/K2RTVRvkWxz0OmjhCi4GxGNpOceINpP7P2RhDCCW2CVuqatkVa43OfxUQhgfzhP73I+4=
X-Received: by 2002:a05:6512:3ca9:b0:578:75b3:4326 with SMTP id
 2adb3069b0e04-591d85898camr6905309e87.29.1761159371180; Wed, 22 Oct 2025
 11:56:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251022060141.370358070@linuxfoundation.org>
In-Reply-To: <20251022060141.370358070@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Thu, 23 Oct 2025 00:25:58 +0530
X-Gm-Features: AWmQ_bkxIq78J8bGR4Bl7M0BIY16lHxaS-yeq4_ZNjZukPpJrSPGuGvQ-EnMbjg
Message-ID: <CAC-m1rra_aXm8aV9rwQjPKBf9gGDHeqe0E5MqpWHd1BuxgUgeQ@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/135] 6.12.55-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

HI Greg,


On Wed, Oct 22, 2025 at 1:49=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.55 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 24 Oct 2025 06:01:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.55-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------

Build and boot tested 6.12.55-rc2 using qemu-x86_64. The kernel was
successfully built and booted in a virtualized environment without any
issues.

Build
kernel: 6.12.55-rc2
git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc=
.git
git commit: bd9af5ba302635dcb1e470488c0fdf70be8d45cf

Tested-by: Dileep Malepu <dileep.debian@gmail.com>

Best regards
Dileep Malepu.
