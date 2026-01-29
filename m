Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52500378836
	for <patches@lists.linux.dev>; Thu, 29 Jan 2026 06:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769669751; cv=pass; b=eHzVLz3A2dm9Zus53AhhzxIG+KJ65HqnqZ7DUbLp3xR+f9t5EQ6IrPqElg3KXbHrz9e/y1sAYHyEYMvyKDdP/mV74zrAagY2J+AIgxsqIc8dnuDQa6tyX2EkQIUmJkEGhCLfHzi28XRdlwepmC89c4f4GnW7WN5983aLZxgH2T4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769669751; c=relaxed/simple;
	bh=YX+VT6G//hQzFKre4H4+dJSNx6e21J8uALflX/1Rda4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lJ7dWOSLT8OgerHzJ6fqeuPjvjJgfNKoMWdlKN/JNPpQeaziq845mF34XfW025Tkja6UT34VoieTrpA6CaVIHTkxjk3JbSxCbaqsuBTcCp6H9wd/aKk4pYLcLzZPsq/89a+ogUlwoK25k9Mu7TYLtPNNIOrgfjYBW5ZzUUwPem8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com; spf=pass smtp.mailfrom=sladewatkins.com; dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b=iGaCxXzY; arc=pass smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b="iGaCxXzY"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b7cf4a975d2so84570566b.2
        for <patches@lists.linux.dev>; Wed, 28 Jan 2026 22:55:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769669749; cv=none;
        d=google.com; s=arc-20240605;
        b=YIRleS5O14XyxAajAvYdqYVJOir8C/iOw8xXvAT13to8P+9qcUo01vFZPX2snX9T/Q
         qv+oE2w7jz4AvB/3TbDF9gNPY6yy10npL/B7nynZboJ6aSKFWNEA6dNtpX3eLZen9Ko0
         lX+9/AmHP7SfYJEg3mxDpnKW0rl/IAZIpOBjycbdgQzPGAH4pg3qD/yTfxFk2dE/UH/j
         fHZfDyYU9b8Ao+9zVVD/zS0pTO0kTEFB4MPUho5NAdP7XQh+1t/fb6BzukXE10I+w9U8
         6zkAr903J2eMVyocNZENMhvR8wE+n75bRuQ6fmcgZIpakB8eL+stwOIdI9jrZGI5Wzsc
         NxXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sQO5rKRKBQvQpktDVX5k3oNgy0DyD9YcvVc55rWtXVQ=;
        fh=Fwy05EEW18nsz2TLG03PQIJ5jqhYI8vHCzJgcDcQ+Ro=;
        b=SIEcipZCikXrQiOfE1wI+W1h64piUUn7YE+DScw6xMd3CGkclD0yt1sHxde+1f3F0+
         OoTnN/XHJ0LoJ1ozm6TK4v0VMsd7sUmiUVGDLnbhRulASiWEd6Asz/5bxoDUukZF5bjS
         GzFWMmMvcPLx175iOz4jH6+bfiGVfPMAtb8F6O3KDB3eULsNuc24AqXaDyVkMcf2RSlN
         02FPn0Vzfu5RGDM0e8hcmLZrsri+DL0hRV1xzHFJOyNGrVuyAEpVNuXdx2fh2V4VJiAi
         TiCvBd5gyDGUSilTVQUumoK0BLMCbVLAWJOpXsEMJKXYZwpK+LQZI5C849ZwZ8CVd62M
         X3AA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.com; s=google; t=1769669749; x=1770274549; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sQO5rKRKBQvQpktDVX5k3oNgy0DyD9YcvVc55rWtXVQ=;
        b=iGaCxXzYS17tT8CNbPwg6zDW1SmYKL3g60EHRCNXH4pFBfGStmspZsm3sFgnfMovQz
         M3zaY0Qi5zkrK9rXaKL0MjwQ9tG1Kw774ca3vxV4vfyQWtwM8q6mklGeOrCwikRMeHEm
         UvOwqLYEHulwF+t/xCUNNE5nJPNjlagKm4V4uL8zbEJJOaMDOU8EwiDWP2bGo1Ua2sk/
         jk7RIHBtDzUdYv6ivA7AwyNFlD0KgG1VDsxWT2Gpa7ePf/32JVmhn7OyHyHJwpa3oRru
         UnOwP7dO0GYW+xrkUx6woFjJuzJt3u7ajoylvjEhNaTBpkx7hQfdTn+9VZzPfoXJrxvQ
         UbDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769669749; x=1770274549;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sQO5rKRKBQvQpktDVX5k3oNgy0DyD9YcvVc55rWtXVQ=;
        b=jRAAqwB5hbrEgqchwXTdP6u8q0pWAdpi0978rzKoJBMBglDr9qeWS2SlPo/9O1vRUA
         CFkYJci8dI2QhpfoU8rY6zhtB+UdMa6tTzrnCxMWHxPi14fKMhat7s/pp0iX6qECIz9U
         tDMlCQ//5dQ9dTk9+jZIGbA38Ai3yoq2+ktzK8mp+olPMyRlfyTqNYy/RDzxsAFhf5+P
         0IwUr8xeax4jIeKFmvN+vxmhAB6mocg0mNy45hNUpYFc0OzGt43zdiQcSEI66PE78ms1
         FYG3VQvsmIOSFlgoANlfhBpFtuhJGm7/7xeL6b9y+RMnJn9xxtebEpnJPtnuch+WjQe1
         vDpg==
X-Forwarded-Encrypted: i=1; AJvYcCUvrnlCJeDuOlJr1ZuSv6aY36dJWlP8pNxaa504HZh41NZtH5BWBwUUtlQ+eGCidlAjkOlMMgL2@lists.linux.dev
X-Gm-Message-State: AOJu0YycAYGjFk/ObMbQ4wT2ROzyCjbryta7PV/ddrD1Uku1tQUCUEUe
	w29b45jYcLhD3Y9kTpFkiDwsmgSuIqA9pWNFd+tNK8w9NldxWiXtz45p8DP9lx5aEbRocIxGkAb
	nr5DonNcNfbE3l+IEpfyNF1XVF3tjDM3HzudR6Tzp4vrkDtCqxGQgBta5fj9tQFo5gqA2GDi2LH
	azd/JIi+euWRxJ9C//3ktgnEO+KoZk
X-Gm-Gg: AZuq6aJNgnyozzq57mUS/LIDdlTwu0BmEbaNOwoTTzfYARAIqUr1Y1wHwbLTfgXoKlv
	ypXLIkZbPR85My70bzeti695sIk/wGuaUkGgb5ZTdeSO6rIpRJSvEQGcGJq7V5OrKV4HYG5eBna
	AM5S7ndydrrdWeBj12dCqELkQu9J/89YbDvAGsYTVIjiJ900jpm7s+ba/ofY7AktDvd/RkjSY3A
	w64z2fcjcFvDuKpVyLoAGwi6S0M2rDaowSnKsTQ7LvmE1FS/TpDuar15xyMy5XpSAGkqCdPpVEW
	5Jlijmq1/ceSiCvmlA1fAJ/Pfok=
X-Received: by 2002:a17:907:1c28:b0:b87:d09c:1825 with SMTP id
 a640c23a62f3a-b8dab2bd67cmr548106166b.13.1769669748136; Wed, 28 Jan 2026
 22:55:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260128145334.006287341@linuxfoundation.org>
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
From: Slade Watkins <sr@sladewatkins.com>
Date: Thu, 29 Jan 2026 01:55:37 -0500
X-Gm-Features: AZwV_Qh5NgojKdDDaPCetv2klBsLVpmM8TfAh5a_KdjTwFgRdmpUzPubNaPNCfg
Message-ID: <CAMC4fzJTCRO=J7R+w1XqTe_cQPvo9p_Ls93aexd99qqRPwhcmQ@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/169] 6.12.68-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-SW-RGPM-AntispamServ: glowwhale.rogueportmedia.com
X-SW-RGPM-AntispamVer: Reporting (SpamAssassin 4.0.2-sladew)

On Wed, Jan 28, 2026 at 10:41=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.68 release.
> There are 169 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 30 Jan 2026 14:53:02 +0000.
> Anything received after that time might be too late.

6.12.68-rc1 built and run on my x86_64 test system (AMD Ryzen 9 9900X,
System76 thelio-mira-r4-n3). No errors or regressions.

Tested-by: Slade Watkins <sr@sladewatkins.com>

Thanks,
Slade
