Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 407C0131E49
	for <patches@lists.linux.dev>; Wed, 11 Mar 2026 02:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773197183; cv=pass; b=swAJQ+T+E9iYpOKE3rW3uaB7/2CAvPeZPi6al5/VZ71sdeU9CG1VZc1d1Kkvl1x9qDrFE7A3YDsWn3Uih4sh7xfkvDHKwkj5CY+l7bNE81QClYekKwuQfpq4Xc5KxA3C1m9NHYa0rQOpG8sKDnKspSSAYObYH3QJJUiIUiSiktM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773197183; c=relaxed/simple;
	bh=w1PwotnzP5teLIRNxoAl8PpppmkyqFPGpwFrDOn3A7c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eu/2xnqdeM/dIBNnMlkYxJHitzhktKf2/a0UmK+0e6lCfIRG4ky2M9u5CSCW6dVodf4nv1YjRSqRmN3h3VwRVc7h+hCYdEykaw3R4o1UC8X8laeUvU31+d6MxsmvatteXKYPCeI/0eLkcPSzeUKLIKadIcU/oJ3odfZzWMeJrso=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=vdTxF8Hd; arc=pass smtp.client-ip=74.125.82.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="vdTxF8Hd"
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-126ea4b77adso16645713c88.1
        for <patches@lists.linux.dev>; Tue, 10 Mar 2026 19:46:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773197181; cv=none;
        d=google.com; s=arc-20240605;
        b=jYDjYZSjb6LHOfiwEecbmRYYdi8zPCXy4OFL6N+XQhfarb8iSQGGkWT1TjBHQp3t7D
         b7p0w0q0TzEAF6Ob/r6Yge4Rkyc62WuIaOwh5try1yYy8keq4RBZyrryWewN+Iot+hNj
         /Ea5N8AMZnTisru6KwVPHRi20djNhHsboMfHH9nZ3u3s1OMesXMSx35aRXQsv7Ryt0bg
         pIHmxaNBcDuEMwAo3ciclBkc1BC6X6Cv9m+zIrh1vYhaXH6PvhQ4pMmWBr/c+szAX/sB
         wgNk6aHclhoAKGXeVupQiFIrtEjXm8VLCaqMPWd/2ucY1SJ1/Y4NBy11chGV5TZIQF3U
         CMVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sGXFndNWrLHH4Yf7sDqSezTLxh6DdvmScvJRMGduF2w=;
        fh=aAxUen26AhjWuP7RHOkVLEZm6sUJpzOel6A7nI0qhFQ=;
        b=S2nSROyPEKYS0FLL8iVU9Z8fj0m9Off4rLZGvMEICIuh2fjY9LcEdcSDLx78gQMleC
         hWh3XTiDhdGAOjtI3MUZDHLxgHNX9AdIDf48AE/C8rKhMs5EkUTtvjpIS37OOp4rMHCt
         rO91WTr47tkMOhol9aiWhx1QfIZqCzvCn1wjWvjb7e1r++co8xzOZGDZPKdRPyhbAlKQ
         MnMV+rtb0bmuubsBdnXE5RyY7OP4DMvN53pV6HTVRrX4+74nX3UehxJTf5N22C0QWHcA
         kHT8G9J3yFBmHWdpFrwxTJh6c+muifcZPBcsdbvmSAXoIPmBGtW9+0QR7S48y/e7BzTw
         vZxA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1773197181; x=1773801981; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sGXFndNWrLHH4Yf7sDqSezTLxh6DdvmScvJRMGduF2w=;
        b=vdTxF8HddW6Z6GBTW9xJxkK2jy5eUVwBnpixfJkc+I4L0OhpbGUNLUY/f5S+2AFT2G
         5Gs1UVUsGioaYs2WnTAJjhBfgnUOPF+5F8ljR9jebyFdTg9U40dtbHZHVNkCEKCvusB2
         n6VPGRgFuxlP5ePEuUIn2eIhU2drE/vc5JevGkASav/ZHO6Z/vLrM65IVp+MWIST3wwF
         46hWuSXRZQHeV+o9LhevlNfyeFxukclyW6yMKS0QJF2qbFi9vOivigLqLVd5BGOh9xdx
         zT7rPAN7MiwFf6C47SFq1FSK8osgf2ShLJ9KHQIWKWZAUqo92Tgz/MasWxkde41FuckV
         ZVLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773197181; x=1773801981;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sGXFndNWrLHH4Yf7sDqSezTLxh6DdvmScvJRMGduF2w=;
        b=ZS18rxEEYsQ3Qfc6Gi5zHZvPn1lB/0a0h0vTF+GPDhFjuc5rAKQUjZK/9UmCJXsv6e
         e2VRBJPcZgXeIH9idpGxB78Ac5uZteGcJ8SXGgAjcIvN+ANaNjzdSbDMc//P73iGuhf6
         mFhawcqAJ95ONRcURY27SBev0jHSR6AJzOxdSU6GpE4dm7OxQmv8GwG9AUUxYolBdHvt
         F2dd11FyToO8Ici+rshWj+XvX6Q6LHWvvVGyNBy65EIn1Hx2g5zCQOOOwcSlHTH0drlb
         b5BuLDTNVAluFkEjJIB7tBtekjtCQPOCaj1n3coRAdscLI39Ulv7ua3eXeHwnpRAniTt
         Lsgg==
X-Forwarded-Encrypted: i=1; AJvYcCU4fwMfQ1gSrDwIthlOpVtO0P9ndIfIRzZlD+MJCFvUtNXMd6m+jq5w/ttiorfa7vdk4qelpOuL@lists.linux.dev
X-Gm-Message-State: AOJu0YzBHJRELsl7US7XFDVze0AxKzwdZULJP9o455c2/GmX1kwFVvzE
	xLY4iAfVSZ75rtizUang42aMzc7LSRQZzIDo65SZWRYJcHmrN2eeeMBkxXJPUF84YdFtLydtYvM
	h8yhWrAej9NT0GJZl3USG6rEdZjHdNIXRqzv02ESiLg==
X-Gm-Gg: ATEYQzwZlguID7YwE1gpdEon6YHVbO+jd3pvP39vPLxT7WshutPPqAKsgvJFNOogu0g
	33RdktRcwcmOb90s6CCB8Vq4dquCSUMtSM8NvuR+8isz2VmfxAWOntkXAqYoDenubP7WR0t7BVW
	G1M29q1cqGY4NAaNjKddIe/zJGMdLt7ocGOFXrf25Wgz4kVh4sXihUjemAr8NOuYs5jXSoub62h
	ZPTFvrnoxHrZnp/pMPkTa6XNvzN16egNsJe2Ufmzjs/f32XF8LupYZjyfI9XDFbpRno18hL8G+G
	+Cc0xfyHLLMKXmTToh8=
X-Received: by 2002:a05:7022:252c:b0:128:d23d:81a2 with SMTP id
 a92af1059eb24-128e784c1b5mr460921c88.29.1773197181161; Tue, 10 Mar 2026
 19:46:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1773140654.git.sashal@kernel.org>
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 11 Mar 2026 11:46:05 +0900
X-Gm-Features: AaiRm51yvjGv8hoDc6UinmFg7p_FLu2aytRrBfEiWRAIiUZhBwBpxpS1mK1d6XU
Message-ID: <CAKL4bV6uaqAEDrjL6kUvHfn2yp7wmwS5dH+YK4nbcvoufDz-1Q@mail.gmail.com>
Subject: Re: [PATCH 6.19 000/311] 6.19.7-rc1 review
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	gregkh@linuxfoundation.org, patches@lists.linux.dev, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org, 
	sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Sasha

On Tue, Mar 10, 2026 at 8:11=E2=80=AFPM Sasha Levin <sashal@kernel.org> wro=
te:
>
>
> This is the start of the stable review cycle for the 6.19.7 release.
> There are 311 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Mar 12 11:04:16 AM UTC 2026.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git/rawdiff/?id=3Dlinux-6.19.y&id2=3Dv6.19.6
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.19.y
> and the diffstat can be found below.
>
> Thanks,
> Sasha
>

6.19.7-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.19.7-rc1rv-g2867504d9c53
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.2.1 20260209, GNU ld (GNU
Binutils) 2.46) #1 SMP PREEMPT_DYNAMIC Wed Mar 11 11:06:57 JST 2026

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
