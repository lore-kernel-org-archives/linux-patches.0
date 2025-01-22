Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D75A31DFFD;
	Wed, 22 Jan 2025 07:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737531528; cv=none; b=QQOkA0AYDhJGL/rd+FIBHK5gCqyAHOEXaLO5luP6wjbo8VxdbLs2+Sk6UZ6QquexA5Hbgk1eb2Y8p4EN00AxrIYSSD8s25wyg0bzLoh4kWnoc8C2bUIaMefc5GBQ6BYYPKBfyKvCTWaaDzeQ5FWEq3mCSX4qlugRt2gBQXhrDWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737531528; c=relaxed/simple;
	bh=yZ5+lSIuOVgbFngowQBADMtIw4biT9MQ7x58OGMT+BA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tEbTJDQ5MS0gEnBOhVY3tSuaxdhd2A8Ad+PgD31gjj5Z4AXK8MeGnwayeZ5RgMHIgjHPQ0qfjVjTggrMKhL2rKiGBuEnaZzZZop1MVOCzaRt3W+p8PhZkUYcuUquaFT8c6EWf9RxjQlOWHNAHb7+ORqjx8KsFPc6kzrgikZzA/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VFDA8WLn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VFDA8WLn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C037BC4CED6;
	Wed, 22 Jan 2025 07:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737531526;
	bh=yZ5+lSIuOVgbFngowQBADMtIw4biT9MQ7x58OGMT+BA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VFDA8WLn9sGaV2DpXEcmvw6darJEj4LpHMmmG98Ec1PsjUm5XFkGn2I5/Sjiyjyx5
	 IoBL1S0nmWT4r+uqNkYS8L945v4bQnep/JTHYrK3D6swa+JX3Zg7MznmaoWjl+02Tl
	 8IokE/d3SCTDRNjfQU4YFfdYwvWfrmEr3WMzQLgI=
Date: Wed, 22 Jan 2025 08:38:43 +0100
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
Message-ID: <2025012221-whenever-sterile-11e2@gregkh>
References: <20250121174521.568417761@linuxfoundation.org>
 <b5f7b88a-0f6a-4815-8344-bf6bf941bc91@googlemail.com>
 <Z5AYNaxIm-SwmUHb@eldamar.lan>
 <2025012244-rigor-boat-b44d@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025012244-rigor-boat-b44d@gregkh>

On Wed, Jan 22, 2025 at 08:35:11AM +0100, Greg Kroah-Hartman wrote:
> On Tue, Jan 21, 2025 at 10:57:09PM +0100, Salvatore Bonaccorso wrote:
> > Hi,
> > 
> > On Tue, Jan 21, 2025 at 08:32:01PM +0100, Peter Schneider wrote:
> > > Am 21.01.2025 um 18:51 schrieb Greg Kroah-Hartman:
> > > > This is the start of the stable review cycle for the 6.1.127 release.
> > > > There are 64 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > 
> > > 
> > > On my 2-socket Ivy Bridge Xeon E5-2697 v2 server, I get a build error:
> > > 
> > >   CC [M]  drivers/gpu/drm/amd/amdgpu/../display/dmub/src/dmub_dcn303.o
> > >   CC [M]  drivers/gpu/drm/amd/amdgpu/../display/dmub/src/dmub_dcn31.o
> > >   CC [M]  drivers/gpu/drm/amd/amdgpu/../display/dmub/src/dmub_dcn314.o
> > >   CC [M]  drivers/gpu/drm/amd/amdgpu/../display/dmub/src/dmub_dcn315.o
> > >   CC [M]  drivers/gpu/drm/amd/amdgpu/../display/dmub/src/dmub_dcn316.o
> > >   CC [M]  drivers/gpu/drm/amd/amdgpu/../display/dmub/src/dmub_dcn32.o
> > >   LD [M]  drivers/gpu/drm/amd/amdgpu/amdgpu.o
> > >   AR      drivers/gpu/built-in.a
> > >   AR      drivers/built-in.a
> > >   AR      built-in.a
> > >   AR      vmlinux.a
> > >   LD      vmlinux.o
> > >   OBJCOPY modules.builtin.modinfo
> > >   GEN     modules.builtin
> > >   GEN     .vmlinux.objs
> > >   MODPOST Module.symvers
> > > ERROR: modpost: module inv-icm42600-spi uses symbol
> > > inv_icm42600_spi_regmap_config from namespace IIO_ICM42600, but does not
> > > import it.
> > > make[1]: *** [scripts/Makefile.modpost:127: Module.symvers] Fehler 1
> > > make: *** [Makefile:1961: modpost] Fehler 2
> > > root@linus:/usr/src/linux-stable-rc#
> > > 
> > > I have attached my .config file.
> > 
> > Reverting c0f866de4ce447bca3191b9cefac60c4b36a7922 would solve the
> > problem, but then maybe the other icm42600 related commits are
> > incorrect? Guess it's a missing prequisite for that commit missing in
> > 6.1.y.
> > 
> > Can confirm the failure as well in a test build for Debian.
> 
> Ok, let me go fix this up, it's due to the namespace symbol stuff not
> being in 6.1.y, I'll hand edit the offending commit and push out a -rc2.

Same issue should be present in the 5.15-rc release, I'll go fix it up
there too.  Odd it didn't get caught in my build testing...

greg k-h
