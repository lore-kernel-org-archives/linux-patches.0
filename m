Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9E6331EA8
	for <patches@lists.linux.dev>; Sat, 12 Sep 2026 21:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789248158; cv=pass; b=ALKPKfVRhkHG7+N+AwpRsb20HggpSNirXjjmFPEwjUJ1oFb6yTJ84rnh5YKEClQIpfR16TCoZRbG4WzNySwdjsF2/k+oSEx8CxrrmBL4ev0Cq0fPspTMEEUTDLNCPAwmEIDL4zMWP+1V4bS6q/lDA+3i4r61oawaE0zVXd3ysa4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789248158; c=relaxed/simple;
	bh=K6b4Y85zB8F+BBk4idWUHIeZSzCGOJi00zwSBhhsVs8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y8NekBnn2NtesbhQGnRfwJJTpEIdOKFbl/V5JBbCNEOpwptRMw4FuVJcRlTlrIVoIYyMqw6tPgnBmBdikWZ/gno/1KKDlQ5cfSB7PfwD5N5PIhJX2Nn86XCxUbZMN618g4/BaqMapxV3su6L16rR9ctEvcT3Uv9S9zquWDhwSXA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=QjGxqJNl; arc=pass smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="QjGxqJNl"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254f9f0b20so204910566b.3
        for <patches@lists.linux.dev>; Sat, 12 Sep 2026 14:22:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789248154; cv=none;
        d=google.com; s=arc-20260327;
        b=IK0YO/rd7vyaOSIjbfaP23ygsTZnqgAKpocdEXmPB/Jm7TOGxwbQghhpRMqwctZSyv
         rkQY00wDazcULF1ksVFnjde6Cc6eDcD6xRikOk+N9KAaUsQFsIG9w8CwnV+4fvODjcng
         zJPyFc8dREZYkmShbonlw0Z56mmu+Q7IlQauBi03E+a0EdBwlYm6pBVKkR+S/4bLy7qU
         YYpZaHwT+GlvbkgZ53TXRA7jIvMhZGLtPePXJwuNFz+W9hbs0RcVclY77K5Znyetiy9Y
         iiLFPJ/TxVtsB1DQgTBFBmFr7dOI3ewqUylWlwKSwVdF5JF1b32axTwLMeA0UoM2tk7v
         cv2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4+uRYIalsrhw+jlcX18QMk7mu25CKrBRK7xynbg1dqE=;
        fh=xejHgN7AndxgZDEdAYR+F/tPdyHKx5ZXHclqWGvrS88=;
        b=ZMjLCy2mUeJ8aeUvUhjShEOkvH0OSleGR6IO/HyDoGy9qALbLCbOy5CKA2ZZEAEoY2
         D3nCjiXhV3v1eP6m/A2bmQynrUWL3QtmAdr9n27aLiRhUcloS1RYtaV44grf6ZYF86PV
         D3aFKuMjI5xwHjNQPyNmByMj1wYMivOhU6krYO1bydyqORs9BQYyySS5O6CaeLGj1IJD
         kb8mzZeV0CO9Huvp4VW7aDZjm6Z4lYHzcgyI7XlGOkhcxJrf6u332pB62SsYaE1gAWSa
         3ca/N8k1C/JgLe23Zl5P7A1ajjwb2EeVHIkzghgovGiygiTJE3Fxb8CHKD2G6HwF2KOo
         w9XA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1789248154; x=1789852954; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4+uRYIalsrhw+jlcX18QMk7mu25CKrBRK7xynbg1dqE=;
        b=QjGxqJNl596bbtA2v7If/Bpt7RD+MQRbA6p5scglRRmqCF36EJSz4lWEPiBueViBqn
         xXb9EFH10jhm8UgF8+JL1rnmJC+aT43BQooGZcmO+ZfM506yWjURjbhFiA6Vv/rcENWV
         6M4bGqmLccZ7aAJiRhHw44/LW0GUCxzLxW2l7pPx7ZUFH6iHSMx2k5SBJPJ2uu+e7AgR
         pnJL6H1S1sFmBXeVMVBlC2nZFpofbrsIkdw5vxjd1azkVsi1C9teWjDKrUwnpOfNHeqe
         kGzEZlHhk0B3ZQ3mTAc24qokoMRQa3lWZS8ocTjIDvWAqGQpTY56IiHhYJS9IG4tAfsV
         z5VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789248154; x=1789852954;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4+uRYIalsrhw+jlcX18QMk7mu25CKrBRK7xynbg1dqE=;
        b=hQo4k5yuxIJ6gi5WuNoMUXWCsXnw+YSUU2JSZuJGEbn/H3vfgL3XMvVy7F3GUMYrDJ
         RG7OlHlNIVjGglf5mWyKadi9MtPxc3lwVlw9lyN9s+BegNDSQHlS+99Xph9c80+LxAfn
         akHc6zbAAaWg9alBXi4BMPO3l8wVksqbv9Wy8Zk4Z+P82QvNioKfRbDtBV+YeTSmNd8v
         VtnYczFul5kKJu5fAr0wc7wGlpVkRsPSEM1v8HXUDxDRvWcF0eqFm+wWitOajvqBQzyE
         G/tvQEuwCw5N2ZN2oLrqd2fXCaQkL3igoWoxFIag75Sohrm+19MXrJ0toiY4uTlAsF7z
         LAEw==
X-Forwarded-Encrypted: i=1; AKwUvBxDnMD0Rz/RcHKyO8aR5m6OZaqmcVnaUzg1U2h2EurqizYuzoKD7fJ2QL9lsnq4RA6SbyHWXWIO@lists.linux.dev
X-Gm-Message-State: AFuF++mmx7bD3tQ2BY+wG6OlcWbbGTwx29bvIm/8y45sgDonP+r3tJnU
	Rj75Q6L37hltA3zaUj5N25srrYgpyoOW1HFxJWchf3np8a3ZPatlu1obeu32yY7WdLl2BI8eVsi
	UrMnZ1dwHrizL4gPaWtUXGabr+/uNeWDWwb+v8rIr/w==
X-Gm-Gg: AYBFou3ngWGbCMa2PK0p+25tQlYp+PgwGaSq3p+xjaM+4HLeEFLxCPIrk81WIhjHiaD
	L+Eny5JdS7aDPVfzDDwGI0IHWuCL/+xuk3oG90zp2v+zWUQuhR9abe3D163Te+KhHQsr/7APtrM
	FJW490CcxYMmnucBMR76hgNGuukiR+eW/h0I/arVV5IKW8inI8QZRPeVBpdgG8k7GKhHVrM1bIL
	KOufNbxnEpbTEg+IuFZTQfC6MlYLaPmTeVIE9rHx4Yn9BAkwabIk1OVc0hJlc8n6CZRhcCW5oRj
	YSSAEUG/VIE30Eul0XEJCatoWB65+8QoDi9DEgH6JAeHP/KnBrwvsuyB
X-Received: by 2002:a17:907:1c82:b0:c29:6291:e38a with SMTP id
 a640c23a62f3a-c29665acdfbmr1025781366b.1.1789248153717; Sat, 12 Sep 2026
 14:22:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260912065648.999753832@linuxfoundation.org>
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Sun, 13 Sep 2026 06:22:17 +0900
X-Gm-Features: AcwNN1XKQfCG5_IOzoP0tn84TLT5vhownt9emT4x-a22NExaXwsm-snsvHub1FI
Message-ID: <CAKL4bV4_Pdw=pFU5RcCTpNuWmbYNeEB1jkCtwuaVNWJcMSfBsw@mail.gmail.com>
Subject: Re: [PATCH 7.2 0000/1815] 7.2.6-rc1 review
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

On Sat, Sep 12, 2026 at 4:07=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.2.6 release.
> There are 1815 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 14 Sep 2026 06:54:17 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-=
7.2.6-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-7.2.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Linux version 7.2.6-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 7.2.6-rc1rv-g048ea6124e84
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 16.2.1 20260810, GNU ld (GNU
Binutils) 2.47) #1 SMP PREEMPT_DYNAMIC Sun Sep 13 05:45:30 JST 2026

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
