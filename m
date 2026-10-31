Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793419781;
	b=NKgd0bhk/QgiLS4GS/jB7zkkWR2tAks3Vc13r6bqvPHDmt2CjbiE2Cl9O/Zc+bvwwBpe
	 bQq7Pc3bZePQmkpiugnPZUwk1JIKnY5kTZouC4A9g0CNgL2t2f8SUPvaogVzHl1mp2k6D
	 4Bi4fGlxvX+i7wX93p6/eFD4Tx371QE5pEVbcANFl6nSbIXUZ+PsYU1uTJugKb/tUBWhp
	 s90iAn/FScypAkMBB8HklleumHLE3OgBRFl2XlFypfkBZF3IvcAzRHclik6xEuu5MUnW2
	 VGGJMcuC+Rz431aIjcUOX7u5mc/aAc1YZnsGb6LBQYdizU6YNx921Vykdl1ZJnM1Ccw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793419781;
	h=Received:DKIM-Signature:X-Mailer:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:MIME-Version:Content-Type;
	bh=aAFd1Osv5M7suApYUvHmPaqN8qPqZG2Y5RH+DfHeAcs=;
	b=cxjaTCwElP57Mt3ByREwyY7N4+cHEG4+wDMzX253GD2kIJHHfGScpAAjVV6euuxqLEg2
	 OzHEyrmVJIChPp5ODCfmKH/BbvUbA2pIQKm1kwEsc44PQ0ZxIeI4K7MLkhQbmPEy07BfP
	 DRsFCJTBrP06ipckwdI1UBve4EZIFMCdPmkUrIHUPQTxqPm5eFoWS/01jtvGgEszWquQl
	 KMhLSJ6/CfSDAD7LAbtbEze75B2LYVXoWD/kf4nqgW0rRd7VWUNcy2NSE9ygKtOLuP7c3
	 rzs3H2yT1UA0spcGREKu7KyGqiB1PDYlxD1hXx0WSVeY/K0Qd3tYv2p0+3FYKhh4eiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ljqG8MMC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05892606A31A;
	Sat, 31 Oct 2026 04:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ljqG8MMC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E1FF1F0093A;
	Sat, 31 Oct 2026 04:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793419780;
	bh=aAFd1Osv5M7suApYUvHmPaqN8qPqZG2Y5RH+DfHeAcs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=ljqG8MMC79nHvUXZ/IIOV+wC3qH5qMF0nxrAPXkp6HlIdVSzYCLO2+g5vdWKcmlSG
	 GZV6m2TzgqaWQdNs3EMFAvqPJD+jf9kw04WGuUCebWy9hp+TLnCEb8dgwoS0PON/Xa
	 SOeRCX3X1+Mj0L56vE1QpBna3sak7HstiZdURwbTwRhIhV1ORdiX8x3z9WnSmOpXRb
	 dgh9Leag/hnWQrkBMKA8itSCZH09ldieZ9wuA3Cbip36ejE4hYx8e7s/Emuh9+7k56
	 pPlPi3pZvmXFVPYEh8Q/u2pGMHd+QtsYz/LzQVzspWWFN4BO5/OhrUg7UVas88liEH
	 3tQDLI2sPOGqw==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Jiri Pirko <jiri@resnulli.us>
Cc: linux-coco@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>, patches@lists.linux.dev
Subject: Re: [RFC PATCH v1 03/11] attestation: Enter secure operation when
 evidence is accepted
In-Reply-To: <auSfroz-gNb62nMG@FV6GYCPJ69>
References: <20261028152618.1356860-1-aneesh.kumar@kernel.org>
 <20261028152618.1356860-4-aneesh.kumar@kernel.org>
 <auSfroz-gNb62nMG@FV6GYCPJ69>
Date: Sat, 31 Oct 2026 09:39:30 +0530
Message-ID: <yq5ajymya4ud.fsf@kernel.org>
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

Jiri Pirko <jiri@resnulli.us> writes:

> Wed, Oct 28, 2026 at 04:26:10PM +0100, aneesh.kumar@kernel.org wrote:
>>Use EVIDENCE_ACCEPT to enter secure operation after userspace has
>>checked the evidence. Check the referenced device and evidence
>>generations before calling the driver, and record acceptance on success.
>>
>>Remove the separate DEVSEC_RUN command and callback.
>>
>>Keep DEVSEC_STATE_GET so userspace can read both evidence acceptance and
>>device state. Clearing acceptance does not undo the device state change.
>>For example, with the following PCI/TSM patches:
>
> Note that the published wip_attestation_all_1 baseline still
> has DEVSEC_RUN. I am planning this merge into EVIDENCE_ACCEPT for
> my next revision, which is not pushed yet.
>

I agree with your comments here and in the other emails regarding
attestation. I will wait for the next revision of your attestation
series. If you can accommodate these changes there, I can rework my
patches accordingly.

Could you also add the ctlv-attestation-spdm family so that I can base
the PCI/TSM changes on top of it?

-aneesh
