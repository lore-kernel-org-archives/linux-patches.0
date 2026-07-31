Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971A13E3C76
	for <patches@lists.linux.dev>; Fri, 31 Jul 2026 11:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785497019; cv=pass; b=hA6txRTsqD8R+rD8ranSxMvxp6mP3+dTB+I8p0kjzvFUgUEotGj4xZ8/RbgxB6fFZi/NpFq5W3OHDqBm8xHHnvJ27XnHoqVCyz9BVfd3lWz9KV5wzG0I4YT+eWiurwnR6691phE6Q/TgRg7LAljkWV7Eoq6OIejpzTWUaw6GZHo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785497019; c=relaxed/simple;
	bh=Tjxrngnbb1L6fKIjskcna7MeeUTYCRbwtPNR2IeZhks=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZYr+eYAd+0Y7dU8Q2A4MqmU4zXVTpY56O3WA0u9CrefRR2xEeGs7jwy554CYEtN/vnZeoCfWUdoz2yH/JBiyATvEfR3IQl27KXP7ZUU7hhOcx3jY1P52T4orll3lg93fS328PafQ4V6mzkKak2NCSf2Dy+Opd7AkYXiq09pQyTQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=DWu5SqZ2; arc=pass smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="DWu5SqZ2"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-69ea0595598so1040392a12.0
        for <patches@lists.linux.dev>; Fri, 31 Jul 2026 04:23:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785497016; cv=none;
        d=google.com; s=arc-20260327;
        b=d9UgZLOe6i7GeF0rOqH39l4zxb9CDOX6wADQ+tEBgszfMGAmja0Mn2rhkBjeWn3br9
         ICgnCLtmD1LqVl+IOGAekh5SPT8HrnoTD/ZsVhUNk/ExSxc5myJHb6SydHdC0L4OCu9o
         7dAzJqLe3p5i+QHe8zfY/dxj6lxufyUrueja3rK2NAp+8XUVRcy76UGxPdNSKNGd48lC
         kR3RbajPHJdBRwJuu6zZCvmHTozCPOCdFt+Rrl+RrVjc3K4zocRsUNiViPp3FpnyaKFG
         cgxDZFKLCNSPm5KuKLpxi2B9+pslCmqgW8Li5Dy1u38R7/s/m2WuDCB44F4z3s7lS6hk
         lJBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DCSOnPh7d3OM5NtLNdoViyd21RmfOfuFsm28QcChymw=;
        fh=YFD+/UkKPAw/og+wnDDyH/3gPfIbj4SQDuUgQgpPkas=;
        b=YevurjVu5yfAwqPZd3uwTyXK8NeywisxSEo6JoyYIH2eKddkSVpQRqX114rjqgs5jD
         xJptextLmopW4FIQs+HQ9qp/CR3KvUXkNbHwrgxF2afRQ50NPponyP7CoeV6yqgRMcHM
         QoBl3dYUGMg0rHB4KiOeGswmhvSuafzVYE/dvCgInGpi9iU0fTU+9wKgB1l7gWodAwye
         7pqenYm/pyn6Fag0Uez+SBXSx2DLM5Flrw2685n45637Oq0MtUYGqg4z9o4hGoR+QPvS
         DxTZH6JnyHoBOdPnFAsD/GPFKCoYVuOa/07npBOeTqY2yDaE53Csyr7EvFNX6EQnvoi4
         53YQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1785497016; x=1786101816; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DCSOnPh7d3OM5NtLNdoViyd21RmfOfuFsm28QcChymw=;
        b=DWu5SqZ29IImO6827R3hyQIzkR9IHnubmifOKtEFcLHPZfuX0mfUb5VL5ZCm7wkjcU
         A7J+TJHQ8gMl6iQajB47ZuEaVb3xNLHSzDhRkZBHqQKp0aWcazPJnLfGgfm1j8Meg/rk
         Ws+O+2pXtxmYmI3ojaxx1/e7axqWLM/ppPnHhVT+ryBPtQu4pOnViqGrkmMqPb4AEH4N
         uA98Kb7CkBfcAzV8r/7GGrCdkWUpU5XIK0b0jqaUG4ynzvKjVEFoRfBj7ZsHIB1P3+Qb
         5WJnMzRF/RNtsJDkIRAoEYjg1UtXBEWF4nxc3jhf/NtA0mxZfJLIl1dvhKlnHvSXItEh
         WKCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785497016; x=1786101816;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DCSOnPh7d3OM5NtLNdoViyd21RmfOfuFsm28QcChymw=;
        b=ipSVEJqQNDfO70tIzEXyv7tgKAx91c65hn/9BtpWGa9ssnlzNU+aWEeiTEvjym3/9w
         D6fsmnn1WsuxtBJgIzeCoSN5vR0KJpNFdPUXxqePd2P2fyuMdl3f4pYFtUulScL1dQJk
         2kIP5X2OmLBPhZiDLVF+oh2dwf0fpw11P9nPgZiau+D/5MVYMCTnaCXkd+ZWvq780VS9
         CBs2aQHn0MhaH5ars08HsLoJG/xG9M4xF5gIPfbqAsupSUMPPsXf3z6zoT4ZTPpYuG0y
         0bbTtA/whEukeq1+ddeRIU/h5+1fI8tGtjwGeuzEfobK7KVpYTMbDRp0IKwrF+5nUbFE
         /INQ==
X-Forwarded-Encrypted: i=1; AHgh+RrxJGRNNuQ2UocSC49WPjPJVfUQ/wdSD0WO4HydDgd9UWjQTFia5VvHW/JSeyvrF7HPGU7Ol1p0@lists.linux.dev
X-Gm-Message-State: AOJu0YzpqO1UqQDFnL36dX3sW1cc0JkkFaNaDODmwMfIopXARYzdlaTo
	HVkWf35RwcjpNO0EGsfcTZYRWXaVNSOzCOW6IpD2MYfm4Pn47H72IRXsRPK20mrZJQrZX1ybhcs
	pR3SRoTtvH6tHMSdDBSOX1jzy8+7wkap7uh/WYlLCbQ==
X-Gm-Gg: AR+sD10gMlugr9JhwYKizncoSXFuS9EmCr4lvgXYAkh7uSQv59nUFllHOGb+IIrC003
	ph2+Bft6+nPwFvQQESdO7wLNe48Ga0PrKTGyEQOTvsqbkj0mS8UJsWX4ViePQiScQENrGruaX6v
	GfqE45ncwR+HkOWqd54KiZ1GnoDuDEXINx5/vBm5THdM5JdawM6jPLNvMxWv/QW2sQUbAa0EMPt
	T7ljj5HrcdKB2LO8rhP5XG89mdGJBdHEEtqPjHjegrIUm/lzPf+ESRtCgnNSo3rGKOJhCfJvHRE
	BG3JrT5FWpdkiqcx52t0K4nbuj+uxRa/3/lLDhOIvzzG5g==
X-Received: by 2002:a17:907:ea8c:b0:c08:417e:3696 with SMTP id
 a640c23a62f3a-c1fd1ecd84dmr109074566b.20.1785497015732; Fri, 31 Jul 2026
 04:23:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260730141444.267951807@linuxfoundation.org>
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Fri, 31 Jul 2026 20:23:18 +0900
X-Gm-Features: AUfX_mw3hd-7UMBmhngr8a7ueuiKz8UX9MJTHvwheDI8VI-Iv31bFbQRyyRd-nI
Message-ID: <CAKL4bV5XWoE+AmOmgm-yCSLoDX8M+KzvbNgnDyNt5JKzH9mHbA@mail.gmail.com>
Subject: Re: [PATCH 7.1 000/744] 7.1.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Thu, Jul 30, 2026 at 11:43=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.1.6 release.
> There are 744 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 01 Aug 2026 14:13:38 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-=
7.1.6-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-7.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Linux version 7.1.6-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 7.1.6-rc1rv-gecc0c68d2044
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 16.1.1 20260728, GNU ld (GNU
Binutils) 2.47) #1 SMP PREEMPT_DYNAMIC Fri Jul 31 19:44:25 JST 2026

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
