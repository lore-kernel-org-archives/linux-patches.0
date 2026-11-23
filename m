Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795450876;
	b=b3clZJ6Eq1msB7AFl3lXeiTsTPobYG+MGguVYhEzfJYIKFIqHAAhaIgwyMy7/GoEroxR
	 RbO4fu8JAYZVDF8s5jjENhz71hPWI/J4bwZUJyo/IvZZj51Hs+IHYUI0Mhpl315172JPw
	 30/MyCX1QCdEbG34NVLymh77MoRT4Wzu8ubfe5kMVBLKn011ECkCxU8cXV1ereknl2VQV
	 9Wyz2zExobHP7j5Isa6P8fXCPiqUO8P9MtwBd3cyja8yz0RONZkE7nLfI33cJuAnVECeh
	 kXD4npFyirl0ZNgcKYzhH6awXVb+3W8wHn57ZPDWXbITQyJkDA8aMgX2UBfJL3dYoKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795450876;
	h=Received:DKIM-Signature:X-Mailer:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:MIME-Version:Content-Type;
	bh=INOa4kV3oG92y+8V9TagV8Pu1IayJqy+GVQ0Gn3qaGU=;
	b=IyWuWCZd4KH6cbEjBvfMZUAxqI5vo6cYuyBKtoQEeI/GYrcUZL0SjGxoTXGVkvzAi70j
	 DcJMW/B8feZCKO0/iIC8Wx0oX/rgYFSu2LtDTVb62BV7zx65ZMLI/LEEKX7WsqifZw1bu
	 C5qiKWvUdgR9dzsojxMlYsEBAe8SzRPXS0mwDPsx73WQrrwLGNfFtH0ErWsKNolvLmsh2
	 5tlDbOQUjyYWOW1etoKtwG/WHGctLf2DSva/3P1Aj76hmxnhSKYT0T6NbeXXq7yqKVYED
	 mTH9xWSt9qeYMb7sGZBGO4Y3k7yRIU7ngsEez2v5YLbjmITFyoSlI0FRlTRMESjt5qg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HBJ9VHSW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9C6606A334;
	Mon, 23 Nov 2026 16:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HBJ9VHSW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C8CB1F000CA;
	Mon, 23 Nov 2026 16:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795450875;
	bh=INOa4kV3oG92y+8V9TagV8Pu1IayJqy+GVQ0Gn3qaGU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=HBJ9VHSWa5FJ88g6/jfPijZU6l1xJoOy4ReuonJZNMf10mQKZaZAyxKhmD0Z5KzVD
	 OlaE6/ZqU5PUJBYufl1CrrFrxmoLVvF2tKxkE6KjNtCzsawwejBQSKui20ma2cbQfx
	 /Rr5ZOIfCpjGmDTJIC8ymePf2JPORNDV3ptobGw4mAKVwU/0zgfEPVhdap6GQbzCQe
	 EycC30XaetDia+bbLaXR/VBmxRh4RV1sDIPTXsgDzy9eczijCH9pOT0u6X2ZuuR/uP
	 /CCuHiU3uOVN5Z8xKCz1MsiPK7oINS5hEOjMD3IyA+rijpWRRLZaMOUYF+bTa6F63Z
	 8HdBH64Mg7Naw==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	Nicolin Chen <nicolinc@nvidia.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-coco@lists.linux.dev, Dan Williams <djbw@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
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
In-Reply-To: <20261123152533.GE179082@ziepe.ca>
References: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
 <2026112325-emit-squeezing-5d96@gregkh> <20261123090623.GK14811@unreal>
 <yq5a7bi3riha.fsf@kernel.org> <20261123115803.GN14811@unreal>
 <yq5awlq3pto0.fsf@kernel.org> <20261123135638.GO14811@unreal>
 <20261123152533.GE179082@ziepe.ca>
Date: Mon, 23 Nov 2026 21:51:04 +0530
Message-ID: <yq5aik1n4iz3.fsf@kernel.org>
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

Jason Gunthorpe <jgg@ziepe.ca> writes:

> On Mon, Nov 23, 2026 at 03:56:38PM +0200, Leon Romanovsky wrote:
>> > >> >> But it should not, as you are making driver core changes that will
>> > >> >> mirror the same thing that that patchset is attempting to do.  Please
>> > >> >> work together on this.
>> > >> >
>> > >> > +10000000,
>> > >> >
>> > >> > Greg,
>> > >> >
>> > >> > This series came as a surprise to me given the fact that device trust
>> > >> > series is exactly for that - allow confidential computing.
>
> Device trust's primary role in enabling confidential computing is to
> give space for the userspace to do all the TSM and attestation stuff
> to get the device into T=1 private DMA mode.
>
> It is the userspace that does all this and the userspace bridges from
> "I got the device into T=1 mode" to "Now it meets my userspace policy
> to be trust level Full" and then finally "Now I can bind and start a
> driver"
>
> The two concepts work together, but they are not linked inside the
> kernel.
>
>> > >> > Adversarial is equal to the "cc_accepted".
>
> I expect most policies would make "cc_accepted" as a full trust level,
> but we do want to allow adversarial as an option too.
>
>> > >> I think the confusion stems from this thread:
>> > >> 
>> > >> https://lore.kernel.org/all/yq5amrr8yldi.fsf@kernel.org
>> > >> 
>> > >> Based on that discussion, I understood TRUST and eligibility for private
>> > >> DMA to be complementary attributes. Device acceptance determines whether
>> > >> a device may access private memory, while trust determines whether the
>> > >> core must enforce additional restrictions. 
>
> Yes.
>
>> > > Device trust does little beyond preventing driver binding and recording the
>> > > trust decision in "struct device". The missing piece, which I would expect
>> > > you to address, is ensuring that the IOMMU and private DMA are configured
>> > > only after the trust level has been decided or as part of that decision,
>> > > rather than beforehand, as they are today.
>
> They are orthogonal and unrelated.
>
> All the TDISP and T=1 DMA flow is about how the DMA API works and has
> no direct impact on trust level. You can choose any trust level for a
> device using T=1 DMA.
>
> Getting the device into T=1 should influence how the userspace decides
> to set the trust level, but it doesn't interact inside the kernel.
>
> Aneesh has it right that these are orthogonal and unrelated
> activities. There may be some confusion as Dan attempted to couple
> them, but after discussion we have moved away from that since it
> doesn't meet all the use cases.
>
>> > What I am still trying to understand is how you view the DMA allocation
>> > and mapping paths determining whether a device can access private
>> > memory. Paths such as force_dma_unencrypted() and SWIOTLB receive a
>> > struct device pointer and need to decide whether to use private memory
>> > or shared buffers.
>
> It is Nicolin's work here that needs to go before the TSM drivers:
>
> https://lore.kernel.org/all/cover.1794343501.git.nicolinc@nvidia.com/
>


This adds

index 429e39f647cf9..01d7877d0b571 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -604,6 +604,8 @@ struct device_physical_location {
  *		ancestor device.
  * @DEV_FLAG_OFFLINE_DISABLED: If set, the device is permanently online.
  * @DEV_FLAG_OFFLINE: Set after successful invocation of bus type's .offline().
+ * @DEV_FLAG_DMA_CC_PRIVATE: The device is able to access private (encrypted)
+ *		memory, no shared memory bouncing is required from the DMA API.
  * @DEV_FLAG_COUNT: Number of defined struct_device_flags.
  */
 enum struct_device_flags {
@@ -617,6 +619,7 @@ enum struct_device_flags {
 	DEV_FLAG_OF_NODE_REUSED = 7,
 	DEV_FLAG_OFFLINE_DISABLED = 8,
 	DEV_FLAG_OFFLINE = 9,
+	DEV_FLAG_DMA_CC_PRIVATE = 10,
 
 	DEV_FLAG_COUNT
 };

...

+void dma_set_cc_private(struct device *dev, bool private)
+{
+	dev_assign_dma_cc_private(dev, private);
+}

This could easily replace device_cc_accept()/device_cc_accepted() used
in this series. I can switch to it if that's the direction we want to
take.

-aneesh
