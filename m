Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA5C1C54AF
	for <patches@lists.linux.dev>; Mon,  8 Sep 2025 03:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757302895; cv=none; b=FvvrHyWxNgJScTNOfA4s4L/2TCbPM3r+lXX3TsA9bgh+3X+DQGBjMmax6RUw5PB/Rwrskpo3QCBBnIV8dRKy/6Gc1ovqgoRexh3B5SHRIoIGaNq49NbPoX9l9UeM2+z+tDUY75AreJXrB33edHIaHPKlDDViHuO2I4Zy8MzEqWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757302895; c=relaxed/simple;
	bh=FlRezqGlNzRwo/eQaMve/P6wVjIVJ17qa7oQA0cRpLY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PxttU+6ssZGTx+49AX6bOtnRb54FqQIBeSLjCJ26xiUftLzdhg/6OmO+TskxhTxc+2BgFosXIcf5oMHi6PE0lb8Q4ZyMGfiv7zqKXnUIqape7mqsnk2m8tJo8gaFn/OGW3dhUO8VzASCusmZxUijMj3ZunuY/egQYQQ6cV/35jM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=f7bz7cIx; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="f7bz7cIx"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-b4fb8d3a2dbso2381715a12.3
        for <patches@lists.linux.dev>; Sun, 07 Sep 2025 20:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1757302893; x=1757907693; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d6Z8zaRh25HsvwFwmLDi9HGVEV4yypZcSaE2HnnfjeM=;
        b=f7bz7cIx463Azma7veIw3qavVF35/0MdWZm99N6z6dj3BI7NqZ3x1MXfKhLa4k2liy
         ZBRJxCbgMPGgi5LJQfx+9R6F6qeqmQuidE+7BcZGH+F4Vo8/5VMc8PeAN54yM3Hyr5WW
         882U2Jklj1mfPwngkVHX2vlCiIRjSNojEZWGvxllho9QZwpQNUDr5J+Y30jbZK/BK6X7
         Xe9/GIkzUhXyOSnLzh+oY5R3CZ2AQDPqZtq7dO40UzYpWNwB2V37N6vzAQKrG0nCjHis
         F4RbyGaDi6FgFtwyBCi3GPMrjrltxzgh7GMGgMoykk0ChLVXzWLUjF1VuwSrb2COTr6w
         Ggbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757302893; x=1757907693;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d6Z8zaRh25HsvwFwmLDi9HGVEV4yypZcSaE2HnnfjeM=;
        b=Qper1tNWQCQ/ZYEGH32/PlPa/zoKFkFHW4E9g5egxgVXNi09bkqIXc1cTGNQrFinRK
         rxvmyfhDz4nYsyAuEgn1tFOuaWy8voewOpr3NIRfXHUNMHFtKg/agnvd3EqxEZ6adyjm
         XY+NeANVdZnIuglzL/MXrsfDUJKXyTqsr4OxY7A2HCdI5jnIDJP1EfE4xQI5csBMbc2u
         0ho/iqXXnM4IDj/WA1LIwXvNU1veaUuTBtex7v5Ar0H1/5tMEEHrlcmXS3gkiHIRefEj
         ZD9dd9/tOr2bIimGuYqbs/M7TWNB0qlaKq8MTZeGPOyOkQWj23+wh/Nnrv5QxoHMheNj
         B+1Q==
X-Forwarded-Encrypted: i=1; AJvYcCVtnYBhqv9GN4A58YmFvPphDPKTa2Wc2AguqQEhmuiygtWncp5dFLN/x3nSPLpTeAMLAxuRL6gY@lists.linux.dev
X-Gm-Message-State: AOJu0YwwRbKXqC5QQxgUFMagr4r08rPz0donAea21GEtxZhTOjefX1KH
	7LIpXuT8mwL2DslcZBQzGfO/U7GnbdX6W6eOIpeftgKKuIUvjAehjSemufsIZB1f0HSJdoi2JjW
	b79X2u8qg9TM1Yy3AgqNS42wGd2nhsMRFvb62MUvNgQ==
X-Gm-Gg: ASbGnctkeobcMOv4B9Srz1aeCEkGf9rlyu2Th2U2uv5202UPxAja1KxSTq07d1aNUDH
	ICJXBNFou8NUXy3cp4AkMFYTqJ26q484jXp8D4QbLqhY2hwIfn+4vr6HiY+GiMAjVw8KMvmj4BS
	iylR6mQqLqvRQeQk+Xy+h8Hn6yed+Rm+wBwxQFmZm+CXgiQUvlLwJKnAzOw/ItBKCf1KTMMLY4P
	olq71Vo
X-Google-Smtp-Source: AGHT+IFEijA1F2cyMlEG8dJZx0or8k5xZbxobkL5zQPTFxwayqkrYZYJ+tsFu455csFDZ1bmP4sWayZ0f0NIhk8/C3s=
X-Received: by 2002:a17:902:ebd2:b0:248:fbc1:daf6 with SMTP id
 d9443c01a7336-25174c1a946mr92202915ad.43.1757302893478; Sun, 07 Sep 2025
 20:41:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250907195615.802693401@linuxfoundation.org>
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Mon, 8 Sep 2025 12:41:17 +0900
X-Gm-Features: Ac12FXw1Y1FbZHyIhDFMEyNA6f0UWtK_eXEwjIPuuju3SYeQdj5KpDMQrKsENTM
Message-ID: <CAKL4bV7O=GXXAujmwHXPFuBBd32Vc38n528qCNGshFQUHzHK9Q@mail.gmail.com>
Subject: Re: [PATCH 6.16 000/183] 6.16.6-rc1 review
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

On Mon, Sep 8, 2025 at 5:37=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.16.6 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 09 Sep 2025 19:55:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.16.6-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.16.6-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.16.6-rc1rv-g665877a17a1b
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.2.1 20250813, GNU ld (GNU
Binutils) 2.45.0) #1 SMP PREEMPT_DYNAMIC Mon Sep  8 11:19:48 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
