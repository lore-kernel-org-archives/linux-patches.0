Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B3115ADA0
	for <patches@lists.linux.dev>; Wed, 15 May 2024 19:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715802647; cv=none; b=nzAFINJ3IXuqnvWsJKInO+DpIc6DDjyxMjlSbHWMcP67Mw9XPMX9Um3rZyKH5HJt281H224gmY8eOBo4EwkPZepLeHrqwjpUmIs+rYKM/rVvMNYvp2KgZ9Yp9qhGPBrQ0DhusAKlCzMNgshSNxlTRG7CzliXlb62hyi8TG7Bs10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715802647; c=relaxed/simple;
	bh=TMWtx1q/4CT0Ytzn0MpvQulQwB5i6wOAVyq44uuc7W0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I/py9sswHGeqOLUFP+jwi8P58h1L0yTbA9kDvR+fIWjAzT5yYdmPp4p8mdW9WigL7EMilo9keYtWs7NnhlT8SsKxQ1rwMRnyl8G1Zg8geJSno5Ia2SInonzu475fbOukpskcsmeCDRmUwxlp9hSx9w68L7ObQZWZBJwv6Mi6rhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K2IMMjAo; arc=none smtp.client-ip=209.85.221.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K2IMMjAo"
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-4e150c2106aso197271e0c.1
        for <patches@lists.linux.dev>; Wed, 15 May 2024 12:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715802645; x=1716407445; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8rcJ7Y7u5PRJkF+YuWFW6oG9ZRqMlT50WMVAy9pp6As=;
        b=K2IMMjAo8JYlby4MWlHEYCvfXpI2MsyopcNbZMhIxbMDijYdWf1ppGJ7lomMpiYVU6
         f+UuZSZAOqJSfqAcbTagBbpCHu17haY2SsFrNVvP34ru425noai0Q21yo9PWwWxcpbZj
         fEHin7LxPijVUZ6EJjRmU9uMn5ANVSLZ44Fjy4OyAEBZxH3x4FG9/OnZHMmUIWCEO58d
         gGIVyEGvCiVwESwHI0m85uQd37bfULvttWYhqcOl4GJbIl4Y4iAIoh9bqKTOGgJygpnP
         ee8qqn9H9oUoNL7d2DD43/ma7650hdyBWuD9zoUGVHJjhnIBGlUrEpdkP4eytYlvJlU4
         Z0IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715802645; x=1716407445;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8rcJ7Y7u5PRJkF+YuWFW6oG9ZRqMlT50WMVAy9pp6As=;
        b=pZgdev+K1wGwQi6FGrB3thUMV4erRzjfHeNXJYrNnvW0xUrUT7anDCJwE5rk5Pvbsc
         5sc9vfG7NiTsaEJpx8Dv9dZ8gWUOWSlOjh9GNelaYsxTCwCH+Otr+L5a9wEzBc5VNukZ
         Ft6rYpBX4+7rbqFyWQgCGFch6RDUdGp1gDhtGJnQJuxKT7WXQUgXpbJ3vSetMcm1JwF6
         ykcCR5Yy+3AJdglkOULYFOlr5JEIaMZSyNMOZm8K+aoDJ+Rx3mCPbEpGWuAr83xHxbc9
         brtZRmIN3qVyyJOUtRRRgzMiS5WEVbr2p/VAzQ41XD1uQFkAp5GDES5cPx7u/by4v8Km
         U1VA==
X-Forwarded-Encrypted: i=1; AJvYcCW8JbbXSqmNuiFV/RFntL48Ho0r+gPVk24dUHFLUAhD+bCv9vqfKF1FUB1+Ae02jySuFUpwlqwm6rXIvq64DzHZlOFbyH+/gw==
X-Gm-Message-State: AOJu0Yz+5Iv+fIyiFaoRaJQa04MMDgWeDAfO5W8i1c/wq+eujroclC7P
	6VxaKiyxdoPpTDXCz9BWK9iBrNXv31PU5IVwy5LvN5KoLxrPsAFRrm067VUexY2EQ5Oq54JbA8B
	sUwBr17SmjDjJh3nZPo9RxvSz9s0=
X-Google-Smtp-Source: AGHT+IFz/KDfBjvaBpcxctcufOB/sVB0Gj611XP5ZvaBwqRhFmoHdBgYz2KoqopVK57g1dwY8p0Szh90tObrV6db1gs=
X-Received: by 2002:a05:6122:2018:b0:4d4:ef9:719d with SMTP id
 71dfb90a1353d-4df8829edfbmr16056592e0c.5.1715802645485; Wed, 15 May 2024
 12:50:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240515082510.431870507@linuxfoundation.org>
In-Reply-To: <20240515082510.431870507@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Wed, 15 May 2024 12:50:34 -0700
Message-ID: <CAOMdWSLSoxj8_oG3aZyFw+wv_cUWU2ycnDvikpO-K_Rcsre6vw@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/309] 6.6.31-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.6.31 release.
> There are 309 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 17 May 2024 08:23:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.31-rc2.gz
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
