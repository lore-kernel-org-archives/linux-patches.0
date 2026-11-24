Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795510835;
	b=B+laAPsnlz6TQeDC/o0tzAZOcmJ3tiodypPT6Min9ni4uMIXd+Qp9Vqvm/6xvuSZZ/mn
	 Q/RRotgU1gKbPVRCLRICCicapb/Z23j5nz720D6Cky0+yQaoKMSVPJrWPxNEZ5xvvRU5R
	 1MQeJBMhNvFLwooxwtfISKWWe9vjTjmHZSukDmAVRAVvClVnzqs4F7s/FWWWp2GaVdeJr
	 sBKB/0TydcpSjlSsSw0/ff0U9otvS0/C6NIpcf/GLtfWqS4woE+sUkTGoLALkpqiPI+Hb
	 HkqnyUhWI293DvZyulFAgaP66d4CtCSF+xKSUY8oHHA23+OUos1wMYbg/bYKkABTA0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795510835;
	h=Received:DKIM-Signature:X-Mailer:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=Qt6UQLCPSMtUGw2PneN+8G6f4t6FF/Je5nAGO6KM+ck=;
	b=Rp23XS5QIMUySjNIwpio6Khp64J9G0pSX2WPHM8bM2dq/H+wMAm7i3/B16EE64RfZoA5
	 GT0/DJQfQRIeCa91/AIQUF07wDwAkI8S+fn6+4kIGTAaV9tnIHVeB3cAlLQHJ0F4uBnGO
	 OKkhBCY6hyT10Cmh3AmEW+3TKSBdaydyQeDhhmlMgqgYxSdJ4aisaycOzu2csQXTjU5VA
	 yJ3E0lvFRxb9fVMtevkGGbEWM+N5PYv+6PraRILTpOGsI7eg7Di41qCPv5jtDmagjrMaq
	 n54p85XaIejBY0cl2LwzXrG4fkv3znUDJwAGsr9/LESgQbBE4lNxDV/7oVpw6l56Aaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cq5YppoE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C797B606A31E;
	Tue, 24 Nov 2026 09:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cq5YppoE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D148B1F000C0;
	Tue, 24 Nov 2026 09:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795510835;
	bh=Qt6UQLCPSMtUGw2PneN+8G6f4t6FF/Je5nAGO6KM+ck=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=cq5YppoE2RGMHDASP9dR2GuHpLApTRS7/GhRuCKIn+m8wGrOIcwyVw/qq0Il/AHih
	 chw96NsdWgfampEF6cppz6ZTvnll8YtGh91OtPE/abs6GyptrLnay9kviweTzbWZg8
	 ban3OG6fhIKF4+XR3VONkCjXzMp/XMLnzBX4iKbkHtbGL0z25XvOSAsiHpy7E4myc9
	 6HmN90IsKX+DeGX8dhINNHm4Y+o2eNKkxI82SQb/uEMAj0NI0docLn0F0lX8iBeooD
	 xlPoI87U9EQyFa9isi/dsrUUx84N8xmmqGmxaYKJ1aGg3SO2e+/fqY2IAXXaNdkS/G
	 FIeEs0/cNvpPg==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Jianxiong Gao <jxgao@google.com>
Cc: linux-coco@lists.linux.dev, Dan Williams <djbw@kernel.org>,
	Leon Romanovsky <leon@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Lukas Wunner <lukas@wunner.de>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	driver-core@lists.linux.dev, linux-pci@vger.kernel.org,
	kvm@vger.kernel.org, patches@lists.linux.dev,
	Zhichuang Sun <zhichuang@google.com>,
	Piranava Tamilselvan <piranavat@google.com>,
	Erdem Aktas <erdemaktas@google.com>,
	Ackerley Tng <ackerleytng@google.com>
Subject: Re: [PATCH v1 10/10] PCI/TSM: Configure accepted device DMA during
 driver attachment
In-Reply-To: <CAMGD6P0pNAnq9U80dnpgbz+hHbX1yH1bdmXjcie4oiq7KizU=A@mail.gmail.com>
References: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
 <20261123083337.2731019-11-aneesh.kumar@kernel.org>
 <CAMGD6P0pNAnq9U80dnpgbz+hHbX1yH1bdmXjcie4oiq7KizU=A@mail.gmail.com>
Date: Tue, 24 Nov 2026 14:30:25 +0530
Message-ID: <yq5aeccabo46.fsf@kernel.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Jianxiong Gao <jxgao@google.com> writes:

> On Mon, Nov 23, 2026 at 02:03:37PM +0530, Aneesh Kumar K.V (Arm) wrote:
>> + /* driver_managed_dma is unsupported. */
>> + if (to_pci_driver(pdev->dev.driver)->driver_managed_dma) {
>> + ret =3D -EOPNOTSUPP;
>> + goto out;
>> + }
>
> Hi Aneesh,
> A short clarification question on this check: once a guest TSM driver
> implements dma_enable, pci_tsm_dma_prepare() will reject binding
> vfio-pci (and other driver_managed_dma drivers like pci-stub) with
> -EOPNOTSUPP on both locked and accepted TDIs.
> Is rejecting driver_managed_dma just a scope limit for this series, or
> the intended long-term policy?
>

Wouldn't that require an IOMMU to be available inside the guest? The
current implementation uses dma-direct, and I haven't yet looked into
private memory access through a stage-1 IOMMU.

That check was added because I have not yet investigated what is needed
to support drivers such as vfio-pci inside the guest.


> If it's a scope limit, is the expected
> direction for in-guest vfio-pci to enable private DMA when it claims DMA
> ownership / attaches an IOMMU domain (via iommufd or vfio_iommu_type1),
> rather than during pci_dma_configure()?
> We run a userspace accelerator driver over vfio-pci inside a confidential
> guest on an accepted TDI (similar in model to DPDK/SPDK), so knowing the
> planned direction for driver_managed_dma =E2=80=94 and whether any upstre=
am work
> is planned for in-guest vfio-pci support on TDIs =E2=80=94 would really h=
elp us
> plan.


I have not yet looked into this enough to comment on how it should be
implemented. I will follow up later.

-aneesh
