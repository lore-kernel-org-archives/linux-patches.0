Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617024;
	b=jm/4WHAoKYc77vQrK7xwrvUhnjuXuczSFNto/HWKVpcRs1MWZDIkXjNW+D+R+duWvahS
	 FV7SCmWbNyO8zpMYKIjeYff9QxlDu1vHFxBXAckrm0NFBSUL96k9SYd62CfrzbH1R14X9
	 Da3smfR8T6bqZ0zUyiH+bwrZjRhnyCU6IAEm0mz8KcVtA876Uag7UGRZ361Z3cSpPhxTa
	 4/PmGcKeHRV6S1Hcnk4rCaGhneN6mfJ5CwUqnJxoF0hHCQg0pgL/ztDfVG/ndUnjXePIO
	 ofAYi4U3VQADK9XrReejDe09enTs1X7Tc7NN2cCeGUmqnbsk9aHo8XGTUiTqBQt7E2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617024;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=QBcv8zNRd7z7TClVEOp0n/ANSt8sNFaJ/rvaTVt2TZM=;
	b=sM40yL+8Celp24ei4SAWM7y3OQ0CBdZ28lFFbGIqPqdgNy717YkrzzsEWreS3aDTwsjW
	 BX4aLSTGHrW3RR6+fw+tzNqNNR3q60ZvKfOmljcHaA2LbVAa5vlTkrM3evwtcZcZKRm8n
	 SKDArscqSlIK+tULQo2v83EK2n2h9ewIIQjmZ8ekcDgh+2yAIOFxkzbAEc0pIrEqaYzu9
	 Si98mYYfhQ3KhDmhvR9S2ZwE806mLnq4G36OkRc2lq81YCHJmZZDlwBdv4+wMTIf8+hz3
	 m3ZG6mVj2Pi3m5JfQC6nbUfoYfWIFOeKIYE6ZiyDWCWqv1adH9Cn9dkoLVBIN6ZGiVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=QcD1mi7h;
	arc=none smtp.remote-ip=209.85.222.175
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C735606A323
	for <patches@lists.linux.dev>; Wed, 25 Nov 2026 14:30:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7C735606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=QcD1mi7h
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-93f22a8515eso507359985a.2
        for <patches@lists.linux.dev>; Wed, 25 Nov 2026 06:30:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795617023; x=1796221823; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QBcv8zNRd7z7TClVEOp0n/ANSt8sNFaJ/rvaTVt2TZM=;
        b=QcD1mi7hS1nJEh5RnDz+i3qMNkj9OaNI14nXyERrcG+7TbGJURtXgqggOYncDcxVs2
         6PSwdHLzy631DnOAcxIA0yzNr7HLR5PMTRUlww1Po8vAyx8lCCvOy6sWoM8JgfgRY1pr
         rZ6EvygJp8yzG/enUW/oqzQCckxyy+0keTc4BrbXsManhsDLMv6/q1+VpGsfuQT6avFL
         TnvYu2iZyP/nffcOk/fIGx1YRn1P+322LF7rpYEXuovbi/uasl2nLGSY6oMu3lv2Oepo
         Kuzq2tYnd6XAXDk85QDq/OojSgC+FtuiDaBfaaygtUzWsadxD35/AvWiVSr+2EVOQkBD
         X0tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795617023; x=1796221823;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QBcv8zNRd7z7TClVEOp0n/ANSt8sNFaJ/rvaTVt2TZM=;
        b=mx1QtqZZsfFSTPP4IbOpA2WNe5MfRO6dpAIBMGoJww6k/+Tx4zUdoTANjXCYYgk/kw
         IWr/7a8JJtKxh/QkccXItRQkdFuzaqxSkcyeHBlxFuQqgqnZxo/S2MubXbyBbjag5Q/n
         mmE/I/ijB5xa1csfLOyCzb+pybpbOQIXNRWv0dbRQdpWJjDneDgyjHOPQHll2zYBVA/L
         Ve1Us6PY7LFrmoTaypIaVBx5F5SQZRT8lQsiON4e6r+pnGeJwixiZhBvvfRp7QRsYhao
         ytU9lOrzmjEZHXj9XM23yctkzXRJSTgI8W9IoQWiffxjObf049V0u4YEhvo61l8pEOM6
         reWg==
X-Forwarded-Encrypted: i=1; AL+hErFNDeY8b+p8qB/sKLgrgzPIcQylkTk4Yy00v6Z3EBI9euaifEwQpA8Q0v6KtBKj2OHhEskooMdz@lists.linux.dev
X-Gm-Message-State: APuU4Z+JmWo56XlAFrrIHtjRCsxMbWb839VoLJ/4lUyGFgBjw+S0bxpP
	/YFdMfpAy/D7SoDqLl4y5jK5+nCrbvyYwSQlQ9hfUjX/FPEGDkxEBg2p1dxSEuDI2rc=
X-Gm-Gg: AZFdTZcI1cGi0ATVDXsxgs7ctys+ZVCWw9jo21speEWxG6xCon2lWp8QIihYZQJc6to
	b1M/lh7AtNXr9DIQlkUKM9FBz1L3feapEQiIwPQuzi7YgSqsnrWJnMOISZGPnn/oQMWbyV5f9UY
	jwIBkJSYPyqVise+gD0RhE5Mlv+XQZ+t+XEGji/P/bYL9TCzQFkX0sC01v0kGlvA26bMGuwPJGb
	/lAKVDazN6v2FcCowwoFE9tCFnSM48iGICWrhwQLmXyI1K+XTMJJS6lmxwKFrJUqoqRwaAVyAlw
	VJFpSiPITiQ/mIy6CfR6k/Jh+hj+MnVlN68+rCRtJ9aneqz8T2hsIcvLpc7FNdmnHVBXJ7sMrPS
	L8983GIOOIFfvzPItMhXaGoNV5pMZmePCV9wcNGw1XR5WQrfpeHmDGmK+tfXFGakvL/38J8+sqE
	vf4FehoKBNU85+Kfu3fUCOk55xAX9EHBoDOC8mWfrfsjlTIqhBZbteOTEFve1THdk2Z0NYqVc2E
	t45wwyC+NO1DaWrhgM3jRdA3qJuLgl3tAQM7V1hG62OC5CHp801pLCnWTphIomldnbepb4gJL7Z
	wctE8A==
X-Received: by 2002:a05:620a:f04:b0:949:a71b:ec68 with SMTP id af79cd13be357-949ba823b7bmr3195384285a.3.1795617023007;
        Wed, 25 Nov 2026 06:30:23 -0800 (PST)
Received: from ziepe.ca ([142.177.118.84])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-949bb397b4bsm1330247085a.21.2026.11.25.06.30.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 06:30:22 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xWE0r-00000001kw0-3nZo;
	Wed, 25 Nov 2026 10:30:21 -0400
Date: Wed, 25 Nov 2026 10:30:21 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
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
	Lukas Wunner <lukas@wunner.de>, Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	driver-core@lists.linux.dev, linux-pci@vger.kernel.org,
	kvm@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v1 08/10] PCI/TSM: Add sysfs lock and unlock for
 guest-assigned devices
Message-ID: <20261125143021.GE246011@ziepe.ca>
References: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
 <20261123083337.2731019-9-aneesh.kumar@kernel.org>
 <20261123152738.GF179082@ziepe.ca>
 <yq5ao6bd9tb5.fsf@kernel.org>
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
In-Reply-To: <yq5ao6bd9tb5.fsf@kernel.org>

On Wed, Nov 25, 2026 at 02:33:26PM +0530, Aneesh Kumar K.V wrote:
> Jason Gunthorpe <jgg@ziepe.ca> writes:
> 
> > On Mon, Nov 23, 2026 at 02:03:35PM +0530, Aneesh Kumar K.V (Arm) wrote:
> >> A confidential guest needs to lock a PCI device before collecting and
> >> verifying evidence about it. Userspace also needs a way to unlock the
> >> device after use or when verification fails.
> >> 
> >> Add tsm/lock and tsm/unlock sysfs attributes for TSM drivers
> >> implementing devsec_ops. Writing a TSM device name to tsm/lock calls its
> >> lock callback. Unlock calls the matching driver's unlock callback
> >
> > I thought we agreed not to do this in sysfs as we worked through the
> > SPDM stuff?
> >
> > LOCKED should be the 'start SPDM' action in the guest
> > RUN should be the 'accept SPDM' action in the guest
> >
> > And though we didn't talk about it there is likely some 'destroy SPDM'
> > action that is UNLOCK and UNRUN.
> >
> 
> I may have misunderstood. I implemented that flow only on the host, but did
> not add a "start SPDM" action for the guest.

I was hoping for symmetric. In SPDM terms the 'lock' is what
stabalizes the measurements so we can do the same sequence and then
guarentee they haven't shifted by the time we get to accept using the
same cookie scheme as host will use.

For this reason lock needs to output a cookie, and that doesn't fit
into sysfs.

Ideally the user space sees no flow difference between guest and host.

> Currently we have it as
> 
>     # Host SPDM authentication and stream acceptance are complete.
>     # VMM has created the guest's VDEV.
> 
>     guest lock                 -> associate guest attestation endpoint

This action should be TSM connect, same as host.

These should be the 'start SPMD':

>                                -> RHI: request TDI CONFIG_LOCKED
>                                -> host/RMM: VDEV_LOCK + VDEV_COMMUNICATE
>                                -> RSI_VDEV_GET_INFO:
>                                  trusted state, lock sequence and digests
>
>     spdm-get                   -> available objects, certificate slots,
>                                  formats and current state
> 
>                                  current firmware:
>                                    * expose only the existing selected identity
>                                    * report independent signing-slot selection
>                                      unavailable
> 
>                                  updated firmware:
>                                    * expose all discovered candidate chains
>                                    * expose slot/key metadata when supported
>                                    * bind the catalog to this assigned VDEV
> 
>     spdm-get(certificate,
>              slot=0)           -> retrieve captured slot 0 chain, if available
>     spdm-get(certificate,
>              slot=1)           -> retrieve captured slot 1 chain, if available
>                                -> check the applicable trusted RMM bindings
> 
>     # Guest inspects the available chains and selects a signing identity.
>     # For 1.3 multi-key, its key usage must permit measurement signing.
> 
>     evidence-get(
>         slot=1,
>         nonce=N,
>         selected-key-identity) -> select the firmware's supported measurement flow
..
>     evidence-accept            -> validate this guest attempt's generation/receipt
>                                -> validate/map approved interface resources
>                                -> RHI: request TDI RUN
> 
>     trust_policy=full          -> authorize driver binding
>                                -> configure PCI DMA and the default IOMMU domain
>                                -> RSI_VDEV_DMA_ENABLE with accepted sequences
>                                -> driver probe

Then this is some error flow or whatever:

>     driver unbind              -> driver removal
>                                -> RSI_VDEV_DMA_DISABLE
>                                -> release default-domain ownership

>     guest unlock               -> revoke guest access and mappings
>                                -> return TDI to CONFIG_UNLOCKED
> 
> 
> Both host and guest flows are documented
> 
> https://git.gitlab.arm.com/linux-arm/linux-cca/-/blob/cca/topics/7.4/cca-da-integration-v2/Documentation/userspace-api/attestation-spdm.rst?ref_type=heads

I don't think the scheme will be 'spdm-get' using a bunch of 'cached'
object IDs. It should be much more specific.

The transcript should be its own top level API, with its own sequence
numbered list of discrete blobs.

Different kinds of fresh evidence should be collected and returned in
one call, not "cached" in the kernel.

Certificates should be in their own API.

> The reason I did not add spdm-start for the guest is that lock does not
> take an input parameter. Only GET_MEASUREMENTS requires the key details to
> use for signing.

It has to generate the session cookie based on the current sequence
numbers.

> However, we can keep the guest flow consistent with the host flow: use
> the tsm/lock sysfs attribute only to associate the TSM, drive the entire
> TDISP flow via ctlv, and have spdm-start lock the device.

Yes, but as above creating the attestation device should be identical
to the host as well. No locked sysfs required.

Jason
