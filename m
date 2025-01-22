Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F99E1DFFD;
	Wed, 22 Jan 2025 07:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737531315; cv=none; b=R+c3tcB37sxIiz2CagykOTLZPbo6UJ9IjQNMFS8D1wOD5klQveuJB4pf7dzqMPXQLmqsW+CGrblEAiJ28eF3bPLbkPtuDHMUc5K93I4tXOYsDjGEX1ohGVbCyNpRL+0YWkINL55o2xhSUmzmZLEmx7f+19loKAJ9kCAWTpD2oMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737531315; c=relaxed/simple;
	bh=a5QHtHVLyhLuhEE3Mv1rm+vMRptEsx69289G4WrZtuE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Evl69jXvUAM0S1BULjb/8TsyB0u7JMWHHgoQonPDqwpkf55/rT9T8VH5KZH0hfxgwid22+3TlxmHxFEXH5dUAXOOaVD0aXeAfiRJ+faKJDGazYvcJ0l7AxT2A8TaL1mMCemRqrwJ72/DTmi+atvne6bYisUjBz03F354P1AASqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YLR0U35n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YLR0U35n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D0A8C4CED6;
	Wed, 22 Jan 2025 07:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737531313;
	bh=a5QHtHVLyhLuhEE3Mv1rm+vMRptEsx69289G4WrZtuE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YLR0U35n+h+ZAh/5lWBzN4tms0Iyz1blGE4IODytbLJrXW/JTehJjIUZn56XcCCFF
	 AXziHPBpGGHDU6rjZNQ5KYzsL5rpV8/0CxpICQGOdRgI9rsK8sVesgpuw7P54gez4t
	 MLxeMcomiTygoF1mleYhhj5JJcHrX0AUs/1ibDok=
Date: Wed, 22 Jan 2025 08:35:11 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Salvatore Bonaccorso <carnil@debian.org>
Cc: Peter Schneider <pschneider1968@googlemail.com>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 00/64] 6.1.127-rc1 review
Message-ID: <2025012244-rigor-boat-b44d@gregkh>
References: <20250121174521.568417761@linuxfoundation.org>
 <b5f7b88a-0f6a-4815-8344-bf6bf941bc91@googlemail.com>
 <Z5AYNaxIm-SwmUHb@eldamar.lan>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z5AYNaxIm-SwmUHb@eldamar.lan>

On Tue, Jan 21, 2025 at 10:57:09PM +0100, Salvatore Bonaccorso wrote:
> Hi,
> 
> On Tue, Jan 21, 2025 at 08:32:01PM +0100, Peter Schneider wrote:
> > Am 21.01.2025 um 18:51 schrieb Greg Kroah-Hartman:
> > > This is the start of the stable review cycle for the 6.1.127 release.
> > > There are 64 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > 
> > 
> > On my 2-socket Ivy Bridge Xeon E5-2697 v2 server, I get a build error:
> > 
> >   CC [M]  drivers/gpu/drm/amd/amdgpu/../display/dmub/src/dmub_dcn303.o
> >   CC [M]  drivers/gpu/drm/amd/amdgpu/../display/dmub/src/dmub_dcn31.o
> >   CC [M]  drivers/gpu/drm/amd/amdgpu/../display/dmub/src/dmub_dcn314.o
> >   CC [M]  drivers/gpu/drm/amd/amdgpu/../display/dmub/src/dmub_dcn315.o
> >   CC [M]  drivers/gpu/drm/amd/amdgpu/../display/dmub/src/dmub_dcn316.o
> >   CC [M]  drivers/gpu/drm/amd/amdgpu/../display/dmub/src/dmub_dcn32.o
> >   LD [M]  drivers/gpu/drm/amd/amdgpu/amdgpu.o
> >   AR      drivers/gpu/built-in.a
> >   AR      drivers/built-in.a
> >   AR      built-in.a
> >   AR      vmlinux.a
> >   LD      vmlinux.o
> >   OBJCOPY modules.builtin.modinfo
> >   GEN     modules.builtin
> >   GEN     .vmlinux.objs
> >   MODPOST Module.symvers
> > ERROR: modpost: module inv-icm42600-spi uses symbol
> > inv_icm42600_spi_regmap_config from namespace IIO_ICM42600, but does not
> > import it.
> > make[1]: *** [scripts/Makefile.modpost:127: Module.symvers] Fehler 1
> > make: *** [Makefile:1961: modpost] Fehler 2
> > root@linus:/usr/src/linux-stable-rc#
> > 
> > I have attached my .config file.
> 
> Reverting c0f866de4ce447bca3191b9cefac60c4b36a7922 would solve the
> problem, but then maybe the other icm42600 related commits are
> incorrect? Guess it's a missing prequisite for that commit missing in
> 6.1.y.
> 
> Can confirm the failure as well in a test build for Debian.

Ok, let me go fix this up, it's due to the namespace symbol stuff not
being in 6.1.y, I'll hand edit the offending commit and push out a -rc2.

thanks,

greg k-h
