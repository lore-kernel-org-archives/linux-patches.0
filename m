Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617407;
	b=HbeNMiuFFmahVCsS1/DNn2vEgATZvV/LJ50jmUZflcn6JOxy/1zvRO7IHxGZQQMBWJUP
	 TynEihtRh4qeh2i6yUQDU+yFnBRcUJyxNqKsNH0h21yVGkgaeu57i3yi1yliGgHh++S0m
	 rcZusXa0S9JKm5zHAojJ1OAmeUCdGSJ3Cy2is/HmOiirUJR3b2j+OYxBr795+p20Yeoj+
	 1/Hn1GjyzO5f9w3EedfiymIjqBkp7maLHRvYJUbEPIiiedXt6mhkLoBc+kweV3rJviX9P
	 6IgjrnlOinTXNEBYOeJgMRpjwutk3kAB4vMJ0QEVhLgRpur+x8k4CvGHll5DfsqMV7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617407;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=jZ0ODJBUI26+BRK0bblrmNavhVVExfleUfyE4pxTCBs=;
	b=F5R0/8uuZdGD1xRs2qC7Y4fnJEKLxe3tU01PpkSR+OhpG9lVVaRduQYxyMGRKqJc0x//
	 DaRNp9Cl9o/iLlnJS2nyDxIgWl2AV6Z8mNdoUwY/YbmHNLOWqJ91UQgB6YSpzRnvhxjTr
	 Km3CJ3YgmO3jSQ0GTpj+bldLsPl97oeNeKYHZMapIzssLZjQ2ZkVY/0T3UYNgXit868Sc
	 WZ3xbQFJURa0IIiK4AFPM9kOeOtHZHblMeCUycUbOJHQFqDKz3m3YJmBcmrLMe6G4Q6Y0
	 jivzyLIr2cwREkhmdupPGHxmQvzdh0rBQaUwgJlxDuHScrwqmDUAORE1GQWDrK21IaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=nNufUi+b;
	arc=none smtp.remote-ip=209.85.160.176
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4A2606A321
	for <patches@lists.linux.dev>; Wed, 25 Nov 2026 14:36:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8B4A2606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=nNufUi+b
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-55c38cdd5b7so43206451cf.2
        for <patches@lists.linux.dev>; Wed, 25 Nov 2026 06:36:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795617405; x=1796222205; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jZ0ODJBUI26+BRK0bblrmNavhVVExfleUfyE4pxTCBs=;
        b=nNufUi+b+idZrCGl8AZNlJJQ45+Bhfbsofh/RKlszlAZnTI0y6uIgecAwkabYJyyWb
         Uas9Ae4A1wiY80p8PJZ3C1s6fOQxUW5XcRs58VCysSvzjk9bgoJjk3aIJpkw0FBXOS4s
         rnbfI9LezAcxyjFFLRzxe/9Pkd0pG1JbiyC4deR6nK+NEZSTqnoAzcKEXJSFESYpoR3G
         XLJdE93E0lt8gDRWC2ZhGtGxGdv4KUCbDM5TKwNgJtVMHuIXr2k7EdWUVAkVyKljxqTI
         4UfXDl4OCQAyWvNe45HYCBW419byzZjag0eGFpFJbvvyHszt1xn5r75f0IqG/EoUeMKh
         SnrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795617405; x=1796222205;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jZ0ODJBUI26+BRK0bblrmNavhVVExfleUfyE4pxTCBs=;
        b=AePjgmH460+4FuCVyCmZ1vmiBrJaOOfalw8MEuzpYcnFvB0B/LrF50g35sPQxyWV39
         ZZFmMBsEowiQtDkasjFhNxjvKkTxMhh/R3bZ5x/heJQwDHqaklefTy8WxU3DoyUkFIkD
         BvMvmtVBOYsExFpLryyv7Uxd3OVcst8w4vdiVXzr9BeSIuf6pcAqVd5onPCHbHed/gsw
         q7VzLK3ujor+UOGMpxELBujm3NpzSp81ozcsdZlTKZ2l13djQfez6Q9iPH/4eFrIskUm
         1vLiPLZ4vzJVSOr8oFFRXC/9P+3A7kH1+7yeM9BX5qT3bKLcxGc4m7M36vy5VLRF0uuE
         xnlw==
X-Forwarded-Encrypted: i=1; AL+hErE/rrdeJ28NqtjN9sENsjOf/AIXl818ZOvW/RDBZc/qS/T429JNzgnhMjaV5VUinu/qz+bF6Dss@lists.linux.dev
X-Gm-Message-State: APuU4Z9z9mPkaoru0PnLrBAV3y1ShAYcZVd0I23RdKV8Z+M4cNFXlqHr
	4kLOKbEl3P7/2rlQYegh5wGgs68J2Fvl1yxVUbbn7jgwtoAQsj1rmlVRQtC30VZM93E=
X-Gm-Gg: AZFdTZe1t5CIJ2A7gi8JfKerBBWmCIA8oNstyozzcrOFSmbnCBWcN+t5xd2soVFlkEt
	HFE4xX1mp4Vj0XzcS3mzWLajXt7kcFiRI//FhFrq0p7Gv2nuCnga8EiWQU/63SroCm3GT1NtotN
	JafyEGp/c9MbnrUzeOioFj9AJwxtvKoS9jnAD5Oc9e0/D9HJRprQXYWEYab2fJMzq+kl2EPeLPl
	x8U2tZtcgENv3gqr7VemrMOTUh2gpVQrG0/pk0Dg43NDAufZ64Z1DZc4/wNhwIJdKeDk5vc4DIj
	gwVJN/FFWWyRu9SO+Wm+osvW8vJvDP3tuYEIZ490g2RJFFgvY6cUbmSBxrnZ9FMyxzzVnnQJWtU
	+vwSl1Jwgu1eFr1WDHCsVMUqcCmeQ8KDvbD0fk0zSGMuqarz+tgELl6/iTB334+iFsa5Yr4WH/v
	ZsrhaSkziEmu1FsfAWaTAkbprK4aPPEoS3kGF3NsaRb335T/I2PrOyx/cMfjRhM98RtrnAGNodD
	TgCEmZb3K/RTHqvKIjma5DaO/ECftjU0AhiDeIT2jqHy9IabUUKCWIWxYBRr+w7bHnFziz2PD0p
	gc0zrQ==
X-Received: by 2002:ac8:5e53:0:b0:536:699d:9a22 with SMTP id d75a77b69052e-55d76aa8754mr328840131cf.57.1795617405368;
        Wed, 25 Nov 2026 06:36:45 -0800 (PST)
Received: from ziepe.ca ([142.177.118.84])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d78880604sm157945401cf.24.2026.11.25.06.36.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 06:36:44 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xWE72-00000001la3-15Li;
	Wed, 25 Nov 2026 10:36:44 -0400
Date: Wed, 25 Nov 2026 10:36:44 -0400
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
Subject: Re: [PATCH v1 05/10] PCI/TSM: Add association locking helpers for
 evidence acceptance
Message-ID: <20261125143644.GF246011@ziepe.ca>
References: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
 <20261123083337.2731019-6-aneesh.kumar@kernel.org>
 <20261123153507.GH179082@ziepe.ca>
 <yq5ald6h9r1g.fsf@kernel.org>
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
In-Reply-To: <yq5ald6h9r1g.fsf@kernel.org>

On Wed, Nov 25, 2026 at 03:22:27PM +0530, Aneesh Kumar K.V wrote:

> > That cookie should be held in the attestation driver and when we get
> > to acceptance it should be presented to confirm that nothing has been
> > tampered with.
> 
> We already do something like this on lock, we track the cookie as part
> of CCA and use that during accept. Sure if every architecture supports
> this at firmware level we can abstract that to attestation layer. Yes
> and this protect from hostile host.

Every arch has some solution, but the critical part is the cookie must
be tied to and exposed into userspace.

start returns some cookie ID, and accept only works if that cookie is
still the current session.

Since we have a uAPI that allows multiple userspace threads to open
attestation this cookie prevents trouble if something else open/closes
the session from userspace.

Doing it transparently in the kernel isn't protective enough, IMHO.

> But this patch is about keeping pdev->tsm stable in the guest. We need a
> mechanism to associate a TSM with a pci_dev. Currently, the host uses
> sysfs 'connect', while the guest uses sysfs 'lock'. It is not clear that
> we were proposing to remove that mechanism.

Everything uses connect.

Once connected the attestation FD is created and its internal locking
and disassociation scheme will prevent any issues with TSM hot remove.
Basically when TSM is hot removed it unregisters attestation FD and it
is attestation subsystem's problem to lock that, not TSM.

Once the viommu is created then the ref mechanism you build prevents
TSM host remove while the viommu object exists.

Together these mechanisms should encompass the entire uAPI we see
right now, so we shouldn't have or need yet another layer of locking.

It is why these sysfs's are looking more and more troubled since they
are existing outside the natural object and locking model that is
emerging here.

> Are you suggesting that the TSM association remain under sysfs control,
> while IDE teardown and TDISP unlock become CTLV operations, and that
> sysfs disconnect or unlock be prevented until the above CTLV operations
> have completed?

That is roughly what I'm describing above, it should fall out
naturally from building attestation subsytems lifecycle model
correctly.

Jason
