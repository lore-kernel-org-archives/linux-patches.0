Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795502647;
	b=EWtKjhZ/hfsoxDacHfgqYvLf1erGJKLw7yBgqArClyWBKo3M6ViVOV0xrv9N/rSVVREo
	 O2TkvD5uUWC6TzjFaFonGmYsvgVlIvfctZLu6sx7VyCDUeY7xfpE376GTZqazqkb14Jt1
	 mLrkAasNIfEHfap/q2uSiyD1IjI9XMgW/eMzXdoB4dx952NH1SPiPhFboFqfDBoIZ8YSY
	 9LPMQjXJtjw6zAbEWWKga24l6osWEN/HGCWuqF7gXxCkBYjGq18MDrY5lOXqPYS5ApO90
	 12al3Gs+kiSbPfOJAKIUAyNwo2uAYu1b4Y8Zt37ik3m67Sa50AeG2aHZB2ATgyLeTpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795502647;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=f4D9nzAQs8JOljc1HKpN79I++6boE/LG2zcA3JJ7t6I=;
	b=ZT+8FFTjaX5FMUiRt1I1e0pxSlmC+cqctv+fcJ2yiAdH2TFN1Eci0Us3EpAUanHNuNnZ
	 y67rB2/Z2yp+9I13Hnd7KjL9DL6iOmbh5LIAYfBfu6z4HGfcvn607/oY8d4mj+xzhmbwE
	 WmkC+J/A3Npw9Hp8XgI6io1QR5/5Ii0wcTA/1j8Dhv1waBIUDObVPWvWkMoaakaalqFa+
	 LS9bAkZCo9xp1rkgSVS07aKNsE4mpVnbqI899MBfTVRGsLYYtVATWaz4zorSim4IRi/eW
	 ieUI3vkTvhS6QFvkHKQBmlJzNWeu/0qMy5TjchrqH5IK8zViv9KId2eEUsLbncj73Nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=swlRVAES;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 451AC606A31E;
	Tue, 24 Nov 2026 06:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=swlRVAES
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A83B1F000C4;
	Tue, 24 Nov 2026 06:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795502646;
	bh=f4D9nzAQs8JOljc1HKpN79I++6boE/LG2zcA3JJ7t6I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=swlRVAES1lf+TbopEIgCYz7MevC0eym2gj5HfNJVcbLZUN2SQJeWBdTK/9a0ypMmZ
	 7FPapsbW3v+AvfTDgwJEqJrFVcylpTVlObq6e6/sfbLUSMQP77c/oNELPMj0tgXh1N
	 zPMwti6babKk5h8Bew0osty7GQj1zb60G+T4+5H8=
Date: Tue, 24 Nov 2026 07:44:03 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	Nicolin Chen <nicolinc@nvidia.com>, linux-coco@lists.linux.dev,
	Dan Williams <djbw@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
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
Message-ID: <2026112429-expansion-wilder-a0c2@gregkh>
References: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
 <2026112325-emit-squeezing-5d96@gregkh>
 <20261123090623.GK14811@unreal>
 <yq5a7bi3riha.fsf@kernel.org>
 <20261123115803.GN14811@unreal>
 <yq5awlq3pto0.fsf@kernel.org>
 <20261123135638.GO14811@unreal>
 <20261123152533.GE179082@ziepe.ca>
 <yq5aik1n4iz3.fsf@kernel.org>
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
In-Reply-To: <yq5aik1n4iz3.fsf@kernel.org>

On Mon, Nov 23, 2026 at 09:51:04PM +0530, Aneesh Kumar K.V wrote:
> Jason Gunthorpe <jgg@ziepe.ca> writes:
> 
> > On Mon, Nov 23, 2026 at 03:56:38PM +0200, Leon Romanovsky wrote:
> >> > >> >> But it should not, as you are making driver core changes that will
> >> > >> >> mirror the same thing that that patchset is attempting to do.  Please
> >> > >> >> work together on this.
> >> > >> >
> >> > >> > +10000000,
> >> > >> >
> >> > >> > Greg,
> >> > >> >
> >> > >> > This series came as a surprise to me given the fact that device trust
> >> > >> > series is exactly for that - allow confidential computing.
> >
> > Device trust's primary role in enabling confidential computing is to
> > give space for the userspace to do all the TSM and attestation stuff
> > to get the device into T=1 private DMA mode.
> >
> > It is the userspace that does all this and the userspace bridges from
> > "I got the device into T=1 mode" to "Now it meets my userspace policy
> > to be trust level Full" and then finally "Now I can bind and start a
> > driver"
> >
> > The two concepts work together, but they are not linked inside the
> > kernel.
> >
> >> > >> > Adversarial is equal to the "cc_accepted".
> >
> > I expect most policies would make "cc_accepted" as a full trust level,
> > but we do want to allow adversarial as an option too.
> >
> >> > >> I think the confusion stems from this thread:
> >> > >> 
> >> > >> https://lore.kernel.org/all/yq5amrr8yldi.fsf@kernel.org
> >> > >> 
> >> > >> Based on that discussion, I understood TRUST and eligibility for private
> >> > >> DMA to be complementary attributes. Device acceptance determines whether
> >> > >> a device may access private memory, while trust determines whether the
> >> > >> core must enforce additional restrictions. 
> >
> > Yes.
> >
> >> > > Device trust does little beyond preventing driver binding and recording the
> >> > > trust decision in "struct device". The missing piece, which I would expect
> >> > > you to address, is ensuring that the IOMMU and private DMA are configured
> >> > > only after the trust level has been decided or as part of that decision,
> >> > > rather than beforehand, as they are today.
> >
> > They are orthogonal and unrelated.
> >
> > All the TDISP and T=1 DMA flow is about how the DMA API works and has
> > no direct impact on trust level. You can choose any trust level for a
> > device using T=1 DMA.
> >
> > Getting the device into T=1 should influence how the userspace decides
> > to set the trust level, but it doesn't interact inside the kernel.
> >
> > Aneesh has it right that these are orthogonal and unrelated
> > activities. There may be some confusion as Dan attempted to couple
> > them, but after discussion we have moved away from that since it
> > doesn't meet all the use cases.
> >
> >> > What I am still trying to understand is how you view the DMA allocation
> >> > and mapping paths determining whether a device can access private
> >> > memory. Paths such as force_dma_unencrypted() and SWIOTLB receive a
> >> > struct device pointer and need to decide whether to use private memory
> >> > or shared buffers.
> >
> > It is Nicolin's work here that needs to go before the TSM drivers:
> >
> > https://lore.kernel.org/all/cover.1794343501.git.nicolinc@nvidia.com/
> >
> 
> 
> This adds
> 
> index 429e39f647cf9..01d7877d0b571 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -604,6 +604,8 @@ struct device_physical_location {
>   *		ancestor device.
>   * @DEV_FLAG_OFFLINE_DISABLED: If set, the device is permanently online.
>   * @DEV_FLAG_OFFLINE: Set after successful invocation of bus type's .offline().
> + * @DEV_FLAG_DMA_CC_PRIVATE: The device is able to access private (encrypted)
> + *		memory, no shared memory bouncing is required from the DMA API.
>   * @DEV_FLAG_COUNT: Number of defined struct_device_flags.
>   */
>  enum struct_device_flags {
> @@ -617,6 +619,7 @@ enum struct_device_flags {
>  	DEV_FLAG_OF_NODE_REUSED = 7,
>  	DEV_FLAG_OFFLINE_DISABLED = 8,
>  	DEV_FLAG_OFFLINE = 9,
> +	DEV_FLAG_DMA_CC_PRIVATE = 10,

Again, NO!  No "cc" nonsense for device states please.  That's an insane
policy decision that will be driven by userspace crazyness, NOT
in-kernel stuff.  The kernel will give userspace the tools to enforce
this type of policy if someone so desires.

thanks,

greg k-h
