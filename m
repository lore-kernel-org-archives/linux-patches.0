Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15DB541D11C
	for <patches@lists.linux.dev>; Wed,  9 Sep 2026 23:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788995350; cv=pass; b=u2eUEiQLXU6ThZurQJh3KP8hvl6GIzkqVTZqkgpfAFZplKQVrhZbvtq12Wc52KM5OiG8EF7yVlIgulgw2SwfMFVtBp+It6GDZUO4kkhpMXrb/mK+jUN+opg/T1NjR4twC6zVYGHwIIbc+KZE7cHAOkS4B7geJIKHUxDy7cBTE4A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788995350; c=relaxed/simple;
	bh=nb1YblmrUlr2sa2V2CZkzLqPe6bh6GMBpVgP0JRYHCs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=etNUM+g4t7HmnMevhRiD5baVgJI+U+s9mrKthbUUScK1c8RvsTYwApxw7OKcU7gXPxY5NdU0UWIHO3AImTCpuqe23WNev1VvChCiD+mRcUrcEeHqos/9ingmOvCSNL31BMzzNqj7QpThP83iS6Jk2EMymZGZq2rcF238qqmvPUQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=dfdYxCv9; arc=pass smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="dfdYxCv9"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6a0de062db5so9610838a12.1
        for <patches@lists.linux.dev>; Wed, 09 Sep 2026 16:09:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788995345; cv=none;
        d=google.com; s=arc-20260327;
        b=r8/zANOIqxn+wB6V2tyMfm7FsZSxEw9K+21ZcZwFGLGh+VHJpqsm0i48/Z8NgsLsFx
         wnf+2kZ2d6b2Q3fxewJWs+orlnt6H2MgYhobX4mBsLR71hx3sxejYxcN6Jbw9CbYTzIr
         7ST9sJlWLkvfJ/rE/3JFRTpGmQm47JjSW3kU3isLkWUD2AhoBFo86ZYw6qHzYRgSj78U
         zEprP4X7E8+Gk5UcNPRgbVP8zA57nlYjiQDQARhW7GOGN+eCeGc9/LWrSb9XwSTG96r5
         jjbhEc90367zDfC0ffEeYNFpOjnt4x3ROtjWTibQYI5bP9RJ8TMMynpxubnivo6JDAPd
         FZSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GqZtypdgnQbkzEFaLVtmtAULjzYK8mwtxUr5PWfFkcc=;
        fh=u3Q6LhzIhpKl58t1JJTJodr1vI95RMGWASNUF3PuGg8=;
        b=IUB9/Ns+4I0qOZ33UpoW537mA3h0y0ckKGor1CEScvTTLk8RDKx88+/m0lpSAVACOT
         h3HCU+8adtiInWmMx0GjtjafEono9MtIe7FU78xyOFkG2UfCe4polh62zaosd5w6wsjI
         M9qsJzre17z9ejxLOLzHUNb/7G6ZJPejVL7OnxNXDMLhZ2nv36JnBUNdHPH9rXpS3UJa
         ORhX3IbSTxI/yZo8lhC5fqZnxnlZnO3SH3rOs6b7uojOfVVg07+f/CNrkReeGvkB4w0W
         S69th9t9EVpsoL6aiHuPNzc05GPsTfGdZLMpMD8O1vjzeavYxT0P3N7yBIfjpz93+Nw6
         8z8w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1788995345; x=1789600145; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GqZtypdgnQbkzEFaLVtmtAULjzYK8mwtxUr5PWfFkcc=;
        b=dfdYxCv9w2q+k4gp+CYXqY1CG6Y8SLWRvnQTg6rczzqecPPcf2tWumkM002NVQIkVD
         fhtDqH4MxabEdtpMEfg/kHKa/UR+7ho7XdS1+/aN870qPcDNG/fNtyxoYU6upBr5B1hx
         ASEGD3JxprSlnj8cGBBQMh/nf+AFOv22wiTJvGjuCjnbOw4/wUTx4c8uKqPfg0ypoeT1
         cIYl5qJGcG+VOrPnURiS6F43gkYOT+YDpUBA6HvGMw52IbhcOGWFgjeXOOk3uk1e0sgv
         F4xR19uzkOYlVC8QzCaHoE6oeJatrAb30iVz5F9yDinFON8NlrdFafxOjpGYKL2kzFS8
         8blw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788995345; x=1789600145;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GqZtypdgnQbkzEFaLVtmtAULjzYK8mwtxUr5PWfFkcc=;
        b=UgovL0NyIKdRMFsS40O00llx+SbExz0zwGnLp9NPCR6TVZJztSRpPusHdMhZOAAzuw
         rzgq8ibNM+/ejqcfjdm6nBlFdOtYqXEMChWaC1V9FkIqVBECAnKTYLXJWRtEd7g2Q28h
         nCzcXjGiCpHgLwN9e843JpbnBsdEiCap5uAQugHy5YJYF2wrG0d9qVb0JXK5YR+rV/lR
         tPw9iBAttq/mpdzMKcilZ25TtIhRBf9Xwfm/ILpmFTpffyUid8ZINBJSQMAyJJRz+uJj
         dUD+u7KMgBYPU6/e+/bAYd1VKK3n6mpRuCgWgL/3k3HQqWwQNJF7RcFdIZibjbleGosL
         9F9A==
X-Forwarded-Encrypted: i=1; AKwUvBx1T1qojk/e0fBsxVxtXGr1UEh2fXxM4ntOPn8kXkXfiL1OhNgX+VJM+EZcLSB5QIHwTSRwuCc2@lists.linux.dev
X-Gm-Message-State: AFuF++nSI5oCDSwBh50OH+gDxVG5otORLpQL+4jT6pqiJT/Mo4RddoST
	wr8kCNrwuwkAyIGkPJsln9gH1Ra8p+yXtMG306B6gF0pgp4wn1fuHkc+SAE9LJDf3d3R6S4Rd25
	NQo8OOTV/kvO6sXJz1UI5FJ4G2TVfXqj3dB7TlteGSw==
X-Gm-Gg: AYBFou0douslF/BaCtQ1g44SOPBhDNrhOMpG7hVKLrsLo6VpM2CzbiMhUlspBrM2qcN
	xhr87cfgBVxFw6D7hazQ38vXCxfI1jjuK7cmqGN8OeorWK1XFTn90PCJZCV0+ygDiGfRjIW2xsw
	BubWEASHylsBq+KEjauwTQsAp70b8MUWreBclxYheI4EgT110hRoWCK25KOUiIiSC46Vyp04kBV
	/lNG0KMMpBpzhG2InqehM25V3O+Rg580aQ1IQBnmUoMAjfyX338K9YYT8Bk2nvA6udLagP4+I8o
	rVuxAC4ooniIBKAu8IGKbtWm1+Y8pj1Qb99gY2iNz0sHKxBIOGEweVFGfFvVxEKi6Zw=
X-Received: by 2002:a05:6402:3546:b0:6a7:ee56:8158 with SMTP id
 4fb4d7f45d1cf-6a7ee56823emr13010872a12.38.1788995345102; Wed, 09 Sep 2026
 16:09:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260909134230.441546314@linuxfoundation.org>
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Thu, 10 Sep 2026 08:08:46 +0900
X-Gm-Features: AcwNN1XsZj6QFOQ_6a3WQsNELHQa_nUcIhH5WCykY4cQ6hErmSK2vs3WnidzMYE
Message-ID: <CAKL4bV6sASyrDc81R648XH+kV-BSOa+-v_4CpEp38KiHzU8_CA@mail.gmail.com>
Subject: Re: [PATCH 7.2 000/556] 7.2.5-rc1 review
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

On Wed, Sep 9, 2026 at 11:14=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.2.5 release.
> There are 556 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 11 Sep 2026 13:40:31 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-=
7.2.5-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-7.2.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Linux version 7.2.5-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 7.2.5-rc1rv-ge01c81012950
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 16.2.1 20260810, GNU ld (GNU
Binutils) 2.47) #1 SMP PREEMPT_DYNAMIC Thu Sep 10 07:34:49 JST 2026

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
