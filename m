Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B4B338F62F
	for <patches@lists.linux.dev>; Mon, 28 Sep 2026 23:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790637395; cv=none; b=UYa/5DwTuaEAHeOHOFRmtpvsFjgofWpPv46DFDpD90BkHBy+mA4olzAthBqxC/NCgiNLIFp/JzdGqK5tgNqficufZbTCEvJEv0kvR2hQ9R3I25lpB/JA6tLfhZrckh4+Lrcqwykgm+lOCFPa2Rr9GAovErwjJotA+QojQwSrO5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790637395; c=relaxed/simple;
	bh=4rJz1QddBFCOKaFtHqcH9VzDRR8WPKOL3D1OOtTj3S4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mGouSE9uxOFABhpdCV2qaRqmf1U1/Q9+q2D5KnFfjFdDfg5eGw7i+6jaqzM9dvbyj44DPB9/Mkn7AKh1uJVK/3YDBTYsYHBJcbUYPVpMAj0vu3AIaiAG6RefQjl1WqR+3HR7uivciXUkwU3BNV/AzWeGwBGM9zljNZFzxebnAIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=m2LJxE4H; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m2LJxE4H"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2db33db4de9so22685ad.0
        for <patches@lists.linux.dev>; Mon, 28 Sep 2026 16:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790637393; x=1791242193; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YTzG2AG2lQdERz5R0R9LywAO1UeZk+G4W/mfALEjtno=;
        b=m2LJxE4HP08wk5q3io4Cwyn3hkRVRjb8J0+s52O7wOMhPqMKR9Y4c0IazSj+EswuLU
         tSLRI2xzh/YdMmPU5mciboSpCUcp5ICGvhyKlkWtu96ChyHpyHp4MEA/OLfvs48Ns0Wu
         ZnESabUGadXyAtYsSxjOGNOG6eJdC0SmyhOOkon2XHzy7Hp5Pj0lWL5Sg3OwSYVIX21f
         hPic/bbg11AzZWoDEIFXnsZGQLmQ2BKjPgUGJKBTBRsDmSlc7qQhK85Z1ZpB4ehcMwwB
         3SId3BdHft713OMDfDTn5valX9gRr305+fuydOugNDNVHUT0IJncRfqAKf8QZPyA+REy
         xlQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790637393; x=1791242193;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YTzG2AG2lQdERz5R0R9LywAO1UeZk+G4W/mfALEjtno=;
        b=mTxXydnIWtuKDfNkLsNYMr2+15PJuPpdgd0pVmB/Wli+FqASDbehDMxR31sp1feXbx
         PYC+frVfIxwQ0TqiiC3soJ4qjqkkskCiE5BIKVlrkB0gGd1g81t7NjbiXK+Udk51aMzh
         VOQhWk5oaByeyDHWnOQsVFWtMdrB5ji3mQ4rmcwX6/7m2ZNCq40Ww7scmSTDd/UT4zLm
         5e7uLU6Yv/YOOhmsddpThxs6HknKV1r+f1K5la59DmlffnZMOTPUp5ztQwAqCflvgBmK
         KqQYGg9XIViDEjkiXJJu5vdAg3YJ3tqUP1qACThhzO1n39wJdhr85nLPe8DsXkKD1gAT
         B3Cg==
X-Forwarded-Encrypted: i=1; AKwUvBzFKz9slrOAjr+5Pn+LgwdPtb1VCx+G1iz/4QJbPIjcyuDqZ6tUE0RtZsTkr0+/1NHkSPTn9fC/@lists.linux.dev
X-Gm-Message-State: AFq9FYKrbkJgvVBoeQypCb5JGxfnRV21jjwUwZMg7Grfa0JWLkjYqvcA
	fyw3vBs1j1H1F0db4532TRQgSs6GP8VMh1/Zm2EJMrAR0CIJUlhq7rcd+/cC1Y2Qqg==
X-Gm-Gg: AYBFou3vNxquyXWhJfted9AGqLlWuhNYMlDO+Ktpzkt6elAmitik8uB/IQQ53Nbj8cx
	WjeyxW89B8vtBQroUwTVsrBWeMH17mf510k7oCxiIjoU7e0GgBxLAI6pQhe0Bt2iDVu2/nUx66y
	QXvsjgN+yJzrbqkxRWfp0Hac/WmYvjTq4knhZRwAgVuuuauaihyayqWqRSzcCHn2VwCm0390zEM
	SIW14IW9GPEkGeGYI+mbmfSDzPa8nE63zlhhktIfrobKmqzQ73JDRU5Cysmkw0VSZtLeMzbKcdl
	8zEsnu+PxSs7PyObw7EVP+nb97CaV9SdnILc5Cutu9KI7FZt1ZLKuad91oo1RGTVrH7hWXeQgAM
	3+wPR2D/OMHzMv6nLo9diumxZS6RgFSmKhJwuiiUXpARJDjk40YuOfLf5fHQArn+jOJGxAI0wYD
	RC5wXDJB/zwrTh9G6yQLMM/0MRjU97BEU1pHHTBiTxDmpT/46smf5vd85qHHQkEruBC9aI60jRQ
	F9lzODTSLWTUadRmBxEA0IKvzZMngOsytuy4AdBJJ5sfDY=
X-Received: by 2002:a17:903:244a:b0:2cf:4353:f117 with SMTP id d9443c01a7336-2e2c5a8e99fmr1398225ad.0.1790637392723;
        Mon, 28 Sep 2026 16:16:32 -0700 (PDT)
Received: from google.com (105.211.142.34.bc.googleusercontent.com. [34.142.211.105])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a498726d63sm1582327a91.17.2026.09.28.16.16.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 16:16:32 -0700 (PDT)
Date: Mon, 28 Sep 2026 23:16:25 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, "Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 2/9] iommupt/kunit: Skip test configs without
 supported features
Message-ID: <arr1SdQI-s46qG20@google.com>
References: <0-v2-563ee63886f0+1209-iommupt_armv8_jgg@nvidia.com>
 <2-v2-563ee63886f0+1209-iommupt_armv8_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2-v2-563ee63886f0+1209-iommupt_armv8_jgg@nvidia.com>

On Wed, Aug 12, 2026 at 05:09:18PM -0300, Jason Gunthorpe wrote:
> Some of the tests configs can test features we don't currently enable,
> like TTBR1 on ARMv8. Instead of blowing up, skip the test. When
> CONFIG_DEBUG_GENERIC_PT is set all features are force enabled during
> the build so everything can be tested. That is the normal mode for the
> kunit.py runner.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/generic_pt/kunit_iommu.h | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/iommu/generic_pt/kunit_iommu.h b/drivers/iommu/generic_pt/kunit_iommu.h
> index 79d7f9c8e7868f..558e161eacb05f 100644
> --- a/drivers/iommu/generic_pt/kunit_iommu.h
> +++ b/drivers/iommu/generic_pt/kunit_iommu.h
> @@ -134,6 +134,16 @@ static int pt_kunit_priv_init(struct kunit *test, struct kunit_iommu_priv *priv)
>  
>  #ifdef kunit_fmt_cfgs
>  	priv->cfg = kunit_fmt_cfgs[((uintptr_t)test->param_value) - 1];
> +	/*
> +	 * Without CONFIG_DEBUG_GENERIC_PT only the format's compiled-in
> +	 * PT_SUPPORTED_FEATURES are available, so cfgs requesting bits outside
> +	 * that set cannot be tested.
> +	 */
> +	if (priv->cfg.common.features & ~KUNIT_PT_SUPPORTED_FEATURES)
> +		kunit_skip(
> +			test,
> +			"cfg requires features not built into this format (enable CONFIG_DEBUG_GENERIC_PT)");
> +

I can't quite build this as I can't find this macro:

drivers/iommu/generic_pt/fmt/../kunit_iommu.h:129:35: error: use of undeclared identifier 'KUNIT_PT_SUPPORTED_FEATURES'
  129 |         if (priv->cfg.common.features & ~KUNIT_PT_SUPPORTED_FEATURES)
      |                                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~
  CC      drivers/tty/tty_port.o
  CC      drivers/clk/clk-fixed-factor.o
  AS      arch/arm64/lib/strrchr.o
1 error generated.
make[5]: *** [drivers/iommu/generic_pt/fmt/Makefile:30: drivers/iommu/generic_pt/fmt/kunit_iommu_armv8.o] Error 1
make[4]: *** [scripts/Makefile.build:551: drivers/iommu/generic_pt/fmt] Error 2

Am I missing a series it was defined in? Can't find anything on lore,
but I did find a commit on your github [1] that is supposed to preclude
this, I guess?

With that dependence defined/linked in the cover letter:

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan
