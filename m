Received: from mail-ua1-f47.google.com (mail-ua1-f47.google.com [209.85.222.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D1F35EF1
	for <patches@lists.linux.dev>; Mon,  5 Feb 2024 16:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707151236; cv=none; b=IuIcGflPwCnXTmvWF8zGZ/582FRwKhJbWmLRLpWQ/p+sNiw31uoLN9/OuaMT4qPxYem8sA37j8oy3Jb0GwFFm1hiPISATEE2xhA7HC+NChgChiMZuQ5Rs6zNMOjC2vadL7fGqA745wTA3LXhayCFwSyU4wg3nx4qUDF18+APtJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707151236; c=relaxed/simple;
	bh=ary512A6BfTSJQxaZq8dpsFJkve0is15pesW2o9sbOg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Riv9YNy7ltmDr2AFSY2g5rQp4LukcbbixS/HK12w8pvzggRPoDNGNFqp86VaGD15p0r8jFvqaoVFElhlfR+E1tV0JWGLNsDn6We1aJ5CstaIHfQleNU1CPL8Ox+V0X/KmXFvr4RYRKn6zeR30eTLsSct0MOl86800tH1EadDX5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f1ilm9E+; arc=none smtp.client-ip=209.85.222.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f1ilm9E+"
Received: by mail-ua1-f47.google.com with SMTP id a1e0cc1a2514c-7d2a78c49d1so1916181241.0
        for <patches@lists.linux.dev>; Mon, 05 Feb 2024 08:40:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707151234; x=1707756034; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0f/X+Bpl57XsTrknK+4uXaivkt+xwyCd4mmJCtIejiM=;
        b=f1ilm9E+3vvWE/rwntChjzq22Mm3MH+RBqT0af2rQkWlr8889D4ep7USLAk//7RJd+
         nqRgC4PAGK6ara4Gf20KVxZ2j6GvTCw28rZRNWnfvP24Wkwa97QeytAsF+IYLVConLvy
         pdPaiFPRUdttzrYCWrGIcdupqs3DlGYqnj0r0vsdQ8L2ckDaHNGohDv6UvuEGqq1T23i
         KZBtv9TBt8aX9bLeIehULRaVAAzSW49te7FH0WnGHoev08/bVpf21jJtOwbad1vFY08D
         5/yM//88Uh5IChoEohqjMNnTEbKjL+q53lgJQETTM1MXyLa/Y9ImUHc7eHIAdXu7POU/
         sQkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707151234; x=1707756034;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0f/X+Bpl57XsTrknK+4uXaivkt+xwyCd4mmJCtIejiM=;
        b=hn1qBngzVKgwfmw2E2QJFnysjn/e/87PJexlcXIztDwzF+fiUDsT6QaF/02r9+kWE9
         Vy0EPEvYM7SsSvz61r0x7vblnTwQU9C4dWAdtWK6sA4ng8KkEfFDJNm/NjcxL/A0VcOa
         2hqcZr18kOhcjf759CK/XNRMdwd/IznFfsHzJ9Ihp3YycviqhD0bvNUg7MuY9QwaF1qp
         jUrqQCtRA2rvopvzLoDO5lewVKeMrPgzKbFJ6M7WXZn7BgO4cQVC8GSJRwUZKq54Tbmp
         TM5zwSGUzs4lZRcxniW1B2ZsQdO3KMwCGOXT9OrwxVK5iRGc9LSK3OcPKapAur9ZFQEf
         OaZg==
X-Gm-Message-State: AOJu0YxxnCVx64LGcK4Uxi9xnlUi7/Y5iiDclHhFoRu+EeMWHPpm+cAc
	kEFdqSTrXJcqvnUvYRC5/a+AUS170aGTsub5BMxU2/KK5j5GVTLP3aBasMYraed8Kzfz7Q+hJ54
	sezKVFePTxQT/hz5xCF78blKY+R4=
X-Google-Smtp-Source: AGHT+IHCWnn1ZmXqR/KTVDYIdL/mIfnCd2sufWbS3uvury9Hap2qV49xHkO5y9vmWqzP5fKSi+OO+EuP2cx8AkCmVmU=
X-Received: by 2002:a05:6102:50a6:b0:46d:2f69:c772 with SMTP id
 bl38-20020a05610250a600b0046d2f69c772mr236851vsb.11.1707151234080; Mon, 05
 Feb 2024 08:40:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240203174810.768708706@linuxfoundation.org>
In-Reply-To: <20240203174810.768708706@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Mon, 5 Feb 2024 08:40:22 -0800
Message-ID: <CAOMdWS+9caKLFejS3mmhg1p09PcRgMTBep5waxhjEv50TPrbbQ@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/326] 6.6.16-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.6.16 release.
> There are 326 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 05 Feb 2024 17:47:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.16-rc2.gz
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
