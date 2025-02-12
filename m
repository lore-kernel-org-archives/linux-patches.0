Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F24220B7F7
	for <patches@lists.linux.dev>; Wed, 12 Feb 2025 11:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739361504; cv=none; b=Ko99brbmA/tHqcc54HbDSGnbVRswq4bPIroT6RpStlCycQi1iIysA9SH6Cj1Eml/HEwKW94KIVbLy/0sREkPz8okKAZi/H9Qu5y93MtgTu+bGAcbFUapf8tBLUQ2wKiC/mjZ2zsGI43Rwak4V6qAXzxXt2sHR7P8Rc7gx6TVN1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739361504; c=relaxed/simple;
	bh=RISiYUYWH3priUoEa9eJopp8XOg7Eu1WGRqR9XaSUvQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bIf4Kh0LWfBBF4/1Tw2oXxSA0X+eeUzXAYF2MpHKkigiKKAK/hgm94jJjCayr2mOchX+Khn2ZEMafS6v8NEL6Wv9Pfc1jOmXhZFU0FgMUR0CCUW8hkw96j/OWnnx5agmU9VO4RJ9mMrQVxpgM3sl1Q3CD7vq4BvtBhY9pZMtCCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=crRbV2a2; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="crRbV2a2"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-38de17a5fc9so1855423f8f.3
        for <patches@lists.linux.dev>; Wed, 12 Feb 2025 03:58:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1739361501; x=1739966301; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ybHzBV5q0ST9K9g4ez6foimvKrjebaVw0yEDcZXjbuU=;
        b=crRbV2a2ywouE7w68m3Hh22xAEDPjzTvkR/wmd3lQS8FVzPpSzMCaRanjBJqPFK07I
         lL53WlNlRsRJpPmpgU3paZj7bPhuuUN2t7VIoHP0rIlRzyred0qFwPoirnqumqcDQfKk
         33ngW38KxLXDr5ljnU1dPLoYAyoomsNepSHOR6xOwbSwYSlzusu7VdFsusmX2rDEB4t8
         Q+6gR3GV/mNGg66Z8bGYUq8XSSxird6+DfoYKINNuTTl3rJoxYHRamQzuHpYtl3Mf6on
         DGS1MTyIlddUndk5nmj4vW1vTXyNhfLDCf2iUyxMMTADgkyvLIpsPK1KpG2j9UesYT0U
         Y1Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739361501; x=1739966301;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ybHzBV5q0ST9K9g4ez6foimvKrjebaVw0yEDcZXjbuU=;
        b=SPkyGcHCxEh9LeWM99OlD2zSZNKDA3otYOwckxQcAtOUHgrWK9skayptBvCVNdptr3
         Qr2dCeKDRKy+xZhJEJPNy6YPWRdW5xXrKleD9CnUEBfxTPyZQaNHQOeWGKCmQ54VN+D1
         +eN1vbqdOe0DasWK7NforIcq7g/jnR/dRACQJqKaztnpB9+eah4vv8vd+KV1hgoIfPKL
         2L8e9TB0S0P/UGQuUJoAJmEAW8DA2EbyDYUtBhrhlzR1RF52nAhIpnefKNC4rNhpLtpE
         NpJfSYp3wJyp6pm6wQrH26nF89prsVoYkpy95TiuK4Z2fVLLNAONRm2cWGgwfrBAj3GK
         s8Pw==
X-Forwarded-Encrypted: i=1; AJvYcCXvdJmwn/iRjNFV9hv7V3su+BeLiC6N6MrwaQtEu800QPeoFC4Pe/mnAvNdQjETe3gJSLt4h8Fw@lists.linux.dev
X-Gm-Message-State: AOJu0YwQ606zP5FwAGzTcnNfTuV4RKuI0jjsmGpydZzT0wOI38WIhmDN
	ZfMOechKUx2D9nxR8vJlOCDyltWvtS9qs3jN4tWrPlnmjGlmcmY2E42KGVjeXcM=
X-Gm-Gg: ASbGnctYv9Kn4O+k5F/VswrJoQJarpqukrKV/ur785fDvn7JDdT0bw62IOzvd6tDIt1
	qjFkc5ojbr4vb10UCuGIjU8LYW8OoFW58LjqFRzFcUfb7apOWC+keRG9Ss+BwCxsaTopKqx1wH9
	mDwgbA+zMYxp5hUHOLFjU5fr99eAW/TlVO0eGdEfOxd5Zor5G9L0mKeeOE8YwGdF8N40T0D/B8h
	i4d5BwDD0LjMzBiCsynVkOLi4F5ZOdiFCL/VrvOs34Rf04yXit3y3oblU3OaXa5KIshl1uGktXA
	WV32SpsTtD08CQ==
X-Google-Smtp-Source: AGHT+IGGzFRQpeJwmMtYnITZI2hyf3fXUFq42FYFjd/kOuqSVtFL6BcDBmTFbU3z2rWC5ZyCJ9MUHg==
X-Received: by 2002:a05:6000:1869:b0:38d:b448:65c4 with SMTP id ffacd0b85a97d-38dea2e4500mr2369675f8f.55.1739361500868;
        Wed, 12 Feb 2025 03:58:20 -0800 (PST)
Received: from myrica ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4395a1b84bcsm18320435e9.40.2025.02.12.03.58.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2025 03:58:20 -0800 (PST)
Date: Wed, 12 Feb 2025 11:58:45 +0000
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Jacob Pan <jacob.pan@linux.microsoft.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	virtualization@lists.linux.dev, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>, patches@lists.linux.dev
Subject: Re: [PATCH 0/5] Convert virtio-iommu to domain_alloc_paging()
Message-ID: <20250212115845.GA1627174@myrica>
References: <0-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
 <67abee53.170a0220.154671.ae28SMTPIN_ADDED_BROKEN@mx.google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67abee53.170a0220.154671.ae28SMTPIN_ADDED_BROKEN@mx.google.com>

Hi Jacob,

On Tue, Feb 11, 2025 at 04:41:51PM -0800, Jacob Pan wrote:
> > However, there seem to be some unrelated qemu bugs. 7.0.0 does not
> > have working VIRTIO_IOMMU_F_BYPASS_CONFIG and neither qemu works with
> > an IDENTITY domain using !VIRTIO_IOMMU_F_BYPASS_CONFIG. It prints:
> > 
> >  qemu-system-x86_64: iommu has granularity incompatible with target AS
> >  qemu-system-x86_64: iommu map to non memory area 80000000
> >  qemu-system-x86_64: iommu map to non memory area c0000000
> >  qemu-system-x86_64: iommu map to non memory area e0000000
> >  qemu-system-x86_64: iommu map to non memory area f0000000
> >  qemu-system-x86_64: iommu map to non memory area f8000000
> >  qemu-system-x86_64: iommu map to non memory area fc000000
> >  qemu-system-x86_64: iommu map to non memory area fe000000
> >  qemu-system-x86_64: iommu map to non memory area fe800000
> >  qemu-system-x86_64: iommu map to non memory area 0
> >  qemu-system-x86_64: iommu map to non memory area fef00000
> >  qemu-system-x86_64: iommu map to non memory area ff000000
> >  qemu-system-x86_64: iommu has granularity incompatible with target AS
> >  qemu-system-x86_64: iommu map to non memory area 200000000
> >  qemu-system-x86_64: iommu map to non memory area 400000000
> >  qemu-system-x86_64: iommu map to non memory area 800000000
> >  qemu-system-x86_64: iommu map to non memory area 1000000000
> >  qemu-system-x86_64: iommu map to non memory area 2000000000
> >  qemu-system-x86_64: iommu map to non memory area 4000000000
> 
> I see the same on arm64 with v9.0, assigned an ixgbe nic via VFIO.
> 
> qemu-system-aarch64: iommu map to non memory area 0                               
> qemu-system-aarch64: iommu map to non memory area 8100000                         
> qemu-system-aarch64: iommu map to non memory area 8200000                         
> qemu-system-aarch64: iommu map to non memory area 8400000                         
> qemu-system-aarch64: iommu map to non memory area 8800000                         
> qemu-system-aarch64: iommu map to non memory area 0                               
> qemu-system-aarch64: iommu map to non memory area 0                               
> qemu-system-aarch64: iommu map to non memory area c000000                         
> qemu-system-aarch64: iommu map to non memory area 10000000                        
> qemu-system-aarch64: iommu map to non memory area 20000000                        
> qemu-system-aarch64: iommu has granularity incompatible with target AS            
> qemu-system-aarch64: iommu map to non memory area 200000000                       
> qemu-system-aarch64: iommu map to non memory area 400000000                       
> qemu-system-aarch64: iommu map to non memory area 800000000                       
> qemu-system-aarch64: iommu map to non memory area 1000000000                      
> qemu-system-aarch64: iommu map to non memory area 2000000000                      
> qemu-system-aarch64: iommu map to non memory area 4000000000                      
> qemu-system-aarch64: iommu map to non memory area 8000000000                      
> qemu-system-aarch64: iommu map to non memory area 10000000000                     
> qemu-system-aarch64: iommu map to non memory area 20000000000                     
> qemu-system-aarch64: iommu map to non memory area 40000000000                     
> qemu-system-aarch64: iommu map to non memory area 80000000000                     
> qemu-system-aarch64: iommu map to non memory area 100000000000                    
> qemu-system-aarch64: iommu map to non memory area 200000000000                    
> qemu-system-aarch64: iommu map to non memory area 400000000000                    
> qemu-system-aarch64: iommu map to non memory area 800000000000   

QEMU v9.0 and v9.1 have reached end of life. Do you also get this error
with QEMU v9.2.x?

Are you running an arm64 guest on an x86 host with TCG, or arm64 guest on
arm64 host with KVM?  Does reproducing this require modifying QEMU or Linux
to disable support for F_BYPASS_CONFIG, or just passing QEMU/kernel
parameters?

Thanks,
Jean

