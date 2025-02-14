Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F3E1FCCFE
	for <patches@lists.linux.dev>; Fri, 14 Feb 2025 23:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739575186; cv=none; b=UYPwBLYB5SpZ6xihip9ixk2DF0J3cxZyJERK75aEfq9GUGDUUyio4xwBuKv5ZSsb8+28fnEIjo+mWHnYXdWOCPjSmBVmcZ5Cw8Eh6nx4t+IlMwGoC+Ysawh9mXmKj+HGgQQi1PF5KRYp6VcuwVDqDGdCZF+64K7JKKnH3Izosww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739575186; c=relaxed/simple;
	bh=IVCW8vVwUdVf2Ohvyaabldfb9qJTAjpef7lVg2IxJj4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XaVCHxcadvQiEVFwTw91t2N5ZG5xCsnkuYQaNDbk5Rdo4BYeFx0LYATJts2dfHToruz+S94Jg2uo5BQXAbQUZa2Cre6P5fLjvtZgAJ7J08DWlzq4+3o6OOHCZEbDsGSS6RMmnSfQintILOjrxtjp/5472B0KQCkUOfw7XgZzjHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=xKDnfkiN; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="xKDnfkiN"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2f833af7a09so3816905a91.2
        for <patches@lists.linux.dev>; Fri, 14 Feb 2025 15:19:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1739575184; x=1740179984; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M1kptu5/J+vpdEp6ep3Tn6E02zBSHfeej1qMSG9kR5Y=;
        b=xKDnfkiNaAop/H8xbYfEGW2rPBCkySKVQDn9qrxZAVBe6ucs9+TArjNTh0mdg7PcVn
         i1PdT/jsNhAE5Hof4nWGfX06sxVv59XtcSUzVFfcY9KO9CE32fd7SaoRl2AUT9GMtTRj
         Si1ccGwDaunaXfQ8OdGUS9v8A2mT0PN01zPQbIIyx07mRoJ+xYRnwm911sz9Pm2U3jte
         LF6I0YIvV3W6tfy/m8zLoLwmut1lSIeZkCmWw27cDZG+QehEswhtn4owfwGGnuQLBNal
         kjbfGzxxYN2K9yWkabq8hfwGVHE0YnL/TMK+79kiEysL8Q8dqxWhbDnIssDMbdrej8+z
         itTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739575184; x=1740179984;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M1kptu5/J+vpdEp6ep3Tn6E02zBSHfeej1qMSG9kR5Y=;
        b=Zxqw+34RBWAfEWDH59veDyP6rPcMjwBn3g3y2XTS5Xx8Kw6CiXIGR8+8fgiWykvZhG
         Yvz7CUlOM0RHz274ZqJfdS9rjrytubuoXrDHXlQccFsZD+41jSwGB8DTVQQsjm9wpYv4
         /yQlt+TLm1f2P7jxNXmFZ7N3IgOIGPNDyTCE5bu38dRKwXhmG67A46H/I3UrGvS1bZen
         J2OFCgi3USJX6mKygdtrqJnIpEiYZTvGgLyPDgrwE3LLs5gGf2KZER9/IUxsJ9dvb4XA
         w/VagZZMqG+Z7n+akU5OvymzeCRTzmoKeF3DGHU8kic/S6EY6y234Ph+IkP5rouTNRID
         VCYA==
X-Forwarded-Encrypted: i=1; AJvYcCVYn4T/yKW8Uy17/WunLbwtBfvSV6aR2ryKt84plANKPO6bUPrZZY81AuNFeD0c5NXOEiO5lME9@lists.linux.dev
X-Gm-Message-State: AOJu0Yybs6X1md6LEF25MnkWFt18FmuDSIBQ4MyH5Be3bIo3nJ56+KEI
	zwoCxPFuTyOXLeIFZISUevjm6u7X7yf4GGjJf8Ht8ZPHlwhGTZ1c4bkbVCy+Q9bjmhOULVBsJwG
	3IKVVzSx2FhkjguGxW1XSg0rzRgaLnDAf81Hv9w==
X-Gm-Gg: ASbGnctxmpANqbmTS0nDrBJMmn3itwaHMU/tmo+YThdTh9WFGdXkOoAotT1tGUPyUGI
	Aaqq35kPJ/ZQu6E48+JJKmGWuceVl4BFSEVXSKi2arK2/7KIxEdzMsPC8sr8EBRJFOscID00=
X-Google-Smtp-Source: AGHT+IEMDk4JmHkWwYaC0JdU3mrceeG+mLsI96RmyYTF792fB06bA49XHLnAxr/Cg0xW5tlJasKPprqGg2xWInDdScY=
X-Received: by 2002:a17:90b:4fcf:b0:2ee:a4f2:b311 with SMTP id
 98e67ed59e1d1-2fc40f1040dmr1245930a91.8.1739575184167; Fri, 14 Feb 2025
 15:19:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250214133842.964440150@linuxfoundation.org>
In-Reply-To: <20250214133842.964440150@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Sat, 15 Feb 2025 08:19:33 +0900
X-Gm-Features: AWEUYZmSJWzwPPeIoaUIOQDKvcgfilAIixByMHWDgVxEElGNhm8DLhW2jW1DgKE
Message-ID: <CAKL4bV6p=1wrzk_HoLMTog7a8SyDaZz5UtkNRgV+j-OtkTjq2w@mail.gmail.com>
Subject: Re: [PATCH 6.13 000/443] 6.13.3-rc2 review
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

On Fri, Feb 14, 2025 at 10:59=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.13.3 release.
> There are 443 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 16 Feb 2025 13:37:13 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.13.3-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.13.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.13.3-rc2 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.13.3-rc2rv-gac5999a6c007
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.2.1 20250207, GNU ld (GNU
Binutils) 2.44) #1 SMP PREEMPT_DYNAMIC Sat Feb 15 07:57:54 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
