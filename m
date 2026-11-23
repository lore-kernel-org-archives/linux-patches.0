Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795447746;
	b=qYgDXr/WcOjh/tKKTBU48ecHf9P4ClePcEwDfj5YVjYDPNuWGpNHvfUftlV58ZMSB2Za
	 7PoX+TFUUaVBpW8ed2YIMXxhjt3QD0dOuVSXpjFSXADn/cdTjvtb1Tu3fZ3X1myQB4dxq
	 +f4QGT5DUaLJFISD9sy8DNoeHQN+JG/qFXNfSzddrdLm7lb/EHSzAEBttUckDglpasirl
	 wI3BWibsUHbG3UMs//0+hSnJxJg6dhDcPn5rRv6s2RGisq9FNaf8ovLerOK1KMrBBrwhV
	 fO1XHg80RrrJRvGc86iXQbGbXWJVojSC5EAiOJU6SNyURYcTEPdRoUNPIIh4AfMHEzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795447746;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=kjgFR4G5OQ9juZKj9Y5T78qgRaR4MXSjWG7XFR0Z19k=;
	b=pQ6H4D6yRi54XuxaNKB9ROY1W+HGXB/fxpBhgD3ly0KeEZ3I/a8XK4XVMqjbvoYmVGts
	 HE+BDGVDNM+dpZTafwEUJTaeq44coMT9g0vfUv/dnlLXtDguECDyBh73aydPygZbfwfoH
	 T15G+sObbHm2nmfJK/jwKKzf6ZLkDclqpC6Ov3+RJKLqVvTrcdLrA+Q/udFT/D5yM0GoX
	 0LBrqzL4adkVGI2RrLyKjAFbrhQi8Kfb4UteoFvAO5YvDrla1YRcTLKmziPsXMMu9vjQk
	 UDFOZJIsEtcZsTD8aU1MHCbkizogXtEdUG18yeWxEvWR6UnrQzH+Hn9ZqITkbjPrNBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=gZEn9koT;
	arc=none smtp.remote-ip=209.85.160.180
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82D7606A327
	for <patches@lists.linux.dev>; Mon, 23 Nov 2026 15:29:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B82D7606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=gZEn9koT
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-537548b811aso29154081cf.3
        for <patches@lists.linux.dev>; Mon, 23 Nov 2026 07:29:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795447745; x=1796052545; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kjgFR4G5OQ9juZKj9Y5T78qgRaR4MXSjWG7XFR0Z19k=;
        b=gZEn9koTSc5kKwZ6QFAq2k7itG25aeQ1P/1B1oy6qdQ/YJfIe/YYqIN/LRz4A7j9a4
         udXAgl2Qqa8gtqlVseX61zmZp27lUQT5lFHKSCJh/llBWbjh+E3ZZ2Omi66Z7KouC05s
         WIChZGodznrqv4pvVFh7KN6lBQAzBKonkxCclQUidDSi+UpEfhb4ksS491sAxeoOdpbH
         hqlf1wnjsZEMhbG5NKTTnunD9tG80CNfVD+XZcccV4tf/57+Zy+VB7TRPls7pqFb1Vke
         LSNEZZa8f7IG+bwMPOdjEITLCY71V9FfDUKzPD982BXUTvmY4CFbGwyvlzJWrpOOr1ig
         f0hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795447745; x=1796052545;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kjgFR4G5OQ9juZKj9Y5T78qgRaR4MXSjWG7XFR0Z19k=;
        b=dewClvCPn0Xvyv0Estg73M0XP4OseJs34Ip7gzFFwrg/6zDUFEZkGgJptmOr8TNkzc
         Kg2F9RZxSv7BqBqB+uWC9cCbHKeo0sdZ2lq3W1tpATZERf1wmRrRHcU22GRrOpOZraeq
         x0YSMKnlGVjqFsnK1OZ7rjD14ovHo8VODoavX9mfOUlPlCOytLMUiF/y+d44kByk/zu/
         GSXnDOHBAvx4pHKPtETeg85bCdABAENccHaw/GnF/X3gD2vsIi6XpLYtxaU8iosIx3QM
         kl9jiSnPpjrJTtF7xOutbgsXp1mgSSz5jbqPTUB/4St11Br5pkdnQRvXGhOg6YWoo6Yq
         Aklw==
X-Forwarded-Encrypted: i=1; AL+hErHx+Spmn5LQkxvQpl8/CffjbwQOqOtY8nz5p6LXtPCxsYL60psB1yQyU2ojealLP3rjeueOYU4F@lists.linux.dev
X-Gm-Message-State: APuU4Z8a9yUsaVKDska95QG4YOFL0v/uC3jB90xGFKMF5lyXEXFLXZuI
	U/0eLxZNWucz5lJZ7+WyZmDhASqL6WMJkQuQ5Qm2U7RDod80Ke1hgebpYLhalx9ybVg=
X-Gm-Gg: AZFdTZeuiylXlyWq6qeVLOsIHHAhPYqeqsm3M3XBbWUbK93LyUAjxJlHddGHARM2cBA
	nuYm6J4voqabfWVpqmoaCaBMjXVMR9OkIEFsjW5OyW/+8x3lhchryKtZ3AZ5JKOTDToC8cgV5Ye
	tUZgkgi2oaZ1SOylnwN+cJlkRLijDej23NNxZUbS0zvfkWzUshMZO43Yg3osGqPWF7dxxcDsVFd
	HrTaV/6SZOIQ9MCpwjaoi64dkFHUR9j6n3JtwV1JlLZro8JFu8jhWhMXZ05BFPJJnC6aacvyAnU
	Pi1Npdq8nvLTtlxWZevJzncw++xQyOrIKOxhmQJOf/tPVnaDKCYUgxv6uDev9o1yccEabaoJUPn
	Imb7KGaTCQ1/Vgx7kI/YslIIIZIj2Hc3VTyo7MZaQfxM/22CsOYU4xX77KNJDxNDnIoMBSdw2j6
	f397r/XsGAG6kya5Ziv8yTy+rBMt5NqkKgHKT1EH06+DqBuKxIfw9X2kI/l6goG1ItE9PpUDbeu
	UK4W5lUU0RKE5XpmjR8GNwrsInhZDS/FF6NP6nYcbm5lZFiPVgGdyU9fqEktBiCveOhFDnfl/QH
	EzJS1dxAXfjNRcyPJdjLb9Rff37JtUI0Nl11l5w6LfLdq+36aM8dUihMZFhdXfKgh7bDYNtQ9Nt
	E07o=
X-Received: by 2002:a05:622a:248c:b0:55d:3350:d270 with SMTP id d75a77b69052e-55d769f5705mr226617451cf.35.1795447744614;
        Mon, 23 Nov 2026 07:29:04 -0800 (PST)
Received: from ziepe.ca (stjhnbsu6iw-159-2-142-59.dhcp-dynamic.fibreop.nb.bellaliant.net. [159.2.142.59])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d784517casm101253631cf.3.2026.11.23.07.29.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 07:29:04 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xVVyZ-00000000sUM-05ni;
	Mon, 23 Nov 2026 11:29:03 -0400
Date: Mon, 23 Nov 2026 11:29:03 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: linux-coco@lists.linux.dev, Dan Williams <djbw@kernel.org>,
	Leon Romanovsky <leon@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Lukas Wunner <lukas@wunner.de>, Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	driver-core@lists.linux.dev, linux-pci@vger.kernel.org,
	kvm@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v1 02/10] coco: tsm: Register the TSM class before device
 drivers
Message-ID: <20261123152903.GG179082@ziepe.ca>
References: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
 <20261123083337.2731019-3-aneesh.kumar@kernel.org>
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
In-Reply-To: <20261123083337.2731019-3-aneesh.kumar@kernel.org>

On Mon, Nov 23, 2026 at 02:03:29PM +0530, Aneesh Kumar K.V (Arm) wrote:
> Register the built-in TSM class with subsys_initcall() so it exists
> before a platform TSM driver probes, independently of object link order.
> CONFIG_TSM is boolean; remove the unused module exit path.

Why isn't it modular? This is going to force alot of stuff to be
non-modular.

Jason
