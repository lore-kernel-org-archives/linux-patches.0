Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795165261;
	b=R7bQcgy6W5F8Fr4DV/wW0pX+ToI1i7Wddhk5ZxKaFs/pzIu4uFh4IZYTQdmRMSwzdJ1v
	 z7knmF3xTYUrfeal79d09VDvJymvXL8DgeuLaxlr9kkUK+7ywcLbqcKdJrHrYVIXdLJc6
	 Kk0X4y+nPDMfZav9kJkzIiiN2Y7sm30PIJNtro88627Ds1dCPvlxquvuqRo6MfzTL2Cbx
	 25bw+P476lZZuicIE6BnMLH6mk619lXwP8i/rk6KmhoXrP6wRvY6ZBrQc0LGPuyvMaSkK
	 /si1J4bjpJSZxAm6SvNwDFhhFvlrjGtGxfuQBBtEK7Ts8n30MprZodzSwhCTcBmf2TA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795165261;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=PZieRENVmUX5OHXGvmzJIcsoS8CWVu3mfuhhXe7ha4o=;
	b=cHEWhJaDjIHiKxfldBJ7XnvyRFFle3KAKAnrr9LJZW3qerusnCex+hML9qIrR+1RYuV1
	 Zny3487yWdHyLWylCaG949ip7Q98GZRhHZkjCFIfkwRy/IICgPmW3FWMU9+H/R72ScKLD
	 t38eKYyi6ZkV29UtOc4s/SAVylVDAlmES5gQ1Pmvn4a9gTOSn9Z46G1bp0W1U35wGOAi9
	 TLeHCHj+BWFxPlG9hokJUaKE56N4kpkEMeoKo1FCnWGNK2Hg8jVfWUSiEaEC99VyHERBg
	 ZrjQXkzvV/2K7aBDU+MrXQjBslM+Hw7vPuKJ2TibZi9EDNtpE946XYc5lL2YUmjzYig==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=futuring-girl.com;
	spf=pass smtp.mailfrom=futuring-girl.com;
	dkim=pass header.d=futuring-girl.com header.i=@futuring-girl.com header.a=rsa-sha256 header.s=google header.b=MthRrWwN;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.48
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9723D606A325
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 09:01:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9723D606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.a=rsa-sha256 header.s=google header.b=MthRrWwN
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c4d427836e9so101631666b.1
        for <patches@lists.linux.dev>; Fri, 20 Nov 2026 01:01:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795165259; cv=none;
        d=google.com; s=arc-20260327;
        b=OgIobXbdXmUp9kV+5MfQ41HsM9zwJRZcQSwy4Zv0xWpkgKcgDStoTakBkLOQFeQ47+
         bG5QYLvOoOJIBJQc86YiooXeoY++J0njfTESsT6HEjjZffomz3ITYPeZzVATckWbgmzi
         WaD1vykZ3Nr6/P0SBM8X35RMbWSmO2yLGQlFgbc8cUxLNzj/Z6nMdbO5bx0O1pAezbeF
         KooktUfbLrXiKVpbGRkYnbMTnMZv/rxF0XGggPzymjRazCetFicggWiiDd0nUaHn6eFM
         eXZEnuy5XtLZ0NKhYohi5IosZybvO3hDFA5/0mT+Gbnf6z530uVpVFVOjOEUzUk1ZOtm
         3F/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PZieRENVmUX5OHXGvmzJIcsoS8CWVu3mfuhhXe7ha4o=;
        fh=HMRYke4OJqfyraU6qgMMHaiW/6s/JI2UGwUKxmgirBw=;
        b=p2+X+7jHnQ0KbXOcH57sQHTieX4PwgDT4P8NQrhH3VMgPbdIHumXQEuICawbBW31os
         M7R3vElPgp0IoOaM7Jk6Ivit0C9mlW/RLbcj+Zs6+iqKeEmtbc+7DYuMIxHu6u5rvC2/
         3F8KBsqU6oVELerN7Q3Cx4hWLcEdPFe5/gLc8s1uO4NZd5OTeoRpBCtKOxDJP034KdGU
         XFNfkUH04MJY5QgeTJuWWSEgPsuVwJVMBI4HptI30IlmxOmy1pMvgly2bF5iiPZ1TES0
         Lg9eFeioyO3lSxNNLP39J7kC64AmSa2G93ybA3jOVRYtTHNgp1+MmXdOUgsMBG2ZolUo
         5EAA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1795165259; x=1795770059; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PZieRENVmUX5OHXGvmzJIcsoS8CWVu3mfuhhXe7ha4o=;
        b=MthRrWwNqRLhGRCG36LH/ymZZBfW/eNldw2ptghEoNzw6LpWNJ/w1AD1dO7PEGHxd9
         lwmgOsBC/4B4su0835HV+N2eRF9ZGA1ptD7X4re8dg7XRm/UE1p1XAi8swJXERv/PhSQ
         ipFCO46JSHFGu+GOyhMmFsmEkjeucLEqILzkhlIjbh7AWADodMUnt3YHCqVQQuzkjTbm
         QbDzr/f5Iyj23k2vI3BN5w+CWk7h2zGK9JZZNkS+ZTWc+lfMMNRp1TVA0SkFC+3Cbnos
         D1HpkrHKJX+FR9WOMQvgWPJwxPp+KKk4bAwOPXb9ZObADAoyeHmZ1TQTxszovkSy0pK+
         pD5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795165259; x=1795770059;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PZieRENVmUX5OHXGvmzJIcsoS8CWVu3mfuhhXe7ha4o=;
        b=1U8n5Y31UK2PZwzPYApEfykHpoU0QGLKw29K1/amlwwKRKK6+AxVc5iZ0XqhbAaH/N
         o5e0BhgJPE+/9wmw8SiGMdGevYy7s/kzo1lmg45Sgrmf7tJ6Oo5odINqP+yDYIdsFSUc
         j+jSClux1Eo+nmbCvKiYLSpvg8zV8HTkIYMYVP6xoGZ7V2Ot8LbXkpuBBPm568iPvNYD
         QigJO7rkag1rKBBLVUnVDab/9YZdY1OIKoKFzUnNKwfs/bdTtUhZ2ZFl4N8Hzb2eS35Z
         zUKwZIyA/EhiyQ4BmRju+umK+kse5noC9trnJOZuwPcODqfZgYqBO/pLTXhXZm5a+YpB
         hISQ==
X-Forwarded-Encrypted: i=1; AL+hErHpTaWBs/0M6B11AqKLWaufDqA5QXo9YnxlAJy5f8p03/TTjhWFjQH+wgsnpEeicV4diCL5dZmE@lists.linux.dev
X-Gm-Message-State: APuU4Z93UEvpOwwl6rmvtc2z3PHXDP95Yu4+rF7/Ay8z7v4PDKAQ/nQW
	M+cR3wbdXeqQBpO/sgQydoSuFwbrvBlWACjb6K1rc6/EYnPHGYihySoEtJubuNAaQi1Dk6TupoE
	BstyAhyvEfDKcfhFQdMOmAdcPPp58GIt+HxrTVPw2Jw==
X-Gm-Gg: AZFdTZcJDSk6aYnm22L7IvKk3GF0W4ERT5bwdat3eXeDkDbjkWZnkqF+7c6TeMEauI+
	IZkFNc/QqZSCRtpQO7WNzYSMALQzbq5mlZJKjLIWT9yuYSPlYNDX/sKh/Are5oDHycebGmOY+uX
	77GdFHWQ3G3T9Uyq1tH+WPYRK0hySHFp22WkTUgTkZGJqQ/dMO+lfD/45HJVjt4YbSzhkkVNDUU
	dAsveuoo4lLGXsLBmfQt0mBXJEVTBh+MeJPbI4u6Gx3aAplZR2LgOYk6yqu9I7LM713bqm9pCxm
	Q3SZy4068KPQOCAwhhyOzCK16hWsu037bFXndfv9jnU+m68tNaKCjt1ybS5re/LO9sgUw+bDzfs
	WiXRhNe1MTJ3ZIJElUmMdan/seL/ubWsfBAvw
X-Received: by 2002:a17:907:2d9f:b0:c50:f0f9:ad74 with SMTP id
 a640c23a62f3a-c513a99aa4fmr235834066b.9.1795165257779; Fri, 20 Nov 2026
 01:00:57 -0800 (PST)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261120055248.913352689@linuxfoundation.org>
In-Reply-To: <20261120055248.913352689@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Fri, 20 Nov 2026 18:00:41 +0900
X-Gm-Features: Aa3M54rlZA_OBwjiZKWCvnO1fS0Oy5SCnCxiMl_HpsSggZDP4dM965l7S2Cnigk
Message-ID: <CAKL4bV6kN20uHLeG=ZV3FHe2HghsA-yRp3+YgCVgTvGybek5Hw@mail.gmail.com>
Subject: Re: [PATCH 7.3 0000/2642] 7.3.6-rc2 review
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

On Fri, Nov 20, 2026 at 3:04=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.3.6 release.
> There are 2642 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 22 Nov 2026 05:44:39 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-=
7.3.6-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-7.3.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Linux version 7.3.6-rc2 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 7.3.6-rc2rv-gd6a022cc5dc8
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 16.2.1 20260810, GNU ld (GNU
Binutils) 2.47) #1 SMP PREEMPT_DYNAMIC Fri Nov 20 17:29:14 JST 2026

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
