Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EBA23C9ED8
	for <patches@lists.linux.dev>; Fri, 17 Jul 2026 08:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784276992; cv=pass; b=au4ulBF4XSoU5oKbLxEdEuxNc2xwhJ5OCHQkukF4cuZy3Aqb22cTf1j4obmBATAByVqcYYQ24a0bcAwLgJlZxQqg8AD0RdNiyX74OQkSOXv0OtxlucgwpGc7x4B14myi+L85vcgafUtmTe7IrGSHbBmV3w9JzxLnpICMYzMoBWs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784276992; c=relaxed/simple;
	bh=0t9JFG9qYMxku99fuegP0SFobvht98c9pfQEgjYuBo8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N471woKyDbF6zxmfwv0SgljyVwOkg2Jt7/Kow+A+iOvlW5aSsLI388M3oB3LUH0+FQAy9xD3YrF4vWvEOivo/FJcpHv21LtoduuOMQnGRcyLFBwiSAq+X8xFeWQMs+OSCXE9FLjWOQ/GKXYA+ArspzTKY0Xjzyx9V1PkIWSclz8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=fJLEvsOH; arc=pass smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="fJLEvsOH"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-c9d1fff21edso4952373a12.1
        for <patches@lists.linux.dev>; Fri, 17 Jul 2026 01:29:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784276990; cv=none;
        d=google.com; s=arc-20260327;
        b=JB6HUJBlxWPMAhdox3+xNV73tI1fz92G1kfGsuT1vQrNy7LCfP6KHdxr7tnIavmux8
         WFwNfLyTuojJqHzEnwahvVtJoef31pC6hiqp+hHoGfb/C3zrXQBQRwzfAr2JwHmmJMJn
         bp/UxLd+Ky+UfwaiuYm1dfFjagpXrJ/oDxzureD45yqKe9xPz3lohln9OMahJlIO7Pop
         NzkpKEvyMLg/BWidG0Zm/b4hfW1codVjRl4v6Ltf+19ApLDgynqsForAtLm262kDWnlm
         VkQb0OCFjQYSGQWFTF0Vuy2BkzXX/ud6+8vPKKRDNdWwYogpvVoue1O3fRxqxUSXZT07
         nd3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bsyN6n1X+GJ2Z5rKNi2r3QYlGOgGQhzgZqC6Hvjv0XI=;
        fh=kO4gvrSUtp/+Zq1nPqL6KLGRA4kaZ5E3gpXl8NK2hhg=;
        b=m5fb+R8yO5yVkafsIqVVVF78S3VKL3M0UJawElQOjeaxBbCBxuk0L/2FaCI3E9CTYb
         QgBYO6lNcxRUYv7XSlG4K2fZfzFuos3qqqNH2W7gneJI+S9XL6Jf/j0YiionRxhdSY6H
         Yg7wL8c4SPpNrDl7sCUk5C8WcwPbIr51Uhg/W4lQeYfGTuRAUlg+MU90q6mhpmbzeuT2
         YhF8gZNOIRmeJw988RZ4JtIDr3wp2CfasdG3g+cjjQBDxTBsQ7EI0khYsAdEWx2izFg3
         5yZ1EQY1a2jWA4u5/JsVMbZPzJP8YqtMR3soXRQTKi/rH/rirS05ymSOYOS6IWeYbteC
         b0FQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1784276990; x=1784881790; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bsyN6n1X+GJ2Z5rKNi2r3QYlGOgGQhzgZqC6Hvjv0XI=;
        b=fJLEvsOHLz10Cw9gy2EIPSAqCYEtes+ASdJDjgnBSUhOmAzPy8TT1TCCV0lJVh536Y
         n4/ZfFF/1xCTEr5NTdetbOxPybtbWUNk6cHqGogoL/dz1rZrr+andhPrJrHZ0ZUsW1Mj
         2zpt6BLZwlQqEGWC02oFrs37Pd0naoNlEKRa9iOX+H30He9OSAKkuhaX2fCgpK3zcHQb
         hdx1vI2pg9dlvu+yJQvcqjWhuzzC+E+McotrGZL+5+47WQjpZMITtPR0E1eUcrpiqii1
         2SxEezArEwko56ktIUezNdXOvTM8IsbnyaL4J+4KA0jRspmjfq4K93yQvwCbm3OvymNc
         PRuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784276990; x=1784881790;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bsyN6n1X+GJ2Z5rKNi2r3QYlGOgGQhzgZqC6Hvjv0XI=;
        b=oF0xKm+QvdwsjJZxRshTMOcnSsgqyA5rPolobCH23O+VRVilY1IRnTqeqlqODmMpQC
         0ocb5jAJdfm5axJIpY2DsIEwsL2XyTPwxZ9kllL46pmSZQlNKgQK5SrBMaHunZbEpZkH
         2WYUUVeZ04rzEW2SAD4RWQshLV39ydJtwEeXsFP52HE1RVkzV1RXyP/pYrEFjuCrOuF9
         CPMad/C1xA38igFZ3TEWzShI8u5MdvZG0+Y1Ddk9Yua5io+eYJ4HKjoCNtlgTx5Rhksp
         Dl2D8gmQfQpKYUnC9dCf6R40oRSYm58epnVm9rCRAJtMrPjai2UAG/D8l/MVHVcdMUlo
         dEcQ==
X-Forwarded-Encrypted: i=1; AHgh+RrSnoNks+1wnw/apChJIjiCoMyuwY1/jdQIFe1a958hF2CP0axSz6iPhSWuZcDUvbrkzlvLh1FC@lists.linux.dev
X-Gm-Message-State: AOJu0YxlJyP/55n/vpK6MpcnracnHuDaLlbaVSQHDttsslu5T1Esbzmd
	8J/KGO+SeSZV3Y7FfDtek+sK/7sUt90RO+tqyg6c0Kft/TBU6jLjxD9Nr16M9oyWVU4GZOICfVu
	DIcYxds5oj4rkoqL0zaEh9d3sJLuRWEZQWP02lA7Uzg==
X-Gm-Gg: AfdE7clUwksYRlqe9O73ccDSDHgqXOC75vqtgisSdfoVH+NH/2etesY/aNqUOTECAUF
	NwQUwyHeqc/215P5YJ3FEYiOFJS/wFQWELSb2EZiMLTU0faYO7P3zdVf0g9AYRwTamsezt3FyRa
	/PLmioRVhslqHuy5TMomGe3lsMj+61oiEDLAFP8xyOrkPXRziFMjjHXS9bT5GGJLe2ii2Nyr89C
	/xf64T6qHOKf1PRssodvHOJhY4wsVfznMiH5mhYuMDdfm9xNaEw0meju1RnDGozar84mWwj2tnr
	FmvMRZhVcL6p+q8BdUo=
X-Received: by 2002:a05:6a21:6e95:b0:3c0:9c1a:893e with SMTP id
 adf61e73a8af0-3c3ada3e2e6mr1770184637.70.1784276989861; Fri, 17 Jul 2026
 01:29:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260716133047.772246337@linuxfoundation.org>
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Fri, 17 Jul 2026 17:29:33 +0900
X-Gm-Features: AUfX_mzoMNdeZUUZN06JT_8hRl2lSZ_0mLEjp5zCBlYqYm4zCoRug6tYz9ObcTg
Message-ID: <CAKL4bV4EODs29Ra3wO77kmvu+UHnX3N8rELbmHRFW1RMwbfizQ@mail.gmail.com>
Subject: Re: [PATCH 7.1 000/518] 7.1.4-rc1 review
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

On Thu, Jul 16, 2026 at 10:38=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.1.4 release.
> There are 518 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 18 Jul 2026 13:30:01 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-=
7.1.4-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-7.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Linux version 7.1.4-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 7.1.4-rc1rv-g01c8c5ba0d4c
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 16.1.1 20260625, GNU ld (GNU
Binutils) 2.46.1) #1 SMP PREEMPT_DYNAMIC Fri Jul 17 17:03:38 JST 2026

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
