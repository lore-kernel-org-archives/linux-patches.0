Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793251813;
	b=pCWD0jeTV5JKDwsu01emfRfKG0iQTqJsnuCTUkvU+Gh3VAvKVH+Dz4j/PrsPJ7HaSeiD
	 lwzsE6adR2F7JxfckhejJ1B1dF4p8uGkdnEYIqzHAIXMu1nXmaAUVBP6XkM96cDaSEO1B
	 z8zGDFX3Y9c6H8/5kY7rxH2YaAQr1Z6HSdj+T0Kw1YZ74mq6ogJSyk1x0oIjo7K+snjQw
	 A0+iN5sroopnYFLD4jhDTHQ/EPaKtR6Bn8xC38eQU2r6PIBXRyu1jNqzjY5svj7Hh1R38
	 PrUwME+8Kg9cRBalEZn9J9eIIFLt8uFiiGnVp0ER2PXLmSp67BtfU57y4InWMXmLRXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793251813;
	h=Received:DKIM-Signature:X-Mailer:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:MIME-Version:Content-Type;
	bh=eRsa7Nuxwuuj+/qV5ip5IGQIJP2OU2Hvd4m6ivmoiEo=;
	b=jT0x6Dzi59rE50zQLAOAUwILsY4bO0uEafo/cr2/D/j/yLkXs0JuTiSjaMs7c7Olay2b
	 zJMBgEf0JyNJ1hu7K9ImTIiemvKe5q/fHEz5YQfgInq4Ro9e0xsSAosN4+oq7RrKhguOR
	 1SgVo/uKzqGsruUUoHgh1kAUgYT2HqLuwXOs7b4M5mCElUCVsbQC34ZyBmUZ9lPNsr83o
	 A4XVa3pRutUqTPCZq0i14MAzAytUiD1teHrON7gxrWeVqFBBlo6zQaFq1JlnA0xZw/mig
	 0D6wwOlE4kxGXdFpaglrRwc/uakAZvLUJJzxJuQi7DjeppdFvX712SLrG0T0DSK/Jqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WHxtq9Zk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B12606A31A;
	Thu, 29 Oct 2026 05:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WHxtq9Zk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34A6E1F01825;
	Thu, 29 Oct 2026 05:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793251812;
	bh=eRsa7Nuxwuuj+/qV5ip5IGQIJP2OU2Hvd4m6ivmoiEo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=WHxtq9ZkHpkGaJZ+D3E+m73w1q/uxVP0mkcrYxNJhOWOoSZn7dM2kVPFOab4xIQPS
	 YoTSOnVOHffrGm+Zat0RtURppiKMZXXZCybQv66lcGaV+8Yx0ZbYoqu2zSYfL6Zl1k
	 TQotYYsSVxRS1lu+oD6RVNFumlSTwgGb5x91ZZtcHj3HUozwlNnb8iFsFbbPzfyQAS
	 Y8LLZnHC+Z9RPGfDQL655OpEe8bntUKtUC1pwQmylHU2eN67DEBp8h5DiksHiVHjbj
	 vPYjBkK1FMLxTCAdm03hn2IKvpTA0hVl+ruFg+TLsMw4PPWn/ECifUVP+3Q7raoRka
	 y+MQ5hThU423A==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Dave Jiang <dave.jiang@intel.com>, linux-coco@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>
Cc: Jiri Pirko <jiri@resnulli.us>, Kevin Tian <kevin.tian@intel.com>,
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
Subject: Re: [RFC PATCH v1 08/11] PCI/TSM: Bind CTLV attestation to
 connected and locked contexts
In-Reply-To: <9ff72d51-3933-4f2e-a854-c0f9695c0c04@intel.com>
References: <20261028152618.1356860-1-aneesh.kumar@kernel.org>
 <20261028152618.1356860-9-aneesh.kumar@kernel.org>
 <9ff72d51-3933-4f2e-a854-c0f9695c0c04@intel.com>
Date: Thu, 29 Oct 2026 11:00:03 +0530
Message-ID: <yq5ajyn1axb8.fsf@kernel.org>
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

Dave Jiang <dave.jiang@intel.com> writes:

> On 10/28/26 8:26 AM, Aneesh Kumar K.V (Arm) wrote:
>

 [ ... 232 lines skipped ... ] 

>> +	ops = tsm->tsm_dev->pci_ops;
>> +	if (!ops->refresh_evidence)
>> +		return -EOPNOTSUPP;
>> +
>> +	ret = ops->refresh_evidence(tsm, type, 0, (void *)challenge, length);
>> +	/* Even a failed refresh may have changed device state. Retire all verdicts. */
>> +	if (ret)
>> +		tsm->error = true;
>
> Does this make any refresh failure fatal until unlock? The CCA refresh
> in 11/11 says "failure preserve the old cache", but with tsm->error
> set I don't think the cache can be read or accepted?
>

Yes. The generic layer treats an evidence refresh failure as fatal. The
backend can decide how to present that failure.

>
> The cached evidence is still the lock's evidence, collected after the
> lock. And per the cover letter a failed refresh already invalidates
> the earlier generations. Should the backend decide instead, and set
> tsm->error itself when it can't tell what happened to the device?
>

For the CCA backend, evidence is replaced only after successful
validation. If validation fails, the cached evidence remains unchanged.
However, we could instead discard the existing evidence cache when a
refresh starts.

>
> Also, this builds on struct pci_tsm_evidence from Dan's March posting
> [1]. The TDX guest RFC [2] and AMD's SEV-TIO guest RFC [3] both use
> device_evidence_create() from his July posting [4]. Is the plan to go
> with pci_tsm_evidence and drop device_evidence? Would help to know
> which one to build the TDX guest side on.
>
> [1] https://lore.kernel.org/all/20260303000207.1836586-1-dan.j.williams@intel.com/
> [2] https://lore.kernel.org/all/20260924041032.1096569-1-zhenzhong.duan@intel.com/
> [3] https://lore.kernel.org/all/20260916115159.1938195-16-aik@amd.com/
> [4] https://lore.kernel.org/all/20260705220819.2472765-1-djbw@kernel.org/
>

The include/linux/attestation.h do cover

enum attestation_device_trust_state {
	ATTESTATION_DEVICE_TRUST_UNSET =
		CTLV_ATTESTATION_DEVICE_TRUST_STATE_UNSET,
	ATTESTATION_DEVICE_TRUST_NONE =
		CTLV_ATTESTATION_DEVICE_TRUST_STATE_NONE,
	ATTESTATION_DEVICE_TRUST_ADVERSARY =
		CTLV_ATTESTATION_DEVICE_TRUST_STATE_ADVERSARY,
	ATTESTATION_DEVICE_TRUST_AUTO =
		CTLV_ATTESTATION_DEVICE_TRUST_STATE_AUTO,
	ATTESTATION_DEVICE_TRUST_TCB = CTLV_ATTESTATION_DEVICE_TRUST_STATE_TCB,
};

I am still unclear how this will interact with generic device trust. We
can only determine that after reviewing the device trust series.

Leon,
are there any plans to post it?

For the current PCI/TSM CTLV implementation, however, it makes sense to
treat evidence as local to the TSM and keep it in pci_tsm_evidence.

-aneesh
