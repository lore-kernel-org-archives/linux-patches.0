Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2A3F9E8
	for <patches@lists.linux.dev>; Fri, 29 May 2026 00:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780013487; cv=pass; b=DJitYs8Dx5LYmDDmDHZuDiiPHH2Q+41B5Remrs7bdGtai33uMc2j7tXq0nF6Teyf0SE6CfLFHTRIXOFQDC1TnTVXu+YPgqu/piUSfBnwK8Oot4iWqAc7ke8HC+EX21Ob2ToSysdYEIKNL0V6P3DZRi3DNaADYcxrrubt4ZwL8r4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780013487; c=relaxed/simple;
	bh=ZjnV868NV+lqhcd4MsChwouvTGC+VvZdX0Apwr7c6jo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cVAe5K3jzbRJNkEIYyTUl8mn+kQQHgyh1e9H4ri1NYQy/6VG/pTOMkLlvuJZK5DUpgE0ITcc6nk0584GrI5dqbCnV/tm1a39DrSv3VrBJtXY/5RWMerkQ5LsMThgNNCG/hBrQ3/lGzmNP+2SDV3rzo8kiJQHAQQMFTHFDYYQMCw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=Jxaik3/1; arc=pass smtp.client-ip=74.125.82.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="Jxaik3/1"
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-1353c2f35cfso5798530c88.1
        for <patches@lists.linux.dev>; Thu, 28 May 2026 17:11:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780013486; cv=none;
        d=google.com; s=arc-20240605;
        b=idsRjiK3Vhs3ElIRu2TGMloinNZ/nBSYd/5DSvNAjx8UE8OyNR/3viiMjiAtOf0Qft
         E1bEvToDI3pNFuPSOm9xhKuafb3HAa3SnBXwiAjh42Et6fnAsixesBI7Bw3uKNS/OmaF
         oc/Ek9yurnmzGysNpKD0hKRJw/gROWND8nXvqy48WvMlhOb1JtlMQ3/lDb2M1jwPSUh7
         DZnTW6Vngu/Q/uCoCoxgyC3Hxtg5/snryqa1FYTbwuYmGf98fZwf+W66K+VtI6NWMVu9
         kPMMhr5xq1IdZ/5DZ43+JKx01JuoY4jOyWCJ+V9KVvfJRdlqGhw/CYNDKJX01+jCiA+9
         W8SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dU6gEEGgnU7lLGrcMuRY9/3fx3otqDmeJHRSgiwmTMc=;
        fh=VRV7vGlNLVaJXrjlHGedBD8/0aazPpCOcNazPBvTpnQ=;
        b=lysjZG1nLlIVZlGUyzL37/h4YldcRJPvCACOzp+ff3nVwsfdeJZqvejDiUAzlJHMiG
         GBdS3XJmlWfrenYPbjEb/PPg+6wL/u946w9DuEkiSqTaXHSV93Gs00HE4tenfsdekkPT
         LH6SpvzfOYcgPF9KtsMilIFcgv+Ex97NwruDcPSaNVeScKeWWof3Qb0XKnGh7rHfmVTB
         aMPlBh73nzOnr6Os7sGbV9jIck13JRrIrHTCUydBScgDrETccm+tDCsUmWqAPERIWuHI
         7upnoCzRh8xmbFfeM1YFL1T8MCgS27XSqi+1YrWVNnRhCmUpMnYfzeWmvDx130voAzds
         8YXg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1780013486; x=1780618286; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dU6gEEGgnU7lLGrcMuRY9/3fx3otqDmeJHRSgiwmTMc=;
        b=Jxaik3/1RkSzPeD3tY/1N2uaZ7wl1TQk/INX54GrfGrc+ruKJrR4jHF4G9cEoYoeua
         zxMj07zTtAj6KBPuErz4HZj3pdvq0qhf7eFzrOBlMnx71PxTrQrEF9ICL3b9GfFXtXLm
         0/Rk/fKx9x9H94HvONKlODN3vH3mS1Q9ZSWGVy0O40+2Zbqc+JrlJwMj7Zk6+p1IfN01
         Dg1hI+202wogQpp5MYHDN3j9XAiclL02UQk1rZv8/+96vfwrc7c4tmFV/OWDRlR9DuaK
         5vw01UjdDcowsh0kePuOjWQcSEhvcGVhD45ggQitfPMFdYsrnYwM50aDf4hpRU1v+RnA
         rcUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780013486; x=1780618286;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dU6gEEGgnU7lLGrcMuRY9/3fx3otqDmeJHRSgiwmTMc=;
        b=XKvW6rGLDDm4X7MSmlVKUHJReFla9tfoRQ5OWbapsdO2GdPQcnKhOKrGpZiqJbQx3K
         ghLGCI8v417I0e3LSlSVFnUxzEB1+xQzjySQ/xsvt4ZLl6cxYybvk6aUsu9ar763FuEu
         A3F4TsW9V/zeMgWHQPDxarn9GvIM9sMXRqbVrepWnD7rOscHqkhysGV9l2M2qsyGNoya
         T4psA7NrU9bMtSd7dYueX3h/ZNsSUui6A0GvXUd9bNH9NH4oPaaL3UCirS1lEzgZB+uj
         CkMLk57VBqBDhby664wd9YIwqT1SZ2tDXKwxlF+vgQqkhSwGjKYCZTGiiviLZsx99sSk
         aFog==
X-Forwarded-Encrypted: i=1; AFNElJ/uF4JLVmhY/t23s6KN2mgafNba3BNTWc7lnFUvJemHCGoTTlNVvX/21hls17H2R1m7i8MJQ0SG@lists.linux.dev
X-Gm-Message-State: AOJu0YzNfleEa9vjIRa3rKAhtvJM26VabbdlRvl36O6LJOtYWVZ1SMOZ
	vvrmWJo6HHqFRYBLUu0ie+IeAKjv2vGE2yUMNPJG00Ob1H/76k2KKEc06A7gAp7tdw59wQsf85e
	1/4yfvMsWKDIFqC/1uA1TG2SgZDX5sSLYk58jVJdWOA==
X-Gm-Gg: Acq92OF/Eky4XZ7B2vH/lEI/Cub0r3WKwbJ96WavnDTDeU9GVXGwEgw1ANZ4L/uvWG0
	1C5X+H92uBL5KtkOqcU0pzmiEBk4SYZn9m0jzqdsupdqhpB3yjHL4ZqnOPc+rO9M9FHpinx9SHR
	zd64oRG9aX1dqzFIl/cJganzsDFQYETvw0M9wvsyTHq5e2BtQvd9/oZGeWDqdAcnY498Fu9JFXP
	mOF9R0TG9UtIvWRFTeibcDQtCWiZUuX8AY52Zz79BC+CLO3Q1kd5+MiFoq0ZtKGLMS4Cfktn4gs
	/RQZqXqrJaPZ/TgHOZ8=
X-Received: by 2002:a05:7022:e06:b0:137:1ae1:bc19 with SMTP id
 a92af1059eb24-137af011e25mr244319c88.5.1780013485477; Thu, 28 May 2026
 17:11:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260528194646.819809818@linuxfoundation.org>
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Fri, 29 May 2026 09:11:08 +0900
X-Gm-Features: AVHnY4IjvGF0iXwroJOxaXpDNkWnqugRN30z4Z-UYDG5Do0PqSqa36fDKSG9L8w
Message-ID: <CAKL4bV73k67Qg1dfhPV18S7_yTuVzkVsBLO0sMsdESoDZnwLcQ@mail.gmail.com>
Subject: Re: [PATCH 7.0 000/461] 7.0.11-rc1 review
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

On Fri, May 29, 2026 at 4:56=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.0.11 release.
> There are 461 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 30 May 2026 19:45:49 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-=
7.0.11-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-7.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Linux version 7.0.11-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 7.0.11-rc1rv-g547c0212c36f
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 16.1.1 20260430, GNU ld (GNU
Binutils) 2.46.0) #1 SMP PREEMPT_DYNAMIC Fri May 29 08:35:15 JST 2026

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
