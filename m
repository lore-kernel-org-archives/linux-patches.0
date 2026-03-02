Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 887F4319871
	for <patches@lists.linux.dev>; Mon,  2 Mar 2026 22:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772489700; cv=none; b=G3QHbVr4yVfDYqAB8rN0wy5aQTbOD8IOaKJEOkW2E52i7IPZq7pJCPFDqBzUq50oshMyJq288piJbXB4UgaT7aKTLVDiRdnVD9r29+5jTSCS5zEJ6c1ITaWZ9OUiIKWoTsFSyIH/yls18l869rBrnB4/Z2uREolJLh27aIM0W9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772489700; c=relaxed/simple;
	bh=7tUyLlF5oSfxEFoTpeVKj6AEeiuw6YGNR5YAq2t1Tm8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gNRbzZuiGmfz8Sat4w2O1CUKCJ5g591jShxjvbK7GiRxLy8UwMOSRRgnDMw05ulsgtxrVeCG+fWXmvdFr8F+nFq7lefYY6EIXqHvJtyfLa7fNnyb5Gqw6AwC6oH+1vZHnbswm3yuZNL2ZMUVqMyQauiIrlfjpEfVEFhfzuzHg/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=Qt7dSEuV; arc=none smtp.client-ip=74.125.82.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="Qt7dSEuV"
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-2be1b5fe11cso1118154eec.0
        for <patches@lists.linux.dev>; Mon, 02 Mar 2026 14:14:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1772489698; x=1773094498; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jXt41I/9ZWGWF2H15Qu2+W0y8hiMFnOM4RdPPak0JGs=;
        b=Qt7dSEuVScBLRIFEICDEvFGS3HkmojxGjYupcWXbxAuW4m8GPs+ZPKkp5sUIBM3hJM
         PdgPI8DP47NB+TNjns9sGBM3Et9XTWgC8A2KO7pRxScggU4FD6+39LODmzaWclDQmizI
         eNghH017CMXcLGuPGr2eJ0JU95478y+otDz4k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772489698; x=1773094498;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jXt41I/9ZWGWF2H15Qu2+W0y8hiMFnOM4RdPPak0JGs=;
        b=GBi0X+GhIshow2AOyde+t9tlAsqfnEHxRufuejmPN1hbF3HgCTbbXZuwz8bYVS6I5U
         G9RuCm3c+BVu5MWGO2o+71rldD7EZ1/GbpBCs7PbDS3us/Fa7NrclzD8AHWTzBMPECmQ
         pMvsA3BpG00Dtwh9mFYhJsJr/9V5BZWFBouNbzgUmLH3wwMkoYJtMwIngJH1hX3eHC5W
         YxTC6aHjf1TjBeCjqVGR16C6xa58hIAhRUdvSnNHz0rkubW+GR6xfprTyj/dM0a1DXea
         nWAtG0XOZMaaU+6XG5j2OffDoqEabhm/Z1eciewMB50glc/0gGxA7g4xdMghSNsY4qHM
         ipzQ==
X-Forwarded-Encrypted: i=1; AJvYcCWKbA/yeBcFy/TDjc/wMA9inwyl1CgxRWPv54NjwsZ34Gk2tASlbEast8RZOHwRSdvJV+GRjE8D@lists.linux.dev
X-Gm-Message-State: AOJu0Yyk9AZORUuhz8IBrrDTUzT+RdtzLrE4R+2mlCx/xLpJ+F8lUdj6
	Gyq2LFx3aEQYJIMb27ROvqWR8D9uS736iFU5P8658yBGiqxWONQcScOKDNAgnaLNHQ==
X-Gm-Gg: ATEYQzwoz2hDOaACimPpgLaZcwVOwfMcKM0qgnCklr6IgSAg24xDVMlB/I8aQQtr1Rd
	4iQAiSH0aMRPF8BAonKQNi7xp0r4GdcJCVdGcn9tV1Eei9tmb6BYg7/uCl4UnmRYn2qJE2TLdQj
	eJFqTFQmwqpcbPNt/eoyEO6neL0hH1hsBqxR5PdFlsR2jGrOVLeYt6N8TQtxOlnm4EyksUro6ri
	XULQTh9kkhEvOcjmAGWT9/q0UEMihnvkKpwpafFTqE0pZ14TVcv2cffm985bhE06goJ7z2HJ5A/
	/zfZl8GVI2J1bYnm7/+l2UzeeSEeCqwAlb4f/M3icXCSi24GCTnb7oCYC3/PvKo4W8STuL0XqPK
	7ZkKlQdazxlmbnxfT3sZQfOQS9QBpG1t+MKOaBrGMEqfCd+h0bjy4ueiTIhLXsl0L6kxqmPwu++
	7Vx2VEVqvCxtMx8hxihyoWutq0ZCtfdrpF+F3300yH6Op0
X-Received: by 2002:a05:7301:9f06:b0:2be:171c:5048 with SMTP id 5a478bee46e88-2be171c53cemr1383663eec.5.1772489697595;
        Mon, 02 Mar 2026 14:14:57 -0800 (PST)
Received: from fedora64.linuxtx.org ([216.147.124.134])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2bdfb3f898asm6594316eec.29.2026.03.02.14.14.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 14:14:56 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Mon, 2 Mar 2026 15:14:54 -0700
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
Subject: Re: [PATCH 6.18 000/757] 6.18.16-rc2 review
Message-ID: <aaYL3gXI4Czb_Q9I@fedora64.linuxtx.org>
References: <20260302160853.2519610-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302160853.2519610-1-sashal@kernel.org>

On Mon, Mar 02, 2026 at 11:08:53AM -0500, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 6.18.16 release.
> There are 757 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed Mar  4 04:08:47 PM UTC 2026.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-6.18.y&id2=v6.18.15
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha

Tested rc2 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
