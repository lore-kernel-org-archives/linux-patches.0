Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com [209.85.217.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C92B25D548
	for <patches@lists.linux.dev>; Fri, 14 Feb 2025 12:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739536195; cv=none; b=d1xRLJW6qbCqyExXR7mKVo6E+PWvmiUGZAyqYKV/J7pLKR/B4BFmX5Ur8uzm/DIDNl2oavlD8nEBJ4VKbHYHrBe7DfWe731Y8JfRfK9HtggV8vYP8uHGRMrOq2FjW8L6Y31XMDMlDTjB0GAOsig6O/HwX1xyb7v0UBOD1rXW2Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739536195; c=relaxed/simple;
	bh=o+9eJVl8CwL4mxIer/X2JlMnYjvZGgitWo5E6XsIP00=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mEiMhumquzEZ6X/gLqb5UwmORkw9DqorRTVe1Z7AEj17aGjJtofpCjbHR/6XTaDnVVHUfC4Kmkvl8Hc3zlUcyNJFq1lBZKfuvxmACOhVvcU+UO3UJMn7swt/ZIZCCRC8LxOOcNNkwIBtzm9+d14rq5vCmfRMk+wHKHPyjBYrOCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=el5oUDa7; arc=none smtp.client-ip=209.85.217.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="el5oUDa7"
Received: by mail-vs1-f48.google.com with SMTP id ada2fe7eead31-4bbeb009101so613141137.1
        for <patches@lists.linux.dev>; Fri, 14 Feb 2025 04:29:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1739536192; x=1740140992; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lTFbAU7wJoF4fOBfb8cWjl4tFAB0huVpYXczHim4Y1o=;
        b=el5oUDa7O9GpBER4FFYZ7abj/YJlcRmYwXqwEYV4EmTgm9RXvUJe6x2rnsqeUtU7qg
         tRzKZD7ortnq4rO8uy2Vlv4JPVwWZUvt0MgQipGe+S0zMsJ5mmb6QcXwPtXHey2OJtXr
         YTN/c6X/lah8j2aqyAQRdiMyHQea7b0B7MZkLUYLLw4Ozn2xpyCKRbcEKQX6BUO1Vw4N
         PNS6kPedb8QAJEDtoWSK1eqZiEnLUXnfLtVfcd4GufoUFMk3fX7DnKSGNfK6vtoI8+4q
         kcbik5LETxDTQsdZjjC3p+9oDYQ57DliTnNj0U0zV6tWXTZsQ3B5zRtyRHmQ/hJYFdd1
         UCag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739536192; x=1740140992;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lTFbAU7wJoF4fOBfb8cWjl4tFAB0huVpYXczHim4Y1o=;
        b=R0EPWHX7FT8RX/FUsQeoClarUvs7hB2bbvbmCDZCdKddHpgGGC5zxa17jxZz3Vw+cx
         dao70m44XyblQY9Bk4wdOcw2rkqETzurCbq7u3921ecw0YDL/9MVHPdVkdSkxXHBfBZx
         R3SBikxpgc1Gn2SMkLngQCu7TKUGccxAY5xKoV0wHeG3cu0pZzI204EtvCbkmjX+NMar
         HUf+ex9ZyryyeXbCWICi4hwfPg2abKy8oXIJTI6/fFujd1Qa6GB9edr860Btb4jxh3Pi
         BSli32+9uvWJ8WsWbnD9QLK6hb5NWUYEt4cySITmXt5A9mfR5P3eAVMHJyEc+hbF6NZo
         6Jcg==
X-Forwarded-Encrypted: i=1; AJvYcCX4NVl5xMwccRRRhvXvOH8kPcb8GuekhsAZZTty8QnfY/R1UmSO1lVyoNtaj3Le6cIO7xc6BI9d@lists.linux.dev
X-Gm-Message-State: AOJu0YyaYYOsWVlffYfbKauf0nfUU7EdJbDKvpgLxklWEyhFy1Q18Kkd
	nokvPaUltU8GvlUd97WW3myi7cyHFb4K/ZSKewYsrvfK9tVmLERet8GI0d7+nZ1LXNSoQH5d4/W
	NgqO+cOyW9OmeNCzp1bX2UuxNyMMZuyNnYw9z2Q==
X-Gm-Gg: ASbGncs2zRNkMJSKlkW9RqvbsgoMtjvF6D/u1Ctvz5BgAB8vfzyNWLGabLW6fmFWgy/
	I5o8CNqwDHXxcyx2vqr+BKVhuZCUMC4KoByB9StmkCLHn76WTBJxmtadsneGSBUdFSRsT+zN8cc
	4df0QgWcpy5LYJfNBrlMezC2J8oK4jyK0=
X-Google-Smtp-Source: AGHT+IFayjXgqLnPIi5Gj/6+Fnamdf+uE2pl1g6krTGZMHKX9RJajOKZ81JoDlIpuTxR8LgZtuj0I33nc9DhR+zNH3w=
X-Received: by 2002:a05:6102:3a0e:b0:4bb:e14a:944b with SMTP id
 ada2fe7eead31-4bc03781b64mr5853377137.20.1739536192461; Fri, 14 Feb 2025
 04:29:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250213142436.408121546@linuxfoundation.org> <CA+G9fYuVj+rhFPLshE_RKfBMyMvKiHaDzPttZ1FeqqeJHOnSbQ@mail.gmail.com>
In-Reply-To: <CA+G9fYuVj+rhFPLshE_RKfBMyMvKiHaDzPttZ1FeqqeJHOnSbQ@mail.gmail.com>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 14 Feb 2025 17:59:40 +0530
X-Gm-Features: AWEUYZk1PwH1MSNr9Lf4hA8ve4s44k0qj-QHXi0NZuppFfQe21jEYySxIYPOqJU
Message-ID: <CA+G9fYsVFoLTXYBqpeUN1VUTwy5kXTB82fztK62fMPR6tYxChA@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/422] 6.12.14-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, Arnd Bergmann <arnd@arndb.de>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Anders Roxell <anders.roxell@linaro.org>, 
	linux-xfs@vger.kernel.org, chandan.babu@oracle.com, 
	"Darrick J. Wong" <djwong@kernel.org>, Long Li <leo.lilong@huawei.com>, 
	Wentao Liang <vulab@iscas.ac.cn>
Content-Type: text/plain; charset="UTF-8"

On Fri, 14 Feb 2025 at 14:16, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> On Thu, 13 Feb 2025 at 20:02, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.12.14 release.
> > There are 422 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 15 Feb 2025 14:23:11 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.14-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
> Regressions on the arm64, powerpc builds failed with gcc-8/13 and clang
> on the Linux stable-rc 6.12.14-rc1.
>
> Build regression: arm, powerpc, fs/xfs/xfs_trans.c too few arguments
>
> Good: v6.12.13
> Bad:  6.12.14-rc1 (v6.12.13-423-gfb9a4bb2450b)

Anders bisected this to,
# first bad commit:
   [91717e464c5939f7d01ca64742f773a75b319981]
   xfs: don't lose solo dquot update transactions

--
Linaro LKFT
https://lkft.linaro.org
