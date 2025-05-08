Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C08D199931
	for <patches@lists.linux.dev>; Thu,  8 May 2025 12:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746706353; cv=none; b=s6ZD6+8kDbcifxnwyINZYL07tDBla2H3tsFcKJ8xwk51zmY9oCtqZEqw+QBiMbsuVOwlPJX17NMP49a4xsQTDQL3G1GkHI9p29H2OAOPnSvO0hAM+r9j/ACl3rAIxrUc6cHG7/juFGGy3nnPGnTXiNDLUa5ibj4DbCG48TFEmLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746706353; c=relaxed/simple;
	bh=YTlEjrVaZMORPcdtqbke0C4y8V3UF0+iZCzRvxQRU+U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Br6jA9qtAnGfX1pdKvDkkHv9EoMSaeEx19Ti9jqaUyU8vXSbAxFpdOprEldENWSbvrsKsuk/iCD1/jw4JTfwPIem1pYx6YbEG86vNqCXQYCPqBxvjBoJR3x00K4iaJAkm6VUHPG9VpsaggdhfxF7k9z/PslH+tC1Jgkafz6CMcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=yjdXobk5; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="yjdXobk5"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-30aa8a259e0so873008a91.1
        for <patches@lists.linux.dev>; Thu, 08 May 2025 05:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1746706351; x=1747311151; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y0GnN2zLN+jwcqw/AYevnBc6HDx0sVBLUkFkXjcaYbg=;
        b=yjdXobk5kfx9wZV8gQYE7vYa4J1gPqbQOz8GHXalDUF5OnDDp6US8MGnsAnEy5Au1z
         Y5sAATZNw13yDSaKYjGn/zpO9CaVHuBk/68EBIK9+PGPfmPen81tb+2XhOXHHm5J7VPt
         2tnCp97uIu/cVAfYoQrZZFJKrXOcHhqim6otFubx9HmsJn11SD9ANPZzwT6nMcCeIbZJ
         7QyZEB+zzL+ZBVuhvB5wuD7dJMiaG4vQ8CMfeODJcJp4hpPmWlsUYfiZsG1xvvVKveqb
         MHhqog6kPHTlHyx2Q627N3cCSlYQJ1SyogHvW5zOYpq6KrSzobelsdUb2iOghn6YB6Dt
         1KPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746706351; x=1747311151;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y0GnN2zLN+jwcqw/AYevnBc6HDx0sVBLUkFkXjcaYbg=;
        b=CiYark0LR6oNwppvnZDUiAZZMevUOALjU/ij+Dwm/KSbGClTw0XZjYOu+woPM23FKi
         Hzt4bq0BFa10dEpMdtYvgU+ygZ5uad1IVXH5WF9HIHSaWK0Nwo0HNpko6fdLEKXnjXDw
         q3IhO335fo444QId0UveNUpTWGxJrdFShXwxvfQ+BcDIzupm5mCbcw7bXUUFYARjCEXd
         YEg9fG/BnquczaFUWWZ6x8+Qf7JcNkl8N0bJOkvs47lvt3NRVyDcWIOblQJGunKe2JkX
         /bO62w2SD8UkMGWRB7PMKniR4NSQKpatEjZvWZDhfW9QAlmmXXaM3LaZiDSc0L1UwnBU
         9IRA==
X-Forwarded-Encrypted: i=1; AJvYcCWtfdYg8l9sKn6ts/CoDRsKJ34vbZrkhJgeHqWtg+ZHlIwPkr2th11VqKr0joJgwY+Gm4mDkGZF@lists.linux.dev
X-Gm-Message-State: AOJu0YyvoxtZd9sRbKIg0QM79SV9QgxaMBi3JAi+3uDiWqs2cR27TeKw
	6uC/yY1RkcPXNcybmHdemGUybCX2imjJWfKLt9aQorKPPUxSnfsupybjVOFfVtcpCgjlj36XOpr
	22tMSLu2ikubz4YklxqHSkzrYCXPlC4+gTSCBog==
X-Gm-Gg: ASbGnct0ap82qL0pEcUsEyWvXvMhad94JaecS7Kl6WcrOnsIerftYiFFO//aSNyoBv3
	1qD5rS+L6xz2Tkfj17evANOlgmwHkUYOYVkuLGgz1IGJnrtCjFFxnVwTjIk/EmTR+KLF2k63kRD
	2vPGCSq5th4bZWJkdE7JxTvA==
X-Google-Smtp-Source: AGHT+IE5AaZc6k+qedv3ywSbWB9YaEJxg6FlsqvBzg4yPSs5n2Jeme8sRai66OYETNlq66zkPNs4uU3wMHLIl8bpXHo=
X-Received: by 2002:a17:90b:3e89:b0:30a:2196:e654 with SMTP id
 98e67ed59e1d1-30aac1b2907mr11342735a91.15.1746706350545; Thu, 08 May 2025
 05:12:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250507183824.682671926@linuxfoundation.org>
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Thu, 8 May 2025 21:12:14 +0900
X-Gm-Features: ATxdqUH2P6CaWRpb5gIEUbHMjZ59qZg07BG41t-BPBu0QIMK8pwNTdQkClHsJ_Q
Message-ID: <CAKL4bV76YR9PX1KYY3PF59yDqGRH8koppGbhU7YL1244wPc-jw@mail.gmail.com>
Subject: Re: [PATCH 6.14 000/183] 6.14.6-rc1 review
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

On Thu, May 8, 2025 at 3:50=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.14.6 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 09 May 2025 18:37:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.14.6-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.14.6-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.14.6-rc1rv-ga33747967783
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.1.1 20250425, GNU ld (GNU
Binutils) 2.44.0) #1 SMP PREEMPT_DYNAMIC Thu May  8 20:39:36 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
