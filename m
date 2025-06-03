Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 054D022F757
	for <patches@lists.linux.dev>; Tue,  3 Jun 2025 11:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748950840; cv=none; b=E7+rDU7WTn2YOM30dudWLOTPWV03h3jaP+44XipwgwHnZ4zxopEq0Owm3D4gBdjBD4FSIwvnkLx99JJDF0ccvWLgZvzIAIeH5dE3ockdunML2T8w3iy2Tmn31hY37xyLkG2AfA6j7KoU/zsa61zEeOU14xKeliOgclKNGU9/4Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748950840; c=relaxed/simple;
	bh=ydJW/LoDzPRJt3Rv04zweiPDrb2AloHSlubJhACP+CU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SuZu2oN9I5xkAdFJD1b1OFrP9Q11R9BLW76kR5N6XGEGsf0+x9t7IIskHi9PWVP0FZWQGdPH8z/j6kKAb6Az7PMkum+4NkyZ36spBVOS4OUFEoaOcq7D8NI05IVR8K3FIcQFpJ8v7DCEWzBmcJ4fOj1aXt5/Uamh77tjyKUY7eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=d3tZRfwh; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="d3tZRfwh"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-306b6ae4fb2so4717630a91.3
        for <patches@lists.linux.dev>; Tue, 03 Jun 2025 04:40:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1748950837; x=1749555637; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=icZx/2AfzMBw1r6SeRjsuN5YEn+p0qUPm4S9o6uO9EY=;
        b=d3tZRfwhGIkcEJ/wtMKn8YAav0LhSJUcVdoNt5NUiG8VfIjcxWhRyXfPsXGUaB79l1
         LHtjzl7Cqu68qMjPMHL5sAXfx3R2F7g/ITKDJDS5fD0BXsLzhsjDNa4bsG4dvbcV53Gy
         aBQxdEuIs9Vu7p3ncVQdWljB1ClVUih8x6iNE38Xr0Ju2+Hg3qedFFA45AI1BKwDeSUF
         viPeX+5DB43jFQP9Oz2OWlFYrCe+4Jon/oDALr4mSaMsumMHV4gHodvcOVIbcaZn5C73
         Z7IZ9fk3xe75k1nIjpvGRGqnQYY9F6w+PK8IFfruwAawPJaAZCKNzdDB7hq6h58mRu16
         ilgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748950837; x=1749555637;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=icZx/2AfzMBw1r6SeRjsuN5YEn+p0qUPm4S9o6uO9EY=;
        b=fQlBqfiLqfrSfAwBfJTDDDaSOaYavr7T31pZSku7ydzjXbvOKJJ0o7506Ixso5RxBG
         VGatYqaIfOFBr08Hu2CyBof47Jr8UhyeQL1y8n4b19d856482gJndHgGgF2XPgNkDrty
         IxsCWrOwFPbXR0ODhkx5PXPZR+gKRgjjPLYu11cOz3H4yde8u2ZHHEUYt3xFYFjqXDvg
         bHG9Y9WnWJuMl+9LnGshBpSyuBSINJBHug1e0KKY+nvKi7y/b/tKIltFBhY7bfQcynXz
         1XBAanu+K4QKe3hI5a/LQx69eB3gJjFaTknlknZhuaCkJXK1iCQOLCDXC3QbRmyLDe5Y
         KThg==
X-Forwarded-Encrypted: i=1; AJvYcCVnfoDMmKG9JyXdRpys/3c12mesMTCuJag7xynWkXfbLgZM6bgofcQN3bWNXWXOTdourlib6yfC@lists.linux.dev
X-Gm-Message-State: AOJu0YzSQketrJk8UOnSMHhdzkJm2iQQcTn8zAieO7gkTq+Sgeosw24R
	qrxDoAB6uI/YwmxgEGNKKUbynTmDYVc7/Cxtc0oWet886auDBABUckZr7X83+MG+/ng+zPaCLxt
	OvmLWjKPQk8dj8uG0pC+sAqVuSMbSS51vGY+vXQPn6A==
X-Gm-Gg: ASbGncts8s1JMJiIUkpuAh0rGCC5sB2ZWeteQ3AibP/s8HDuRdqBcSiP/3x4wYTEBoZ
	f/CLA8TxOkbUzCm70g9XN6uBvKrXrHvTdqyjDgt1ddCIwvXDLre+av79Pgd9cnIINklgvna7PYA
	NxVyy+oYzL1DwOw1m/eIQNU7c6jBXZPQL1
X-Google-Smtp-Source: AGHT+IF0haHNNQFhqF/wVyOzL7nQAg6E/2DprECkNGJEFD7A3Ta3cIiSJF2MKzFfFrOObGQ4hE+8hgwD+Eg8ExjuydM=
X-Received: by 2002:a17:90a:d650:b0:311:f99e:7f57 with SMTP id
 98e67ed59e1d1-3127c72e6aamr14719693a91.23.1748950837161; Tue, 03 Jun 2025
 04:40:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250602134237.940995114@linuxfoundation.org>
In-Reply-To: <20250602134237.940995114@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 3 Jun 2025 20:40:20 +0900
X-Gm-Features: AX0GCFsMfxUVTqS0QyB76gobjArUIvPeTmaHwVNP3N04POsePCAEXrHz1EuTjsw
Message-ID: <CAKL4bV6Jb64fXnYWZ_wP54FE2TRUy7Bp=Tzt+1tmUOzjbnghCQ@mail.gmail.com>
Subject: Re: [PATCH 6.15 00/49] 6.15.1-rc1 review
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

On Mon, Jun 2, 2025 at 10:49=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.15.1 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.15.1-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.15.1-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.15.1-rc1rv-g86677b94d603
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.1.1 20250425, GNU ld (GNU
Binutils) 2.44.0) #1 SMP PREEMPT_DYNAMIC Tue Jun  3 20:09:59 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
