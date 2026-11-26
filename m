Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.217.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795706091;
	b=D/xai4durVAHGnfmxPLcjfSMM9sjHNq4BRwSK5mEQjhtYqGp4Kp70ZA4UgiLK0uXiFPW
	 z/6ZY9DpYIoaqk5rtJlWYe5M75GHkZkx47WdvMLVSxgcsqpFzAf5l1QiZ0JasOVEXjuZt
	 rfKTin8hVfEjkRtgRe1oYlXgMtBYEh77RIuooYSC+MdBr+pyY7Jaj3FfCT56PrvvpjAyV
	 PAusohHxgBQqsCf6mlkr6yhRyLT2r2+hPbjPt6rLJc1EIlbO2e/y1gdjon7nxocOl9MG7
	 iUz3H7faCOCES48HlJ4ptVogYJl0PENlVCjso85GSOPefIXvFfj9/RcY4hxHth8qD1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795706091;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=Fmk7KvplZu8IqXCFaSm0h6pjbCmnVJRD63HoP6Br6hc=;
	b=DeRoi7U1jup4UkiuCMstnIqE4OZDQqmk/a12rpdFBosZ1fYrTWVHGOmJcVPDegQaBhNx
	 cxbdp42819zk3mfJnRVrdx8a3rRrEwelsphMhbU3GE2mp0wwuUKK8QgPbHj8bylkfsEgV
	 o9nhrlJSo91VcrW8gmYLPDD8WRK4BDLAkKdLTKh8/S8QHqSmH41ot2nyg56f2TMfrM7xB
	 pVReyIdiaW71Jff1HerFQCB5oXRUrSiVmp9IeyKS4rytYWcUQbYKzCfwl7mXROPi1q1+k
	 u1/sAt4iOO4s86gA4m6lHzsLsrrupO2UUkJTmedS4Jws5qK6FFUWe7rFkIkp7A+AI2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	arc=none smtp.remote-ip=209.85.217.44
Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3136606A31C
	for <patches@lists.linux.dev>; Thu, 26 Nov 2026 15:14:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D3136606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-7d2c8141dc6so3773805137.1
        for <patches@lists.linux.dev>; Thu, 26 Nov 2026 07:14:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795706090; x=1796310890; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Fmk7KvplZu8IqXCFaSm0h6pjbCmnVJRD63HoP6Br6hc=;
        b=CjppQh2P+eyPwIOGQ+UmQnp0d/uhx6KyOfYxZ1uLohZRS058XnYrvmbv+/Qjv0ukqG
         7Dy32TqKPbXN3l5CktAYXcA/UFbUztNlVw0g4hpjysx71DuwNS/rQgyqmnMeqStBLiVN
         AWF5vEYXxIVCAala3lN01DcnrvhPE7AhqtWZ8r9+ZN6HhvaqoMJvSOh3FCVwJYetpVIS
         IprLpA4BzdiNSI2M3rULDrqLTHtM/YPQJ3B/4yt5dj+SkNPuHWCQ/t/3FNV3xEGfDggu
         qHNelrHPWJs3IpeOG1j/TNm9qczucuOdVDsmRQMQSMq6r7isSg+lmOcHQhAAsfPl47yE
         1nYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795706090; x=1796310890;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Fmk7KvplZu8IqXCFaSm0h6pjbCmnVJRD63HoP6Br6hc=;
        b=ul6G/AkjbKOE8s+k+40Ue6xjzcTm9JReSgEEfbouTEJr1WCgFjRlbLLE1+8V2ZsL7f
         0wciPCs6/i71AZUKgJmnVmGdcPWZa/9QX4GP+aV9WMajq06B1iIDObtSxJ08LULTMblo
         DD3fQ/urIlxwCL/8GcPFvfFYzh4keKyy/MkrQEb3Y2eWZKxLTZTLSBJmZnoyRMOSnnp6
         4mWiHeFt3dn4YV9y4oEHbN/tYuSs3jFCgA2Nc2EueWTIp/T2bOKT/ONPTSHqzcaM4zhD
         8T6Rhbn6eVcuXA1gTSLzO5wIVNvQWYURNEZryflgPr25vU0yxftv2SNsNjrhfAVlqR6J
         7i9A==
X-Forwarded-Encrypted: i=1; AL+hErEIy3t2hr5ht3aCHjr/BUTgGWHPUjEinhsDuTm4eNHgK0lhbLbLHYgx/RXYBXznHdAZfeN3aEZd@lists.linux.dev
X-Gm-Message-State: APuU4Z/5nn+P8DUsUyXWAwF0QrlAxATAwdBslfDm0hUCUaWjtaCMKFIN
	uJZQZR1avO+XZXPEJOOXigmw33HN+DbhLVim8r1s3rw4nyMpR1oLE5thBYtt2nj6Z0Q=
X-Gm-Gg: AZFdTZelc23FGepVdrTd4uFk3uXFHmXPESV2kZEP0yEG5vpwCYK21ELSoUWlvBXPA2M
	wwujlA4C3nX0MpxMcirNUd1QV44UhYlRKG87IMu3GElj1r1lEKGeYZWmAt/OAGsBHHjK3UFzDsW
	QVRGGkbiuHK9FmmNjVDZA47Nzz9RV99y4932Mr60l8uUpDUtKhKuETRnC1RLKGZIejSAU10i/lX
	UEpG14pzI1pOqj5avEpEKcSRDnALnzOAfmBf+aIr7wh8tVMS1VDnOeeufJNTl3d1lGps0HG80Zm
	TMjlB+PllSqpa39QHtaF8FO1jgy/RySyKITTuc+VYtyoJncHpW8qGYAoRX5VU72mUKNpe6v+vow
	95DfSDPzKVtrP64FV0GnqfxTdwzxPmHCXU2n+GxLIfcJlOuQuPB8GHyWXhEK2SODJ+VAxIEdNS0
	6/Lw/IImxoss6eIME22yZOHToaI4xHf555LnwWWrz4DGMCAEPiLHS+MxNy68m2wdnyc9gA7IcnM
	wradGbAwwHL0Sa5ULnKjxnYT81fc/tCf6cnmfH0PgbgYieQVNxbDtfhO1HG9hORn7JfeGuOo6Qf
	t6U15L4=
X-Received: by 2002:a05:6102:84c8:b0:7c3:2168:d603 with SMTP id ada2fe7eead31-7d71e329ce9mr10299312137.0.1795706089640;
        Thu, 26 Nov 2026 07:14:49 -0800 (PST)
Received: from ziepe.ca ([142.177.118.84])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-921349cdfbasm193141456d6.17.2026.11.26.07.14.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 07:14:49 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xWbBQ-00000004NdO-2PDc;
	Thu, 26 Nov 2026 11:14:48 -0400
Date: Thu, 26 Nov 2026 11:14:48 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Alexey Kardashevskiy <aik@amd.com>, linux-coco@lists.linux.dev,
	Dan Williams <djbw@kernel.org>, Leon Romanovsky <leon@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Lukas Wunner <lukas@wunner.de>, Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	driver-core@lists.linux.dev, linux-pci@vger.kernel.org,
	kvm@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v1 04/10] PCI/TSM: Defer TSM vDEVICE allocation until
 device setup completes
Message-ID: <20261126151448.GO246011@ziepe.ca>
References: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
 <20261123083337.2731019-5-aneesh.kumar@kernel.org>
 <5e04323f-dfdc-4956-acee-bcc09926726d@amd.com>
 <yq5aqzg99uio.fsf@kernel.org>
 <20261125141947.GD246011@ziepe.ca>
 <yq5ald6gul7q.fsf@kernel.org>
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
In-Reply-To: <yq5ald6gul7q.fsf@kernel.org>

On Thu, Nov 26, 2026 at 12:34:57PM +0530, Aneesh Kumar K.V wrote:
> Jason Gunthorpe <jgg@ziepe.ca> writes:
> 
> > On Wed, Nov 25, 2026 at 02:07:19PM +0530, Aneesh Kumar K.V wrote:
> >
> >> That is what this patch does. If IDE setup is not complete but the
> >> device already has tsm0 attached and connected, pci_tsm_context_get()
> >> returns an error from cca_vdevice_init(), preventing the device from
> >> being assigned to the VM.
> >
> > If the device has not been fully accepted on the SPDM side then you
> > should not be able to create an iommufd vdevice for it, nothing else.
> 
> That is what this patch does.

Well, it doesn't exactly. It adds some code without any users and
doesn't explain why we need to export a lock or add more core code for
this activity.

Nor does any of the naming imply it is only to be used for iommufd
vdevices.

It is problematic to be hacking the core code without any drivers, I
know we are kind of stuck with this, but lets try to limit changes to
supporting stuff that is potentially about to be merged. viommu is
fairly down the road still due to all the dependencies.

Jason
