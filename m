Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC2B42065
	for <patches@lists.linux.dev>; Wed, 22 Jan 2025 14:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737556845; cv=none; b=sBR6Vse4Jec7j9WkalC2DWDimZ4R1liF1EqwGJnoNuiJg9f3PSILrHIcRrPHUA/w5AJiRO+OqwFXCTp1cJRzPNjA4VQ30pwZcX4NVMc9RL8A9kCXGCBLXG7uv0Q0TaZiNHjQtsJtP5jCaL4Rr5bZStKO/vlVxt7tK6LwRg/NteM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737556845; c=relaxed/simple;
	bh=LsfukF/yBfh1ci0CeM4YPAlN1I2R2qkAxmEyopkVvGc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T7aeFs5us190mDZ53H8EziOnne3CEyAow6MuetxUwwTdNdc5qfbgdT8rOrAlVJELV53S9Y8uE/knk32p002FbB/2ZagW3s/hsM0iZKY6hHBNawXnJwvm5/N1E2XLoN+532I7Yak7X/44mMzybvk9WH1uRadWQylcH3bUth+to78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=e466cZTw; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="e466cZTw"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2ee74291415so9489511a91.3
        for <patches@lists.linux.dev>; Wed, 22 Jan 2025 06:40:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1737556843; x=1738161643; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t6McvFRaJ5osHAYhUEUYsvwZIqCtrxvJxDD2sjjhlt4=;
        b=e466cZTwsQdcZK+FjUkfaLsjTTKu+hj+xC/YqeccYEBUrsRavfwCTFIfBlBH4UcBND
         I7UQLGtyIQrp9fIevE9WSNplCNCofeK3wpXwfoDrFm1a0LSYePL2eikcC6/78fbn8PWd
         jdszUPpqJ6jBTPKpY17j/pH1bwBiBWQUUA8huTsk3sL4cFdeskydB+jULP9TndqVS77s
         YwL44dVsRqxq4q+QDq4o5i2RbyP+3pX8pSzxps4Snn9P3dTxZjTZBOtAdv4/W8guf3ok
         gy603/XPyO4yfJvPRvZBcDxIhywtywFcugPGn+Lp+QIL/Jfs5khVbl89cJKKckXbBaQj
         8W5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737556843; x=1738161643;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t6McvFRaJ5osHAYhUEUYsvwZIqCtrxvJxDD2sjjhlt4=;
        b=XyucP244P64Drqq2d6bQq3dLX4PPXOuA0TXgKLmIVUsyPzc+AY51YiWAUbcMKoKUWN
         w1xnZXnNVp4cDQmO6il84xt8l75901RBx17nAS0Nd+SsdA07Dm7PhwBJYZ4f0WvhCo6W
         7/Ahoe9i6JtIWeuBZXfSkzWK71OEfQjdeDCVOircinyoYBwCdgSYRfPgXo1JLuvBdoqR
         5CuDbvGU7XY+aixoqm9dezOuqDIYVkRZOzyvahge/yi2Oeh+JIU+Oee+JLmBa0Wryk3Z
         lX3pb1Zn3w04Cq2syXPNi3O4840RG52+W0PbPW4AUrXEBUKSYlXZMBCamLgfQmNzRPsf
         JMLw==
X-Forwarded-Encrypted: i=1; AJvYcCUVJK0/ZJhaX+mx+VrRXCpeF5hANgydDuD3AuI0thLqxVmMn5VU5egsH9EfxiYF0uBxnt2BPCSV@lists.linux.dev
X-Gm-Message-State: AOJu0YxYgcPG6yTW/syeaFSTyD7I/jpR3aaNEyyS2RZ21uUm4jYRaQP+
	8oYFdqnDWrIFaPN6Kk3u/Rb7wR7bVkb6zxrpnrEkEV88BFsZ4gWk6mCYHWRymfbTbNKlbwZ3CrF
	8njhsKBDkwIliTuuS0tDpvethBkGmLXeWm5a00g==
X-Gm-Gg: ASbGncsg/d6SOZu5VjNB+e5z65Sxgt/rSJLHLVhS9RfydmlzP2gq38fuJb2sUttTy8i
	l4tzdIub4KNtr0tKERjqbP9n2et5+vMZg7FK29xuxI0KqgFyR/Oc=
X-Google-Smtp-Source: AGHT+IGv+GlnSom+dKcknTxqk+ZtvCUMMUd9EnJqMxMxHc4PjBjG5A40osvTg2dwXP9e/EwXwhDwjK1mVEA5Iz+pJ9U=
X-Received: by 2002:a17:90b:2c84:b0:2f6:d266:f462 with SMTP id
 98e67ed59e1d1-2f782d8c84fmr31882295a91.35.1737556842998; Wed, 22 Jan 2025
 06:40:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250122093007.141759421@linuxfoundation.org>
In-Reply-To: <20250122093007.141759421@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 22 Jan 2025 23:40:32 +0900
X-Gm-Features: AbW1kvaxMa-1XgosJuFYYbAaAUZODb3Ltxzlan0oN98CplTBoHkdtELScykbKVA
Message-ID: <CAKL4bV72AK1qSnPFE2JK18D-Q4mBvNPef3u5sqHKoOP4UvB0Vw@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/121] 6.12.11-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Wed, Jan 22, 2025 at 6:30=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.11 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 24 Jan 2025 09:29:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.11-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.12.11-rc2 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.12.11-rc2rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.2.1 20240910, GNU ld (GNU
Binutils) 2.43.1) #1 SMP PREEMPT_DYNAMIC Wed Jan 22 23:19:39 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
