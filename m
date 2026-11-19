Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.219.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795125290;
	b=Z7Ef1QBtwCUO6rYvub/hVVPfYXapiFCLbh065Tdabydj6qBrlN8QjP9MGR5sBHg3fumE
	 IqMTVptIPwGgatGldI6LAcaDXGpfij0X7hxdmjR3+QioAkeH7mo7sPllcJwkXgV6gSd7m
	 tLT+Zsvd3h3FHQ473ZJaomInoa/K7dicfmW7HvEVa8eJsF5zyQZBpPbhwItPp1itGyg5a
	 mabOcSM11NayUeIPM6zXp4HDP849Jdy3iMoqtlClwVrX9kkD11KIO/tC2IPpXnFCyufZX
	 mj0wadPdfB5TgdSy90W+XU6uW2GXBWaNGmbr8R+ueAOSyE0H3Z68FT81lMak5O6qy4A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795125290;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:In-Reply-To:References:MIME-Version:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=9oWwO0cY+zSAmEBywqcvt5EowD1mRhhhpuanmPj0nj4=;
	b=srnBxUxZY4M9ykhO1pFgko34J8HHWvC87DPNzOUxkGyFFKnBUtoxoEP+5LAmKUHiPoWF
	 /zXmfXGdSFAj3if2BIQIeDFxkomDOxHJ0f7XkbOYgDZwO/b971PfZM8amiprAcFWkyLEh
	 kxGbO+PQQ4MkIviPq9BWaDeXcYhLbb5MzcP3PpxaUE+c/W1Q6HoNt2j98TyKJFOVpu52s
	 0q03mx/NgSVtA/tE1Y/q6iY1enSQAH8Y072mMjCGoJT4ErOBvPKttxHdwdyTFvb+SpkYm
	 0n7TXBEkEbxtNfo6jU1Vu9wWMES7Hnhq0PibUKJ5oa0vGdlmOP+dYALrF3xl3g1YUeg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=fpAsY1N3;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.219.51
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA492606A324
	for <patches@lists.linux.dev>; Thu, 19 Nov 2026 21:54:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EA492606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=fpAsY1N3
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-9212dac247aso3429636d6.1
        for <patches@lists.linux.dev>; Thu, 19 Nov 2026 13:54:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795125289; cv=none;
        d=google.com; s=arc-20260327;
        b=PXJHzCDZLa03K7COcm3iv6b+fisdx+sEZSPdqeLhAXSMVGpd8KoMmGFaapnNSu7zWX
         LGcqdoWK+aWHrxKmjc1sivc+CqqIRj1fLaDdvpOTpkB2BdF74c7LO7OdCw12hgDYjUDU
         kxgZCxQ/DSjIcbGxLo7XVFP6DhMB+6kad7VDBlRWYURwHKsDA2JLoiXB4bbxt19RXERW
         nF/7OJebEnlcB3rCv+nx+sLlGqo3HT56siQ9ZDV41+/fE4JnsbWhJ76Bhz2XhpxEjPZ9
         hPbjD0+1egq7J+qidEJRCx3CS37HRUEPhWF7X9VNoYq4la50v0SjF+7z8gK+iFC6qqOe
         qJJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=9oWwO0cY+zSAmEBywqcvt5EowD1mRhhhpuanmPj0nj4=;
        fh=/7lX8ZgeyAI9c1UqIL143rWh+X9np6Y6gWtkOffTju0=;
        b=pOwAAnsyxxDqJ/2KweGdYahc/klSlT/fd7T9HUCAx16ACGIfDYFrILpqXlUk1prqXr
         mb9CCD1gujcfXVMCQcXgOMPgAbECdTbUPw//qQr3cD5EusayXAYOQ0kBKmEPqQTWp5CI
         uMr2GiacNCSugOjNag1N/rhIBlDI8RO4GtTNIctyOG+xV0YWNURLX+eX9LwYRgl90O99
         nDlYksKqdYalSmsd8U8pRy2FNGtTKPSg3lEKtEsz2XGrm/luW5pB2hdI5UoCP3HDhnAN
         owzU6oUP8Vha5fz/2T6YzBsjDYHEvtUDhvmSV7+W7qTpNS5EVIbtrpnp1bDzEGclyStr
         zl6g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795125289; x=1795730089; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9oWwO0cY+zSAmEBywqcvt5EowD1mRhhhpuanmPj0nj4=;
        b=fpAsY1N3FV2Of70tXyWKQWKTu6xYGYAI33A/Ihax+6lWHI/OrFOXK6YEt+6vWaOHMn
         XJm96u7gYJ0v0KdIjABIehFX608zd5QRZhyEzbWQpaEI3xG8gEIpJsda5CQQz3hAIkj1
         iFn2uGcvQFOrWsuYLJo3tcD/DmUYbRumimCuf5OZtkgjIT9yCWzGfxx9hCr6/Y/HZI6s
         S1srAQDWFGdxnjZfmulXjJeasuEyAg1fkIfUI8xazQV5JhEffhAR6RDnenCVsf9Xc3fX
         OiuspCGQDVCUEOCq77UKTbnJGc355J2QsYxzOCfEc4hrfGojM4G+Xvc3FXQLOkYq+Siw
         6hSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795125289; x=1795730089;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9oWwO0cY+zSAmEBywqcvt5EowD1mRhhhpuanmPj0nj4=;
        b=njZJJus6gM/6+unYEWKMamQYAx2D1bhtklgQQ19GVBZ6wLZOydBBDjYZdXGadlekC2
         f7ZiEYWLHy6OV+o8EcnvXfX85MoQVX72P8Sk1pXYzCetHsPmSE16y/9iuPdpsPY66yFO
         zMLsu2pn76gmnFs/Iiquu5RmNlCzhno9qGKWwSnqKJ46dcZ0H05mN3Fqfc0IlDmWihR8
         JMeVuXqsLzJyclSJDCckQdEaVo16xV4Kc+ZcsS0dPs2DhFsac+482Kou78jnGlMHBP9Q
         kcOAW0jiHYI9Ux74X0JjNWKwmljP2mZT5FR83mi13X//m8e1E27cSCFCdIazCVqG67Ax
         s8mg==
X-Forwarded-Encrypted: i=1; AL+hErGmbigDaAuHfu2qZwFd7XxZt5GyOD8lKJEmhNklRj2KmWn4Q0cacOfGTJllRajp9NWfUEfaPguY@lists.linux.dev
X-Gm-Message-State: APuU4Z/xg4XZK0DvL6XD7+hUoujSeOyctYfDsnwYhVI39Q63UNn2qxPn
	0gVCosV2VFX57H/buTCcqCvyjUpzF0f635WOfwciaqDD9jmt0qE20ry+a45i3xXYUb6A7tAwCYJ
	hKPRdwehCNIevzHIvA3B/gEn6XZljpZz8gZOQiaJy
X-Gm-Gg: AZFdTZdBdM9HToySKnMIrvutLGncXkxKHQGoZf1USXs35+jYoz1sknMdcGoinCMh4bi
	vyy2o0UD5HvAl51sOVfT3TFZeHOKmIdAZFR8Flq5chCLc08jTNi2I1DjrBTMYbBIdrDVXL7aB0d
	Lt6VYdGn7a16ffnXHd/bu6BJF1qryRYtIvMaocKw9ZI5ISYnbqQ5+zkbT7X0hQUZVvv64sCe+yv
	4ydqOFYTid3v572fKWrQ4ipBG0QRFTX88JY3V618sltcaVwTg/xhBSfCxemhOSXnaGj3VBkQbZR
	/kLXLxXxOJI8g6huZw56DNdhT3yAmGf7AoviGefCHWWmKIGvTlG/tUUpS9nJAgTb8z0zRtyeRgw
	peMiWzp7bLjVmpcchyMrZV4GSx9Iir6dPDu7kg4eXFhgdehkYDRWIK1ayeMu+guT+uP5TG1k38W
	mfLnx8v5VqRx5GKwtmzUZgEg==
X-Received: by 2002:a05:6214:4018:b0:921:3369:a766 with SMTP id
 6a1803df08f44-92134a90270mr18304526d6.37.1795125287959; Thu, 19 Nov 2026
 13:54:47 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 19 Nov 2026 13:54:46 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20261112074120.1570072-1-aneesh.kumar@kernel.org>
References: <20261112074120.1570072-1-aneesh.kumar@kernel.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Date: Thu, 19 Nov 2026 13:54:46 -0800
X-Gm-Features: Aa3M54oXacZEF20KAAo0a9xrzHva6i-aYhx3GSm4FZG9y6dnhRg5XpywqLRfWns
Message-ID: <CAEvNRgFKfGEzMzAHCqGv4T3YdkjFbLKjuHW-CR9V0OzYRzTu-Q@mail.gmail.com>
Subject: Re: [RFC PATCH v5 00/16] KVM: guest_memfd: Add a common framework for
 device memory providers
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>, linux-coco@lists.linux.dev
Cc: David Woodhouse <dwmw2@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Alexey Kardashevskiy <aik@amd.com>, Xu Yilun <yilun.xu@linux.intel.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Steven Price <steven.price@arm.com>, Fred Griffoul <griffoul@gmail.com>, iommu@lists.linux.dev, 
	kvm@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org> writes:

> Confidential device assignment needs guest_memfd to manage device MMIO as
> well as RAM. Device resources such as PCI BARs supply PFNs directly, and
> their protected mappings need architecture-specific map and unmap
> operations.
>
> This series adds the common guest_memfd support needed by device memory
> providers. It builds on the resource-provider API [1] and the existing support
> for folios and RAM PFNs.
>
> The VFIO provider, IOMMUFD integration and Arm CCA implementation are
> available together at:
>
>   https://git.gitlab.arm.com/linux-arm/linux-cca.git cca/topics/cca-da-gmem-backend-v5
>
> This series depends on the resource-provider groundwork from:
> [1] https://lore.kernel.org/all/20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com
>

Just a quick update. I'm still interested, just tied up with internal
work. I'll get to this as soon as I can.

>
> [...snip...]
>
