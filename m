Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07B736E472
	for <patches@lists.linux.dev>; Wed,  4 Feb 2026 23:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770246506; cv=pass; b=cM8Ic58hD1QElxITc3N59gpIY+IXZnnQeEJEbp/0fn60TcxUncNTVA2kmpUdhpCjCY5fLtsNsVY3HUrs7NhHxPkcQscvXh0oeXOg//kALFsykIcvgftADmqgnk7/2Qse0N7UF9xDMUT8a8p9/7f6RVkoP9XEspJp1z8Nq9KZEyU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770246506; c=relaxed/simple;
	bh=/jze4YelSplwIAptM7myBAJGYPMZZ95HC1pBPuOrmVY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZfW4eUuGVd1+orskoqjL8BCSFYkmtNm/v47+BiL2S2MiK8rbELsg6gCaDZ1ujoZ8LCdYpz5DWbhHbZGRoJ+PPvFmq56eWcXiOqW2ogs/XyZL0qmQK7iosqAfwjvzVnpeGPD8dY4BrofkgN/zX0gpjjUQ/Kd0SR3f0DNS2kb9IwE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=Kkftb72k; arc=pass smtp.client-ip=74.125.82.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="Kkftb72k"
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-124a1b4dd40so756952c88.0
        for <patches@lists.linux.dev>; Wed, 04 Feb 2026 15:08:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770246506; cv=none;
        d=google.com; s=arc-20240605;
        b=BqCIfTycZ5GGwmzfPnbiETfjBLHJTz5kIxMLZqGHmNIoDpH2UZxerp9hK6nWH0g1gb
         PFcPrymnFfTgVhP0XuIpox69LYmzNdZdT6VKJV4raSp/iGI96mPiK+OPuOGgwqZeHFll
         bAv08ibTKDiY5mu1FWpv9f9fGjPQw8SyL+0vvd2Qt1kbaNwBuRHxeqYf5jK3NpMt03sv
         aeEH99rZA/xJ8zEsoewGQtytudQS7iwd0/CQ+77FeU34i9fm/mqwdVq0JeIOe/Wr5IEW
         9Vb35RUjEwz/thzo/e1JX7huXNYBhFChX8dZFQZHvY1wB+vyqoSXmzv5Ips0aH1N+uHS
         bBfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CGc6TK+a60aLQyzCLxWYX+tErzFSQGXPE5dNkGcSckY=;
        fh=g1n4cP4g+tkYxuNgxnyjTzfDZjDmUyxcvM5z/qA7EiQ=;
        b=R5ZaMJAA/EcVsd8m23J5In9JNKm+1eGWu1bFW1rBO6sWxnAXE1vQzLz7TpqcJLrazh
         3Dk2BfiEHX7uasH3gCggbuVg4dThTQ7NtGxGpip4oL0ypvei9OQKjbMFLoY2z6TKmHZA
         SYlLjkq70SlKndqCR3yLk2dPXnVkb7TkljsARfn0JTwLcqXXZR7+vt7QUv0Qwn9XYxMa
         ixxiwVpK8UCmDz93zu/mlp+6f2FVSblD0tG4v81scA9+QA3JW3sMHOSTTma1XNFHT1Vh
         5SbN0wHFGgNgCjaBgHxJiR7zIHBWMfOcQdTG2oefh0shZPn0uV+Bqf6kb7ckvxiNkjPt
         IwiA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1770246506; x=1770851306; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CGc6TK+a60aLQyzCLxWYX+tErzFSQGXPE5dNkGcSckY=;
        b=Kkftb72kzqCryXxSsV7nQgwjrkqA01RJZMMpQxFS40WaxhIFhglOLmhCImCI64Htyz
         IK6A/dOkC7I2/wS2KSbtn32ZViP1uwYTkwSSk2Pf/qxMQoSx+DKEREddPS30eO10mz22
         NjI3DO/Ash6sc0bef5OzBka5fWWrVBroKJhUCxZNI07uVkPzs8YQyyFby/TlOHrj3dbn
         aUVhzxDK01ksbwX1c5rId6YcU+t+FjxJUrD1sXy4KyEGxULJdsNzHL0VfWw0tRq51LU/
         +CYGfxG6vR79gLDfjTnbZ2RovsJTb+8sQTaLss7SreK/MR462rJFz8IRTJOu3DysKUka
         FpfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770246506; x=1770851306;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CGc6TK+a60aLQyzCLxWYX+tErzFSQGXPE5dNkGcSckY=;
        b=IsvuYSqqCXYHO8nZLctBaHTvmk/Zv/IpikePiC0/E7RNwBVns6hKswONTGXxR5BT63
         ZqwZENzuCc36YTpF4yZ+y+y0w+x5dssegvZ0ifnDfkhpTpKaGbPDkBwjDiW8Mz3DEs1e
         eZ+MxU6fsW7/g0ieVywDzIBr9FSq2gBv/cEt3OCsLob8+qFQMM2c1uy5AhS+u8BsymLi
         SjYVPJZgYtRyjJzsAogh18WW5QEJD/YP73bHUH2caJg827sDcvW4rNO2WVpMTK/invMO
         UR4Lz4eLJ+UyYhbwzkatLlC8qLOmPT4/MzyystF5quakw2ZprL3NNFHBSIXQ4kd8GwTp
         cgAw==
X-Forwarded-Encrypted: i=1; AJvYcCUpamfmQcPgvE6esJe5wMbgxMnAl3DIkrYTncoaXYePJgbcdME30uDNdKDK6SXgof9lAM8ePzJQ@lists.linux.dev
X-Gm-Message-State: AOJu0YwTS4gZdVb7oV6d+5f+gF8z/x4XvRDpSo4+CXB18Sg79swpu3Cw
	tcYsC+Nhu6tAkedTnuaBng1xydV1weqeoI0MCpwekumy3jUuMPr46Pyk/gJlbDIoeB6VMIPe6on
	A+T51lYIGApVGgE35UK0P9mQlQ8nktrXXh01V4PnQJw==
X-Gm-Gg: AZuq6aJbQ0HIEMqXLnsL9uBPFJe01VrcgTC+s5/FzhSeVh/JtcalFMeAKg6R0OH6e1E
	8VCtc9CoNbhC4FVEZ6EhqjqcFu9L+eKnZAG20mMLF9ISX/1FPcwn4R7Pv9hX7Ke2SKZZUy1tQQ2
	fhBXuHDnJmy8k5UCd/9B6RnOGLJoUfOpEAmpR60DAarGRG+VznYOSNFI40mEyiStJnF00r3Yph7
	Dqtq68hrEELgcGq6fPw++EmWb3ZCocLVNVzYFnQEqPfemFug2J898NZHRz6EpRjNzxxrdOH
X-Received: by 2002:a05:7022:f103:b0:119:e56b:9596 with SMTP id
 a92af1059eb24-126f47bae4dmr1623242c88.27.1770246505667; Wed, 04 Feb 2026
 15:08:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260204143851.857060534@linuxfoundation.org>
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Thu, 5 Feb 2026 08:08:08 +0900
X-Gm-Features: AZwV_QjfYF-TNpEGyxA7aGUSXEEIF-p5Hlr1boxvB4P3x0qFA7pSZm3cljg_uAk
Message-ID: <CAKL4bV5z-tbCjjj73vowb4jiy-mYN2qPMa6phLfXD-S4KV3Orw@mail.gmail.com>
Subject: Re: [PATCH 6.18 000/122] 6.18.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Thu, Feb 5, 2026 at 12:50=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.9 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 06 Feb 2026 14:38:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.18.9-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.18.9-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.18.9-rc1rv-gcc6f56fd087b
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.2.1 20260103, GNU ld (GNU
Binutils) 2.45.1) #1 SMP PREEMPT_DYNAMIC Thu Feb  5 07:21:27 JST 2026

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
