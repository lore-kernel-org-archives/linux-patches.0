Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE6B55B1E8
	for <patches@lists.linux.dev>; Mon, 25 Mar 2024 21:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711400791; cv=none; b=g6D2ALUYnY9QnedjXdqHzHBKrVLMX4N0QkPA6KkisofnurI/fHzAnKBilJ8Lw9BLzTxav0GSKg/2iRgqF1JSTgD1xhtirEJfbyAIOskg/PchLYvfvW9BDP3/64OYemLMCzj5pGxqE24RjRljMCoeebJTRerFJc5/E/8DkuWvBD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711400791; c=relaxed/simple;
	bh=sfVyrmgaj5oBn0tCvQYHQZQDZDExeVi6rltukh2TVvk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AfFbRKk3FJjldKastYJBXnLWZwUl0t/wPF8K0BQsdwlJjOM+StYmjT/E6LwGiJ7w0iAXqjqF7co+20yjIEGD2aVAYo27pr6SUbuXVK2k/jdn+pGW+zrK+8OS353WBsS8X2BemVFin47q71KZgeIzCEmNr+fb2Whxzh+lyzngTf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WOV/yvg4; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WOV/yvg4"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4148c09ec6bso6175e9.1
        for <patches@lists.linux.dev>; Mon, 25 Mar 2024 14:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711400788; x=1712005588; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=87kSRxw1Ym98c2cZV0HSeTHtXw3IMZt6YXbhTpf4Gn0=;
        b=WOV/yvg4XMN7y/GirBkf4V+lac07B7kk3nFjVjBvrpDiTIZJLxLmoeVdSZLxU3cc38
         Jyql4UptfhxunEe4vc8bV/byIfJoJpXgETFYgn8qqO7Gr4AtMBuZ5EOCJw4rSAehfyy/
         QyUS+3zoN6qsxrV0fJTU+Zb2685eo+QAoc1iNLZzSTJFcfN/2SsS8si9zPn08tJ1LyuY
         MjxNHjC89MwpIRm8EtTaa2uYIX5Fp67HORTrYEJyqIkN5cN1zftkonkLr3pepZcX+I/y
         BlYCZkbklqgnA5xHDyxKK+k4AnG3iLEEtf4OvhmLD8g5nM4awYOlGDOaAuTzdtLj9cnR
         auwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711400788; x=1712005588;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=87kSRxw1Ym98c2cZV0HSeTHtXw3IMZt6YXbhTpf4Gn0=;
        b=SAeeuv+jhsTUpp36+w/mEk/jDTbPBYVmCxwwcO2f5jMdQBsNr7LJ39I2m2+jQ3XZ33
         3+DwM2zNC4Ko+Uhc7WPnX1qtTslKVivBORutYlherhF8bsIH5oj0n5EqdynWau2Mdml0
         Six3XU1/5L29DA57/Fa5gNTY1VtcmXTvuG/btTlTae4/2RsaxI1rsNQZIT04d/z3aLg/
         VMJwgY98WQfSd5E4FnPN3MMm2sus7OSo1grjAX/HNpPGNVFZEqo0i+i9F4iWnx+nn1HH
         +dgGT/swf2byyKTS5/wyCjVnZPYA2kaJ278ytLbZYmmEJ3FEY2ssAmWRhq+zpvjS4hv1
         vkWQ==
X-Forwarded-Encrypted: i=1; AJvYcCV3JrzGf4qSXwP8WhmcrDZz/QtwS6wlrhJ5iSkhrkM2JUWH4AY9RXWycR021i8CvaeMg8NOUDYbLCozlTNqFd3Qigy9yfmtzQ==
X-Gm-Message-State: AOJu0YwkVeT/czpMbeeviJTqVdeWGOCuVYJ4JRFY08e52fv58wi42jYU
	kzOtpkoyy5nTm/fYO84v8l40RBOwmrqUwFEv9MexP5QQXVpdGD+sFDrfAnyt9Q==
X-Google-Smtp-Source: AGHT+IGJhWAECCUdYs4iDPZsz04LuG+syQz1Yw/Xrcg4rgTS20erTsGI+S2EJx10DtBo6OyLMMwq8w==
X-Received: by 2002:a05:600c:1c27:b0:414:fb8:5105 with SMTP id j39-20020a05600c1c2700b004140fb85105mr17168wms.3.1711400788139;
        Mon, 25 Mar 2024 14:06:28 -0700 (PDT)
Received: from google.com (180.232.140.34.bc.googleusercontent.com. [34.140.232.180])
        by smtp.gmail.com with ESMTPSA id q20-20020a05600c46d400b004147db8a91asm9518815wmo.40.2024.03.25.14.06.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Mar 2024 14:06:27 -0700 (PDT)
Date: Mon, 25 Mar 2024 21:06:23 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v5 00/27] Update SMMUv3 to the modern iommu API (part 2/3)
Message-ID: <ZgHnT8ZoOtzUwYwb@google.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <Zf7bPOtRg9tLSOKT@google.com>
 <20240325143503.GF110546@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240325143503.GF110546@nvidia.com>

On Mon, Mar 25, 2024 at 11:35:03AM -0300, Jason Gunthorpe wrote:
> On Sat, Mar 23, 2024 at 01:38:04PM +0000, Mostafa Saleh wrote:
> > Hi Jason,
> > 
> > On Mon, Mar 04, 2024 at 07:43:48PM -0400, Jason Gunthorpe wrote:
> > > Continuing the work of part 1 this focuses on the CD, PASID and SVA
> > > components:
> > > 
> > >  - attach_dev failure does not change the HW configuration.
> > > 
> > >  - Full PASID API support including:
> > >     - S1/SVA domains attached to PASIDs
> > 
> > I am still going through the series, but I see at the end the main SMMUv3
> > driver has set_dev_pasid operation, are there any in-tree drivers that
> > use that? (and how can I test it).
> 
> Not yet, but some will be coming. Currently only Intel driver supports
> it, but Intel HW has other problems making it unusable..
> 
> A big part of the effort here is to enable the platform ecosystem so
> devices and drivers can use it.  Moritz has access to a device that
> can exercise this, though we are still working on it.
> 

Just out of curiosity, are there plans to upstream that driver?
> > >     - IDENTITY/BLOCKED/S1 attached to RID
> > >     - Change of the RID domain while PASIDs are attached
> > > 
> > >  - Streamlined SVA support using the core infrastructure
> > > 
> > >  - Hitless, whenever possible, change between two domains
> > 
> > Can you please clarify what cases are expected to be hitless?
> > From what I see if ASID and TTB0 changes that would break the CD.
> 
> Right. For CD it is only the SVA mm release flow, setting EPD0.
> 

I see, thanks for confirming, I am still going through the series, but
I now wonder if this case is worth the extra complexity, unlike the STE
where the hitless transition was usefull in many cases.

Thanks,
Mostafa.
