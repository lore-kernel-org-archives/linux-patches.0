Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1617417A2E1
	for <patches@lists.linux.dev>; Thu, 19 Jun 2025 01:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750296970; cv=none; b=YYk6uBcz/rT8LKlahDux1Z+Y+y2XmYK1ZMUsWdjNnqeOAzl8nNK/rHtyY6mWREZKdWq6UUrja3VuP02FFUf5cb3xn1cAzUr0ZYA7iwHrKymUOArolL+TFjCfH0CUs5GSQSQLaP2wKsQHbxNQhGqJ0XIYIT0krW37YXSwuXV3VVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750296970; c=relaxed/simple;
	bh=a7LKI9yVxE3ykJg1bgsYmWUbSOo/xy/ycf6LqSydAZg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m6S2YOck24dXi3n/QfWYK3ijNq6SDK9U3mPEXEoqP1FAWPRiSEn6Yzm0MjQ3zNNqMpMdk+TpWjckym+bimH+5DX1sSXSkBteWmn/3udn+yznLOPNKjQBo/BRt/ppHs54oL6ipyMfT1+mKzBQB5orzzKVe7f02ZynP9tnuHisShA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=Qt3gsY6B; arc=none smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="Qt3gsY6B"
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-60f22023eddso195030eaf.3
        for <patches@lists.linux.dev>; Wed, 18 Jun 2025 18:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1750296967; x=1750901767; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bYxzGeW3SeKobvt5hVr2NPD7d0ZSxse5WH45fraPlic=;
        b=Qt3gsY6BbHASmva8sIc0O/j6/fMMoMbWQqwPiqYrItqWRx+EIkt5cl7plDeTDeGW9l
         b9Px2tpjRHSjk3NW/UGQBVnugyxbVWviue5mJNcMyBIwFg1n/orXzzpjBUlbmms9mwhK
         XuldUxikkxdzeehmUltF7Cz4Tqdgn1JM0gacU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750296967; x=1750901767;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bYxzGeW3SeKobvt5hVr2NPD7d0ZSxse5WH45fraPlic=;
        b=w43zkMsM89SNzoX4brwGiV8DiCx3qhpPhpKpGzDFizLtIZjrYRipCl3YSvawo/BevX
         E9tt5HGzQjwtHlbxuPCvChi3BplhrN9pvuEPNyT5D6YGAb8T7978iCmWFGrOgbT08+ZX
         Qja2gtzd93XaDYEzUv/WM3KWyDCv1yVIyNveCVQ2q/McJkXkorHZCLV2Nve+8kedJHF/
         H8Cxl7Ju1gY0B/pfW9tM6AxL2F8jleKQjb1qEK98JOZ89vmI4atiQgmbu3olTl40ki2l
         KJbz9mcpff7GyBC7kXXF770HtRFJupz7bWlFKe6mkXTxXdyLpTK0pS2esBpKR+8K2BZh
         ws1A==
X-Forwarded-Encrypted: i=1; AJvYcCXW8yZmgH5gy2o6MmoImDAgrWLelnsfWb2CQvHX8Zs9rjYGkpzO7H8L0qVv6YcdxRwnhu6jy3Hw@lists.linux.dev
X-Gm-Message-State: AOJu0Yyd8YAjddDugAzZ3zi2vut/NOXW44CEvZefB1QnU7KXOCLhEcT3
	IkkzEuJvXpebE0pwYUNMG9I4OXvXJ0whVs5cCfEYt7YpuL1efVEwa1S/f5Z7j23tBw==
X-Gm-Gg: ASbGnct55COEipSqiCPX6X/xYoe1TxQrlDkzegTlBSgGCSKp3eYndLrkEBJWB50uUDi
	xzyo7DBfKoX00Fap+ldVGlWXwN0hAY8ufx/1ysV7lXFTBkiHFHluQi+d/iyLzG4PhNJY3pHQoiS
	Rto6jzFpJmMCTvxsrUxNPaBMzmgns+xS+mbd9Wvm1pEtgZSUTHwbYJvhUIgglV/ppVTAblBBo+e
	Xxr6eH7QRBIE0hYiHiIssAGEM6rPFhs2EXprB4xhonHZsTPrTjyiI3IK1iFPn1AAwoZaRfy1pYZ
	QJV/VfFlF69zj1QDJuCb4sC5KqBexbCmLUll4Jp3Gse9mINhN6NgBOtjqg7G7x90ynPBzcISaYz
	eenU=
X-Google-Smtp-Source: AGHT+IFEailJ6g9LRTn3NG+4TGjZYtEMqCWW4yTLocUVb0EB4IywFCgdkoef2GnudjaCn24BHwV0KQ==
X-Received: by 2002:a05:6820:1628:b0:609:dd17:795 with SMTP id 006d021491bc7-61110ee3dccmr12281943eaf.6.1750296966909;
        Wed, 18 Jun 2025 18:36:06 -0700 (PDT)
Received: from fedora64.linuxtx.org ([72.42.103.70])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-73a4fa8a054sm1285463a34.51.2025.06.18.18.36.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jun 2025 18:36:06 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Wed, 18 Jun 2025 19:36:04 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.15 000/780] 6.15.3-rc1 review
Message-ID: <aFNphCnmG57JMriZ@fedora64.linuxtx.org>
References: <20250617152451.485330293@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>

On Tue, Jun 17, 2025 at 05:15:08PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.3 release.
> There are 780 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Jun 2025 15:22:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

After dropping
revert-mm-execmem-unify-early-execmem_cache-behaviour.patch:

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
