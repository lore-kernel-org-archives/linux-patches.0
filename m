Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795423259;
	b=krnbb+M46LsiY9GnqV1xK28vgteTgFbXIyBI7eZvz0Ae3rPdrJVFP5ceGzz7bPNTRABp
	 qezvOtgj8ydDZdkD0z4bkkpPxR1356GismStkY+YNCdXFSv8KPaTN2d5LCpELKesO/S3s
	 V5VZX6lCRE6Bfoo+uFBpmjFt1osqUbeoiuD852cXyp2AnhIJNOZXRhijUJDSYFrwv7+D1
	 9jDq1yDvgG0bRQExUrXRxaYNDy4X0jKHLWmfyoYz/x9uIzTe5TwmTdzxsqywJOu0aNucz
	 WoQOXd9WfauoqTSXONUl+r+Ig74FeR4OfC7zRhfQLnKdh41t9fTcuRZgPUuKW1HEz3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795423259;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=S4nHUrs17hshqm79V43YL5JWoREyieIuqgcPRa84cZ4=;
	b=JvpboJHMjnheqjMbh8BaGQOM+runQXVaFu0zt7MJ8NVvAWdG8sEbu6No22T207nTNRdw
	 KojaheGaSm3iViEch7gfRvqNFKlFPu2D96diiv02aFg+rUYtfxunFpfgh93mOXQZniDyx
	 3QdJzZdFVjtfXfbBEf5SPQCOA8QnMg8jNggZo4X/WheoSOZhwUh9HksSXIzH66XnuR+H6
	 kJr2ImaaUvF4mNq2sVeKTKZSnys4hukfvb3bduR1cOoPRkSegJko5E9A2xObaaUYQmOmj
	 hvTkcUaiCU6KXMsDhUStmiy/rTHDnVruriRFhlFb1QaftXuzrCwxQ88h0nuE279TwPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KRC98440;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E478D606A31A;
	Mon, 23 Nov 2026 08:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KRC98440
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F0941F000D2;
	Mon, 23 Nov 2026 08:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795423258;
	bh=S4nHUrs17hshqm79V43YL5JWoREyieIuqgcPRa84cZ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KRC98440Sbcu0/HXB/kZNAVvUwr5dCOQWt33Q/FDBMcN7+QhlwP6PR6f9+ff0ewau
	 6s8MDk+eWYW3ZNrah84Po0ci3bOFrSMsnKqo3xOTZ62VNd8UCwte56Djhkuw7GwqDw
	 bnlm7FEnEodVR+TWGqL8RIAipyoUfLKjTLxdRHC8=
Date: Mon, 23 Nov 2026 09:40:55 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: linux-coco@lists.linux.dev, Dan Williams <djbw@kernel.org>,
	Leon Romanovsky <leon@kernel.org>,
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
Message-ID: <2026112325-emit-squeezing-5d96@gregkh>
References: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
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
In-Reply-To: <20261123083337.2731019-1-aneesh.kumar@kernel.org>

On Mon, Nov 23, 2026 at 02:03:27PM +0530, Aneesh Kumar K.V (Arm) wrote:
> This series adds the PCI/TSM support needed by a TEE Security Manager
> (TSM) driver in a confidential guest. It adds device lock/unlock,
> helpers for recording device acceptance and parsing MMIO reports, and
> DMA callbacks used during PCI driver attachment. The guest TSM driver and
> attestation commands using these interfaces are in follow-up series.
> 
> This series is based on Dan Williams' "[PATCH v2 00/19] PCI/TSM: TEE I/O
> infrastructure" posting [1], particularly the guest LOCK/UNLOCK, ACCEPT
> and MMIO report work [2-4]. It retains device_cc_accepted() and the
> confidential-device acceptance model from that posting, with changes
> adapted to the current PCI/TSM structures and reference APIs. Dan's
> device-core acceptance helper and per-host-bridge IDE stream reporting
> patch are also included.
> 
> This series does not adopt the Device Trust changes from Dan's "Device
> Evidence and Trust for PCI Security Protocol (TDISP)" [5]. That work is
> being developed separately in Leon Romanovsky's "driver core: Authorize
> device trust before driver binding" series, [6]. Confidential-device
> acceptance is kept separate from that driver-binding trust policy.

But it should not, as you are making driver core changes that will
mirror the same thing that that patchset is attempting to do.  Please
work together on this.

thanks,

greg k-h
