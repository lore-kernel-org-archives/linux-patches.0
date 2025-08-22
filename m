Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 543D66BFCE
	for <patches@lists.linux.dev>; Fri, 22 Aug 2025 21:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755896459; cv=none; b=lSmOFsXyfN7/RPbB9/YDFe/h+xwRsAI5FzznzSXMFscpMM0DPS6LEWSv9SxwIirdfq6pLMAFHW5CFG7DhD+kynre+hhdtSURIvjhm7HTU7l/BXVjN8ybT470itZHSGNSHOcGCLqoZ4l5dXpQSnXhNPUPSsbBUn2uAoKF1o3UCo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755896459; c=relaxed/simple;
	bh=dc0BRlBhZJ6Pbxv14syasrosEBaUEOhVgP0tc9NoHLE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nQV/OS0X6S2aTy+tJL/UCFY6UYruFBp4cgfx8y5SEbuLyhrFE34j9EijeWPx1hjCbMlngj5GvOQUuuUP3MKMQNgWBuq6dajxs+IOzGyLGHanAHw6n0TUS203KpQ8gLxjlOzzEJDmQ4YMr0WyHZTHqK7+t3Nl5pau417e1n/tg2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=Nj90OhMO; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="Nj90OhMO"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-246648f833aso2918875ad.3
        for <patches@lists.linux.dev>; Fri, 22 Aug 2025 14:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1755896458; x=1756501258; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nSm2pjQXpxCPM50Nuau91slBvEI2srYL3KvYFnBQXAo=;
        b=Nj90OhMO2kIT7YFvwp6OGkKbIXXfZPaPrES6s2s0wT28h1UvZFZrfjxt5GvsDta5eB
         OBrMf3NeeXL9db95ZjnQp4Xyz8qX+AUkUWrWtmTpo3ln0jfghL9fKOxW9kj5JEWOSdhi
         hAt3ddP3Ya7s0/rFregtWPU6ZaNGxQQyCeUuPBKofOil1n4CshQvzVLBjzeFIxOhPj5X
         Y0zPVey8MOqHztRA2tANl48MMxjGM+h+1afv6wZRU2T1UlvQbCXejqaRlWKeBU/+iF0S
         +m5HgBuBrwHotPwgruABEkLfyiDajhlCjNqePWrGkwbCFtKcs502nE2M8Tw5H20DgOOE
         woOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755896458; x=1756501258;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nSm2pjQXpxCPM50Nuau91slBvEI2srYL3KvYFnBQXAo=;
        b=jqbdFrcKlHR2pWbBltSlknUia4YXXK/mu9/GxgKKiKeB8hKHjArp5284DoqoAQQKCy
         c22ouT7EFBHm3tTLTI+Ba64eUZdnn/gqzQi1Jebbpcmk2mhfxca7MRUmb12xCGcF28C0
         wCk81EDbWEza5sktBJjk0/4X7SzOkWyClsckIrunilAYlOCdyllsTiMdwxqo1alVgJeP
         LbY3K7WJxKnsowDgRE91F54+7gSyq1oYKigGeoxTyoXTbHJo8NIkUs7LuwSJmhvjYyZY
         Bo6D2F6ZZveeOklt6abZl/sQeQ1wFAVi0FwE8BznfLhgGh0z/O2xEv2HZF8D4GS/mFRf
         f5Aw==
X-Forwarded-Encrypted: i=1; AJvYcCUeuPYbIv6nXjtK7vWTFZQWyo4KoiB/oUDj6CQbFsqHUtdB5vksYpY3eny015AMFVphIQOgalMU@lists.linux.dev
X-Gm-Message-State: AOJu0YwCsTKlwFPw/4LFcMnv2f8TwSwexwO+S/auzvIWMTmA3BifMLSC
	jYgDWayQxYOGAJNvczuKsQ5j5JWCTk3pSanXBaeq+jzm5JtPGD7uwe0KdmS40rRQwpTWEGG8+qN
	qRbbCNK4QBDkWTSfqBC54viLPGP9gglJIwEXSoT2gNQ==
X-Gm-Gg: ASbGncsWrng70mE5cro9EScPT5GQU6FO4xtXeea0viKr76XqElkyZZzyJcQrw5n1jbR
	9PM9Nwt+u4TPBMJW0mxXWhA1kcm79Uic8L3SwjguFlR6VkF9m9/rLkEalEpSqJi7gy0CmTr8GxW
	EpR7xWIaCvZc54fE6ANveZ4b9HUpMGTmaqhIW6lXdpCSRxVCXYFSL6vjM1hKV9iUjY2zmHHoZc+
	5P/pls=
X-Google-Smtp-Source: AGHT+IEK4BjS16HtEyFxN/8dn0Ogc8AzIY+cgBAZsXdJAbzTtuUSyKBmNNJr870kG/3FIaY8i4pndkzgJyPfrJt6lxw=
X-Received: by 2002:a17:903:32cb:b0:245:f7b9:3895 with SMTP id
 d9443c01a7336-2462edc449emr66279955ad.12.1755896457518; Fri, 22 Aug 2025
 14:00:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250822123516.780248736@linuxfoundation.org>
In-Reply-To: <20250822123516.780248736@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Sat, 23 Aug 2025 06:00:41 +0900
X-Gm-Features: Ac12FXwOc1JOogbAORWWqhBQKksDiytp0VNRRIlI972IFt1EZD8UcTM1-UoNzCM
Message-ID: <CAKL4bV71GshkgN94LL55NCiDiXD-obrpzVoz4EkPRyP9paG-Lw@mail.gmail.com>
Subject: Re: [PATCH 6.16 0/9] 6.16.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Fri, Aug 22, 2025 at 9:39=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.16.3 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 24 Aug 2025 12:35:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.16.3-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.16.3-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.16.3-rc1rv-g3fb8628191b4
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.2.1 20250813, GNU ld (GNU
Binutils) 2.45.0) #1 SMP PREEMPT_DYNAMIC Fri Aug 22 23:37:39 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
