Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 127B1407CE1
	for <patches@lists.linux.dev>; Thu, 28 May 2026 18:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779992196; cv=none; b=oXsFFb3Jz+IZ2s8IAtVLBgTMt7f5qJZqW4OyI5zFgcyS3yfhFV/bci4KU702Qmq2I8MSuoEWofXMCzboytaXreZR6653LJUx2sO0xUYUkLcAoM3Qp5S+luybqJ6+H2VYTiiGfoHVyDsiBnPX/sLPwX0ShsVNDg6M+vclROnr2Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779992196; c=relaxed/simple;
	bh=Ds1Jip4Q+szH28JOmLE2MWPcuCX4YqkYawFCTzZTR90=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s5cpg5igKogWx8K4D17QadwHCiPJvnXT+z+kY9xF8sihtEhpIR/yxNek32oIbzQNBmhyjiRRh3Fxh0wEPvlFMagCMZCJ4ahqnSmMhtItqgQs55A9xl9OVImjmDbR16dqs2oHxZeWHmFgdj3u+Ga4t+gaQJSpOUIJ1U4EFZBp9UE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rE207MBG; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rE207MBG"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2bf1cda2b17so634685ad.1
        for <patches@lists.linux.dev>; Thu, 28 May 2026 11:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779992194; x=1780596994; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=H98Vwp3bRkB0ayStNiyEfxNXiTSUpiEWRaZG/RbuOdc=;
        b=rE207MBGyE8q6ks2bshp0otcFLLZ2qUZLFa+Fp4LjW3upGMvldUOR6hi5X0EobdH51
         yLcb6yOoNpVEQuFWwcBREhnDZXPjbFdj2UDDToUbC3UT5y6a/OYX6CSH7u7QTaZ/1pWL
         yW68+2lQ+mRsn4wIbaEJ1dZqTM/s9MOIyltqqcXSdEVGTsCRvKKPk9MjVAJM3rNdoHf9
         0+06Q1UDX9Okv0Iz4Nbn1W7vIaxjmwitFDvlb+1kdEywBBtxT3QqzrxQvoaDEjKCf4y3
         /cNLeYnmu662wlLehKF+dsQaqfzXC8yPL2affLhWqam34tnu++LkRpo55eZUGmo4jEx/
         6YCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779992194; x=1780596994;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H98Vwp3bRkB0ayStNiyEfxNXiTSUpiEWRaZG/RbuOdc=;
        b=r8fJ7bfJU327+JViAOy4bU+MqniQD/nKAFJ3Il/CeeRa5AbfCAorSVmwoVvwJNOxg4
         J6mPvwaU2D695vh4nTREq6d8rgmkxcCDbfOvg641MJ+1XTeACTIdP3CWqN5V5x0t9J3V
         EwZjXyNIiIlSgb87qo4UiJEdYNkStPWclV89bdMkuYWfNW5raM5arEfpQ2zxGyGBkhjT
         xdo8hsdn25gnvF8bSGKk716zZ9Plcr5XGz8wT5VFBM2ZuiCZR4jSpXx5SAOq4vSdjV4n
         63BRjN1+EoKnEV1HRD7H/0m+QpAev8SPH0e3JZuLlgszaV9+DGLrlE+XAmxTKQY1LZTo
         TvbQ==
X-Forwarded-Encrypted: i=1; AFNElJ8KI5/zS6COBYdFlV4CfRpKNhFaqXHg9PQ1Mj8qZZz+pSB0t/s1EVEsTOLWgMD/qtgNOSbdqFB7@lists.linux.dev
X-Gm-Message-State: AOJu0YxHgUqhqio+Lpt4RrPDnuXHjcpREkcO5O2qSvKnCWYo0/wnemiS
	H2mZlI6sbTvp3kWD9B3dppcw2sARhQyiec/WBSN917h7B/wU/MkjSUwcwZ2CmDmfyg==
X-Gm-Gg: Acq92OG4mVZH7CzvevMT1GGcjxcclVKhjPqPXeuxy2Ljbszh0d8/NlD/gXINqODSjcL
	VFX/zzATYM9q2PO4CApSKIWeTNK6sCfelgjLgy6Pl9CXWRG6ebq1Td8MqNekGBiz75PqkUwtJeE
	QRLqAMr8aorLG2yKUU8Dnxuw9AJoMaJ1q4lBVjWpqhil2khr7fZLrg1eQnNbEtMa4hWVOKp/EeY
	1mo3wmmfBbfc/gqelriUdLdldlxgYQH0Vigwe1lIsIEbdHYHxYSadEUHB2VtPZ2J/t8Elody2Mn
	11iHVyVt8LcN1js9P7ai1yhzyK/asgrbUrjLSLIf6t+eGRYh0zIOJ/AKEQVcv178ESjh+WDygR8
	cuqrsR/0GiRUSgfPZiTV8VxeUh53svC6TIgm4+rxW4ZhNwTwCZeavg5y3/5499b92sWi6J4DnlM
	6NWrmJ3h6nR87haCvnAKBZRorv5Hiqs0VjKpQfzST5JPpRuAuzxF96hoy14tkLaQZ/6KyNbIH3
X-Received: by 2002:a17:902:db05:b0:2bf:1845:baf5 with SMTP id d9443c01a7336-2bf1845bde2mr12584885ad.12.1779992193939;
        Thu, 28 May 2026 11:16:33 -0700 (PDT)
Received: from google.com (56.149.168.34.bc.googleusercontent.com. [34.168.149.56])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb58dde4fsm198930285ad.67.2026.05.28.11.16.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2026 11:16:33 -0700 (PDT)
Date: Thu, 28 May 2026 18:16:30 +0000
From: David Matlack <dmatlack@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>, linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
	netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
	Shuah Khan <shuah@kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
	patches@lists.linux.dev
Subject: Re: [PATCH v2 05/11] selftests: Add additional kernel functions to
 tools/include/
Message-ID: <ahiGflOWOOk0U_b4@google.com>
References: <0-v2-72e9640932fd+2c64-mlx5st_jgg@nvidia.com>
 <5-v2-72e9640932fd+2c64-mlx5st_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5-v2-72e9640932fd+2c64-mlx5st_jgg@nvidia.com>

On 2026-05-15 02:30 PM, Jason Gunthorpe wrote:
> These are needed by the VFIO mlx5 selftest in the following patches,
> which includes some headers from mlx5 and also needs a few more
> MMIO-related features.
> 
> - DECLARE_FLEX_ARRAY in new tools/include/linux/stddef.h (wraps
>   existing __DECLARE_FLEX_ARRAY from uapi/linux/stddef.h)
> 
> - dma_wmb/dma_rmb barriers: x86 uses compiler barrier
>   (DMA-coherent), arm64 uses dmb oshst/oshld (outer-shareable for
>   device visibility), generic fallback uses wmb/rmb
> 
> - ioread32be/iowrite32be in tools/include/asm-generic/io.h for
>   big-endian MMIO register access
> 
> Assisted-by: Claude:claude-opus-4.6
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: David Matlack <dmatlack@google.com>
