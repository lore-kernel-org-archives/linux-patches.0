Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795492998;
	b=VfqjAhu/8z4Q/VbuwXzWVu/+m9+g4fwzHeWtoTKp0LC/4YEagDH8athkppr3YVTui9il
	 G/nCHOfMZ6uckrXuSfnPFepwiYAHQqGdYTdqPrWbFPZqu9H1iz3VHtPHVKOA0akx/IpL7
	 8gImO9JSYf5kWwIb8RK2UYwZmx2mxmdO5XBkACDX+eUwFW6KagUb/M0KwXLIh9pbihUUM
	 jUYNf+5smcjviBLN0pcIxddJK0J8CFoQmVtrpEgmcg6n6dPiYCHkXWgtcA5Dx/PvSwByT
	 HeWlGwFsOFIWK7q2r3o32inNH/NhS8q2TNZuY1f8N4PAT8+NJheSNsz73+/XFnEsBYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795492998;
	h=Received:DKIM-Signature:X-Mailer:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:MIME-Version:Content-Type;
	bh=0uolOVqD40xxzEqeWG55ZDWSlt7NaVVPmj6fMxUPPhA=;
	b=ONIrdnf/G72rg1pH88slOJ8u5ACgVC8w+2DOf9IY0Cu89QwyVHvQyE1Oafnz3EMwwCX+
	 vg0q+v4voMxW/Xy9HbRqjrYDtYwJmdYftun1t8GNiu8pjYCeL/jTtwV6Mj6j+bbdxC9MJ
	 CWrkxvzERWai47tLeRPrZLZVnOJypCNS4nqcyzLcauq/PrkxVc/TbTbOQUyj4cAb/0nzu
	 dEYUNsJtwPNkkA1fkncJcoKzS2Ppwl/HFIftnuuN3Emo4EHCFy6TAqZ6+8nQmcJe1pA2p
	 HocdBq8WWLNZzzi0Hk3nCPLm9Izo25THiGAWIkSwL2X87rxqu4U6BRrUazNip8Tc1ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dUBfTU2b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17EFF606A31E;
	Tue, 24 Nov 2026 04:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dUBfTU2b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B5A81F000D0;
	Tue, 24 Nov 2026 04:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795492997;
	bh=0uolOVqD40xxzEqeWG55ZDWSlt7NaVVPmj6fMxUPPhA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=dUBfTU2bZcriHyCyznmH+wtA4cnOoSaG8LaH1IiDJmFTGiErgOff/JaXdhZtcKNpR
	 QVrWCpJegIFq7g/12U5wBrAGd+26SB9CbXYXNjEJddRYB/CEBLMRRSly+b67LsJFLa
	 vH6tqLGB05fpyjzFuvcVfpD1qP1GdWX8X991h3E88f19Nm/bD3flaoI5G3ei9yJp78
	 glKx0hXlkIKU7OobyUcTjw/wXDd5+EnqSvZQyJBYQ55CZJDfqAwbDsksWrIu7/TPu5
	 J0l8jFnsHmTZuwZsGnBw/hhNHfDY31+c6PfotH7V5Kytit6yI755loWgbMEnvqOReH
	 o7scafsqHqvow==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Baolu Lu <baolu.lu@linux.intel.com>, linux-coco@lists.linux.dev
Cc: baolu.lu@linux.intel.com, Alex Williamson <alex@shazbot.org>,
	Alexey Kardashevskiy <aik@amd.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Krishna Reddy <vdumpa@nvidia.com>,
	Lukas Wunner <lukas@wunner.de>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Samuel Ortiz <sameo@rivosinc.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Steven Price <steven.price@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Will Deacon <will@kernel.org>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	iommu@lists.linux.dev,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org,
	linux-tegra@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v9 08/13] PCI/TSM: Keep connections active while device
 contexts exist
In-Reply-To: <0996eead-a63e-4a17-96d3-45ccd48cd4b1@linux.intel.com>
References: <20261116081935.85372-1-aneesh.kumar@kernel.org>
 <20261116081935.85372-9-aneesh.kumar@kernel.org>
 <0996eead-a63e-4a17-96d3-45ccd48cd4b1@linux.intel.com>
Date: Tue, 24 Nov 2026 09:33:02 +0530
Message-ID: <yq5awlq2c1vt.fsf@kernel.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

Baolu Lu <baolu.lu@linux.intel.com> writes:

> On 11/16/2026 4:19 PM, Aneesh Kumar K.V (Arm) wrote:
>> Add PCI TEE Security Manager (TSM) contexts that prevent PF0 disconnect
>> while in use. Verify that the device is connected to the requested TSM.
>> Each successful get returns a separate context and requires a matching
>> put. Reject disconnect with -EBUSY until all contexts are released.
>> 
>> Remove the legacy bind and unbind interface. Device security state is
>> managed by the backend, so also remove the associated "bound" sysfs
>> attribute and its ABI documentation.
>
> This patch does two things: add pci tsm contexts to keep the pf0 active
> while in use, and remove the old device bind/unbind interface. Could
> these changes be split into separate patches? That would make the
> changes easier to review.
>

Sure, I will split the bind/unbind removal into a separate patch.

-aneesh
