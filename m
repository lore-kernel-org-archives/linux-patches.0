Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD58397E91
	for <patches@lists.linux.dev>; Mon, 20 Apr 2026 23:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776726510; cv=pass; b=m5opy3QrsElCemdKMcge7lAE7KTV/a6n3WjsvL6nhej+eoIn91v5x89VvsNJLwBwezJMFGMK+4D7W0jnjRnZF+IgJ9QIuA0t36HxnIaGwwKGWyEjsZ8x6+y4ZEW5RFe/z/Z7mF3CEV0/jL8dpTo/gJI+BPX9LkLHS0d/6xi6GWA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776726510; c=relaxed/simple;
	bh=zmOFTBFPOAhWVkL57eSJhZw+Eq0A+KPRBxu2alBXACY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=huOAHnnfR7iHQFexGTbaYVcoBJBT52/Mbo1qr1hI1jv7QAY9xAtO6YBmoc2QwaU0lWB+niF6LS9r9D51nnJaHTOSo80ZIfzY/9IaalYStGXIq+e1SEuZtR08xguaz00NB5FTFwkfM4tebCc3kr0X/JWwnlOPfwxAPgfodI72vrE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=Pp8gVxrw; arc=pass smtp.client-ip=74.125.82.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="Pp8gVxrw"
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-12c45281a06so4737756c88.1
        for <patches@lists.linux.dev>; Mon, 20 Apr 2026 16:08:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776726508; cv=none;
        d=google.com; s=arc-20240605;
        b=Rok+bASe7MPP4RP/KReUqLRmhc010WTD04zcmHGdFJTzHNuPu3kkQ5BC20ndDjTOXz
         l3wfQEXNmxxGX3kHvu7qCyWJAG1pdPj2QuESHg7DrS6M6rxj8vmRIEboqSqV2cl7D7pY
         AzdRZ5FOppPW8xn2OtLNAYUg6430vdVWtA6Qz/KQVIp+5iF4GkmmXdkUdbwnWJr0Ojio
         19LkRt44nnhr4OBr0btfSw+wHETNlpSE1JmmadreWPJSRHgrUbJeJ5hY3T5TY5Fe8iez
         0RDbqR5nQ/9ibzfuJU64ktsxwsXwYZgfWFLbPedna4VWdsiuoAQuXv4mTKImFk31H/ol
         kn7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WfZw9lUoUdSkvL1mEcDKzmMDv2qNLFBrd2cb6geueH8=;
        fh=DlMa2YiadmzfAeblQWz2mPkXADlnG/KISHzCyIqUiOM=;
        b=Qpz2RtRmc6dclfDdA18B+rrpKctLN3VCKwFv9YvPACRZHgs1FI+l3Yprl1QKEKPERw
         qrYs++2JwAMZi1CyMMk5CnvtBVkfvCPCk6+8w7fUeFlv5ExIoEFp+IhibS5O1dPxqwhw
         lHaDVUJVy63VGtjH4eT8xfa6ybhFFtoEmEeKBfQmT1ANvNve2VDGDuBAMZJLsx6iMwxJ
         E4GUB24+XeAqJIOka+Si6jNYY1+lMbkkAMs088vzRxpow2xM5mJP5oRMMufuyxZFpjmS
         R9Wqmu6ZquitH9fZOw6Kr7nL+JiPp/8wP5cuZOOZFuPvOtZBlKpNwgwDFvDnl2Vg/oJe
         Sgvw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1776726508; x=1777331308; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WfZw9lUoUdSkvL1mEcDKzmMDv2qNLFBrd2cb6geueH8=;
        b=Pp8gVxrwFQH+2y0wuqUeW0p2ox5O4GnH/e0ETaocnW4piR0cg3OuS4jKMYe/fFCKq7
         oglzPIEOQXsUr3tc7TO6teqmZjVwJBQbbp0D35Sw/nvWRBitO2JgTILmyQxMIpat9Vg2
         0xdJSLBcPGPGP4iRB9NTP8jTWI/AEVHoIW01XZa2r1cUDWAaoEWls/IMTIIwH29R2u6b
         kvY7S798qUCQyDh9PVfqjL/G+sZSDd9jjav6g3orhfoK1L6IwY3u658I/IrK2NbKaV+a
         qQs9kqMq2zwU4Zdfl9hxQDri9zSKuL48BrB2SWRyuWWqK+5BSfCQplcXGlxRK/5l7pIP
         DrJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776726508; x=1777331308;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WfZw9lUoUdSkvL1mEcDKzmMDv2qNLFBrd2cb6geueH8=;
        b=PCDGswAXtp2/JrbnWjz6hdtlxC6SZ4nzrRO+k2Vvluy7bNDjQk+xUm6rbAbs2ZXs8p
         pUr7UBTn98mrXRv5kRYYKijAw8PFc/OVs6slIqicXAH9ZSuQmTYP7snYRDy89zajRREA
         56IQ6kmFMinL4lYuJ5rxLdSDtcA0eM9nprZO3Z+/lRgPvoOdMbDJAnv90trvya2Jxb2f
         Gsgy5fauJEFGWymtlwZflfgXqJ+VwlYJBBxrqLco2YSx+K2kxMvkMwM+vw6UoVrRz9ft
         qQEENO9Zg7WR4Q3R6cnuExyH2KN8y8ysAv4gOsNdW9+9Y/eEBrkfOLgxxiOC0zkO7tfG
         huaA==
X-Forwarded-Encrypted: i=1; AFNElJ90q+h+ljM2jUwZj1hr+ysqcnEj0wD6V1O5JG70k2EBL4v1UKSXvZlkxNQ1hV13zXnUbe5gHZJg@lists.linux.dev
X-Gm-Message-State: AOJu0YxoMOsku0DWB1zLaebCA++aqFXcAmfECbKa/QEMLKrZS/IemQDy
	1I4TEHhWqEk/wribxE4R9apXXkyzmO6NVQ0OqvDUfru3ep/66/PfyxtArcyQzp4KlUqiQvT0ZqZ
	znqAn+zTBWzdDOQqS2SB+TSshdl4f4GOvs4eossWB9w==
X-Gm-Gg: AeBDiesFVfOaB30bkJ88nGd8UwULTH/AF3M1kKmABOQvE/Fmv7GKSCGW7+4ZJyNDRCt
	GbNs6zn+zn7Tbe1pbvnmBL1oSI14z0WHA8u+nMlb7h3W2qxxM8k9A0UZOeA1pXvaE6pMdjtUsXH
	nZ0SFHQiAmSQh0NI9uAH51MwrHsL3mj/aZE1bTjbrW0UBqG7c4KZ6ZPCQ/2SYERiVUjccztVEOa
	ZckCrDUqcu5Lw13a2jW9nTmVpZhQO6a8IF7610ok5W2LjqO/GpFuPTuWnAyc7rqhd6b0NFDSdpS
	vbJ5kjLGYGAeGL8IAnG/wcxcQazYwg==
X-Received: by 2002:a05:7022:1282:b0:11b:e21e:5653 with SMTP id
 a92af1059eb24-12c73f995b5mr7198049c88.19.1776726507819; Mon, 20 Apr 2026
 16:08:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260420153910.810034134@linuxfoundation.org>
In-Reply-To: <20260420153910.810034134@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 21 Apr 2026 08:08:12 +0900
X-Gm-Features: AQROBzDJnYb21chYbYwVabBhIScuKpcMqmeQBC43qTH-HqJf94L2Qz420LTB-zQ
Message-ID: <CAKL4bV6iDGydgwZc=Oqo_vTX4JEyrxvLkLh7KBN-KLsFMhs87A@mail.gmail.com>
Subject: Re: [PATCH 7.0 00/76] 7.0.1-rc1 review
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

Hi Greg

On Tue, Apr 21, 2026 at 2:17=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.0.1 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 22 Apr 2026 15:38:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-=
7.0.1-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-7.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Linux version 7.0.1-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 7.0.1-rc1rv-g01d779c88be5
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.2.1 20260209, GNU ld (GNU
Binutils) 2.46) #1 SMP PREEMPT_DYNAMIC Tue Apr 21 07:14:32 JST 2026

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
