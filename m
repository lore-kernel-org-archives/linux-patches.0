Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE58128C2DF
	for <patches@lists.linux.dev>; Tue, 13 May 2025 11:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747136338; cv=none; b=LvsXaLx+8hMmRN4bces8ctIilQUe1Rx8tR8jP6naq1sj73B1jiBCN3XOsNgo+dP4GXycsJYP6Im0PRVY3NzxlU6dxFIrwktxkAVrjR2HpODxauylTeGOLkUCZXHfzvgQfv0kFtjdCKw0N6PycABh7IPlJ6ly7sCRQM55KNymz9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747136338; c=relaxed/simple;
	bh=QY0m5Mq3QK+qfBlMurOu9d2I4hNQNM9XNrP3mIvuRdY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OmSTnI5tg5BlqwfH8eFuEFr2lpxVNPJsSd5x4kyEK5/o704eVxp9hDcu6DjlYy0an7XM3UBsEeex2LoPKTrPaQ8vIz3R1XHPwzS4zujDueYP4OH8oOZgBaD0MnkhWw0R03wLutQ12xWJoblmgYvbU/Ppg16Y9pfGePb6aJ1PFx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=aD6D6v9r; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="aD6D6v9r"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7415d28381dso4512510b3a.1
        for <patches@lists.linux.dev>; Tue, 13 May 2025 04:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1747136336; x=1747741136; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TCDA/phudC5Ubp3SYy7GMsyot2oOw8W6PSjAa8fXQIM=;
        b=aD6D6v9roGIKE+agCh0ZX0NkgqtkyHngOe0ZbSeqovyBW0+Nqv4rf6s06Uj9p9e3hL
         0gy4HJkDhrSpEwTb+NMX8ywleqz6Iewihaf+Wh8+E4Jp958CoMpmyz99VxScv0guLXg7
         LeyteTDzsgBVVjD2L1zW208u4HbxtMuE+9KvqVMBewySNnXqnsd2TRicUKmq8r7foc0z
         J9XvnCUDv+XrxLCMfoNUVL6vt6nHGqFl2E69Vhb63EXioyis9kFPC2qWsJp++nsLoLci
         QIiEr9cqRqBvyiLvgToTTnwfD1bnIub3vrDMLlBHd+xR+JJQ5eJYczAP+pIA8+sxRQIT
         XPyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747136336; x=1747741136;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TCDA/phudC5Ubp3SYy7GMsyot2oOw8W6PSjAa8fXQIM=;
        b=HGJbT8a2PseXs4fXeFLhLN6BctZ4a3hFZje022jN9/lvDeXgkWeitwxJlMo7Bl5uKX
         8jqhZjbDUaEwQ/14pPjkaJqd0W9CZfGiZoke+bp3XfP2fV5VT2s1crrihY3SKmWnnaSK
         An3TZiBbtPqdTjfjOU1OMmUC8BWNPsAikEPmUY89O/h3QHnizInYk8beuR9ev4KfMCu7
         GlQn4cobLrl82c5daqZI5nxS2gzXRJ1hvPnpp7Zb5X/Ho4xhl4xjj5r0XDXEgdTX4ub6
         Y/npkEHphpPX4YysQ18kd46ZzMTHtDz44sWUO4QUsqHpWqeTVvuutuGMDJ1lXQI6emaQ
         q9ug==
X-Forwarded-Encrypted: i=1; AJvYcCXOU8r6O836kOGs1LESTrUGyP/EHV+OKWTTwL0ZGH5LgVByeVcFMjpgk+OxTjBsDRWmrqjXanbZ@lists.linux.dev
X-Gm-Message-State: AOJu0YzfhiuYQpJRaQ1BMyHvW9dQOISLWqQIOW0QjUld2un4Ly0qxXXo
	w5PEGxt7cgTPfjTpaYjaA7619AIAtsEccnwTqdGAXN0ufEQjs4Iand39RfVDGWrynjEfrxdtnMY
	yVbviLwBWbYKYNN2XdjF22iZK6R4Aa7ITeac2Nw==
X-Gm-Gg: ASbGncvq5hHWz0RJd7yyUWfAnCu/VhM+dBqY5pmwCyFoAeCtAL4qMalK7tDcQT/GG1S
	N13ZHYjWMek3tpAB27vbT2FEvWiWZBdO/hJLn/bWIsPEoOYBHhYdCl6KOaJIp1/GOLbkyYirY5z
	uGLQKMv7QkqrG6HC5EaNpdvW1PfUYpSO12
X-Google-Smtp-Source: AGHT+IErFEavacYkaYzKyCsj03GcwMurqloDPo5UyC1bTq/RXs01iErBjbluQ3pLpthUG2UvLKbubccEK3QOiy15YTE=
X-Received: by 2002:a17:902:e492:b0:22e:39f8:61fa with SMTP id
 d9443c01a7336-22fc918875dmr204499885ad.34.1747136335849; Tue, 13 May 2025
 04:38:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250512172044.326436266@linuxfoundation.org>
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 13 May 2025 20:38:40 +0900
X-Gm-Features: AX0GCFsWaVdpAcTWj-O0CPOKts0lC1GIeXOFV79lBRasU6leEtinvJHx6zatOhY
Message-ID: <CAKL4bV6qHhnbm=Q-pXp5wzba7GKhwCwgWGc1QsRCq-eACo_CxA@mail.gmail.com>
Subject: Re: [PATCH 6.14 000/197] 6.14.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Tue, May 13, 2025 at 2:44=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.14.7 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 May 2025 17:19:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.14.7-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.14.7-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.14.7-rc1rv-g4f7f8fb4f8e3
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.1.1 20250425, GNU ld (GNU
Binutils) 2.44.0) #1 SMP PREEMPT_DYNAMIC Tue May 13 19:59:27 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
