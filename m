Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2991C5485;
	Tue,  8 Apr 2025 14:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744121044; cv=none; b=JvLKsWyAOgvMUrcaS7OgtNEkbDsmzXqIDZZPwp/rfKPlWu1+pKGIlJ9okP6O68+zAfUm48eEREuwJKtf5wCkQ27zzvIDwigu18aXimCI4TG93S3SSkgtz2elPa/EBG2BRJzyEq49BOPuP7rC4i9Dz6+PAa+lvFHQhtjvgI1rz5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744121044; c=relaxed/simple;
	bh=BzFbZA1m9dFOlKsy5ES02lDgkZDWoW80YEBIeHHNu+k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L0Eftc2i6zA+krKBHqIExK63Ip9uf3FTF+6SgliWc2yr/AXFeDiZnEj+ChkvZRio6UDb/D9boNf90vxPZYNhWgr3mDf5XLbTsOkrb/KzICf/9jm3CwoyBasK9EyMl6R3yvSnNnTxbF1slrObY86TsAs0n7WfPOavO+kxUo+ZNZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FP+SRwJ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FP+SRwJ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B66C9C4CEE5;
	Tue,  8 Apr 2025 14:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744121043;
	bh=BzFbZA1m9dFOlKsy5ES02lDgkZDWoW80YEBIeHHNu+k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FP+SRwJ8NwtZ6RWvC+sp2R+vSOyb/SVNnj+502MfqxHqobE254c3WPy05xy9friP4
	 gVDbaV14c31Exg+Ww8M0fHQxK7a1M8AcvIKXwrN78CKmfq9fJseo9trjqpDKcXfhsh
	 wpQ3bxziDcAZVqD11IkMZdI+YDcQyaKiZCLBZFmQ=
Date: Tue, 8 Apr 2025 16:02:29 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thorsten Leemhuis <linux@leemhuis.info>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	Miguel Ojeda <ojeda@kernel.org>,
	Justin Forbes <jforbes@fedoraproject.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
Subject: Re: [PATCH 6.14 000/731] 6.14.2-rc1 review
Message-ID: <2025040857-disdain-reprocess-0891@gregkh>
References: <20250408104914.247897328@linuxfoundation.org>
 <c06b17f2-fc80-47a9-b108-8e53be3d4a76@leemhuis.info>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c06b17f2-fc80-47a9-b108-8e53be3d4a76@leemhuis.info>

On Tue, Apr 08, 2025 at 03:16:31PM +0200, Thorsten Leemhuis wrote:
> On 08.04.25 12:38, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.14.2 release.
> > There are 731 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> Compiling for Fedora failed for me:
> 
> 
> """
> error[E0412]: cannot find type `Core` in module `device`
>   --> rust/kernel/pci.rs:69:58
>    |
> 69 |         let pdev = unsafe { &*pdev.cast::<Device<device::Core>>() };
>    |                                                          ^^^^ not found in `device`
> 
> error[E0412]: cannot find type `Core` in module `device`
>    --> rust/kernel/pci.rs:240:35
>     |
> 240 |     fn probe(dev: &Device<device::Core>, id_info: &Self::IdInfo) -> Result<Pin<KBox<Self>>>;
>     |                                   ^^^^ not found in `device`
> 
> error[E0405]: cannot find trait `DeviceContext` in module `device`
>    --> rust/kernel/pci.rs:253:32ich of
>     |
> 253 | pub struct Device<Ctx: device::DeviceContext = device::Normal>(
>     |                                ^^^^^^^^^^^^^ not found in `device`
> 
> error[E0412]: cannot find type `Normal` in module `device`
>    --> rust/kernel/pci.rs:253:56
>     |
> 253 | pub struct Device<Ctx: device::DeviceCchangeontext = device::Normal>(
>     |                                                        ^^^^^^ not found in `device`
>     |
> help: there is an enum variant `core::intrinsics::mir::BasicBlock::Normal` and 1 other; try using the variant's enum
>     |
> 253 | pub struct Device<Ctx: device::DeviceContext = core::intrinsics::mir::BasicBlock>(
>     |                                                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 253 | pub struct Device<Ctx: device::DeviceContext = core::num::FpCategory>(
>     |                                                ~~~~~~~~~~~~~~~~~~~~~
> 
> error[E0412]: cannot find type `Core` in module `device`
>    --> rust/kernel/pci.rs:411:21
>     |
> 411 | impl Device<device::Core> {
>     |                     ^^^^ not found in `device`
> 
> error[E0412]: cannot find type `Core` in module `device`
>    --> rust/kernel/pci.rs:425:31
>     |
> 425 | impl Deref for Device<device::Core> {
>     |                               ^^^^ not found in `device`
> 
> error[E0412]: cannot find type `Core` in module `device`
>    --> rust/kernel/pci.rs:439:27
>     |
> 439 | impl From<&Device<device::Core>> for ARef<Device> {
>     |                           ^^^^ not found in `device`
> 
> error[E0412]: cannot find type `Core` in module `device`
>    --> rust/kernel/pci.rs:440:34
>     |
> 440 |     fn from(dev: &Device<device::Core>) -> Self {
>     |                                  ^^^^ not found in `device`
> 
> error[E0412]: cannot find type `Core` in module `device`
>   --> rust/kernel/platform.rs:65:58
>    |
> 65 |         let pdev = unsafe { &*pdev.cast::<Device<device::Core>>() };
>    |                                                          ^^^^ not found in `device`
> 
> error[E0412]: cannot find type `Core` in module `device`
>    --> rust/kernel/platform.rs:167:35
>     |
> 167 |     fn probe(dev: &Device<device::Core>, id_info: Option<&Self::IdInfo>)
>     |                                   ^^^^ not found in `device`
> 
> error[E0405]: cannot find trait `DeviceContext` in module `device`
>    --> rust/kernel/platform.rs:182:32
>     |
> 182 | pub struct Device<Ctx: device::DeviceContext = device::Normal>(
>     |                                ^^^^^^^^^^^^^ not found in `device`
> 
> error[E0412]: cannot find type `Normal` in module `device`
>    --> rust/kernel/platform.rs:182:56
>     |
> 182 | pub struct Device<Ctx: device::DeviceContext = device::Normal>(
>     |                                                        ^^^^^^ not found in `device`
>     |
> help: there is an enum variant `core::intrinsics::mir::BasicBlock::Normal` and 1 other; try using the variant's enum
>     |
> 182 | pub struct Device<Ctx: device::DeviceContext = core::intrinsics::mir::BasicBlock>(
>     |                                                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 182 | pub struct Device<Ctx: device::DeviceContext = core::num::FpCategory>(
>     |                                                ~~~~~~~~~~~~~~~~~~~~~
> 
> error[E0412]: cannot find type `Core` in module `device`
>    --> rust/kernel/platform.rs:193:31
>     |
> 193 | impl Deref for Device<device::Core> {
>     |                               ^^^^ not found in `device`
> 
> error[E0412]: cannot find type `Core` in module `device`
>    --> rust/kernel/platform.rs:207:27
>     |
> 207 | impl From<&Device<device::Core>> for ARef<Device> {
>     |                           ^^^^ not found in `device`
> 
> error[E0412]: cannot find type `Core` in module `device`
>    --> rust/kernel/platform.rs:208:34
>     |
> 208 |     fn from(dev: &Device<device::Core>) -> Self {
>     |                                  ^^^^ not found in `device`
> 
> error: aborting due to 15 previous errors
> 
> Some errors have detailed explanations: E0405, E0412.
> For more information about an error, try `rustc --explain E0405`.
> make[2]: *** [rust/Makefile:482: rust/kernel.o] Error 1
> make[1]: *** [/builddir/build/BUILD/kernel-6.14.2-build/kernel-6.14.2-rc1/linux-6.14.2-0.rc1.300.vanilla.fc42.x86_64/Makefile:1283: prepare] Error 2
> make: *** [Makefile:259: __sub-make] Error 2
> """
> 
> 
> >From a quick look there seem to be three changes in this set that touch
> rust/kernel/pci.rs; if needed, I can take a closer look later or tomorrow
> what exactly is causing trouble (I just hope it's no new build requirement
> missing on my side or something like that).

Hm,  odd, I thought I was testing Rust builds on my build system but
obviously not.  I'll go work on this later tonight...

thanks,

greg k-h
