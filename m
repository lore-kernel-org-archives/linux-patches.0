Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C372EE5FD
	for <patches@lists.linux.dev>; Fri,  6 Feb 2026 12:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770379237; cv=pass; b=B9P1wgd5KWYay6Iwpci+MjUG1/JNMi/XHicRlWsmZDVRz+1noA5owYVTuSVafhw8mX3SFPhVoZ1dNgBCnSOKzMcN++assUMYfXddoY83SC6dX6lCGf/i+0Rp+pun6vcswQBvLcg7TLAaGLS5uZiPbs7oVjm/dG3ATJZCx6gYTIU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770379237; c=relaxed/simple;
	bh=g20uevV4tVvJLv/9bgO5Hh+jgvBQc0njCfo+a67kzcI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d1pxaVJGtQYgFg7mgX3Q+Z2bId2FxRqKUoF/Lvs/+LxGXlNYwJpsvALZr0fLEgpG8IN0CCBOIM2vmlln0HzAWSqPy78SrLlyDoR34TIfsiVETITGFEZyQq6RyBcl8+LVeYERCtMwe8oFNeCP14gEazIu2H0UYGQQYwHErGOMRpA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=ud8VSDxT; arc=pass smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="ud8VSDxT"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6581234d208so936694a12.3
        for <patches@lists.linux.dev>; Fri, 06 Feb 2026 04:00:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770379236; cv=none;
        d=google.com; s=arc-20240605;
        b=EXErsf4TXdYtTOiGAcEP7NXr/Ny99fEi+lxR9umSJGsDdHwHUUZWYpWMAxWRseNEu+
         w2wdm2JcaWNE1mGeDQmMagJjqvIOMcUv+ZDmpEs3labs/3XmrlATgVQLCjBajrPrVqnb
         Dskq/xUpySKHQe3KsgnjU3SPfHe6UcwlPdLcLstzxNG7yx0CW7FEPF/x60GUoSCcUgOo
         D3N8GxgCJ5oIpVf1ykVi9LpOzM7C4vQhWCRQEKlasUdFqadAzpOtRXpRPsLcY+iOM46R
         8JZvwdW9F8utO6PtyvHasfCVoM+c/QRsxAKkCJ3xeQt2o8rP4pS24T1RWyD4fHysLwHF
         xpaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=6I/x/WRhEO+daalBrvU8SHSRaTRx4bAG6z/mD8JVCJ8=;
        fh=u3tUhqh1H4uErRHY2UOdL6czK1XBk3ZFNIotQ7st1l4=;
        b=DUo7mICxeMzP0kSAs0BzWHcMXeWP5TYTuI1/o84BsX37rQMEz1B7yxddBwx7Tinbhv
         RhJNGziWRqSD19ydZcXUf32jQWoRcqzCD5LcvQ4jf/AXvgYWcKsW11dVcc2vDIYlucGq
         TdlSVlguyvTdiBVPb1wJbA599Xz8qWhorSlO1jAYOuN0vzMJH3i9nK1ZydDjKxy2INBb
         x1h4ijxDBU1ldARCFjpRsVqx49aC3zyxQBrmo6cFG44zRNS3vMeXVAbVSqya1paXouh8
         3sDlq8F+Cbz0orOgcEBkaQoc/XtooUBwK7TfopTTb1BLCtomiAFur37T4Zrupv/1yVvw
         8ZQQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1770379236; x=1770984036; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6I/x/WRhEO+daalBrvU8SHSRaTRx4bAG6z/mD8JVCJ8=;
        b=ud8VSDxThoH6/dgqIdiauGBXPZqLkSbfIYgRgi4uozxHcjGUKLbFLHdfjbOaOZauts
         IZTc9yIRi7mUQgk2jkwxReigDyA9bpeKJ/YgjAK0OFLaMe9CDCIF58t3QIwOLKMlRIhL
         b7pg3Qe6G+pBUACOcky2M/0kYPuP2/pueSwdRc5NaZqkKBLmpHb/0e7cRCme5O0+YRa6
         D/NcYzyBw3jmcJ+L1QG6Ono01j3qt3zQPKK3Ub+D9sC1eZMxsbcZCtElFVwF/obWGq6w
         9TVVZm09srNcAr7DnRnhDs5ztqguPbkFfxXFHw3F0fwppS6oBzRVL7eU0lonw9tPR6yp
         nY6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770379236; x=1770984036;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6I/x/WRhEO+daalBrvU8SHSRaTRx4bAG6z/mD8JVCJ8=;
        b=baVshfa4ylk+b0DX5YG+oIJifMh0qD8lZCMozKqsf2urxt1PxUv+/NUnFZeVtq6OZ2
         IUGDtU/0exGL4kZ20t9K/djFrvmPL7m5fRbfnHShjFn1n0BU+jlLLYk3Ob/6p3EsnVpT
         SPaHbVGr2lfO623M6S0Te9n7A2UoBoBDsUZ/oMUwzg45O6P7AAsE+KP46XSGd0VTdavV
         wDWzQ4jNrPQqxKQ7Rlg5Dj67N6bNiz9a/9OB/3gvmqg8l9xP0UuCujSgRSikMvwlikhA
         XUPIzk8edW2VmLUdWpmCzlmIN6VV9hMLoklhS6uTdAiKkve8lShTSSyZ8foeMa/rhJd1
         DglA==
X-Forwarded-Encrypted: i=1; AJvYcCXvQ4bR274i2lj6vLaQvvD4CtUffpxct54XiM4Yjx2/VWSPCEFSBz8X54S4KjuBp0LZ5TUzbXTe@lists.linux.dev
X-Gm-Message-State: AOJu0YxqrRTgWaOk9f4uUgzRUVEjlb7aGK87to2XzceZMXtpZezLB9+6
	Wn/uOA2+NQE9H9WluwhszMfzobbKar6W8Gqm18zSJTzzoBEoHrdSkXeDv0hxKa6ljDmWcY4iVLh
	18PVpXoOycIlT/FyZfPV84ar/GEiIK1Bk5IT33WsMUA==
X-Gm-Gg: AZuq6aIR86eysXNycz6fgOHeiZ5+IvJSYhBiYdv6+gYFFQdYQn2R7T5wnPyUpd55eN2
	0dFCaPyuY2L49ewDudgkmra2AHk91MHokRSivxHKKRyI4zyV46Y3VVJ/wP2RlWPkWSbwn8sDoa+
	iEnYSWO8b3S15zAgv5lyeAwzDj8J97SppFwEZdZbdNhKdwF9TuJSyvsUQQpUGbzZlYUrftzAzWz
	dZHDFrJ4zsE62/V99k5By2z2DvoUmFP3hg/8PzvqrM9ga2naUehvugaJ7JzvUKbW+ZlFv/T
X-Received: by 2002:a17:907:7f8a:b0:b86:fca7:3dc2 with SMTP id
 a640c23a62f3a-b8edf15ce6cmr149172366b.10.1770379234954; Fri, 06 Feb 2026
 04:00:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260204143851.857060534@linuxfoundation.org>
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Fri, 6 Feb 2026 17:29:58 +0530
X-Gm-Features: AZwV_QjOvgjK9NEvluJj9yu0cCeB3pX9VAK9jLAhSJ1LBGv7_CJIl-nLLopraP0
Message-ID: <CAG=yYwnSJCp6W6+0MGG_aaj+Ao7Qhiza0FKvrP-4wf6f9x1SQQ@mail.gmail.com>
Subject: Re: [PATCH 6.18 000/122] 6.18.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"

 Build error related
screenshot  below.

--------------------<screenshot>-----------------------

$make -j 4
  DESCEND objtool
  DESCEND bpf/resolve_btfids
  INSTALL libsubcmd_headers
  INSTALL libbpf_headers
  INSTALL libsubcmd_headers
make[5]: *** No rule to make target 'str_error.h', needed by
'/home/jeffrin/kernel/linux-stable-rc/tools/bpf/resolve_btfids/libbpf/staticobjs/libbpf.o'.
Stop.
make[4]: *** [Makefile:152:
/home/jeffrin/kernel/linux-stable-rc/tools/bpf/resolve_btfids/libbpf/staticobjs/libbpf-in.o]
Error 2
make[3]: *** [Makefile:61:
/home/jeffrin/kernel/linux-stable-rc/tools/bpf/resolve_btfids//libbpf/libbpf.a]
Error 2
make[2]: *** [Makefile:76: bpf/resolve_btfids] Error 2
make[1]: *** [/home/jeffrin/kernel/linux-stable-rc/Makefile:1449:
tools/bpf/resolve_btfids] Error 2
make[1]: *** Waiting for unfinished jobs....
  CALL    scripts/checksyscalls.sh
make: *** [Makefile:248: __sub-make] Error 2
-----------------------<screenshot>---------------------------

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>

--
software engineer
rajagiri school of engineering and technology
