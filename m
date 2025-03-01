Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A36863C0C
	for <patches@lists.linux.dev>; Sat,  1 Mar 2025 04:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740802576; cv=none; b=JcPQg1afYgHPk+oYAIHoQFg2eyrzBMgSok77RtF5f1ArK+JttIBa4YKJ7Z+9bkUIZ5Pn7kHeUZWIObkLC01u2MQpgpA/LUnJJmGR3lIeb+TNzxyd1NzA3c98z0ee3lAp6pWGUEYqEW8LOpW2MGNIV11Fgmad3ngz+VgJkNz24Mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740802576; c=relaxed/simple;
	bh=nRJXVNbZUpNIBtt8TFs13UDH3fN+Tw1tbm1ZW4YHs/4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MIoovfJ6Jgc4CJnv+I2kGmUB/oLaLbOQBkiVsspYNgxEq19/a4hu0cnH5ljyZZm0J4x5vwXDf3iIvsktO/E6uPBFjpNJAeJUoBv1xayW2zSL9hEIQjqrKDBPxAMLkTeQM1lbqd/gIuo5vj2uzKgt1mRdavbzvXcG1pQ+y/Fixx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ybP7Yr1N; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ybP7Yr1N"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-54298ec925bso4138422e87.3
        for <patches@lists.linux.dev>; Fri, 28 Feb 2025 20:16:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1740802572; x=1741407372; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nRJXVNbZUpNIBtt8TFs13UDH3fN+Tw1tbm1ZW4YHs/4=;
        b=ybP7Yr1NcuDPHZITsBlO4NsrtieRCJ6W0MkG21wDtp/FM0BfDrlicMD4S6H8HAu9YJ
         SHLpvX0SktGylT1sSGNzBrxgPioZ0z9xSNcKfbX6AIIuGiteBbQ1bJCBeY1OckTdvjx8
         +93taiZHyU/4u11ELxvRNgmsoPQs7uKESnr1MgCpWlIY2kvaSd5rY4a809s7Wn/L8T0e
         HyA/HLDI0+hArclv3o/R6+okK6/qH3SK3BQ8UWWfyLUDvklwL6ydH2x+hUCIxgg980qH
         PZC5Pifs7KziutKAduASec1PeQdqBDPlXI+CbPwRbsOD9Cpg3y0En9sfdG/fPB0BYw8Z
         MSsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740802572; x=1741407372;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nRJXVNbZUpNIBtt8TFs13UDH3fN+Tw1tbm1ZW4YHs/4=;
        b=axgp5Ni7fLQPkFvikXq9rn4/a/lWZZw2By/Yo6d0KMRqh/HcIN6JxpyWL2nkFNHdew
         TsgU/wnoM977u4yqDKL2gFwod+TEEeGxYDAXkRbboQxZl/UetkQ1FtsxbrPN8aU14NEd
         f0zQ4Ix4+lwAFTIZWNX5x5ZJRKZh9YpoRW18XWBpe1L86xuGuN/feXEClrh8lWVrjrx6
         XCtDAsJN6adFrwqMXGGgMH3spFyb4njke/c9Oz5O/vYyyZSzVhmee4MUihg2M+My3Pkq
         otco1nQzUEqVlGhj2iyV7b8E6L+q1RWr4Br8NQGeJwWICELY6IZXfWUTRiyHkQu7FSKu
         er5A==
X-Forwarded-Encrypted: i=1; AJvYcCUSt7Me3TdH+rbINIJp2/0oP8nfo5TN0556WvYp0U2xTOBgWT40X8XZiRJ8+5NUawawH+iDH6JY@lists.linux.dev
X-Gm-Message-State: AOJu0Yy/PVyfDteSI36EZAp+LX+hftj2GG2VLYhvI9MPkWn8NmoWLJwR
	HnbTEZevNIopJexzqVe33+aCwBFQkau+ukvuHzuvrq4RU7Ijue1fMeiOILP+AqhTf3Ld4GGG7uL
	A02CvstJVqTHFFMWRKmgsSJOGJD01JeSKP63jyg==
X-Gm-Gg: ASbGncsjCeYDJVS7pOE9F86/eyTUhugkxsFXgRSDgj+b4+yhWZTNH+WRHBviSQjRf2Z
	GjvUi4Lo/IqSRXYmqQn/AQUtHLUqJ3x/16RFniJ51/WvoB9IgBYVZYLImLFr/GNQOTxoX48zU7X
	ANLCOOjRx41IUaSFN8NdoJBgPc4jO6qaQ=
X-Google-Smtp-Source: AGHT+IFP5aCHULz6zpIiPlJszPYhhIKQa4bjgAfv6H6nwuK5koq1iQ2nHbNDaxSV+n8l900FUXdJNFmIzAGeKlhCAx4=
X-Received: by 2002:a05:6512:693:b0:545:b28:2fa9 with SMTP id
 2adb3069b0e04-5494c122af7mr2774025e87.16.1740802571668; Fri, 28 Feb 2025
 20:16:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1740504232.git.nicolinc@nvidia.com>
In-Reply-To: <cover.1740504232.git.nicolinc@nvidia.com>
From: Zhangfei Gao <zhangfei.gao@linaro.org>
Date: Sat, 1 Mar 2025 12:16:00 +0800
X-Gm-Features: AQ5f1Jq1aPPNEUtuYw2bvAu1XDeZv-PKWUyrHeAmpxtPMb0nHo1DtYawDISk28E
Message-ID: <CABQgh9FYqzoUxjR246QBPGW9jqngK1JpgfACvBTLTHq-mBBCJg@mail.gmail.com>
Subject: Re: [PATCH v8 00/14] iommufd: Add vIOMMU infrastructure (Part-3: vEVENTQ)
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: jgg@nvidia.com, kevin.tian@intel.com, corbet@lwn.net, will@kernel.org, 
	joro@8bytes.org, suravee.suthikulpanit@amd.com, robin.murphy@arm.com, 
	dwmw2@infradead.org, baolu.lu@linux.intel.com, linux-kernel@vger.kernel.org, 
	iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
	eric.auger@redhat.com, jean-philippe@linaro.org, mdf@kernel.org, 
	mshavit@google.com, shameerali.kolothum.thodi@huawei.com, smostafa@google.com, 
	ddutile@redhat.com, yi.l.liu@intel.com, praan@google.com, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Wed, 26 Feb 2025 at 01:33, Nicolin Chen <nicolinc@nvidia.com> wrote:
>
> As the vIOMMU infrastructure series part-3, this introduces a new vEVENTQ
> object. The existing FAULT object provides a nice notification pathway to
> the user space with a queue already, so let vEVENTQ reuse that.
>
> Mimicing the HWPT structure, add a common EVENTQ structure to support its
> derivatives: IOMMUFD_OBJ_FAULT (existing) and IOMMUFD_OBJ_VEVENTQ (new).
>
> An IOMMUFD_CMD_VEVENTQ_ALLOC is introduced to allocate vEVENTQ object for
> vIOMMUs. One vIOMMU can have multiple vEVENTQs in different types but can
> not support multiple vEVENTQs in the same type.
>
> The forwarding part is fairly simple but might need to replace a physical
> device ID with a virtual device ID in a driver-level event data structure.
> So, this also adds some helpers for drivers to use.
>
> As usual, this series comes with the selftest coverage for this new ioctl
> and with a real world use case in the ARM SMMUv3 driver.
>
> This is on Github:
> https://github.com/nicolinc/iommufd/commits/iommufd_veventq-v8
> Paring QEMU branch for testing:
> https://github.com/nicolinc/qemu/commits/wip/for_iommufd_veventq-v8

Thanks Nico

Tested-by: Zhangfei Gao <zhangfei.gao@linaro.org>

After rebase on your branch
https://github.com/Linaro/linux-kernel-warpdrive/tree/iommufd_veventq-v8
https://github.com/Linaro/qemu/tree/for_iommufd_veventq-v8

Tested with multi-device in guests, with io page faults happen.

Thanks
