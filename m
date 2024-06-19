Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 198C3249ED
	for <patches@lists.linux.dev>; Wed, 19 Jun 2024 21:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718831513; cv=none; b=f6GqxoLSB7X6yMLm+b/ZXEYf+1c+EmVhMGiJPp8GB2Csf8mNpXoOYhwefCKTb91gkW/MgvzKj5iD6Ivs6dVTpix7V/fRlQQ92dLZaps/Wq3B1xuuAOn8cMqbWGG23K1d3Tv0lG0dEarsW9r1uu54jdcpts869CCgWNeo0ooxE8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718831513; c=relaxed/simple;
	bh=JonIJaq3OZKtX2IdWUeB2L72zt1Pa52H9/4Dlgj3xoM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ds0taG/KehMFARMVBlAIdUfmHSHRBXqaYDiazu53o7tNd0TGCriu9gpp6hoZ8iQthZb7F31UkVcqNFYxmSosaN5o9Y8fbUMzlRbjzOQ53GXvNyl0ECYRJlrDNpEUaUwsSD/pBRS9mBrevJ11gvz31931Xcs/Qso8/2OPkf7g6/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fWHG4Xqk; arc=none smtp.client-ip=209.85.221.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fWHG4Xqk"
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-4ed083c2874so53912e0c.2
        for <patches@lists.linux.dev>; Wed, 19 Jun 2024 14:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718831511; x=1719436311; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=G1Wf/koZbFW9IPk/YrluCkWzg9WkxM+rq1aaZRjZ11M=;
        b=fWHG4Xqknc0x4TUhN4+MWaFcTJLAWO2vthEsxRws5gJk78h68c+TNzGS8t2yBugrAn
         b8jG5GVfbtUL2+SKQ1dRqKPkybNcoS502FppduoSjUyKUeYxLOzJR7h3JCLBU9tj9cqY
         aqIRJWMmvj/TsWoNngTI6WaAuwHeMfCxEkT367CiG7CjF/4Qwv1+Y8b0PQSI6y56yTE2
         TYhKITX0bTIS2o5443ke7+EfjV7kJWN6G7QzOE/lqpnNvK0i8QhCq0ntrbbsNncs2TAe
         HV2+FNrx0VJOrgWa8E9x3tOCX/hbSkfBDAxvlFdCQuSAbSoVGPxcAa0QMpzJE51PSWJJ
         WfUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718831511; x=1719436311;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G1Wf/koZbFW9IPk/YrluCkWzg9WkxM+rq1aaZRjZ11M=;
        b=bTtRVmfcly688JFWIoAoIB/Q74ASZkfmBOtX8au0dHqv7wcWiIeTOqK96A45OsczLr
         xsI7anKsuupCCrtnQishlarHBaKQ+mzcf2Lx26FNWcgPhdIC3vg+i2Rk+yifCgJYfPf8
         B+gg5WeR0Y5oi29TGRhz2qaZWIkyyHYJQl4jerFvhNj3NnVgdq7wX1zO01ZrH9AqDjCF
         JvMTklqqYfMsB61GCOeQc77oh4ui4UoIDm00boadb7nWPfLigZPJdvXPwyhavw2L9KnV
         2487hgdYUPm/v39Pk/V4vdDW6E0bywFxVZYGxFBuUYPwnf2zDbg6saEOC/Fa4Esm+Wb2
         lzMQ==
X-Forwarded-Encrypted: i=1; AJvYcCWkwqfs11kyRBP6Pn3DThofzEqVhLZ1y6Pdm76WrIQgLUEpBNV4TtVQTQqGF1zGtZLULTls62lvZ46Acnd/1yu2lmCzGxg+ow==
X-Gm-Message-State: AOJu0Yx6dGG27Db+otTwMrj9lleQu68iZ+4BmO1B5o4y3/CPy7BOmQUA
	UWxSe+oKKGhnHpV2v45tFXVr+FcyagSgmu3ohvcrmXWfoxTSGizDq44rfor11Zm2FDEFv5xzdg8
	dMZs3arxdGX/yuUGIgdu7hPL0A74=
X-Google-Smtp-Source: AGHT+IGjyujEK+bHyLZHGQKjMkIjxvDNm29uWhTBhACl6IcDhQiGcoLcjOlh9JO/lLGeoXMwIZaOtHEreRocNL6N4n8=
X-Received: by 2002:a05:6122:920:b0:4e4:e90f:6749 with SMTP id
 71dfb90a1353d-4ef277dd297mr4205321e0c.10.1718831510898; Wed, 19 Jun 2024
 14:11:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240619125606.345939659@linuxfoundation.org>
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Wed, 19 Jun 2024 14:11:30 -0700
Message-ID: <CAOMdWSKYu2f5Pz_CNVktWQonknPOOskdp9Jxj+xBJgp_JdsdnQ@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/267] 6.6.35-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.6.35 release.
> There are 267 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 21 Jun 2024 12:55:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.35-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
