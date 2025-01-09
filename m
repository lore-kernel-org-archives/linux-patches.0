Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1199321577F;
	Thu,  9 Jan 2025 10:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736417545; cv=none; b=gqpdtTCH6v4qdstqa70SvoeRNkA5b4fXu0yRla/YSeY4Sk3czQvUCJ/V9eD5u5H/d+t+obX+JmAvXIYAB+juQqqaX3M4gWYYncRSzx7s60/lQx7vhc20x9GerRCwQAzRvPjaZYHUu//4pWYCDMMZFlWFZRgPLeqahiVJbrWZ5gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736417545; c=relaxed/simple;
	bh=mpf4PO0MC/K24WEphpG967MEZW2PWTj0uQneUZTTeic=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dcz6D4tm89cbSURaOcKN0NPcSciW4BjWvz5ouHGCLnXRIx8Z3KwiJwMwv98ZYzbvOodMToD9/owJ4nk7c3g6hr1NdmQVrmeGc1RglmA/D3pj/mVVYI3fKcjFOuJVIvP1ixvl3UcKHlEPdcSYU++WzLXD+OYaYVg5VDGfmcY3CW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xI3SIYSn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xI3SIYSn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03FC3C4CED2;
	Thu,  9 Jan 2025 10:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736417544;
	bh=mpf4PO0MC/K24WEphpG967MEZW2PWTj0uQneUZTTeic=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=xI3SIYSnYad3ViLE7wozlCC6NCqqncOyF/XF/EKG47JUN7GNP7n8sHuSeXGHLq7SY
	 r4Gc04nZBe4p/rJdEG2uJdEMac1nI2ezVh/faMabFYgs7MjpVkmuQiXxrBQuUDum5U
	 6Q02CLidEnkuZqn51m5SvmZ1U7BoMrmWUWzZ2EUE=
Date: Thu, 9 Jan 2025 11:12:21 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Muhammad Usama Anjum <Usama.Anjum@collabora.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 5.4 00/93] 5.4.289-rc1 review
Message-ID: <2025010900-camping-giggle-fbe2@gregkh>
References: <20250106151128.686130933@linuxfoundation.org>
 <9382652c-939d-4368-a4b2-93798ba0da19@collabora.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9382652c-939d-4368-a4b2-93798ba0da19@collabora.com>

On Wed, Jan 08, 2025 at 06:00:40PM +0500, Muhammad Usama Anjum wrote:
> On 1/6/25 8:16 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.289 release.
> > There are 93 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 08 Jan 2025 15:11:04 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.289-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > -------------
> OVERVIEW
> 
>         Builds: 34 passed, 4 failed

Are these new failures?  Or old ones?  Knowing this would help out a
lot, thanks.

greg k-h
