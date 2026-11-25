Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795600357;
	b=y4B//F7Cm+sTx2Va7qsDL62dkCWxJ0XxDahE7ZB3X6283MNnQ7KPQ732tOVYkZEfaWUI
	 r9O1ddBZ2eCi1Auakh2c62++qoe3YY7mKL0rhv9NT9lTBBtEnVfIwE72KaymAHa8/i4x/
	 ltNnG6EJB02uzLFGaa97RChLKMEm5xQhH7geMpQM0ZCeTjuuR639GBY7OLqf0W08smnwF
	 1PkwXlvC62YLZITwDBHwHiaGTvxd4KoObw9B9bnBkCd3FoOWYLby26YM18QxLI2Ty7UVK
	 6KxgMY0YwSeNMMDZKvfTms4oiGGavyqzF7bWujirOSaGxnze161ZaAS24rSgMfzk5gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795600357;
	h=Received:DKIM-Signature:X-Mailer:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:MIME-Version:Content-Type;
	bh=lxNxo0WViVlcLa7SPdP8MGDphVxbnRRV9YfIs2LmfLM=;
	b=ocEQTmQXj6r4kRld3ITBobEjOWt2NzMtX4tQyIc6goKcUmzhJy53CAmDkx914dMxs0F7
	 qwwf6NDxHVXFv8BNoW5oO5OL+0GppgzS9A6mLyklu5hkeVwYtdSMQtlGl33UVxuj88VbX
	 t9e6rPcQCjLYUM3qOPptD+1f3CN9nDz622Wxx9KqNrwd/03G51+4tac5Zd0N/OkHqCNCn
	 t5UlOTd8iJHG40AM/zYGXK9JY5OWtA8lWTYJ/U5puBef/jXFTWFIVj0fMpaTmUTDRG6MD
	 gHopaOSK9DAQdEK0vFs+NaMafbHsPYnDs7kVkQQ8k3gWp0JLVej4vDseWJ9eZp9NOMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ORQuLAwS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951AF606A32C;
	Wed, 25 Nov 2026 09:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ORQuLAwS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D79321F000C0;
	Wed, 25 Nov 2026 09:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795600357;
	bh=lxNxo0WViVlcLa7SPdP8MGDphVxbnRRV9YfIs2LmfLM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=ORQuLAwSSWGXRALu58+wnUib77buu3jlPY89IwQjKGbXEltJKVewClrN9SJSfNKRk
	 zhFH3pUS/pP1RP2FJJc5pQcXcL0BQnYogOT6ZVJ1AuAVefppeErhwObhLH1fTZFGKE
	 W7ipM1xnSYSEWWCRhUmq35MgBF0f5lB8h3U75CZXpTLSU59TrRETuag5gCtTX1EU2S
	 +sLD0HatHQoM9l/Mfi2hyvR9O63zEJQHbcBUWkY+7XfHU2en+kZGt6kuxWtHsTrAmd
	 +FzWNZ0OqKbQwDNx9vS7waGnfTaCJF37U2XRPBpZG3yD5+CaVBH38SwTWf/cF5UrsI
	 gZWIH1XuSEvWA==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-coco@lists.linux.dev, Dan Williams <djbw@kernel.org>,
	Leon Romanovsky <leon@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
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
	kvm@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v1 05/10] PCI/TSM: Add association locking helpers for
 evidence acceptance
In-Reply-To: <20261123153507.GH179082@ziepe.ca>
References: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
 <20261123083337.2731019-6-aneesh.kumar@kernel.org>
 <20261123153507.GH179082@ziepe.ca>
Date: Wed, 25 Nov 2026 15:22:27 +0530
Message-ID: <yq5ald6h9r1g.fsf@kernel.org>
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

> On Mon, Nov 23, 2026 at 02:03:32PM +0530, Aneesh Kumar K.V (Arm) wrote:
>> Later attestation patches let userspace finish device setup through
>> evidence-accept after host sysfs connect or guest sysfs lock returns.
>> Those commands use a saved struct pci_tsm and must prevent disconnect or
>> guest unlock from changing pci_dev::tsm or freeing the saved structure
>> while setup is in progress.
>> 
>> Add pci_tsm_trylock_association() to acquire pci_tsm_rwsem for write and
>> check that pci_dev::tsm still points to the saved structure. For a TSM
>> implementing devsec_ops, first take device::mutex to prevent driver
>> attachment during MMIO validation and device acceptance. This matches
>> the device-mutex-before-rwsem order used by PCI DMA preparation.
>
> This doesn't seem the API I'd expect here.
>
> When we trigger SPDM session start AKA lock through the CTLV it needs
> to capture some kind of 'session cookie' for this locked that ties
> back to whatever the TSM is using to prevent a hostile host from
> locking/unlocking while we are working.
>
>
> That cookie should be held in the attestation driver and when we get
> to acceptance it should be presented to confirm that nothing has been
> tampered with.
>

We already do something like this on lock, we track the cookie as part
of CCA and use that during accept. Sure if every architecture supports
this at firmware level we can abstract that to attestation layer. Yes
and this protect from hostile host.

>
> It is a further reason why we can't have lock under sysfs control.
>
> It should be attestation that provides a general purpose lock that
> serializes all attestation operations including lock/unlock so we
> don't need a TSM lock like this.
>
> The driver should rely on that lock and use its internal mechanism to
> process the cookie.
>

But this patch is about keeping pdev->tsm stable in the guest. We need a
mechanism to associate a TSM with a pci_dev. Currently, the host uses
sysfs 'connect', while the guest uses sysfs 'lock'. It is not clear that
we were proposing to remove that mechanism.

We also have a single sysfs teardown operation: 'disconnect' on the host
and 'unlock' on the guest. This tears down IDE, unlocks the guest
device, and disassociates the TSM from pdev->tsm.

How do we ensure that pdev->tsm remains stable across the different
operations?

As described in the commit message, this patch takes the lock to prevent
a sysfs unlock from running concurrently with evidence-accept.

Are you suggesting that the TSM association remain under sysfs control,
while IDE teardown and TDISP unlock become CTLV operations, and that
sysfs disconnect or unlock be prevented until the above CTLV operations
have completed?

-aneesh
