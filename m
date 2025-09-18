Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4742FFF86
	for <patches@lists.linux.dev>; Thu, 18 Sep 2025 11:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758195799; cv=none; b=u0sdBJ4kSBAQEH1urTFzZzD+rf/I9nvMpbKBu6ZgTUHwkcOqMV3Ik0yQ0zaV6/23aQLH9n4htv67pEXrJFarjlq9xlQiIpYAAm84IWzruxiYWU31JgnddFAWuCCeNDnN9YNFDAP8pp4iOhBVoc8x2OZQme755zpE5QNK12WX6So=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758195799; c=relaxed/simple;
	bh=D0qT/j8mgOQHMVtdjpb+0Fx+sFTbsplo6m2+YqZFl8E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eWOQBWl9e29WLY1hIiYw/ml9nJa4fbcPi4XPL2G1qMs7nfcutmtAx3B8BftXosdKMb2eXIfMZX1yvf7DNR/eCQBSQSgmojPrNOO+ooz/Kei1yHlixCfEX0GXrwsoTytr2pZnJqK74OaWC8+/ff0jNXL51D+1jTMCRp58axoB+a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zvdmfd+6; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zvdmfd+6"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5679dbcf9d8so871621e87.0
        for <patches@lists.linux.dev>; Thu, 18 Sep 2025 04:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758195796; x=1758800596; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mttDaVgnou30m6qIadwuCBtYMMTHSA0PElHch05zpGQ=;
        b=Zvdmfd+6kmj0rO6hJ/ldBdaUpXYZZq/+ChzwgXuF/kC/9yJEINeBO+y0luKlTC3yKk
         E9L0ZBL3uWAmu+YuSVm2BFMTnjw1SwQxkv0fpvi6QvQwDMekhna5R1wPKIvrK8xxLZQU
         Lay9DuqLA3XTu1RWo3MgXRI3pDUjivCmF6Ha7R3CTp08hB1j1Cr4+KoJ63tCvhrnbQeZ
         Fo4FqeenGNBUiJqOi+gRQDDvYHpcFCbb7UuuIt7oLZewNQelIvJwJ/aDHX1+Uz5U86fk
         hr6iu+muw0GLmqYpM4z459+iVhIsQRsOPwaJBf1Ho8rPE6yd+x8AWuK0FMMJQlAAS2VP
         07lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758195796; x=1758800596;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mttDaVgnou30m6qIadwuCBtYMMTHSA0PElHch05zpGQ=;
        b=bS3UngGYUEMP7kthvFzLi9dvulNoVbtaXOLJSFQ1wdspclYL/X7/POgC4PquxjxaLh
         Y5fTwR1daPOADPXGbnP+uiBndFRLBNE8BpNGqznG8wXSxpSrNuc1mE3m0JZJ96R74ms3
         ps8vZw0J4hD0wz2QwuGPaGCmjdDwqnkp9MPABxUK2U6kccdHQruZiKPqd+YNq7QzsVtS
         6EAcaUoDMe9fIOiLDyfSoBe8oQ2RTUcfmS6+neSMKGKod6VDjhVFadfbAb0WKaQu+mGR
         vjTqH+GvUXtinO0PZrm4GT+96cfBrBDZcK32TkjiwMy6TeEENxy6hl5GIoYcRBruA0Hk
         G0hw==
X-Forwarded-Encrypted: i=1; AJvYcCW/H/HNKxpdE1AvC14eSpsieli8CXqJM8YZB08qRcLhdcwMv5/U9GsiR9txYw/l+KmEL+Cbnv2m@lists.linux.dev
X-Gm-Message-State: AOJu0Yz6n6q3kiAQ9rna7AZaCVwAaMOWMOF6XbZUUvPdc86N3Y2Auy9N
	CCE6TdNbF1v2LWDbqg6sgY8xjSqBTvjhMDfv9FOLiZSHfBPfjJUntF9NtBe0MK6drmFGfNm9pCr
	2IABP6ErYqHA9MTStolcUsLfrhY0EKbg=
X-Gm-Gg: ASbGncuACbIUi19E26IS4ZKufJXwk/M3ZjBXiOa0WgCNE3GsxyeLfxrGhzim9/D6HZi
	VRaJiFTXGJIid1yWD1Up3hOseSv3fCC1izl5vzlNKTP5HsO+j7UUqYdfv40G+prG8LFKA9fhkS3
	YHmve1HTT/bxJycqLXRJrZlRQVbSU7+Ve3L4fRgPDCfgPtj0sU/IUHQfxucdDjC3NNeeNrsv/7A
	YBrizKJtyLCqkaFInj0LPsmdwHgNgYJ5r1ksQIGI5ekxUjpweWI+NzA9kuTCZVPnjwlVds=
X-Google-Smtp-Source: AGHT+IFZ5w3GAzz7FR/Jj3KgJNtD/D7A3e4TaXGqydX5EqbXflMlxl1MTipZAZVLe5jiTdwbW8rWf9Jesg9Q6tJ5zQc=
X-Received: by 2002:a05:6512:12cf:b0:55f:4c1d:47f3 with SMTP id
 2adb3069b0e04-5779b9be614mr1933467e87.28.1758195796193; Thu, 18 Sep 2025
 04:43:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250917123351.839989757@linuxfoundation.org>
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Thu, 18 Sep 2025 17:13:04 +0530
X-Gm-Features: AS18NWDWssrlG-K0ZlWvu9x32iRhOcTvdFSygqtOTPhd_LkBMlJmE0oYnHGYMj0
Message-ID: <CAC-m1rrg6BkCSvE2L7niQH1E++daOrFYX6p0s0on0Ykt-TYbMg@mail.gmail.com>
Subject: Re: [PATCH 6.16 000/189] 6.16.8-rc1 review
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

On Wed, Sep 17, 2025 at 6:06=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.16.8 release.
> There are 189 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 19 Sep 2025 12:32:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.16.8-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Build and boot tested 6.16.8-rc1 using qemu-x86_64. The kernel was
successfully built and booted in a virtualized environment without
issues.

Build
kernel: 6.16.8-rc1
git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc=
.git
git commit: fb25a6be32b38a3267e8037fc4bf1a559316360a

Tested-by: Dileep Malepu <dileep.debian@gmail.com>

Best regards
Dileep M
