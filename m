Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB77233DED2
	for <patches@lists.linux.dev>; Wed, 22 Oct 2025 18:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761157406; cv=none; b=L34WxOyCUW+CXaKwPc8QfCjStygmO177C1xZCGwtSc9B7VIBS9zQsshpyn4rkeoNGNTV7tvfpewCZpCzznm2l8dqbbn/IA+aAjykz3CMY5W+Nr6rrz6r4cpXQ/drUZwCuSW83MVXDyYll6IeLoQw7Jr9fii1/9N31Bud0R3/8Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761157406; c=relaxed/simple;
	bh=D/N87KwxV+Z68IbXXzogjntbGGIivtw3E0aCgzNmrh4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kB6eveDYEWzkevIVlUXPFRB+E+kJR2CukV2bbvmDEW4jvp40RkuiqXDFTN1ce1Pn7VDgo3Yvt96U2QwxbH0l4WhP/FqhZ/XHCiKm/gc9VjrJa692jfatCy5LxkKpq0PsAMKiJB9NDfrlfQLx0Xn3DA2z9kU2WO+vra0UMr/L1E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fdWeH8mT; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fdWeH8mT"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-59054fc6a45so8296427e87.3
        for <patches@lists.linux.dev>; Wed, 22 Oct 2025 11:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761157403; x=1761762203; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z3Ba3B15sVVtpDRMi97H+sxsvfjd9I6QEv7fyC8Xwxw=;
        b=fdWeH8mTayRk8UGbG9hfWxS3P3nDlRfDo9Yuwi+f2HWfOw0qsYMR0MUig4u/xe8wcu
         Si5Yw4PR75/5WCrMB/h/zA9Fg74NlMIxj0G0BnyXSNqHfe3B2No2QLaFtiaENavgsGxv
         RO4cAtTrYN+NpP/aPnGPr7t7xkomPUnsoKLJQtlgwAeMNltJrL9L7q+4A2WnV2w+urBY
         dBI9VdZwMyXbw1aMp+umBpa3+VaLTcqWoSvxzmbfP61o6wbyC3U1Zl+Hp9LNXmEzGPwp
         SkAKYN2O01kNayM0+zureg60qkNrUmFNGpbelvRB/13C9WBaNK42hW2+YEvJmlO4atMh
         f8uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761157403; x=1761762203;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z3Ba3B15sVVtpDRMi97H+sxsvfjd9I6QEv7fyC8Xwxw=;
        b=m+y746vt9oFTzsIMN94uuo2TdnURBBTVrJE6piDd82g4/xOY/jUNulpN4QQ6Tq0362
         LAcI4Y7Tq0gnLDABnHwKHvPbe/4y2ZGepy0iIafbBsSlJon2CcWDXRMDJQeF9ZfHAzag
         /I99T9vxbL+uNQEGiH7mIWxUZ9IV6xFTrhNIT5oPkRz2IvmsbgoHr9R1nAUdtv7GVUxb
         HehOxDC6CLtzLT2sF811n/7DG5pATieF2JFIVW5kGOa+wGDSXKrilvRCP+uPytZUep6G
         wNiJKV9ciYmKj2xT2vEfRp3fCYDGdmaOTWTU8e0bS/aftHpD0rWxqZRLRdWw3vTkr2S9
         R+uQ==
X-Forwarded-Encrypted: i=1; AJvYcCUp5FQNbJiJSb3sakzkPvaqBkkm3K2Ngmup2rUZA5KrdcLFAtaGeSoggMaLbStkiVbVPQzdOaXA@lists.linux.dev
X-Gm-Message-State: AOJu0YzwyPFZe3JQxD9JLQ9mbr7xOM6YpkeNe2AqZxT4ZAW4ecVwHKFN
	uQTPhOssd3Bm958IV7DullFEFNnWZK1zuHIgSkEh9rtvTQjJGX4oaQJauYNC+hs2V9Q2A3GEUzZ
	pzi81KoqcLQ4D9/fT2xMrav8Usfo4hzY=
X-Gm-Gg: ASbGncv1RncgpOMzu3ZZY5RutGOOADxJQt4OxmBUq0TBNhqBhVax5I4nOYvmk4P7j9k
	yiO3g5Nq3wLG8tV9+OPqj5qbgtEvlqN9olcnedHI9DeOqUoRr8YRMfVZJ02eG9z3oGpwY+dZ4be
	Fx+WOJCaE/AEATMOpxnX0W41NsaF6wQdgA3jzOzhwkB+Mn9b0jPIBTjzFet5njnrgF1+/e4mcH9
	m8wtnJLkzts3gVS+4QXDKUisjDCOFCCOmn20D3ojnxagZY26nIi6M7xNeSPJd7WRrja1ZKRzVnW
	CSZvB/JvwTt44TkhBA==
X-Google-Smtp-Source: AGHT+IFe5sIAVTfqOs2vfE2J8nxHXTDuWTZ/Gh2yprS/NSIsXhVORISS9EYSyEXk1cLCfTI14WyTvgWzGLNy9u/kyuE=
X-Received: by 2002:a05:6512:3ca9:b0:578:75b3:4326 with SMTP id
 2adb3069b0e04-591d85898camr6876561e87.29.1761157402448; Wed, 22 Oct 2025
 11:23:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251022053328.623411246@linuxfoundation.org>
In-Reply-To: <20251022053328.623411246@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Wed, 22 Oct 2025 23:53:09 +0530
X-Gm-Features: AWmQ_bkB1VnCzq_z3-s9Pg8J_-xBFqTPE9lCpcHmgjOViDGV_maAREzZjQVmEWU
Message-ID: <CAC-m1roB4_c_ThPxiEi9yzvFE2qZxuY_s2fQkUKqYvF72o+ODw@mail.gmail.com>
Subject: Re: [PATCH 6.17 000/160] 6.17.5-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hii Greg,

On Wed, Oct 22, 2025 at 11:04=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.17.5 release.
> There are 160 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 24 Oct 2025 05:33:10 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.17.5-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------

Build and boot tested 6.17.5-rc2 using qemu-x86_64. The kernel was
successfully built and booted in a virtualized environment without any
issues.

Build
kernel: 6.17.5-rc2
git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc=
.git
git commit: 3cc198d00990d2fccf1413a30fa9ecfa9a02d35d

Tested-by: Dileep Malepu <dileep.debian@gmail.com>

Best regards
Dileep Malepu.
