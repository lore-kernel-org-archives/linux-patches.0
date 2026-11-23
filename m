Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795442204;
	b=nHsgZCibnH14OPTB7YZH+mcyMdlVvBrqoFrZxDNFjlckaQ1z9mPkSusbS6otmgKTdadR
	 IuMVjnyoIwkBLW0p/DwQ5EzGX4t79gdRfyuOR3XKdcaiwMTwwbBOcF1IBEMcFtxw6cY5V
	 7MFFi/C2wfB1fchiTLnHV8G5fZdICLVEdXj26onYHzua0si93CghA5yaDwoM8ABOUEs/3
	 n3yzGkQZUnFRDndApWpJlVUM9uiIHeRzPW6UEAfxRlOto+g/XKrun0G68M3N1C3xiinFb
	 cCy+palGSGCTIcXN69MCu2aQeb+QhWn7c8jxrqYJmOypICn5Y/ekBkhZSQVJTBTFagA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795442204;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=YvJuJhFp5l2kJagzPQ2SnYyg6xkop1iejbQq4U7qdYc=;
	b=bH2vbH7Wof1GriRGy4hhtXQjx0avuEg/agOcK84LezT3fyCI3YQWL0pgBQS0kmbPHKf4
	 f2MSW69hG9tf2dR6Cm6n6THKpn+iRSP2eUmlwzC55oElIZ8MUMeeZUIJCVsYb13lXA4DA
	 XmsD/kaoIxXB9LNLQcFJCoFcs7n2VRNApnoV+Nx1kQvukpo4aeR0KIdXqKR+6febl3J/h
	 SMt8C3NdN4Ka/Nwee/HiH5fDvQ+yIPUvapt6MP/GsDUwEfd2DYMuOTM8g3gnd0QNZW0Qn
	 J6V/pCRm0K/Gu5uQfgscbU7bz8OzzKuWQikLkwwg7nFggTFBTAe6YOGg/uMPx4OzyxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eUBIT6ZK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1036C606A31F;
	Mon, 23 Nov 2026 13:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eUBIT6ZK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 993FB1F000D0;
	Mon, 23 Nov 2026 13:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795442203;
	bh=YvJuJhFp5l2kJagzPQ2SnYyg6xkop1iejbQq4U7qdYc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eUBIT6ZKbzq+Bc9lN79cX0NuNYT/6SfEdlBwvpzcUIY7OSqN21qmPUdmVBJX5KGP4
	 HasU6uQJJYARzZeImuxEd3H3OPBFWct3ME1vzMKYLmJj+j/7GOk91V0UiieaHPVujm
	 Z4J0GGf54gKjlkpyrfejJ2pYvy9U5yPljBqj1zm5opqk3IfbOD4SfaTCRp8VFCgbuV
	 Apmt1QapavcCY4qK/VBVFICq4PVNYuu7wgh+IPPL2ELiFGGfM05AoAYyWPQCB5JrGY
	 JV1cYVFnBTdPAYQGSOKQ0bzo9KDJ+hppLFp7MvYDRk7oGieN/9KBLWPZFDSJ960sHg
	 5rU5hQMu2VrQw==
Date: Mon, 23 Nov 2026 15:56:38 +0200
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
Message-ID: <20261123135638.GO14811@unreal>
References: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
 <2026112325-emit-squeezing-5d96@gregkh>
 <20261123090623.GK14811@unreal>
 <yq5a7bi3riha.fsf@kernel.org>
 <20261123115803.GN14811@unreal>
 <yq5awlq3pto0.fsf@kernel.org>
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
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <yq5awlq3pto0.fsf@kernel.org>

On Mon, Nov 23, 2026 at 06:54:31PM +0530, Aneesh Kumar K.V wrote:
> Leon Romanovsky <leon@kernel.org> writes:
> 
> > On Mon, Nov 23, 2026 at 03:13:13PM +0530, Aneesh Kumar K.V wrote:
> >> Leon Romanovsky <leon@kernel.org> writes:
> >> 
> >> > On Mon, Nov 23, 2026 at 09:40:55AM +0100, Greg Kroah-Hartman wrote:
> >> >> On Mon, Nov 23, 2026 at 02:03:27PM +0530, Aneesh Kumar K.V (Arm) wrote:
> >> >> > This series adds the PCI/TSM support needed by a TEE Security Manager
> >> >> > (TSM) driver in a confidential guest. It adds device lock/unlock,
> >> >> > helpers for recording device acceptance and parsing MMIO reports, and
> >> >> > DMA callbacks used during PCI driver attachment. The guest TSM driver and
> >> >> > attestation commands using these interfaces are in follow-up series.
> >> >> > 
> >> >> > This series is based on Dan Williams' "[PATCH v2 00/19] PCI/TSM: TEE I/O
> >> >> > infrastructure" posting [1], particularly the guest LOCK/UNLOCK, ACCEPT
> >> >> > and MMIO report work [2-4]. It retains device_cc_accepted() and the
> >> >> > confidential-device acceptance model from that posting, with changes
> >> >> > adapted to the current PCI/TSM structures and reference APIs. Dan's
> >> >> > device-core acceptance helper and per-host-bridge IDE stream reporting
> >> >> > patch are also included.
> >> >> > 
> >> >> > This series does not adopt the Device Trust changes from Dan's "Device
> >> >> > Evidence and Trust for PCI Security Protocol (TDISP)" [5]. That work is
> >> >> > being developed separately in Leon Romanovsky's "driver core: Authorize
> >> >> > device trust before driver binding" series, [6]. Confidential-device
> >> >> > acceptance is kept separate from that driver-binding trust policy.
> >> >> 
> >> >> But it should not, as you are making driver core changes that will
> >> >> mirror the same thing that that patchset is attempting to do.  Please
> >> >> work together on this.
> >> >
> >> > +10000000,
> >> >
> >> > Greg,
> >> >
> >> > This series came as a surprise to me given the fact that device trust
> >> > series is exactly for that - allow confidential computing.
> >> >
> >> > Adversarial is equal to the "cc_accepted".
> >> 
> >> I think the confusion stems from this thread:
> >> 
> >> https://lore.kernel.org/all/yq5amrr8yldi.fsf@kernel.org
> >> 
> >> Based on that discussion, I understood TRUST and eligibility for private
> >> DMA to be complementary attributes. Device acceptance determines whether
> >> a device may access private memory, while trust determines whether the
> >> core must enforce additional restrictions. I understood that supporting
> >> an accepted but adversarial device would require either a private IOTLB
> >> to restrict its access or an IOMMU.
> >
> > I reached a completely different conclusion from that discussion.
> >
> > Device trust does little beyond preventing driver binding and recording the
> > trust decision in "struct device". The missing piece, which I would expect
> > you to address, is ensuring that the IOMMU and private DMA are configured
> > only after the trust level has been decided or as part of that decision,
> > rather than beforehand, as they are today.
> >
> 
> 
> I agree that the trust decision must precede DMA configuration and
> driver probe. My integration tree shared in the cover letter already
> includes your trust framework, with PCI/TSM DMA setup following that
> decision.
> 
> What I am still trying to understand is how you view the DMA allocation
> and mapping paths determining whether a device can access private
> memory. Paths such as force_dma_unencrypted() and SWIOTLB receive a
> struct device pointer and need to decide whether to use private memory
> or shared buffers.

After the IOMMU cleanup, I expect we’ll be able to create a cyclic
trust-level state machine that lets us reset the trust level when a
driver is unbound. We can then add internal states to the trust-level
FSM, which DMA/SWIOTLB can check.

In theory, we could make this final improvement before the IOMMU cleanup.
However, the risk of creating a mess is higher than if we follow a
straightforward, sequential engineering approach.

Thanks

> 
> We could move cc_accepted into struct pci_tsm_devsec, outside driver
> core. How would you expect the generic DMA code to obtain that
> information? Adding another flag to struct device would effectively
> recreate the state we are trying to remove.
> 
> This goes back to my question here:
> https://lore.kernel.org/all/yq5amrr8yldi.fsf@kernel.org/
> 
> If we remove device_cc_accepted(), what should those callers use
> instead? How do you see your trust framework supporting that decision?
> 
> -aneesh
> 
> 
