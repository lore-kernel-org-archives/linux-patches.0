Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793734733;
	b=FU/et0vP6hcsPYC9aBIunOlh9ivRxoDjJvXWtHhTRRxO3IaiWwarKgChmjQg94g0aEfw
	 0PdvQeox6Ij3WVtNcd6ukltVEl4r4uqTjTwSKR/rfGgB0pXQWKmIFwTvWAWa7kHFKcxys
	 SQAcfJY2xMfmt4MBrlBoiBSCPp/j2viumrqpwG98W2zC707pgwUYrMLgaH4HyxczxY8pJ
	 44jE5xK1HEoptPEE3vD0HrVP9ziowYF4Xt2vaK05asX7GidtvloOcRHdjKq30hSlAyU3s
	 LxCcg+vnsyICr+1uNcR7uMqy2Fx1Hp5uW8gZbJp7/hyW/wCQmi8fmfanVANWxm2B97g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793734733;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TK3utwnIPX37GwcC6jBJrNjTtS9pS+ECr0ZBshoSLgk=;
	b=wTCf7xTZfjmy/P9JlgohyifbIlDZczyxY6yW21asx7L5SRYwPDh5EQSqtDBZle2Jc3jW
	 4zUcIVOF7oVXBmmn+ds2l1VImt7NolzC/leCIrm/i9Rp/CcfGHPOlc1ks3Rnlcrl4pdsl
	 nQS6yzWTAoJV0/J8Ml/3ebkrFwhATntE1T7CK0dEymsvbrugfjVdOePRnBcsglPt8NZkK
	 C3/TQlHxEuB4x3AEQNmdFkPCdJUWhNDpS31rL080Gb6VIWYmKT1Q7w2jfdGGtWc4nT3Hx
	 DrloGtDk6Srsw38ylSVOp9uqZwfcl+Ai8OfTqvmm+f9KbQdJrLG1XaHgJkdg2tZhg4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=TX+afQ5O;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC5B606A328
	for <patches@lists.linux.dev>; Tue,  3 Nov 2026 19:38:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ECC5B606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=TX+afQ5O
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a2072b9832so6732905e9.1
        for <patches@lists.linux.dev>; Tue, 03 Nov 2026 11:38:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793734731; x=1794339531; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TK3utwnIPX37GwcC6jBJrNjTtS9pS+ECr0ZBshoSLgk=;
        b=TX+afQ5OtmLi0K/jNFhb5EjLFNdHPjZexNLXbOdK2n5L5lLYEavfh1RJezjq0Ewnb8
         uMFSW+ADG6GkMoE/+t5MPs5slp/rIsftxgRNBloTBYJpOSWoXuI4lnWWgjjMc7c6i9r/
         FnpsINYLolXqce+OhmVw3GnOSYu1JyZW1mcc2VUzZ4QJQrjJUKVletpO7pdts0qA+O2O
         G64bKp/+JAcwyQhOzFhvtfXS6xX1pIfP+/0ZTBb2utw+aMk+4705defFpSoGrnDRuwZ7
         MShz/Pjj0dmSZj29lOYd/kbI3ZRBb66RbEb/ATVdtDsufZXApjfvENXVLF/vHz2g4Z74
         7ktA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793734731; x=1794339531;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TK3utwnIPX37GwcC6jBJrNjTtS9pS+ECr0ZBshoSLgk=;
        b=NFgrdTSHrg++VzIeFw9VdXAKWOUC5Z/nGjaK4TTI6/ZRGyhhmYCalvquIG+nTN8OZT
         0rTUAie89MwR5brXNxvSvyvdxHSUh2Sk3wno6DVAqzUAqbGEs22K987b/96JHfvE7zX1
         rPsfpDLVkUdcOM+nDfY7bn0jObShKd1lmxLFK4e7o6deBgOxGqHz8xUHtAD4HVW2WO1N
         mBm+L/QQkbbMP45uGVt9LuMispbKE0WuCi0yOFTHdB7ikgzBFLIf+zYBf1TuFcYjXW+H
         aGBPNCc9SpcWK+gpwM+BqUxy+EdTmyIjia9m6hu/Ep1xpDTrdGR2u/c5ocU2TDpntP4q
         gNWA==
X-Forwarded-Encrypted: i=1; AKwUvBwxXgN8Qt/A67FDFj/MMyolLWoGcI4z5AtuNhjWX7BRvy9gvaIROJS/CkX9eFK/+c8fIuunAtAx@lists.linux.dev
X-Gm-Message-State: APuU4Z+GKIl6iaZ1Ci1mwWxWr5UBCm6QZazmfSLQ0IrwdUR4p5fsKy6W
	KKP4gMKGtff9Hhl1LntoMLSYuDCNX7tem7uLGed4XatrYZaQPnnDTjKQ
X-Gm-Gg: AYBFou2e9NWgYNFu1Zof3KVp47hdGquyq1+f2+9wG3Cjh7FW8y00bGUaoK6hC1ZEm+Y
	gUoPn0rgOWnNccNKF4ApF6RGY0oyYdf48JmcgjrV1j8P/eUkGj50P3Blxa4iVE5OgzoXUqc2q2w
	uZvXrUpfFchJcQ+78+s1OrJzgd8vNMDCP4Y8+MlZ7z3GJSgWuwKRbDht8DCQDnKsKl+oDJYiuEP
	HQezVoxSIF1h0NlxJoNa8o2xTJqoejwvRmsQ4upSg/h2eLrdLMILlIoOIwHCo33CHMr32nXHiKU
	OAaj6ManL32DYC7Ps50KFNK/LhC6zgLozGj5cYAAxUEog10RCW39TJeSXDhs/hw5g8qnVPiA/j9
	RKkBbKwENWinZ0eDJjPpljCkhDmlOOLeL4D118nn8LEy1hEGSC64ZDjxk6hbdwC8d+DIVVQbe/Q
	eZgofv6qC8XWDhDm5pPkjlJ31dJDcEe6QI25YNCuwyh4GyflN2VoY8WF7iGmCq/eQaPWcS9iVoq
	OEVB+YiUqiGDOYtgIdVvFF537g2MYjHJ52d9gcuqDfYjyz9pGR4m9Zhnczdx4EFuVD8Q/fIBqpW
	5d/0P5M/skF1lqnkW6GZENFe/O+4BFLC1d2kCQvhugHxzh8VtYN0Fjfg4nryFTZc9bICNdTmFZ3
	UcwgWXutnSqjZ2IWgv6LqbgR/Ou5deiJh35QZSgc1S8RVhqnpVdYoSIjF1ISaM9n5Vw==
X-Received: by 2002:a05:600c:848c:b0:4a3:5da2:38ae with SMTP id 5b1f17b1804b1-4ac17a3628emr326325635e9.14.1793734731206;
        Tue, 03 Nov 2026 11:38:51 -0800 (PST)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b2a5372d8bsm87303325e9.0.2026.11.03.11.38.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Nov 2026 11:38:50 -0800 (PST)
From: Fred Griffoul <griffoul@gmail.com>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	linux-coco@lists.linux.dev
Cc: Ackerley Tng <ackerleytng@google.com>,
	Alex Williamson <alex@shazbot.org>,
	David Woodhouse <dwmw2@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sean Christopherson <seanjc@google.com>,
	Will Deacon <will@kernel.org>,
	Alexey Kardashevskiy <aik@amd.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	iommu@lists.linux.dev,
	kvm@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [RFC PATCH v3 07/13] KVM: guest_memfd: Support private/shared conversion of device memory
Date: Tue,  3 Nov 2026 19:38:50 +0000
Message-ID: <20261103193850.15363-1-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261101071928.2462549-8-aneesh.kumar@kernel.org>
References: <20261101071928.2462549-8-aneesh.kumar@kernel.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org> writes:

> +			if (!slot)
> +				return -EINVAL;

[...]

> +			ret = kvm_arch_gmem_device_map(gi->device.kvm, slot, gpa,
> +						       (u64)(high - first) << PAGE_SHIFT,
> +						       PFN_PHYS(pfn));
> +			if (ret)
> +				return ret;

Unless I'm missing something, these returns leave the pieces already
mapped in place, while the attributes stay shared. A later conversion
to shared would then find nothing to do, and a retry of this
conversion would run into the pieces that are mapped.

Would it make sense for the error path to unmap what was mapped, e.g.
with kvm_gmem_invalidate_start() and KVM_FILTER_PRIVATE on the range?

Fred
