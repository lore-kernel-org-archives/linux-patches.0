Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0AF1990D6
	for <patches@lists.linux.dev>; Tue, 13 Aug 2024 11:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723547529; cv=none; b=no8YWblSgaFTMEysC1DjlJfmcEMR+YGt2KcEVyB9dyEZFfj4JPBOa682nSnuGu/ihEooeSIsXVh30C23tHAmAnRhVbktpgPVLLqvef2WN1kZS/lOJdai1ub1dt2I6fe9f+sXblMioHlPXzviS6SI0dTS2vayxRICbBww5scaBgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723547529; c=relaxed/simple;
	bh=sb+XtHUDQtmCMGrfwTt5ykYomI6fe6U6GobYI4zQheA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L46YN8C9wvYht5Gihz0ewUNA1DSrb3qd/W+pgqLJuQEMl9abnx7xr6bRxvxl70nRTQsP7TTWO9fpPkH2W7U2RWeor9T1TIY0yr4XkowruG+tXGXGdJMmUs5Lc6PpiyiA7Y1Pk+29DJzt2pEXFnHMVTaM8G4kq5Ew0SlJOGlmWvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=Vswl1dX2; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="Vswl1dX2"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-6c5bcb8e8edso3812596a12.2
        for <patches@lists.linux.dev>; Tue, 13 Aug 2024 04:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1723547527; x=1724152327; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bXWH3cj6qeEDUbAOW6N1y6hA61YbTTG0cc3E6ZuOHeQ=;
        b=Vswl1dX2uuIkaru4lzV6mWi4Z0TMZuZggm9Ei/N7l9mfmeVwPYQ+WMfGxGXIxFG7/8
         PeYrNp265ICG7O0Spwx+kfzkt8vaX2laX1NbmKCXcwNRQENHZ3DAol/91FsJEsohzuAs
         K2rvYtNvHLVSAM4GHH1IDSCNcNKTtIjfyWMR/7q6jqFBZSPzq2ru8gST5b8ka+mUcAGj
         zWIBAEk6kRz7kIB48Boe8ksxoCvPpbvT2C83eET3F6nu40foHF/8P3NDel5FYBzUHdPp
         OuZoXUVIqlGXVk08jDBWUpd1PAZjZ3KaNjMMUuNrssDZUlOi7M3ZWk11x90ugG+qdZKm
         ATWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723547527; x=1724152327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bXWH3cj6qeEDUbAOW6N1y6hA61YbTTG0cc3E6ZuOHeQ=;
        b=Ud0sLIbzy39SKa0ZgzRdMTFryW8kMW6E3gBUXFs4oBO6GMDFHbvewdw6XNUsF6/KM5
         lFvVgkbzp5BKawWo1TN796DDDPC9FInsS6hec6YegtwG7kM3h4sDLmLjXeivLU+AFD97
         18VdIlspr01aXFghDjvXFKGxSWAD2qUqghZDddsRcD6fMOWm410f7g8FXXqIZPwf50Rv
         fJsD5mmTDNrXjJI8wo4LnUvY2ImNdsFJl/pEwIv9xiYHLyc0c2C/4nqPxrWWHGm+o9aS
         jg/IJ4W+z85geyw+QnNeAHRKs5EGPmM1HCVeZq9+vGjZEakO08GRTtDEziCv7Zqf3m+K
         Y1dw==
X-Forwarded-Encrypted: i=1; AJvYcCW2zj5NS6UlV7div73CGLgOmPLyrIR2KWQ7Al3W2CqV1kp392QM4DOJxN0nkQRXwSETp3S8+NKKteky+kC7De6kaz58b/WAPw==
X-Gm-Message-State: AOJu0YzULqqo9xayC4nnFV6HxvUVJVBzezNn/4c4p6uYoCpe/bY+lp3f
	cOE4vazuaywFKZtc3UG3X8DOyq9e5ilLzE2DP/kSqTzmLpMmLpwBP8tns/QiJU5o7AeuSrylV/Q
	jQYc6/JWfiSx410s7GQTrWl8JF7BV2uEB8SCO8w==
X-Google-Smtp-Source: AGHT+IGuSeHG7m5K/jmSW20RDVS0llLgYzyxC9ou/X+cYTWu/3utdqzZoNS752omYejEHO3eijXxIXiNFbcWZM3Y5l8=
X-Received: by 2002:a17:90a:5c84:b0:2cf:eaec:d756 with SMTP id
 98e67ed59e1d1-2d3925048e2mr3647563a91.12.1723547526952; Tue, 13 Aug 2024
 04:12:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240812160132.135168257@linuxfoundation.org>
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 13 Aug 2024 20:11:56 +0900
Message-ID: <CAKL4bV6-OVxsOQPQYHetJZ7C7=oxBK5eHnOG-+HhTgDu608zPg@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/189] 6.6.46-rc1 review
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

On Tue, Aug 13, 2024 at 1:14=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.46 release.
> There are 189 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 Aug 2024 16:00:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.46-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.6.46-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.46-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.2.1 20240805, GNU ld (GNU
Binutils) 2.43.0) #1 SMP PREEMPT_DYNAMIC Tue Aug 13 18:50:55 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
