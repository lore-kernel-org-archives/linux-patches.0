Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC351E87C
	for <patches@lists.linux.dev>; Fri, 19 Jan 2024 17:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705686801; cv=none; b=G79f/27a04n8u2OViH3ZAknrNvcd6YH9CO22P/Lmk4HdG12MP7Dwl6xAswhpOhgygWWFY25VX3D0nNRwwWaO5IAadZ2NVxW3HgOJSVaII4cCfgZ7BLug+3b9T6Q4H34gWEGIPu00NyBLGFGmZTq1f5XAZzjbvpWy/DL40wX22/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705686801; c=relaxed/simple;
	bh=joZ3oqdD35mH93NqBSHyDq6L05JkQomCwHe2AIIsFH0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VyfDX8tf9DfWuFzku2/wrAPt8H+FhJqfgRKE0mAQFy25+CJhS11IPojADZy/XBfPpV4LwGV5dld1jvm3lysCoNeNEWab0KmAASviO7xlz6m8ipkJR87/lbtcrOoHqIyfxCdxgYvz1kWi2rOaTWwxWvaZbSKBTjCGYJEJJEKW1Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LGV6TY3P; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LGV6TY3P"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-5ce942efda5so844532a12.2
        for <patches@lists.linux.dev>; Fri, 19 Jan 2024 09:53:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705686799; x=1706291599; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bWNsVy0kTO/oiTcTQ5yfNu1I6n3cORC/fqV3uGmtSiU=;
        b=LGV6TY3PAwlp+CUm5gLOwJgG3YzixOziCp7NXsQlNViJKqsJ4+plHT/2bOU5HLwSBk
         oGLrZGVpzZHMdvQzNGzPt7zq5UfeprZM7Aj35cQ9dBFikYm82L1mktkSARePiMem80ue
         dxifiNoboCeHtw0Z0DxkTr8P4g3qYwjxQxyoMhB8w7Lo26mdyzNPWrsQitzOYSwzKQ/k
         dADorje6gfbuqxDES6oDwLyeawMn/zycWSmsJeoD1NO82CxV27nB8e9FRRxsz9Sy0KG0
         av+RbKG/SjtvjjQBHIfwHYRP21mpulaRBn66tVV0fwrTR7Z+904TJ8hgfypI1AAsdFZS
         sQ6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705686799; x=1706291599;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bWNsVy0kTO/oiTcTQ5yfNu1I6n3cORC/fqV3uGmtSiU=;
        b=Iy9aZtOKXeTMDaYXidbxttSKQCS/izwUF0gRZ/dgUbZCkyraNyjMLpUrThi7c0jMpb
         PHcGnYZEBwvpZGI+4Ml6dQsKPDUYjAbnW/8W32xG1pAS4tftS44FBHUY/QZ+FsEPfGfD
         iUy7NSXymBqil8b7LqKMv+CpcI45ImRGdzfpzTi+t/47kb2bkNwjO5YRfPyPqWwV7oTp
         6+/8xU+joW1ysHaksjguqOu3IaBQAmQY0eN/JS5uEXHYy664Pg5ZyrQfhUdT71jE4uUY
         AaA59/GfvsG4RTfFuUwwcjlvnr1sELz8+TdH5nk+OlFsJbHtVVjynD2lczwEZcNbBW5J
         Rdig==
X-Gm-Message-State: AOJu0YyTUTe81Z0Dk7mmUbXDNqFdIujA/0dzn6P3qptQ8gz+B7w5pXLe
	0iQilWKV3VAPXD1ehTHlreizohnT6SC8UonIUQf45XySmyOEgapkCt0G7SvahBsIuPvXFGZTJAo
	7I2UCgMKUBM11vSOJAHBtWao3Lv4=
X-Google-Smtp-Source: AGHT+IE1CSWzpt0z9AJr2t26c2E94K4ctR8RmKK6fIyBA6fD4c56V3CCGLhkExsI0hw3aMK6GoEBsCipVS/DU2ngbCc=
X-Received: by 2002:a17:90a:bd03:b0:28c:cec8:cfe0 with SMTP id
 y3-20020a17090abd0300b0028ccec8cfe0mr120928pjr.94.1705686798681; Fri, 19 Jan
 2024 09:53:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240118104301.249503558@linuxfoundation.org> <CA+G9fYv4PdOsuFmd2BGoq57omiXWuvnSpJJ1HuLYT0rJ_h9xEw@mail.gmail.com>
In-Reply-To: <CA+G9fYv4PdOsuFmd2BGoq57omiXWuvnSpJJ1HuLYT0rJ_h9xEw@mail.gmail.com>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Fri, 19 Jan 2024 18:53:05 +0100
Message-ID: <CADo9pHgVDXXw6DcFTPHU+Cg10K4dusW61N4G5CFba-Qr99TS-Q@mail.gmail.com>
Subject: Re: [PATCH 6.7 00/28] 6.7.1-rc1 review
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
	conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Works fine on my Dell Latitude 7390 laptop with model name    :
Intel(R) Core(TM) i5-8350U CPU @ 1.70GHz
and Crystal Linux: https://getcryst.al/site

Tested-by: Luna Jernberg <droidbittin@gmail.com>

Den fre 19 jan. 2024 kl 16:48 skrev Naresh Kamboju <naresh.kamboju@linaro.o=
rg>:
>
> On Thu, 18 Jan 2024 at 16:20, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.7.1 release.
> > There are 28 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 20 Jan 2024 10:42:49 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patc=
h-6.7.1-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git linux-6.7.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
> Results from Linaro=E2=80=99s test farm.
> The arm allmodconfig clang-17 build failed on 6.7.y, Linux next and mainl=
ine.
> but passed on 6.6.y.
>
> Links:
>  - https://qa-reports.linaro.org/lkft/linux-next-master/build/next-202401=
17/testrun/22090095/suite/build/test/clang-17-allmodconfig/details/
>
> ## Build
> * kernel: 6.7.1-rc1
> * git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
> * git branch: linux-6.7.y
> * git commit: ef44e963b02edb00d4de5fa3528a21f3e7b33a85
> * git describe: v6.7-29-gef44e963b02e
> * test details:
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.7.y/build/v6.7=
-29-gef44e963b02e/
>
>
> --
> Linaro LKFT
> https://lkft.linaro.org
>
