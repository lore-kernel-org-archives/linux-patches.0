Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.217.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795616401;
	b=zSETLIuDkBVw5BnKhOoqinEbmLi+N/mkpPe35P+khsH35HL7UmjONHGPCGpVnxpygpd4
	 HTS28w01dgnXQN/jIAFQn2Wp1c/efp3mZ+NInnhKkUVuZCgs/5AAnmGbhLeNNvOBBbR2o
	 jgUT5yS2i2PnpZb7f+JJOxmcw/IbkKmgSRATg7/lJoe7beZYI0+REFvCEDRFyj1wv14su
	 ShyX31g3t/gJqV++/Zm6JnsSNYT/5aBhcrVAfGmStTUITrWyOc/Bm6Iq8cCTT1pPmS1C9
	 gry9G1WM9BvIQkzvQ8pTXU/IvBdNkK8ZeEd15f7XJx4wUDC6evz/x3Jr3KO9NbKuxfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795616401;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=/sE+cARi5XYpGFmCaYKKwUnoyCBvBLnkQPGNB1SpCIw=;
	b=aRssMT+p3FT6WpY1Dou7ecOpIhGcp1rbM6CaahtCXlI03rMHQcYAyWkVckvyoAr20Tzf
	 Ld+n/IWBcDbCJ37UfmyBKGfo3kehSYvWz8Yck+wJiqLrjzYg1FQnseBLTeBYYsG6Eis27
	 3fP2+2Ti+pTNY/zYQ4m4GLy4ODxmhvaWIl+lauy/CHGvzY/lv8iWmDXVTkp07Ja5CzePx
	 2pmG9IkBYwZZoNU0SKYo4kx2EUOsDpHLLLhK2stn3MtxzZTrnMprdWTv/W1E8BLGzDS7d
	 5m/TuAbN1GqgW2gqOpGKoLMDEm2YvCXMj7e4Ckgz4jIAc9rByLBq5isP49Cwa05MHbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=G8DbKR89;
	arc=none smtp.remote-ip=209.85.217.45
Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115AE606A329
	for <patches@lists.linux.dev>; Wed, 25 Nov 2026 14:20:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 115AE606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=G8DbKR89
Received: by mail-vs1-f45.google.com with SMTP id ada2fe7eead31-74ab99038afso3782518137.3
        for <patches@lists.linux.dev>; Wed, 25 Nov 2026 06:20:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795616400; x=1796221200; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/sE+cARi5XYpGFmCaYKKwUnoyCBvBLnkQPGNB1SpCIw=;
        b=G8DbKR89Kzgbti7vVPnR63f4O6XbWHbHhxKiKokBvHh6coL6Mwdl0HUuJLNX7y7nHW
         HV4DaIXpSoLL0MaC1Kjbes69IFrnAFIiYcylZYFfpFKw14DFijrENmLOIjFuIO5HnlHh
         Yf6IOTtfqK0sVLLTKM8VB2pXfYJE4nDBNCY4FZX3yK4o2SgNk51Uw4DyS/nNEtA4G8H/
         vWS6SLQorGg7yxUelzP5PxAzr++Eboi3y30JycGGAcD6HHax0BlECIXR532DIxQS+Ucj
         eocJ0FD7AcKH2UzH1ia5zmOS5/OsUHTQ7PxfzoVBO81WI5VX4SgqQdYYAfJ8/qvZa+8k
         upTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795616400; x=1796221200;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/sE+cARi5XYpGFmCaYKKwUnoyCBvBLnkQPGNB1SpCIw=;
        b=MsagJzOilygA+6ycS00vzS4i29/+gy7PPKIMlQf1HONCFKaDLlfolgRjVN3Xpwdwfs
         l/WIXvYhCWCBTV/XhhSNR3Xn+knCejzx3nwaB5Xy+dOClxuuXptlkWNlJGLpzdb8k0yN
         P9WHHBUtclepgMV0lxPfNrkR7VwrmVM8ZLX73cE7cW2QWYNV6G8T6Am73ompHf/kmM/q
         EnTex17sFYD9FyHVBWpSHTFIiDYlFmQhtBltoMbGNG+r7KfhQ1oEf1Jws+h3MaypLmZi
         sR53Hl/90DPJw2xgQj+zjnrDse/rTyR/sEnJL2KH8VfyVstu5yy+oxOhFcYwN9cJCaFW
         ngnw==
X-Forwarded-Encrypted: i=1; AL+hErGhOTny0KBhRW7KJ4MIdNtMweEPF8f/3l6phlAljjZhnNEot6ZU7gueBulb9bLNx0Qu23HxeGeD@lists.linux.dev
X-Gm-Message-State: APuU4Z/gAoxEckmmYPo9xhSQrWV1MM2EMdT8DhqhuChpD+YuGQdrmUFA
	b8CmVyKUNRYkarrd1XoFAOOL2TornPFQlrc3nidML4T9rS4QQMWWHBXndPSI9RaYwALM15hg+S3
	mBSsA
X-Gm-Gg: AZFdTZdLvS+ybtLUECBlCrKp5rSArIf3v5sJUffGCNsMxtPI4v2bOHylSqCv6JTwr23
	cnIdf+yrQQ3xG64JbOehpzyq2kgHkQQjVFaRUzV6GnN5oeTi28WD4kihOS6faM0GB1GS3bhR5IV
	MzUPErOrkL1Bs0AbT7OQcR7UWy7+4ONgMVR61jpRa0i6sqnrtHDwz2TSLK1DEgXPQbSRXPEYxf9
	evh7kI712kg/hxIO0Mn7eWZV/y8Qobn2+9OmN/brCTwNZZB7z3TvDiRMqYGSIhWY0XnM0/r0MAT
	aOSxpHSsCzvdKVOwZB77Se079cLdI3OShryrsZwhxMif7UYiGc0vY9d3RFmewUnR2HTNBmxLQ6y
	XlGk+CmIPu3E6m+9Cq6hVzCBcsnUmXP6wZQ9C4EfKzEEd8J8m/++q8b4zl7X+VwS9k9Mlj8dzAV
	eZrrvqkax7Rz4Hbebe0DRSDWlhshNpf6RBK0ARYJTUZECT59kSALcZBtYZcI07890GNb9+lDT4h
	NdYldwLR6cTn91tBu/R8mEcusVNXbqKa9pvUnwVkuFLvL2nlCa2C0Xsuqkik1UyHO0qQslehdM2
	ArJVI/0u4UnvwdyoRUTOSp1K26U=
X-Received: by 2002:a05:622a:258b:b0:55d:3789:8c8e with SMTP id d75a77b69052e-55d769e11bamr337179531cf.15.1795616388597;
        Wed, 25 Nov 2026 06:19:48 -0800 (PST)
Received: from ziepe.ca ([142.177.118.84])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d7889f8absm153708121cf.27.2026.11.25.06.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 06:19:48 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xWDqd-00000001jay-2IOg;
	Wed, 25 Nov 2026 10:19:47 -0400
Date: Wed, 25 Nov 2026 10:19:47 -0400
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
Message-ID: <20261125141947.GD246011@ziepe.ca>
References: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
 <20261123083337.2731019-5-aneesh.kumar@kernel.org>
 <5e04323f-dfdc-4956-acee-bcc09926726d@amd.com>
 <yq5aqzg99uio.fsf@kernel.org>
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
In-Reply-To: <yq5aqzg99uio.fsf@kernel.org>

On Wed, Nov 25, 2026 at 02:07:19PM +0530, Aneesh Kumar K.V wrote:

> That is what this patch does. If IDE setup is not complete but the
> device already has tsm0 attached and connected, pci_tsm_context_get()
> returns an error from cca_vdevice_init(), preventing the device from
> being assigned to the VM.

If the device has not been fully accepted on the SPDM side then you
should not be able to create an iommufd vdevice for it, nothing else.

Jason
