Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E843A27E
	for <patches@lists.linux.dev>; Tue, 24 Oct 2023 16:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YCf+mGjT"
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-49d8dd34f7bso2020125e0c.3
        for <patches@lists.linux.dev>; Tue, 24 Oct 2023 09:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698165037; x=1698769837; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DJF74bOpCl2cyMohFOvvVhQktn04W/je5xIM2cEgZBk=;
        b=YCf+mGjTWJDZpzCgrfyCP+8EgJMS63A8h9ek8wOyo3vDoe0xN2h6q5I47zpHlthgBw
         bZEdawzg+l6fr7bP77Z8SVt3B/mtvziBJP12DbD5/KQqii/6mqXAGKo1oouS6GZ8OV0k
         rJ++Jai+gGGYEBPRYxSvqAEBB+s069pXgAGh9dP4USbiPFlt/rNzicpumlmggLTqNzRe
         LsCZkpJj8gDfiDeeFINe7udBI/w/dETXIiw2OSOO3GGXR8f1/froV2fP4T+qcEjxat8Z
         JEQ8QggvQRpmWaDxGt+yjiRDiJdaZujJuxGZQtBEg6Nf4r/Rpo+gCyJlTZxKrvayBmCT
         PA8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698165037; x=1698769837;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DJF74bOpCl2cyMohFOvvVhQktn04W/je5xIM2cEgZBk=;
        b=h78Nl7GApfVdZVeFn11KofPMXO+KfwrqwR9dYPKEM6Uwlf95CN97Xx6IiLeNIapAdd
         TY1mshNq25eUYKXfCftnbG9Aauymr2IwRle/+/HJeaesVQOlzf9jDrZ+KhFz2Czil2EO
         FuVSijyBgnhOlPVzAzFxuBq4SJIoPfDSFYlFvuk9n0Ga5s43zFb24AKKjZdmShmwWxNI
         dleJpnbCT020e4O4Rag/ODFyJxNuxZ6NyLlB/WbHCURw9PPIC1qJIp4vHqiqI+QVh8sb
         VtE/+cxeN9lT1LiLCSDzstPm0KBHe45zaahDefZy8Sl7KslmafUxa5BEloFbBZcpsFfO
         GlGw==
X-Gm-Message-State: AOJu0YyKYAc7K//unazyr4hDsFJML/xf6PFoViMi7/R6IfLMLhNQSZnH
	9iZYFceJvs8mh4ITT2siHMDDujR2ejoOTo2/vvI=
X-Google-Smtp-Source: AGHT+IHryv0bir0iGIZf1J3sjDMzAN8oqoi2adxMT795NJqXtK6EhKj2ChbM+Z9QzPZPaFLaQLQqwT/Kf9GUuKo5qz8=
X-Received: by 2002:a05:6122:3c56:b0:4a4:d34:421b with SMTP id
 fv22-20020a0561223c5600b004a40d34421bmr13700168vkb.7.1698165037356; Tue, 24
 Oct 2023 09:30:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231024083326.219645073@linuxfoundation.org>
In-Reply-To: <20231024083326.219645073@linuxfoundation.org>
From: Slade Watkins <sladewatkinslists@gmail.com>
Date: Tue, 24 Oct 2023 12:30:26 -0400
Message-ID: <CANV5eWDgnrWsmAuJ5mC18PUCacTHqCTSs8pxaqXozg3SeLWEdg@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/199] 5.10.199-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 24, 2023 at 4:37=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.199 release.
> There are 199 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 26 Oct 2023 08:32:45 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.199-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.

Hey Greg,
Tested on my x86_64 test server -- built and ran 5.10.199-rc2 with no
errors or regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

All the best,
Slade
