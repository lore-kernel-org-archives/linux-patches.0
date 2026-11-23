Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795435088;
	b=FlQwOHRh6GAI5G2pdDD9D7QocSVaafHkH/XsJkDn1PtElyMkZfAz1bLs+iA+eoKWAd6N
	 2XcHe9hgp2xiRzTtl8fK9sbSnz3xsjGWHieThwRh4GeCocEZBnKwXqFcoBHv5NUu07CIB
	 XTnlLbC5wOYgZBPvL00i/Z1yF0TEb8fx9YmxZwKFSF/GTocSQahcCSDw1liFmOeZ1VqjP
	 eQu9TG4ghCyl6pwbbdoRz4tD7W4qjUHkgXAw5LYWXmb7CgwaNBBE0bqrqkpU6kZU21FFS
	 fhLNARTWsi0e6jSMLAnVq3WJwBCe4uCgleV4eNfQIB8vYnsDHLP7iC3IOr0XWRAecVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795435088;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=0TmBe1tXlcWpfCVrfd1KqqoznT5l5Jx1iU5TZr+SAgw=;
	b=hTZKecc1gtevVLiSXQoVsKHWKeZnSB+WS1vor/ZQ36UPTcGhm+XQGFeZaeKzQD6TTvqw
	 GFiHWUhaScbiRSiJ1ByGDL61nhnERH+V6glyCaFM9mQKzukqVxF2JrmqG0hXlN/G8e7Or
	 rsfd1ZChixV7MlQWboZGzxynuCj/9eekfEe4Qq3W4PitAEj9eDXY+8oD5CG3rbUU4NEXH
	 zjbeud6kxUV+f1Q4ErdUn7DpvwXKuHy1FPiZ+ggQOr18w4BGOs1b0NSiq/hKOHsahLjYX
	 7QCn1AlO/8DbJZLeLWmyZryDPzTpFVlPrjJ/ZinAfi0gaZcCwkjgYPJs9LKFRsM6Jaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Du1Kyd/P";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0EB5606A31E;
	Mon, 23 Nov 2026 11:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Du1Kyd/P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98C5A1F000C4;
	Mon, 23 Nov 2026 11:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795435088;
	bh=0TmBe1tXlcWpfCVrfd1KqqoznT5l5Jx1iU5TZr+SAgw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Du1Kyd/P8Lt8CAlnCV7czApRJxSEjYBL842wCUV0K57v809kCt9syFf0KB08w77MM
	 JujsWwgrqh7lztdFxkWRgR4X3WQmsCsj5/8FFfoeif8cO/de/Whfz74lZZCwQ8R6UW
	 8NJHIwr/RI+Fmc/6yn5zCmCebhKDshF6qsqaP0jfF1oRjGYll/8c3EvfDv3dzSVYj+
	 dDpJrLtmJkj5SnWHMzQ5EhjhM2UNnM2mtqOPQnVlG/BrW0+x94gc9vI5q2USFGxw5R
	 cl/r6ieFsaF4x+9d24X2yRBTgGfDQsxUumN0rmfCjpqZvFzIZ07Y9Xr11v4JuwFvi2
	 MBF1PVHTKOhjA==
Date: Mon, 23 Nov 2026 13:58:03 +0200
From: Leon Romanovsky <leon@kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
Message-ID: <20261123115803.GN14811@unreal>
References: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
 <2026112325-emit-squeezing-5d96@gregkh>
 <20261123090623.GK14811@unreal>
 <yq5a7bi3riha.fsf@kernel.org>
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
In-Reply-To: <yq5a7bi3riha.fsf@kernel.org>

On Mon, Nov 23, 2026 at 03:13:13PM +0530, Aneesh Kumar K.V wrote:
> Leon Romanovsky <leon@kernel.org> writes:
> 
> > On Mon, Nov 23, 2026 at 09:40:55AM +0100, Greg Kroah-Hartman wrote:
> >> On Mon, Nov 23, 2026 at 02:03:27PM +0530, Aneesh Kumar K.V (Arm) wrote:
> >> > This series adds the PCI/TSM support needed by a TEE Security Manager
> >> > (TSM) driver in a confidential guest. It adds device lock/unlock,
> >> > helpers for recording device acceptance and parsing MMIO reports, and
> >> > DMA callbacks used during PCI driver attachment. The guest TSM driver and
> >> > attestation commands using these interfaces are in follow-up series.
> >> > 
> >> > This series is based on Dan Williams' "[PATCH v2 00/19] PCI/TSM: TEE I/O
> >> > infrastructure" posting [1], particularly the guest LOCK/UNLOCK, ACCEPT
> >> > and MMIO report work [2-4]. It retains device_cc_accepted() and the
> >> > confidential-device acceptance model from that posting, with changes
> >> > adapted to the current PCI/TSM structures and reference APIs. Dan's
> >> > device-core acceptance helper and per-host-bridge IDE stream reporting
> >> > patch are also included.
> >> > 
> >> > This series does not adopt the Device Trust changes from Dan's "Device
> >> > Evidence and Trust for PCI Security Protocol (TDISP)" [5]. That work is
> >> > being developed separately in Leon Romanovsky's "driver core: Authorize
> >> > device trust before driver binding" series, [6]. Confidential-device
> >> > acceptance is kept separate from that driver-binding trust policy.
> >> 
> >> But it should not, as you are making driver core changes that will
> >> mirror the same thing that that patchset is attempting to do.  Please
> >> work together on this.
> >
> > +10000000,
> >
> > Greg,
> >
> > This series came as a surprise to me given the fact that device trust
> > series is exactly for that - allow confidential computing.
> >
> > Adversarial is equal to the "cc_accepted".
> 
> I think the confusion stems from this thread:
> 
> https://lore.kernel.org/all/yq5amrr8yldi.fsf@kernel.org
> 
> Based on that discussion, I understood TRUST and eligibility for private
> DMA to be complementary attributes. Device acceptance determines whether
> a device may access private memory, while trust determines whether the
> core must enforce additional restrictions. I understood that supporting
> an accepted but adversarial device would require either a private IOTLB
> to restrict its access or an IOMMU.

I reached a completely different conclusion from that discussion.

Device trust does little beyond preventing driver binding and recording the
trust decision in "struct device". The missing piece, which I would expect
you to address, is ensuring that the IOMMU and private DMA are configured
only after the trust level has been decided or as part of that decision,
rather than beforehand, as they are today.

Thanks

> 
> Therefore, with this series, a request to enable private memory DMA is
> handled as follows:
> 
> 	if (!device_cc_accepted(&pdev->dev)) {
> 		ret = -EACCES;
> 		goto out;
> 	}
> 
> 	/* Adversarial devices are unsupported for confidential DMA. */
> 	if (device_is_adversarial(&pdev->dev)) {
> 		ret = -EOPNOTSUPP;
> 		goto out;
> 	}

The snippet above clearly shows why it is a good idea to wait until support
for device trust levels is accepted. An adversarial device is untrusted
from the PCI perspective and must have private DMA and a separate IOMMU
group.

Thanks

> 
> 
> -aneesh
> 
