Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD26F3DA5B2;
	Tue, 21 Apr 2026 15:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776783752; cv=none; b=hQE5/VFaX2s8iMT+sERTVeQutU1pPtOdNhIBgg2J9IIkMsX6y+QAr3IODViLwN60UGdZMU4JT2D2AeRR3rcY1pq/kVoYkSryG9Y44dgI+5BwRv9J25hYymv4znPujQRDHffi4JZzYfXJ3rdWfjgVJdD0QgO+gB4W4gJ4CgKUddo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776783752; c=relaxed/simple;
	bh=qvAuGgRLIUHK46coKMc1+qO5ZMSNpH4DPMh0ih0C7Uk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XRLroyPUlKAk4q8dL6PpoTFPz/iW1z4yt55HCtuqjpDWmp7fCofg9DhaN+X7zvxaeJXhaC7pJF0hfb4M6UpkHpynQfeRuw1Li69xLlTitr1YruQ79///eU5gRxtNCzLAVZkU97Kq/uAws6rzqgUfa2Y31HdKh4tV47TmtwZLvLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xhoV2oJI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xhoV2oJI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4906C2BCB6;
	Tue, 21 Apr 2026 15:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776783752;
	bh=qvAuGgRLIUHK46coKMc1+qO5ZMSNpH4DPMh0ih0C7Uk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=xhoV2oJInvEpJHszK8KgLKDDoJGtFVQdIDVHKEJvIk6J80/zMqTcxVSXvcXx1/yEA
	 FLtrG11J66JQZwAY09tQl5ICak8rqUsACOwrVzvJyopvlgzSzi13kIFo7ebJmulIVx
	 sC0OaQ4qJCH/kFsfEIYypAVE633eTe2wp/4UPXHQ=
Date: Tue, 21 Apr 2026 17:02:30 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/198] 6.18.24-rc1 review
Message-ID: <2026042122-refurnish-silliness-47f1@gregkh>
References: <20260420153935.605963767@linuxfoundation.org>
 <67def94b-6ed0-4000-be08-314f30c7a923@sirena.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67def94b-6ed0-4000-be08-314f30c7a923@sirena.org.uk>

On Tue, Apr 21, 2026 at 03:04:33PM +0100, Mark Brown wrote:
> On Mon, Apr 20, 2026 at 05:39:39PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.18.24 release.
> > There are 198 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> This doesn't build for arm multi_v5_defconfig or bcm2835_defconfig:
> 
> In file included from /build/stage/linux/include/linux/srcu.h:59,
>                  from /build/stage/linux/include/linux/notifier.h:16,
>                  from /build/stage/linux/include/linux/memory_hotplug.h:7,
>                  from /build/stage/linux/include/linux/mmzone.h:1538,
>                  from /build/stage/linux/include/linux/gfp.h:7,
>                  from /build/stage/linux/include/linux/mm.h:7,
>                  from /build/stage/linux/arch/arm/kernel/asm-offsets.c:14:
> /build/stage/linux/include/linux/srcutiny.h:14:10: fatal error: linux/irq_work_t
> ypes.h: No such file or directory
>    14 | #include <linux/irq_work_types.h>
>       |          ^~~~~~~~~~~~~~~~~~~~~~~~


I'll go drop the offending commit,t hanks.

greg k-h
