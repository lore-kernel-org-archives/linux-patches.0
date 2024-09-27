Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D751C0DFB
	for <patches@lists.linux.dev>; Fri, 27 Sep 2024 18:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727463119; cv=none; b=DZQ1lOHJk0jtVoBb/cpeWSj4BB+oseAsS/IIBQGWZ+Na4J9I0VIs+nJmNKpzvMG24MyZPaFkUOwVLzg4Rf2+mnbalOUVOOUjaHUmyfcVcrL5J7Bu7WRAMFxQ7vPkGGvvTlSxRCoFy6RBP6OQH8YFCZztJ9VOb4Rp+pBMsk0WG3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727463119; c=relaxed/simple;
	bh=eITh1z6ROeAVjf34DngYzl3Vc0FLZBZpfykTmNZoXY0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HDJW3PscRGKUtg+4u/X1qToVfNinO40BdwcPHybI4rHdPeb2ZO19wylYIsnlPC1Zf5scSJ77unThOE8UATZZcmQcfAOPKjwzMU+YHhj6ETUOEMGr2cTDNBmTvC0VyH3c1j8OHg5Jt+yt2a2Ndd5aGRTPwo/4Bsc6g8lroNwLQSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=KOch44vn; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="KOch44vn"
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3a0cc384a85so11066105ab.1
        for <patches@lists.linux.dev>; Fri, 27 Sep 2024 11:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1727463116; x=1728067916; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gxyQQgkA3wMtE3Hi9DOhcULcCDQzTPtIVdh2jdevVzY=;
        b=KOch44vnnsIFJwEoFX+pZ9MyMBV5Nz27/3NtSPF/MymuZzZFpqIPwAvdWAlvRqLrXw
         mIsuW0hVv6Qqr1keCOfMtNL+RB5plZ5a721zVxMJmhq0u5fy5LPK7DAImveKHf9q/IGm
         wQ4nvX8ZGyFBZuldQY2QY56wooYfbCVX3cza4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727463116; x=1728067916;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gxyQQgkA3wMtE3Hi9DOhcULcCDQzTPtIVdh2jdevVzY=;
        b=opCyLpITCmFSJXBxoBxLlAGbn6uHd8OIvrcqk2aegMS1+Cfk2/r48MX6nbS0a7uQ9y
         /WgsSfsyHvA/0eFAcmx5JGagQ2CQ6BupTm5C+Geic6PTooECBsrwpYyEPzzxrrqKFuTL
         CAae78D6dRDxbby6msCiNRnjusQJfzkoB0iBHaGvkKTAsXOcQSUUxX+ReLaJBl2zAU9a
         FmHn/xMWt4wmWtBIh8FltvTs0oHzzJywQh0aU5FZDK+xp9NAH/qjC0tKiLVcqMcl/6oo
         fyTI4OGm4Tet3d705noFCjTs9tMF635/8dgBzxvnIuyr264jI+dGrA8r+8ulGM+JnnWn
         3joA==
X-Forwarded-Encrypted: i=1; AJvYcCU9JwU4PaF+b56yOoFkgMHKfrr7rdnUI2Wm9leQ/GQT98YKkJM6anMgc+zzvbnYW4Jfp8uMiwyh@lists.linux.dev
X-Gm-Message-State: AOJu0Yw+cnIHJ/gg5kfwLIxHt0jHo+N2lpkROqm7KdEkmeR2houYejTb
	2HIH7Le1Lavhq2df5cAC+g1dwlX6cru0bBJ/MYhonzsQ0sn3KU/HkUPjkzhy/Q==
X-Google-Smtp-Source: AGHT+IGBJMHjU3F3oNzrEVYyvsCJoiibFm59q1GvVFt61CRaclCtx2Dq6FUyz7K8DJ0ILIP0e9KCaQ==
X-Received: by 2002:a05:6e02:19cd:b0:3a0:c7f9:29e2 with SMTP id e9e14a558f8ab-3a3451b691amr37024015ab.19.1727463116011;
        Fri, 27 Sep 2024 11:51:56 -0700 (PDT)
Received: from fedora64.linuxtx.org ([72.42.103.70])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a344d82ae5sm7443195ab.28.2024.09.27.11.51.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Sep 2024 11:51:55 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Fri, 27 Sep 2024 12:51:53 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.11 00/12] 6.11.1-rc1 review
Message-ID: <Zvb-yRASvJclm4hT@fedora64.linuxtx.org>
References: <20240927121715.213013166@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240927121715.213013166@linuxfoundation.org>

On Fri, Sep 27, 2024 at 02:24:03PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.11.1 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 29 Sep 2024 12:17:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
