Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644A1301004
	for <patches@lists.linux.dev>; Fri, 16 Jan 2026 21:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768600567; cv=none; b=p8bRmHcxdIWd4oH/h1mtzXrALMkjW9795XtyuL3peJUeRWZZNevcMxEzcRUmQsAfp9/yu28lrin8a0mfhM+5t16k6V6yzzwCaFwTaFcLJFg7GFls+NBIN5X68iZYaNN8KG2TPO5qCP6ieSQRce6jgwPpk0l+9nVGh1AgvpCW6Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768600567; c=relaxed/simple;
	bh=jQKYgO1fO+h99uxsyrogt/jaI/NAbt/f7mqYugBO8fo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AeWrivleaPWcMlOxefsLquTfPazxHYfqNCuilhLkEn12u9SMbv2d5zZZU0x7Sw3uvbRS/4phXSWZNx6cq1mXVmfBVFligS2/+Y18ankkA9hrg8LRVFsMjdv3JG5UdgpYqTRpm1LIKAOgGDEJoL8tj/vQBhBvuxLqIUg1AdSrZEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com; spf=pass smtp.mailfrom=ciq.com; dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b=fUno2V1w; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ciq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b="fUno2V1w"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8c6af798a83so50409585a.0
        for <patches@lists.linux.dev>; Fri, 16 Jan 2026 13:56:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ciq.com; s=s1; t=1768600565; x=1769205365; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8eZ9D0LRjF1zjIiPIQ4+n55pi2/vjND0r4M2Z8nEoV4=;
        b=fUno2V1wXg3U+UtOWiNS93YCGQmJnAwjC5uxY30uf2xJJbnHpQMFht4rRw+XCzAvjB
         dnSusqRj3mnqhzUc5hl/YTKyr4S+J5cY9P0HhfVOgcKWjKGDoiIwgwSIL+BilQfmiaTg
         JJBXvvnIuIA1T4wxmmiOSsuFIY3dvj0hl1ha1z/EOxo7rhuTK8wzaummgYM7/dmHSjgY
         2CxqoieaBE05j9wyhKQn1L/OiL/HgmKGH84mmNflISdS/VYsi7tmPhm2cHYpm8cr4M/U
         FY6IxrJw0WSGfPWL3Kmc9UrIZdxm+lq+8zWSObRG6S5FQgunXAH+QOIkf6I7Jxixfg0W
         sfew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768600565; x=1769205365;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8eZ9D0LRjF1zjIiPIQ4+n55pi2/vjND0r4M2Z8nEoV4=;
        b=eaeOIAsaqlYd0DbMEMVCzawAlJQ8Whhp31CAREB8Q3Dy1A8kLWn28WRMbWE2qkBscn
         lRFv+jpdY4kLAm9edYDfJT+bjS0v8zIiLIpzyusj+5zqg26yh9oRkMH6qnizgkSHiKlC
         3W6PYqjk/ed9qcx2b2tY7BwxqPmk0+5lbvsQmLsxEBFTngDlACVhMVOiRPtGUxBSYzsd
         0l/gnXvde9rhNd2dN7m6/o0rnjQ0tyYH+x1kDhXNXDfsonri8kEgHwx7JnQldI0XKWBU
         Rnpjpclydk+YcnxVcPmkx03InU8iS0CoVOXv+PUd/o6i0dEH3+Irr/lU7mCxAcF2l6H7
         ZD8A==
X-Forwarded-Encrypted: i=1; AJvYcCXR0VGLZIdg63wGUoRyq6XHCRUEDXYKTV+0AYb/1Smoz09bqSXWwBjYGPDfIq438v7AttMlblOl@lists.linux.dev
X-Gm-Message-State: AOJu0YxcJKYMesPA7oJQgoijFYinqgutP/Lbr42QDYAbUxS62dGNcyRG
	yb9/CtGVZuQSPNWyCcfUGLr5dtnEgtB67GJMPKlHtKnW92/3s3+BV2r+cWQgAz9+nOIFooqdktR
	x+vPGbGDWLuYerTv03Vw/EaETgICx4FHPyTJXk8MsJg==
X-Gm-Gg: AY/fxX7r1RYTHfm6VjJ+AyPZJyQcZ4OYjfKgK/GuRi4+Topgz4JtNWVTc1H6eR8URKg
	GbwInPDnR0yQmLGDWhAVShciILHHmMcjW3xlQ3dVRODsmEbU8ChT3XzFKSmElq4Guz97JvBkzRT
	a9sOlWbcxsy/Idqbh4tsB5qnu7Ano0AHWthCfMtBTWitcXDtOsFWrJ/nfgVLOS/pQTfE5A5GtP4
	kDwJNT6wq4Gp3feAXaygu9BUWxSC1wp4FfJagK0OxZru8U7l7Bz6+LdJn+N6h5GYPQvDfepJrFk
	+pggY3c=
X-Received: by 2002:a05:620a:4054:b0:8b1:110a:e14 with SMTP id
 af79cd13be357-8c6a67648cdmr581602085a.55.1768600565283; Fri, 16 Jan 2026
 13:56:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260115164202.305475649@linuxfoundation.org>
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
From: Brett Mastbergen <bmastbergen@ciq.com>
Date: Fri, 16 Jan 2026 16:55:54 -0500
X-Gm-Features: AZwV_Qg7i-GTu8egevic-3fB-43vNln4v5HedxwZ0L7EIgpkOdNYwGQZdioya5M
Message-ID: <CAOBMUvjRY_U-hu+nk+Nc4n5WRwaFSM34YFqP8P1SvSp1uSSzeA@mail.gmail.com>
Subject: Re: [PATCH 6.18 000/181] 6.18.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 15, 2026 at 11:54=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.6 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 17 Jan 2026 16:41:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.18.6-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Builds successfully.  Boots and works on qemu and Intel Core i7-10810U

Tested-by: Brett Mastbergen <bmastbergen@ciq.com>

Thanks,
Brett
