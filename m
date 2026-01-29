Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8800D34CFD7
	for <patches@lists.linux.dev>; Thu, 29 Jan 2026 02:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769655572; cv=pass; b=Dt9Ib7bWJR6YL+r7WtxfmZgfTOxGjVluBQS5DIlkH3/5Vyf0FY7htbZWR955UGPfI6KDY0ODiiSoiV7oufMt3U/8M516qYQoMXO/jQtajpF9gMkqKPLdoCO+LfDNrm9em3C9rEJs/S3UdrzpycT3Fy3HSWsaPKJH1hbtozwp4gM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769655572; c=relaxed/simple;
	bh=d8cztXYczvSOszr3V7pMy5PpP3cnZAjkRbR9QfTDyWg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hVpYRKWTDQHLOz2rjSUeDDjO+FLUNIf1oahHOT0Zzxw8nig6q/xVHOIud2ZxNY9sBNDIhgyAF+RzY+ep0j6L2t0qJaBJJa4pSs6vHRiqA46Jz/cAL02cHFIYisgDMqReOdDw5nPktl8YIxdDnwWmiBADzdeneJse4hTH35Hl4WA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=RpsvhyxM; arc=pass smtp.client-ip=74.125.82.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="RpsvhyxM"
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-11f1fb91996so1017619c88.1
        for <patches@lists.linux.dev>; Wed, 28 Jan 2026 18:59:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769655568; cv=none;
        d=google.com; s=arc-20240605;
        b=SkXMH++FWffLNC/s7em4Hur4nJQ8XXCNtJZxucm9iCnlZlxa0EpHxYrv1spqb96gfY
         Smf8U2CXv/PM6eFm6qWdx+kpcgsA5P9Y2sVc0ZE15fPlelcEQqdLDk69gBTOehX2b1E4
         pE2rYGlydYtbzUBMGGdcAR/fJ7wIv6MhRlOlt5LZfYhpKb15/L0AfJiS0jFL8YeR8j5j
         eVuEEvkDQswVwS4FAkCchKktj+BevimJEO9UPZEk3keM16ppkC3qZFt4LsF6XKGsJueJ
         CeqkjS60RyTAW5V9QNyMzJP0gwOKYwoiU/82tQTYyrAsr/1jzl+9zJfR7QdlW/uzpxu7
         oUdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=b1/1hgdrdOtGYjDRlu3dvktHWpc4PrVZjEiQ0nlClDM=;
        fh=CNvW1cwom38iP1BiWohfotJuoDlnhdbpF33i+JMjwsI=;
        b=VzXIWCiRY2AIczX6tllDrcw6LuGQxKYrLZ5s6M09XycjlTd+V+qN5hLWpgjJ9Y8E93
         VyH49y9LFE4XBsf/CJkIpL8DsoKpfC2y5nKGeF/YgTimPfnWewfuG1Tpi/dUWaZZNZqA
         uDjap1ZAT3/ROX0ojNwDDf14D9qgJkbp9ym6Idg90a32eupCSvORDUomiDWMgIagSYPN
         FHlIfH+VBO54vQEMW4y5DHif3kVnikXPNZ+xrz7K8orIeNm4I+vdgafdIDO7czTuhjug
         a+Izoah+3icLdQCEqijIdvAeFz2MYVnHfQ3HZGwAvjHYNijBVZBK8dw/BxrNZBrMjmo4
         cs1A==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1769655568; x=1770260368; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b1/1hgdrdOtGYjDRlu3dvktHWpc4PrVZjEiQ0nlClDM=;
        b=RpsvhyxMiWhIrlD4qpoGMaPh2N9SZ0k2M3kKkjmgHC5SqbKfdmB12zPzRm9ufS7mOX
         cutwc2tyn4mc1OYUtyR9UgkPhiPMyM9Tfh8BtWl0qsJxvThkP7RRs7hBmYcR1XRBlVcx
         3+8P8prU7kYS+JTtJP+7RIHZ6QNiyHvjkjkISz2WkH8qHPOjh8X1ND92u1I7xW3yqI+q
         0yOr7H2Pb0E5jSWSfBBgU/Zb9PaQ/XD6OlWGgSKuai4wLlvMM/3JL8VSRg3oFwjaV/KV
         h/xJzCZLZeWCFBfESqwpLObQd+xF2VOJdgfRFpvdLLou/iDvSjxh5jj+MSaetOFKiGcA
         p6mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769655568; x=1770260368;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=b1/1hgdrdOtGYjDRlu3dvktHWpc4PrVZjEiQ0nlClDM=;
        b=HvuRMq6c97HSpaWr2CrS3rcdE+54cxZr9WzvZpRJqQ3qFOLgMeIx5x8lRdKnXy4/d7
         0XeQ8mQJWl0s6yvhvhmydLQq6HkOlxwzbqVT+mK9UvA0xg+/DlYaTNBrqDtpg6hSoYBE
         T47HDTY8SzbxRzVj++wJN/2hwfRaO9bDWsvlQVYpVG/6u2p9B3p9idvI7Rnq85giT+/B
         JJ3nlT7jYsa9hb+gLBxBRTgCiMfc9sqdEA6v0KCcERvJnMtBXa3yFu+iJ6wxcj7tJLdo
         WgWP7RtY2SmuBy2ukihTTKynj3vd74jvocyXvldr9+sn/ebw5L3dKbSMeagzsYbgIEuu
         2xvA==
X-Forwarded-Encrypted: i=1; AJvYcCVN6c7yu5l2z21bOJpr1KHNl2rrX8s043nd7KoQabyqlO9Mo2idGJEoE+DbK0bKggXPmAYaaWY6@lists.linux.dev
X-Gm-Message-State: AOJu0Yyo06FFs7V+FGuMUKcBXeIt7TkWgl+vLlCltHTHykBrfWUs6xST
	5nZK3ZzheMOWtcUOpXgIdpx7sQZfB9eVJcBAqTtA05LUMiYVm1mEkcwVBZJRI+vyZbC9kDFmxTc
	c3bJHDgWFHnT+R5R5keXvizf3ZjD6EW8c1Bt/DVSMkg==
X-Gm-Gg: AZuq6aJ3WUVgj4uKIyoBlUZ5wqlIPCH27cx7Bl3jlKI65LWLk6Qmd6z3yCVqcgs2nW+
	S6Niz3SdALYv4eD14bEULXuaJuKUpNweD2OG3OycB+3b8QobaNaHumGIKpbhIE3TRGZdJ4Znpsm
	18b7LxfUuP3CQdxGACvKX5x1e4HLmA9UHv0k3rJPR5TQwixtcz+oXIHyPoGIk2l2TTXK9VShIos
	BkWszE7j09NNsSnKYiIASbSQaaXCZMLY2aJ5xN15nRDkQmsCp+JOVzSfpNOdf+DQh1mdP6E
X-Received: by 2002:a05:7022:7a4:b0:11b:ceee:b78a with SMTP id
 a92af1059eb24-124a00aaff5mr4519762c88.19.1769655567618; Wed, 28 Jan 2026
 18:59:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260128145344.331957407@linuxfoundation.org>
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Thu, 29 Jan 2026 11:59:10 +0900
X-Gm-Features: AZwV_QhApBiJkDbKT_aFAZUil7LKIchbu9gATA5R1VL45l1QkcwrVx9tfXGG0m4
Message-ID: <CAKL4bV7BeCwHonkdgtO9cHyWKW9Jc7R-uhxrnWsoVSjTOg1pdQ@mail.gmail.com>
Subject: Re: [PATCH 6.18 000/227] 6.18.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Thu, Jan 29, 2026 at 1:18=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.8 release.
> There are 227 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 30 Jan 2026 14:53:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.18.8-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.18.8-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.18.8-rc1rv-gc0a52e9c6618
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.2.1 20260103, GNU ld (GNU
Binutils) 2.45.1) #1 SMP PREEMPT_DYNAMIC Thu Jan 29 11:35:00 JST 2026

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
