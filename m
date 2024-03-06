Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA7913E7C9
	for <patches@lists.linux.dev>; Wed,  6 Mar 2024 19:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709752223; cv=none; b=Bf2nlUJgqC+gi9KznttWUaCH7bDkNsybKO9aHI3Ngu2rw0SN8/OpjzP/6v1hK8XCb22XDbJBv23hUQ2tO38MVvBCSw8b2N1766EsHWWSkb6xAd1pUMbPFHSNqE/wUV9F2r0EQIS6Ze7Z1qbh6Ue70KzwEtg7Fij3oKyGvmku7Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709752223; c=relaxed/simple;
	bh=7ZlQAAuTZrSqrwRUl2pqjvZmax0cAWYqHp5B+26aaJI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A+LE3vgfu2cLnhJE64aS1tQaZUB73qpDjiYm+BZqY03PinlFhd7FNqDW19+Cv78ngJee7vTBbJ1m9LIF6HGD6lzmRJXDLyIHSz++w+MaZDCUyr8BG6t7q+1xknXmMyldrI9o0NGjx2Z/OGwh5tifVFzbFhhQ7TslFSvHcShFtO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hhvzbXcW; arc=none smtp.client-ip=209.85.217.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hhvzbXcW"
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-472e7dc2b6eso14510137.2
        for <patches@lists.linux.dev>; Wed, 06 Mar 2024 11:10:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709752220; x=1710357020; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HZMgXEdSaT6HJkOI5fBfRL5/6AFPoxBmi8lMmVSghgs=;
        b=hhvzbXcWweAheT8VviXe0xWkEtiENBqTqFbcVMwJ7wkLdDKpgtaiKhqz9RTzvWnqdn
         x/2zet7Tif4vpAyiI1KOYC3b5OmBdze6FWEOF6q7JbbHFetGoP7+bCK/PZFTr0FrBmoB
         XS2kkUOfiRA7cKUcBJKzKl1/7u/vXzEpBmCHAlJrQQptPEMRekz+PU8P+XNk/0dV1quJ
         g5UlmZ1qG2xFRHo6i93O3y1Js/1wbWCIEpOmXNOUAqNJahwYjgfTOq6vFpwe3hK38g01
         a1gsc7SdAqACwIwl9SOl9jR7kZwal05egDeeEWGuqQ3xDI5ymf4WuQ5ZLaQx1oHjOwn+
         bVig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709752220; x=1710357020;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HZMgXEdSaT6HJkOI5fBfRL5/6AFPoxBmi8lMmVSghgs=;
        b=dUUmAcm/Cqe7nEmJ/SD6Km/6BkJ+DI1ajCF1DCy0dWHWvU9ylyWC3r4ihAO87g8iU+
         XzUo9RqgOevFtzaPamv9HUcP0G6Z6SCHirWM2aB1/rjCJzfA/vd/xw9HZS0ddYdRxnyv
         /6Lo5v0l6r/4I/+D/SM4FVj7ojGCLDVqXLcQ8Gum9B5BvC3x7wvAH39Ag5/swk74S/UQ
         xP2GMcVUOsyKPqn1YvKEu9bBWmI3uaMwp1GvVhq3XE6ancwvWxe4r7pKo0PZTex3rwxP
         gwtIiJVAUv4wwUGP7l/zdDrpVx9GKLkoSLMhzPXfXh4SLyZL2jM29pUh07S2l8F8v4Xd
         wNKg==
X-Forwarded-Encrypted: i=1; AJvYcCWXFFDpA7lqArWoLOweeYYnye8spB46f+ZAaXMpTYnCacGrD1p+mihD/Go8yS/BwHxB8EKPjBcQO7iQmYZhbs9YEAXyZMh4Uw==
X-Gm-Message-State: AOJu0Yzq3nstS+ejTBmWDjU//eYwNcpiOMr7Gzbc+LH+ocweZ0BkvhLX
	/zS72ih5BRtwf4ZQUNQxGvNgHOtio6ieA/rS4l+IYah8nP0eUNzKPcMMcjxLomjMgjHSwY+VEga
	Sj9Y7xfFRgL/TjbgBU64eThbkDoY=
X-Google-Smtp-Source: AGHT+IFhwUx/44qzGvR8hpKXNVsA0p4fq+LFRumMitpgUYpQZ2O9PVfcdQSDU4uyAP4fuJwo/aQm+6L9VrsFBL1iFPk=
X-Received: by 2002:a05:6122:4588:b0:4c0:25db:3618 with SMTP id
 de8-20020a056122458800b004c025db3618mr6312157vkb.0.1709752220162; Wed, 06 Mar
 2024 11:10:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240304211556.993132804@linuxfoundation.org>
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Wed, 6 Mar 2024 11:10:07 -0800
Message-ID: <CAOMdWSKmEzJa0bP=7kKSf3UV0wc-AbKW2mdA5=AC1DhM2puiMg@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/215] 6.1.81-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.1.81 release.
> There are 215 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 06 Mar 2024 21:15:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.81-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
