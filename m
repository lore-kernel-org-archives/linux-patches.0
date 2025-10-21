Received: from mail.itouring.de (mail.itouring.de [85.10.202.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEAC27E105
	for <patches@lists.linux.dev>; Tue, 21 Oct 2025 21:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.10.202.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761082582; cv=none; b=M/Q9YSSPzY0JCmo2QE8QQkx+2kzZJl4JfPAyG3Mpe5bpCo3dZDz4jpP7kyVdafiZjKpqdpXOVpaHgbcHz2DdQcchICWj2hApPx0FZPDqKxeNFPo8ulGE1A54AloLMGH69B1NJ1PxlYxTnDB+I4nqfSUkyWX2kLR/KWIkctkeG5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761082582; c=relaxed/simple;
	bh=AWU5KQPbFduhRiDS8cUb240PKtlCdv5iV93TBw/piXY=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=R5NzzhwS2AlgR3JvJqp3f0V22zwpLuQSnR22ZQLstBmhX8VZxe5pCaW/amoAQ00e5EKyqfEoFf9iEKCQ0kjLTs4wEs8I5RqlSdAn4hHEPxRLD2R7ewuO1xSj1PaWp8KoQTePB9d5yYJoZHWhUNazst9F722+hEWe09nPT4BDru0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=applied-asynchrony.com; spf=pass smtp.mailfrom=applied-asynchrony.com; arc=none smtp.client-ip=85.10.202.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=applied-asynchrony.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=applied-asynchrony.com
Received: from tux.applied-asynchrony.com (p5b2e85dd.dip0.t-ipconnect.de [91.46.133.221])
	by mail.itouring.de (Postfix) with ESMTPSA id 7673AC597;
	Tue, 21 Oct 2025 23:30:27 +0200 (CEST)
Received: from [192.168.100.221] (hho.applied-asynchrony.com [192.168.100.221])
	by tux.applied-asynchrony.com (Postfix) with ESMTP id D013C60187F04;
	Tue, 21 Oct 2025 23:30:26 +0200 (CEST)
Subject: Re: [PATCH 6.17 000/159] 6.17.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, "Mario Limonciello (AMD)" <superm1@kernel.org>
References: <20251021195043.182511864@linuxfoundation.org>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <fc400181-7c76-6344-c6ea-a4e48d722f55@applied-asynchrony.com>
Date: Tue, 21 Oct 2025 23:30:26 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 2025-10-21 21:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.5 release.

Hmm:

*  LD [M]  drivers/gpu/drm/amd/amdgpu/amdgpu.o
*  MODPOST Module.symvers
*ERROR: modpost: "pm_hibernation_mode_is_suspend" [drivers/gpu/drm/amd/amdgpu/amdgpu.ko] undefined!

Caused by drm-amd-fix-hybrid-sleep.patch

I have CONFIG_SUSPEND enabled, exactly same config as 6.17.4.

Looking at mainline it seems we also need parts of:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=495c8d35035edb66e3284113bef01f3b1b843832
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=bbfe987c5a2854705393ad79813074e5eadcbde6

cheers
Holger
