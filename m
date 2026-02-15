Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19CF2DE713
	for <patches@lists.linux.dev>; Sun, 15 Feb 2026 10:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771153170; cv=pass; b=AtlVysqBFzlTuEny7zCs4iXY57XYLTDvL1qXrGMcWZCN/DSOoz5bmS+NjsjAt+iDkopgBb/+K9GXd15WU7O/o3QbSA5JdW3NZ5dCiByyMuJDeshBCEy9XjlYfVTjHmU0LDMblXLwyPQxhVLa513qrX1bEPBPeBezsRL43vBrtbM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771153170; c=relaxed/simple;
	bh=TOAJegcEhtu7NkrOnb60uubSW9SS0WjzepPMOON9eyM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tsy8A8dO9ujUfEWJcaCq0JvpwNKcH1P8BKydoXC80uZnMkgsBQ/SONbr27xyU5A/qPwC2tn33po4YpBw5m0rHdm4oDrm7L8qP0ciVpMcPYebgxMR6oC4fyTv/5/rBDLr1CdKSN7H+aH5JLD67GhDvUfGY5N+wGRDqMdVr437O4c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ikt1ZubW; arc=pass smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ikt1ZubW"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-59e699310a8so2662112e87.1
        for <patches@lists.linux.dev>; Sun, 15 Feb 2026 02:59:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771153167; cv=none;
        d=google.com; s=arc-20240605;
        b=gWO9jz8DBGLZQCepbCDNB99/aQoGv+Wvdr/Zdrh2gZgfYIwHFpU9xMip9zP4gRW6Au
         kLfb2V0B6gZlA8OGEX1aY4lmkOTpf97MTGsNUFCq7WLpVACxCxPHXjZYQAYfA/je1axj
         51R1j7q88S1owdmSFJaWW7OJrbFFlMGlGznHfauUxO6g0azQOW2K5D7WPYelfjWGoi6D
         NTPr1dz+jx1gVmzE+SkyV9XTXa3NEWgpQLqCaW4TQKje/wgmFz2SlBQ5b9uji+EUzkak
         f6DebhaFeyigKBpAu56w4dhGc4Ug9/43jLPYKA8Zp2cm34z9910NHgujrWmQE3dTqOXr
         8rvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/AID5hOUAIZxGzgNR8lz3CVvcXcQ5J8kmxWIWetV/nc=;
        fh=7a0eeyo2WdPUt7H9XLcvdO1kMJjQ0ItuhoDna6LkugQ=;
        b=SFsLH/Llw1FYh10yuzEBaEVFkMZD5w5CrrCuo/kuDKZ0k8L7u76EroQ+3nNPoyuig0
         1OTlAaRAvxEzX7mFWP4dyKeJywuRbyr1X5MYwIt65nHer1O0vridkfF+PSKhW9+ipzEJ
         TIt4kEdC/rdLQg4If9IzARRV5zKxc2iX9sic9PFfd4jYreX97YGdw29qmH9R6YR9jQpi
         4y36qYjnjPg1xBLyisoQV4wrGiQ784u7A8VO2+l7wt8xiF2RzshBirbG4eTcoMIl0PTT
         Q86/vdEsLNCuqfQdjhUJPHfQH7hHHgZtJX+CTAXQQyDpfeR6EC3AyupIYxdQ0UKwByX9
         9FHQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771153167; x=1771757967; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/AID5hOUAIZxGzgNR8lz3CVvcXcQ5J8kmxWIWetV/nc=;
        b=Ikt1ZubWkSMd9AmzxNfCZPV89eU03cHTKUZK9jOHCDCAxVk5fzztt6p/qvppwWavtS
         mRsPyYF4CZ4cbKe2OMPYkJMhpWaDN+JNUyM0lbOTNAQw8yzYcMRReGYBgZkxUyTVwmfE
         n0KFrYDoO0wlCQIGB6d2b2jCDgBAFDQqssZ7jR/pX2dBgKUn0pq0eR6MNvrYmpQVFB9+
         fyDKorCNU/dJ3hat9AuTuX19edg6tLCfQPFF8W5AWZypeBRieO/Bo48INL5HMnHcUvky
         f4oUQP+cUdbMTarlHSTPtY83sQBCVwoJNBwCGfvXhWeetxpDXD4S2gX3p7C1koHDNmum
         eIpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771153167; x=1771757967;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/AID5hOUAIZxGzgNR8lz3CVvcXcQ5J8kmxWIWetV/nc=;
        b=q4Jjxf9qbWwyvIZ6SgAQB0V/aCUdXSmpcY01Ij+fu8hOp76/V4RwRSX3kcW+LomFq1
         zuJ5ZaM1aUWR65XdRX5lMZ0vGTOfwDn0qIZgjhdFy3rHsztackAqXSo4N3yVCdz960aa
         9yPowyHRgqKrp/vrZrN9GFx/QbcV3zVRiSe1+1PKORyLbyA1onGGSAJHtFnGg5tXacIx
         Bx0Rv/j8jDjm2Q6DQF9LUgTvaqUIjRJZZLWrV/reyxszOmdVgTWeYvmic1pjyvCXZdVW
         OZ9Qac34WvHAmy22//0RSa0Ji3hTQu3vkngKKxU1rqH5u7aFjrtYGqBStp3ORrZ7iO62
         UEKQ==
X-Forwarded-Encrypted: i=1; AJvYcCWyZu8HCmhfAQVuCzO9kM3he08cyjHsLdywii8Ff/l80y97WjMduQghN1yi5nNJmOgi51G/lAl2@lists.linux.dev
X-Gm-Message-State: AOJu0YxLYvIZ7dbSBhVPoinlXiXZJeqGXzHw/fQhCOIjryfe4EMXPzwj
	gIPV8H74tSE4ci7PeGQJW5bfaAzbd96cXLHfDau5bJCRSJ10h6n6O1d7TLcEHtgenxlSGqX4atf
	eV/NF/HJkfHDoqU7NlE0ghlAWc6nufZQ=
X-Gm-Gg: AZuq6aKy9N7O1bmcnYAEEl0Pk1+BrQAIaxQMYka4lLcqezcwMaGcmk5/VmgBG935Tw8
	Mu8RfdskDvqAUKWgbnLuvNM0gK7k99CFeLGk87uAm8vb0dVxWw0cGCXyg/x5xqKaikuDAGuIQ+J
	q1j9WMSFF0C8kvB2GlHmn4OJ4NX/+oxuyyjnzDGi1UlcynddSD/yDXdJ8dTq0CpE15uhhpX7ufj
	6f0oIO+t4Je7PdQZ10KyhCw4CwPxEETnsOEJQPvkPNjJIQRNcgLy72QqSjoo0LZbAa9gkbvoMFv
	U9nZ7hDnlT/zWRagIMMLnWEFuwZXwWHFQYJNAnBV
X-Received: by 2002:a05:6512:3408:b0:59e:6297:a057 with SMTP id
 2adb3069b0e04-59f6cfb7190mr1516031e87.6.1771153166608; Sun, 15 Feb 2026
 02:59:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260213134708.713126210@linuxfoundation.org>
In-Reply-To: <20260213134708.713126210@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Sun, 15 Feb 2026 16:29:15 +0530
X-Gm-Features: AaiRm51XzX5HFwaCBQsVFAHLFio2cP0DEMw9cACKHq_SBPKzYKfGXKwU5kQcY_U
Message-ID: <CAC-m1roX0qFAf_ES6M=f=qLggY1do4v0WbkW76Ch4CWz7=Xehg@mail.gmail.com>
Subject: Re: [PATCH 6.19 00/49] 6.19.1-rc1 review
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

On Fri, Feb 13, 2026 at 7:21=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.19.1 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 15 Feb 2026 13:46:52 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.19.1-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------

Build and boot report of linux-6.19.1

Build and boot tested linux stable-rc-6.19.1 using qemu.
The kernel was successfully Build and booted in virtual
environment without any issue. No dmesg regressions
were found.

Build details:
Architectures: arm64, x86_64
Kernel version: 6.19.1
Configuration: defconfig
Source: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git
Commit: fdd37e7f30acd1978b8c205b62562dbe7b17b015

Tested-by: Dileep Malepu <dileep.debian@gmail.com>
