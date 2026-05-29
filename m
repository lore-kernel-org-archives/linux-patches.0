Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ACEB3ACA5E
	for <patches@lists.linux.dev>; Fri, 29 May 2026 19:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780082634; cv=pass; b=dwmJEMlRkpvJcsxP3Hub/YPJxXpCl7MS34f4VMZnohJrfUyz8axT7nga+CK6z2Rj+kJTLI1BJ0nZHDxjKiZJQegkBL1Jjbdi78jyoLuqsC8ePWkyh45CUYhETSos6TTE5mDOuw4hsS0HdbXaWG0i98Uff2sUh1BjN++90dugKFc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780082634; c=relaxed/simple;
	bh=oxt8Q+W2WsDLa+wW/HdAmzz3vSh3SBOrxOS7ezVfgWc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jJVluJ1W9b1aZ5CNTqBu7egfnWKTr1vLba7C8EBGsbYqeaENxCN99qYYZRJy5O0gwEOc73mi7CqYP5JkMLOEmxLi0AimorLIG9dq7pqbqA5Qpjf7FlwH8loPEOkyZK80Sw1W98mMOJ7LzZ7M+KxubnAc3yoP2tselcZEbB2Qui8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VvRliE4B; arc=pass smtp.client-ip=74.125.82.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VvRliE4B"
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-2ee4e75bc93so1134591eec.1
        for <patches@lists.linux.dev>; Fri, 29 May 2026 12:23:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780082632; cv=none;
        d=google.com; s=arc-20240605;
        b=Kf/j/YdTDaIUU4VetGmPSPweztSh958w66sFB9ojbxU4+N977Gpm6DO8bDvZBTUUa5
         nrbrRa3gmIQx82o3xwO0ut37PGsOl8R3CDaRYjJoeos0cKe3I0B1JygSGI03/EHZNqLp
         +266QSyjIm30B8hm3APUcryds6xsz1KlmJR7/ZW6F12GsbeewVdQUd/WWJrt6N3Fm3au
         3VEHONf06JxddjEZEGNI/e4TXDJAxxzveINMS4LFQcSz2jJhOZYTt8jHAheMY4QrzAu/
         E1P4ugbUd4EfK+NA1NLmNFSYiBfG3PACpQHpds0VTa1nQi/0liKxuEiS61dLVEJ3gcgh
         zWGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=oxt8Q+W2WsDLa+wW/HdAmzz3vSh3SBOrxOS7ezVfgWc=;
        fh=hn0OL2IkBwBYoE94Gx7PvGxbRYSUiXWGKe4fYmvpfAs=;
        b=PbNJKL33cY6PHQ9IojYu6I7aJmPcGVQr7L52GVOEMtqUUbVe1HfZKTzNeMpv41SJmL
         DKXfF5xRCwE4Fd2w+5mOrEBI46KW6C8+SSEix0feFGWs3sA4/3eVd+SB1RTlP5v3yqYA
         RW3DinP14rpUyja7aUAzLdaJrUGtkJ25SsS8nW8kV9rWk2pdjkEEC9qHT1803YGnqEGt
         UQ/xAiCkl4QBbGyxCCZWhJ/OO/w32IjEBoqjR+BkDFqVMQxGfWGA5cdi7E3DbrKBQLwE
         XTyGW0nv6vuW2efmer5wJKY7QFg6er+3DaguRkTBkGiaemYA2w+LiGkNnI7IRWxKXKQv
         du4Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780082632; x=1780687432; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oxt8Q+W2WsDLa+wW/HdAmzz3vSh3SBOrxOS7ezVfgWc=;
        b=VvRliE4BlIRxDBv0VH30Bzwdo0FHAiDbwCuCsEtvjVYP0L+++xP2M/rlU7BAVSbKTm
         QcRHAuOMPnaSPf/FxAOpLBYkOggAR0TwmCFF/jTju4BHMNCXRorgh16RSrNWuI7qto9D
         6M73TtgKXL+meucsJrU1UMWUbBhkDuBxyl83j5kc+2GOhmy2p9iuBAyMNFfaO1G/NDjT
         0p2H6+BDIv+hVLQz5gZ8EhapJDdCnIMOXgNmD/1dCN2SFI/fokgG0O2RaUqfui9xufwv
         hzWz6BodUCoNyYNjaIonK6SlkAxdXe2lgT6nbKFW+79W6sIi4VQeNXBXJDLYR+7jQzL3
         5LUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780082632; x=1780687432;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oxt8Q+W2WsDLa+wW/HdAmzz3vSh3SBOrxOS7ezVfgWc=;
        b=l/Yoa3Ct1UAFXC26g5wjP30jHDwTGtI9Mlv8druRxdq3ogDdTbLsXCSdneTDlcXlMd
         u6moE0GKoMegSMSvxUto1CzV99Dc9+bGT23ZopzGBX5NvEFWaaVhXvjdveKXJg38H8Yw
         tUtYJOx/ewCeM+pjPs/n33+N/zR+b32xtODr/8bQrSwHuuWYidMhDyYwALYtusRaj0Ua
         yTQojtr/K2eXKJKRpLIR+5jIpTkcdvHk1NM/fJ23fYCFSMFbnnq9dfCdxbIMEnBVgYxv
         NKoOAedJbreE50s7pUcovbXH0UCu7zHwKHIiefAkekvX2//NSWcwI6CnnYe6/PUz+DKu
         yU7g==
X-Forwarded-Encrypted: i=1; AFNElJ/aU9V1pz8JjxeMDCzSqm5YvXfIsoGpTz/q0oQhoUtxl8g0QMoywEsO7P9OQwFa7zqfKSpipC+8@lists.linux.dev
X-Gm-Message-State: AOJu0YzH1DC7MCqNB5wK13lRhgjuX0xrw8PTh9zJ1ukcdVPGVWa2z7Ly
	atI5lj7KBPZb1D4lNoS7DqZN+IHtFNMEMsmWU4zpJ+mW45yAEpKHgDMZzo5SsZcHAL12oPPEO/r
	UxtbCxjc+mshqAmhvWaLOBqge2kEUq1g=
X-Gm-Gg: Acq92OGw0B9/C6s4Gch2e7+uQsu1q8tKQyHtcGz88vZzTJhyDE48XHoIUZg5e5zD1VS
	roRNIpuRYwcRtk2xteLfqDo+TntX/PZdeqQ2hErv7zRtT2e3JaQhjk3/aYQzMu3zw+bq4usl8fa
	bwshF65XL6sJWpxXLr20GBr9Tg9HFPRc/NCUDO7i7HrZdDbtAn+lX0swAK6oDR12BUHUiNdjbwg
	MBnj1Ev9n6pd3AwPb6bwU7YgK0dNZ0Rc1D1vCMukqtu9hfK9wWBXNJUM8pva1s7t7Kqv1ExZX/R
	ggLKdGtXWSWlgJTz1n+15h3wMNaqRGSyxbhaTiL3Dgkvhdmxd9ctOUoGyGFG2p2isBor8x5DAGk
	7OollyNQVk+laFNNX7rMFeWtDEsYjdz2Gqw==
X-Received: by 2002:a05:7300:fd02:b0:304:c73b:79ea with SMTP id
 5a478bee46e88-304fa65935fmr269421eec.3.1780082632355; Fri, 29 May 2026
 12:23:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260528194646.819809818@linuxfoundation.org> <20260529054139.120182-1-ojeda@kernel.org>
 <20260529185046.rc-reply-001@kernel.org>
In-Reply-To: <20260529185046.rc-reply-001@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 29 May 2026 21:23:39 +0200
X-Gm-Features: AVHnY4JA7t_ZnbW45aaa6F6ZMDmDXu8KTbZJaiGNMmTmWANvKuJkOpXJv3srhGY
Message-ID: <CANiq72k=M7bvd0ne8thLQFOOYACM5dRoDdNkTbeyTXaeL7qndw@mail.gmail.com>
Subject: Re: [PATCH 7.0 000/461] 7.0.11-rc1 review
To: Sasha Levin <sashal@kernel.org>
Cc: gregkh@linuxfoundation.org, achill@achill.org, akpm@linux-foundation.org, 
	broonie@kernel.org, conor@kernel.org, f.fainelli@gmail.com, 
	hargar@microsoft.com, jonathanh@nvidia.com, linux-kernel@vger.kernel.org, 
	linux@roeck-us.net, lkft-triage@lists.linaro.org, patches@kernelci.org, 
	patches@lists.linux.dev, pavel@nabladev.com, rwarsow@gmx.de, shuah@kernel.org, 
	sr@sladewatkins.com, stable@vger.kernel.org, sudipm.mukherjee@gmail.com, 
	torvalds@linux-foundation.org, Miguel Ojeda <ojeda@kernel.org>, 
	Daniel J Blueman <daniel@quora.org>, Rob Clark <robin.clark@oss.qualcomm.com>, 
	Dmitry Baryshkov <lumag@kernel.org>, Abhinav Kumar <abhinav.kumar@linux.dev>, 
	Jessica Zhang <jesszhan0024@gmail.com>, Sean Paul <sean@poorly.run>, 
	Marijn Suijten <marijn.suijten@somainline.org>, linux-arm-msm@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org, 
	Nathan Chancellor <nathan@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 29, 2026 at 9:17=E2=80=AFPM Sasha Levin <sashal@kernel.org> wro=
te:
>
> Thanks Miguel!

You're welcome, happy it helped! :)

> Right. Rather than dropping the deadlock fix, I'm queuing the upstream
> follow-up 53676e4d44d6 ("drm/msm: Restore second parameter name in purge(=
) and
> evict()" for both 7.0 and 6.18.

Sounds good, thanks.

Cheers,
Miguel
