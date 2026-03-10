Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D323BED4B
	for <patches@lists.linux.dev>; Tue, 10 Mar 2026 18:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773168956; cv=none; b=jGa16Wxyb58AwnBiBdhTaZOl11qxmXlh2VaDYdY4If0eq6zxt9kStn7UZKBqSObDB/u3wcXX7YKITm/keqUDTDDVpAmaAJOs2KDrj5g1gqtEd4U0Xx56TBqvjCv4OMpq3ALi4wPyCpCw8+pj7HIBtjRaYt3qV4qorSWTAQB/Rj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773168956; c=relaxed/simple;
	bh=JIV7GzVbpLnLuaEK5/zFdC2TJRtVHYh8P8kjKCCHdGY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kym1NnTYrtirPSB+oK5IOjzcPATUG+SUN+g1mlGYeV5k2oxw+Pc8Nrr7R5BNsrTbi/aF25GSBMi/CyNxMaDcLM3uoQfpmh84DyvcF0xK/6B8MUOK+d8pcMdUppH2XTn/0yX170IzpbFoQd2wQcMnv0yU7eLD6weUa7sJPOBC7F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=anr+bLyX; arc=none smtp.client-ip=74.125.82.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="anr+bLyX"
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-127380532eeso873721c88.1
        for <patches@lists.linux.dev>; Tue, 10 Mar 2026 11:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1773168952; x=1773773752; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UQ72vUindK+cFfJ95rdlTtKUowMa4key6184d5W9Acc=;
        b=anr+bLyXAhUjawQeDNh2O+ZXhZSHALy0NGmWK5hYV5TjFYBH/BiRGiYnwnuBVNG8Mf
         Gb30XSR1Z3n8r0rj+jorZgaPBZtBmo5/ZFj+12XCmNtGHxiLwhXj4qSsbI/UzdK8PmIQ
         11cHlnPz7QUnRyWOK8HeoMHvkKO0coUvzzgnI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773168952; x=1773773752;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UQ72vUindK+cFfJ95rdlTtKUowMa4key6184d5W9Acc=;
        b=kJKKvvltKQa8F/a1e7h9/8LPJxePVjweEsNM6RdlykDCaQl84qZWCLE2sCUruNwoJU
         qlae6NejHv9HdSsQzt2T5kZIvndcf+2WbGtBQCqSh3X8f06CSfzVVu1R8aEgmiWkXDRx
         blGiq/J7aLVyQ2yDaA1EoN6r2KkDLc/p39aubjvz3wlhMurnsL2YYng5gTx2kiiREy72
         EdqEqRqwEsJc9P9oLhdJZ3db3623b/5tz7qjdS7eUoZ0jXkrq/htO04+cfrdwvUUfp7O
         o+wtx2DtNO9o3OBDCaLgYjvE5ZSxMAltlRsIPwpr9Zday1EzTwimE3/gTWA9rSY/aQGs
         lt9Q==
X-Forwarded-Encrypted: i=1; AJvYcCUTOcopNey5nZzKBY0n+0qkcNMSTrlxodDUGMykmb+tymUWDVujOkmO69PDLUR0xvS6Lcsj1sG9@lists.linux.dev
X-Gm-Message-State: AOJu0YxNt812n/f2Wk/7BBWnMb0hQoYmUlx/trlmsiaq6mn/CKH4AE6I
	XiCBxDz4y8QTy3WnnkP5iTDoX+rrUh/rbkl1lMEk7KycH8/avg1OjPWDbYroSaFapA==
X-Gm-Gg: ATEYQzyE4PhcHfRVY4kLY6FtZgkPz6c+B2ncqqnO1QfUkIF3gwE7gmSewGCGjOkXC4P
	yzQ71BCHmrXWKvcb+IjOaMDcspjvD9EyJPc//OugRtv/G6iTWlrOFFBdhrvaMOk+9DGD/83cb+Y
	lJlKVVdpbzqglJMgYhL0zqlZzuudw/+dyFVpLNdYuyTm/Aiw37GFd/mihifwlltvRPaC4wXQGml
	AA3u3X74obNqKcn0Hvq/MSTE2Px4fDT2DPxml6UPFDgMYslzb/JqGkJRdsCJR+jFThpQUbJDQyN
	FGQHp9ISgIKssN0M86NlAeUK1vDJKu6Tmj529s24CzFbjgGqu/MWcT1sLUoeuo9/cN0+qNRsya8
	eu2l+k3XyGAMdYVKFaaByzz1wQrUSNYhLj+TX7vT03eceLrpFrZTYqGmKHT3FQI9nJeerQJazbE
	s9iV65soeR48lB8ufwmtXBWW21mJZwa8I2xx5fr7zXgxwQQEyNZftq9w==
X-Received: by 2002:a05:7022:518:b0:124:abaa:7ff2 with SMTP id a92af1059eb24-128c2e7ece1mr8340992c88.24.1773168952196;
        Tue, 10 Mar 2026 11:55:52 -0700 (PDT)
Received: from fedora64.linuxtx.org ([216.147.127.21])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-128d5aa8f5esm11602041c88.6.2026.03.10.11.55.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 11:55:51 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 10 Mar 2026 12:55:48 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	gregkh@linuxfoundation.org, patches@lists.linux.dev,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.19 000/311] 6.19.7-rc1 review
Message-ID: <abBpNGge_DDUtNJu@fedora64.linuxtx.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>

On Tue, Mar 10, 2026 at 07:05:54AM -0400, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 6.19.7 release.
> There are 311 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu Mar 12 11:04:16 AM UTC 2026.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/rawdiff/?id=linux-6.19.y&id2=v6.19.6
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
