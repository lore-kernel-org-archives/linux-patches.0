Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE37238176
	for <patches@lists.linux.dev>; Sun,  2 Nov 2025 02:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762052347; cv=none; b=cxUuKeQXshsS+qtLfyJ4Ea5LiTpJvm23SmiimQbozjoqNUyYffbFWPHxx+Qc1O89zAaP73FHRCkKxtfW+BuF7seRz6yWB1/mVUO8W3VJleaY+xMPoJHvFKgKQye9KX/vNvClSAJRT9PI1FZ+7L4Ve4IwNvEZAYd0YFIOk2eQUWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762052347; c=relaxed/simple;
	bh=obt3aM36cVJabIYjFO5PbdxBdgxz9xRXrzbYELuVAn0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DleBe0bMt/Tcj8n0edMAVsqrrIo6x4bdapG/9JJBHT+katMg/Xga8nKHDYgv8qsx13aYOEi4OO9qS9c6EmOkAPPOxXaBFHfOLDJxgA54Lm0AyQuw3QecYLrS9JQWMie1A1gqNk4uTbmBVIWOg/MBhPOG/nlU5CLWakLgXq6gyRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=hG7oNUcN; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="hG7oNUcN"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2953ad5517dso16440715ad.0
        for <patches@lists.linux.dev>; Sat, 01 Nov 2025 19:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1762052345; x=1762657145; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rLumh3cNsj4A5S7s0QtpZk3S8e1GvxVj+uYG/2PIV6M=;
        b=hG7oNUcNS9vrExlrlYRMmPuZ7/vbk9EXHrC/QUIYsQD9FFEkrtevf8a0TT5dHxu+VK
         pkUrvAYkfkomoKGC6dwhiOt9nomvnGVfg6Ar17Zqs/z1No0fN9i/A+TmgQGTGQIphZnQ
         pq3so046CRU1H55cq7f1Tns7gwD09PXVo+e5BDIM74X7MRisip/skIt1r7p4cprCnzQW
         qBDUHnN0foV+ntI/h0DiU9ZJX8sf11bfNeq5XcrSPpgIj4I+ONnHGelZGkjB0ZTKLa3Z
         gvA+SHpq2MWR5dzCK2RD5Tk5iIFU+SibsY+Bllj5Wfqc47p7WjPRtv+wxfdH2ckQFn3B
         AErg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762052345; x=1762657145;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rLumh3cNsj4A5S7s0QtpZk3S8e1GvxVj+uYG/2PIV6M=;
        b=OsSkoN83Ced67e5sNLL0Hx1fufRtOXitqOTa6eKDIFzKndKQOlt8s0dHc4IJekWuB0
         +wTRWDlYDkjGCPnmLUD+9adx3ToW6tDNAoKDiyzTlk8CV2CBSDqDy+tnVey4esB2QszK
         B02aHGo7qkleeJEdr9VT5G0jD4SP837v49J2gRFGYnNOWwsmdB3ztAaunaAVi9q6qi4Y
         ZMY/VKGctyEvnSJJv+kLqxgrSztdeMD2MJ0iQZJIIiVwpxp93FIQYyQF55re+qmtU0Mn
         zvAv6A7+puNCyxqqy2ykcj3HZpRAOT5nZ1vbQiHSzP+4etUFSqf+suPZFsmohuvcLDBM
         YWbg==
X-Forwarded-Encrypted: i=1; AJvYcCUuRUYi9Dxn/iwgbGrCfgNRDB0WA3dOzrKlY2LeF4Wf1PR6F3hEjn6jCGb3cJhGlW4yq6z2+f6p@lists.linux.dev
X-Gm-Message-State: AOJu0YxO2NFoNVTaMYi97DMCfBj03YYDbhe8sd23KxAQwR8JpKTFx+M5
	H98H+BJajvcKAlb+ypr0SA5cNPEgtA61t+aBHO9h8M4TL+70rwPpta7YhmLo2iLWjlysU8gv15b
	f8qarRWgcjtb8noSdVuNP2+TnDw79kwy3+6IfLK86aA==
X-Gm-Gg: ASbGnctJpHVRz6nodS8dsHiqXI/c0Kw4QkrCADKwh6VnWDk0oHf7UDgl+JA/cUA+8U9
	z1h60lgsUOg/m1htG6DwnKtHOrph2zlmTzqJpIm9dNsYZISB2L3+Jelt5tvH6oIbSGeAzYklM/k
	L2gNME5TZX04UseseWtzbfGOkrtYJuPuDj90YEJBoLtOczFUx6hb54L0/gkWZT3ZX2Z3a7UD1GO
	00XoX1krOACTynhbss3FDDJlbJf0kstpwS3DXMSWefJyEwzPq6A++4JJ34F1j2JtJwQJcbXfdvl
	fJY2pVgUvF3Xp6RKsAWeGeqYrq1c
X-Google-Smtp-Source: AGHT+IH7KUMAuAewCAP00Q6zBbvodvUMs+s5nG+cFcTWFTo/5afr/24R9eJSZ4skcRLpRH3OqFtHPtQDMzOEOkj5qXc=
X-Received: by 2002:a17:902:d511:b0:295:64f8:d9cd with SMTP id
 d9443c01a7336-29564f8dcf4mr34382905ad.15.1762052345170; Sat, 01 Nov 2025
 19:59:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251031140043.564670400@linuxfoundation.org>
In-Reply-To: <20251031140043.564670400@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Sun, 2 Nov 2025 11:58:49 +0900
X-Gm-Features: AWmQ_blFwNNxtlVAJhO9Sw2HMPpAD5tSqM9C6mgS06bG4B6-NzncKglA43uu1qk
Message-ID: <CAKL4bV5rU0eSF_MsKV1aW9A+FHquRi327fvakT5Hy6ATzN24Xg@mail.gmail.com>
Subject: Re: [PATCH 6.17 00/35] 6.17.7-rc1 review
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

On Fri, Oct 31, 2025 at 11:14=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.17.7 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 02 Nov 2025 14:00:34 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.17.7-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.17.7-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.17.7-rc1rv-g7914a8bbc909
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.2.1 20250813, GNU ld (GNU
Binutils) 2.45.0) #1 SMP PREEMPT_DYNAMIC Sun Nov  2 11:13:09 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
