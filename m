Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 059D917BCA
	for <patches@lists.linux.dev>; Wed,  1 Jan 2025 15:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735745644; cv=none; b=MjGaeFrI58syCzhDMLSlsghhiMIm/CUI4eoQMhZdQCE7spJFB3FC0soj4Xm0KlBmJscggxKHLCSVoRVOhuF/bAT5vvb9xDpeMBV2hutihhZZuZug0LUddJqeWVO4Ao4QzTiHFe/AOT3BDqmva0qOniIViGDrbeVwbyYxcxFTEy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735745644; c=relaxed/simple;
	bh=P3+zuA+9A7xmJKZ2lRKOaQ0D+DuWoqd6XsHj041ni6k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AWk/o08E/awXMF7KkeAzdE7NzgcyBqA+XlP4GzjLtocm+IGlOixrCatBOccUU8EdHAOhScHzOTdtZggKLVuhXUgJv7WjpnkpLGMtXZ9uBGKAUxBzy76xeJWe13X96wPD1g0Ts64hShgFVUZT9MFGQ2Qo4nBjoNfqVwd7VbJxPVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=LeYVipKg; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="LeYVipKg"
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3a8165cfae8so36170325ab.0
        for <patches@lists.linux.dev>; Wed, 01 Jan 2025 07:34:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1735745642; x=1736350442; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hPYhkQDwj4+4j5it/H6S6WTOthbU+coHVFGtarpUVPQ=;
        b=LeYVipKg0t9/mzmUOsZkw6jtTAaMdkqRVFwieYwf9zrmCUaB8Krrc7z/QUMCI8BiAB
         xpsceagmJxacL8gZG4QS8ovaDaLeh1T2dRVoEeOWYyrgrC9p0vpM1ZZOksyxb9S1NOE1
         pL77Yxi5H6UdExZrLtZP0Ra9599QF9GhJ2S9c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735745642; x=1736350442;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hPYhkQDwj4+4j5it/H6S6WTOthbU+coHVFGtarpUVPQ=;
        b=EA3xT/sHWnbagYH8DLeGFpcL5G1//DOBMNUrf6owaEsriQCgxSlLAFkdqffee4bcIE
         rYKItZoaQJ6pqbRlkWRP2EmMtfNuUAERP0KWUmGAJv/YGzPxOFizVq2KpP4Q03YnQu6K
         5GSqFifM8vBujIqe+/BUDFew+LRDkwq7s7IlCFHWe5BUXfT0P3hAIq5LOeJG7lUX6M98
         0g3Y8v9zzIg0bdN/PB4gFLQoe6QKw2k0mxdFAyS2hUJmofEZtDksqenC//AsMlL/4rQV
         OAhiisZk0cbPJii2We2zoVQWhQNPswXEgB+fiPh+nzcW7cZpCDUqj0Zc5MbYLct5F+50
         0GDw==
X-Forwarded-Encrypted: i=1; AJvYcCUCudEDNr7Sur7QLmBB40Nr71m2xn3z7a/vqRQYbpxTCC+ZL9Y3i/6WUrQRQ3KavoyrKMUvnc1L@lists.linux.dev
X-Gm-Message-State: AOJu0YxF6matE/AuM2/u6BudmRUpwL6TwGORbvJtEbvF7qd688vUk0/q
	oN7UCYL6wZXYxId8m3Fa8L8GNSYTeGEgx8rCyU3UvADOtgCkSs1KmalltW3k3Q==
X-Gm-Gg: ASbGnculdQVvfWEFkGCX9PKszANiYHMzIA4/R8gjUpL/N+9Z92xehshato9N0TOFmMT
	rsUysZwqhcqmrH7JikEZ4KeovUWDP+Dj+QEySgK9sc/4PtVSv6aa12xDc0Z/J+sJyZ4qGAmRFuu
	8A8KC6erMTgg6W1q/vKlXqeIOSLpWXcJ01QV/drA/jc28sKkC+M1jcG9NNWLOB00RLBVQ+eX+Li
	YXTxZfoIvUDv+2/WLKgJIBpg7Z6HV14+gRsq3O4/vN0+4eOMmuBjVXXDJYDi/nhP6Tbl/qjBQ==
X-Google-Smtp-Source: AGHT+IFvgp6d0hYeTh0NULR1nCaecGwhILzPF1W1Pxmq1/RTw+ezT3kqzKOvIHbJkPMRYjw3G+0NJQ==
X-Received: by 2002:a05:6e02:1a47:b0:3a7:e67f:3c5b with SMTP id e9e14a558f8ab-3c2d18b388emr334369105ab.2.1735745641927;
        Wed, 01 Jan 2025 07:34:01 -0800 (PST)
Received: from fedora64.linuxtx.org ([72.42.103.70])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3c0debdac77sm68798955ab.19.2025.01.01.07.34.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jan 2025 07:34:01 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Wed, 1 Jan 2025 08:33:59 -0700
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.12 000/114] 6.12.8-rc1 review
Message-ID: <Z3VgZx1zJ5f8-jyQ@fedora64.linuxtx.org>
References: <20241230154218.044787220@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>

On Mon, Dec 30, 2024 at 04:41:57PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.8 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Jan 2025 15:41:48 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
