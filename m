Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3E02BE043;
	Tue, 16 Dec 2025 10:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765880452; cv=none; b=JLlnNAOeuvwDBx8pPgl4c4jWMmTob8GQztcGhZPVcyAEhOMPu/SenCf9z5Y2DXyYHiJWviEhe0KFmq908K7JsBBE71YDOpAj3c9hCfTY2VPeWf0kbUTLbQvLZDwN+qVgF2MoG9Fd39kFcn92tsLmaoWF3X2YMobKmhMU/0B4AaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765880452; c=relaxed/simple;
	bh=/7iailjfqVha0sAMUUK8KXoQJSsNz3Yax9uU3E/foG8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EP1fGVazW62SSrxdl2bge5Lb4QstjD1qv9lu6jmqFql8PhLHSbjo/bvi/atTTUdxAEB0rYUcAtx4SkOzj2s4wC8qJJCeyoPMCSYj8itpozCOh2qSO2SXxqPhLtmr2rPuh3s/5nhVA91UOvicy142NB149Klp4EFRsBlIbnpafcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gjpeq8s7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gjpeq8s7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64234C4CEF1;
	Tue, 16 Dec 2025 10:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765880451;
	bh=/7iailjfqVha0sAMUUK8KXoQJSsNz3Yax9uU3E/foG8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gjpeq8s73IZg4pA11EADsJsBLw9/dZ/crDElPQVIA48N3LCd0ygWRpcx08wxuQzrJ
	 P1nMpa0F4FlbVY3ZrarSzk4pcCltqC7u3yDQyQw7qKlq6FkrenqZnc7p/i9Vl26Z/O
	 gsi/oUKQKXSJb3C1SuX81KHv74kiIED6n5Zi+vTg=
Date: Tue, 16 Dec 2025 11:20:48 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Guenter Roeck <linux@roeck-us.net>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.12 00/49] 6.12.62-rc1 review
Message-ID: <2025121643-consuming-unusable-043b@gregkh>
References: <20251210072948.125620687@linuxfoundation.org>
 <35e3347a-198f-4143-b094-2d0feb8d6d50@roeck-us.net>
 <CAAhV-H4tiTBqd7mUphq58KdUtvro9HPxZmComr6ku1Mcw6=+9g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAhV-H4tiTBqd7mUphq58KdUtvro9HPxZmComr6ku1Mcw6=+9g@mail.gmail.com>

On Sun, Dec 14, 2025 at 09:24:02AM +0800, Huacai Chen wrote:
> On Sun, Dec 14, 2025 at 12:31 AM Guenter Roeck <linux@roeck-us.net> wrote:
> >
> > On 12/9/25 23:29, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.12.62 release.
> > > There are 49 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Fri, 12 Dec 2025 07:29:38 +0000.
> > > Anything received after that time might be too late.
> > >
> > ...
> > > Huacai Chen <chenhuacai@kernel.org>
> > >      LoongArch: Mask all interrupts during kexec/kdump
> > >
> >
> > This results in:
> >
> > Building loongarch:defconfig ... failed
> > --------------
> > Error log:
> > arch/loongarch/kernel/machine_kexec.c: In function 'machine_crash_shutdown':
> > arch/loongarch/kernel/machine_kexec.c:252:9: error: implicit declaration of function 'machine_kexec_mask_interrupts' [-Wimplicit-function-declaration]
> >    252 |         machine_kexec_mask_interrupts();
> >
> > ... because  there is no loongarch specific version of machine_kexec_mask_interrupts()
> > in v6.12.y, and the function was generalized only with commit bad6722e478f5 ("kexec:
> > Consolidate machine_kexec_mask_interrupts() implementation") in v6.14.
> https://lore.kernel.org/loongarch/20251213094950.1068951-1-chenhuacai@loongson.cn/T/#u

Now queued up, thanks.

greg k-h
