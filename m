Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36CE6EBE
	for <patches@lists.linux.dev>; Sat,  8 Feb 2025 00:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738975602; cv=none; b=uT9/AKVLaPYqbWjY9SqVuTT21lW5ptvlTZgeimvdWs1wG5RfzW1E0Tqhs5QAJ6iNOYsIvLem32psIuVSLUzdUbwRw5OAxEJQc185WpAEEHfkRaLcUqcFYYHPIvAEuvMy+lYc49q8mQzW94buw8X3PRVPu8LyFx7GPH8gd50/B/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738975602; c=relaxed/simple;
	bh=U/iM/vgIBzMXSjVgFVisrL8eEI/4m5uzt1ogA3r6Dv0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hd9w/1bMaDGH1VjphMNVxhmldPheuKCJFuPOSfPoQDNQK44vTn3W7nlDwW66RwSqZBpcxi+8snCybOVlFcItV6RZX3RbzWQF5j0ljX9jLucekRHMDS0oUQcxe1KZ93I3Pkh7qMKV7DjSgxURw8txLcGrWBslQ8MVAczrAYePIik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=s7UHNJmv; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="s7UHNJmv"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2fa44590eebso424299a91.3
        for <patches@lists.linux.dev>; Fri, 07 Feb 2025 16:46:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1738975600; x=1739580400; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pFPCDRWfiwY548OE9KMzZcnx5u4rg+rWVCQ/qhPvDMI=;
        b=s7UHNJmvK9VGg+KfsDKN+x+kNeviMQ2OrtezlZC5KQGtAupNja6Etq2E4R3bpARv99
         KlaTsYbIawzvx1rkqMLUH1HAA7Kf4pZCxe9KlxIIe1fnRzRFDnnGW0tOxD0kQZSPiCPp
         ZbgtnXG2Y8zdIkRaZ07RyeEAJ4Lp94LtFujqTuvJBj67c+o7qYlX9BtWwffSaFi2tnwR
         F+sYdS0EgEnLhkqhrbuSsi6umaPDS77Hx/fU4QpEm3eS4myuMV7WBQbo3nP3CbpgR8Qf
         XJwdllxXBoKSW8s5SXab8pYiN/2ilJUgYGesen0XXI36+KUgrGlZwiSyInzxMCE70CtM
         6qvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738975600; x=1739580400;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pFPCDRWfiwY548OE9KMzZcnx5u4rg+rWVCQ/qhPvDMI=;
        b=Bvcn/vsaI+OkFhyEvJOczWj1AhTE041sNYOC+2Nd52k8BoWJ+0R+sQBTjJ6QfUUZ1R
         h1N0rscbbPu0HhYWdRyBadNn5dFO2Q+CfA63PaOCm9S+qWktihrRuLw3dV+lmz4PMkHJ
         enaJMJn/YXN+4pkaY+wYGSEd3gNgihi3fHmZm4nWYiyVDfli9exo2U8VHh0O/gSNMs7i
         yU4BNQVt3wyimsPk0JxaX38FZN7JHbQ6LFWFyffF7sEdCyZQU6/qr3/0AQ88NJOzdQFi
         xq79HRT9wBZO2r/0//tr7a+ySGXCy04o3j2QYOqb/EW7d6fVpBIPr5PqI6Uj9mfX2ZWE
         cDjg==
X-Forwarded-Encrypted: i=1; AJvYcCVKP4UQ+cDTFaxnbXXLt2VylmYvRcO+dpDpLTbK8/MDyqHOp1hUXYADmxqaXgO3ozjIRoXBqv/i@lists.linux.dev
X-Gm-Message-State: AOJu0YzLbHyvm50IWyXrrO3W79U9prYNnJZ5uDNqcrjUaHDubhfRNxox
	Tn+rY2/r7LO4ldy89z4fSf3zh8FroF2yfG4JfOsd16fb9+ZikNP0Q20jnfUngmUqtu/N14E8XFt
	SooulofsPD3ONZFRe6L5LvyaWOjqsQRS+c9qvoA==
X-Gm-Gg: ASbGncs7739UV0PevNf4Dy3sFnGWx9dYpIOXUyBTLfIBmXD0C+XwC1r5gtGZ5YH/4Kv
	voOY0zx7jBFvT+oMTCxp45axo5RPJ7coHA9xGJv5WcpgeiTlgNfK7NzgRkIUH4rv6Tek5Dw==
X-Google-Smtp-Source: AGHT+IHyBjiDGf7wVgGsBkQDcCSh2TnPY3jPly9PKqaRjONHXxOEA+eane4+FYFN84Y/5Lfu3fPhuquGmIGMz0S+vWE=
X-Received: by 2002:a17:90b:3c81:b0:2ee:9e06:7db0 with SMTP id
 98e67ed59e1d1-2fa240641ddmr7792502a91.11.1738975600350; Fri, 07 Feb 2025
 16:46:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250206160718.019272260@linuxfoundation.org>
In-Reply-To: <20250206160718.019272260@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Sat, 8 Feb 2025 09:46:29 +0900
X-Gm-Features: AWEUYZm2SmSRtoIkVsU74yZBb6bTd0d29OHynz4X7U95eHdh1KsMA5_M1BW02hM
Message-ID: <CAKL4bV7a5r0JL-RixXNyDmywvfyPWrsyL0QuNudxzfBcqOo7Tg@mail.gmail.com>
Subject: Re: [PATCH 6.13 000/619] 6.13.2-rc2 review
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

On Fri, Feb 7, 2025 at 1:11=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.13.2 release.
> There are 619 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 08 Feb 2025 16:05:17 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.13.2-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.13.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.13.2-rc2 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.13.2-rc2rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.2.1 20250128, GNU ld (GNU
Binutils) 2.43.1) #1 SMP PREEMPT_DYNAMIC Sat Feb  8 09:14:31 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
