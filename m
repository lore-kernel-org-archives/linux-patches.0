Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com [209.85.217.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8359200CC
	for <patches@lists.linux.dev>; Tue, 24 Oct 2023 16:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g+wgVkuK"
Received: by mail-vs1-f41.google.com with SMTP id ada2fe7eead31-458d30d63deso1642617137.0
        for <patches@lists.linux.dev>; Tue, 24 Oct 2023 09:27:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698164870; x=1698769670; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pCnp0vx7toGOFpsAGZVfZuo4u/M910K6Gc3WGajgLbQ=;
        b=g+wgVkuKQvTYYjeY3PTouMviV7zgrgUmwlAA91kU4+7jBaqDaxdEuq3RfxpCfwsM9Q
         ENZqj37we++AlHmW1Oatkp4mlUUgaoNId0j4FPiJC8jL5Y83dWWyoKyvtYYWa/rFxZfX
         nImnqB03sqnJAgqk+mmd+bbcKHn8CMaK7rWTynIRMSnc0sZnsQK9JDQn0DBIpKk/KSXW
         9DmzrL+ilG/SAjfyDyzvC8R1/xLmidCHlwu9H8jWOyNOMdszxeL92o5QIgZSrGxKki1a
         YnfX1K3zPNdokkJuiYhXbopSzqe6/Wg+aiXYJAjICqnVGsiYnZM6cSYZKl7O7YN5RliU
         CUrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698164870; x=1698769670;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pCnp0vx7toGOFpsAGZVfZuo4u/M910K6Gc3WGajgLbQ=;
        b=anr/SvrtxLIulxffEgUNOBleFigIpAc5t07D0i9V8CHGOFht2OBgUVE0nNw2gFs8vH
         ECEoZR4oGYYd5Xnpp49K5QiBPYePACJNyC5+AcyPxDbyrb3bsDRostegJN2k1Dv/xHxp
         lx0cty/0DvD6tWBFC5pn5icQUHxXjnM96RsQzwydos6KvR48TBK1sthTA42Ku2UUf8Tf
         ASmQEyzeKuxSRvEKiaryUCRPy4AC2vuhNui004dL7m8PdmHmNFu7vWMPd51T7hZfT6kC
         cFz8pzD9Ri6dmfxLG9hGQHKykd7DNYD8N9GL2h0ZoIVFH6AoBbEZDKQREP/rnGWau7CB
         B60A==
X-Gm-Message-State: AOJu0YyfizEkVcLWa67shtVTAD0VR5J9ioYU7E6qBJSKZO12HoiyI4ro
	NTdoHaKuVB0KJWYEVTf63d+/hKdT01nU12KXfFo=
X-Google-Smtp-Source: AGHT+IEWdBOVvs0sG9Sf5N3GrRIlRSzqyBWAo7IXISVNzqsqY6qgzNmvHSqru9Pm6mBc0qNZ5QdV+Nih6OWZkSXUV9Q=
X-Received: by 2002:a05:6102:20db:b0:457:a97d:82f with SMTP id
 i27-20020a05610220db00b00457a97d082fmr11631436vsr.30.1698164869629; Tue, 24
 Oct 2023 09:27:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231024083327.980887231@linuxfoundation.org>
In-Reply-To: <20231024083327.980887231@linuxfoundation.org>
From: Slade Watkins <sladewatkinslists@gmail.com>
Date: Tue, 24 Oct 2023 12:27:38 -0400
Message-ID: <CANV5eWB5Pj-hXr3YthL=6T=-E29oR9FfHEKY0=F8ZdN5EZC6rQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/135] 5.15.137-rc2 review
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
> This is the start of the stable review cycle for the 5.15.137 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 26 Oct 2023 08:32:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.137-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.

Hey Greg,
Tested on my x86_64 test server -- built and ran 5.15.137-rc2 with no
errors or regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

All the best,
Slade
