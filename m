Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795451987;
	b=gGIIkmsVaqY99BHD9AnAlzkLzQcvmDAj6JCjBJRGiKZInRf61Cs5RJT1a9cWsX1os4J+
	 HkASKW+CH+jLwxYIGStO7BLLIL4EmfysWN+qoJ/tA30+rmn5MFs4vp5QV/mu6u5e47yW+
	 TEQgNPNe12ZTjAA8YwEEP8/kl7W1Je1UkdsUWowCHg2EsUGoWK1vUpLSMhXELErNJrShG
	 8km0XrKOcmroQ0q2/q3Z8QO1UUm4VUTKgJk8k/uoSiYjPMzxeJ3CbsEEHinG303xD3pzR
	 uEJCA1gy1czbKPKiaiosEdxQrg15gRjf8yPkJ+zwJzZpLYe0qz0zgorkQ05WenthbuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795451987;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=drjpTP74JsK51H7vM836NsoylzVlZy0Ll0P6+YE0Z3w=;
	b=T6xBhL6VmV9JzUTUB3FZWu4GdPoTowcStcIKZtgGtsjiEs34VkHpNfTkeQaiiagPdgnn
	 k28+jvPkFsiktJK5e72og8sUZtPYZ79JhpNjWbbLopLBBT3e7wEX8Zwfml1wxFsvDjk8B
	 3L7M1PZX5FQ0NGMTNvmgKQ3LJXo4pQ9GLODanHOboeKjqJU26bT6zbP/zpg/fVfp0Bv96
	 Y0UbevRafV4qcxcmmiVKJIZpG2mEbfwDLiQidua1o1d2j1lgy1wTipVlLi9LP1E48NOdB
	 QfUiuBBuY6siQF5Jjv/EfIdvqrJ5cv0jJ6hcMzgdfJ8poAOFThPqvQj1502u27MsLWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=JHijAuKO;
	arc=none smtp.remote-ip=209.85.222.177
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4630B606A31F
	for <patches@lists.linux.dev>; Mon, 23 Nov 2026 16:39:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4630B606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=JHijAuKO
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-93f1e5d7450so352879785a.2
        for <patches@lists.linux.dev>; Mon, 23 Nov 2026 08:39:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795451986; x=1796056786; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=drjpTP74JsK51H7vM836NsoylzVlZy0Ll0P6+YE0Z3w=;
        b=JHijAuKOjY72eOsyCLK5bQSXHi3v7+L9T5QvMEidcai+av6NrQwrzxbskBngKgBjpZ
         2iJL7Hn5XS23RvpznVhq2a2Qf75izZ+xldFOU3cs+P1rzHDtbP/F35TRlIB1BXuJVQhb
         9reXgji0m8Hw+l8ST4g+WExqnEVYnq7GvSi0zE2zSc4GOAlt8PCn8dWGg5mWPtUF4p25
         qp4e6AwW1uSwVJ+DmXdqMvc+HM8EjUCM5FFoXj9pPNqQ2OPxj6+2+bdONHesfW/ggHJT
         1xyrejXJs6U256UTj215Bbna9M/5WqPUBRxPLBgRyjcYXIFHr/uGYFlWDqbdhOQWX5Iu
         +Hkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795451986; x=1796056786;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=drjpTP74JsK51H7vM836NsoylzVlZy0Ll0P6+YE0Z3w=;
        b=QlKxuBWJE3aSrFWKAtvlb8Ddoy6lboIK+n/XQl2AgbCnYyZPYc18jZA9yERE+1OzfF
         maDnoRrB6NvPuUW3lNE5EPZO57ndikMHnbqHw5B5Qs4m1pEECIruKeANzmjKCcJI8WRq
         PI5GCAQKIB3nD/o/axL6djFVM3i4dwxIjeX818BbUfJYNtf0HP7bjeif0RsucGJAxrd+
         g0BzOT+4d4TcKU7AgZAu7zDus1iuwo0O825udGiEMu8JjFoeOXHjWbg8+vk754iGwMen
         MAHWbC9qXdHNGyiOkL/7CRwtb5zkIEHO+jeWsYVkDcIAU9VaPgn2/EqtX9eBgLbJeSDL
         Y8qg==
X-Forwarded-Encrypted: i=1; AL+hErFpoqnu+spjXTBMaU3y3BGpTnhHQAK/aIIcDekRl0bFxsdRB6oTQxsaveNlQFeuPAw7oWxmsT/D@lists.linux.dev
X-Gm-Message-State: APuU4Z+TFs4PZedy3piQOq9Dvo2UfXcPdAYtz6ucPZiK355O42elutGN
	B+oltyByqbufyaQYaoHpe71Q66FRpY0oh5p4rAKY3Vt3PNCfuiAB/eKug6ClF0CUVRU=
X-Gm-Gg: AZFdTZfWQluJLGqborfhzHjPf8Fjdw0XCU02F362nN+aN6eqHpc18NxFG/IIORSW435
	K71v3vJyuadloc9scyuI2NIu7P9jF74oVePsLsOW/ilhofPWYCTTB4GZIu2kbFJBkgof4PmfnvW
	80dalA/slqUylT2SHJIky4b3eXXzgO2suY+mc2L57sYy7ZnehIBzhTh+0uUWWLVNf4ypcAjUwfy
	tDrvQBufM/BlNRAun1YpzW2DLB4iUMMcSla39Pr0TPmWh6s/kRQV8EFD6Jabf0eQ/2DiqBT2wGU
	ececYivCRGWQisOQxbB/ISoAeSif1nyEITR3YjUoaIvfPCJ3Nevpfwc4IvtwupijnqdcEa5OQ3t
	9S13imHn/4dlJfZOJgBGLbziLmssixm3KTvCkfvkzMAXCslX66Dlus2+HUwHelpRE3cRI2ELFRU
	af6G4F1u6ihLbQtJzUZV39SJZuga2uiFfZYJKiKMCk9BHT5swBPcy/Uwr6wfM2wadfND1ZTOlow
	uhJPP7Tzixg8wft2ZV24e1vb36bTjgxNHSdKIm0p7j4GpbYp+6/7AH4cw9JmAJ9U9AMbEEEleEf
	DSApqGJeKVqpB7G7+PEr7r+wm+kMI6WBN4CKf5pp10nnhlmP4Orty9UMDjTV0pq1gVtKttjSmRi
	62CY5mDEQghBR3o8exYUb09wv
X-Received: by 2002:a05:620a:4403:b0:947:7f9b:f839 with SMTP id af79cd13be357-949ba9bf10emr2106812185a.47.1795451986121;
        Mon, 23 Nov 2026 08:39:46 -0800 (PST)
Received: from ziepe.ca (stjhnbsu6iw-159-2-142-59.dhcp-dynamic.fibreop.nb.bellaliant.net. [159.2.142.59])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-949bb424fa6sm828689585a.40.2026.11.23.08.39.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 08:39:45 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xVX4y-00000000vk5-44Yr;
	Mon, 23 Nov 2026 12:39:44 -0400
Date: Mon, 23 Nov 2026 12:39:44 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Leon Romanovsky <leon@kernel.org>, Nicolin Chen <nicolinc@nvidia.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-coco@lists.linux.dev, Dan Williams <djbw@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
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
Message-ID: <20261123163944.GK179082@ziepe.ca>
References: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
 <2026112325-emit-squeezing-5d96@gregkh>
 <20261123090623.GK14811@unreal>
 <yq5a7bi3riha.fsf@kernel.org>
 <20261123115803.GN14811@unreal>
 <yq5awlq3pto0.fsf@kernel.org>
 <20261123135638.GO14811@unreal>
 <20261123152533.GE179082@ziepe.ca>
 <yq5aik1n4iz3.fsf@kernel.org>
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
In-Reply-To: <yq5aik1n4iz3.fsf@kernel.org>

On Mon, Nov 23, 2026 at 09:51:04PM +0530, Aneesh Kumar K.V wrote:
> index 429e39f647cf9..01d7877d0b571 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -604,6 +604,8 @@ struct device_physical_location {
>   *		ancestor device.
>   * @DEV_FLAG_OFFLINE_DISABLED: If set, the device is permanently online.
>   * @DEV_FLAG_OFFLINE: Set after successful invocation of bus type's .offline().
> + * @DEV_FLAG_DMA_CC_PRIVATE: The device is able to access private (encrypted)
> + *		memory, no shared memory bouncing is required from the DMA API.
>   * @DEV_FLAG_COUNT: Number of defined struct_device_flags.
>   */
>  enum struct_device_flags {
> @@ -617,6 +619,7 @@ enum struct_device_flags {
>  	DEV_FLAG_OF_NODE_REUSED = 7,
>  	DEV_FLAG_OFFLINE_DISABLED = 8,
>  	DEV_FLAG_OFFLINE = 9,
> +	DEV_FLAG_DMA_CC_PRIVATE = 10,
>  
>  	DEV_FLAG_COUNT
>  };
> 
> ...
> 
> +void dma_set_cc_private(struct device *dev, bool private)
> +{
> +	dev_assign_dma_cc_private(dev, private);
> +}
> 
> This could easily replace device_cc_accept()/device_cc_accepted() used
> in this series. I can switch to it if that's the direction we want to
> take.

I would prefer to settle this with Nicolin's series that is part of
the point of it since it brings a real user and a justification..

So if you can confirm there than it does enough of what PCI needs that
the PCI additional is incremental then great.

Jason
