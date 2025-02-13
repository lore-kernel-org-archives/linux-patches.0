Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42E4202C31
	for <patches@lists.linux.dev>; Thu, 13 Feb 2025 09:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739439941; cv=none; b=gX0l89JGuIhENpAGXCLw0Jjee7V4eSbt9pqg+Zim24WxfhiccsZQYrxGi2Ohzv8T3/tHFlEq/Lq2s6QwWQCeoGtYuJyHDaVzFQsEndZAZZ3aSPWFp1g/HCj1E2C5wTlyRhWr9Fp2FDh1hSI25b0shLi9JU5wUvIghOXNd1H9a54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739439941; c=relaxed/simple;
	bh=3Ilo/X3a30c4xDyqJmeIBjYKRtFgQM1sP1z2Knqi7Q0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YCe3vOJjfzL3OuaJz75XHo4ZXIo5GJQj8zDW6T0e3U9W3+gQ4tmmJv9GKIoCLmch73l6SNC7Dw+dkikWlKeNxLblV/HhElFes4fyVV43pzzlm74p5ftp7DFkigsJeKGweIdfuSkFtt/tAnI1xxN2WEkUeNdxT5do6gUznQfzlE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pFGrvy+j; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pFGrvy+j"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4394829ef0fso11029855e9.0
        for <patches@lists.linux.dev>; Thu, 13 Feb 2025 01:45:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1739439937; x=1740044737; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3Ilo/X3a30c4xDyqJmeIBjYKRtFgQM1sP1z2Knqi7Q0=;
        b=pFGrvy+jTedsek6US8JEqYdSvMtIjn67hBUk9mQP0R2T1lWyez5MsNnaKlTimzQqw6
         F+HcOn9miOYPkbSHvEKUHnPeZSLOVxZqWh0zYagfZKN15E+T4OJMLBEgMAq6Djx+BpbW
         t32AnBdipXTxDysbH11gx5Q9E1q9mTX8eBs3xjd/BxNWacjuAQTrjig42aESX/pQBmvQ
         FWXxTGNOuRbEnYtwMDQQ4qd6YJ7mpI+xfjes05MICDCyNswGb8U1oeFUOxejOAMrBM83
         8DjEZsyxNMmpJIS+jG1em78dfaAf7hoWL4gDwtBH4n+vXHy6uIDfE/6GeyBOU6IgVxju
         qUww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739439937; x=1740044737;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Ilo/X3a30c4xDyqJmeIBjYKRtFgQM1sP1z2Knqi7Q0=;
        b=W/ueECfY2tUyI3qF0P/KFPwLxQwBlnSI22o9xVOvBb+7NGIGDyZHPXhQMD6fWkoIco
         85cgbjUv6748RxMB71u6fE2wfM26RFNY/TXea4EQzzLXb+Xoww1QE1zBJwJmiZPX6EEU
         uzS0At29ZdBuzNIbEcnf2dZnv+/zc3/H8k3I0C7O5HUiwy+B0AKOqY1j56UuVU++xIyV
         xKtVtbaFwt7oGyCebAx5/yiBAPjVvBwwfSmX7asU3GAzb/dJIKNJ/506wAG4x9A43e/u
         zyeyU2VUdFPhZvamuXMH+M7aslDEvSyy0RIbC540EEVYGCxjRXuYZO/hJkgWSs1KnAdo
         gkfA==
X-Forwarded-Encrypted: i=1; AJvYcCX8nOJ8Itcjd6HE8K8mzVsa1USygDuKetIh4ry2/nN4JDVtaRBNw4lhFamHteOHnFc+/jKYmYnw@lists.linux.dev
X-Gm-Message-State: AOJu0YxkAmrrAB4hFxM6z6EpQTNp7kv5hT+RaSmvMH1SaivRoEKXwy6R
	Ij7IzUT3ekegcEBiBjR9uO/t0ovvNfQdIa2vZcNKx1reVMhN3klWKsGCguQxFvE=
X-Gm-Gg: ASbGncvPuRkCo4aYY4kjUe1+G7zF/r5oi3qyeFbH5RGM/W3wcxMcrLM8++rXFKaJikP
	aUWCmfcy/xsaCLjji9mRXi44UJASDAkvzeyG+ntiRwY8opY5xlqMiPwNmUSMtp/UAW7djkEufve
	TBl9HXXo/aSnYPEvT1EQNGQHGOHQs+P6O6ZZNPBtbJqE+VJv+dQj7+O1ZQOu6jBVW2gi9nSMQla
	Jjp/rpgjbjDiQSNen146MAHT4uHfCniRf0wfW3cJfhfvfPUfuDTrd/whCXa0PTOmZyYfDaHzQ6J
	6/Jp16c/pmNMHA==
X-Google-Smtp-Source: AGHT+IEIeCgAGFBXoUwvmjdG4kaT43lYwV+Fkp3fDkVeP6qXvOFBGNPRA7BU0T2qf6XHumXXrDCSDQ==
X-Received: by 2002:a5d:47ca:0:b0:38d:cc9c:630c with SMTP id ffacd0b85a97d-38f24f2c099mr1998761f8f.10.1739439936845;
        Thu, 13 Feb 2025 01:45:36 -0800 (PST)
Received: from myrica ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f258b41b5sm1396930f8f.14.2025.02.13.01.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2025 01:45:36 -0800 (PST)
Date: Thu, 13 Feb 2025 09:46:01 +0000
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: jacob.pan@linux.microsoft.com,
	Easwar Hariharan <eahariha@linux.microsoft.com>,
	"zhangyu1@microsoft.com" <zhangyu1@microsoft.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	virtualization@lists.linux.dev, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>, patches@lists.linux.dev,
	tina.zhang@intel.com
Subject: Re: [PATCH 3/5] iommu/virtio: Move to domain_alloc_paging()
Message-ID: <20250213094601.GA243081@myrica>
References: <0-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
 <3-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
 <20250212112235.714b0a14@DESKTOP-0403QTC.>
 <20250212233053.GV3754072@nvidia.com>
 <67ad876d.170a0220.3c21dc.85ceSMTPIN_ADDED_BROKEN@mx.google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67ad876d.170a0220.3c21dc.85ceSMTPIN_ADDED_BROKEN@mx.google.com>

Hi Jacob,

On Wed, Feb 12, 2025 at 09:47:23PM -0800, Jacob Pan wrote:
> Our code and backend support are still in the early stages, that is why
> I am attempting to convert virtio-iommu driver to iommu_pt. Not sure if
> anyone has done the QEMU part to support VIRTIO_IOMMU_F_ATTACH_TABLE?
> @Jean @Eric Do you know?

As far as I know Tina worked on this most recently:
https://github.com/TinaZhangZW/qemu/commits/virtio-iommu/vt-d-pgtable/
https://lore.kernel.org/all/20231106071226.9656-1-tina.zhang@intel.com/

Thanks,
Jean
