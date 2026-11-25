Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795597417;
	b=BZ/FSdUxdM8j2ySePPxgKxUecpqRZvFaWcrAmSTAJj2GUNeKoUCyGUQgYfuqjWUZrUFc
	 tkVcFCUIqr+woy7chno94/yDhgwULBupfPkuH+hDbLlMQHTY5ZegAT4YQaBh3GhxmX6to
	 2jhYJEioWCECtxmZUNN+OSXbCNYMQ2b7JxxTvZZoE/JNAb6HIJotgRzCGkPs8phf6Bt19
	 j9ZtpQdO9I7+zOzNY8LQ09aGwEfqYb5/hNyYUT+ouh7Bje47QGdqnO5h37HGEi4451dTx
	 bRzyy3JIvZN8aN7Sdklv03GOe11NjnGjCkeZrXBkSOZRajE49c5TWdVVTW90PPdh8/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795597417;
	h=Received:DKIM-Signature:X-Mailer:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:MIME-Version:Content-Type;
	bh=VKJwAy1lGpq4z0cOO8aJHyNLtiPZ13aYi7c5omKUShE=;
	b=DenGyIoRuwFmiwgy6tngfTvLK9KH/jAvpj3e/WF74tuKphcWP/8CBZMWUTHkYdkViglj
	 TvxEduQeYJBHwRVxUYAbpmhB8CXOXNOZfcrRjZzC6HQWKiefg88XA/mrMnr0NVb+mjBVV
	 nVYnJTL9GDpjxn0kCGpfA/swLAMm6+E0SHOdOPFlclxFm8hrioPz5vCHFIEM5zXYO950Q
	 0BDoKPPzsCxsmwenAwxwh2Mf9LXqmbDP059bOGLWDt5XWTpXGJFmfcM+St1u1AxZyChXo
	 03D4gRVuGosRbXBLjqFVKWIEZmnkuOGjpKv6SUKZA3AnzciaDPcFAUps4SJGNMiCbYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CNjuEEgY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2822B606A31E;
	Wed, 25 Nov 2026 09:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CNjuEEgY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C1A51F000CA;
	Wed, 25 Nov 2026 09:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795597416;
	bh=VKJwAy1lGpq4z0cOO8aJHyNLtiPZ13aYi7c5omKUShE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=CNjuEEgYPQAcKuQYdl6za1C0ebFVINRWCNnFCjlDwJQd+I/ft9hJRStwX/N39vxDl
	 nD23OV2ymNPVX2Uw0dBQXKUZ2pljh7PYWojD+DrY1EHXYrg3HK2mDB5bALqGspQiLH
	 SYHXiF2jIeecjb8F6IJKb/u9s1m0y8iyXAYaxveO8vsbKbwS4cMiAv9VlFgSJK9CU3
	 jttF9y94eSzUmGwHJ4s5Zn1dIMAsIzN86hHAZQvDZ44B0uM0DYzY0K8U9mYvuHkNfF
	 0MC3pZ6VKlroRd/tz1qK6dsFELPlNoHuJVoP9DntITzk6FMOqpA3ySLBNObxFU/Y82
	 6Tf4S/2+emG6g==
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
Subject: Re: [PATCH v1 08/10] PCI/TSM: Add sysfs lock and unlock for
 guest-assigned devices
In-Reply-To: <20261123152738.GF179082@ziepe.ca>
References: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
 <20261123083337.2731019-9-aneesh.kumar@kernel.org>
 <20261123152738.GF179082@ziepe.ca>
Date: Wed, 25 Nov 2026 14:33:26 +0530
Message-ID: <yq5ao6bd9tb5.fsf@kernel.org>
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

> On Mon, Nov 23, 2026 at 02:03:35PM +0530, Aneesh Kumar K.V (Arm) wrote:
>> A confidential guest needs to lock a PCI device before collecting and
>> verifying evidence about it. Userspace also needs a way to unlock the
>> device after use or when verification fails.
>> 
>> Add tsm/lock and tsm/unlock sysfs attributes for TSM drivers
>> implementing devsec_ops. Writing a TSM device name to tsm/lock calls its
>> lock callback. Unlock calls the matching driver's unlock callback
>
> I thought we agreed not to do this in sysfs as we worked through the
> SPDM stuff?
>
> LOCKED should be the 'start SPDM' action in the guest
> RUN should be the 'accept SPDM' action in the guest
>
> And though we didn't talk about it there is likely some 'destroy SPDM'
> action that is UNLOCK and UNRUN.
>

I may have misunderstood. I implemented that flow only on the host, but did
not add a "start SPDM" action for the guest.

Currently we have it as

    # Host SPDM authentication and stream acceptance are complete.
    # VMM has created the guest's VDEV.

    guest lock                 -> associate guest attestation endpoint
                               -> RHI: request TDI CONFIG_LOCKED
                               -> host/RMM: VDEV_LOCK + VDEV_COMMUNICATE
                               -> RSI_VDEV_GET_INFO:
                                 trusted state, lock sequence and digests

    spdm-get                   -> available objects, certificate slots,
                                 formats and current state

                                 current firmware:
                                   * expose only the existing selected identity
                                   * report independent signing-slot selection
                                     unavailable

                                 updated firmware:
                                   * expose all discovered candidate chains
                                   * expose slot/key metadata when supported
                                   * bind the catalog to this assigned VDEV

    spdm-get(certificate,
             slot=0)           -> retrieve captured slot 0 chain, if available
    spdm-get(certificate,
             slot=1)           -> retrieve captured slot 1 chain, if available
                               -> check the applicable trusted RMM bindings

    # Guest inspects the available chains and selects a signing identity.
    # For 1.3 multi-key, its key usage must permit measurement signing.

    evidence-get(
        slot=1,
        nonce=N,
        selected-key-identity) -> select the firmware's supported measurement flow

                                 current firmware:
                                   * support the existing signing identity only
                                   * reject unsupported slot/key selection
                                   * RMI_VDEV_GET_MEASUREMENTS(nonce)

                                 updated firmware:
                                   * enhanced RHI_VDEV_GET_MEASUREMENTS(
                                         slot, nonce, selected-key-identity)
                                   * validate the requested slot/key association
                                   * enhanced RMI_VDEV_GET_MEASUREMENTS(
                                         slot, nonce, selected-key-identity)

                               -> VDEV_COMMUNICATE
                               -> device GET_MEASUREMENTS:
                                 request signature using the selected identity
                                 and the guest-provided nonce
                               -> collect the complete guest device bundle:
                                 * selected certificate chain
                                 * fresh signed measurement exchange
                                 * locked interface report
                                 * available supporting transcript
                                 * trusted device/identity and sequence bindings
                                 * formats and declared capture limitations
                               -> obtain fresh RSI_VDEV_GET_INFO
                               -> check evidence digests and lock/device state
                               -> retain one consistent complete bundle
                               -> return bundle, device generation and receipt


    guest verification         -> verify certificate policy and measurements
                               -> verify signature with the selected leaf key
                               -> verify signed inputs bind the original nonce N
                               -> verify association with the assigned device
                               -> approve the interface report before acceptance

    evidence-accept            -> validate this guest attempt's generation/receipt
                               -> validate/map approved interface resources
                               -> RHI: request TDI RUN

    trust_policy=full          -> authorize driver binding
                               -> configure PCI DMA and the default IOMMU domain
                               -> RSI_VDEV_DMA_ENABLE with accepted sequences
                               -> driver probe

    driver unbind              -> driver removal
                               -> RSI_VDEV_DMA_DISABLE
                               -> release default-domain ownership

    guest unlock               -> revoke guest access and mappings
                               -> return TDI to CONFIG_UNLOCKED


Both host and guest flows are documented

https://git.gitlab.arm.com/linux-arm/linux-cca/-/blob/cca/topics/7.4/cca-da-integration-v2/Documentation/userspace-api/attestation-spdm.rst?ref_type=heads


The reason I did not add spdm-start for the guest is that lock does not
take an input parameter. Only GET_MEASUREMENTS requires the key details to
use for signing.

However, we can keep the guest flow consistent with the host flow: use
the tsm/lock sysfs attribute only to associate the TSM, drive the entire
TDISP flow via ctlv, and have spdm-start lock the device.

-aneesh
