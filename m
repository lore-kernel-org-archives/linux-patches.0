Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 704D01AF0CA;
	Tue,  8 Apr 2025 13:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.237.130.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744118197; cv=none; b=m7tkl7y28I4IFTDLGQVYIcFZOIKODeFhwOupNSUv51/8vhF2+pDlZ9xfKrVNYLzsjo8o6r4xGJOn0EkCxNnjaPAfR8Zt7yW7CjYVmn4fLSg6XwJeIxv4aHdOW8UjSjLqFQnWooNEGaMOEq9v71hYzrmvSc2nw+WAA1XGPeERYsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744118197; c=relaxed/simple;
	bh=MhEN1i5xu/9dGHu00/9Ckw1UTC+PDsvHzMy8BK1WVjA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kgFvhlDBtVxFy74v8c8i4/pcIqB6BXZRb9YwAKjO5cJBB3ocDkLDiAwAQeEowjnMR+LaWxt2nyASOkBiLsjjc+x7EIA8SS5wWAC1RLAQnZq0IKY+IeU+/6DB80anv6LPYB9GMQ/DpdsyhU/dMtp0QGdfCfsXmGI+qJZ/CYXcAHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=PqJRiyNB; arc=none smtp.client-ip=80.237.130.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="PqJRiyNB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=leemhuis.info; s=he214686; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:From:
	Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To:
	References; bh=caMTW2YFhPgzDBie2cfGBil1iBGo+AGd3ZOvs1aYh6c=; t=1744118195;
	x=1744550195; b=PqJRiyNBc/T3HumFXgICkpcFY8h+qEZIdUg5AP4E6FFo+KLv0nEXI2FXGuwj0
	2etlwDdodwOLvGnXZ/UHrOQdN+btbZKGu6BJTHy7xSdoqdGHDft/ESUAWp4VX6R7I9o+4KTU8nw8P
	e8tTcLlxunW9dBBm96TZwE2hX6BerrGGAvI21aSfSKIk9ysu2rQOCYbK7mtH1dU8HUOVMfpzSvY9h
	WzWIR1i1ZXjtCZ3iZFRV8a1DTTXxIhuYM6j+WuEL7JoqRYizEwmb6ldLEsSl8UTrphLXWv0RkADOD
	aHOT+sKZJxNSwP+9b4NIS8V9fIdK64vki8KtQ9OXV4OhYg9Vgw==;
Received: from [2a02:8108:8984:1d00:a0cf:1912:4be:477f]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128)
	id 1u28oa-0021Qh-2z;
	Tue, 08 Apr 2025 15:16:33 +0200
Message-ID: <c06b17f2-fc80-47a9-b108-8e53be3d4a76@leemhuis.info>
Date: Tue, 8 Apr 2025 15:16:31 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.14 000/731] 6.14.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Miguel Ojeda <ojeda@kernel.org>, Justin Forbes <jforbes@fedoraproject.org>,
 Alex Gaynor <alex.gaynor@gmail.com>
References: <20250408104914.247897328@linuxfoundation.org>
From: Thorsten Leemhuis <linux@leemhuis.info>
Content-Language: de-DE, en-US
Autocrypt: addr=linux@leemhuis.info; keydata=
 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 n7RI
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;linux@leemhuis.info;1744118195;b4e03392;
X-HE-SMSGID: 1u28oa-0021Qh-2z

On 08.04.25 12:38, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.2 release.
> There are 731 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Compiling for Fedora failed for me:


"""
error[E0412]: cannot find type `Core` in module `device`
  --> rust/kernel/pci.rs:69:58
   |
69 |         let pdev = unsafe { &*pdev.cast::<Device<device::Core>>() };
   |                                                          ^^^^ not found in `device`

error[E0412]: cannot find type `Core` in module `device`
   --> rust/kernel/pci.rs:240:35
    |
240 |     fn probe(dev: &Device<device::Core>, id_info: &Self::IdInfo) -> Result<Pin<KBox<Self>>>;
    |                                   ^^^^ not found in `device`

error[E0405]: cannot find trait `DeviceContext` in module `device`
   --> rust/kernel/pci.rs:253:32ich of
    |
253 | pub struct Device<Ctx: device::DeviceContext = device::Normal>(
    |                                ^^^^^^^^^^^^^ not found in `device`

error[E0412]: cannot find type `Normal` in module `device`
   --> rust/kernel/pci.rs:253:56
    |
253 | pub struct Device<Ctx: device::DeviceCchangeontext = device::Normal>(
    |                                                        ^^^^^^ not found in `device`
    |
help: there is an enum variant `core::intrinsics::mir::BasicBlock::Normal` and 1 other; try using the variant's enum
    |
253 | pub struct Device<Ctx: device::DeviceContext = core::intrinsics::mir::BasicBlock>(
    |                                                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
253 | pub struct Device<Ctx: device::DeviceContext = core::num::FpCategory>(
    |                                                ~~~~~~~~~~~~~~~~~~~~~

error[E0412]: cannot find type `Core` in module `device`
   --> rust/kernel/pci.rs:411:21
    |
411 | impl Device<device::Core> {
    |                     ^^^^ not found in `device`

error[E0412]: cannot find type `Core` in module `device`
   --> rust/kernel/pci.rs:425:31
    |
425 | impl Deref for Device<device::Core> {
    |                               ^^^^ not found in `device`

error[E0412]: cannot find type `Core` in module `device`
   --> rust/kernel/pci.rs:439:27
    |
439 | impl From<&Device<device::Core>> for ARef<Device> {
    |                           ^^^^ not found in `device`

error[E0412]: cannot find type `Core` in module `device`
   --> rust/kernel/pci.rs:440:34
    |
440 |     fn from(dev: &Device<device::Core>) -> Self {
    |                                  ^^^^ not found in `device`

error[E0412]: cannot find type `Core` in module `device`
  --> rust/kernel/platform.rs:65:58
   |
65 |         let pdev = unsafe { &*pdev.cast::<Device<device::Core>>() };
   |                                                          ^^^^ not found in `device`

error[E0412]: cannot find type `Core` in module `device`
   --> rust/kernel/platform.rs:167:35
    |
167 |     fn probe(dev: &Device<device::Core>, id_info: Option<&Self::IdInfo>)
    |                                   ^^^^ not found in `device`

error[E0405]: cannot find trait `DeviceContext` in module `device`
   --> rust/kernel/platform.rs:182:32
    |
182 | pub struct Device<Ctx: device::DeviceContext = device::Normal>(
    |                                ^^^^^^^^^^^^^ not found in `device`

error[E0412]: cannot find type `Normal` in module `device`
   --> rust/kernel/platform.rs:182:56
    |
182 | pub struct Device<Ctx: device::DeviceContext = device::Normal>(
    |                                                        ^^^^^^ not found in `device`
    |
help: there is an enum variant `core::intrinsics::mir::BasicBlock::Normal` and 1 other; try using the variant's enum
    |
182 | pub struct Device<Ctx: device::DeviceContext = core::intrinsics::mir::BasicBlock>(
    |                                                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
182 | pub struct Device<Ctx: device::DeviceContext = core::num::FpCategory>(
    |                                                ~~~~~~~~~~~~~~~~~~~~~

error[E0412]: cannot find type `Core` in module `device`
   --> rust/kernel/platform.rs:193:31
    |
193 | impl Deref for Device<device::Core> {
    |                               ^^^^ not found in `device`

error[E0412]: cannot find type `Core` in module `device`
   --> rust/kernel/platform.rs:207:27
    |
207 | impl From<&Device<device::Core>> for ARef<Device> {
    |                           ^^^^ not found in `device`

error[E0412]: cannot find type `Core` in module `device`
   --> rust/kernel/platform.rs:208:34
    |
208 |     fn from(dev: &Device<device::Core>) -> Self {
    |                                  ^^^^ not found in `device`

error: aborting due to 15 previous errors

Some errors have detailed explanations: E0405, E0412.
For more information about an error, try `rustc --explain E0405`.
make[2]: *** [rust/Makefile:482: rust/kernel.o] Error 1
make[1]: *** [/builddir/build/BUILD/kernel-6.14.2-build/kernel-6.14.2-rc1/linux-6.14.2-0.rc1.300.vanilla.fc42.x86_64/Makefile:1283: prepare] Error 2
make: *** [Makefile:259: __sub-make] Error 2
"""


From a quick look there seem to be three changes in this set that touch
rust/kernel/pci.rs; if needed, I can take a closer look later or tomorrow
what exactly is causing trouble (I just hope it's no new build requirement
missing on my side or something like that).

Ciao, Thorsten
