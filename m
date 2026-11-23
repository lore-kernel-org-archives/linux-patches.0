Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795440281;
	b=kYVUsq7h/196KNz2xNKeQSxWTAd78R/A3PsePCW0FJVddKkJ+MXW3py8tVXUHVkKMcdt
	 VZPC4e6xg3W3GtE6xVHIyE6yNWJsJA5papZ0A87is7x9SaoOVtDcZ16FzuXJqcjV0kSnp
	 aQzxe9LpoWgjK7PwRa2Wl130gtCt6bRC8ydw4cxlgRvD/ocR14mgpun/ImCnAAoVaMUO/
	 qAVEuh7cs8lx2CoCMGkUqhM3O2ZjbSmr52mZ9uGwI7d0Lvj7DONBMToQqFn0h6nGV98R6
	 oXtlYFDCGELCyXFlVZYlvE2DJGm3IIM6zyxk1jo5ryut+fAR24EavVaZfC0/NC+zrlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795440281;
	h=Received:DKIM-Signature:X-Mailer:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:MIME-Version:Content-Type;
	bh=jLv9CLcIu1QdSA1kmYNp8Rb0YGi/d/JwNxve0vmO/sU=;
	b=cDHvuXiMJWiEo92c7yzgitiTiqgWh+GQRR4Bgx8ix3pBc83Jds+eCbN96uc7QFiluU2i
	 MTlEQZ6E+YXWZTruzb9jhtGP8IS1t6z26+Bt2KftpTZi+pzKqenhYJqkZkHe6PBtKtq19
	 EoCdQBg4hy26y8Z2g4YTY7SHTk3Q9p55t0gOCAaJMGnyPg7B+53XgvjoSBj9yP0ZbNljN
	 oeuw0OCYQ4u2TbdHH7pWiz8yqas+aMQloSn/MNH+i8hjFxCwkNz8N5iZT/MWJ5qYIVUSh
	 k+RFE8ohdsxd8eNETCHaQL68CZR/o1D5U7Gj93Vu+q2NGhhWHISK/FKY4tAU3Ro8fug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iaAgsD65;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4337606A31F;
	Mon, 23 Nov 2026 13:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iaAgsD65
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1536A1F000C4;
	Mon, 23 Nov 2026 13:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795440281;
	bh=jLv9CLcIu1QdSA1kmYNp8Rb0YGi/d/JwNxve0vmO/sU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=iaAgsD653MyS8Dnstwa+FbDv4hWrojjI4EITadwmhB+lk0rlHlPSgISzz4VZXsj0B
	 aUBYSS1Fd3kB8+FB8eFw0ca2BEFoI+FUA1TVrSE4ovO4V7n8YEuBOwKsdObHNKOjVe
	 zdyfy41Uvq3BsBBtQ8gAOQ9Ro02DLpQkEzyy9gixsfnqGmQEcNU3AuZK2/FqCeuoQf
	 Tn+6pTYDNXo5Ednau3nWFteuMPi6jgmv23qOKdW9AsencEo5EQ2oCvrw1mFv4+JYkC
	 e6l3DoY4td/NLn9orESZtZey6ebiOcaV2GyJGyGHiZzZWjVO4Ks8z6P14k7EN4dCgo
	 9wCiGLStuvCrw==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-coco@lists.linux.dev, Dan Williams <djbw@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Lukas Wunner <lukas@wunner.de>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	driver-core@lists.linux.dev, linux-pci@vger.kernel.org,
	kvm@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v1 00/10] PCI/TSM: Support guest TSM drivers
In-Reply-To: <20261123115803.GN14811@unreal>
References: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
 <2026112325-emit-squeezing-5d96@gregkh> <20261123090623.GK14811@unreal>
 <yq5a7bi3riha.fsf@kernel.org> <20261123115803.GN14811@unreal>
Date: Mon, 23 Nov 2026 18:54:31 +0530
Message-ID: <yq5awlq3pto0.fsf@kernel.org>
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

Leon Romanovsky <leon@kernel.org> writes:

> On Mon, Nov 23, 2026 at 03:13:13PM +0530, Aneesh Kumar K.V wrote:
>> Leon Romanovsky <leon@kernel.org> writes:
>> 
>> > On Mon, Nov 23, 2026 at 09:40:55AM +0100, Greg Kroah-Hartman wrote:
>> >> On Mon, Nov 23, 2026 at 02:03:27PM +0530, Aneesh Kumar K.V (Arm) wrote:
>> >> > This series adds the PCI/TSM support needed by a TEE Security Manager
>> >> > (TSM) driver in a confidential guest. It adds device lock/unlock,
>> >> > helpers for recording device acceptance and parsing MMIO reports, and
>> >> > DMA callbacks used during PCI driver attachment. The guest TSM driver and
>> >> > attestation commands using these interfaces are in follow-up series.
>> >> > 
>> >> > This series is based on Dan Williams' "[PATCH v2 00/19] PCI/TSM: TEE I/O
>> >> > infrastructure" posting [1], particularly the guest LOCK/UNLOCK, ACCEPT
>> >> > and MMIO report work [2-4]. It retains device_cc_accepted() and the
>> >> > confidential-device acceptance model from that posting, with changes
>> >> > adapted to the current PCI/TSM structures and reference APIs. Dan's
>> >> > device-core acceptance helper and per-host-bridge IDE stream reporting
>> >> > patch are also included.
>> >> > 
>> >> > This series does not adopt the Device Trust changes from Dan's "Device
>> >> > Evidence and Trust for PCI Security Protocol (TDISP)" [5]. That work is
>> >> > being developed separately in Leon Romanovsky's "driver core: Authorize
>> >> > device trust before driver binding" series, [6]. Confidential-device
>> >> > acceptance is kept separate from that driver-binding trust policy.
>> >> 
>> >> But it should not, as you are making driver core changes that will
>> >> mirror the same thing that that patchset is attempting to do.  Please
>> >> work together on this.
>> >
>> > +10000000,
>> >
>> > Greg,
>> >
>> > This series came as a surprise to me given the fact that device trust
>> > series is exactly for that - allow confidential computing.
>> >
>> > Adversarial is equal to the "cc_accepted".
>> 
>> I think the confusion stems from this thread:
>> 
>> https://lore.kernel.org/all/yq5amrr8yldi.fsf@kernel.org
>> 
>> Based on that discussion, I understood TRUST and eligibility for private
>> DMA to be complementary attributes. Device acceptance determines whether
>> a device may access private memory, while trust determines whether the
>> core must enforce additional restrictions. I understood that supporting
>> an accepted but adversarial device would require either a private IOTLB
>> to restrict its access or an IOMMU.
>
> I reached a completely different conclusion from that discussion.
>
> Device trust does little beyond preventing driver binding and recording the
> trust decision in "struct device". The missing piece, which I would expect
> you to address, is ensuring that the IOMMU and private DMA are configured
> only after the trust level has been decided or as part of that decision,
> rather than beforehand, as they are today.
>


I agree that the trust decision must precede DMA configuration and
driver probe. My integration tree shared in the cover letter already
includes your trust framework, with PCI/TSM DMA setup following that
decision.

What I am still trying to understand is how you view the DMA allocation
and mapping paths determining whether a device can access private
memory. Paths such as force_dma_unencrypted() and SWIOTLB receive a
struct device pointer and need to decide whether to use private memory
or shared buffers.

We could move cc_accepted into struct pci_tsm_devsec, outside driver
core. How would you expect the generic DMA code to obtain that
information? Adding another flag to struct device would effectively
recreate the state we are trying to remove.

This goes back to my question here:
https://lore.kernel.org/all/yq5amrr8yldi.fsf@kernel.org/

If we remove device_cc_accepted(), what should those callers use
instead? How do you see your trust framework supporting that decision?

-aneesh

