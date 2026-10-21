Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792563293;
	b=E/Ea1/xbQCg/l8Lk35U3LqY2eBq4N1/bIuPhGG7VA/BDbUusOsiBTMBQv0Z5NTxfv3rP
	 oeOLtvbTYp9P0bolY5najamt6C/GEvHNf22nfK0tyakQWr2W4nZixMtBNJUPDBiwuoDWY
	 Caqv6PlnxuO11fav9DNL8UPAL4EPpCgHdArb5jD9LTnm4i0cpzH/hNmJGtmBOD9otj5y7
	 jlJWLc35Rne93SbPp0LECGu2zNHiXqmS2WWP/Qf8fW/VN9wrkR4CWgt7ypef3Fz685HV/
	 ekBDLKcgIqx7TUECh0KTDORO3WnAu76AGjG9YKb0Zi8YF4OxtCNyF8K69q+3a9oravQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792563293;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=3x3TamlaaK9V9PCuBZqg1dttpYbp4NHVNda75j19VEs=;
	b=y/RlcmwruTp93oz8nr67xvmlt5vJjkQy4eKv3RNkjFgG7Rz+4x3YAkz702d8cLbvp3qi
	 MZ4qr4dCH7tlEbp3HysjcgbT7ONN4JthBw4GYO4NEYzpBJ9DYi7tCp14zIZghaQRIHRck
	 /M15NQ8owsIiUjGzR5tRBHXVVE3vFtULuJUoOB/uv+Dd7IzYuHiOrRmmqSvy8+IrGtNUG
	 T3gyV53cg0zD0J06d/H/4VFKiSfT5nmRVufgxbedA3VvY/BZ8LcUo531WhDACXEPwrqNc
	 PmFP65ufqprGjiuRbm3IbcL2BBA1SIOyVpj+Py48f5K7jgljUJCFuz6DLCfhFL2PNcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39F13606A32A
	for <patches@lists.linux.dev>; Wed, 21 Oct 2026 06:14:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 39F13606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DF9A815A1;
	Tue, 20 Oct 2026 23:14:37 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7D69D3F673;
	Tue, 20 Oct 2026 23:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792563281; bh=bY7eaKmWXeEGJZPv0klJ3mm9fvB9sa6YQ58K0dGT+DQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Dz1W2m1mtqieAvvcHZ0PElJP5ck781BRAil8keCt0J0xDmnmsvOtE2z2M/5OD8bJT
	 x0mY2JIMQy/68/SPz8OHAETC2GSRyy6i0mXuMcfrF0pwBi7AW/wwQj2YV7ClSyJ7P8
	 z7NHuQtFqmTF4JQhakFU6b9pfZaA/t3mKW3YduKY=
Date: Wed, 21 Oct 2026 07:14:33 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>, Ard Biesheuvel <ardb@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, David Sterba <dsterba@suse.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org, linux-efi@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Simon Glass <sjg@chromium.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Nick Terrell <terrelln@fb.com>, Will Deacon <will@kernel.org>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	linux-integrity@vger.kernel.org,
	Palmer Dabbelt <palmer@rivosinc.com>, patches@lists.linux.dev,
	Piotr =?iso-8859-1?Q?Kr=F3l?= <piotr.krol@3mdeb.com>,
	Ross Philipson <ross.philipson@gmail.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Song Shuai <songshuaishuai@tinylab.org>
Subject: Re: [PATCH v2 15/15] efi/arm64: Implement ARM64 DRTM in the stub
Message-ID: <athYSbJXA96DZK-X@e129823.arm.com>
References: <0-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
 <15-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
 <atf4ONRM3xbs877y@e129823.arm.com>
 <20261020233435.GJ3008132@nvidia.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261020233435.GJ3008132@nvidia.com>

On Tue, Oct 20, 2026 at 08:34:35PM -0300, Jason Gunthorpe wrote:
> On Wed, Oct 21, 2026 at 12:24:40AM +0100, Yeoreum Yun wrote:
> > One small question...
> > 
> > [..snipped..]
> > 
> > > +void efi_drtm_launch(void)
> > > +{
> > > +	if (efi_drtm_policy == EFI_DRTM_OFF)
> > > +		return;
> > > +
> > > +	/*
> > > +	 * No cache maintenance is required before the launch. v1.4B R42130 in
> > > +	 * Table 22 "DCE preamble requirements" requires the DRTM_PARAMETERS to
> > > +	 * be accessible as Normal Write-Back Cacheable, Inner Shareable memory,
> > > +	 * so the DCE reads them coherently with the writes made above.  R45220
> > > +	 * in Table 30 "DCE requirements for the DLME" then has the DCE clean
> > > +	 * and invalidate the whole DLME region to the Point of Coherency before
> > > +	 * it measures the DLME image, which covers both the Image itself and
> > > +	 * the handoff struct placed in the DLME region. Thus once we jump into
> > > +	 * the kernel with MMU and caches off the CPU will see everything the
> > > +	 * stub wrote.
> > > +	 */
> > > +	arm_drtm_dynamic_launch(drtm_cfg.params_addr);
> > 
> > After launching, How to get eventlogs for measurement of DLEM if
> > tpm_read_log_efi() is used? Doesn't it need to concatenate those
> > event logs from DRTM eventlog in returned DLEM data?
> 
> My plan is a future series will return them as a discrete log bundle
> through attestation subsystem. All of the logs will be available
> consistently that way, CCGL, the EFI and ACPI ones..
> 
> And it will be logically linked to the ROT the DRTM uses in some
> future ROT agile DRTM flow. So we can tell the difference between a
> TPM bare metal launch into PCRs and something like a realm launch into
> REMs.

Make sense. Thanks!

-- 
Sincerely,
Yeoreum Yun
