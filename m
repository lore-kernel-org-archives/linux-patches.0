Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A20D210FD
	for <patches@lists.linux.dev>; Tue, 24 Oct 2023 16:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fpUrO42b"
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-7b6eda04180so1465125241.3
        for <patches@lists.linux.dev>; Tue, 24 Oct 2023 09:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698164947; x=1698769747; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/CpseSac6ZLEUS8u4CyYubu6VEvSZHplqay1pUkSTtM=;
        b=fpUrO42bKyLSKZ0VyhKb46yrsfG4kqiMHxBM0sIZrrz7HvPBSzV5Yj+zZWM1WBQSgF
         vOJd3MK5m2yF2EYWqg5pbs9A0ZAaGu0FHS903SEHDa/W+8saSUfC5/B9jlyO1IX9PzCa
         SM/3IZy17NsoI9YCSIiStj2yKNIgDAPa0E8y0eUk3m3X6I0mZazhUzxv3b9QeNnsQGTq
         KF2v+1RCZcbamlTF2O4eNdM9tC51PTimZzqM2kTwC1To6Pq1gOf3K6TThSUj3bYFBlBN
         V7BFew4cSfjs9WctuMAFliAClL2JgiufC8NlAM2Bqpxr1ET0WFJG1B3I1vlKnFC3KHM/
         iQGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698164947; x=1698769747;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/CpseSac6ZLEUS8u4CyYubu6VEvSZHplqay1pUkSTtM=;
        b=R4rxu1mZI3u1tmkURB+VtRDlrLCAyjMKaLLtty2Xdpvn67+80GMewQE2aIk+JCwq+8
         PIw4YF+LZJ66/ANOAc91ie77rZjmeUb3iRqoDjWagrdusoTk4M3WIYhYBUKmBN29E7vO
         uQ4u6o4Ph7fnCbUUW615BzR4/umlHZyJfN8J3EJEVQ3BRyfWSrMGbCkFm8dJWvV759E7
         EjIBP75Onxgt0BR3oqN/Xiw6bzDSjboKX0ttU6aup+SOeD7GyBDW0WHp7cxVil1+wUVH
         urbvNY5HQ6pUpXatw7nv26LLyhBlySZAU39RaJtEz+L/lP7mgou7LWbCf6rTsoHVsElK
         PzDg==
X-Gm-Message-State: AOJu0YwTD2V702h4irZ/Nq1haEkcqi+cJM59Sb8zsHunpo47pvusimjO
	uRTNoc0n+YnTTy6Fuy2RKpzPeyfflGCLgmfh1i4=
X-Google-Smtp-Source: AGHT+IH0SaQWucEcdlzDh6PsUBpAyAUFv/YWuCFINZEJ/h3rMmpMOrQX2ikJhofAdRRbinEG6wa/VQDcBugcL8JJd9o=
X-Received: by 2002:a05:6102:4754:b0:45a:b396:a44 with SMTP id
 ej20-20020a056102475400b0045ab3960a44mr1784185vsb.25.1698164946726; Tue, 24
 Oct 2023 09:29:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231024083306.700855687@linuxfoundation.org>
In-Reply-To: <20231024083306.700855687@linuxfoundation.org>
From: Slade Watkins <sladewatkinslists@gmail.com>
Date: Tue, 24 Oct 2023 12:28:55 -0400
Message-ID: <CANV5eWBr-TLCQ-hWwqgi4MH8RWNuUjAmpAXMK3ujAubHx-CnQw@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/120] 5.4.259-rc2 review
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
> This is the start of the stable review cycle for the 5.4.259 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 26 Oct 2023 08:32:40 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.259-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.

Hey Greg,
Tested on my x86_64 test server -- built and ran 5.4.259-rc2 with no
errors or regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

All the best,
Slade
