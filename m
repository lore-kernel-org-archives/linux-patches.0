Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB0428750C
	for <patches@lists.linux.dev>; Fri,  4 Jul 2025 10:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751623808; cv=none; b=nU55sktPz3jCkt14zYGW0U25S3ZO375KPr+Y+e8gQhk0Krm6zJEPiNL81IDU1BMqhUHxv/Htuye9k+8ntmmDp41wblb3KPWBbqs8LtXNjYSeoYMLkCXA5E7iSjpK8LRIU51f5z3VY9dLUZ2upmEmZPdwTYIAoC5RfANnawooBBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751623808; c=relaxed/simple;
	bh=BvJSQBbLCgsK0nHpn3Pabnf+DjFGHNKncR/GG/p+WXg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DqOaMNLsuQUdd8ZEVrmU16VCmcYhvZgtueUoXhwfpp5SyHuNGjEqf1qpLG5QJrqrgrjusnSceQ8r5+3LNAmJzFzXOkDgg/HGPAgTDE1/01ugGLcmZ36OBTw4TNTAtpe+DrEDvRAXITX+UeKm33FBi9qaTislNKl6iOiGB4n597o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=VRJFVPvQ; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="VRJFVPvQ"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-311bd8ce7e4so723621a91.3
        for <patches@lists.linux.dev>; Fri, 04 Jul 2025 03:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1751623806; x=1752228606; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rGomid6tXjDATmj2wPfvjxlPuB+5sxSNFD5zhmmdhyQ=;
        b=VRJFVPvQTETdJf6pEK5ZP3NbuzndP/ja47lGcL4jeVdmLwTeYqq9frapyK/nyB+cG+
         D7FNwm5YnbazlmGRKjTE1/jOf497XgU70MNDMwOhUNbgevkd5j8dZ25n63JikJaHUNgF
         YEP8DM0DtL6sWSNjucFrTgAuVAmixXxZomOhBYvmdfE2w4SqoJu3zytL7+uk8ynmrk9n
         fB634I0jGQhlQU92Nj3obCVMCCtRuoZu2uz9UC3QNQfFRExlZnGWbQhNPeJitipXJK5z
         D9PeiWFqUDGu5EMv4v0GBNeUuXZqi/8JGfdFSKkyLK7QiaN1OE2GgIluzm4d9b5/4Rv9
         fTnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751623806; x=1752228606;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rGomid6tXjDATmj2wPfvjxlPuB+5sxSNFD5zhmmdhyQ=;
        b=uR5bTFArX7FV4vRrwqYp9GBN0BuuthfWz428yfb2xA4qBVkuh0SbkzluPiuDbzaQmR
         25S2lWOYQ4SdrtEVrWPdzKGbH5VmyWVEPx1ceZ1ZEJ59qXXM4K7tlyUpbYzZfhCNc2Dt
         CaYKp3Wj7Qp1UPYQGO3syMgRvSqsBaQuv/BWE2ZgEVDReauNw1UoMhN1lO6jkwFmLJEc
         hymstOwQiU8zEgAD1FGp+O10eOon5X7Gs8EhQDvH6D+xguzvU+rIXQgYDqFL9c7N4WCe
         zPzukk90kI0OXmTIhOgqLdpe6vKU67cSjcVWmK04I92N+WiBZIrdOSy4naH+9JTTvHRx
         Pbbw==
X-Forwarded-Encrypted: i=1; AJvYcCWasvmdl+85veaLj3loYML5pdCfASAPO+w/W80V1/FWYo98k6WyTdddj3RqrnUyaz1KmIajgyx/@lists.linux.dev
X-Gm-Message-State: AOJu0Yx2HRIwdkP1ziwyPkflLQnIcgcWItkGpsROW64/1u7ku/CMnTb1
	L3xVMd0Jhza38wORNiT4H2fjzp27c1AnUbSZUfIJ65X1bYHQTvSX17/PpNsXozzln/Ptkigchcq
	IHKjiZDFrt47cRwJi+XaDpqx+6DDpHM1txTigkAM3PZoGfIJrkhi6MXU=
X-Gm-Gg: ASbGnctFwE8sZDxd9xJNJTM6ETDOUcN6RtaNY7BLqEjcwBmKznkrnw2xEF5v+QUf0Ad
	/z5E6+jGAKLcgb3LPWftqoGwr8f7OZmNh/KJbAMv+44po2HsztX+z4cgs0P7rfvE8owyCjjO8Sk
	253Fd/z2aOVw03/gUgeQcUk1EGQH1pQikN2jWEdngwfpo=
X-Google-Smtp-Source: AGHT+IH4BxE99Ef0qUkehLWAfQZiLQKgyRZHUcLhWdiTkP5SU7gyIx7AeqV22ZhDCpVD2aL0hWTQw6EzayZ60F59q/4=
X-Received: by 2002:a17:90b:5488:b0:311:a314:c2dc with SMTP id
 98e67ed59e1d1-31aac451a00mr3813426a91.14.1751623805958; Fri, 04 Jul 2025
 03:10:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250703144004.276210867@linuxfoundation.org>
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Fri, 4 Jul 2025 19:09:49 +0900
X-Gm-Features: Ac12FXx8MuFp5ghMIQFlEe6cTz5NY-x9cQoW3RZ4g18YXENAdqBUMD0S6cvI_8w
Message-ID: <CAKL4bV4mSvr9xRyrdYpopTb87BsbsBCj9t7jO+33PA5BRaFe_w@mail.gmail.com>
Subject: Re: [PATCH 6.15 000/263] 6.15.5-rc1 review
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

On Thu, Jul 3, 2025 at 11:57=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.15.5 release.
> There are 263 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 05 Jul 2025 14:39:10 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.15.5-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.15.5-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.15.5-rc1rv-gd5e6f0c9ca48
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.1.1 20250425, GNU ld (GNU
Binutils) 2.44.0) #1 SMP PREEMPT_DYNAMIC Fri Jul  4 18:24:44 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
