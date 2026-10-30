Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793369057;
	b=wh/Th8zmFRCFLwqzRFNfEan5UbQz9K+NnhL+CXrRxqSovCTv2t6QV7HtYXove+dBJYNJ
	 +geZYAqY1GxGnqI5jZX5/gULe3xnpry0tfmbafO4tnS6AvxNmSwve7MOjJyqGFLRme3Bk
	 iAhjG/mluD0bTi52sXWXzIgdrsOCpfDitEIkosFpGbCrFPGW0WeZayBACf44edNatkFyC
	 UAhXwqPVQ7FfwWW59MdR6kLdZ1GuQc9GKK5zgXfPTv9T1dkSSTu5aAqb2uxrAPMcaCpyL
	 Q7L6IXeMFHuNjpU8DPSuVtd0DheZ5qomflP1zmOmMawyYkQUiFgsFDqR/e4dWKYD+vQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793369057;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=LSIZZe//120Y6NC9XSNUIlM6NMk9sTlvtQB3HWbcsOY=;
	b=pX6ImLrK1WCIHbjbsQDvdlLnDCysWT7FZ6VqYnbbUtpMgikxIGbBRlb5wSIMdSfbFINx
	 fD0RkpS40F2RY7p5zGoabBFNikezsUPoIXHR8TyXrGsCKysIqaLnPUyCJ6Us4q5wt0VVf
	 LMiuScczZw8QCL4By4KmAAhdY4xk/1r4XxSesunw/HW0ghulJBLwmVPLDMkmmQ+mpnyqO
	 +l/SBBuj/g6zZJpVyvm1hdmEuFaT9GeVHoUgvFRHseb8o6IEUXRMQDJeoF+qOKGyLdmiz
	 jf3bmngbYm3ZzkjEo2953JpZ5mfzs9QNWl3i3PaKliUR70v5KaSLOVSRnJqj1Tq8WDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=HIMqx8gI;
	arc=none smtp.remote-ip=209.85.167.54
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23141606A31C
	for <patches@lists.linux.dev>; Fri, 30 Oct 2026 14:04:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 23141606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=HIMqx8gI
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5bfa7c09c9eso646914e87.2
        for <patches@lists.linux.dev>; Fri, 30 Oct 2026 07:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1793369055; x=1793973855; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LSIZZe//120Y6NC9XSNUIlM6NMk9sTlvtQB3HWbcsOY=;
        b=HIMqx8gIoFZBSwwRqIYgolAuYqstkwn7nWmeLP0qy3sMD8WW7gy9VtETYm7Dpp0Li3
         KZQV0G7KehFx4D4vVNue9rmsrYiN25DGJsgtWzTaj+B4wL5fXq4Yi4DAjhfKTMJjIsBi
         hcisWMydg5ciEY6uOrlGh1wz9nWkDN42E0UYWur98ASlw7dfgxnoIg5f12pfpXkx88P8
         CmsMqDewJwcDnRkkpDFuCccDsDJRx+BdprXgl/QQQ9M/K930WXzJE+i5znuBfx1/nVzV
         IiRk0pvtWEfb8PoCROFKs0HOt4vW740iIm14D7I5V/uBBs5OdZuD6BNRVJ1JhUKQq9RA
         VRbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793369055; x=1793973855;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LSIZZe//120Y6NC9XSNUIlM6NMk9sTlvtQB3HWbcsOY=;
        b=ziHfk/VmaoM6S5wYDTncOpqDdZKOVg4fDZB7IUVlzLQ78CjDiQlpjT68iW2dfUtEzT
         7MbZtVnpsQiIxWaFM45mwEhWv90E/s4HuAojtneA0cgJ7M9F2wcWpxlQq+88G6fFUCcz
         VecQKuW1lurR6dgRv44YM7B49HeiN5oXzLMWEiI3rMddjIyEeVlxJpW+HOLJ4j2gxenu
         8mciufYYRuWUV+eDAFGjDJ3QNpPGzLHcvfqVmIBE3HZJv09tiLHvM/Q1ibnRQnGP5QdK
         ZQNXIf1aquOXS8hxB/xzgWxI7W7amKkoie5XBabbQvhcQiqfYL/P/E1LdwUlK0/7FPyW
         5H3Q==
X-Forwarded-Encrypted: i=1; AKwUvBwHS6zFKW+SqoMx6huXr3M+sCaUtRYptK1Rmguq7soAMBnNKTH9KZVbE3fgzP6Ye4+x9Mr41Cxa@lists.linux.dev
X-Gm-Message-State: AFq9FYJzalvmJ+uCj4UvtFCY6p05TfTTOSASXWg3LEpJnQBhBn/9oY1J
	icszTCeMNasJdsSmeRwKMH6Bm8LsNb+RzQTr6fGumlGZnfTM4DHSLZRlUtG/93EZB84=
X-Gm-Gg: AYBFou3071AIg/8b0zPpyazTCFtTcRFpf8NCYkITjFnX9jHisFIOA2QW/jsIkNsfb5h
	o/k+VGCQypGw21ZrlDsizNHZu8dRBzI5hEBAQiXoIS1Q3Zvts/lSizba2Th9HK+Zi8xSz+keK1t
	KJchh5z5ZhKQOY9K8EAa7iUwmGKC8fvpAi8plHWgGJmJo+xiTe/Wsxn0+/wyJyCYQDaICnEQU2M
	SXCrw78RqK9BsWeX6SBF8aHhvobI9Zy75LFMc9CLPCHw2vIzB4s0xkFdmnpxlO9u1GqkrogCYpe
	ZVUQCSYFMr+PT0HpRaTqknpciDfjvbHYDgdGJaZmWljkZD5JTU7h5FQ2ys5J3HWJwax/KffP+gJ
	kwAmLUEVIgw/K4F8tHvcv5Mq71GidxN0ljd6lSL7M79xAQEIyRUbTEIVBcoon+LfeJtxntCPfJl
	q3A9Tx9zTEvgubMXoVXqOxpcYFsP31nesn1UV2opXV3tXmwX5YsU1NbQlWQjz0t7snl1obwHo1q
	v+tmaCXYbWV56xvMq7f7APrT/FS7tzBJdJQNx8fw+koSbyJlsZ64BAk5ysNaiuqQ/1ZAuVsDTkd
	FwXXLiNh78ttMB2qTGzz4ekKXNII54womAIEO/VP+vh7YzMZYDfciHBDvOMQWg==
X-Received: by 2002:a05:6512:3f14:b0:5be:64aa:af1 with SMTP id 2adb3069b0e04-5bfd951d51cmr751831e87.3.1793369055245;
        Fri, 30 Oct 2026 07:04:15 -0700 (PDT)
Received: from localhost ([140.209.217.212])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bfe072c9b4sm870e87.37.2026.10.30.07.04.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 07:04:14 -0700 (PDT)
Date: Fri, 30 Oct 2026 15:04:10 +0100
From: Jiri Pirko <jiri@resnulli.us>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: linux-coco@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>, 
	Alexey Kardashevskiy <aik@amd.com>, Xu Yilun <yilun.xu@linux.intel.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Steven Price <steven.price@arm.com>, Kiryl Shutsemau <kas@kernel.org>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Jonathan Cameron <jic23@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, patches@lists.linux.dev
Subject: Re: [RFC PATCH v1 08/11] PCI/TSM: Bind CTLV attestation to connected
 and locked contexts
Message-ID: <auSjbga8BFsUWwOc@FV6GYCPJ69>
References: <20261028152618.1356860-1-aneesh.kumar@kernel.org>
 <20261028152618.1356860-9-aneesh.kumar@kernel.org>
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
In-Reply-To: <20261028152618.1356860-9-aneesh.kumar@kernel.org>

Wed, Oct 28, 2026 at 04:26:15PM +0100, aneesh.kumar@kernel.org wrote:

[..]

>+int ctlv_attestation_pci_state_get_action(void *priv, struct ctlv_op_ctx *ctx,
>+		const struct ctlv_cursor *request, struct ctlv_cursor *reply)
>+{
>+	struct pci_tsm_attestation *pa = priv;
>+	struct pci_dev *pdev = pa->pdev;
>+	struct pci_tsm *tsm = pdev->tsm;
>+	bool accepted = device_cc_accepted(&pdev->dev);
>+	bool ok = !pci_attestation_reply(pa, reply);
>+
>+	if (tsm && tsm->dsm_dev == pdev) {
>+		struct pci_tsm_pf0 *pf0 = container_of(tsm, struct pci_tsm_pf0, base_tsm);
>+
>+		accepted = pf0->stream_connected;
>+	}
>+
>+	ok &= ctlv_attestation_pci_pci_connected_put(reply, tsm && tsm->dsm_dev);
>+	ok &= ctlv_attestation_pci_pci_locked_put(reply, tsm && !tsm->dsm_dev);
>+	ok &= ctlv_attestation_pci_pci_accepted_put(reply, accepted);
>+
>+	if (tsm) {
>+		ok &= ctlv_attestation_pci_pci_tsm_id_put(reply, tsm->tsm_dev->id);
>+		if (tsm->dsm_dev)
>+			ok &= ctlv_attestation_pci_pci_dsm_put(reply, pci_name(tsm->dsm_dev));
>+	}


I had in mind SPDM_GET for DISCOVERED/AUTHENTICATED and the selected
authentication slot, with guest TDISP state coming from
DEVSEC_STATE_GET. Instance lifetime already follows connect/lock and
disconnect/unlock.

Could we use those state models instead of adding another PCI-specific
connected/locked/accepted model? Also, pci.generation appears to be the
common device-generation under another attribute name, not a separate
counter, odd.

[..]
