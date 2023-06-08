Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B86C8FC
	for <patches@lists.linux.dev>; Thu,  8 Jun 2023 11:19:59 +0000 (UTC)
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-9786c67ec32so92848966b.1
        for <patches@lists.linux.dev>; Thu, 08 Jun 2023 04:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20221208.gappssmtp.com; s=20221208; t=1686223198; x=1688815198;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kJdbAv7bpcT0Rq4k4eGG4gWyo/yarCqXwYtqTBVFLOk=;
        b=04Po6YJpdWArF1GlYBipfvE+IIbc06y2oiNGq3CKx2qXTgntDKxhPSUneAsQVKYL+l
         KqQ3Fij8CYLMxnsipo/qPZYZbHIaiRfDDXqx4Bdt9DxTKnIYQkj4hgbfu6LWzHzTtt1R
         DzOvPsHmiCbwuI0mC2GhpexI0e4aSAiu7YwyLV7HMxXKAzInnjGo5PFA1tX6STep9vw7
         uDb3WD7Qq8g9qfJsFZd7skEo3GubzFpVlgQt69iSGX+M6JBwqYR4sAFzav2FS58qtAU6
         3CMI4fD1cbSTTUMgA53ZkCV9ZXQ8MTHYKMtkpb2PMLJdliuitBwgvjxfi9fl7H5MTni+
         3TbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686223198; x=1688815198;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kJdbAv7bpcT0Rq4k4eGG4gWyo/yarCqXwYtqTBVFLOk=;
        b=BZoCs+ceNu2uefYmY46baNHalJn7/PkMuyZoCZFxvbBmy0UECH+7CajkwunyCnwe5K
         TwQI2cm7DQ8+++zGvjcP+AwW4mvdY6KYqL/rKitZZ/X/1MoXMFVJfu599zI3FMuoHHgs
         O0zAYJuIMfYibbbIKf02IV/dd+vb8zoKrPdvWzxtNJXAVJCkuYZ7el+rCyO6h0qcCaqm
         GZFWlcFy1o1nlFQDCQHVb+dhqf2/BCtB2eyBTaUzPsqhMU3bRg5gEN9v5wtpzueW7cY8
         gP79IXkQj6fuQk9J6qS0HzP320xGCR39yTSBPDiyxW5rqwfiGeOy+l/6GHs405IcCW7e
         45lA==
X-Gm-Message-State: AC+VfDyZa0CmQ7RJfjxUk0hr7KoyW7uLLzuINeauruTaUkbXdRfUmSn5
	u5HQfx3szNwwdg9NG0O6SeoCqmhYUBuNAzXRuRyq/w==
X-Google-Smtp-Source: ACHHUZ5C+87499XG0JaDWva+8XjJb78v1brxE9fUSogkx6xplO47GKzQvdbrmj8rrGGaIBK2hGmeqQpCWWWYYsYPS1c=
X-Received: by 2002:a17:907:6d27:b0:978:66bd:d771 with SMTP id
 sa39-20020a1709076d2700b0097866bdd771mr10362972ejc.55.1686223197879; Thu, 08
 Jun 2023 04:19:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230607200913.334991024@linuxfoundation.org>
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>
From: ogasawara takeshi <takeshi.ogasawara@futuring-girl.com>
Date: Thu, 8 Jun 2023 20:19:47 +0900
Message-ID: <CAKL4bV4m9nXyZaWx3C5peZKyc_QgYtZg_V1=WE-Hv9=F8nfkVg@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/225] 6.1.33-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Thu, Jun 8, 2023 at 5:38=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.33 release.
> There are 225 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 09 Jun 2023 20:07:31 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.33-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.1.33-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64), arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
