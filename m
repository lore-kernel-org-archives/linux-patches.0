Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795424788;
	b=ooB4V1QuDEnh0Gvwdz9h5+z0kBA0IB0KRxnWw4afsv8f7O3aNGcsgYoZrQWihDAVpR4E
	 4AlwjVQP/stJgcxSb1BHNXQUWLBXJKyiERJuNdT9fXmo/QyNPmJJUslYTNuwz4Mdfez28
	 NrsuSrpEAXY0KXBhP0zS8V/1BjxVJnLq0QvM0sBQyVTo8DzRitGuRb5wYclwk6RpYnQ6K
	 +9DVuGrLQ4+n9Ie1QkGpZDDXWpzYbanS1f3c43yDqNxduOCh8/1qIeD3KpvRwbBjfNkaT
	 WGa7RKinCv9273mfZLc9cVTNVQcBVoNxAqUjLlhZyfBzhrpqHN/WBD9YEkDH9fT/JBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795424788;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=z3DrjhrQrO2BYHo1W8YewL8VZiJu1abw+mdAXkVRo10=;
	b=j56fXpiCDQI4XBf4ao1VifKFBwtLkv9+laVRuz+1Ub6fCi5s8UfrDKf+ZcAmk/1ODXvw
	 1dBUZQbpoD9oRjbHph/drW//pAKYU4ujgUIzB8X3+iEuQWKWvWGlFZCI1lq5lm1ULvxAy
	 70QaLEqs+iqMPkgpuGXySi6ajUcBXfSezaXQtU0Pa4MAkGqI9oQCv7pYyB/e4udU80zr2
	 lt/MdMKt8A2ZSgaSHBrLIqy/QBglSCLQIqRqqRuW1u4bZuEduNqzW9t4aRUm9nYcyqumM
	 hAWilUxg8uOMCNIuI2ajzitSTWCpTfBYEjHzd1zIJnC3F2315Ier8SBHkUkkLaDhWmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Ev/KbF3O";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C426E606A31A;
	Mon, 23 Nov 2026 09:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ev/KbF3O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 866181F000C6;
	Mon, 23 Nov 2026 09:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795424788;
	bh=z3DrjhrQrO2BYHo1W8YewL8VZiJu1abw+mdAXkVRo10=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ev/KbF3OKJT1NrTyypHir43Ji3PypA3Ny9jOe/nVKGfsjHzqeP+Cwa+SPtqolXMGN
	 lydZKWAOvT/HA8KHudaFIV+wagOvjUDyePIcmfTVqITJ9limgPbzSAN+FO1kMxrZMt
	 6owFBS5no6R0UIhs/But10CR9q+ciC9TrvGjKNnlzVBK7ou00dslYtGotEAIEKIDT3
	 0fQXhs/xSoF3Lkv6qqOkx8RJcVmJsK03JZkNV5cG30uqETnh/WIYOwF+okO9AdHcI6
	 ezuJfAtXmsEFZDFKStxv7Jq4HAQo4w+gOXH/S2IQWa4/peGaVy9ZxxB2+J8JKKON0p
	 CzCFWyHfddqZA==
Date: Mon, 23 Nov 2026 11:06:23 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	linux-coco@lists.linux.dev, Dan Williams <djbw@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Lukas Wunner <lukas@wunner.de>, Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	driver-core@lists.linux.dev, linux-pci@vger.kernel.org,
	kvm@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v1 00/10] PCI/TSM: Support guest TSM drivers
Message-ID: <20261123090623.GK14811@unreal>
References: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
 <2026112325-emit-squeezing-5d96@gregkh>
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
In-Reply-To: <2026112325-emit-squeezing-5d96@gregkh>

On Mon, Nov 23, 2026 at 09:40:55AM +0100, Greg Kroah-Hartman wrote:
> On Mon, Nov 23, 2026 at 02:03:27PM +0530, Aneesh Kumar K.V (Arm) wrote:
> > This series adds the PCI/TSM support needed by a TEE Security Manager
> > (TSM) driver in a confidential guest. It adds device lock/unlock,
> > helpers for recording device acceptance and parsing MMIO reports, and
> > DMA callbacks used during PCI driver attachment. The guest TSM driver and
> > attestation commands using these interfaces are in follow-up series.
> > 
> > This series is based on Dan Williams' "[PATCH v2 00/19] PCI/TSM: TEE I/O
> > infrastructure" posting [1], particularly the guest LOCK/UNLOCK, ACCEPT
> > and MMIO report work [2-4]. It retains device_cc_accepted() and the
> > confidential-device acceptance model from that posting, with changes
> > adapted to the current PCI/TSM structures and reference APIs. Dan's
> > device-core acceptance helper and per-host-bridge IDE stream reporting
> > patch are also included.
> > 
> > This series does not adopt the Device Trust changes from Dan's "Device
> > Evidence and Trust for PCI Security Protocol (TDISP)" [5]. That work is
> > being developed separately in Leon Romanovsky's "driver core: Authorize
> > device trust before driver binding" series, [6]. Confidential-device
> > acceptance is kept separate from that driver-binding trust policy.
> 
> But it should not, as you are making driver core changes that will
> mirror the same thing that that patchset is attempting to do.  Please
> work together on this.

+10000000,

Greg,

This series came as a surprise to me given the fact that device trust
series is exactly for that - allow confidential computing.

Adversarial is equal to the "cc_accepted".

Thanks

> 
> thanks,
> 
> greg k-h
