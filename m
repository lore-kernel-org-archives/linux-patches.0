Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795485888;
	b=hYVo84HSOusRs0M+I6ms3t/gIwK78h86nDLleo/jfNii2mMQ58kDdFm4RpfEq9TmaABW
	 iDOpSfDQTL2rY88+xgulBCkegmtItcBgwVYSqUPsqi1fIhHWBxGax4Xn+42VCuk6yuKT0
	 7z0ijJA3H+O80qsCAFkYB74u4XtKHA729n9zad2JcgatQnDUh6pDSiiNZaIlhJ/Y/Dbrz
	 Odwrc5h44zEK2W6SxopJHo3b7xIDktQdCAD/ezBi9HK+mCYoqBOCx7RSped90VdFqpL01
	 UtI194uEr50bDrRo7770YwZlmpHkqdsnr6JmD6SyvYDEW3K73YYgj8n9O/blqE1FbQw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795485888;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=QZ8jeJhff8TwVzDr8mq7hnVn9Uwjnn1WsiAHJK7NNrs=;
	b=KG8gGORwwAk5cbSmfNew9w9x51j0eE8LXdn4QtNYana4Zg2vKNw48fxT5OOtPMfWuTdt
	 7g+ilKM/wgRsq8zN7hqDCKzag+egkGziJr+d69DTCyR9+ZNetfx0pdo/KFyT0eHiHb7ib
	 F7m8wthFqVyXf/kKvEAv2ZcE410qmvHNrwaTFwWJYcHOl26J/IRxR8LtrvwP8jZtO5Oqp
	 MPwgeTUPV3L14QeDUFy3DblRXud060SBv7UkLEkkAYshu9j+E7nYYXIdtwSVa1mpbUbhv
	 kUpdjP+TnkAQVUsCBG2TXrwohkI9UWzTdLOG0eQYFYobMqhFVnZfLfqc2LxyN4Cq7xw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Au1HBdhe;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.42
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14084606A326
	for <patches@lists.linux.dev>; Tue, 24 Nov 2026 02:04:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 14084606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Au1HBdhe
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5be58ad9600so19739e87.0
        for <patches@lists.linux.dev>; Mon, 23 Nov 2026 18:04:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795485886; cv=none;
        d=google.com; s=arc-20260327;
        b=mrnhDZ0cCIBj+JV4XKChAl7J8+0TbL7B6EPAHXfPDx+vTcgxnmcIlqxlbSsxJrLo1R
         gCWkbqqXUVaewa66p6h5IUTnpp/N1EDWQ0BYZ9FqafLOfooxGqBKBBdsbVYzv3npRLb3
         jTAwe4B7rs0pv3NuOJ048rHcPplclVvw0AYraxu+SQkc/uYEznj6pb612aYIbwU/bmBr
         W4KE7IQ55BN6YVhstqpWN+S2WJP7lQsV9/svw1Nx8hK0Nx2SUX0s+KL6rg8Lk/LuaN+w
         owapR26yHwpxJS980uI7nf/qRkzaMLkS4kVomp9sMUicJPHW7no2yCiAOpwQP4LLiraD
         M2XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QZ8jeJhff8TwVzDr8mq7hnVn9Uwjnn1WsiAHJK7NNrs=;
        fh=lgnU14s0Y6+QoZpT4xO2xufr3SqWXuLqgsuKwl6EqYU=;
        b=mhIHjOdA/5bPXUwBslVVxuY58arVf1166TT47UuOv/v9jit7Db4RQEhx+OLBfKHx1S
         heyOkWUc6msxd+EQycD84vg6fzR1ghdnmv2CGznW+FdcLFHg73gCN8xMwyhsQGKzvTvh
         1sEgr5/Tt21+9sX4I94qTWCQQdy59R+RZAg/7Yiz0k8af7M/fkMYNya+OU0rqL1g6IyG
         2jf8KvRu8aq/X7INpR0yUjq+noH4tZf8efObVefgUYFay9SJ56J3iJ2rOKU4e+AOXBfs
         yx+0LIdn+fPxsEPkfBNl+sqAuswqFiYuhW+kNLFIbaSVRweHXhbs17YrKYGuKLP0Zc2O
         Ph8g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795485886; x=1796090686; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QZ8jeJhff8TwVzDr8mq7hnVn9Uwjnn1WsiAHJK7NNrs=;
        b=Au1HBdheIzpAbd2JoZkJkQuYbnbYLjNGax+9Hgqt/+wgW+dQkphN03XyI7+UWrLxw5
         izZydNoKXNvErjrsKMm2ue+FEhfe50HtcfX6uJGyctgWhIG8mZ11UuqS7K54uMoj7+9M
         eKapPGz7xh/ofqlTmLTn5qyO7ylq6eZ+jI+9AeTed6iskeCWbWx8tRDs8GpOv3/i0LMy
         xJoVMQfgJIDlbfl9cynDPzxBpDF+theiAdtA8DmYSpNLp19XPjBmDBrqkieFxaKbgGIy
         X0JzD9V+vycsTLSKbic559tNb6t/Ay0vyk0+UhUiw/xYLbSDQ+oX7+6ICznujlH2Y44D
         dUKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795485886; x=1796090686;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QZ8jeJhff8TwVzDr8mq7hnVn9Uwjnn1WsiAHJK7NNrs=;
        b=KM+gjhiYN82YSthZFGc51NaSQ+EHbWIBjLGfJanlyo5ZbxeGJQC92bAXT8MzapgC6D
         5g4Zh5AFfeBUA2j+OUVwBmXp2VpX+wfRBVEZS8Yj22M0vPkKSlzfduDNanf2X/Lw+xhr
         hVmws4Y88LB0w9WEMin+06a5+br++AqvAGcOMHOD6fKkQDLK9K5xcvoJb34l+vPpouZB
         T5Z8Mth31NnW3jKk9gZniy5jTlIZRXm7da7lTwL7f1/YYkS/nCR3B0VlFZxd8NlXoPHN
         HYApQqBN3qxR+LsYc54kg1OiS7g3r9CT1LqW0TzzKfgezs//a+i03lA5ZCLKrXt7lfx5
         33zw==
X-Forwarded-Encrypted: i=1; AL+hErHniDfswM1gY5m/Kmo3DoWyzNjGvCym73YR4+nnnyeAcUHUqrax3JGPKKkz+vwbaHk1+X5fJmJz@lists.linux.dev
X-Gm-Message-State: APuU4Z9jePj+BUDBw2SpVqPpf7QWaZB7WIqF1124J4/iMk0doZcbxxk+
	CEkLV2VS/114iaimjS90HBvQAL3ZK4G16cPVdH2S5UAjHIbKhSbAxNm4crqCCeRHe3ACZHuBu+5
	UV8gaVEOfGzi4o5y9HruLEHTEVaRO7K2RHwm9sZA9
X-Gm-Gg: AZFdTZfz5qJV6ZKui0KrAzHbXI1yiboYExAACr/0pOVx3sYTYurJaz0zENg+XIFBVsY
	JfuBfiqh38hpWth/1HTgCWhqKKL/EUxc+ofpS8x13eIprw/tckyjEONO9PuTOwFJuKLDeAczWZy
	ExMwqe/icrXZOnH6+286Ku9skqTGz4sHM2ckWr4NiXeUxjIWMF5MxHzc9ZYdSa6tH1vkhzrC2T6
	ZpvlhIkKLcveml6ITz9QXRJY3a5udIQ4Kj3Cdsh0GnbndL+P6dUVGTI3w04txqn3OS9qUgVmZ39
	yXJqYHDiSJbLor4Xn4AZsDK9Tp94sbsjIWgz7yKXSDn9UuouLOovg+O8MktIhxQcPQknV/tAXG5
	SKl2kGQd5C1vOA+A6plwc8tj3JWKq87mK67vBwAhMMP/xJh7+59lkwJHthT5Z4sAVQyNtNHwDZO
	NPfEsWi723/KkVbiaLts1wkGl4SxpUiu8PDp6F9btupm45/O2aOBM=
X-Received: by 2002:a05:6512:b9e:b0:5c1:5209:5a44 with SMTP id
 2adb3069b0e04-5c1c8239441mr351300e87.4.1795485885773; Mon, 23 Nov 2026
 18:04:45 -0800 (PST)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261123083337.2731019-1-aneesh.kumar@kernel.org> <20261123083337.2731019-11-aneesh.kumar@kernel.org>
In-Reply-To: <20261123083337.2731019-11-aneesh.kumar@kernel.org>
From: Jianxiong Gao <jxgao@google.com>
Date: Mon, 23 Nov 2026 18:04:19 -0800
X-Gm-Features: Aa3M54qI-S6sAhD3oo3lD3dF7U9WjxfGl_G2FEa2MNAlB4C8vKhlPO9m5SK63WY
Message-ID: <CAMGD6P0pNAnq9U80dnpgbz+hHbX1yH1bdmXjcie4oiq7KizU=A@mail.gmail.com>
Subject: Re: [PATCH v1 10/10] PCI/TSM: Configure accepted device DMA during
 driver attachment
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: linux-coco@lists.linux.dev, Dan Williams <djbw@kernel.org>, 
	Leon Romanovsky <leon@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Jonathan Cameron <jonathan.cameron@huawei.com>, Xu Yilun <yilun.xu@linux.intel.com>, 
	Alexey Kardashevskiy <aik@amd.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J . Wysocki" <rafael@kernel.org>, Steven Price <steven.price@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Lukas Wunner <lukas@wunner.de>, 
	Ashish Kalra <ashish.kalra@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, driver-core@lists.linux.dev, 
	linux-pci@vger.kernel.org, kvm@vger.kernel.org, patches@lists.linux.dev, 
	Zhichuang Sun <zhichuang@google.com>, Piranava Tamilselvan <piranavat@google.com>, 
	Erdem Aktas <erdemaktas@google.com>, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 23, 2026 at 02:03:37PM +0530, Aneesh Kumar K.V (Arm) wrote:
> + /* driver_managed_dma is unsupported. */
> + if (to_pci_driver(pdev->dev.driver)->driver_managed_dma) {
> + ret =3D -EOPNOTSUPP;
> + goto out;
> + }

Hi Aneesh,
A short clarification question on this check: once a guest TSM driver
implements dma_enable, pci_tsm_dma_prepare() will reject binding
vfio-pci (and other driver_managed_dma drivers like pci-stub) with
-EOPNOTSUPP on both locked and accepted TDIs.
Is rejecting driver_managed_dma just a scope limit for this series, or
the intended long-term policy? If it's a scope limit, is the expected
direction for in-guest vfio-pci to enable private DMA when it claims DMA
ownership / attaches an IOMMU domain (via iommufd or vfio_iommu_type1),
rather than during pci_dma_configure()?
We run a userspace accelerator driver over vfio-pci inside a confidential
guest on an accepted TDI (similar in model to DPDK/SPDK), so knowing the
planned direction for driver_managed_dma =E2=80=94 and whether any upstream=
 work
is planned for in-guest vfio-pci support on TDIs =E2=80=94 would really hel=
p us
plan.

Thanks,
Jianxiong Gao and Zhichuang Sun
