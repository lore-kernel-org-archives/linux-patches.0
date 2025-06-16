Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02DE6225A20
	for <patches@lists.linux.dev>; Mon, 16 Jun 2025 22:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750114335; cv=none; b=JfV02noxYSQeF1al+pf5zzUwetK0kVmxdVO8k251HkmmSdGdQyOEP3P4BFwJamIBkeYHf4cff2gmRo/5MdFrw5kTJhgcMeNKMlL4a8HqsX3Q1IDMzyl1S7gwy5BqkAIITbvAGV9/g4WHbq8YEzbV2sxvNQgqCTVZlEHwxzm6SjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750114335; c=relaxed/simple;
	bh=PmDF/LX+MEY7yNxnBISXFQV1FTEkhwSQHKJS5tTjenI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ANZo/ymrS4hpurncVn8PLJnASPumTnLvyS/abaXe8lDvVKJSOWYiWaCMTMN54kH5p8ZNhn9ySi3t6+2BM7BC3TF+Ykl09O3LkCpUgb4SMjT+l5S5b633/ucEU10va1VDPoIPtt6flmd4q80PGSEkCK8z2jn37M3Uk0c06KUxtNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TIp10kJJ; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TIp10kJJ"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-235ca5eba8cso65525ad.0
        for <patches@lists.linux.dev>; Mon, 16 Jun 2025 15:52:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750114333; x=1750719133; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Jj6+mcpbE9V02qadLzbuN9y/flOOPMALPxxrYxqko6o=;
        b=TIp10kJJqgq5OzX2vnCMFtThCkpNCn81ipaXj7hWOtWy1VRQ8/oxRvVkbJLQ9kPBuZ
         GTUPu8/L19XU06bTisCxBIv19ebzzGRBL+lMiCvjBu4LG72JhrnBbA9unwGJsgKFIhMc
         c2X1F27jk9kGfVEfx7tN1mabJVi5NOOfc8r/I9leQ172qputtxTaZMgpHNddV8erBjBP
         Bkdx4Lw7CG7/UWf13ODB3lLa0ewCzosckLoF8fCygWK0yHKmovmwE1y0+2+1KqJ27f1z
         6gt28luBaN+4zAq2pLa6NjMEBozVhYibNOZfP3aTu1plP3ufOA+2eKNWchLGtgNGMA2T
         n3dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750114333; x=1750719133;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jj6+mcpbE9V02qadLzbuN9y/flOOPMALPxxrYxqko6o=;
        b=FdUUhheoKbPrscjOt6BR+T0z7I+NCixOEZWNAx6Dweda4Dd6v2zhSofuTgr31Z/HQB
         8h1Gex68MaW7H11EzzAmMasDTBKfLQEayzQLkn5F4oFfWKRlgKxvNGkznmFAD5IDL+4n
         PokbCfrC2sxk+h7S2mnLlmPGJWGd+g1dT85zyUceajYd+L4WYtbRHslyFvbOO98c1o7B
         QIZmeJhPt7tXHwKuflatpgi16zumbguz3ur6gf3JtRB7TueeXIqD1sct7m+O50+oizmg
         eRF/rNvlhL+xnPesIWX78bxs0wROm29JPIkHyGpZQtpsAS7AckWr0MrtrQpYir7P0xrX
         YcAA==
X-Forwarded-Encrypted: i=1; AJvYcCUHX7WiBurJsrynSBoLUusu7cJRUNFxPlQHFeiz0Lf17cD8uC/RZ4Od24PvvRj/grhn6yt0ezA+@lists.linux.dev
X-Gm-Message-State: AOJu0Yynuj1be9/4I4IMexKYBHazCJ5jbVc+OVQJ1c56J7k/yvIWg2Oy
	fjE9CognfAAbnBfdeqmHuBuB4fSoQQMeCcw09SjHi20uRdkAMQe+viXRA5C3NyYN2Q==
X-Gm-Gg: ASbGncvvpHwzoC+V5a+ms5ZgWVbtddjEn13J3cb/duSg/GWDe1v2Pleqe6CvKk5ADzl
	+0vhbJ1OxjsX4btQcz6s6IpeNYA8xOLKf1p3d4V/642BkfByTd0OzjBAYBcE8ACNMYCUoh+XrCB
	EVsywyel/5z7TM7FfAT5ANtquM0/bHvZ2Wrl5tzbwFe+Ft4Y/5tBK1+u6iMPpR2G5IYZqekUoDK
	7+Q9phqoPFobOkszaCN75cJQGfa4i+vmm9g9JkT8831CSSytf7JGSMuq9am3fyj62zLQJ3hUHnv
	rivKObuePz0DNixoZO44JAp+ZEwT/18SR4Mm+5omUwvvb7CPeMszAbv8aZ5j1bxWfWmEh+HkVb3
	98hO4ycofSaC93sIbLe7a
X-Google-Smtp-Source: AGHT+IGlPE9uP1SbbWnzOuYOIe1eDG4YyhjqWGy1/roBJfbAZkNgrizH5BthvNw3ZPe4qwD5HsBoXA==
X-Received: by 2002:a17:903:b45:b0:234:b2bf:e67f with SMTP id d9443c01a7336-2366eef0269mr5964675ad.9.1750114333086;
        Mon, 16 Jun 2025 15:52:13 -0700 (PDT)
Received: from google.com (232.98.126.34.bc.googleusercontent.com. [34.126.98.232])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b319dc80726sm3333506a12.68.2025.06.16.15.52.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jun 2025 15:52:12 -0700 (PDT)
Date: Mon, 16 Jun 2025 22:52:04 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: jgg@nvidia.com, kevin.tian@intel.com, will@kernel.org,
	robin.murphy@arm.com, joro@8bytes.org, yi.l.liu@intel.com,
	peterz@infradead.org, jsnitsel@redhat.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	baolu.lu@linux.intel.com
Subject: Re: [PATCH v2 13/14] iommufd: Introduce iommufd_object_alloc_ucmd
 helpery
Message-ID: <aFCgFPlz5dYlN8N2@google.com>
References: <cover.1749882255.git.nicolinc@nvidia.com>
 <e7206d4227844887cc8dbf0cc7b0242580fafd9d.1749882255.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7206d4227844887cc8dbf0cc7b0242580fafd9d.1749882255.git.nicolinc@nvidia.com>

On Fri, Jun 13, 2025 at 11:35:25PM -0700, Nicolin Chen wrote:
> An object allocator needs to call either iommufd_object_finalize() upon a
> success or iommufd_object_abort_and_destroy() upon an error code.
> 
> To reduce duplication, store a new_obj in the struct iommufd_ucmd and call
> iommufd_object_finalize/iommufd_object_abort_and_destroy() accordingly in
> the main function.
> 
> Similar to iommufd_object_alloc() and __iommufd_object_alloc(), add a pair
> of helpers: __iommufd_object_alloc_ucmd() and iommufd_object_alloc_ucmd().
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  drivers/iommu/iommufd/iommufd_private.h | 26 +++++++++++++++++++++++++
>  drivers/iommu/iommufd/main.c            | 25 ++++++++++++++++++++++++
>  2 files changed, 51 insertions(+)
> 
> -- 

Acked-by: Pranjal Shrivastava <praan@google.com>

> 2.43.0
> 
