Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1440D47CC61
	for <patches@lists.linux.dev>; Tue, 11 Aug 2026 21:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786482889; cv=none; b=aUDoEip7hd5hHUUCvHkcx2PObYl+R+8QMw5nm8/MQ5CBceaYMHkfZm4zOlCmIwuXspCNsKiViTEMpvquC0KHOA1fZhcyx9uHA69+2vA3U3CDL07PS7xAjFChijyZYv4Me4x1JuKA6BE4H6VIPvSWgTukHIVYLX1eXhnqqXloVtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786482889; c=relaxed/simple;
	bh=vELLWw0jcQS3izlB2sdDvaRC3WcKac/J6CTcP0dIWC0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WUvPcrSqOw4PhPZ6l78qxRSZOWsVnLyGVqU4QdPhvlVABITAvpaSWt7PW0GBGo0VFR6gBu4uVzMOLMM7sLrPE/gVb4kByBjdW/5/j6xQJR/wth0YqmhII97JWRSoKLODBwNZ/oq0A/1jqA69W6I8IsCxGObW1wrFNghFNzq5rU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qEKf9R0f; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qEKf9R0f"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-84867f07d63so379550b3a.2
        for <patches@lists.linux.dev>; Tue, 11 Aug 2026 14:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786482886; x=1787087686; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bsIA9G0uzM6tK8/PrMCXpabodZWsD0MRjRT85WaMGF4=;
        b=qEKf9R0fj7X8E7X8DFC8+ttJ0biixLCYBGROPKt8FbAwI0hYqhL5aDmmhyxWbj9wtG
         ObJT8AaSVLVkfKkcEfSD8sHkp1R0TlnWH7WJCv3i2iBtCv1rm2zYcxRqfa7TLWqscxrd
         LztV0rKpav3kYYmvQ+DjGk4Xf5PmkWOJRK3QMKfyhpJAbilQnfh8e/JshGiZVbv/Cmgy
         mA1l3OgVlGTkyK55ZzhSJpVVeUBXLJqGqyc6ZUgVA86ck7qVK4nccqpBjfvAyfe7bvpT
         fX8kE1C5Erp0M+ANkQyS7JHCpbJWuPCztzeoex9Mk0e/Y6YvbFvWbqpkh7atZWSaXGTp
         neDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786482886; x=1787087686;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bsIA9G0uzM6tK8/PrMCXpabodZWsD0MRjRT85WaMGF4=;
        b=rwWV/xmLKdqGCdaFZMPD/yO2Q+cWrleyjDdzgXbQ0+8AzqCeLEoIuJpfjvnr9sY6eI
         i/0IJb+cQICMCsiI6254SQVmBhGHRCAtgonJ8RrOsQGuNEUrIdg+xQvbyo3SdxcF1pFT
         UpO/MOrlMTMpBcc1tRCbGTbjkk89aJj8hu0cRVnFw2X/2+yD2wQ54nCfIla17d5J3jjn
         zAjnvBjxjpg3Fm4e6aOPyoAZOE/hEtI21OJIlcCSOz0r/SeHKs7JTaMfPifBpjAitXE2
         hNEKWxML15E/b/vWb1j4KtdC28JoMMWaJF+4d70S5Vtl2pVu1pQTG/xX6opgSaw2enjk
         wNXQ==
X-Forwarded-Encrypted: i=1; AHgh+RpBcn6Fou2aouMGhttI2MA7Z7s8lwDYYgh/j9s2uuCoHJzrOtvxnDpkFLTzhWFOGibTJ9tk53Zr@lists.linux.dev
X-Gm-Message-State: AOJu0YxFnUoQ9FCcc7b+LXPY4tC8WpgsSTYU353sTnUMdm5JfeHPRx/G
	MxprGFWK7Usg+8aKHmKHyh6HgCRyPzNqi1q/FxzKR3K7lMODwEaCHd8gOORkvmSGEw==
X-Gm-Gg: AR+sD13zyeqD/i+PkCAphfemD97tIZsqoHuetLr2xYV9BYv07I4Vbk45odk/ls7tkjY
	2OcvUDS/RaOZbxAmV8jw/hRVf2hXoqoRqHe6u+Dqyd2oyn57VP2GOXfXig8U/S+XqKySGEyinHN
	MlUeLoW0e92HX6Do1u3d/+3+9a45z6ypEvEqg+s47PL54Ja85fYSPAPfX9sVFDLnoZBFRztwTbu
	OdlcIe/ohhC4LtvFtVCa96ElTc9BiYZ0g6EIaagAzmUjxmDEEDrA8oZLTSgBgf1WqrH/I4VK7jP
	1P7O0/vcqdkiiSHzYM19iLrfu5is2TinCP9letk7Yt7YaHxY+J7lqnnbxYaOYRP5zSrOI/8rLAN
	UUPUmGNCqdNq4MQutTcjY97e2RUZhZVHNb/MoT05pX7JDZTWAC5RNi+L66braBGkJyJTk/pxq0H
	U3G9OCdSqAfmvZ1XqsZ2lOb419Efd15KBF/GQA3SrionUKMFl9V+TonIr0AZSBc0zUVD/jUVucr
	pSTuOam0nTDtBcZXqS1O4D6LvjXAg==
X-Received: by 2002:a05:6a00:1d98:b0:848:4c0c:9482 with SMTP id d2e1a72fcca58-84fb5596c31mr161407b3a.35.1786482885795;
        Tue, 11 Aug 2026 14:14:45 -0700 (PDT)
Received: from google.com (132.200.185.35.bc.googleusercontent.com. [35.185.200.132])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84fb1f2645bsm237399b3a.50.2026.08.11.14.14.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 14:14:45 -0700 (PDT)
Date: Tue, 11 Aug 2026 21:14:42 +0000
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
Subject: Re: [PATCH v3 06/11] selftests: Fix arm64 IO barriers to match kernel
Message-ID: <anuQwhVv5UhjS_ER@google.com>
References: <0-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com>
 <6-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com>

On 2026-07-16 02:03 PM, Jason Gunthorpe wrote:
> The tools/include readl/writel MMIO accessors on arm64 use
> inner-shareable barriers (dmb ish) while the kernel uses
> outer-shareable (dmb osh).  Fix them to match.
> 
> Add __io_bw() and __io_ar() definitions matching the kernel's
> arch/arm64/include/asm/io.h, including the dummy control dependency
> in __io_ar() that orders MMIO reads against all subsequent
> instructions.
> 
> Assisted-by: Claude:claude-opus-4.6
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

With the changes to tools/testing/selftests/lib.mk removed,

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
>  tools/arch/arm64/include/asm/io.h | 20 ++++++++++++++++++++
>  tools/include/asm/io.h            |  2 ++
>  tools/testing/selftests/lib.mk    |  5 +++++
>  3 files changed, 27 insertions(+)
>  create mode 100644 tools/arch/arm64/include/asm/io.h
