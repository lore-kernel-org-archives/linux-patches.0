Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795427002;
	b=kme8u+pXqDfXKsR/+0ndLb8bet+v1MgQtAvIamL748LoU0VETaPln45INkkxqbK2CjYL
	 ktptDwv8XOwzcjRTcAgh1Pdqu9mZqhzu2NaUc3pdAgtM9tMjXxWVbKEOQW7iAaqPecirc
	 6Oyk5BSHP8TjU5oFYt3/zsSMRBHsgh6UUtG0dSUch2ks7pEwMBIulXkm3iMYpQHRb3oNt
	 mCadP7LSp5TtwmkYQj85NGqZkKfMhr9z1zf2peaz7P0bwKQNcZrivssxPSzN+ijFAZpTs
	 FwBIsFynUEU4k4L1XsZUxkd9IVlINf8fPWnTaz5mNsDREKkWQab9JjWfx26y+BBdUiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795427002;
	h=Received:DKIM-Signature:X-Mailer:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:MIME-Version:Content-Type;
	bh=ovTZpuEFEoWoBniAauFNolmkozpPhbGaZO8n0GhWEtw=;
	b=l1zpcriE/T38qTfvruvXA8v8FqBONOxtRa7Vl5m8pbfZrVvCqLptgmaZB94+YW8mpp/g
	 D4PfluwYYz581Jzd7EvS6ZdW5ZXoIDIeZ8ZQ+hhnBgRnwFjffecqeLtl8ton5wi7XvK8E
	 dm4L9oVGg2C0of27vMHcrr4vohOE8QR47EVBJPHrCgxX9Sag14/gg3k4YSn3FJ2k/+KmC
	 3SLnxsUFPfXt1YkaGvH7gqSBD5YZVzb6MA617u4AdCpwQFZh80hRvuBZyfW9f1poin85a
	 WFWC8F/OjkdLwBnBMbnuaGOB1Aww2tUFj3VKJlY+gJYeMHSk1+V3Fo5XJW1PB6p/Cnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=orv0xpNT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58B2606A31A;
	Mon, 23 Nov 2026 09:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=orv0xpNT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FFB21F000D0;
	Mon, 23 Nov 2026 09:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795427002;
	bh=ovTZpuEFEoWoBniAauFNolmkozpPhbGaZO8n0GhWEtw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=orv0xpNTXOq+Hp2bUGf2xot20ap+p8J9/WaqyVRXto96awU4Yf/gQHFGtkG2rKN/l
	 QXNxbcpqxfpeV70kidCicmpZ4CwNXlXbGAzxj8dUMM8Mk1BRBmeqIqjCHlC8kuVaWh
	 wuLb3ZSEH0gv69+b2Ae/+lnpWTpqk53dHAiYAkAIeJvqsNsQjZRwdRXjHIQBAlcxJf
	 5+tKU0Wxwe4Uh7Y0jbOJdbvx7WssEGSiGZxxutLlpq5q0o2K//pKtKz/M80jRHEccF
	 +ycfRBr08AO3EYKHdeAJgggQ+sgnf4g9NaFcWMaCwglHb8nA2Y50liAZ+djH7DRR4O
	 dl1cyWBw42D0g==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Leon Romanovsky <leon@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-coco@lists.linux.dev, Dan Williams <djbw@kernel.org>,
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
In-Reply-To: <20261123090623.GK14811@unreal>
References: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
 <2026112325-emit-squeezing-5d96@gregkh> <20261123090623.GK14811@unreal>
Date: Mon, 23 Nov 2026 15:13:13 +0530
Message-ID: <yq5a7bi3riha.fsf@kernel.org>
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

> On Mon, Nov 23, 2026 at 09:40:55AM +0100, Greg Kroah-Hartman wrote:
>> On Mon, Nov 23, 2026 at 02:03:27PM +0530, Aneesh Kumar K.V (Arm) wrote:
>> > This series adds the PCI/TSM support needed by a TEE Security Manager
>> > (TSM) driver in a confidential guest. It adds device lock/unlock,
>> > helpers for recording device acceptance and parsing MMIO reports, and
>> > DMA callbacks used during PCI driver attachment. The guest TSM driver and
>> > attestation commands using these interfaces are in follow-up series.
>> > 
>> > This series is based on Dan Williams' "[PATCH v2 00/19] PCI/TSM: TEE I/O
>> > infrastructure" posting [1], particularly the guest LOCK/UNLOCK, ACCEPT
>> > and MMIO report work [2-4]. It retains device_cc_accepted() and the
>> > confidential-device acceptance model from that posting, with changes
>> > adapted to the current PCI/TSM structures and reference APIs. Dan's
>> > device-core acceptance helper and per-host-bridge IDE stream reporting
>> > patch are also included.
>> > 
>> > This series does not adopt the Device Trust changes from Dan's "Device
>> > Evidence and Trust for PCI Security Protocol (TDISP)" [5]. That work is
>> > being developed separately in Leon Romanovsky's "driver core: Authorize
>> > device trust before driver binding" series, [6]. Confidential-device
>> > acceptance is kept separate from that driver-binding trust policy.
>> 
>> But it should not, as you are making driver core changes that will
>> mirror the same thing that that patchset is attempting to do.  Please
>> work together on this.
>
> +10000000,
>
> Greg,
>
> This series came as a surprise to me given the fact that device trust
> series is exactly for that - allow confidential computing.
>
> Adversarial is equal to the "cc_accepted".

I think the confusion stems from this thread:

https://lore.kernel.org/all/yq5amrr8yldi.fsf@kernel.org

Based on that discussion, I understood TRUST and eligibility for private
DMA to be complementary attributes. Device acceptance determines whether
a device may access private memory, while trust determines whether the
core must enforce additional restrictions. I understood that supporting
an accepted but adversarial device would require either a private IOTLB
to restrict its access or an IOMMU.

Therefore, with this series, a request to enable private memory DMA is
handled as follows:

	if (!device_cc_accepted(&pdev->dev)) {
		ret = -EACCES;
		goto out;
	}

	/* Adversarial devices are unsupported for confidential DMA. */
	if (device_is_adversarial(&pdev->dev)) {
		ret = -EOPNOTSUPP;
		goto out;
	}


-aneesh
