Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793836503;
	b=rIP8ODIkIAF91Iw5zh9e33djcsvINT4Y4wCMbigP3m0ziEnPgQb6CCvun8NDjS0Zaluf
	 y+08GwnhpWhMOdc7VDpq/C6TRg+0mu9rL7Regh0b8Wf5lk8RzCcH8bm9f7N332Ey7uLBN
	 5e3v3Q9P2FY3xgjHiKS22FJugBpUgZ/lvrjm+gY7XBR/Pwltt+ltYRpySP2nw8aVST28V
	 zEwGX1NT9be/PnOIVsdLPFccnY2DlVIoh8pW5FJS4NRLgRm5kod0+a4yCRtzZOdvDLFMX
	 CasVFAvPaCw2CRIX1wBCNTPkypapezP7h2tt9dbzoj/2bQiiIXH4sRKkgtGAauB6KTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793836503;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=IdsyS82S9xmEux1Z7p//48MeApymfROqKvbsztaBC5Y=;
	b=Az9OJDoTw605BDtd7CKcNZSpoYSMzNWWdBPzxt7B5qDa0KgYEqDX6Lw3Sl8WnjZZtCd5
	 YKNvNckXZG7Xmb2QsX7RNAAqNL+MfaLBTxF/Q5+LF2AMNKwUvy3JL5QWTQnugv7S4tiw+
	 utqjn2754cXNe3ke9IvgvBlcNrxfLPZSy/bUWuRQNTT/vIDmht/TYL75KbBr9Q9iGeRIG
	 rOJV84SoEmZl2BJBEecAUkOYUeHtiSfEsWtb+/NDZvZkSqhhJA0Z4VFo3fZbZLark3iYD
	 GEQ6pBzZJjMstsuzyzxyJp4dUS/WEG42EoXZTTFkdNfn74hdHKiNnsTfVaU9TQUJJcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mvi8mwQk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B20C9606A32C;
	Wed,  4 Nov 2026 23:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mvi8mwQk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B1061F000C1;
	Wed,  4 Nov 2026 23:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793836502;
	bh=IdsyS82S9xmEux1Z7p//48MeApymfROqKvbsztaBC5Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=mvi8mwQkbBCz1G8u+WsLGD2et7mREaqQJRVO2phq/i6ayqccFRl8LXutTZ+rFZi+d
	 golFdWhlzEcOiUR8yOuCXOU55n9Zgc9jsYhVAf4aY5D44zXaXhvWWyXfBxEs6m3MoA
	 P94Yx31Gdivl/UaUaGVlY4twI7tXiNTnGjaU6SyOLwcWtaXA9pBGksWJoiSSCxbP79
	 mldFp9P8J6COVJS3NnLJAVzx7BgYUpGU/0uyHtHQvTUq2wYAafsRZAJbBFtpA3WOzl
	 jXlo9SqRqt2yAxScV/n4ptBh26+98j/xrV8MqxRSYmelR7eefqr2eLvbJNgk1u63gK
	 nacOVLl4F3jMA==
Date: Wed, 4 Nov 2026 17:55:00 -0600
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
Message-ID: <20261104235238.GA1469671@bhelgaas>
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
In-Reply-To: <348c50ab6e95b5ec6d48ee3fa05d529a784a34c3.1765834788.git.nicolinc@nvidia.com>

[+cc Danny; this question was prompted by sashiko review of a
pci_ats_supported() patch at
https://lore.kernel.org/all/20261020181053.2646782-1-digonzal@google.com]

On Mon, Dec 15, 2025 at 01:42:20PM -0800, Nicolin Chen wrote:
> PCIe permits a device to ignore ATS invalidation TLPs while processing a
> reset. This creates a problem visible to the OS where an ATS invalidation
> command will time out: e.g. an SVA domain will have no coordination with a
> reset event and can racily issue ATS invalidations to a resetting device.
> 
> The PCIe r6.0, sec 10.3.1 IMPLEMENTATION NOTE recommends SW to disable and
> block ATS before initiating a Function Level Reset. It also mentions that
> other reset methods could have the same vulnerability as well.
> 
> The IOMMU subsystem provides pci_dev_reset_iommu_prepare/done() callback
> helpers for this matter. Use them in all the existing reset functions.
> 
> This will attach the device to its iommu_group->blocking_domain during the
> device reset, so as to allow IOMMU driver to:
>  - invoke pci_disable_ats() and pci_enable_ats(), if necessary
>  - wait for all ATS invalidations to complete
>  - stop issuing new ATS invalidations
>  - fence any incoming ATS queries
> ...

> @@ -4885,10 +4919,20 @@ static int pci_reset_bus_function(struct pci_dev *dev, bool probe)
>  		return -ENOTTY;
>  	}
>  
> +	rc = pci_dev_reset_iommu_prepare(dev);
> +	if (rc) {
> +		pci_err(dev, "failed to stop IOMMU for a PCI reset: %d\n", rc);
> +		return rc;
> +	}

Unlike the other reset functions, this one calls
pci_dev_reset_iommu_prepare() even when probe==true, i.e., we don't
want to actually perform the reset, we just want to know whether the
reset method might work.

It's at least unnecessary to call pci_dev_reset_iommu_prepare() and
pci_dev_reset_iommu_done() in that case, and maybe even problematic
because the pci_init_reset_methods() probe happens from
pci_init_capabilities(), which is pretty early during PCI enumeration
of the device.

I know this has already been merged as f5b16b802174 ("PCI: Suspend
iommu function prior to resetting a device"), and I'm not sure whether
we should do anything about it.  I wonder if we should just skip the
prepare/done when probe==true?

>  	rc = pci_dev_reset_slot_function(dev, probe);
>  	if (rc != -ENOTTY)
> -		return rc;
> -	return pci_parent_bus_reset(dev, probe);
> +		goto done;
> +
> +	rc = pci_parent_bus_reset(dev, probe);
> +done:
> +	pci_dev_reset_iommu_done(dev);
> +	return rc;
>  }
