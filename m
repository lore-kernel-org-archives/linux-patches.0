Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 181F431716C
	for <patches@lists.linux.dev>; Mon,  4 May 2026 20:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777926886; cv=pass; b=TfYhInD9y2Znwk3QtzIcZq7pFNIj2FC4KoPc+a0gamV7teV2r0ibIPl1IR6U2fOogFXqrQVd6NK1jNnLtYIuGt96fKdJi4ZsqqN+FlMOwznjTBWRy/oOSjuW3xEsGNb/SeOF5epHLvMjExsQLNWpD7HPkZWiiJV8jKXX2iOA7r4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777926886; c=relaxed/simple;
	bh=zc23Ai/g7qOzZn+OqhUZ9eBKciOW0aLKEEjJkHYkKxY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L5fT/qd0gn3xuijV6f8Xr/wYF3F7zg3fS/HL0eSikKlWRP49d3//zWCu0QRUBc8WQIZQU3FhLpZl+aQrzzWF+kRgbrJ7DpvH8HfxdIwuF+SS3lWbuyOypN8lj6gayWKRH95lHItC3PDnxOK8S1iQsJbuutOcxlqT9DDr2ZwfhPs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=azzB/H9j; arc=pass smtp.client-ip=74.125.82.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="azzB/H9j"
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-12c45281a06so6993601c88.1
        for <patches@lists.linux.dev>; Mon, 04 May 2026 13:34:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777926883; cv=none;
        d=google.com; s=arc-20240605;
        b=MmVT1EVMBCCrFT4oPEU8Avf2Z8jO+4o+e39NgV/uwQ32IHc36toS4ouqSD1JlZ7Bd5
         8bZuZs0GoxgJZW8mlZI0p8yWLYQnBpLVUfjRrS8wcO0m5PxRIpZfxQxiEVlWLVbjeSst
         IyI+aYA8/RQFFzHzyP8MK249XOCC2gWF5aPBomFbg0iO4VRyO+02Y6WXYsi+Bv/gHlZC
         XIb3luHX/dl8Je73D6mplHlS+YMb0+79PTDgESRH0z7oHBrgXAr3awMEyic0fEuQTqve
         zCzC63D4ng3VtEF/2KyQdWJHCTyRx5knyN4auuV6cnuhxDz7S4qDR1UY23OvcaApVljo
         ywXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=V7yjXvpFCXjsqwMrVbmmZqjOgfflxDjwoJvK+IyEgF8=;
        fh=+YNt/uwmiCSIDFyvswb1Ya+2M2a/JtIw1ZG4j+YtYZM=;
        b=H4akddDRwWJMdh9z1Ko5GwELBR3PEdW0a90XwW1XvyG0VXpy+g5qxu5nBn7wT1u26C
         6R1749+mcnYXA9rvgIoTR9zHDTdSalxLxtFQRp1rt4KHHth+OCEDkqd6Db55ZDlC5hic
         0rMxG4yIxPp3awDYvfeFtexBoCZiqE29SyycutcDR1kHgZodiUYhoqbYfiZGK86YFIEe
         l2lMFk16fHSzJf/X1Bjw6gyJaGDokTke5Cg7AdBxtodzyV0ZWzxaEC75uOJRrElD1Uj5
         kG2G/JXuCZEY6aM7D23A7b4WsLHy3j2p5puVMKm/ck7Y0/B4WO2E3dztWP4NQNuCg5in
         HEhg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1777926883; x=1778531683; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V7yjXvpFCXjsqwMrVbmmZqjOgfflxDjwoJvK+IyEgF8=;
        b=azzB/H9j5FyuT0mzqiTWSUXibVp4cEevG64iTSLnSip9+6FFOfFCjTuK29YK0cI0l4
         0pw+T1du5JHWkrpSGQCZdKsYkqiguqpKzof/vxPJt1U/ZElhgt/llFZohonVuhubnG6H
         DBJnTNHbb0sOMYW/O58ZrV67XxxaskJo60fxxSWqOY6NHkmgS33ErWqpDpif1ty4duD5
         Rv7WIR3gRSZtvTcqaJTZIZSgfg3ZWf3lroekphyLf5P9sfTZm4KRSGIdcdihHiyqhzy8
         fnLjonzysX7f4KFeClNbCkWBPoyFFWUEPPsLQesWT7Vh0MfKkH4f5DuVA8Zi63VFmfHF
         +oPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777926883; x=1778531683;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=V7yjXvpFCXjsqwMrVbmmZqjOgfflxDjwoJvK+IyEgF8=;
        b=gvyYHeuLodVjb4NQSi7mk3FP7H1UnQ1UL3/T/G0A4kMEHDSgQJgGRgCb+2ZuH6WEsU
         bMkoBLZO05PrPepK7nLyiIuFBr6jE3a0pB6beQm5qGj8zyah4UeyBrQDGXNSVb4d/OP9
         4XMF4uL7W8PwgmSonj62U3fnAO/r1CV/4gZiAd++JCmp3RixBtHtsXhyJXB5801xwavz
         omqX/PGCgdnwfQf5fkXNMT7hR/hNlUsbkzlk8nktFoVU88ALYe4juq3sWghSrZzmDb80
         8Mh6MaaBBKZJFN+xHTz5PPZZqY2N09y92C9uBc4qyZeK0vUhXSB7VwM8SgwejdR1AeEj
         ksiQ==
X-Forwarded-Encrypted: i=1; AFNElJ+q4N/00vhdsWhQ4q2TN8Pb9Ahhx2Y1wKFQ/Q1cdhOpdIQqTFifLUjibUS1UGYMwPcuYYDHJoGc@lists.linux.dev
X-Gm-Message-State: AOJu0YwQuX4FqiBk3P6AtzcbSo5pHZfK5yzto3+g4xn/GzufsPxUQeq5
	IpVytMCl6shR0XlE3zG0e5xCXGzMV262LqExpEFXFbRLcyvN+hftIImecyDTC1TJExCQdi10rcP
	Q/4+qKy95p7GA8DM/N/PvQlYnMONfbARDoJ1UoPmQDg==
X-Gm-Gg: AeBDiesAZ6IsqKQDpcNuCL8z3v6bldEJnV+AB5oTB6CmIpcx+o41bbJKi6U0gzypVsI
	ztW1TxqvJo7oPvEMOty6/JEFsG2+Jr45xvjLliLZ0VjZPBX0HyS5/T0fE/CdmzpoBdfdCvHtBLO
	j196UJbk1CIHdrDz5GlvR0aGTonYjP7/DH4ivcGFLu3qQca8pHKG30wPsxLmSWe2952EQrKwq6M
	Mx8P3usZwf5phz4KiNknGy4xn2nfx8IMFanSnJLtrxFbo7MMZAiXURiKVAHFM7fSjaZNOGgxKm6
	vvGLzQIaELu8noscZkxpToLtKKpUiBCPK/0B8cWGtWTr8lgoVyM=
X-Received: by 2002:a05:7022:eac1:b0:127:3b1e:7e0e with SMTP id
 a92af1059eb24-130b1b684c6mr257945c88.20.1777926882493; Mon, 04 May 2026
 13:34:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260504135142.814938198@linuxfoundation.org>
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 5 May 2026 05:34:26 +0900
X-Gm-Features: AVHnY4IhSogUT7gkCWq24CBG0BjeQxCpCg-6MU6hcgqj8FmOf-pFhIM0WA7VmhY
Message-ID: <CAKL4bV7+x9k49_BZBxSuWXQra1YLporsU0amLQtZPaz=866RoA@mail.gmail.com>
Subject: Re: [PATCH 7.0 000/307] 7.0.4-rc1 review
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

On Mon, May 4, 2026 at 10:56=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.0.4 release.
> There are 307 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 06 May 2026 13:50:49 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-=
7.0.4-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-7.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Linux version 7.0.4-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 7.0.4-rc1rv-g4a299534048e
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 16.1.1 20260430, GNU ld (GNU
Binutils) 2.46.0) #1 SMP PREEMPT_DYNAMIC Tue May  5 05:03:52 JST 2026

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
