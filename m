Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793012115;
	b=oTf5Z7XzAXEtdvaL4q4YZCqjdbfxOYrTGcDfpcwKtgvwOeLbO5WqSwTr/67FWBEY13Zc
	 hK2u6M5zgbPZonck3SAElu09bbGtDp33yGeyb5wKRHnBqh9NXK32O3iH6Ke8zp3Cw7kdG
	 Uo8GmwRQX2l/FqDIAe9MkbCSs4OzgZGTbZkR9II7564bV8mZkxxkogJtDEUc10g7aLLGI
	 whgSztoT2rbfZtl4MaJHq5Z0+/ZQ7aJzbcwhGwoWsbVF21JrAGAK3Yco7FxtnfmPjL4EI
	 j3N1dPQiLMcWeR34CRPcXJqTENabVzqAqg8dSsQHh/ZD1jrpNQ1ScIeYB0EvjqcDuKA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793012115;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=DV6c1D/6Qzh64saIkUPZG84ARZMJ/aLNg7R2bPrZljs=;
	b=ByR5Jro+hXyFEgEALSWicPbs+dZvR8mF/8ncNp9aPHAcLnGGK4kaQcqX+l43cyK+biSN
	 fmsMRmnBqvz/mnh9N2LuAP5ALRFSbPkzeAsWnfa6NinAV7aWVD3baLflGtk8hP2FRnvLS
	 NQPyTVIadlJ3rXhV9Z2M8yd6R5Zg/P6PVVo8UMOpgepWfOPrB8pgPG6UsE7fYw5X9SZ7S
	 JG+snbljgPddlXGwbdxJ8j0iluuvI2iDvDHMx0kpi1O8r3u2OprFsbh+Zg8SL0QcVKhVA
	 e6ueCyQXkpzbeKHm3vBVfw534m3GC0uO/kK5BygC9b71TaUkTRM4Qf9o4Jv/v03+rCg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=futuring-girl.com;
	spf=pass smtp.mailfrom=futuring-girl.com;
	dkim=pass header.d=futuring-girl.com header.i=@futuring-girl.com header.a=rsa-sha256 header.s=google header.b=rtvIG0bm;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.47
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C334606A320
	for <patches@lists.linux.dev>; Mon, 26 Oct 2026 10:55:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5C334606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=futuring-girl.com header.i=@futuring-girl.com header.a=rsa-sha256 header.s=google header.b=rtvIG0bm
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c247f6687dcso421460566b.2
        for <patches@lists.linux.dev>; Mon, 26 Oct 2026 03:55:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793012113; cv=none;
        d=google.com; s=arc-20260327;
        b=BguJcm6FG1aRctb2tC7kfQV7tmFLVJO8Npf3jf07z2abHxQLa7eNAGEGYwNw5KUat+
         ut2lJZU389ghdtQC5IXEaU0m/Yd/MAJQMqt1MWlxIU4kpPruNDB9QTs568KpArot2tQM
         Nfam0H38XUDE8qAd09I988F2CsHsyurDbUvblWfs+7vT2DH4f4cUwFEz55AC8ZE2ZhCy
         Jl9xjTYKFY6IeacrEpOuKvEnTptF6c/2Bs0HcWK0+x+eH35thVNXblNTvvqn4XV97bvC
         tZNqsGjn0m4KLnOVqImr62RD/FpgD2ZP7id3UR12S2fRiExITerhGH5/ZTIMNJu3hfNC
         tRFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DV6c1D/6Qzh64saIkUPZG84ARZMJ/aLNg7R2bPrZljs=;
        fh=FRyTK954TZ848FW6+PTapjeCtuA7v4KXdZ01RCmuheg=;
        b=b/MAzvTndM0zM2nQRK/EQX8mN2RW/A88eCdoIbUAl3h4RbdlmT8nZssUPj/2a+rzOF
         bt8xEILMd+8ygjIeTF6AAm0akITkGMmVFV9rr7Y4VBjPCKPCMMpDquVddlubFAPqfSfi
         +mJqAD/9aFxOL2FoU1J0S1qDjvKonB4XR2vpWP/KIV7fS9DgYxC75qthmjyBjuaewUrm
         mEOajFPnEQJWXYDXKGc+ARUsdisnF1oi+qm6HCQbv6CFcz8qHyJqOrLhCfufHm3bMwU0
         iZkUmbSPLb4vLYjbg9AWY7uPBJjWEXZu0Uy8UGmU99eoWQMR3Nzcw8njwYct8fwKrE27
         3gaw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1793012113; x=1793616913; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DV6c1D/6Qzh64saIkUPZG84ARZMJ/aLNg7R2bPrZljs=;
        b=rtvIG0bmkIUfsvVBy3Kk2gzncqR3QeDoNAt8/POP+vRgLGC1Krz/DQySMB56i1Sxq7
         MJzlXEcF7RPSW0Ok3NXZQsDjywN3Lcs55rWt4j3/3oVhuq8+QyjQdItn3NCLeMVQGvlZ
         ubsk+ybcbPfZuUSrOh0/2KQJyMH1oEZjujVmqEuO1OJspp5tWn1WBqftsvRZWySpqkz9
         zqV1KbFu9Irb8wVkmoBpb+8sDL+2ONOLgMw62eE5OP2YZkrF4CRm2Vzex9J9Wq3RCqkX
         V3e6hD+fyMOELxj37nNqsqfIaNrX5l0ySF8kmQ/DFvArYRx0dfFTS65Vo2xblrhJHEbs
         2DLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793012113; x=1793616913;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DV6c1D/6Qzh64saIkUPZG84ARZMJ/aLNg7R2bPrZljs=;
        b=dF2DShAZ87raon/dVAsMXlhtg3rWZcTxfXROaSW2Z3F0JXPka2k9NoVMsuYl7K6VUB
         5YstI/5Ija7TJFdLRyMjYcs9NMGMPtAWXzPIxj/Um8/9mVhH9VRrRTEgTdKiIUcnOWc8
         xWru1rzPzZj+xGAUond3ZuCYRbmJbTQpput2tyyJwbkiqwl/YFXkz5b6ty1lmKI6stCb
         c2c+IjoSPFzPtm73g7sUzdFXhqYi6tYBX0LtAguCjrcL7OcvO5+Fal/1lsLpRB/EkNNc
         Zw+Soa8roEe4gl8OW6fNAvtdZj4ntbFY20Ved1DK97M81ajZuyUJYdxLt9J6Gs2sjHpA
         2HVw==
X-Forwarded-Encrypted: i=1; AKwUvBzFj9ibLxX5uVSAl8OqKdoveLEp5TN7MXN0/5/1MbGY2onsJ0Y3YBx9YrUiSQps6V0gw3x2ugsN@lists.linux.dev
X-Gm-Message-State: AFq9FYJs1b3gnWOSMyqiWqb/WdqiAmrRe0gj0LnEQdDG7xS4xhlM4kjC
	MvL+P2slIUtntNhWAi9edDAQyptVEOaUaY893oQk5TcKHbVI5GWZAl1egWAf6U9TL5auNQpzvUe
	/A2wVG119A8wnww3LGWGRPv2dF6b4Jc/SpOMTu28GYg==
X-Gm-Gg: AYBFou2hug8TuEnVCxOmvWje2WjjamSd/LT8Yq0MB7wloex6rgZI5TwNmvCbTrrEMDE
	9ryR1T3C4L1gLJ+n9dowV7IE0SwmKGsyFRVgGXkg5mrh5VMzCBq9VX+NOMKRBB2kyKfuVeYCGX8
	6et7cCfnZPxzjNRkZYbSLT12m9Ls6/Z4BDxuIkkOHEK25+o9aG98iSEWGAUrcuH4GQoUnJ9xfxF
	U+CdcxdUbtZ1VlUQiKNaEX3WQ2cnMUsrnGsiH5gD3u6VYW2O+u99Pr0mkof6lw7ffYDj/WFOSXa
	METbvdHAVbCQx5tnUF3IFe8jYwas0G0PM2SjiPiSDiuiP5L+CB2Uh19ZuTbRBbNxpfCvRbevyJp
	MuWPZr2sfhQdlugULcWamMhUWk+WYRpvCSd88GwaGVlSgFBjxqhS5X3RuQZJ+lofijLUmtTHgRZ
	4wSOSuR6m3NDYSFSk=
X-Received: by 2002:a17:907:868c:b0:c2d:c98f:4824 with SMTP id
 a640c23a62f3a-c46bdd91e31mr719992566b.30.1793012112537; Mon, 26 Oct 2026
 03:55:12 -0700 (PDT)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261025125805.309934791@linuxfoundation.org>
In-Reply-To: <20261025125805.309934791@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Mon, 26 Oct 2026 19:54:55 +0900
X-Gm-Features: AclHuK8segfbyZOPLnD6APqICZs0xovJLP7DGUxjOh2pTrAodUPaMgSRzdULPng
Message-ID: <CAKL4bV68WauVRiggnG_WNr74+L=RHpaG2L=hr=D3TMn-Ht4YkA@mail.gmail.com>
Subject: Re: [PATCH 7.2 000/231] 7.2.13-rc3 review
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

On Sun, Oct 25, 2026 at 9:59=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.2.13 release.
> There are 231 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 27 Oct 2026 12:57:40 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-=
7.2.13-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-7.2.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Linux version 7.2.13-rc3 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 7.2.13-rc3rv-g638c94931487
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 16.2.1 20260810, GNU ld (GNU
Binutils) 2.47) #1 SMP PREEMPT_DYNAMIC Mon Oct 26 19:31:51 JST 2026

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
