Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com [209.85.222.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B69252C842
	for <patches@lists.linux.dev>; Thu, 18 Jan 2024 17:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705597974; cv=none; b=Hl7F0bimuKQ6mwEtB93Q3oQnr4ShKFzanomSNGsCS2GW4my/ynJ+NYxVMdx0z8ZptHVWiUJIgwZud9C6jKXtL1hG9Jal0Vw1V4DweHAU7Y4EEFM1lDwZI+p/jQbwxyb6bI8QOt1v6boSJTeF/JiIx3YFIpsuCEuUYK+2fFdTaSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705597974; c=relaxed/simple;
	bh=BBxghMMGlXNVOZyw3Q9osEVQvQYCUfuF2q+P8DaL2ag=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:MIME-Version:
	 References:In-Reply-To:From:Date:Message-ID:Subject:To:Cc:
	 Content-Type; b=oTCUfrXw4/I4L4fDeUchIMHqw6B04d55HvlY9rzQ2SMzYaY1Pex7/fx99lezy0Yj6bSUfs/LvjQsLTd2mwpQsB+7gqXHwAzECH6XNvEpzkmquJBfT21Vbtax9Utp8h3cYbecumI4oaJftNKmI92KWNqYegC9Qu2jll68RlzqUFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GUAgf1M9; arc=none smtp.client-ip=209.85.222.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GUAgf1M9"
Received: by mail-ua1-f51.google.com with SMTP id a1e0cc1a2514c-7cbeaacbcb8so3454665241.0
        for <patches@lists.linux.dev>; Thu, 18 Jan 2024 09:12:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705597971; x=1706202771; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4AdGFlJ4DhT7muHzakQ8cGddPk88COkAxuUIVnIUfDc=;
        b=GUAgf1M9V9/2BWOKlZaCnEUsJd65sJLSATfSBzVm0ghDbxpkCzArDCwE1Y37ivjy3z
         YsXnobqU7TQ6BWzN1S8scF2XJDemNVrzRk7BCcaEzaw2Zrt1YIwgY2m1H7H72XfnYXV1
         1HZwRMNUYaYej3jeJgjZ2XcslvBRQ64Pgpi3+Og6R82lwf7+s3n8a9cuZeunBU8V2a1H
         DId4qI9mpBHcs5Yg93IlVnETaNK6C+4/OcJhB8lNX7IYFOPqqfYydlUbD2Q8wUP8J3OT
         Vlj0S+Xs++s/6lr2lPy5Os3fdbHpkoqG/v33UkhliOY1u4nL5tlWV7P34ZTdEgBwmapg
         83Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705597971; x=1706202771;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4AdGFlJ4DhT7muHzakQ8cGddPk88COkAxuUIVnIUfDc=;
        b=tz9PoU+g8+kUsETC1hbV/zc8sfZyL+oKBPgE1hM+bGuEsXkoIO+Jh+r82hL77SEVXm
         eRz+hSgA47L0MicZKY4ZphxswUKkZyVLXJU3CMa1MOqSNEWq4rni+xI57isHfPHVvyWu
         BUcUObbV629mMJryBjgIsc+FQZ/uSES6hV94smaWcymGf55zOKggGkeVg3OYmlBPppVY
         GLkfEQU9+kbfUDb8TjIZQoLZVC8ByHd7AIoXi7S73vZGWwcnfURlF4iqXwKhy4f3nKLa
         /oPBik+viuLwtPmXvcOYzwX6qxcpCj8tmcrzNsNOc/WEZRpFXUG3p65RNx/SF6yRZaKz
         mO6w==
X-Gm-Message-State: AOJu0YyVT4HldiJHPm+Hgp6+V7guSrz3QBUNxjf5UJxNAQJJLDazsFIB
	jSt4GNvXQ6TypPUSdAdCyMJBn5MaVz9h/p0l4s3RngEDdrSuOWBndpsL3/mXPMjxjRv2caXEBpq
	MOsHVPNwtbVKl5as3zh8SW/4xG0A=
X-Google-Smtp-Source: AGHT+IGmkC3B/dAyIjW4ywRmjABIZnyBByHvvtUw+LnR2JrcFmsnFYVncSqYWLeUXP3jAsxm8FeRPuWmmDC8OZcCvno=
X-Received: by 2002:ac5:c0d9:0:b0:4b6:dce2:23c3 with SMTP id
 b25-20020ac5c0d9000000b004b6dce223c3mr1015218vkk.26.1705597971720; Thu, 18
 Jan 2024 09:12:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240118104320.029537060@linuxfoundation.org>
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Thu, 18 Jan 2024 09:12:40 -0800
Message-ID: <CAOMdWSK13P=CoZqo-VfyPc8wMBJ0+o6SRmk+s2QDNetPkPmrDw@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/150] 6.6.13-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.6.13 release.
> There are 150 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 20 Jan 2024 10:42:49 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.13-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
