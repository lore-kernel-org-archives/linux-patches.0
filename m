Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AAF01FAC48
	for <patches@lists.linux.dev>; Thu, 20 Feb 2025 14:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740060965; cv=none; b=a+AWSXIf1WCeQiKlEGfoSpxJx919uscj4lFLLmNJfAdZukxkinlIw9KZD/8eYZNiRcuXtQUDHGHhdfVCHd2CiyUqIMjAXFeN16sLvrlrE45mP3jpDuas3O/XRwkbwmZ+/KbgAnjXLndun2vBW5sp7dQSkhtOvX1xaqU/ASfVb2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740060965; c=relaxed/simple;
	bh=FnUDn3kteGNiPrF+F00ntwEnWg8uVOcU+mbj1dX1PPQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=re3atSQQgw0EK1QW5QE38ljPsWCHKoBavaprcojF57ucMiWRbolsSbSkiSTQrK4DxTryiaGt4Bw7M9doGuZha/1SQVi4NI9CCnF4yPD1io/OSj2NpVWdfGeM8iQJ5mw3bMpmdopqmrnjIWg9Aymtjk4zaNddGVCIIylsBgEZhpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=Wlynp3r2; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="Wlynp3r2"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2f42992f608so1606980a91.0
        for <patches@lists.linux.dev>; Thu, 20 Feb 2025 06:16:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1740060963; x=1740665763; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yFcRRgZ/OI8HueiYaAyTUjysgPa3NhOt5Zbu8dcMaH4=;
        b=Wlynp3r2+rcHkNVhe/hC/gyh/gbONqWiqh6cUOfY9ZA5uAqV8R2XUlqctGN1x1Ox6b
         LN5wbthP4EjoLylxVsj8+/D6CJrELavBuZQtaKQuDBK5I0H7M+Mnc9oOuqONeVE/jxZH
         sRXaeqGWZ+ikin8S4EuuTrjMm0pLbFHOWdpWHVq0ss5SmfEYQ7UGV9hJMfIhWXLrqJ9W
         z/ePYumKyn4u91cJWT0/TZfHhHvbnhuvVkfXPeS30sOOsSJHcMsExGCBwAgyX1UUBuGF
         XdkjhEb2j1RAYhhA5Ut+bkSiyejlICQenCDS/NcZDv136DGTr0POpq//Fd/AdoGWUa1S
         vYcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740060963; x=1740665763;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yFcRRgZ/OI8HueiYaAyTUjysgPa3NhOt5Zbu8dcMaH4=;
        b=Rn7zlxeej89k7uCYIXb6+FRzppX+vXpqGEvHbw/93kuOE7f8h3QxOZAL7fCdP0G8gP
         vAl2oMQAq/5LgRMePN0hA1941D2HKkur17TB/VbyLObBf0q1FhXNmgJmr1w3oguFKwID
         Qin19H2+7Ab6mUGpj2is+KFX4/OjW+5S/SwM8V6q7MAkHQRvTGM6H4mzsCMntd2cWPVQ
         bPzkQvq/lCXGMuhYavgZJLjgIROFMIlnw+Jcu2xN6XELDkM+CmUgFY99TRadehjJEHFy
         m3wUzTWQnwPJfxU08ermUjVggSh07jlUF4yWAIZbKHWsxgnD24c3GlqL/wYYU25JNh0/
         ckPA==
X-Forwarded-Encrypted: i=1; AJvYcCXRU9yDJb2xAuvd00HanbeqsiV7rzWLteWKnTEiQHaCel+Hio9rAKgAolwkdoCLZj5b+QObLqpi@lists.linux.dev
X-Gm-Message-State: AOJu0Yxbd0jNnBzCDOW/jAGMaAdc7T5MCiAqFmDKPe3T3gFobG2kmTDY
	P0diZaK0l9G7jf7/lk1QLkbJXUyAwPTzPVmjEVlmUSsTdnfqJL7pK1LnabL9wWGfYEu5ha8yYTt
	mXAUZ7+bV1eMTh6eAwn5dD9GJRgrCy65qI6kIOA==
X-Gm-Gg: ASbGnctGBY+GyMM6QDoAI5xRsvFsikZpH00RngLQ/gaYV3aIAhfQoN9/p2tT+10dFpp
	oFmb3GkUIYp8NpC0I6T0l1JRj11atdGF6/etoV0tHT8qSqHOd9g0sddyNj0bnqFmxJQKdLzm5
X-Google-Smtp-Source: AGHT+IEbWS89Bl3M1hawkEALiF7cs/fWjH88qNg94FJjoiQcjQaQjWu5RV+u+rnxMy7eGDtdRYuM2xTyBdXRPvgUL3Q=
X-Received: by 2002:a17:90b:1a87:b0:2ee:e113:815d with SMTP id
 98e67ed59e1d1-2fc40f10271mr32024795a91.8.1740060963496; Thu, 20 Feb 2025
 06:16:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250220104500.178420129@linuxfoundation.org>
In-Reply-To: <20250220104500.178420129@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Thu, 20 Feb 2025 23:15:27 +0900
X-Gm-Features: AWEUYZnRaDnwS57qTXFvSLbWRSRROWyGCamNNyT6sk5HbujlvZO28fPyNcOuvaA
Message-ID: <CAKL4bV4NumjHYoKgCqnuqzQGHTM-wLnohFAPKRj5K6n+qWpbhg@mail.gmail.com>
Subject: Re: [PATCH 6.13 000/258] 6.13.4-rc2 review
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

On Thu, Feb 20, 2025 at 7:58=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.13.4 release.
> There are 258 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 22 Feb 2025 10:44:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.13.4-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.13.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------
> Pseudo-Shortlog of commits:
>

6.13.4-rc2 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.13.4-rc2rv-g191ccd3d65d1
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.2.1 20250207, GNU ld (GNU
Binutils) 2.44) #1 SMP PREEMPT_DYNAMIC Thu Feb 20 22:48:41 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
