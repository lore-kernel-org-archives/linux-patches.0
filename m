Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793837615;
	b=lRxrJi5Y05Yc3Dy57B1IHaDGb3hwS06XTDe0Dyl9GtWPkd8kyXPpRKjzcWr0ULkTS+wZ
	 sU9W2ifGUwPfSfJzlab019Ej+1NNKrITzx1H/QNotzzaq6KNuVavBsA3uy5ZdbkYGgiHE
	 deJLvbRxwRKVpEXvAhq+40k+yAmn1+1cniTrs4vPoQ4PHk83vKsGfdzGERlWHKeVPkjot
	 Jd+wREh+Y9RXGmlaPRgNIO6B09PsWMOAMaaKUicJ6Ulj+5Pih8ntVUcNC4lRliHSp8C+7
	 du8ottjgM3nb1Mdl7OsdHPqwiHhptXfACeh5OfePE2hV0ikbliK+YuZRS3QelcsO8sQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793837615;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=orqNvCIr/GD7TIfy/qrX+MEjo8QabahDm8euaMSc6BA=;
	b=EdVz1pUdlnOMOODZQ1UIypLPwPfyg9zls5dTr5hT9wA2m6ettm/4KKBOC5NnFk2WAJbq
	 e1pV/+jkQ7YKA4ACGv2mTDCW33HksPUlcbRuqNVG0IWFsU04bYJ0ur0D+Ig4OuxE0/zu7
	 TGHtRgSoLRj3fUOMGxnGDIlXebsc/2FuoPezNiCHCcWH+iSllQMxyaHM2BAzp28U7ATMq
	 GwmlmnxwWktUOxFYja/Gt7pdlp9dDNesXb/fNGuY11+6aNQwJNN2rYwJWc7bkgUy4yJVB
	 M46naarMZu1gV6QrL2oWmWHj/rSBFSUHGEwAUyrI41Za3FthnohHEGLDsnke21TqxTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JT5VLO7c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD43606A333;
	Thu,  5 Nov 2026 00:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JT5VLO7c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BADC1F00919;
	Thu,  5 Nov 2026 00:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793837614;
	bh=orqNvCIr/GD7TIfy/qrX+MEjo8QabahDm8euaMSc6BA=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=JT5VLO7cllg7mmJOzhQ5x2Ody9G1mMMBNmw2jsxCje8IhTlkJVfJAk3hlf/pZznu8
	 5FIsPH/ftaR4HBsCCHA2COCVqaXqkO50Fz0hbeKMHJbjmKjo8rblvMjeXToTy0FLwL
	 XiKh/AwUxBshDk8b3WpuC77CzNb3pz5qx0PbxH2OgWDubJDqLYeLV6j7aQYOvd6rZN
	 fy4nNviJ1u0gblzJK7MrFOr0ml1JyfeetmZXbQFHtt1aQuhnm+14OEmF0MnHe3nzJw
	 mjGb1GvvQhU3QMNcrMgnBDPgC7+BvN/pLC4K3tIaCfhl4j1gU7gjVRy41Htog3pARf
	 8bLfx9TaGkOBA==
Date: Wed, 4 Nov 2026 18:13:33 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: joro@8bytes.org, will@kernel.org, robin.murphy@arm.com,
	"Rafael J. Wysocki" <rafael@kernel.org>, lenb@kernel.org,
	bhelgaas@google.com, alex@shazbot.org, jgg@nvidia.com,
	kevin.tian@intel.com, baolu.lu@linux.intel.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
	linux-pci@vger.kernel.org, kvm@vger.kernel.org,
	patches@lists.linux.dev, pjaroszynski@nvidia.com, vsethi@nvidia.com,
	etzhao1900@gmail.com, Danny Gonzalez <digonzal@google.com>
Subject: Re: [PATCH v8 5/5] PCI: Suspend iommu function prior to resetting a
 device
Message-ID: <20261105001333.GA1478880@bhelgaas>
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
In-Reply-To: <auvHyrZmMXLTFyz9@nvidia.com>

On Wed, Nov 04, 2026 at 04:03:22PM -0800, Nicolin Chen wrote:
> On Wed, Nov 04, 2026 at 05:55:00PM -0600, Bjorn Helgaas wrote:
> > On Mon, Dec 15, 2025 at 01:42:20PM -0800, Nicolin Chen wrote:
> > > @@ -4885,10 +4919,20 @@ static int pci_reset_bus_function(struct pci_dev *dev, bool probe)
> > >  		return -ENOTTY;
> > >  	}
> > >  
> > > +	rc = pci_dev_reset_iommu_prepare(dev);
> > > +	if (rc) {
> > > +		pci_err(dev, "failed to stop IOMMU for a PCI reset: %d\n", rc);
> > > +		return rc;
> > > +	}
> > 
> > Unlike the other reset functions, this one calls
> > pci_dev_reset_iommu_prepare() even when probe==true, i.e., we don't
> > want to actually perform the reset, we just want to know whether the
> > reset method might work.
> > 
> > It's at least unnecessary to call pci_dev_reset_iommu_prepare() and
> > pci_dev_reset_iommu_done() in that case, and maybe even problematic
> > because the pci_init_reset_methods() probe happens from
> > pci_init_capabilities(), which is pretty early during PCI enumeration
> > of the device.
> > 
> > I know this has already been merged as f5b16b802174 ("PCI: Suspend
> > iommu function prior to resetting a device"), and I'm not sure whether
> > we should do anything about it.  I wonder if we should just skip the
> > prepare/done when probe==true?
> 
> I've posted a fix for a few times actually. The latest one was
> posted yesterday after a split:
> https://lore.kernel.org/linux-iommu/c66d5221a8e4356316d4f614c8584a80dc9d71b6.1793729707.git.nicolinc@nvidia.com/

Well, that's embarrassing ;)

I acked the PCI patches there on the assumption that they'll go via
the IOMMU tree since the interesting bits are there.
