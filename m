Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1E017741
	for <patches@lists.linux.dev>; Sun,  8 Jun 2025 05:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749359648; cv=none; b=dfqLMvl7jNvIOLUmb/oaGSlkmOPtfVreIqLg0QCChvsNnRlFCbH1fH6W/twC8dMWzY0M5EJOBc4yAzS/kzonCRVqIgyK+hR96VMFplzMImjR33Yk2MuMEewAKVsOZPDSrnO/DmNAggCCQkKHDDZjDtKWKeQ2r4taczXTcpn6J/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749359648; c=relaxed/simple;
	bh=R7yFIfJJ72yu/12lLfw+YdCnKdRGHYhVeS9kfsURIWQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QZVLUxqyOsBBHC5CgtP+LfT4WGvVlKTVCT70esgkaHt5rHoR1lU53yvgTcsQ3Vf2GsCMRAT/IeJOcb0sFAH27TGPon063cq2KZ1llr1z5tdaeMiAj5KxeOvj5jgnihDG3uzxe3uYwyJaMPWtdIUieJZw5hcETJ8DlVIqnQAMh6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=PsSx3+Gc; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="PsSx3+Gc"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b1f7357b5b6so1942992a12.0
        for <patches@lists.linux.dev>; Sat, 07 Jun 2025 22:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1749359646; x=1749964446; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bq24FXrS96fZ/hOloFhOjn4H+O+16opz4TqnnVXi5gI=;
        b=PsSx3+GcqCYF92L09y8y9L15b4n4EmVhU7uwWHiSzJ2aUNFjAFF0XIrg1E+mAVH1Qi
         QXQ6vc82cpApfM2AmAZx0NGJmrkLieGWocKL5gmuPpboJ1bycNYEHuaN10APH/84C/Kl
         dtJMyaZhHWDO0gxf1Y6gj0I9xUlOgd2YRqJho68ZoimHBivFSJUxhnUo/aNxAFfYF8aI
         2ZP8uSQccOAuB4XDJz9+OFlLWSRo5ZupEZID4P3XpUd9RpUmeJV2Y5N5LSHzyb19gmJ6
         7rH7SR/SZGuvV2ZzCE3rwdymjEy5VO9jPTc8+8hqf04t/eQofJ7/NBjfJRNtGPKI7h9I
         hPGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749359646; x=1749964446;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bq24FXrS96fZ/hOloFhOjn4H+O+16opz4TqnnVXi5gI=;
        b=j3gy3Ua5vVhQBPE1vkljoS0K8IXLOZ6UqKFXOeJdsp07kX1DyApRWI8u2LqkWDY9NG
         i9TOvSRHJROWiy2678uT/53FILvtPRUmEe+CFmnudrxibtiYUIcXoxLKHYrr+vRw22Sh
         SMSwCHWSgZ5qCT7nY0Cy5e6sibZ6ycuL9CfZ5bKoMwv6XzfK1nwAefFCQxV0Di7cooua
         QDOXmxQzhwCRb0fiMsISAV1g0eQe6IgOeeX2JgjdECG9zwh5MpTaOtiFrBHtKHw9yvNe
         bIJFFYbaCOpdXv0vt3yGHyatuoN+cIL6sWixh+nm5ls00mqxPAk7dv627w4VwO4RhNQ9
         wgLg==
X-Forwarded-Encrypted: i=1; AJvYcCU52y/YOJFFheKT9K9Fwk/AF5Xfua/IyZUo8nAy3n7lMWx9A48KpHISp+WyGWbtEgc8ndwQKuGJ@lists.linux.dev
X-Gm-Message-State: AOJu0YxN+0E3SoGT7CruEjD3FCyKzhLiS27fra9skHOvGsQ6GflRHQo2
	fJWbZ8wl/dS500rNpO2Q/kPJBdXYYPNTNtqeMafnJG6Fi6J4/R2fUbN6W8d9cm6nLPuPs/EIH5E
	tUc9j65Rn67/VjGUJ42EnNJgY6xq0S1JsUctiY45KIQ==
X-Gm-Gg: ASbGncvxz6Ueh5fD9dOkrzV0rellY5h0x1kGeT/3JET+2TEslxX2e8oHB7aasakU79H
	eGsIx97r/casJ8sMFzxXWWpc5QaCKhPWfhI+Jp2ARzTb7kI07yAIQvlFHebcQumhvmhQHo2QJoe
	+SlgyRczn9g88gr7y6PebKMLMNe9gPtQbehr35yKoPNY0=
X-Google-Smtp-Source: AGHT+IENDAqgfEmWtDHYiRyVTLe/VG6n9eA8bBw+SHHFtxygDA218GlKFLInc20fHWa12oeOBRLbkK6qXbDoHPE0cPk=
X-Received: by 2002:a17:90b:1847:b0:311:eb85:96df with SMTP id
 98e67ed59e1d1-31346b56aedmr16157454a91.17.1749359645765; Sat, 07 Jun 2025
 22:14:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250607100719.711372213@linuxfoundation.org>
In-Reply-To: <20250607100719.711372213@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Sun, 8 Jun 2025 14:13:49 +0900
X-Gm-Features: AX0GCFtkSD6iMqXwA4mvNAHmJR_H_fErF2XtQqI6x3N-rGaSjH3mHz7rlegcE3Q
Message-ID: <CAKL4bV5xfxq+Hvnd3C6DdjTT-WO2dcjgK_yLGHSPu-vuq2iW4A@mail.gmail.com>
Subject: Re: [PATCH 6.15 00/34] 6.15.2-rc1 review
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

Hi Greg

On Sat, Jun 7, 2025 at 7:11=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.15.2 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 09 Jun 2025 10:07:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.15.2-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.15.2-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.15.2-rc1rv-g04e133874a24
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.1.1 20250425, GNU ld (GNU
Binutils) 2.44.0) #1 SMP PREEMPT_DYNAMIC Sun Jun  8 13:31:39 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
