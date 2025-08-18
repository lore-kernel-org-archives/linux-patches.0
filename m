Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0D6224AEF
	for <patches@lists.linux.dev>; Mon, 18 Aug 2025 22:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755557740; cv=none; b=Ek8ZIhGX/90dRUsvr7w5xSimBbKi2nXGHUAD4w9Rji4X7EQR0L91E10626K3Pcs6/HxzNGyQn4P19RdqnpmgmiajZvIC8mwCakIjgLlqoba9S8VALBruL01tpYKAQP2XGFQ+fywzPZ1d8/87USyeuWasSj4amfUqwlhv5LjXm1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755557740; c=relaxed/simple;
	bh=QNNh0svKJP1IXn4/YVFb/YlCZ+qTCyfcsqfalwr+f18=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JT6tykCCEDUQBn33QYZqgssCQGu9kRa7yuErvAv3IBtjyySrY3W3KupUaqqzrwNcvm3oH2Lu/6VmFNuSFKB5Fh3+toklCgkAceXZGUJZL9zgwUgk6FgsTlTgkXOVIobCfBskip/l3CU9YGa6OMgZP7tPOmsIJ95TqUZ/WCw7ivg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=BqsXa2PK; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="BqsXa2PK"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2445806e03cso45993935ad.1
        for <patches@lists.linux.dev>; Mon, 18 Aug 2025 15:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1755557738; x=1756162538; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bguXmGTgN4Bd/YvdzOLRte6SvfHtxhwHEfPN/3mWt+M=;
        b=BqsXa2PKOWmEX13lJblWbDQPhM69ob3ZXmfN3Dlhpa0QMYdBxccWc/8CUCjx4+ZXi6
         rtD1kohrC4UudMTT/XHUNmVD/Pggz3bliDw2sig5bQribyj93E2FjvgJIFJTDRqiy0Tw
         jym1zq3EouUns6EdOR88uvRKZEU0eQB8My/J30aYbrgCiJhWD6bV3qjtIl6gmKowzCub
         rCPfoFZhhrYDmLsKLbg4dwVqccLdIs9Q0kTAGhpsMIdcJDoCHJEhbCigUtOvsMFJ9zrS
         B13w0aKteofJV6RwVTffIjHUTi/DWINPJqgLCAzwy7m6xtoQXNt/CHmxehkTfBhnYwoX
         tCWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755557738; x=1756162538;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bguXmGTgN4Bd/YvdzOLRte6SvfHtxhwHEfPN/3mWt+M=;
        b=mgncPZILwey04RkfMbrYaQ+ujVQMXx/54RhqrWQ7JqjbTRBIK6wgTozkOq05MnzbuF
         67wO6aO/y3toDI4xUtcAYMXSqZ8Tztvu5QKWMo1BlicQA9Tcoy8U+IfX+zQ4zBDmqBoo
         PWv9kkD15SWY6ElqqKPdighc+VcuK1zfgnQwUpaUPPBQ++rMKNNDiammCFob5QsC7DtC
         Ac6ZenO3ur920hWazcvOiq/vcZVJXRriT3DhZPpgx08xBghGN+6Mvgph8557uECsnsfi
         QwvLQxDEo1zisiu8g+7MD78pCljc6Kjt61VTTq5mliyVaJWewFFYpbRfr2Ap81f3cw1F
         6ePg==
X-Forwarded-Encrypted: i=1; AJvYcCVOsgTW/6xNi/cM49Fx/1YFhap/F7rjX+vEyFZrCC1BlfICH6ocWjLAw0xRdHXINtNxMS0YOL7E@lists.linux.dev
X-Gm-Message-State: AOJu0YzvK6XX8fzBqmSZKXkQcVOPMPgUppXGKpwjWaOUurzw2kkHk0ca
	/xrcbLIft0VivlArh4j1aTt4wYjOSvNVSDTQQUIGXXTKHkSZ46fANcqekVNzatRd6NuD9tnAcrF
	x9kn2Jfm4bx+uD/EamFckE4ZdfvzcnodAW29+QtMQeg==
X-Gm-Gg: ASbGnct+1a4vhGvPabVOhC7z0rPPaieGs1dhAAAToWVErm0hM/MSOQKHp2FYpp3l3xY
	qQ+Y2oiiCbo+uwD6wBTKI6v6mzqFUPP3lWTAXsEPI6yNc5CiDjlBzu3t5JUuinRX54YEY1GJHpB
	ZEvjrzbcOWa5D/i45BQ6OAw7mvqnxeiqlBnfOSA6w393pXic7V7bibL8MwZ22DAiitKWeJxJBaV
	faUcTjqumga80GqUg==
X-Google-Smtp-Source: AGHT+IGqTfusBp/Wl3eLH4aesenKmL3K7AJRG5soO/sO56C80oHv6CHuRlAmavvZk/O/Ni2sX6LrwrU3ST3yiXgay2g=
X-Received: by 2002:a17:903:2acb:b0:244:9c08:a7a4 with SMTP id
 d9443c01a7336-245e04e5445mr4807265ad.48.1755557737869; Mon, 18 Aug 2025
 15:55:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250818124505.781598737@linuxfoundation.org>
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 19 Aug 2025 07:55:21 +0900
X-Gm-Features: Ac12FXwY6QkznEdzaO8jRF6Tp2__SGYg-Gz6V1qvaRIC3MuAi2b8APUfwkE869s
Message-ID: <CAKL4bV6dKuszLrLP=QJwegSQpCZUd2YowEsmZSNkzChdHPt-8A@mail.gmail.com>
Subject: Re: [PATCH 6.16 000/570] 6.16.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Mon, Aug 18, 2025 at 10:53=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.16.2 release.
> There are 570 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 20 Aug 2025 12:43:43 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.16.2-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.16.2-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.16.2-rc1rv-g7439b60c7df9
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.2.1 20250813, GNU ld (GNU
Binutils) 2.45.0) #1 SMP PREEMPT_DYNAMIC Tue Aug 19 07:00:35 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
