Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E2A1531D5
	for <patches@lists.linux.dev>; Tue,  3 Jun 2025 13:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748958705; cv=none; b=SEKZxGvUSk1NBiOKvkmGB+UW/XlDnRFoW7PHJ5fKn/jbAZXd6VRUcNzvVnQ30b6lUek9f++gz1F2GF73KPy7v/I029HAmblbjEki3AyHxP7DVxEMCas8uWZeBTbEjVqHWDKQ/Q612SyBKdobNmkqfrMR4XXmqEcGT9mik/NCQXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748958705; c=relaxed/simple;
	bh=rFcIgJL6pSIoKVcI/z9SFNckeWUMqMI1IGtxsU9Wq20=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V8pUms4uj9iydb91xos7oCg3zuo33VJTH9bZnvRxekGTcwRWg+y/qfrjvkgG1Y6RMXSwQ5yKPbUbOlVOdxHvylopF3GX7zUHq1WwIlZsZGeI76HH6fxGci6zjuxn4sP5D17wMSqiTahk85ghK6VvRvBDHhXd/4xZ9EQvhVCctlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com; spf=pass smtp.mailfrom=ciq.com; dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b=HdFl0U5G; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ciq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b="HdFl0U5G"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4a58f79d6e9so22757651cf.2
        for <patches@lists.linux.dev>; Tue, 03 Jun 2025 06:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ciq.com; s=s1; t=1748958703; x=1749563503; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u43wnlxB4xsEV+8bCEfmi8jE6ClnVJwePdx4GrJSMeY=;
        b=HdFl0U5GEZ3d100U+YplQvGkktqk42Krf3BvP9JGEwKD4vI1O2JHAIR9gLsAuJXgjf
         vtgmc3XMa7xNy0zpl/WRy+lb5CGSrMRZygHaIiak3GigXC+uQwKGVYV7UnTRj8BY4Pju
         Q8IWYnWb29Jt/Ib8+0BVdQHVnc6aLXPwvZxM2d19tGarVb8L6QYF6m9DNJXE1Gdu3G0C
         +rzwaw6Qahhb6OXiI3YcyVusmypPUrO0GFHD1GH+Wu3t2pqDotxkMdag5iOdRS6MZoVy
         o3ZNiq9eOzk82yulYwV7r8qv/G46Bh8IRLUXiKrNou30uq4hlOHW5IkmUhJjhh24M50S
         HMCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748958703; x=1749563503;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u43wnlxB4xsEV+8bCEfmi8jE6ClnVJwePdx4GrJSMeY=;
        b=tLfTJMeH7r8uy4rK8ScE0e83DA4Roqai7ro7ABTl7UIPAgQ+Srg5SKzOTg54N64iE3
         T/WLtvj7DAXzXqvIKhiw9U59lm7UQpiBTQAMShDAWynLUofhtvjhvL9iH3lS1qHv2TZi
         /BTBOoNDXinYVFtkP7EAa1WxhbJKmLqIrmnWr9C748YtijyS7CJ+q4WZwnIEYjglKfA4
         fDJaDwl3OdQnN16M4SMBZl1p1DoF3e1c45ytdTwSyyYiI1ykje1vZ6XDyPy6mDKIkriY
         IHf4wYRysEI7DVZs6fb1PySLkQX4JCQnDltlhir0Jf+dT0tQyClPOeEVB6gco3fu0yZH
         9uqg==
X-Forwarded-Encrypted: i=1; AJvYcCUmigEKoI2LM2qhk8r8S0NxJXbitbF6ebuoY4dNogBNlG58d3tfoOOD0FpD7cBGaFFNZyXeDTBJ@lists.linux.dev
X-Gm-Message-State: AOJu0Yzv6y17lKwFseuAWWBmKzAdAc+Xs1Q9mZfYn+xAzuIvwqcfH+zk
	jx9JW2gDJqkQiMyjpk6G4LxvEF9CoSAelPrmYoKcBW8GZIsnFH2IVRgSqRyfVR2ywneU8R0yD0w
	oa3/gNXcBhT706r4yhYcjM+dn+13nQRKVZk2SL7BkPA==
X-Gm-Gg: ASbGnctZY+MvEDTtGeXAutcvYAVHdrzIgGl5mPNHPLHcMelV5Dufy6a9HKGau1CNr0n
	RDVWR9WsNsnQjZNMSzAPzA6D86s/FwDZ6njfUzqJoy6y92H4L5pEw3c9l+e+MuiLV83YV2X5sid
	3GunZ7KgRprmHnMqihdxB9JhGPCy86cLxH
X-Google-Smtp-Source: AGHT+IFQVvOosag3wuPv5W+XIJzYaSdxGYD1UMd/R8W8Pxh76H5erVKE3YMDyz7J1K6JRiB3EIiz78IA4aDaPOiyz/k=
X-Received: by 2002:a05:622a:1e8e:b0:479:2509:528a with SMTP id
 d75a77b69052e-4a4400b3557mr277320501cf.42.1748958702536; Tue, 03 Jun 2025
 06:51:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250602134238.271281478@linuxfoundation.org>
In-Reply-To: <20250602134238.271281478@linuxfoundation.org>
From: Brett Mastbergen <bmastbergen@ciq.com>
Date: Tue, 3 Jun 2025 09:51:31 -0400
X-Gm-Features: AX0GCFu5TBNRaAAJJpvK8wBD6H5lRVWrlVadCPrD1KQA20azEjh8PY5cFY_N-ps
Message-ID: <CAOBMUvhhS9RpZoOkgkdLaDv19VpGvSDab7oi7nNupJ-P4siD_A@mail.gmail.com>
Subject: Re: [PATCH 6.12 00/55] 6.12.32-rc1 review
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

On Mon, Jun 2, 2025 at 10:05=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.32 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.32-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Builds successfully.  Boots and works on qemu and Dell XPS 15 9520 w/
Intel Core i7-12600H

Tested-by: Brett Mastbergen <bmastbergen@ciq.com>

Thanks,
Brett
