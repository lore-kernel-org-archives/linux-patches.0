Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB6F318A93F
	for <patches@lists.linux.dev>; Tue, 25 Feb 2025 17:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740506242; cv=none; b=CK4m6wFEuH7zesdpyMNwBqnU0sLf85TSVCeHzSKAKJ1mRLhnyJNGvbF/RSjP75jyoMcf7lr8SGJNf27XLLmBE0UY5XV8FwUnixLU0ID2qt29zRS4Go1MO0rVN9+Qr6XYlMuMMZWzXUUNGMTFutG+YBLr1ZrkKSubcxSLMNq/jw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740506242; c=relaxed/simple;
	bh=31zc1XueM/rGKJ6c+/BQITCsz1wXw3/IbeSan2eXnK8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J4K4ZzTFlgulGOtPpOdn7zB4OM5E0PJSAV6XDXMww/djCCyze7nhyKqzbKkTIwwAymECYvVMb3MXAjVbW8Uyxmtxb5Ln8pzENaSbLSsBOvUwZm8EncJyaLwR1c51maKFbtC53UATtMnkHHa/CwTHMzZQmkXA1x2w2TKpuHQ9Al8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mUs5SVvs; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mUs5SVvs"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-221ac1f849fso3005ad.1
        for <patches@lists.linux.dev>; Tue, 25 Feb 2025 09:57:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740506240; x=1741111040; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zHaAT6T+XlWe+89P2zugxKrlYk7TledH0w0ahGQr4YM=;
        b=mUs5SVvsnqk8wviZoULcNjcroikzNcAuKBy7qgLeVSvxzZK5nKQBOiUPlIOvQ5sRe6
         pT3+hKsZDROgqY/zS6jisslw34RJv3Khcx/kFafoeJ1A3NvmjJbZSi/Z9VqT5mkBQz5R
         /wUUBWJsLUg35eGcXxGOJF8f5CBUf/fxMVcGqfBj/uGUlDrkrj+NjTah54OskgeydowN
         9qN7ZDMPb5X0jEQKL3f/oCBf3c+k9oWm86uPoypYbKVoF5hEThSQjDMd074vi3f1Mhqu
         7wunBd6EIstWHaXD9egXWy3G3e+NBsMGppk6jCD8i5B+CST/48cX5X+3YKbRfryDs7Ss
         9m5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740506240; x=1741111040;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zHaAT6T+XlWe+89P2zugxKrlYk7TledH0w0ahGQr4YM=;
        b=Vz8bhuLdJpV2Zbi6ePp6WJTtQX58A/GmRdJKN/nxbCk6onxAp+MaJ6uYv1Ilxvf30n
         mj6MCaWHxMsSKCNYJGR7Y5cZlUD+2fRN7XNngTMFSV8iQ6yIcPBThbpzeXJEI/gSHqNN
         XyjiriAamVZ8F8B8ahfRkr1rd1IsqZ35Em1kBBY2E5AsMXD6ENk6CJVBVZ4VAMb+4SNL
         Be2v2qfZnRvPLVYGqT6XYR5s26rpngpkIpSzbRmyslzgX08HXy7oQZH1razEJ6dVQ8UG
         JPlEsK12nI20bbE2jefs1sLy/tQwNetcNIJWtQu0qT0HYDMs9gT4MJcG9fwz+ra5AEWN
         /HLA==
X-Forwarded-Encrypted: i=1; AJvYcCXL85Yg6quXGM57s8cQH5e1yvOrCOFVVslOC8H2wPecovvVGX1HF7QqqBwBYZAk3jxNXnHupMEA@lists.linux.dev
X-Gm-Message-State: AOJu0YxUqtZMNPYh0Or/bBI61aPkcHvkanLlr+os9D8W7LoFn+26OQPu
	Lx0CMAy3cxldyItGyrCuN4OsUvAR0cdLiNfKudWeqNgG9EweYGxo5aevxKzRgQ==
X-Gm-Gg: ASbGncuYHvnSX38WUfDIE3/fQ+6/o7ukspekvOZ1jQOpykKGdkz9sqcfjmrLBpZAttj
	Z5x5j/7YwVEaqKF5mKvuiQo4USC+Iy0fS0H8qLfMSMRWZh2FAno6AWoTLoxlNpzqr93OidpG0sA
	Kr5Lv10+GZIiPF2o47/kJC1fxNAETyAUyRAKCHStCfTelXWPKKPNiox+T9q9Bo+qTz69tY0eLDq
	kNX38PmeDILydOCbk6wIk/30WtjX6FByn0dFfaHVA3bDlQD2chRsOcA5mTZ1tfpaflzk+z+hZU/
	kvji22zFTDTJHG/QrKluL+uM5HJUn2iD+3xeLw7wGVenL9/QjVmtK4TbIK+RcyA=
X-Google-Smtp-Source: AGHT+IG02bNp0tkxmXxczB6ZSntt4wfTEWTePiQeT76QafmUXS7ThOKjH22xno2GMa6y5FkJX+V2yA==
X-Received: by 2002:a17:902:c40d:b0:220:c905:68a2 with SMTP id d9443c01a7336-22307a2c777mr3852445ad.5.1740506240014;
        Tue, 25 Feb 2025 09:57:20 -0800 (PST)
Received: from google.com (169.224.198.35.bc.googleusercontent.com. [35.198.224.169])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2230a0a61fcsm17251405ad.191.2025.02.25.09.57.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2025 09:57:19 -0800 (PST)
Date: Tue, 25 Feb 2025 17:57:09 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: jgg@nvidia.com, kevin.tian@intel.com, corbet@lwn.net, will@kernel.org,
	joro@8bytes.org, suravee.suthikulpanit@amd.com,
	robin.murphy@arm.com, dwmw2@infradead.org, baolu.lu@linux.intel.com,
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
	eric.auger@redhat.com, jean-philippe@linaro.org, mdf@kernel.org,
	mshavit@google.com, shameerali.kolothum.thodi@huawei.com,
	smostafa@google.com, ddutile@redhat.com, yi.l.liu@intel.com,
	patches@lists.linux.dev
Subject: Re: [PATCH v8 13/14] iommu/arm-smmu-v3: Report events that belong to
 devices attached to vIOMMU
Message-ID: <Z74EdXC5YzvmJokk@google.com>
References: <cover.1740504232.git.nicolinc@nvidia.com>
 <7f6813dc2b62f5f396ac3172dc2a7d9bf3b47536.1740504232.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f6813dc2b62f5f396ac3172dc2a7d9bf3b47536.1740504232.git.nicolinc@nvidia.com>

On Tue, Feb 25, 2025 at 09:25:41AM -0800, Nicolin Chen wrote:
> Aside from the IOPF framework, iommufd provides an additional pathway to
> report hardware events, via the vEVENTQ of vIOMMU infrastructure.
> 
> Define an iommu_vevent_arm_smmuv3 uAPI structure, and report stage-1 events
> in the threaded IRQ handler. Also, add another four event record types that
> can be forwarded to a VM.
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Pranjal Shrivastavat <praan@google.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  7 +++
>  include/uapi/linux/iommufd.h                  | 23 +++++++
>  .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     | 17 ++++++
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 60 +++++++++++--------
>  4 files changed, 82 insertions(+), 25 deletions(-)
> 

Apologies for my spelling error in [1]. It's supposed to be:

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Correct spelling in [2].

Thanks,
Praan

[1] https://lore.kernel.org/all/Z73zvIbsXzJMCaNt@google.com/
[2] https://lore.kernel.org/all/Z730M3XptvDRObBp@google.com/ 

