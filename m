Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAC0D12E49
	for <patches@lists.linux.dev>; Sat,  3 Feb 2024 22:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707001118; cv=none; b=V26ofl+XSRfrL3AYEW3vFa+VJSutSsY3UaOs5NuBNR81h6+S6M3s5ewfZumMEedTNb+gHDMy3sSQVc9fXWJ++9kDSvDkbK9wy8RkXu+e9IHgBaIRcTYxRSEXHEwtJ1zsvY3bqSEtO2jzEGOpe18Cz0XELMwWj9RFfvTx18hCV+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707001118; c=relaxed/simple;
	bh=9XCEwNXOtd3gfH5JnXX1Mn8plFmt8A7TjyEul2rhlno=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aHGOLHc7aArD5LkCzCZYL9TtgQ6r4RA4kFsvu+QFNNiz/u79v1ZMC6h+nHusQFhd7kQJAe/jgowUCIZ2Fnw6NKFNeovpJFlZLLYVQDxVgN7VGssd9o8Y8JzVQ6322SHLNIsa9X4rF9hD7C48OXVsXf0Wx3v3ZkbX8GemTaLBnhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=WoUQukge; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="WoUQukge"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-290b37bb7deso2673911a91.0
        for <patches@lists.linux.dev>; Sat, 03 Feb 2024 14:58:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1707001116; x=1707605916; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nzRLggOhgGcyJP2PFv5GAw1K1ynDOSTnUjo1ML5xufE=;
        b=WoUQukgeRgZpmMyLFDtfuAJyU+Z5eIVdurTUZQ2yd+le9YzYI5HDt8UQWGQnsRmvJA
         Bx2070ZJLwDRp+/C9Vbvj9K6sglwEYr9JztzgYcEuPN3Mk4xnQLSqqceBgoTAqmBSzyt
         q0uRtQgjqb+WsL7bwpV5sYin+sx/aRKuz5L8pqi8QrVIehuk0Un6rVdS2+vwJkmJntUy
         VQ2d+yEfMH0DcUal1I6GYYyVE0QNcDVHJiT1HMzlba45JCdB9XLOLXrQwx09Lw0965+M
         iel8YOUucvD2ObjOEg9zP1tu6zFNAnQoRiYCrmbevkvqbtuygfaTt8q4qQpkcagzRyF+
         tFag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707001116; x=1707605916;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nzRLggOhgGcyJP2PFv5GAw1K1ynDOSTnUjo1ML5xufE=;
        b=f29pgVbH5UiXSeIubp/pxoqNIM/JVB6ahYDDei88Av2ecjqJHYlzKT+9PBwCW3sp9b
         ac93KMIeVZhgFsfDYS/CmFK/1JNFpZyQd5Tr8BG1CB7oZSQaHpHLldjGWPOVtZafWSGR
         DCgiGXD0lnKO/CDnmG0KbSnNxa+f2szw0Jv+2E+ZYpqHo9ftkkzv8XrGf230OMo9iuzB
         2hEN9bvQlxczVcZEEyaytHoCcKWf7YhDoYMsNobCi+nQZo/RXrJSZpKpp20whCxOCLQZ
         reaSP7l14s0E6u/S1T44LMjM387zRq5aDMNIefbPZqDTLfYR6BqYCx1usvLzddLYbnDW
         Lv8w==
X-Gm-Message-State: AOJu0YyTVbgrnreRjv/2RcENhWxHRpS/bvCTvId/uOEI0DVFmJVOMr2F
	XpN6FrKEcwJg5iqHZv7aDGNz+OIpMYK745zX4Gj019y7XxiNUOAF4p4VNPzSaBhrx/7uJdCMh//
	0qRzZQ9GFCkbfc/Ll42ulNzksetxsfSXLu0Hlwg==
X-Google-Smtp-Source: AGHT+IHWWixaZzUEfvpK6e39qOuHLzQpqN8E7hRV7h68UZHwCnqjdYRWOopQDCpbqGA2fe+IlNtUWZ8LSX2Bstq1xmc=
X-Received: by 2002:a17:90a:eb0f:b0:296:6eeb:ca2b with SMTP id
 j15-20020a17090aeb0f00b002966eebca2bmr1543366pjz.26.1707001116163; Sat, 03
 Feb 2024 14:58:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240203174810.768708706@linuxfoundation.org>
In-Reply-To: <20240203174810.768708706@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Sun, 4 Feb 2024 07:58:25 +0900
Message-ID: <CAKL4bV7e9d6Q7KXpWMrvRvMfD0EkthH4NKSg-LtrvgpWm5yvuw@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/326] 6.6.16-rc2 review
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

On Sun, Feb 4, 2024 at 2:53=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.16 release.
> There are 326 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 05 Feb 2024 17:47:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.16-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.6.16-rc2 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.16-rc2rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 13.2.1 20230801, GNU ld (GNU
Binutils) 2.42.0) #1 SMP PREEMPT_DYNAMIC Sun Feb  4 05:25:23 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
