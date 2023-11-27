Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96DA35677
	for <patches@lists.linux.dev>; Mon, 27 Nov 2023 11:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="m68s6TAJ"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-5c2ad6a5515so1157000a12.2
        for <patches@lists.linux.dev>; Mon, 27 Nov 2023 03:00:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1701082838; x=1701687638; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zmt2hlpJeJU9hnh5GTsTezQO+y0eDA0IJjENIi6FxVw=;
        b=m68s6TAJ1dJ4Jw0ZklvwCHIcZk/8+FUxgwf27YL1/TwPCpXSOwVO/JJTuM6rHiAkMQ
         jjooKGnIfh0yTk+SKPJitH7bJ85KfEqcZtlbUEfB4zQgr06qq3q56zJAyJrTOULtNA26
         uKiTl3H0CrpTT5X/HwCFI2AqsnvqckLIH8dF/E0pLi4jhrSLaOCdDFs8J4y9HDHkRKVh
         H2NfhYcipv7NwEJYJ7jfpqYLOnJiLcGYLEOmqfsygWrxohlfDS5Ewhynv4tJ6iCfutr5
         LGGXBwAfiX9WzwXy9ZGfe0jnDPLPYcoVTu+uNdMuHAH35HiJd0OvYjp9gRKM3sFjWFyr
         iw5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701082838; x=1701687638;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zmt2hlpJeJU9hnh5GTsTezQO+y0eDA0IJjENIi6FxVw=;
        b=oGN+BcgvFnIMcQYO8HNoa5EWydRADA02C1csb0W/TANI5ZTTlAzLV1AGpE5zva2qid
         Hh6iZIGvEZS+b0eo/xsyGhU+ZvNGZvWln7/urdOeVxklvlbk3cEbsBsKpoujlBVONw8+
         7K6Q1OrOh+qqFGNrrc5/sg/KDegD8h76pJqRThtAR1pHZoYYtzN20rav7lDTbQhZsI23
         0x9/vmRiRRowLZA64pJRi3uZM78kjGEhi7bNObmSM7bqfmp9zYslLyPAtBWoByewsH7N
         ER6eU3bU3jlb1w5+xjm4bQUBpODEpfAjvmW/RU9v54+nbS023nt7ttg/4f3IKXU/8mFP
         Qs+Q==
X-Gm-Message-State: AOJu0Yx0xxmQ78tFkdoRXhACOEOoN2/xxMgF0fJlmNgXl5gChlsp4Keh
	jxg7NV0l80gXXGooXrKmbF6f9bhn3hTgSx+35xeEdg==
X-Google-Smtp-Source: AGHT+IHsdtBGvlYv4OiZ3uPa02d1XAJd97bFDgH/OzG+X8+tTIgs9DaNMw/VYEXl8nRn0KWY/ueQrTyUkogFrTpuTbI=
X-Received: by 2002:a17:90a:e7cf:b0:280:cc2b:d5be with SMTP id
 kb15-20020a17090ae7cf00b00280cc2bd5bemr9756711pjb.15.1701082837063; Mon, 27
 Nov 2023 03:00:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231126154418.032283745@linuxfoundation.org>
In-Reply-To: <20231126154418.032283745@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Mon, 27 Nov 2023 20:00:26 +0900
Message-ID: <CAKL4bV71Bc_2zfi=WSrgse-S_M7qvb0M9pV=U7CofNu4-WjiZg@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/525] 6.6.3-rc4 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Mon, Nov 27, 2023 at 12:46=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.3 release.
> There are 525 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 28 Nov 2023 15:43:06 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.3-rc4.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.6.3-rc4 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
