Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1C21A08A4;
	Thu,  5 Sep 2024 16:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725554028; cv=none; b=RfL9XtryKKduhpFdw+IVbVj1Z+4rVKIhMDU1hLTG+DZpNSMYzoEP2CY7FquhtD408tpo1FxOiCV9pcV/0M8hCKV2wGb8sz7aF3vU+GbYvq6hCNV69A+8rMT8ZqYmmAZTIAbNPVuySXBbpLxyduvHFc6Nt/vtKiARSAUr2rNkJ2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725554028; c=relaxed/simple;
	bh=fV+XkGhCCUlQVvIusu+HetPVTTQeYZyNkRFe9370jes=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SXJ+vWKGJ+l/JHvFZlFUvmu1F2awYuePjpql8f3D3Jub/QBmo6AH4IqUHho2C4CrA5oO9K2jW9EH+wDxGB2qMBFB0QDHJ/xfMPgq02z9vl9lyL4Kv6H7RxUPpI9cAOBbp5H/H8xAjSwJU94kL2gbDq6xH/nPX7aB9YQeZy3GDIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bILZybfJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bILZybfJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C39FC4CEC3;
	Thu,  5 Sep 2024 16:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725554028;
	bh=fV+XkGhCCUlQVvIusu+HetPVTTQeYZyNkRFe9370jes=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bILZybfJNK3SlkLtyn6P+IKhAjQumL0HgemfaaN1Ithi0DiKFVzC3y0VydBt70Rqn
	 B8ePubdErEY6JnxScWYOWVX8Ja7kj/cTwKPA/1ZxBbRIlNiS+ShHJXahHQNKvgeogY
	 VjT7Pi++rW9BRQuygr4fA+uTJrZK9Y2zje6sNSi4=
Date: Thu, 5 Sep 2024 18:33:45 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.10 000/184] 6.10.9-rc1 review
Message-ID: <2024090527-scouts-cohesive-bced@gregkh>
References: <20240905093732.239411633@linuxfoundation.org>
 <CA+G9fYsppY-GyoCFFbAu1q7PdynMLKn024J3CenbN12eefaDwA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYsppY-GyoCFFbAu1q7PdynMLKn024J3CenbN12eefaDwA@mail.gmail.com>

On Thu, Sep 05, 2024 at 05:25:32PM +0530, Naresh Kamboju wrote:
> On Thu, 5 Sept 2024 at 15:13, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.10.9 release.
> > There are 184 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 07 Sep 2024 09:36:50 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.9-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> The following build errors noticed on arm64 on
> stable-rc linux.6.6.y and linux.6.10.y
> 
> drivers/ufs/host/ufs-qcom.c: In function 'ufs_qcom_advertise_quirks':
> drivers/ufs/host/ufs-qcom.c:862:32: error:
> 'UFSHCD_QUIRK_BROKEN_LSDBS_CAP' undeclared (first use in this
> function); did you mean 'UFSHCD_QUIRK_BROKEN_UIC_CMD'?
>   862 |                 hba->quirks |= UFSHCD_QUIRK_BROKEN_LSDBS_CAP;
>       |                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>       |                                UFSHCD_QUIRK_BROKEN_UIC_CMD
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Sasha has dropped these now, let me go push out some -rc2 with that
removed.

thanks,

greg k-h
