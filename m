Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A6258ABC
	for <patches@lists.linux.dev>; Sat, 25 May 2024 16:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716654294; cv=none; b=OaX+9F8Uc7Fo+De5RMkj6czdDYjx0j7kOhKo3id8ORMHkETZofkAwAAWPCBow3RSWKgk7XsBSQSC8bctg+thAK401E33X2RiAUFfc/R+YRDf30XSwlmK+4eYoIJz+pKXrI14bARuoAOY6C7fnb3wRH0lXPcJ79Hj6iycDCE8R58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716654294; c=relaxed/simple;
	bh=86AVJKuhdZUAYzX2g6oF3oFG/tJCgWUrWARGlNXmoc0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ARU8iMi2fiRionkKRYhEEeXKOzWQVCg7FaboPUmwssFM4BgjrKQjWad59z7KWq54u60RON/62kKLSe+78EDGeR8U0frrCBCWLXtTykfoSlP/qxp0cFJg8yOqFG4UmEtyqdYcURtjtiLWszsCXXg9BVTojH4zRq+ODLNYhPSuQ0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HsFjhbmB; arc=none smtp.client-ip=209.85.221.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HsFjhbmB"
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-4e4ff43680dso531589e0c.1
        for <patches@lists.linux.dev>; Sat, 25 May 2024 09:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716654291; x=1717259091; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=C10eo8thbRqiep/D1Jvta7yZisLgi/lEZwTUZMNg/g8=;
        b=HsFjhbmBbj2hGf3zSQ52KNdQcx/4v8TpBqNYdIlPNDVG1wZg//bQniYC8x5qbArrGx
         T6eJR/CZ4Wdb7179ffl3nVHcV0u/QN+w0D5uESGMHdE45lxhJynLqUkKWerxhwnGo8K3
         N/0HWWY4J599XMbEino1VOwzpSzTVAKX/wIDcquV+0vAKxpdKe+QndpRtSKWmtLrBIZu
         XrVVKtDV5FXeHcef/tdTauST0IwyiLl+Svjlq/Ylu8y2nySrY8r0lRraKVZDNKr1vseA
         g32Sp24ySVIap2mItkisr0YsVhJrMcfI74prtoCHCw9kAVkeCnf3sHQ7PXhymjS5sb4m
         dKBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716654291; x=1717259091;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C10eo8thbRqiep/D1Jvta7yZisLgi/lEZwTUZMNg/g8=;
        b=pXtu440pIfrbnldQCw6DY5eEOgb2pn30A9e3rPXFnY4yViGJGxQLzMGJ9Rj+yAf0k2
         ylkzmvUL0gSaBHccxxV1Kl/r59JskwDbMjarCS2f8nbcN/wuCPt4x5Nv/PyCta61Mxhg
         TlgQuhuLWb6kCqRZ8uE4/JhgzzSSuxJmgL5n1up6yl8fMNdV5HQnEEoCMocGdE0DcsDd
         7omzWDJtaDvsUk1lCPZ8LVdMDps5FHN9la5e2UEooKb3yfFIWeK6AZ27SBJ4rpQV35lB
         1ZWmfpahmNxfNAYB3nUrJpJePUO1CbBnh+4w0tnnVqsL7i4ZTkgO2df5tFNPzGdAKEjc
         0yUQ==
X-Forwarded-Encrypted: i=1; AJvYcCWwxJNQnqK9UuadZafHG+jtnORIdxh71K1kozmm7/xDLgEfkfXCQgXlEbDw551bMR0AIcv0M0QRpSyQ1UloDniRb6VlfekHIw==
X-Gm-Message-State: AOJu0YwE9sP6pTWg1kIW+5+N/y4UTF0h0270jH4JIykrOkO+XWgOxDpl
	IUr9Y8P5VKzSOZe9GJwUnVrxnJqsbjeD99wQ5asZYrD2LH7EaFzJ5PcTftOeeZIL7hkrtFlTJBS
	zIUJ4gKhQzD8bu95lQOoWLowT9gA=
X-Google-Smtp-Source: AGHT+IFId4xEaD4/ofxKGNhKoPOyE8jZ3s7P0t1ilfqVQ1iQY6jvQOmdiFltbAST5U4WtGcX9TQp6jPRC5eHIOtj9zQ=
X-Received: by 2002:a05:6122:3114:b0:4d8:690d:c02a with SMTP id
 71dfb90a1353d-4e4f0230564mr4693418e0c.6.1716654290006; Sat, 25 May 2024
 09:24:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240523130329.745905823@linuxfoundation.org>
In-Reply-To: <20240523130329.745905823@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Sat, 25 May 2024 09:24:39 -0700
Message-ID: <CAOMdWSL+_5+nq2ToLsyW=92u9uxWVL8z9Pw3=_mp-KX9_rwDWw@mail.gmail.com>
Subject: Re: [PATCH 6.8 00/23] 6.8.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.8.11 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.8.11-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.8.y
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
