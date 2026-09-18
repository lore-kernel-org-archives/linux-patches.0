Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EEFB4E77FA
	for <patches@lists.linux.dev>; Fri, 18 Sep 2026 11:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789731841; cv=pass; b=Ym9IoHHRSZG+NyY4RnInNVT/yl0vFors9/30vsHdupX1YKqYQAIb98rvbW1GIyfeHW9xPRnyxKs4amIP/cmtCdy5C14gK7CG1/PSUlrHrE6FpU2HiJtbRz9wOZ+NutW+BQVtHCUu/29fjLumMz+S0bWR6E4HiF8DlXvWKHeZbak=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789731841; c=relaxed/simple;
	bh=7YChWHA/9zL79y+NcFgTh/UhwmYRTNb0NTKwCE5ZPiA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qtpj5siN/JFwUWVhr4GY0mSzODKO5RM08azOn8Huf8xvIoq17dxsUuwt4PDVqzjTpvX/cNRmLKUYjWLVL8L8HnmpStEULfndGYy/Dt6GTqF0lnR10Z2jBDC5ltUewlVEaq9Yio4qNOe7CnbAVcKn4FdFnpAQwEsbMEElIfPq8xA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=kevZYi1S; arc=pass smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="kevZYi1S"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254f705536so114312466b.1
        for <patches@lists.linux.dev>; Fri, 18 Sep 2026 04:43:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789731837; cv=none;
        d=google.com; s=arc-20260327;
        b=mDTtCI4mBG5NSzekxdgJtuSUN0swT/w+bS6jADi0QM/amwrZWw63L2fJ2mFQ4mlL7T
         9musGWZ/vLAXTpeXcwF/SHIh1iUP/j29ExaSUjoWpGIrj87r8c/fxBdFOtGMRJLxajwV
         P6q1/GfVlKAfZN2ZPKPYWBvaUdbThipJRUW3oUTG1YUDmqVur4EKTOslaW8h0BI/KUNY
         OKGn29qBK0asJUPv2Myzh4n2K7UJbL8SW131hORASN/l1iWTLNpcUMnAj5EeBb31Cabl
         1i/5O2Vx8VcnHz37d3SqwxcUgVk1d0/KZoGQPzzPVlz5Nbv0JlyBbh3egmuL50A+NwKM
         adCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dA6vCQLul8Tx4ZGiErd+xrb4iMlZVj0qj1da7dMX2dc=;
        fh=DZGqSavmoDsZEVBVUUZae73FeqS8rq2RbSqezzSB5qk=;
        b=FCqUqIYP0RjvDNgIlo1Hbrn3MgLC3vJF3p2yIF+ENSyP7sHRHbLieqTNFabA0RyWGT
         s8ZccdhSdZZbsMqO/uAWeuXMxqhE3q2ToNyV4Y2ibZ+R4NumE0h7JYNsziGVhxwOBxNN
         PCW+QMYYPxDA15R0EgNJ1ZBXk5GXtGInJYMmxDLxorhj8UK9/HWlwLokNWnU0VaPZHFX
         pox5/4E5CQ+FhtgazE+NN+Cl3rYoR85nXN7+s5cdfYsHlc8MmNAcTwjTKvBHt4RMP3zR
         lnz/07nk81RceALkL8GVvcne527d2B9JWjEgce+sKQx5ygLF+h3/QK421szfpiQ2Qij9
         BGLQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1789731837; x=1790336637; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dA6vCQLul8Tx4ZGiErd+xrb4iMlZVj0qj1da7dMX2dc=;
        b=kevZYi1Say8sKieLuvE3ZJJINyXFf991yuS/pnzkfzQPkTX4/rNEal+flPGj5yUvBj
         ZwL/jYax3qEAwOK5wmlQeUYOWJ/B3iDri2Z/xlowLsGACnZ5vDW7LY0i8wljR3XJWgEq
         f5T/4jRUCb2Up8c9WgXjPbOe0I45x79HTxe08PB3qz0QpAyUfmKy2/zDQ+as2TPvmPAg
         wdYLPD5SgyzQjNltVOjJvDLcQPp2qm+v+Fcyuv7lGANaoI/m78srZaVxwhtOZczlfj8T
         Cj901Zvc5GUE3HlgISDHRzlwV28l3AwVZPgtQdbtrot8AgMl23z2nNIlkBuaJh8OCd6k
         EQWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789731837; x=1790336637;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dA6vCQLul8Tx4ZGiErd+xrb4iMlZVj0qj1da7dMX2dc=;
        b=YiZ8S+ouCYbrAAaZyDEnLUzIsetMe8ToyMkiFSEDR3U4BgPnp7rf4PUFkYeMgfxnW/
         fcJi2oiJblVXko+y3dstLfbZZCw/1lOq5JOHbZwmFGlyiHEdX8a/hVDsI842rqThZwYl
         MuSbVk9Lt8PIO/ijfxxogJME0U1+Eo6xZsEZHfHOURJAjxJpeoXVxyseJcipvjeMliP7
         4F41+yXQDgiATL3TxWv6qFHwwb1OG4l21i7/looA7dp7x88W6neOZPFKC65vvU9KCKHP
         BiZPZ9ZIcqEoVAeJyIv0JRvG+my7hIqyy30iEk9fUaK1jikiJN1gx+1orSoA+7VbujHz
         xTow==
X-Forwarded-Encrypted: i=1; AKwUvBxkS5KFOpD0iWof5QpUyAbi6se44Id8tXRaMEm1h5ljxdStxc3y3p1f4H3mTCObbuuXxhixBQzG@lists.linux.dev
X-Gm-Message-State: AFuF++kEG4J+iFV5FC85CAipHveoWrtC4DgIIsnuyqA/MoF9n05oI7tQ
	mC27ZfnoXgZrMEP8sVJBgFyYMuCZ317CEV61owD4dnzAozoumT1OOfLkrGIFfs53YkSB50qYNeL
	1WnJu1DC3uyRhQcde2YEDtj7XKEQOnq1OPvNKU9Wcmw==
X-Gm-Gg: AYBFou2NMfBNPb8/cPK9ihc0mqBr79+jbuLbpYWlHgdaraRDS6DVguwxTXKpnjOwoST
	EeRYjdukDQJB7ZmNLjdWCZHVUfvzYUGRpHr4CSE/U3ZD4oNETHxzB9ve6+uEMgsSdIeVo1yw6Ax
	YppfXbKtBeRcldOTg6zC8DsyCaFVqztgeA+I6CeNbSWJm60xcA/8qMXxsrwC9nYmJH6uMOjvPZL
	lpaRsz+5JS44XOTDOStdFYypseWpli+13tksQttMbBzZAA4KTwwE6hLo1lFcjy0qSVzKOksTBtL
	JlC8K7+lXIlXZ9pBa2oK99X9KDpvREmzBbs/mSkiK/P/4lFK/ISwRVJ9oA==
X-Received: by 2002:a17:906:9f96:b0:c29:dd71:7521 with SMTP id
 a640c23a62f3a-c2a159ad211mr257665166b.13.1789731837170; Fri, 18 Sep 2026
 04:43:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260917151350.597953846@linuxfoundation.org>
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Fri, 18 Sep 2026 20:43:40 +0900
X-Gm-Features: AcwNN1V6GXuA7B8FEhCBQCqFU7EygjeCV0Wpnd9XyhRDhPC2vNktE2fyei7DI0M
Message-ID: <CAKL4bV7ZN6mZMySE5tAwDwPEAYaXu5Bx3dQc-gieRheB8vGJXA@mail.gmail.com>
Subject: Re: [PATCH 7.2 000/733] 7.2.7-rc1 review
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

On Fri, Sep 18, 2026 at 12:35=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.2.7 release.
> There are 733 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 19 Sep 2026 15:12:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-=
7.2.7-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-7.2.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Linux version 7.2.7-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 7.2.7-rc1rv-gb4c9ab9b68c7
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 16.2.1 20260810, GNU ld (GNU
Binutils) 2.47) #1 SMP PREEMPT_DYNAMIC Fri Sep 18 19:56:17 JST 2026

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
