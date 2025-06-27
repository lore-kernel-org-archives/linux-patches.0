Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B19B271464
	for <patches@lists.linux.dev>; Fri, 27 Jun 2025 09:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751017171; cv=none; b=mDanOdmWYlABKMK6oSE0Y7S+5OAMJC7r+7xYu2ouP2RUA6QSdCGXn6cmCFPrm8h6k5+2UOAZU5IKZet7YjpJR/8czjHKL0mMLrk+hG7u+nSLD13rZIdmYvP9R4uG+b2vO7H9BLJprcdVC4MoK1UPJbQGZDW1R1CB2XIxy8udp6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751017171; c=relaxed/simple;
	bh=sqHLSnoPdND2n2YqIlO9rU36LPxSklJW5fcjecRMfIU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PN2+Q96QUxnzVztEpdEtMrEpsOWeDMPYS5CcuFBh2Escfwj2seOUCrq5swV+0YsFjEuvfeiDQNWC2ok/RNJDHlqZAWHQCk/0WqW0PxxrgklzregWXgOiWg6oqHbXsBLsZLXoZsSU73X39v20M2DWuy5LpNfRhutryJUr7mx/S7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=n/Ha0JW6; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="n/Ha0JW6"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3122368d7c4so1706318a91.1
        for <patches@lists.linux.dev>; Fri, 27 Jun 2025 02:39:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1751017169; x=1751621969; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7EoXolbAXfPP7jncmJ+OthdgINgb5uiOwXnkRnnjQZQ=;
        b=n/Ha0JW64elLDyoUPm1zwe8mIXSwQJp+ECwBmJzWtPb/ushrSg12WY5SDc2p7LT5fy
         Q7YPsSsZfug6qy64y2hLmczrLKQJGgpNPtrHvx5+o+rkI5dWa5crGtj6QNGkoyA04mO7
         dl1HcI55CkD4a05Barf6SWCYAj437DVCSxil8i1MxW54rd+9V4VeqVPJg7X0jWX4kBI1
         JUXvzGOKC784O1G4QlCchORGfUuqPncAUnz95CC0bzv9gyBzE3yd3Tb3sFDDszluH3KT
         KbcGwqFkzMhND0D8mj8qTkQ+ap2t8t6z0PElD6PGZSXikDXyYGPXbSbF2hKM9ESgvvHW
         t7PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751017169; x=1751621969;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7EoXolbAXfPP7jncmJ+OthdgINgb5uiOwXnkRnnjQZQ=;
        b=hZ18v3mZjK/zfio8dRXQX6B1v43KysIxB7ioeyua7053P6JE6vJTqLfktP421xSk7/
         x8jQilSv13ZMNZTyhzlSS/pzxyv8xyz9krPVL+B8ro2pFxoURCSGeCkpPgT/Qprym5Cm
         3AfMcPJ9iD5drc3pdkm77suq0yuuo+BJyb2W8xv/N8JSLKAUMMc/Br4mGEsBh2zXebk7
         PUrCyJkE90Zn7mDm9KyvUq2c3jh8an0a+iRxpUrkDQs+HPAnJH8yNE8wvQP4lwjo+/vO
         g5pQyufFn9KW6rztAUOuGBSMg0nwzv8CZXUm4W3Bd5EkoG8Hn2wEud82lvTRHk/t9NY7
         12kQ==
X-Forwarded-Encrypted: i=1; AJvYcCXkHrA+zqBYSDofmfXNw1yI5U4t+/VuHc5xh5yJN20WTky6Mj3dUgQgHaSAADs8aEry643H3Ia0@lists.linux.dev
X-Gm-Message-State: AOJu0YzX+8BxoK+7XZmTZofkFchkceOEhc5vrxS8VRc1yu2OAk5Lu1fh
	Cv5Jb4AtTa5rCfGlxZFBjgFq96WwKENHQuSEkWuiSYA7Cg8WW8IhSjeaeDxaULqTTguhHuXJFXm
	bVcpdvR7jf5twbmHDkd6VDRptgMqQlf+hq3AxMl43ng==
X-Gm-Gg: ASbGncsoiv+sHC0ntzJCENfUmKmVdBkUGoSOEkGtiVl8yuXEGc57oYNPQ1zes191/lW
	/aqZ3e+37CysIyR6eljhm9+V293JD5bC0CjlOK9l7zlDp/3tQdmlrkP+SIbR4hUU0QYh0IbCWPJ
	aoa1OzkaYuvbcCQmZr9Wk2q5lFXazIGL+kYiduoBE52A0=
X-Google-Smtp-Source: AGHT+IGP36mzrkCAQx/61O1uVwnGrnhnEFQFaqi7Au+tCZKEUAsLtA9E3QNCQ4g5Lbjr9hqyOV0ruBng7xb3pRA7xMQ=
X-Received: by 2002:a17:90a:f94d:b0:311:c5d9:2c7c with SMTP id
 98e67ed59e1d1-318c9250375mr2738869a91.23.1751017169338; Fri, 27 Jun 2025
 02:39:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250626105243.160967269@linuxfoundation.org>
In-Reply-To: <20250626105243.160967269@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Fri, 27 Jun 2025 18:39:13 +0900
X-Gm-Features: Ac12FXzLbc93PcgOHbJI6EISu6a8l58rrpz2xfCSW65gNinqzCCU2fndTSOrQ-Q
Message-ID: <CAKL4bV5mKKAAE2AXWDVLRhzUNiG51Q7jsx0FhKx_GsDJMRGpjQ@mail.gmail.com>
Subject: Re: [PATCH 6.15 000/589] 6.15.4-rc3 review
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

On Thu, Jun 26, 2025 at 7:56=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.15.4 release.
> There are 589 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 28 Jun 2025 10:51:38 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.15.4-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.15.4-rc3 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.15.4-rc3rv-gd93bc5feded1
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.1.1 20250425, GNU ld (GNU
Binutils) 2.44.0) #2 SMP PREEMPT_DYNAMIC Fri Jun 27 11:57:58 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
