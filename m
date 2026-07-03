Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CACCA3D1AA0
	for <patches@lists.linux.dev>; Fri,  3 Jul 2026 12:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783081303; cv=pass; b=txFH/TKcDBmMKF5Ijwkm0gQzhcuJG2WKsAm6s0kTgSE+/6EoTLnVwe07Oi/SjDVoYGpnKkGussSouD+ilmUdOFR6lC0iaHr7FgEDgisJClIzro2KvLH6v3WwraGhjmsPQ2rGmUdbgxrzXHWO2SCuhew7zDwB5pQFy983Jxcsvm4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783081303; c=relaxed/simple;
	bh=e7AeLpfI/V+IZizL+0VxFnbt6XslONmPoQZ28t9uKEg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dIsIlKVC/iOW8fXoO8d1sFdl6Czvd3tfSE/S3HH8ohwAOdg0W5664fsGhx0KhjmVsmUUINvDuNcCDj9+yqJEjg+zCO+A12tnrKSGJMppdtIrq/Yq1o6r0RnNhvDi3uZ52KyUnlK2yi8REynOl8WSXa+IFyvxevIv8yFMWz8K4Do=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VeQQpA6M; arc=pass smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VeQQpA6M"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-39af87c4589so5114441fa.2
        for <patches@lists.linux.dev>; Fri, 03 Jul 2026 05:21:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783081300; cv=none;
        d=google.com; s=arc-20260327;
        b=VydRnEIJLOURPDfJqJUJFyt9QobKrRB8Wgyi+X+DFrOGYJYfypacfoSYWd2/SV81Kp
         PnR2SZamz+FkCT/zFUe3ByN+/rKLNJGQwXRWB074p+vgBj1TUET/iSKlrw3diOltbTrX
         IvcJ1fUUVNFHlqnXd36CQsVlAs86WH8xyGiZ1qw/86SIBr5VbK8OEpPl/dgGDnXf7EME
         M7b1q5/lkWHEytXGVO4TJodrDRrYi9mLi0Br+fI/1mRhuLNLegNSoUnUnMDMtD+1jI+Q
         9RGHsoc0mMpEdOKuXNQ5Me4t/sHxac0VkPWM3gg8D2zjCyvgWdl5u4z/q2opE+0T4/SH
         GUug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LPBk8ugS/kgMy/u15yq0CBcBrSjlFHrN86r+y6xZUes=;
        fh=YagEoifd7Afhevhvf8g4gavUiNIkCJk20EMS4OCipDk=;
        b=Fc/tiHfB40AHuVy/j/kPYNwWyg3NwVlvlBqzO2M5I8Ot2jBJDk8IHfn3mU8qS6NXfO
         g2GjG5hkB0XfXmwyYBTCA5s+h+Pzure7gkceI/cW3ctzdvmh7HAYUTdyNZDBuXuGvRqp
         NxqWcI518v3espgHdBIOiRAlIV4IldDywL241B2pN0gzcoXfhUc7AU/exnBR8CMGaUvL
         OsiLqL0p+0y7aKyiZvQUXdx65lDAyS+3b55q4xqergg9ArV1+dMjalA2QGYlUoREoFdr
         fCCGvhlwSvwgTjaNW4B0G3pqoiDKcxmrblrYBA4Hl//7iN8Uu3rFfH6DO36UJhsceIx+
         GZrA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783081300; x=1783686100; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LPBk8ugS/kgMy/u15yq0CBcBrSjlFHrN86r+y6xZUes=;
        b=VeQQpA6M+Zi8zi5JgdJyhm92ksWihiUWXmNGYaEJoV+5i4O6Ukr0a7yZEvHQvuiYQr
         pccLdZVdFYgUrY8orRE3tgi9I73/DGXa5NElJYs4JeG4+m/kMgwJ4UX3FyJu90f3YtOg
         eY3FrLJlv+zP7EJ5f9aSTeq5+16yrmRCUeW5NqH7E2CRP8yPCPbwo0aubuudat1b36ze
         isgYoczGLdyph0gnAXwxQo39qUm8Clx2vstnc4omKVBoRvdzWYUupbq839GOnImedDkv
         mGGd2nTURo4sok8gXkZvvRh90AORmOw8PEPo6V295ERS+m6XJMSW3RunOTVoudeOly49
         ShRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783081300; x=1783686100;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LPBk8ugS/kgMy/u15yq0CBcBrSjlFHrN86r+y6xZUes=;
        b=JLrO67nidM491KAceqYlKZUEtmGLFZsZC15nYc4dDXSod1K4NB4XTDardzPEnBvT7C
         SOhQlN6t6JfFvt91nqUMZeRzKts83RcNWaN0Ptfi94z+f8rjTWPTY83vza4U4gb88NuH
         EJy+hN38qBEVSdDO0DXf/3+RKC3lsalJ5x6a141mffJiRS8sDJUIS4Dmal55UQDqMCPi
         9PHV0DxksP/+JVPYON39ATmHldRb7eZ6MpjQLc4qqiVePQWI75POJWDHhjoCOJTUwCXp
         /w6KGgUCGHIx06IEdtcxR58KMQKvoPfVvC1wK7b2DuLvwDY9T8KATEBmv6IlrL9SO4yT
         Kpww==
X-Forwarded-Encrypted: i=1; AHgh+RoeN7B1BsvKd8Mk4tneViw/SrtJ6c61I3XV/Xuvq/FrS08XLI7nmn8eLpKfWt0PLg9MpdDutp8+@lists.linux.dev
X-Gm-Message-State: AOJu0YypUiGL96VIswJHjwkYUfakTdKkgfmEdeXSY3AzSF+v381siS+k
	U6JEYq+yaxWSu9A/BfA4V9Kqg8bo65k8cQK6kHcS7cFIRQ/y2AqDoy+kc5eiI8nm7/9wO4xhYUY
	HzuIHUl8RnmlEdDP8piyF9FuDvubc0r8=
X-Gm-Gg: AfdE7clk1e/OpVQle0VjrEOrZW3jlmJ3Fai7AxXrVVNrWP6RrX0nyvXWjt7in3+/9gv
	tOJVvzkiSuk+YgyQdm/HHZB/MDl7XsA8tEmuBFYfVZMPdPCef3yyXMF7UlIhDtPXjMULQupXnvT
	tBJ9d548MXlRnOVeM6+uX8u3M/Y2wHACioUQv/aOWFE3YFeeY0Dxxe87/APt1cgsL716PxgXcM/
	EcAzB1yNBmdNamG4f6haYD5MZMQ9mWaEBxKwL2zB9/LEATdxRHLvfpGAt/QlkVi7i+HSlP1rlC1
	+MDbMTeRi0MLLjUcuXLdFkojKelNEg==
X-Received: by 2002:a05:6512:6887:b0:5ae:bf95:38e4 with SMTP id
 2adb3069b0e04-5aec679798cmr1666596e87.3.1783081299489; Fri, 03 Jul 2026
 05:21:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260703072822.817328079@linuxfoundation.org>
In-Reply-To: <20260703072822.817328079@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Fri, 3 Jul 2026 17:51:27 +0530
X-Gm-Features: AVVi8CcM4kfM7lzOEdj071SFlE-qqUn8hYlhEnpvzVa2yugxgWc4NOB7MuYiVXc
Message-ID: <CAC-m1rrUUkGEGkQ8sxZYss1c02pCGyfAp6fyPzwTpWWN=tPGfg@mail.gmail.com>
Subject: Re: [PATCH 7.1 000/121] 7.1.3-rc2 review
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

On Fri, Jul 3, 2026 at 1:08=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.1.3 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 05 Jul 2026 07:28:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-=
7.1.3-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-7.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------

Build and boot report of 7.1.3-rc2

The kernel built successfully on both x86_64 and arm64 using their respecti=
ve
default configurations. No build issues were encountered. The kernel booted
successfully on both architectures in the virtual environment. Basic
boot verification
completed successfully, and no unexpected dmesg regressions were observed
during testing.

Kernel Version: 7.1.3-rc2
Architectures: x86_64 (x86_64_defconfig), arm64 (defconfig)
Kernel source: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux=
-stable-rc.git
Commit: 19dde9778fd8e8fb700fd3f9d29be0eb4376fb71

Tested-by: Dileep Malepu <dileep.debian@gmail.com>

Best regards,
Dileep Malepu.
