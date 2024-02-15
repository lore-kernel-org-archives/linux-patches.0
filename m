Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8499A69DFE
	for <patches@lists.linux.dev>; Thu, 15 Feb 2024 11:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707997668; cv=none; b=sHwy9AZ+iuZZpPEtzj0BjezQa/idFsa/uTqd9PRNyCttxi2tQb0nslV98YN3Q8K0ChlDUTLVCrL7NVDYQ19YIIVAL2RqCSm+gQpR1LrmhWeGP5+a9PjxBPAzD9WINw0ia0lp/V3qqgEhCLWi/MMKdMcNuORcpTR3Jh3t/25KVIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707997668; c=relaxed/simple;
	bh=LN1fd7tD77fB42zqbauIV0Aa4K8khZa+u2KvtOVoSpw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r1QU6Hb9xC5KC8OnhcfGJVEaIWKQsTkNgcQYh1krRYgQsns/CwqQB2r4RJmr8Hwo3rH2lIxAR7K3WKfpbK61OhWzcmsM3G9rLpVqspuslO2AYhCzjIe33FhxRwj7TDaWWYvwwxyS2KqD5T7r/1N7rA+b2aUFFAXo7zdxBFnbiXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=Qj2eItOI; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="Qj2eItOI"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-337cc8e72f5so456190f8f.1
        for <patches@lists.linux.dev>; Thu, 15 Feb 2024 03:47:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1707997664; x=1708602464; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jDZkTUXyfxckUhrTkjTJWxTxMlTrhxiy3HMA9uLoreY=;
        b=Qj2eItOIZ8XUpQjPJ5YzzgcuP7ZeOF/cQBsEkK0hoH3l/p5XZndXEzMCJOyLUnF2Dz
         z/mJN68bfeTv9CLi+4oFXrPAnoJpjE0HRlsQ8johmLIPAvdSYt5IkiU09WYXMcGJ3sp+
         Tplg9TtN3fOo8XJFEWh0sl5bnG468kXDUauR8OqOjzF1MEYJuy36jmGmNjV2CPumFnSR
         5NHk/ryMuNtYWyEh/SzzzgojnsmvpOmSgVn/UVfVV9HP5z79QuKpi3CzXz7iJsr9wo+7
         qK3cPGzARSOHXiRqVAXRQwBkFRT76w7MyntiV2KTnk2MIZ+FYtMOvbm2QXTQ/S5qZ7Vr
         NHmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707997664; x=1708602464;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jDZkTUXyfxckUhrTkjTJWxTxMlTrhxiy3HMA9uLoreY=;
        b=BC/T5fapb2MBsTP53XshZTBpXIA7xVfklhYUJeEDOYI4Z5dkC4KqaZ0hK0igwehI5Q
         Es30u1bAh2W2ogehkyBaOrQR6KGn45i/nTeRjSWRMFUd9zooxvWTkJkYISJI2YRVXVqC
         NxN2/n5kJ7ox++EGgtk87IBskEOc9A+4Bm4Dzl2wBvyQ13QkY1/2AX1iqDKHoHLE7AkZ
         12nhPLV356/ssLLd+vcXgpVwUJXspP1I7K9/hsPDng9z3CeplC34Yc/caI7Y7oyPxmsl
         3P/kLnvnBlt6upFpl0TdiXcdP/yiKj1XcAHxZs2+R7/xpNFrl7sEnA8k7k4/O4Nl+M+9
         C4RA==
X-Forwarded-Encrypted: i=1; AJvYcCXUjg9oK05hmIZb5htfRKxu/ODdwwlqCwocFNan5CxuJmjM8ugY5JadunfE5yIKRluOxntNC9yRRFclvrooC3fM0040rNFFtA==
X-Gm-Message-State: AOJu0Yxm67sa4VIlZv9KTBEw3XrtXYyNjH/IAeVfvwWlcuaIcY64Yrax
	gSoJ8fZQq0z7/lUGnpEB2lM7waD6JA7NBKumv6Bf22k2o2A/V0oGWvBP+Qb7kOgruA0JoDI7IPY
	1VmEdcFtF2tzOG5YWIpZ22CEIu/Z4tNK6/q4HIg==
X-Google-Smtp-Source: AGHT+IEPa0xe746/mLrXSvxwPwOUcEJ2izyVagCxfrOZJvxe8P6kn5FD8DsuToN4BWhfhL8fRGnF9fn34vnFWVpVl0k=
X-Received: by 2002:a5d:66c2:0:b0:336:76de:c171 with SMTP id
 k2-20020a5d66c2000000b0033676dec171mr1213235wrw.62.1707997663921; Thu, 15 Feb
 2024 03:47:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240214142247.920076071@linuxfoundation.org>
In-Reply-To: <20240214142247.920076071@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Thu, 15 Feb 2024 20:47:32 +0900
Message-ID: <CAKL4bV6VJexFZwG4fHjZQ7eqSzUee3+VZH2baxvJqJqSneNj7w@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/124] 6.6.17-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Wed, Feb 14, 2024 at 11:30=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.17 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 16 Feb 2024 14:22:24 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.17-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.6.17-rc2 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.17-rc2rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 13.2.1 20230801, GNU ld (GNU
Binutils) 2.42.0) #1 SMP PREEMPT_DYNAMIC Thu Feb 15 19:52:35 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
