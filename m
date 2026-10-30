Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793367887;
	b=dT5XhtYQqmFELL8dveCzFwHHr/khOn2EptVKWhNgPQB5pZX56e0CTF7/sDiTkr0+f9/a
	 0L+FSTq8ezzMzUC5jNx+8r8bwDOTVGytxBKj09o3DMmCdHNxht0rArcAz63bdES2prVyb
	 ZGDSjFh81Jdunneded3qW6cpbiPJyco8+wgKXiueinkpwP48W5MN/U5/8TmTAktDvlgxf
	 xjt41MQWq7yU/KFsDLWY57J7+NajYo/axg00ueGhezBhVsHLa6fLFq40yzFHo9w7ZAxfR
	 U8gGsPiPhgirLHBClWn8yxDLXfEy659IwpqySmeObJ2kzmXK2b6g+md+vKhGKP4JbXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793367887;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=KF5mM/+d0811MHnJYyTbMCvDWhol8CRjotJBT8VYT3U=;
	b=UNRPkjcPEAto7O1tKXnXMCSavCPVvyuVngr72Yb5fIdLs03m/NUOX0wtwmYwX12HLZGi
	 E5pGEg3EJq/sttpdPx5YQVb8WI/xYNBPgvUC6boe5++JkcSzNjLFZYnsfssrVqq8Rcz2y
	 T/qKo2pl4RvaOczOIMF7FyaFrZwdFRf1Qs6qMJjNGn+zSkmxXhoLV88COQY+vJ6YHzASA
	 4KNk5ye44pcoNAQeZr6Q1oHfLcX6DEiAqu4VWMUn94OXOsCzCC7o7wC6BytNu8nOtQQPo
	 XkcIkbP+Izyv756ItH9SX/ITBCb30Nf7rhOt19m6uEBYquGNjIrggEmX3/nTGP5xRug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=DWZgovLC;
	arc=none smtp.remote-ip=209.85.208.47
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E006606A31C
	for <patches@lists.linux.dev>; Fri, 30 Oct 2026 13:44:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9E006606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=DWZgovLC
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6b1a86c0316so879188a12.0
        for <patches@lists.linux.dev>; Fri, 30 Oct 2026 06:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1793367885; x=1793972685; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KF5mM/+d0811MHnJYyTbMCvDWhol8CRjotJBT8VYT3U=;
        b=DWZgovLCeETKPBkjZG7cNeHb3QaKfoNVwX06Ud+eyXt+cLtnQFJEpw0JyTv5r8KisP
         pKXh1TSx/0ShYgmeMljCOf+790kbuV6BLTzkeT/1Q1L2iSoObyHXYH3ugo+N+orChPqT
         ewiK+L+zYRsSQz3/oSXVhOY1EAAHYggRKxrUCIJ2XVByIDQQ/6z7t4stgpKyZpVZCcF1
         LeB/iB49AjKm7xqbZU79G53gtHkKuhoyOKEJII3Jans5hTnm94oqyKqHwrsNZQNbMkd/
         e+bw7KVdqd1SoWGWZayga6RSg6IUwvwdeXIQIp661QMEZrnNrutM5rsAZcKjOrLZU/5Z
         zxPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793367885; x=1793972685;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KF5mM/+d0811MHnJYyTbMCvDWhol8CRjotJBT8VYT3U=;
        b=sLUZPNlfKkRSNngN0qxiXIReUqq0giTviqeAvMsx8/j/roGVZjS7TfBKvQ1wiuYcvE
         wzBn51YOI5LJYzf51L54JIgMXAJmkTC2qHQY2UQSHfjT5e7InTuiwQ9W/3uxe8Ug4pHX
         6T7Sa9G0xZPeZ7wD9oh9n6gzTAAUIkZAG79gFinD48DyXpV7PrmQRwjmC/FK8am6/h/y
         lorrB/XZ38ob/8rpgRSVJmJQa2fDR27THuGleeAgnJCFUwymEiSE5rLvTg+ADNUiH7RH
         xjtk7yctE120XoPxXNNyyUHGncHpuaYhGGbQiKQhsE00Cl2DdWva/av1pJtCpMzdr/3p
         egvg==
X-Forwarded-Encrypted: i=1; AKwUvBy1wPTPYwBCs7ECQtR4z+eeaCZWxFYP3XBkOJ1bmyrawY59YoPEl89+U0JkTJCE0wY82yH1TBxj@lists.linux.dev
X-Gm-Message-State: AFq9FYILNH9vcydJmgJ/rKjrrTAHCTw1dAhLjo1Grj42nHw6z5b3/VUc
	lBXxFywX57XKHiT8P5z4HkF8m3/1WrfF/7SZLlFJJUfYzajtVe1jaFkAZCzPs32/mZk=
X-Gm-Gg: AYBFou1nhNPAFbKprp03JjxzAGrHLjMRk0iiW/heOpq1G0jzPlxCwkdoBcCBc+Yif/t
	pFSVxsX2EfnxV8tR5VvFOh76cudBtkB0M2XMtCOmXcV1WO0dTCyHSaogKHLHyeTTphQXi/tupw/
	rMxKOo8XR8bStnFVlF2dctEDWnd9IOPdCI5zMj+7A47WCo1CxWSiBNqqlnGf2fKTj8yaj5YRRGA
	oWJUjBd3eA1j2nJIXMbL9n2J7G6qEjTVykmUcMl23FYTcqOhvW5S3fdOf8GEgfgdxsRg22Y7U3X
	0mwfC5zRLQ42/j6WXvNM3lRW7ZCdpysxddikKx/sQlezYYnCgTY1qzDuG3l3du8oB+cBLLqdGEL
	fxVOM30yskeAfa2BxHpEdP6g2GShBTpT2IBlGV2D1q4QorHcr/qWvBHvh+EhKNJgiNNxbdA8BNx
	aCnB8+fLbIz8AgB72xKtKYVitBaQOTzbzT57MM/xG7CJ4a6LFEs2fJCB5SoSc8YrUgJVbnd7B9N
	fPKYwxBaKSPhBw6SEZUb6nEoaghD/PJOl4c5dFZGkiSpG6ugiWHav8trtaRHr6sEe4vkFjQzq+k
	Mn2LqXR/eQ9BE3ObvxzdDMeliQKCHWMGjBEZqQ==
X-Received: by 2002:a17:907:9603:b0:c31:8cfe:9a25 with SMTP id a640c23a62f3a-c4ca7a4d9bfmr219408066b.9.1793367884686;
        Fri, 30 Oct 2026 06:44:44 -0700 (PDT)
Received: from localhost ([208.127.45.21])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4cabe4a7e5sm66619066b.57.2026.10.30.06.44.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 06:44:44 -0700 (PDT)
Date: Fri, 30 Oct 2026 14:44:40 +0100
From: Jiri Pirko <jiri@resnulli.us>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: linux-coco@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>, 
	Alexey Kardashevskiy <aik@amd.com>, Xu Yilun <yilun.xu@linux.intel.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Steven Price <steven.price@arm.com>, Kiryl Shutsemau <kas@kernel.org>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Jonathan Cameron <jic23@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, patches@lists.linux.dev
Subject: Re: [RFC PATCH v1 02/11] attestation: Filter evidence objects per
 instance
Message-ID: <auSe3YzgKX-lu27G@FV6GYCPJ69>
References: <20261028152618.1356860-1-aneesh.kumar@kernel.org>
 <20261028152618.1356860-3-aneesh.kumar@kernel.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028152618.1356860-3-aneesh.kumar@kernel.org>

Wed, Oct 28, 2026 at 04:26:09PM +0100, aneesh.kumar@kernel.org wrote:
>Allow an attestation instance to expose only the evidence objects its
>device supports. Add an optional evidence_object_supported() callback
>and use it both when building DEVICE_GET capabilities and when checking
>EVIDENCE_GET requests.
>
>The following PCI/TSM patch uses one attestation implementation for
>devices that support different evidence objects. Its list includes
>certificate slots 0-7, SPDM VCA, measurements, and a TDISP interface
>report. Each device must expose only the objects it supports, for
>example:
>
>  Instance                  Supported evidence objects
>  ------------------------  ------------------------------------------
>  Host link using slot zero Certificate slot 0
>  CCA guest device          Certificate slot 0, VCA, measurements,
>                            TDISP interface report
>  Host PF0 after discovery  Certificate slots reported populated by SPDM
>
>PCI/TSM checks the TSM driver's evidence_types bitmap or, after SPDM
>discovery on a host PF0, the populated-slot bitmap. The preceding patch
>controls whether EVIDENCE_GET is enabled; this patch controls which
>objects that operation can retrieve.

For SPDM slots, I think it would make sense to distinguish supported
slot addresses from discovered population. DEVICE_GET describes fixed
object tuples, formats and limits; SPDM_GET reports the populated
slots and their certificate digests. An empty supported slot
returns -ENOENT.

Fixed differences between backend instances can be selected before
publication. Please do not make the capability set follow a
populated-slot bitmap that can change during the instance lifetime.

[..]
