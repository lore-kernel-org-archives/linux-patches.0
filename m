Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792538690;
	b=IOajCiuhKitz6P7q5e812YlcgHwdYNv6xx0jLPxKqizKxG03zOG4bBx7LLqiBD+Fa33f
	 GHiR3BsulN/FWsGYYED/m1WorGGj9ASP8tZ8T/JvlhTdlUEENk1NVVa6RPrupAPLgh9TH
	 ADbK+ZQFE8WIEXpP/gWpSpekvwQhsZRQAKosL0iXMQK2rTJech8SzFEIDWsNpq2nZ+nOw
	 xS9jx23gjUmV/E9jMC0qcryU9oY+7JCMVsvDsVfnFuyB3MHueEBba7vWIIhhBcC5oafgT
	 SsE37jF2NO8rG7YCItNL92InrC6h4+doFd6N5UyV7dAH8aOxpyCKrnhtXaUaA2jy4oA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792538690;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=N26BUJ1xKAAk40frg4SytOnypgC2HjF2fR/qGKmWfsQ=;
	b=SMIEiB7Tb6r6zB+nzUWrjNfL+WXoUqRpCL5wCBrWYZk8QyWKhPwbQ+/QMi34ChC+qDxO
	 L1v7RaiXK6RQOcvdIFfL0M9XLhLHmRrS5P2DUzG4161xSafe7rCmXpFlxpqGKFjUniVvK
	 F7n00MOWmHtXv3N//YRTTbAZEskZC8fGXVSbjMAK6t6G1JGUWVuDL0SAai2z4XIM+NVAL
	 AwX6XM9wbvHUQ1o9goi7gm+z4e/QA2yGFosw0su86hZnRUzkE9XBkLTmYc3JLAQm7SD4D
	 ca+Ij1TmyHUmtgRRjsCYuisQeOoVWupgXXAzJFAzB7K0PDiXLKev4yMYkQDd/PvHDPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=nIKAKDdk;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4E8D606A319
	for <patches@lists.linux.dev>; Tue, 20 Oct 2026 23:24:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C4E8D606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=nIKAKDdk
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E147515A1;
	Tue, 20 Oct 2026 16:24:43 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0D7093F7B4;
	Tue, 20 Oct 2026 16:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792538687; bh=Ql6r3oDIs3hhRsDlq4e1yE+almBM9gVakuK1N8RoSEg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nIKAKDdkGLv3SjsjIH++aln2p65x1fVAEpimqj0FtKrAONnFvxygBjQsBe08EN18E
	 J77xf1z1++jZYDabnVuKKBEfqoub2i0BNl1gxM/rjbIh6jZJvU0IU3n54hypD6HnSy
	 9A1yGObdMhLOQjmDrsAS6zV7cPojHFEZK7YYe/b8=
Date: Wed, 21 Oct 2026 00:24:40 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Albert Ou <aou@eecs.berkeley.edu>,
	Ard Biesheuvel <ardb@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
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
Message-ID: <atf4ONRM3xbs877y@e129823.arm.com>
References: <0-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
 <15-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
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
In-Reply-To: <15-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>

One small question...

[..snipped..]

> +void efi_drtm_launch(void)
> +{
> +	if (efi_drtm_policy == EFI_DRTM_OFF)
> +		return;
> +
> +	/*
> +	 * No cache maintenance is required before the launch. v1.4B R42130 in
> +	 * Table 22 "DCE preamble requirements" requires the DRTM_PARAMETERS to
> +	 * be accessible as Normal Write-Back Cacheable, Inner Shareable memory,
> +	 * so the DCE reads them coherently with the writes made above.  R45220
> +	 * in Table 30 "DCE requirements for the DLME" then has the DCE clean
> +	 * and invalidate the whole DLME region to the Point of Coherency before
> +	 * it measures the DLME image, which covers both the Image itself and
> +	 * the handoff struct placed in the DLME region. Thus once we jump into
> +	 * the kernel with MMU and caches off the CPU will see everything the
> +	 * stub wrote.
> +	 */
> +	arm_drtm_dynamic_launch(drtm_cfg.params_addr);

After launching, How to get eventlogs for measurement of DLEM if
tpm_read_log_efi() is used? Doesn't it need to concatenate those
event logs from DRTM eventlog in returned DLEM data?

[...]

-- 
Sincerely,
Yeoreum Yun
