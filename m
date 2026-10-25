Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792924601;
	b=nAQ8XB2Ci4YhcQrovuter+hUXs84+jAgilKeWTOZ9cpAyYmJ/8dBRUDdOiKs1Pijc81Z
	 /hgM/Cvx0cjQ/NBH+aItY0W5TXk/DhOYlwNMi3lwHnXXnHPG1zG/pHh2lZQwhaHhm+Rtw
	 2Rj274+gftD15Vx23RFnAKfzy5oD0SmmsmLBtKVLtIO+4w/L3VluZtONswbp4xAXh9ztK
	 iugFDwGTEiwdvkaRYFbVEfTORgaO0MWYyIgz8jufvbvlMa5P6/VzDlzTWzdD0BAwgcGqB
	 iEPKqO8kdV3g8Re3+Rn52y0caJPELP0ZHnsPN545Ar0PjAajk6bMRR6PzqMuMDQRRJQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792924601;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=24txbqcyguXG46xJluEhBf0wsoM68TC1uArTVqKrpRo=;
	b=FK80sD+q9Mxn+mdXP10kYaX3Yfu5BQphpOl+4S7uj2KemvhVRWwzFolKD0HunvSJm9zs
	 hRsTMmI0TyWw2owSlP5E+ForVNALJdz6o7v7I+EaSyuzQm5jK8Y8WYthtMAObwnGWQnPu
	 WNuN8H41FVKb4ViqxI0/cA4qeRMeSj8VJ1d8ViCY6WOgmm+9o+MuNriccdF+jZWUH43Z3
	 tHMV53bMqaR++iA+M3kMDJ+JQSl/4kTrvgTEXrG7uhKKtdJzU2eT6e5QzRikE5YBO75AT
	 mncEMLaxPXji6zNnZxVgeg1DQw+8wD3xP82FY1/6zPHwz4wapLRSMRjdLYfaE463vTg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=futuring-girl.com;
	spf=pass smtp.mailfrom=futuring-girl.com;
	dkim=pass header.d=futuring-girl.com header.i=@futuring-girl.com header.a=rsa-sha256 header.s=google header.b=uaYO7s6t;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.45
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD21606A31B
	for <patches@lists.linux.dev>; Sun, 25 Oct 2026 10:36:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BDD21606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=futuring-girl.com header.i=@futuring-girl.com header.a=rsa-sha256 header.s=google header.b=uaYO7s6t
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6b1aa27963eso4538162a12.1
        for <patches@lists.linux.dev>; Sun, 25 Oct 2026 03:36:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792924599; cv=none;
        d=google.com; s=arc-20260327;
        b=Rzzp2+7GWI0WDxp3tboNWgwDje83D82ENLTCh1N5J4S/6f4PBcBWr6DBC0VlmY8Jax
         54+7gk4HfaHWe5lTDac8v41fpwkeG3R8Rf/BwL+xslVzxyGR5pbH2RrXfsUsUoFZJp4P
         Y9tZhWoe4HFdmGuOuj5KC4bnxkuzfhpGm2kvFLPf8eZHMwc4ng+wx2n+IHZvuO4RqyuP
         jaVMT04+Z4lT/sjZB0eU/vDNgC0xC9xizqUtAvlEChPUX0/CEeezD3xrpKQt9dd/JwrS
         Uy+9izew/n1GQ75mSynIanqiepfOPufWixP63ilN1609RchhlmCtTp+4DpLLQX549S/e
         IZcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=24txbqcyguXG46xJluEhBf0wsoM68TC1uArTVqKrpRo=;
        fh=NPSxaNCpRXX/DII+K1QOT2k7sFBykyUisgeJzsAdGms=;
        b=emZRUZ1N3If/8iAz6rg4e7KOuh+eX+DVQrrTujxHWpdNQ2E3XP1FJ5QuqoMUVuJ8Gc
         7HpxppBKX9xczcQUVA8fipJwrWZYK0i3Pt/Be+T670nDqVM3SsIiHnlG7gr6U66LvdrU
         gW5MZVpiBdcBd+Sor6nmcnKsli9R/O7p44vAKuRF3ZZFGg25rHSrpFHUqZu+PkvELotM
         XaEhykxFxzMTLml+ASSQbD7g8631sKRyJYm76xlI/FIiKsiymg6IkMPZkz6sOLQQHq3l
         UNXQSwAykHNoKeLYyuTpRfK6XzMy51RzsYXp1xB9PvgHjBuBhrjCQY5D5Ayd0UGS75Is
         0YUg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1792924599; x=1793529399; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=24txbqcyguXG46xJluEhBf0wsoM68TC1uArTVqKrpRo=;
        b=uaYO7s6tzjNW7f3QXd9d4gl59szGBCZhc9/JvWEcf+X5j3jPazMu39XJiowfOMzCD4
         LCKVOMUXCHpNQWHnQz47/kmdci0p2GQPl7OXdopJRkqyZz0km4/fB4uq+NORrwx73rHn
         +pl0u2X9bOm5gcLABC1DguOJRM+xe6WgvYRelRWVfBrPRV42JsnRP3bNh1vmIovMaB9s
         ziiVW2P2AIu7uCsQY1eTLAZd2S7+bWkHgf5m/ZFA7NJweqIC+sk47IBfxTQUqPXkJrBE
         U1wAVSXFtbDYbfRAkG+7DnIOQvoeo8fmTeEUrG/3Ezo2OSgXKY5QOASIy0ucZsAgn4Oe
         UaHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792924599; x=1793529399;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=24txbqcyguXG46xJluEhBf0wsoM68TC1uArTVqKrpRo=;
        b=ZW8thEFQrxoeYlZwybkibJBOLxO1oH3qKjrMskx0B2GYigFUeDnnSfd2wTBI+BiMa/
         HHQO0v69wdked0dOHYdgk7fOSd1UCdUrZCKfE5dpMaRsc8rOyVCzRDGTxy/eDLGuVCpe
         2us9rOFhcWWotLjxh9KhQuxQHvNroM7CFYE/eXlKcAh5PKuG2z3t7dxp5zsAKVABOm6r
         3/+2gAT68O4LoOlmvXqHra2TlfwZY5RnpS4XXwkFzGPkOzwuf17oSQq3ABKrTAqk47fQ
         6a4TzMVHboHcvXV+fVAMy9YAJJDUz4nHaR4MspTf2tjeRj31RcqxQTDrWLQBYEXBWjF9
         ZYOg==
X-Forwarded-Encrypted: i=1; AKwUvBzhEf+i5wIDHG3vfpz5CEAwWXkbBOjpQV+KfzFT8iQlCEwFgockbeC326MWebpptphW3gNu7cAM@lists.linux.dev
X-Gm-Message-State: AFq9FYKsh42UXrrH5RvQnBGW863LxpvBH+ImXz8KiOPzbcn/YhGJevM0
	L0Yv0XCiXRLtIS+Hubh+auMtVQw/XQgOEBofT6cBQq55n2wdDGqqCVpBgMHqzrNrTQ3T3y1jotu
	HB8UszGE56cBBrCYs1tFpY5kvp4Bmna7UvRVJCtGPGw==
X-Gm-Gg: AYBFou275eCgdBcx5RCohjyBY49VC7yBlh9TVnK/ffHOf+2Ru8u03tYEf13cB4rLrRF
	v6N+KyFl30rVXlrkh3o9W0pwa1wxNQQ28fagegBi6zxV8XUWeAaR7GC1Uj7GD6OtQlyBWYgO6V/
	zeL3OZ0dB/+nzpbCmgR6v1MuWQqye2qVFhg+Jn2tvcoLcWn1cPHN54Ah/Sit9crB1nOoYnLp/dQ
	CrVcQs0VNchThHFRPXQeuWzEIucZREGfBOPVSbHgeKljE7B0XG81QYu5GlV4NlIi0gVydMFI84p
	EHlQmdGd5/BvAnQ0biZsWmOyU9uPtsPvhGdYcMHPjijYSrOKtCroC7KZMq+ZBNE8jLpMLB1ctYf
	fiU36Gi1DrhChdJ0jpNCuiXKuJmUSAwCTLnfUMhoAtJQ4vfD4acNiDwevyYEhViBUXNlPhw==
X-Received: by 2002:a17:907:96a4:b0:c26:1cfd:4244 with SMTP id
 a640c23a62f3a-c46bdbf337bmr464489666b.11.1792924598905; Sun, 25 Oct 2026
 03:36:38 -0700 (PDT)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261024064731.125251200@linuxfoundation.org>
In-Reply-To: <20261024064731.125251200@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Sun, 25 Oct 2026 19:36:22 +0900
X-Gm-Features: AclHuK_Ev7MJ0UlkIUNpIuHy-qSRb0ZmswNvaVNZebfMs2Yp7BHznY1L4EcdhRA
Message-ID: <CAKL4bV72vvEwMwvDXvgZWio85xJf_SF1-XsNJOtXYdXR9hN5ug@mail.gmail.com>
Subject: Re: [PATCH 7.2 000/243] 7.2.13-rc2 review
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

On Sat, Oct 24, 2026 at 3:59=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.2.13 release.
> There are 243 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 26 Oct 2026 06:46:54 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-=
7.2.13-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-7.2.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Linux version 7.2.13-rc2 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 7.2.13-rc2rv-g7694d244b4f8
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 16.2.1 20260810, GNU ld (GNU
Binutils) 2.47) #1 SMP PREEMPT_DYNAMIC Sun Oct 25 18:47:34 JST 2026

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
