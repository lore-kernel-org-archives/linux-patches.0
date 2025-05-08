Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5164E3207
	for <patches@lists.linux.dev>; Thu,  8 May 2025 01:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746668823; cv=none; b=kPgNBsMNmUgocTCe+aLF4wJnnEQIsd2VoYiOwL53KZT8HJ7OwtA+QVomRyLKTLy3FmwC9rWNRA1w94K+r9Ww7dZzNR4BSmDzVCVcFmkAlkpW0RxqueRBRUUs+AGB7yCZbuAeniMsZwchGhH3l6yq9gTiLdJGC8tFgsygM4DLG+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746668823; c=relaxed/simple;
	bh=wPYQA0chDUAYTp1nRzQozQgezsU3Dw/AxpYicdDi2C0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RjVpmo5krsIyawZXegax0QInPrcOYGg6XG8w1NktjS9UwGi3WArmE8dBB/TPTqzvQar1P2Y7z07gxyGaJ7t36In7UXmdAgLbGqd4L2cwfyBR0xGZDCkTqQYLJpaFlCj5zaMG7C8bPjOOIDSWvsSop158QBsiQ1elNqzm3dmZ8k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=YAlEnkep; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="YAlEnkep"
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3d940c7ea71so2243655ab.0
        for <patches@lists.linux.dev>; Wed, 07 May 2025 18:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1746668820; x=1747273620; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K30ImzdgaQIMhkVLspdKyTD1ilP48uNTiegnW+raJhY=;
        b=YAlEnkepooFZg1MTetlHqvVuDidVNqJxJr1yTDZqXxsIniPTDJixyfoyUumbw9CR96
         zqP7vH5Ucv2FVNFqVxAAB1AHjH6TtT9oinety4FqsbXN3Al93qxwNM9QkXfGgfCm+B0l
         5X6wcY7BavhGO2WC/vJZWw7fmzaGFRUukpqW8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746668820; x=1747273620;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K30ImzdgaQIMhkVLspdKyTD1ilP48uNTiegnW+raJhY=;
        b=peedqL+uXrqRJ2um7FJOEiKT8YrCilHHLNv7dnqSlmnumni2kZTAwnAGQtXE1l/t2J
         VAsy+FURaNedhs8j21nCUINhZOxrjZaAT5KqBPRjIjrzWoE2v4WF1E1jCrazna1mLF0K
         PzR7oYFygmRB8OD7U8BvK0AUS/PFj6VUX47jrrGnekTThChD9SadjRHZSD0bNav6EqGt
         W0d6b/1HsH/Tk7nwzHCWx4T5pmIu3jZJx9L2ddgVI466VabOj4JUUZUoGxRT7aXj5ZN1
         cMh/BSmulA1iKBQ+wexF2B6Rsw2jM7ikVrxRynso9q01hfs+nkBqxMl5iYqUddbHKA7L
         mG5Q==
X-Forwarded-Encrypted: i=1; AJvYcCXQRGchUTypwgtEuw8yocpdu9w1zds5+v+07XYav9qjw7n8qDFL+0Gjv+aZWP67JneYUmFHU7eA@lists.linux.dev
X-Gm-Message-State: AOJu0YwyF/Hmc1UUrEGhchWJCxaRob3WrdUwTJveMYt11fJBcJT7oR2h
	0hHByxMoU3v/wQCbjMZXTHdn41UvwQ17mGYuwGa6RB6djy0W23k9+zGLkipVWg==
X-Gm-Gg: ASbGnctD49TsBy9SIWnv9w58DHSKIC3WEn75Wf58zym+dlnodnyp0NO9NlAZjIkj6eS
	ZCfKo3jx3f9HPzfLh+ZZGdYZojO+UcpIjtQ2MXf6NHo66jQaGa7j0JeML9rqomd9NK3HI/WG7u2
	E3Z92Rq7r+64xsZksBZ+x3L0COTFroRPQh5cQ01/389rTCA3L5cYdVRypVFVc/Ld7d0Qy/y/dfw
	2WzbZrE+mZFN09Vjc+N78dvSbF8OZSIIZgzurnLV+OwlD6ilb7YKIwwjvAqumrFTdcH/WHYYgRV
	Ytcp4jNVYo0/4kax3j7u5GDQpALZKkfOxPIvkQ4p+wXpYhX2KAWQnk8EwA==
X-Google-Smtp-Source: AGHT+IH4Lz1o04N5HigShgyvfxqljFYcADGJXBDAPQu5Ym4eae8BcvvU/ic296T5K1SMw6L5LWvptQ==
X-Received: by 2002:a05:6e02:3f02:b0:3d8:18f8:fae9 with SMTP id e9e14a558f8ab-3da738e3bf4mr67925185ab.6.1746668820373;
        Wed, 07 May 2025 18:47:00 -0700 (PDT)
Received: from fedora64.linuxtx.org ([72.42.103.70])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3da76a9c49dsm4777715ab.3.2025.05.07.18.46.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 18:46:59 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Wed, 7 May 2025 19:46:58 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.14 000/183] 6.14.6-rc1 review
Message-ID: <aBwNElYzao3SIHYc@fedora64.linuxtx.org>
References: <20250507183824.682671926@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>

On Wed, May 07, 2025 at 08:37:25PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.6 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 09 May 2025 18:37:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
