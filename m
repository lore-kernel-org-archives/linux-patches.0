Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792592284;
	b=zJTisKDllrpl2TqqEBFozkTLxpPRBdVxMlF87B844IGFfiZDdkrl8vThUAHaakh009RE
	 lluA4Zhgk1uEqtDiMQPxNpBtdsmpE47Hy9HgmlziUQludHvHVqQUkYsYFXfkgL+0rya3r
	 qLCVcAO0dWfln5IL908FTyu0m0+UxHG07jVfZ4VCK/S5irtBeGgqvPSuz6uv50Dm6TjmR
	 xF3Loxa3LHhy5ugPlBQBnltPLt9ZIDoiq2C3lr20Rzm+6myR84Qtahf5O2bpLFTkhrH7S
	 SJ/Rsd9QYryCI0nD7u7bJH/+XexMpGNxjIZ/MpbSpNg4C9kcYsOojKwa/2AnklU+Y+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792592284;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=viVPNiO1h9d6x4944NBVmE7eQfOCbzUS1zFJo8DFT18=;
	b=S5JUEzOwDcxqZxFmPGzsCMQaVMRpd1860oUKoqgKMUtq4VpLgbA8KvVruWG8aFW+UybL
	 3LhOObSH23xUPpKcOzBhdblk1ujbsw55vZe4GMBWy9lVERvS4vDqU+k1Qf7ALfXCS2DeW
	 NLWaCrsurh5IA4T4CS9LRRbrKfZJ1cwu5ROcB/+h+ue2IBRx4Pt0XD/Yp9A9zMhpnWZSe
	 APxr6D8Myp+ZWypwn3cjLLNHP72r2KeEa8QG/CDDv9RaUMJRv9cjSkVQxtl/Ece4TuC6U
	 rJ2qPLy5I004fpJsEeL+BfY2T5mNUkFBTY5I8l1O7Xm3IA00F7SSNuoyVhPhHuIRSpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=GSL4SX2q;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F6F1606A31A
	for <patches@lists.linux.dev>; Wed, 21 Oct 2026 14:18:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7F6F1606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=GSL4SX2q
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6D04116F8;
	Wed, 21 Oct 2026 07:17:59 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A87AC3F7D8;
	Wed, 21 Oct 2026 07:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792592282; bh=35GT5enIgjR3G0mGLGcskElDVX2rz4mcaIAbm4cF2TQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GSL4SX2qf4CN5QXvB+wvj8b0xDfdgXdSaWJenkWv2OXP6uHcg2mMSaUEenfCanmqw
	 waL3JQZHkksN2EplpGp9cTP9K2BYk/qHOT/mNylNJEhugn51c9sqozipMSVMbXJNVU
	 WD/XpwXx8b5tuTFXHOJje2t23dUHt2NZNquBmofc=
Date: Wed, 21 Oct 2026 15:17:56 +0100
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
Message-ID: <atjJlBqysQmVVwI2@e129823.arm.com>
References: <0-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
 <15-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
 <athzBHFwyp0bFEu9@e129823.arm.com>
 <20261021140649.GO3008132@nvidia.com>
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
In-Reply-To: <20261021140649.GO3008132@nvidia.com>

On Wed, Oct 21, 2026 at 11:06:49AM -0300, Jason Gunthorpe wrote:
> On Wed, Oct 21, 2026 at 09:08:36AM +0100, Yeoreum Yun wrote:
> > > +	image_size = le64_to_cpu(header->image_size);
> > > +	measured_offset = info->drtm_measured_start;
> > > +	measured_size = info->dlme_measured_size;
> > > +	entry = info->drtm_entry;
> > > +	dlme_start = image_base + image_size;
> > > +	dlme_end = dlme_start + drtm_cfg.dlme_data_size;
> > > +	dce_end = dlme_end + drtm_cfg.nw_dce_size;
> > 
> > Suppose user boot the kernel via decompressed Image which is the
> > part of artifact of compressed image and use the drtm option (e.g.
> > booting via UEFI shell with decompressed Image).
> 
> Yep, it works fine:
> 
> EFI stub: DRTM: interface version 1.4
> EFI stub: DEBUG: DRTM: TPM algorithm 0xc, TPM hashing unavailable, PCR schemas 0x1
> EFI stub: DEBUG: DRTM: minimum DLME data 73728 bytes, Normal-world DCE 0 bytes
> EFI stub: Booting Linux Kernel...
> EFI stub: Generating empty DTB
> EFI stub: Exiting boot services...
> EFI stub: DEBUG: DRTM: will launch, selected launch features 0x0
> 
> Notice there is no "Decompressing Linux Kernel"
> 
> > Since the drtm extra memory is allocated only in efi_zboot_entry(),
> > I think the drtm extra memory wouldn't be allocated so it would corrupt
> > memory while setting the laucn parameter or by DRTM...
> 
> Patch "efi/libstub: Have efi_kaslr_relocate_kernel() handle
> extra_size" handles the Image case.

Thanks. I think i misread that patch. :)

-- 
Sincerely,
Yeoreum Yun
