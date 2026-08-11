Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ECF13F54C8
	for <patches@lists.linux.dev>; Tue, 11 Aug 2026 21:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786483316; cv=none; b=fASOKmgBabjVdMMeJQA+UA/9GA4KYLYm8wwoD32EHLe1K/M4pI7WGWEB/fxMS2jVcfOQUiIg857vSbzHsoz2ag7fR/z4Stvg3duPSIswMhx0wCrEemQyLm+WE080lcFrVaTdQKqNYPxb/WACYCcxYu61yd6Ak1cBNNuTgkmQrMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786483316; c=relaxed/simple;
	bh=Fs1q1LuXAYTQ937j0F968WLbSfpvhN7jSqDN7Jd6uBw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VMcn4u1CuBJbo7bMvJ9latXKIS927JtQwE2OpJR7/llxG6MQcvq0wyIyCBjJJxtgzQGp7jN6HB5HvuqxiRPtMuuhe3/pMtHFe2eYQckp0vVtr4Zv9HDxMVzDKN/x7UIFftWDkz8gDHJb3THg/8uwmX/aQmZ+lJ9hdBPeKfUTrwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Yy22w9mW; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Yy22w9mW"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2ceb096e675so5286995ad.0
        for <patches@lists.linux.dev>; Tue, 11 Aug 2026 14:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786483314; x=1787088114; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GgcKeBktnliFILPgH5Yp5qgxA2fPy6McTHeUrYz6elM=;
        b=Yy22w9mWBs5EW7B63Krvt1hVMo7oQaCtk9roLp5Oks3V7U5F74qYQDma4Q7y7oWlwT
         16T9MFwmCyyMgtDisI8GQafv6xzu9sR9idiukqza7LFZwDxYnaGH/pkxxacRysV0rTcl
         Eu2weOGCQc8dgMt87hf66fIFgNj7RaFofK1d5v3hXEGF31HPjqhKIOCcVxW2BQXFUXke
         TxushLvTAY0SnTJcuoHIv0llZ6FRRwQ/xaVJNZ+PIclJOxPi/hneRWjH9euhPIjBRxVC
         dEQ3PgE8fSeaDgBSc19QHtoZ8GknrLe8vOpEM5TM08r6zH91Y+u04ibXKv48ZGQVk3BR
         3mgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786483314; x=1787088114;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GgcKeBktnliFILPgH5Yp5qgxA2fPy6McTHeUrYz6elM=;
        b=daJnKp4iYJtQ2FeItdptYKDe3eMqOzHLyXEoDBlBDmiwoxEWFyHQaR3SOLCnQAKfcy
         EPnyb5rLDvOvlOHoXOyNmWpe2AXNsZLGx5G5trUENbuUxo59tphgvZqtTElBLD2IKDSS
         W4L/zGACp0hkLlN9n9tZgX0g5oDMszx9STgM8N9Cpay5hCB3ee6dp+4dI17ltV6hymdm
         VsM7n+T+j5zIPZpob9EQm32LJshf7G4vUnMZgtvd4gAF+3rgvyoSwWUmBfCXc8ixK9La
         Z1uRsEGVlzL5wghn/q+QDaTka/TDHunYgR7NJk8gT+B+vF+3HCS7lOoQmeP66r7GwaAK
         VecA==
X-Forwarded-Encrypted: i=1; AHgh+RqWQZ1WdHnd4n4EKvA7y4IQYvwZXeMCe9k2NEJWnAZM4OfgT+lWZkSfagvPRN8AB+Nw2ENePCfD@lists.linux.dev
X-Gm-Message-State: AOJu0Yy+OApD2+Dr73ciSoRQvLVKScDfyQbBrUF8P/103R6AFxsvZHtD
	jeJvbcnuKzOAndkK5liZdd/qq2smmsnoFns+pi844LcTSB6cXvW4EPsRU44p5iETNA==
X-Gm-Gg: AR+sD10zDMFf4LuNtIMtV2rxn3lOqq7nr0S1UGh2JPMxyAqi3CyzPNDfWZtUo3nj7CG
	kTFsy7/VifJ90aLD4P5diyLK5zsMIeN03uR2wc8iuh+UViabf+HMfiQCOJ5WusDhR46ja2c2k1P
	+cgbxcEDkR5qcNBnsHa69+HWLA5j+Uti8JhMK1Y/suXOJagZvAH3W7DER1LYcaTsJCkLEhcVnh9
	xW53w9Nj14tgwy0L+snvbJRgyUBzXVJ2NhYJv7uDTvkNjAC8d5+58RMPvLpfHxbU9gPmD05C+71
	Ac+fgpA7H3G7OI+ZhCOlC/uXXBYDSpeSJXJr0fm1iqWvBiEm4SfdIptpXxDisPtrL6gYoYbilaY
	68hHOZbyFyURRY37lRKQ9Z1fQqsdsuc68slxhu8fLcn6nMhteS6iDLVf7BxKbkG0jcy7ZPsjwzz
	sDSVGrBDQpAyzlsI8/SsLbkBoeL1/vIqxYhhBNqJj+83iSGdd3Sh7sZGZZaqaA+SAkK9RwjfMso
	r8RQqPq1dEc9O+08r133o2kzkt7BRK0IrEhESPW
X-Received: by 2002:a17:902:e946:b0:2d0:cc92:f7c2 with SMTP id d9443c01a7336-2d34535651emr6182815ad.1.1786483313141;
        Tue, 11 Aug 2026 14:21:53 -0700 (PDT)
Received: from google.com (132.200.185.35.bc.googleusercontent.com. [35.185.200.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d315f29d82sm12934165ad.20.2026.08.11.14.21.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 14:21:52 -0700 (PDT)
Date: Tue, 11 Aug 2026 21:21:49 +0000
From: David Matlack <dmatlack@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex@shazbot.org>,
	Justin Stitt <justinstitt@google.com>, kvm@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>, linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org, llvm@lists.linux.dev,
	Mark Bloch <mbloch@nvidia.com>, Bill Wendling <morbo@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>, netdev@vger.kernel.org,
	Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan <shuah@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>, patches@lists.linux.dev
Subject: Re: [PATCH v3 09/11] vfio: selftests: Add mlx5 driver - HW init and
 command interface
Message-ID: <anuSbSEiEfCC2MUR@google.com>
References: <0-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com>
 <9-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com>

On 2026-07-16 02:03 PM, Jason Gunthorpe wrote:
> Add an mlx5 ConnectX selftest driver that programs VFs and PFs
> through the command interface. Create the driver skeleton with
> probe(), the command interface, HCA boot sequence, and all resource
> allocation up through ALLOC_PD + CREATE_MKEY.
> 
> The driver implements vfio_pci_driver_ops (probe/init/remove) and
> registers with the VFIO selftest framework.  It matches the same
> mlx5 ConnectX device IDs that the kernel matches.
> 
> init() brings the HCA to a running state:
>   - Command interface setup (two-slot: regular + async pages)
>   - ENABLE_HCA -> SET_ISSI -> QUERY/MANAGE_PAGES -> SET_HCA_CAP ->
>     INIT_HCA
>   - EQ creation (CMD + PAGE_REQUEST events for PF support)
>   - ALLOC_PD, CREATE_MKEY (PA-mode, covers all IOVAs)
>   - Force-loopback capability check
> 
> remove() tears down in reverse order through TEARDOWN_HCA and
> DISABLE_HCA, including async pages slot drain and FW page reclaim.
> 
> The driver region (~18MB) holds all HW-visible DMA buffers (command
> queue, mailboxes, EQ, FW pages) overlaid as a single struct on
> device->driver.region.vaddr.
> 
> Data path ops (memcpy_start/memcpy_wait) are left as stubs for the
> next patch.
> 
> Assisted-by: Claude:claude-opus-4.6
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Acked-by: David Matlack <dmatlack@google.com>
