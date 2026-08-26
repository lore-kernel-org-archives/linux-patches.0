Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526883CEBA7;
	Wed, 26 Aug 2026 10:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787741787; cv=none; b=Gpy/o+kESHpOWWKBIIEYt0Kycya4PMem0oY3/ZibXOzMLD5SY/pzZAT/onRSOrdO9J3yUmVoHyJzXn5z6vA19mxwv5/s80A/ZXqJnW2PbbGpAL/QwoNW2VVU8E9y63rPgvHM39k+g4Qlf6GRSbssukyAOLqDaVY9R/9gPyIQng0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787741787; c=relaxed/simple;
	bh=OlqXrs3FP5/K3FvoQEQfcAAWpkp9P+efwSEp0Z8GkSs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OcEe70F7mhM+R76aFMOKkQbo8konqNFYwYGZabzst+RdyKhpO8WQzSvQZO0WFmDtwp0NlH+pZCT69o5Z6ndbBby+miQ5moqfRIyqCAp8S8aDyyvfiqEvHyqBolUmIRmaWy3qPyqTMF311R/kBtzAPmdWS3mJAI+Ti69a1ANOWtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Stre8xoC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Stre8xoC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C80FB1F000E9;
	Wed, 26 Aug 2026 10:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787741775;
	bh=4ng1xyPLNkCEx8Fpph2DV5F5md26pFFAG/0TMVj0uvU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Stre8xoCySIiCj7EEWrTedPBiqrwGLlPSF6csHS+Iq0SlX+7eERY7ti5v2UXhfB0i
	 5zOlrL5IJAu6mTYht9D/TeLnfO7/lZHiAWsVVGApAKix+54zwTgaqwmV+/yTXMjK4S
	 JglGTy9bk+8KCRPebTrqn0UMTI0Iilt4UI4Kr46I=
Date: Wed, 26 Aug 2026 12:56:13 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: Pavel Machek <pavel@nabladev.com>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.15 00/76] 5.15.218-rc1 review
Message-ID: <2026082658-partake-unlocked-d0c7@gregkh>
References: <20260825132541.568214149@linuxfoundation.org>
 <ao3uOPXs9_3tSs8E@duo.ucw.cz>
 <775e72f4-6c67-4765-bd63-bef5d520a156@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <775e72f4-6c67-4765-bd63-bef5d520a156@nvidia.com>

On Wed, Aug 26, 2026 at 11:28:07AM +0100, Jon Hunter wrote:
> 
> On 25/08/2026 20:34, Pavel Machek wrote:
> > Hi!
> > 
> > > This is the start of the stable review cycle for the 5.15.218 release.
> > > There are 76 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > 
> > Build problems here, I assume it is same one as elsewhere:
> > 
> > https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/2789505612
> FWIW I am seeing the same build issue for ARM with multi_v7_defconfig.
> Seems to be present for v6.1 and v6.6 too.

Offending commit now removed.  For the second time, it keeps coming back
:(


