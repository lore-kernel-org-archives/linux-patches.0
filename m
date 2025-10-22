Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8BF2EC0BD;
	Wed, 22 Oct 2025 05:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761111172; cv=none; b=W8MdZn19j26tYpMS76qAknaibzMafc8sfPXjJxK13p9xW37oubmsoXjB9aYdwjQWZHqGvmlkkpeefRxMm+0JW3EeDVIxZcHHjIJFolLci/e9x9eErPj4kYAU3t3wMoWF/n3Kx+2MlbWd7xnJKFhFqiXrMiYOB6fYOOK6Drzcsjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761111172; c=relaxed/simple;
	bh=+VI8strPvG91hJdErc+XwoQ1a+WncizfTTCaBYO8JjA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QUwrYIY1iM8790ezxAbK2R3hFfW8DWuxmWimTWn2rcQBz1mZpWz9a24qIj4gaY7YVqOyaHxNVxWsy2yER24O6kjCGuTTdi5HqPYHtNQumGdO3sp7fxcZZnlwgNuUDanbInc8LvLETpqIWlhexqdSFNDXhzRE5P6s2DbKGmCAvf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M/vT6Yaw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M/vT6Yaw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D71B4C4CEF5;
	Wed, 22 Oct 2025 05:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761111172;
	bh=+VI8strPvG91hJdErc+XwoQ1a+WncizfTTCaBYO8JjA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M/vT6YawW2GXUrYumPRdX8cAghlwLIMIYv/L9k4D2naDkkHXkRXJyYco9rZJKJ1Sg
	 mzL/FRqYu7siA6BBb79tiwBZIL2RT+AGMIevn9F2vB+/lRn0T8lHA62Da/GxD2ygD0
	 yiWehzZtYLGbdwG6tRlGJEvBOtIi0c+5NDGw6J4M=
Date: Wed, 22 Oct 2025 07:32:49 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?= <holger@applied-asynchrony.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	"Mario Limonciello (AMD)" <superm1@kernel.org>
Subject: Re: [PATCH 6.17 000/159] 6.17.5-rc1 review
Message-ID: <2025102239-commuting-roaming-eae0@gregkh>
References: <20251021195043.182511864@linuxfoundation.org>
 <fc400181-7c76-6344-c6ea-a4e48d722f55@applied-asynchrony.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fc400181-7c76-6344-c6ea-a4e48d722f55@applied-asynchrony.com>

On Tue, Oct 21, 2025 at 11:30:26PM +0200, Holger Hoffstätte wrote:
> On 2025-10-21 21:49, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.17.5 release.
> 
> Hmm:
> 
> *  LD [M]  drivers/gpu/drm/amd/amdgpu/amdgpu.o
> *  MODPOST Module.symvers
> *ERROR: modpost: "pm_hibernation_mode_is_suspend" [drivers/gpu/drm/amd/amdgpu/amdgpu.ko] undefined!
> 
> Caused by drm-amd-fix-hybrid-sleep.patch
> 
> I have CONFIG_SUSPEND enabled, exactly same config as 6.17.4.
> 
> Looking at mainline it seems we also need parts of:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=495c8d35035edb66e3284113bef01f3b1b843832
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=bbfe987c5a2854705393ad79813074e5eadcbde6

Thanks, let me go fix this up and push out a -rc2.

greg k-h
