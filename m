Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE46158A09
	for <patches@lists.linux.dev>; Wed, 24 Jul 2024 12:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721823922; cv=none; b=Vao+U5dCF46X2hHauZ8BjJs7+zO3fP6RyNO0CU9Aud7e4bd4ZSRke+AXFgRXKoghiiyihq9F4dRDITjDikJcCPa1nS2RjtGTV3iwwOq5l6kx6fq6rg6ptYvVmtO+onjzQWE9itvzXDHYrBQngx9+dqYlAw6X3H33CAXCi5JWekw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721823922; c=relaxed/simple;
	bh=m+AY9XXCbeFV3aqKY9wXH1NrnIVbO8URw+wWbywIXT0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MuUbgitiKl6uh1+D1vCkyH2UccdU34txVe3Nn76FztYrSZxcyRjpzxjY5Wf7IFKkCamuW/KpZqcPmkFnwWEPYeh8pRVJODd+ToH4YWYvnFsvYOU5IA6u34GoqfiKhVn7yiW6ikvAIxZPO+vHBlOFjjUoU4/XkwMuk3cNZMaiTUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=wy2j+SAm; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="wy2j+SAm"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-71871d5e087so1317727a12.1
        for <patches@lists.linux.dev>; Wed, 24 Jul 2024 05:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1721823921; x=1722428721; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rR1NOFGImD8V01Eylz118awkhJ4FlI17uyTTajCNlVU=;
        b=wy2j+SAmNhrux9HpK/n1769SUfurZyeAI17bxha21JQJeJx0fHhl0Y6OMpvGjbeTCB
         4xOAWTCN+ExEe+hp22wl2ZDBp5snUBqJJuiuUYlEp+sej4gTU/0Fi+AAjhrbsQ9fcnEC
         GiudD2ty9lhYDVvzEy+/5jmSEL9snw0KcB4QCPlRPi2JLNLVMfUj/PKipksVI/cJ8LCe
         OqOk5KtRQe1xKO6iHXZZjQFY31ciGmaVS4LDg7+1+fEENq1ip6veetlzbW29wm3LSnBs
         c8owTl6xEfOU3v072Tte+iXfNa0tb3vqfOLfTMw83sBvSAtKixe5DMN0PkW8QRvLGIiL
         k71Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721823921; x=1722428721;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rR1NOFGImD8V01Eylz118awkhJ4FlI17uyTTajCNlVU=;
        b=jQ0Q8j7mLuj/DWPkThxCbJ8tOJgPKXmAzXGBS9chP8dqHvkdT9w5EsPGesRHpBdrbd
         w8DaRtohY87u17ZowMy139HD11TF7ERbxn17u9R3543KYrh3aKpjzu2yQJXIaptwCPxw
         JcQnTE+DKzcLL8MU4HL71T/LX2xoPV1Fufaj2+EGDIawqo3TOWdVd1852KQfc2KCagVN
         qic/g6yMSuYTxsaVKMvpFgpfzywoCZKF9Pk1IaP6Gax9BAo+cj6lXAPWiz5JrRdsjiew
         yrqg4+vKWy8nvp1nx4zHPVhygDOCrOHlepR89Jex4uCoOSuo/Za5UP/A/iLm67/zndpx
         Aa+g==
X-Forwarded-Encrypted: i=1; AJvYcCW0jS9QcTddG7cCZECJ0I3ijHRXRwmOM5OrgXaR88lYltwGNFIjxW8ddV7wrie28YWHWAtERT9c1T2e+W7UZwKPnGictFETeQ==
X-Gm-Message-State: AOJu0YxCZqpmQhYb4XRyrfck/6ZSfCu1QptJ8PXSn8+6gxjI4Rv1Lfh7
	d9Gda38fA70rP1Vatmsd/kpGTAaUaTLgI0Yy/xBARcvPmSXI43GIP3LOmjLmYBGhb/FMNpcw3E+
	KBcrDKdpOgqaJF8zBTt8BS0TUJNRJowNk+VQSaA==
X-Google-Smtp-Source: AGHT+IFNrhLEu6zYUQrWi8eM5KK85j2ewBswZa1CUWGuWeU1O+O24u56JMEDx1yShrt3gYrIIBoDz527FwfqqAbpOIo=
X-Received: by 2002:a05:6a21:328f:b0:1c0:e54b:5651 with SMTP id
 adf61e73a8af0-1c461963cefmr2258455637.24.1721823920681; Wed, 24 Jul 2024
 05:25:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240723180404.759900207@linuxfoundation.org>
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 24 Jul 2024 21:25:09 +0900
Message-ID: <CAKL4bV4Y=P1zn19bKnxDzF=brsZP_YscAUOWPopbsi0zeLHTsg@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/129] 6.6.42-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Wed, Jul 24, 2024 at 3:32=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.42 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 25 Jul 2024 18:03:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.42-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.6.42-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.42-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.1.1 20240720, GNU ld (GNU
Binutils) 2.42.0) #1 SMP PREEMPT_DYNAMIC Wed Jul 24 20:33:24 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
