Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793369339;
	b=SVMxdTyJXhn5xqTGycItr3ncN2uHPptVDymNDrwl5XIum4c/JdlbKt3/QTsUla06pLJh
	 0/IMtt7cag5zMtWVzqnG/z1FKyBQC579a3zhvrRIXsJbFv2scVH56Q8iN5R+Cfed1iUYF
	 MgAGSQ7lE20+eAcTCEHpw9lRstZ2HsTCCMWMi+BuYBZ+P/BJ0+R6CzWEJvrrbfvWnRKI7
	 bQnCIuqym+hvu9SlsRRvq2B0yF4fLYCNj5LZnA7QswnOa6kgVr7Vww7EDR0sQbUXWB7bT
	 YggmkcVg4tqCMVflOYJrQUOlhjHD7xpdbmHkw+aT9HNDsUBixEkfcPqbgSyzgGJvYsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793369339;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=zCF/A13vIjO+9DR3ZIgrg0bWRmU50vlNeLEYnFpFx/0=;
	b=2U4wqCaLKT8KCIrArJCXMU/Gwjfr90E7LoA3NWL92PBjtdlsTsG4nGKwbYLykv/EmtL3
	 oPl3kgwighju8jYh3qIIJpcO8KEKSPoHnRRc0maEb+eSYc/stB1KLsff9pOKTFdFpHnKX
	 1YmMTtb1TDoaenI/FWrl/VifIBImZ9nO10sUT2IV1sDXk02zodKTnysvk9/QIHwGPP+AU
	 FuJxivvW33uuTox4rbhFQePJi/oWkhFrh4QzHS4cqVFbRz2p9RaxZ6y1AUiwrBOm4W5Lw
	 1zZC8indf9SFX8O8ON6spAH12MH/XF3krmL/f/E08qOXsCtwYFgDHWCFhDCVqt/BzxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=yTzkdy9e;
	arc=none smtp.remote-ip=209.85.208.182
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C03F606A31D
	for <patches@lists.linux.dev>; Fri, 30 Oct 2026 14:08:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4C03F606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=yTzkdy9e
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-3ab53a99771so6878281fa.3
        for <patches@lists.linux.dev>; Fri, 30 Oct 2026 07:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1793369337; x=1793974137; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zCF/A13vIjO+9DR3ZIgrg0bWRmU50vlNeLEYnFpFx/0=;
        b=yTzkdy9eitMqOy2kzOfvIRsqaOJQ2G9d2+Bf7ACC+eL7OAdgZcQJyd7+JxuCrucmTm
         5PXQglR3d92hFN3lC+Pw3gKxkdkWwpRJJdiBk+qsAXVCKA9rpvPeRqzNvWE0kO8cefxI
         ji5HCTWgQsKPiHaRyfuda0QtbEVNjgWlgq11FuDqNml4abtvFIAzlTl2NtOC0U6jD14Q
         2fDL+x9xPAAwsTQjMgvfhTg8h09jStOQRZwsvMo5dBRS80fsQZC5U4691YFlG6ZWh1Gs
         aq8ICIymXmJw6AStiKYZSTMYM/lNlJVpdJ9ZZNqLfU8Y6fSTBhD3eDUCeRkfFRIL5WvC
         kaFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793369337; x=1793974137;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zCF/A13vIjO+9DR3ZIgrg0bWRmU50vlNeLEYnFpFx/0=;
        b=xumPelVZ/laIwdz7aXEE4nMqeJMO71Pq9lkOATIseiDu+t4TDAP3mXBXV4rFNmIOBP
         xyr+JFqQa11BdJFaJUbvafZVcznIejBPJeGPSHFxoIrzxOzOIxV9ryIVL1ZjhJ6kSQ1e
         ADyD3dHa+z14yfOh1NZGy5N+jsZnHUjLsIvx3nwVzY4GH7V+BLOY/+uWxjzfuMiCdwZ3
         mqAjbRSmdAiIPXsPp8/2aGHAJyDbpk1OpHmhHXqGBGNSeVao6ZPhmKtn0qRXEmTy+OP+
         zc+WQPKWw+czWKvg/B81SY+E3n94D7u2aIA1pX/equqZD4DjuhPQvXmVFfLEncJu8Nzr
         1lcg==
X-Forwarded-Encrypted: i=1; AKwUvBwcDbQTJpCFG37s1bcFug4epN1+NmpLarJRa37Zbow1mTuMnF8OGDbR47DUaDdJLByaH9+due4g@lists.linux.dev
X-Gm-Message-State: AFq9FYIitnPKCmRd/kQ6mZPuVIWI6K/hLyzIDTa9lV1UNQUk+JNYPMgi
	BfFLl56ghiPEDbGMcBjmWIKvtn5HycRi1xI9ww4EbFQQ+s4ei884qyNyDeUVXXcm2Us=
X-Gm-Gg: AYBFou33m78simbgx5vH7leAVtb/kNjTr0aCUbOvXMbDm8KoFRzRJyA29y/q9seVreQ
	fu/USAhXXflfPp9HQBzsko/IFBKLgNRNN43OWUB5WSbogtIMdRkNXHfQqGc6fFgIcDu8ohLBDri
	zH/1kRCSLjD7IlDyZBOzbS9jx2G/D8RIeZ1N3/kvZ6L7A8KY+BUnkGmSQF1Fw4ZwxuN/eMVRVXT
	8C7xnIUSppQIAfFuf3nrYTFI7pb6Ymi5002P2B91U98lSFEU2v0z5r5LgpcXbnC0rmlZgVJ5nY1
	Xw0gTViJz04+mDCLPwSbBGDEDM5BtkFrLJbOHtF6hgZlch/5H4vntVt66vv52xvgZmGh9d510P9
	raF5tld/G8O+a/1RRNlcJnR44VL1TLBuVssPvqwiX5UbtQ5iOKduWIjaRUInfZBsotVcR9SLDqq
	RUV0OdE7/jAZrqiLipxDt60Bnz4lSgD9YYQtbnRq5EEEpKt2v/q6hwtsJCC4PCmes3ESNtnmr68
	yH59YtPSKqEKzdiQHBMzxdxxPK87glro5s77MFta982S0n6qnweXSI2ow2iLG+mRjfunt5Yl/Yr
	5DQLeOyET/SmV3kx3wtS9x3kOaU9ZOHNttIoirkw
X-Received: by 2002:a05:6512:1314:b0:5bf:c27b:8e52 with SMTP id 2adb3069b0e04-5bfd9582a06mr842560e87.65.1793369337326;
        Fri, 30 Oct 2026 07:08:57 -0700 (PDT)
Received: from localhost ([140.209.217.212])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bfe0737065sm2501e87.42.2026.10.30.07.08.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 07:08:56 -0700 (PDT)
Date: Fri, 30 Oct 2026 15:08:52 +0100
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
Subject: Re: [RFC PATCH v1 08/11] PCI/TSM: Bind CTLV attestation to connected
 and locked contexts
Message-ID: <auSkHORl2mg_FiOf@FV6GYCPJ69>
References: <20261028152618.1356860-1-aneesh.kumar@kernel.org>
 <20261028152618.1356860-9-aneesh.kumar@kernel.org>
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
In-Reply-To: <20261028152618.1356860-9-aneesh.kumar@kernel.org>

Wed, Oct 28, 2026 at 04:26:15PM +0100, aneesh.kumar@kernel.org wrote:

[..]

> 		available authentication methods for the device.
> 
> 		When present and the tsm/ attribute directory is present, the
>-		authenticated attribute is an alias for the device 'connect'
>-		state. See the 'tsm/connect' attribute for more details.
>+		authenticated attribute reports the TSM name only after secure
>+		session and stream setup succeed, otherwise an empty string.
>+		Connection control uses tsm/connect and tsm/disconnect.
> 		This is a "link" TSM attribute, see
> 		Documentation/ABI/testing/sysfs-class-tsm.

[..]

> static ssize_t authenticated_show(struct device *dev,
> 				  struct device_attribute *attr, char *buf)
> {
>-	/*
>-	 * When the SPDM session established via TSM the 'authenticated' state
>-	 * of the device is identical to the connect state.
>-	 */
>-	return connect_show(dev, attr, buf);
>+	struct pci_dev *pdev = to_pci_dev(dev);
>+	struct pci_tsm_pf0 *pf0;
>+	int rc;
>+
>+	ACQUIRE(rwsem_read_intr, lock)(&pci_tsm_rwsem);
>+	rc = ACQUIRE_ERR(rwsem_read_intr, &lock);
>+	if (rc)
>+		return rc;
>+
>+	if (!pdev->tsm || !pdev->tsm->dsm_dev)
>+		return sysfs_emit(buf, "\n");
>+
>+	pf0 = to_pci_tsm_pf0(pdev->tsm);
>+	if (!pf0 || !pf0->stream_connected || pf0->base_tsm.error)
>+		return sysfs_emit(buf, "\n");
>+
>+	return sysfs_emit(buf, "%s\n", dev_name(&pdev->tsm->tsm_dev->dev));
> }
> static DEVICE_ATTR_RO(authenticated);

I had in mind removing this attribute alongside the staged connect
change and reporting authentication state through SPDM_GET.

This instead retains the attribute and changes when it reports the TSM
name. Could we settle that together with the SPDM_GET interface rather
than maintaining parallel authentication-state queries?

Jason, what do you think?

[..]
