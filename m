Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB0539A7E7
	for <patches@lists.linux.dev>; Wed, 20 May 2026 23:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779318029; cv=pass; b=IRHAZbQ6ZUGkh+jKbaY70LBQPTwSHbjV3rqcbOChPbB7FmbCx/SvyyNcs7PGJXkloHNjZUYx4LrIGFYXSNA5RUTIP/VMAX5LT72ptScBuvQdZ/IsGxMsYBKeU43GQQfb+XYsV6p4Cd+KGFCUOxzPaLvcypFyimbSlzzS2JUesoI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779318029; c=relaxed/simple;
	bh=614fTFQKMh8YkUQJporSJa4C9EzmMxvSXaHnbeRrJvg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fmUS6cZOs4HW+9LF9vEVXperF0shmDGwN//LBcsFDcKAnhPjetG4ZxzEpEbPQmVpdRgWINmUDWyYV6e3Hk/VzCpyqbIrIVF6PIhTn/P9eKfZgnmq+kaYEVACngo3YASGY8JKuFoVNWW7ETaHjHMwg/ys5e7ew1xAS7vTFEZE0HI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=qBFBOXt5; arc=pass smtp.client-ip=74.125.82.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="qBFBOXt5"
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-132d1b2519eso12527607c88.0
        for <patches@lists.linux.dev>; Wed, 20 May 2026 16:00:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779318026; cv=none;
        d=google.com; s=arc-20240605;
        b=UtXX0HVi5dN6R/DH4wdmScztB7h51gosjOGnNJP6SdOO48GPpO6FIdXOIXznFW3j0V
         PTxClN+eAfVBNBSKgMBpRm/jF6qoube4njsFrtQOxmBMrJPB3bb16Rcn3XLwDpNcgp76
         q9RThFF87fAV0mxChKKQIoAAKBNKou1P4HWf5Syt7wuRp0S0WSCYW7xFjs+jc4yXHXxj
         FMQ2ZA3aBjBlTVfsB98VfBDGE3ZqJUnh9Ek9B1L2FMCAjNa2L2FPpIQyGWM8cMPAQVNh
         23DDMbPKmm+hanL+sVY+Cx/HmfyFZdBImfPzQljI6ggZ/z5fgVIOgRBCTqJwAWDOrD5L
         SZHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FzWSbtMbs/5rD9VopnxxhT2ewZruVU4fd2L/VTX8OMI=;
        fh=GNhkbRNeYJFPN6ccAPIMwhCUNnSDLs8nXIULpAf8ecI=;
        b=J2jYGYZNS+/TJbQU+vr41aRn+YLMCrHdN81NQX9/zBL885LYPyUCBjdMCB/NfpHVyV
         uJUygVuo7oc7HW+LhX9MfkER0k3J9AF9c7Ri4qzFq3lVS3pR98n9g/nOO9roiluoY2l4
         MIu3Z2DuoEqbZ3dLCgU3UqvJND/Av8P5n4FPYPfQWPa5o2t0QRQxxCozZr0QDkHqQI6/
         E1pLFRssK9Yxo45TPi+F/A/5blw/wbOQ3EddEAJE2iOF97HHbGuZMxJTuc8z8o+NgQYY
         aibjrJb9WQLYQD4p817pyoo7TCtOhJl5DoTHYalGWoqS4GUvLuyd6cEDQ3IyiXugijY9
         20Pg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1779318026; x=1779922826; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FzWSbtMbs/5rD9VopnxxhT2ewZruVU4fd2L/VTX8OMI=;
        b=qBFBOXt5DKvqvsVQGbD8fbdwbseT2OsLhObwobeSiRl/U5qhK1Q8djX+5Y7Kf4cG+J
         vkce2Bt0k7cdchN1HgvfZNyIGeL9eoZoyOj/vvwTQ9XsAXu6QL4M5LjJBvMiuRXGEytI
         70wTOgX5/2Jj7FlODwUjLg/Xn3ZhUDOC9oekTLjc6MbzRQsnAgDq5gXbgWx1ATnXVAvY
         e8nawlZNsswxfun8XchAzRbuP/RUqd+kdjd/cZV9W5xERNUL817LO9n/dMPC5pWn/pQu
         tPCDzIi3UIF1E89jkyFj9CgCXdlUeCLMZJ2CCwg91/PAKhhoSH4/G82WjIezkIetdMmN
         iAVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779318026; x=1779922826;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FzWSbtMbs/5rD9VopnxxhT2ewZruVU4fd2L/VTX8OMI=;
        b=IiiODP2GegdI20GzrvDG1TESefLPyNctn+iO7TUFxi7ukWEHSGj3dtfC8/zlVhBWin
         Q4g70ycXWw8fk+KBxX50n2NJX/nInUOP/s8XowaxFnxhZwffPabqtPE+5/wtTPZ+SYej
         X1OxBxpIYMR6WquRmJ9923OdwR4dQeJu8bNnvNfX/Wgm7Fh1g7FWsRSusX3+kaS+rzEu
         riLna5IOa2knfwJrj4pbZTidApsQwh5iHUUXojAzF5QSK4YOgqGVtPOS+8CBXVVH3vJf
         6L2n+GimM+BZ92BzRwkaLfXdlI49eT3p+wPHdHDw+QoRuXKy8bqVek7u46eYml6LSw45
         SbTw==
X-Forwarded-Encrypted: i=1; AFNElJ+8xM/lS+j46jjzXQ1RLbyzKIyFNR8gkgJmbGgw5bLLPVMQSplUSYarPyhP1VQak55GOBbsnE2p@lists.linux.dev
X-Gm-Message-State: AOJu0YwB2v+zCKeNxa4dCl73AyEAIVkvH4kRXX1nqeS5CRCQvjw0fI2T
	EsFBdP1nElwiKjJ3eZ8udj8lpMqVW4w3wRlNDy/Ag863vS5cnO6mPt6igcYOygR+7/QsvFEGEKc
	REAXP3YCwecxQpnC4J7HJ0aC8DaJla0xIJIqYQTQVJw==
X-Gm-Gg: Acq92OGVj7vyWCP43VbloLQJO7Pu7Eky0OoDfsjce9miy/k/cXj5lQ0VYgBTCgoZI9e
	FtTCtQpdkYiMHmeQ+OdkXDyJ/moVR8pBkU7BRZi2H2LT7B2aNvVvLuE5KOAJ9A2Nji3wgsq70w6
	ls8jMnqrPZlNQdj0hM9G1hV5asB6aVVxf8QqmKFe6xav5M1e+RSqLL9jp4FlKA0bGTav4QwjTx8
	eEkcEl0/oPoJBldQmMPfaRjVF+8Hy6cRRCSZVlNJzdfd7B0JzXInKSAZ3uHxcpYLj24IYc/Q2Oo
	Fe+Lc0hU
X-Received: by 2002:a05:7022:384b:b0:12d:de3f:d847 with SMTP id
 a92af1059eb24-13632f66f3amr300041c88.42.1779318026411; Wed, 20 May 2026
 16:00:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260520162148.390695140@linuxfoundation.org>
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Thu, 21 May 2026 08:00:10 +0900
X-Gm-Features: AVHnY4Kou7S6azCDntKaOx_vvWEoQZvCdyzixfwzekOTIzvk_9rCESAy9KkHu4Q
Message-ID: <CAKL4bV5O+tbdXhjZmX=+F3tNMkpxf336koAOGFi35vUhz2Pgog@mail.gmail.com>
Subject: Re: [PATCH 7.0 0000/1146] 7.0.10-rc1 review
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

On Thu, May 21, 2026 at 2:16=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.0.10 release.
> There are 1146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 22 May 2026 16:20:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-=
7.0.10-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-7.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Linux version 7.0.10-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 7.0.10-rc1rv-ge79d5c5d57c0
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 16.1.1 20260430, GNU ld (GNU
Binutils) 2.46.0) #1 SMP PREEMPT_DYNAMIC Thu May 21 07:16:22 JST 2026

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
