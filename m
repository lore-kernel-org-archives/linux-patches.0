Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B98B1AA1C4
	for <patches@lists.linux.dev>; Tue, 24 Dec 2024 21:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735076215; cv=none; b=bTMDtMG/aQqJ9PystHsdqwFdEsZTR4Weao+HW1EMEVWMVSC3bL8DFWm0bVC+PCRy/ZbJ8EoddfcDoXiQ5e7jqrK+Z4JcgWzfAJcMd+4WVvi5lNhB/UG/m2sNSv1QFHM5sf7MapI4SAIkgY4k7DHmBP39UeZXAMkYSR2MWuIzM08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735076215; c=relaxed/simple;
	bh=Z/C4yeb04ozX1TxmiYdpEkCwU4dnpvCayOdhi0T1hsw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YPsSHTXRsAwQT2cAqFOV56KXFXkWttce5VTVey2fv55C1jzhXHq7KJ1AwabOjKUzKGkCou1SaQuH1Mgd6YImVmVUsjHUlVTZgYD/0JDeEUt27sRF8aFSpRqBdS8opEGzQNHjdla1NoeRcK+dqSidGqzL5K2p5f7oUbwyJ5+qVgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=hsPiWvSe; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="hsPiWvSe"
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3a9c9f2a569so41379285ab.0
        for <patches@lists.linux.dev>; Tue, 24 Dec 2024 13:36:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1735076212; x=1735681012; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eNqO5U1WzlHShdnDjDb2XoqFLabx4/jHbSlMuTmZVMg=;
        b=hsPiWvSeXxVjd9i+3b60PQ4hF0EfKGziSP7QhG+O30E810jXyeyt5WkLWrS3j0Dg6Z
         10uKEp1EDpJx6MrdTVYZn3VZmGMK/BmIVOBfVJSNPFdtpX4Qm4dFtTlrTSIeL0IBJn+2
         MPMmIXmHq8ctzFYc17d/VisyM3Rr6Gko2K81c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735076212; x=1735681012;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eNqO5U1WzlHShdnDjDb2XoqFLabx4/jHbSlMuTmZVMg=;
        b=lhH2JCtwUacOr+yT+rDHj9+jH2tMo0oVpjFrEEMFdcLiFrcfLzMiQoh03uWsMuqMUQ
         zd0VVixhOCPvPjQGq8+K0hLC2SDOCmC1fVVP1Jqu57ZT7ctB+rpCinUcIb1wSZuRQtsg
         kdQ7QcPI/1rijKeMYDMov4Os4MoMWBVoJh6f5IYOvRWzIxspljJEm5fjdlDLMkhGlcmq
         kfYjthvrvlSekSCBZWTNJdq3DVtNRW5uFJd3p/nnch/KPb0eXggUHr/Jv8z046q48GqP
         dUmtvXVdvSAhfNhFCn1y6D0+0D8v0sfYziobxROV1hAesJrqa4Mkt+ucqLSCp4RboA3h
         wCMQ==
X-Forwarded-Encrypted: i=1; AJvYcCUj80Hm3ABbx/n2h+KsmG8PJAVHzE90QWeERTiu4EbdWBA8pFEpqsaGcUYQ4wiReNfcEWghyGVc@lists.linux.dev
X-Gm-Message-State: AOJu0YzWwGzLsnJXKY4gwaNL30/12rY3Mp4SU+jUDcGZz9fCOQGtpRKI
	E89Yvlx5ISu+uVHSV1dTp0AKIBucHzTlTVBfu9cs0cwKHP8eGRxM1uHZAF03qg==
X-Gm-Gg: ASbGncszbGwfZKmvf2oJruUMTFdnm8YYnyoiWnvyw/D9BnMmmYPUiaJb1qyIZ0nwNZE
	3puJ/5Xgnt+RvjtwVXEtTv6hmT4WDpgckfpWLP45+n0wppiU6ZFFLFwB+dRU9hI6I+GW8nHEZwb
	yoh4fsDTEHN1pReu1hpEJNdV6HtXNRtNXarL8Vae7M6vZqZDYDfqGTXvXPNoUI9aEgWXEz1Bk+m
	sIE/M9L2aT9e9AUymiX326nIDpSbalNOxUx5Q/y5zNfgV/LvkLVQqOfbVZIHy+jcLpxVgqKYg==
X-Google-Smtp-Source: AGHT+IHY2P5R+AePcGV8ct1KgQ+2uPfWkyNQjgRvyqnpymCxfEYA4Mr32SNFFzLUYrJbNemzvvdc4A==
X-Received: by 2002:a05:6e02:20e9:b0:3a3:4175:79da with SMTP id e9e14a558f8ab-3c2d2d5164bmr151609315ab.13.1735076212445;
        Tue, 24 Dec 2024 13:36:52 -0800 (PST)
Received: from fedora64.linuxtx.org ([72.42.103.70])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3c0e411e85dsm30983275ab.60.2024.12.24.13.36.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Dec 2024 13:36:52 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 24 Dec 2024 14:36:50 -0700
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.12 000/160] 6.12.7-rc1 review
Message-ID: <Z2spcofeNaxm3RGe@fedora64.linuxtx.org>
References: <20241223155408.598780301@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>

On Mon, Dec 23, 2024 at 04:56:51PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.7 release.
> There are 160 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 27 Dec 2024 15:53:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.7-rc1.gz
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
