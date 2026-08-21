Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1552F418373
	for <patches@lists.linux.dev>; Fri, 21 Aug 2026 10:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787309099; cv=pass; b=YZgdUqaJZ0gSQO/3HQo+aRI3OL1J45tx4CF7taLs6P9rTQty2SG91XAOLP2GILZ5R/L2IDhi89seH3mUTSenRsOszliHKvKHicHRYw9ARmlTZuiueh8LvcyeR+NtDj7O8KMUbYiaLh0g4DKSbWmkayDydWEUkrBAn8yPscz+axI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787309099; c=relaxed/simple;
	bh=fp9bZkcQ7bqK+lUV7+jm5JjDcb1xcI/JKOhPfKDJpCY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eb+L0YxG4kz2+9+4aBOFBPEH1f5l8RE2+uOoVMRjtiMnPOG82oYHoxMiblR0I/yiaPHY85U8hYXp1MHhjzENWz5nwqBILilHw3r4X2IJpnRErMQo4EBfy8th8HTNgbtYx2sr445Qr8a1/24WRbzhPQs44cwUDC2g3+JelzRDPyc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=bDhOikvf; arc=pass smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="bDhOikvf"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6a10d02ff43so1933875a12.0
        for <patches@lists.linux.dev>; Fri, 21 Aug 2026 03:44:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787309096; cv=none;
        d=google.com; s=arc-20260327;
        b=CgTSdE22NSlhI5tP/i9y7XpX8Iold+FISjFLwL3KYBpp944CW4h2kLgOhJWBDTd8Vb
         5dH4f4SzQB3zLpIjPVYsqpndrKEBX4SGKkWKzps1HgTJMydCNpa8QdVUIhO/kvBLxgY8
         3t2npMYn2jqeZM21IG2CZXQK17P2Yrd2orYYAY72kzAk1Df0cLEWDy5GdQ9hrKolWdNA
         AlS7De5YybyZLDhqHZhCl4JkSGRMSelN/Dn87QPTcpuuEsBorxYfslXT4XKbpsaQWatB
         nQeUoRzNlE7kM3dsGS7rIsYiGz/gvN3x/t1Z9PAhN+tiojX5sSJhKFuLqAuorLJrP/3U
         47VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Oc+ndhOPFFgR0ZyqbDiLolDffh9s6ShIWGnHuTpSOok=;
        fh=rgRkuhxfYq8eJfNKFjpZnT441oEYqYTqfgTNKkN+8bU=;
        b=DkjvFNCGn1IFxLQjwIyTXNQpogbI7p4cPW4Uc4lx/3q2eWwj8XDPJsW0U40887gKjm
         fnYN3emdF2XBFmTjjxLpi17xxRKqZ9+nnqU88Nvv3TbqlH1KcRpgba8qyUArJ4cizzCx
         q6T1/rP5HrI20HmawWpzOvfmm8NaaklKb77KZ9udHiLK7vULhrIILgzET8y3DQTQWP/L
         z0x8UaXHzxToNv6Cr1MQmtjit9yNzRLWnXmxBdf9wNNL61BWx1+73WFixQtVSroals56
         C2m79B7skcLbfHQwGtdtsQItgFqBdBT28b/3vtBM/w6UaOfAerOeRRThs5ixuvGMY4ss
         FSow==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1787309096; x=1787913896; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Oc+ndhOPFFgR0ZyqbDiLolDffh9s6ShIWGnHuTpSOok=;
        b=bDhOikvfBX6Ybgjiqni0YiWmsDmJ6nnf44phZQJ9ydhFbxQ3kBxO/ao0m+ys9eWqpq
         e+qrKVBy9Xvt6zmu3UE96NGeXihT/ZY/6OVFLd9PYTTbP5rfiqAgm/9KYD1ICqTExma5
         a/i5chUF/EoFxvh8bU+/A6bz6T5Wfu+pKHI0jJ+jaaMODUH5pGrzQInhskv4hPiBfiTo
         n/kyRCeZkzYfQ0lknuGEWkkuylzrMF3kFRM3dtmafwrCMHPIEJHpQH7VLq5+/DHTLiEk
         in77ulnnh6C+29XAPFy7L16qs5Pte8H8hahM1ZTqlEM+EMQMCgaAWnV90GHUYDcw/N4B
         V6YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787309096; x=1787913896;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Oc+ndhOPFFgR0ZyqbDiLolDffh9s6ShIWGnHuTpSOok=;
        b=GmiimHaNR8+aZ/hYJlKbSYog2m4ju4g6IMmImijb2obE47rnOkwRsdsQI6yZqNb+e1
         rqFLLw9uN3wSa51ai2vU62ToGjXSDqKvBQ2dlICoqnjNsxOYA4GtEaNpDUgLRsEXy3r2
         lZMT5MQW1Ztb5Ij0f439bzzNQduzy4YwDZng/lY9BMB2deJrWjRryDCxPyWn/g4fEG9k
         gr/Ya2uA4nnLf495vNeb3hc+yPHoeBkw4TCXLWP6V1BlzCi0T9Hrb8E1T3w5PI9oDZCM
         +zXAqHhNiVaG9lZuyvuaKKufxNbxRnIEAWwg1HooPivLaMmEvJh04Ksl1i7KtzS8CE8X
         Sxew==
X-Forwarded-Encrypted: i=1; AHgh+Rr21XilQZPMw21eMu7G5Vv5/klhDOYxoSIco7Oj+5kRRR1MmlI64ERXcKTCHDVt5EehspuIhG5+@lists.linux.dev
X-Gm-Message-State: AFuF++m9Nzj/ek52QB90NOTwAJRJeOEPjK7got0ClJMIhw2wIX0hK7M5
	QBB4/r73NevNfD8Fm57gD/Jk9rfhW5JP7qlX5kt5GGnoi1W6WQRlxsXpaWnCtjSw8JwQjR6iEjF
	COtBr25OlVcw0enBH0hpoXdYByYVdrVi0y0hTG1QhVQ==
X-Gm-Gg: AR+sD13uJ2ROqoOWgObQdRGAektv5k51o6r4Azv8/C44Wbl2EuROiuJgrEQnpQnl57b
	sOZsDRzxFH+EqWL4+cl8tkAYtpeHX8l1jq5AEuKAOKJiQTO9rdz4IdTKlGGk9Q8lRwY62y3shjh
	z/a7Zm6RQDHHhBLypa+CpiF/nKuQKi6g+6L4NqEvrmw0efbqJJSI7V4lKNvqtzLsIP0tCB8Jbf9
	MKWNL46Ox6CIUvWv3mLBjtCnBxx1LAgKZ0XhG0mrzVj69blVmG4r2GiqC9KM1HvfH48p2qRtZ+4
	tz5Tf0xiV02BKcYco319XjSA66KmNTpvLnY4LNK1U5MrY1KbMl+feNazfHxltZ5Tb35XHjcgmex
	z8w==
X-Received: by 2002:a05:6402:1906:b0:6a1:f8ad:6c0c with SMTP id
 4fb4d7f45d1cf-6a42f1fce20mr6511161a12.16.1787309096180; Fri, 21 Aug 2026
 03:44:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260820145244.450574346@linuxfoundation.org>
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Fri, 21 Aug 2026 19:44:39 +0900
X-Gm-Features: AcwNN1UOrJ47YyCM5Zn3W-Ss_-CHmv8VQveQ7gr5WrWunN0pW2PWUBlYOmL9jio
Message-ID: <CAKL4bV5HtTnp8etw2DiV1oDQOOqew77_OaM=vwC85aFoC6KR6g@mail.gmail.com>
Subject: Re: [PATCH 7.1 000/228] 7.1.10-rc1 review
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

On Fri, Aug 21, 2026 at 12:03=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.1.10 release.
> There are 228 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 22 Aug 2026 14:51:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-=
7.1.10-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-7.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Linux version 7.1.10-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 7.1.10-rc1rv-g02db8575a623
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 16.2.1 20260810, GNU ld (GNU
Binutils) 2.47) #1 SMP PREEMPT_DYNAMIC Fri Aug 21 19:13:06 JST 2026

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
