Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E2A1DFDB8
	for <patches@lists.linux.dev>; Thu,  7 Nov 2024 12:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730982648; cv=none; b=kj0isx+QV4UzRfCHXkNCoYJShGSVz3ICXp/mdJ1Xw1Nxlrq8hP2czE3ZtrEJ1DdROodBjyEfab112SYCjStlOdi2Ms8n8qr6ivES83C5SCyGaqjJPJDm9j2tfTF2fWnE+SbJz2107PYcMbhDoismKX8dN2HKl9B/UxSh3kxXcN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730982648; c=relaxed/simple;
	bh=Fdpm4FLE82MD1XDbrFQIihI7Gfg+HRHDdnITsdrbq74=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HbMVzztZssYcLML8ISREuDByjXqvgEjp0bXrUi++bqBp9eHmoLJoJRMMnaY7tXNQQD3xbryJV9znUvXYkrGhGYBPkU5tbLCC3XssMNefeUzWHeEA5lvKW+3t9yBLZxjshAx3fsKNg07+3/RwPIDG9mTVnlUpg1y2vn3tU+k21ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=FDurr09u; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="FDurr09u"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2e2e88cb0bbso676088a91.3
        for <patches@lists.linux.dev>; Thu, 07 Nov 2024 04:30:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1730982646; x=1731587446; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HguBX7zMS72hjPxZuVUTMy+OmRB6kPtYztXecte9GL0=;
        b=FDurr09uKAiswU8yulwqQXR4AWQVl6W2FY/F6u43HL2PaI54awweZlMY360SmODX2K
         x7KWn+74gNWw3eJnVq5uELrwi+AW44FmwIe6ENGJGRbkloKosVhcAU5TsXEMEp0VA0oa
         ZVXkkIPvEzsAPIz8gx422Thtrif22gq1eVj1/PXZBj837C+t3d1y3IwYkvOG89Ci1A39
         hhdRLGJbLuUunt+O3Q3CNGyQucXjjsjjijYZKj2yHQAfxPdGrxU94lSj4VotMDTbUxTi
         o6XQk+03H1cmqwf5dLXBIl5IKD7FlaaagyMjxiX+L46rfaxssI4ZaUxEcPwo+wJiEBSC
         +6JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730982646; x=1731587446;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HguBX7zMS72hjPxZuVUTMy+OmRB6kPtYztXecte9GL0=;
        b=MxAzV72VHQlSHR98DXAAoMx+ez3Bm8TsXKqHzmAOHmpHnN6LdD4z2Pm2sT1k51UKWs
         E36G96QDPT8WrjLVgPSnyLqXrbJYStNqC+jJB1Ns9TwluVVoY233wfA05es0OsFAhOaI
         EjKkUqnTCI8vLA02/4FoQVKyHYE/pjqn+m+FYjFGGRjrk1hjPmLL88d9iYNX/UmkAh5J
         GdfhrbioLrf7tMn5tLxsWH8aPBgiswf6ro/c93P5rvc9cwVJJponmZVJ7+/krj+zT9QM
         d6O+neScK6pcRABw9Fu51687Tk/je9DW3FG0X7bF5dkQoHSauNxHCg5OPWflQmIIGcBW
         hScA==
X-Forwarded-Encrypted: i=1; AJvYcCXcz1ASbqs2UWiCAtjs0wJ3tdJdtPtAMhtZiBAupKAUkqu3ZsrsvhtxQ7uVpwTKAQRno+Y4Njky@lists.linux.dev
X-Gm-Message-State: AOJu0YyZUeKiDDujGKkxMVU2UQ6wOelXBQs+14dBBkvKjSfVlCvLzNsC
	oIyFLYcO6tGAJ/LOJ5Ka9vqH9LM39pmASUEJkJ5zzOgHH5TP4xgrpUqeth/9GIGaTBztZK2CK+o
	T0PbjNBnrAyUjPa2CQdHFOk6VfDyAoe+TBxzoug==
X-Google-Smtp-Source: AGHT+IFuYCrgtftLSJSRbDtHKLCIhR89jTMV22jQXYNjvu3k10LIWdr4KCxiqdPjI/FxckDfOt8KKDQPO8snlswhv7I=
X-Received: by 2002:a17:90a:6341:b0:2e2:8f4b:b4b2 with SMTP id
 98e67ed59e1d1-2e8f11b9f74mr45004766a91.27.1730982646361; Thu, 07 Nov 2024
 04:30:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241106120308.841299741@linuxfoundation.org>
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Thu, 7 Nov 2024 21:30:35 +0900
Message-ID: <CAKL4bV5NcjMRzVmLDr6-_z3hxy_pBTJCmdQ_URbPKAuVmkMQfw@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/151] 6.6.60-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hagar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Wed, Nov 6, 2024 at 10:01=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.60 release.
> There are 151 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 08 Nov 2024 12:02:47 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.60-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.6.60-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.60-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.2.1 20240910, GNU ld (GNU
Binutils) 2.43.0) #1 SMP PREEMPT_DYNAMIC Thu Nov  7 20:39:12 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
