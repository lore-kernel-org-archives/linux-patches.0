Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795527398;
	b=KlyvPgZ8WSuDBpJ2p9wjHSS/PthWCq9Un3EcC5u3aaqqNOKPs5dumxNF74vWvzm8lTyH
	 s+kLN6IIJcrPrr+gboEPy8eS88unt1ZZJ51lIILfDFVJrhjSoz1qwhaS0LdOlHT+TtRRz
	 An7ry2uEC2qMKted1ZVhtixeyfL8EcDily/X+YqdjO2VIG4pMHlzGNiS0jmy3tyX+UPJ/
	 nF0R4k1bSeBLmdkWL9iUSqemG3URPYAM/arjhQr1B/Xlg8L3uHm/PEhdlfVTPqdTT9tX8
	 j+UduWv7Q4EZxrQTpvop0Ht+vgHTKs8u8pVnisd3aHHQhWgl0pHwzhhYnfBSO07DFzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795527398;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=38dbhiLjfuYeyXify2hejI0unP3asaYqsevCVz0W1bQ=;
	b=xWBd5+O7e5qNofjIHc0Wm7d/6l1oT1HgKaZsaX77KEK4vtfJg6zk7x6WDIi/plXlUHS5
	 QZDiaq4pVzsn8RLGU9joFUv1uGABF3WNIsQaChMBlXct1CMaa7TkKyRyyzhiB9rXCWhh/
	 sHL3sQWYmevbh5TqxZl6nayMdPunORxSl6PtomjQlrlEz6KnawuOZUTLsDxpRfTe+RB5A
	 FsE662k9g1IbbLg9nWMw2t/zF+sutsRgtIcp3yINX02WXavHmyCE2FeBmSZ/y3RGv4Xop
	 6SmhWjvREYvAUjG8yrWd87eDjR1KfLkGEnxPZEu4JmL+eZ8+T4gxzsgK0JrEzpuTkEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=flQ41bEq;
	arc=none smtp.remote-ip=209.85.219.50
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D2DB606A327
	for <patches@lists.linux.dev>; Tue, 24 Nov 2026 13:36:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1D2DB606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=flQ41bEq
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-920fed989b2so44114076d6.2
        for <patches@lists.linux.dev>; Tue, 24 Nov 2026 05:36:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795527397; x=1796132197; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=38dbhiLjfuYeyXify2hejI0unP3asaYqsevCVz0W1bQ=;
        b=flQ41bEqZsTIoWP1xMRLarxDeOueftSsd0ZgKn/hEBrJO5/JIw2jMxaCDfhR2+sjTM
         M6RhOSD0yuZJkiCCyXCEPB3gDxXPuLKamoO0PDRxF7D+m6Hn2R46kK5+O+hDA/4GASJk
         28r/EE4hj5sydzYR8/FRs5dxe2LtuhClsixpUjNkK0scJLGbsK1rJ9MrKLiU+BFH9Ufn
         qafKjC1jvQ8YMPV24GD8oLp3gnUy6u5nAKNfi23pGwkRuQhEuR+kuCi7XK698R2LNbCT
         gKLJvp9smq2R/k4vUVR2QZDkOO5nGnIhuo/3vTvvP9okNyGC+7QpLAcccDmhu2p0n1sW
         sv/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795527397; x=1796132197;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=38dbhiLjfuYeyXify2hejI0unP3asaYqsevCVz0W1bQ=;
        b=mhniCZrjah+goDmsQNngAfdi/ILlHnb9vUAj5BNlwWC+3vMD0daxLDvxuvMFD+v1Fh
         Zevj9h870OHrV5wG63AE174zaOLpdgyCGrCb7dF6IK3/tF2WcpvivCNzGoGeAOLDofin
         eDz7u6mQkfNnfyUPjr1qhxoxWBkW+671mnQdmMJ/0ckZkO0PFQtuaymYEo97dvEWWfEP
         eVLZUs2zkj95A4Devw5tJjvcfEdiXU2aWrsc1oI0ZbxUdLnuYf6q0bKcxjaXBEasm2dd
         cIWjrmqCLmc72HjaIOiJ1RvA2gvYDZgC233Qt2AZu9iq8u12ppRbfq7Kvjy9649pc9fS
         aH8g==
X-Forwarded-Encrypted: i=1; AL+hErED9H9a4Xdg4iW8kNeE45HzMv9BB5YITp26Xwc3hYjfEDNQ0tvUy14o+KD4qNm+li6ok8SEqHGx@lists.linux.dev
X-Gm-Message-State: APuU4Z8BFKcVD7FvWFVobihkfJj9FI8GlFJfrrnTOv0vdP0z7jJwAfIL
	y9zpVfWfPzff7rieNIohtWjy9tehreDx7DspJI5CVXdCG8o8NLUtGnOt+a6Ub+NTz7o=
X-Gm-Gg: AZFdTZf42v0aoLlF8RalDdeU2SdudXX2oR0g6LPzj+Wa+i0AT/gk6NyTzCWYDxemED2
	39AD6UvSAAxDbKWXWgI3VqFLZZL2PvyziZqsgiuCjFunP6fptCo6UG940X/TFuhI8jCwV7VA5C4
	b6bIMMbcuawEE5kD0/MGBkTFsO5AEfH89CyAEBe4EeofmqHhtPFCCR+f5134nw1sjkfeHHaTak1
	IbQJDIjOl6tMdzhh1obkbZJ+1IxbMiz4NqlH6n/HkcRVs53gjrSCq1b0EvBCMcu9CtmgurNKmmm
	ulY1c+sb76Jr1TXOlKWmJols5J/TTPrmKw2nezODc9s+kRcb4cqRWnTPZFR/r/rW12k6QrVi+LQ
	GAJ4FX6rnW2/ogQ7u3a49WvEh/AFQQXktDOU5KzlYjWtkcT+7Soa2PtDCdwmxSVruS3uXkZ7v2W
	vo8cBdUIy8ZTAvyq+d+LpVu+tgEvRyw4OHP+awTSaxTP8cnPAbCU0QFz9GttJo0VDTp55Hb5uKz
	lg9W7AOzW76625lzuyBxWwDg6+HdiM6ECjfTX2MG3fm66DhxXNfFCdKPaQiSfE4DOXiio8G2cmQ
	OVjkmgU=
X-Received: by 2002:a05:6214:4412:b0:921:435d:9242 with SMTP id 6a1803df08f44-921435d927fmr200448146d6.47.1795527396835;
        Tue, 24 Nov 2026 05:36:36 -0800 (PST)
Received: from ziepe.ca ([142.177.118.84])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-92134bf848dsm134683816d6.44.2026.11.24.05.36.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 05:36:36 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xVqhH-00000000PyR-2zMF;
	Tue, 24 Nov 2026 09:36:35 -0400
Date: Tue, 24 Nov 2026 09:36:35 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Jianxiong Gao <jxgao@google.com>, linux-coco@lists.linux.dev,
	Dan Williams <djbw@kernel.org>, Leon Romanovsky <leon@kernel.org>,
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
	kvm@vger.kernel.org, patches@lists.linux.dev,
	Zhichuang Sun <zhichuang@google.com>,
	Piranava Tamilselvan <piranavat@google.com>,
	Erdem Aktas <erdemaktas@google.com>,
	Ackerley Tng <ackerleytng@google.com>
Subject: Re: [PATCH v1 10/10] PCI/TSM: Configure accepted device DMA during
 driver attachment
Message-ID: <20261124133635.GG9566@ziepe.ca>
References: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
 <20261123083337.2731019-11-aneesh.kumar@kernel.org>
 <CAMGD6P0pNAnq9U80dnpgbz+hHbX1yH1bdmXjcie4oiq7KizU=A@mail.gmail.com>
 <yq5aeccabo46.fsf@kernel.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <yq5aeccabo46.fsf@kernel.org>

On Tue, Nov 24, 2026 at 02:30:25PM +0530, Aneesh Kumar K.V wrote:
> Jianxiong Gao <jxgao@google.com> writes:
> 
> > On Mon, Nov 23, 2026 at 02:03:37PM +0530, Aneesh Kumar K.V (Arm) wrote:
> >> + /* driver_managed_dma is unsupported. */
> >> + if (to_pci_driver(pdev->dev.driver)->driver_managed_dma) {
> >> + ret = -EOPNOTSUPP;
> >> + goto out;
> >> + }
> >
> > Hi Aneesh,
> > A short clarification question on this check: once a guest TSM driver
> > implements dma_enable, pci_tsm_dma_prepare() will reject binding
> > vfio-pci (and other driver_managed_dma drivers like pci-stub) with
> > -EOPNOTSUPP on both locked and accepted TDIs.
> > Is rejecting driver_managed_dma just a scope limit for this series, or
> > the intended long-term policy?
> >
> 
> Wouldn't that require an IOMMU to be available inside the guest? The
> current implementation uses dma-direct, and I haven't yet looked into
> private memory access through a stage-1 IOMMU.

Touching driver_managed_dma shouldn't be part of this series.

iommu support for shared/private memory is its own thing that should
come with enabling guest vIOMMU.

> > If it's a scope limit, is the expected
> > direction for in-guest vfio-pci to enable private DMA when it claims DMA
> > ownership / attaches an IOMMU domain (via iommufd or vfio_iommu_type1),
> > rather than during pci_dma_configure()?
> > We run a userspace accelerator driver over vfio-pci inside a confidential
> > guest on an accepted TDI (similar in model to DPDK/SPDK), so knowing the
> > planned direction for driver_managed_dma — and whether any upstream work
> > is planned for in-guest vfio-pci support on TDIs — would really help us
> > plan.

Is this with vfio-noiommu?

It should eventually work, but there will be a variety of
complications along the way :\

Jason
