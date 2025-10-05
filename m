Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98F8846F
	for <patches@lists.linux.dev>; Sun,  5 Oct 2025 16:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759681013; cv=none; b=bIDaVScUIFNyFGQijGPd0QZzxIegBQqTNAnVZrMX8CaMS/eg+FqNfxvIf/L23LVZF26JfwxBwWYxwstQynm3YVDln7dzdD5kqyngh7038LaZtjzjiK81zum1Ek1AknmNEbEp4t2j8AE+VwHTe0ZHRd+eOD0V3UM4Hwce3aS9Jcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759681013; c=relaxed/simple;
	bh=dty90F1rwneZJconV3QOpe/vTPtclXy/p4MVSEe8Yn4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mrUynFvNRCayL+RzyeBa6Z+JzykSrC5ClrAmnNrAh2g7JcpHZasYIKgl1THrZiHx0Ts2gdzQqm5l8KTa16lJrnt8Uv+IGYyTM3aDNbUi/T+3USHqIE5xmz9zfh1kln/vZJ6r/pCycNn5Vz2kTr1KQ6k0dGZpgvGuuGtOBrfRGyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OzVpNrE0; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OzVpNrE0"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5818de29d15so4946098e87.2
        for <patches@lists.linux.dev>; Sun, 05 Oct 2025 09:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759681010; x=1760285810; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xZ/Xe3yLnVX9DMsOGPDjCo4xUIUON52FJicpdmr9Qi8=;
        b=OzVpNrE0C/fVBEYmisOPl1wu6wSJSVYtqm3Fao63U5rVMLXc3r4UAU2EjeGg8So9UG
         opCut5JskpBhNDHi7ZYZm7Mr4UmDAg1wRwSOqvk7ywjwaC5FSGF1fj3SDRq4HGgHG4FL
         LamThxiUVvXw876Via4vjiDCCwetN4eivM5jh42TwkOb7RLk1Ypntf7LggTmlKRHWX9m
         +guHf31qfMD/0b+ObTxOd8YNitqtD/nFT99XY/aCngAoYIepIFMBuNQ4em1+HFiAL/8n
         UXaglxSx4S11evTSvZQ/+MJsRM9lSKgjtw4oC26WNr53uVE5uuGdWmNjokVRfAPXdaMo
         l3wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759681010; x=1760285810;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xZ/Xe3yLnVX9DMsOGPDjCo4xUIUON52FJicpdmr9Qi8=;
        b=vmJAjWlonuFlAnHi6bkGYsF72nJbVJbhtzF+RlbE6OHh3kpGipJS2bymgjSPGC7gOL
         GPRFOIsS+FWPlaI1e/m21IWt/ttkvxf2up7dtLa4gxml5FSy1pL5lHMMkdT4W7W45213
         7pjYPOSSgKRP1eG+wQViOmlZt1x5MAHzbQzkkTuE/WI8AbOUsJCo8juO5Vd5YoJTKC21
         Ufaqfic+BXw+uWPA2Ev8qGZ837KNobTHYcs1QnBQGq2ewoTdcSNbjNA0aZBqgqwJLsA+
         8BumwBlEO+CAE7rv0W9/MRobz+Fhp+F785tNLihvIKp40Se+jpW3A+oWwPz8e3gK0xwi
         an0Q==
X-Forwarded-Encrypted: i=1; AJvYcCXIKJQyEcZVtjI+exRulsouJGKWMthITdEX4edgRhATHXotCvr7TbtPcvxWTqwqIJKQY4Nwtbhy@lists.linux.dev
X-Gm-Message-State: AOJu0Yx4w1EDbLrRMdwBNWxvqtcjwoL7gZUjZbIewoVaqCBcKEW4U1ne
	m+2EQLgaQLExRe8C4ejPaqIybmKz5w1CF6o7f+Po74YzTCUraUQuqxPZ4tlHm03ySgOm+NVL40F
	7FmL6hlFvLEx3/BDMcsj5maoA4tKe2jc=
X-Gm-Gg: ASbGnctyOC30r3N4lh+XAoABxIDyjTdgClcaIE30EVOkU9y0NWHNP5hrEzugX5UeFEt
	6kARBrwEdOeaR9CSWFFS0g5kCGxKk49Zop8dD8506vtkmv/9fI/OU2NiALwyNwMxV5GE8ZL85Z8
	5twG1wYVWa4qMvZdXNkwWwbIbuLdjSOcbSNvPYmvu3a9fGbvqTY+jxcvMLYUFUq1DVKoOggH++A
	kUPERffZeB3Q1qJn2O+/6W8xDF/4xH5X7Ko8x1gGfoCbzOiOj6y7KVxe3DyHlY=
X-Google-Smtp-Source: AGHT+IE/dRLMfEuaRQqy5I4fZVpH7vF/19UAx7JrGRcujK2n+IGuU86xj7rH5QbW3nldnCI8sGQ+vovSwKvXg6cab/A=
X-Received: by 2002:a05:6512:2383:b0:587:b4f2:7f2 with SMTP id
 2adb3069b0e04-58cbc67fd14mr2692880e87.57.1759681009447; Sun, 05 Oct 2025
 09:16:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251003160359.831046052@linuxfoundation.org>
In-Reply-To: <20251003160359.831046052@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Sun, 5 Oct 2025 21:46:37 +0530
X-Gm-Features: AS18NWD3xFJTRgNFUfQnn3MOQsNtm_4XFNOYW88C6cthLJM2mf2PXFq2mY54q_Q
Message-ID: <CAC-m1rrzZ31hvy2r1b=UpCtb=n8dqOxb3CMRL-eFP6F1A-fExg@mail.gmail.com>
Subject: Re: [PATCH 6.17 00/15] 6.17.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 3, 2025 at 9:37=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.17.1 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 05 Oct 2025 16:02:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.17.1-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------
Build and boot tested 6.17.1-rc1 using qemu-x86_64. The kernel was
successfully built and booted in a virtualized environment without any
issues.

Build
kernel: 6.17.1-rc1
git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc=
.git
git commit: e7da5b86b53db5f0fb8e2a4e0936eab2e6491ec7

Tested-by: Dileep Malepu <dileep.debian@gmail.com>

Best regards
Dileep Malepu.
