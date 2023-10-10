Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2859424C6A
	for <patches@lists.linux.dev>; Tue, 10 Oct 2023 15:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D8EJM+6J"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-690d2e13074so4358809b3a.1
        for <patches@lists.linux.dev>; Tue, 10 Oct 2023 08:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696950659; x=1697555459; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EgFuaMyHuuA4Z4cKuZPQOYAOGaxw9YhSSGYsa53WHvA=;
        b=D8EJM+6J+q8hnYpCYK/IOjZGTNygBm5K5uLLUgD5EUNRu4OZBjnIPM0Ga5w/y+P8rL
         1TCoMRy2bdnwV1E3JGdwFwAL8++d4ik8i9vIl+cgmN/TIKNaX2UQhVEzjHg0DaeHZZV7
         IisgUoiv5UIdzPS6fztIR/uoUNLU4DCNGcQH+nzGneParhti6ydwJisJXgcsWPlqeO27
         VWtOnAj3+aFNZWLwoHTU8P6KUwZgmvUenNHEdkVJUuiM+/Qz3j+faq+PakTT/ePxRchv
         krOJseE5yN5LWeg86gOf/t95gR+t87N6iHFO/DWtHhX8aKi5bck32Lu/s7ySluTABNvC
         R74A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696950659; x=1697555459;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EgFuaMyHuuA4Z4cKuZPQOYAOGaxw9YhSSGYsa53WHvA=;
        b=QEa1+ZXYxnFFnLj5+hmcNevnM8DQhaxAWIgmP1tcaqnAmG+z5I6gpbtTkiPr3oyHi/
         VZgujomQziyH4Snot85ql5lqPhmHzbLO97gZjcEIqqVpRQqBrKN4NDmTn/Dzo8ZDvU8k
         3Tvd5ebTCpD4IKNtz7d1cNG0ZtCu2ZISwvPDSCiwRF7OjpzAvUWBkWH5BcnEGZwpKEAq
         3RGD5lr0JPFhZrP8DeXn1ZCF7bp6rvmts3zZWDsMmMVpmpJklGBHPY6dO3Y1ofHQbAoO
         fuRAQH6wrDivzVS0fYjMysGYmxLEFjIz8bKNQPelpkiC93jMOUFvPfBQU5XI5/r2JIRm
         RdBg==
X-Gm-Message-State: AOJu0YwqD6+dWDILniT7JMnZDIHy+UFZF75HofgaCgwUC4WEjNypQs03
	BjkGsMRNCXcaIxprhasjTaHrsLM8VxHVYaZh8nc=
X-Google-Smtp-Source: AGHT+IHVhn2WL2v2vSMq4ifECus+idIWrGQvfwR9ivLh0JEr4CWDFSDsL2Crwm3sHsYMw15OfgafWIueLAOMt7lIDVU=
X-Received: by 2002:a05:6a20:1593:b0:155:5c28:ea74 with SMTP id
 h19-20020a056a20159300b001555c28ea74mr19193414pzj.12.1696950659348; Tue, 10
 Oct 2023 08:10:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231009130124.021290599@linuxfoundation.org>
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Tue, 10 Oct 2023 08:10:48 -0700
Message-ID: <CAJq+SaA5WVYqZeSLYP505c2VmvAXFuetdgyr8VDi6X_ukOaNyg@mail.gmail.com>
Subject: Re: [PATCH 6.5 000/163] 6.5.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.5.7 release.
> There are 163 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 11 Oct 2023 13:00:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.7-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.5.y
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
