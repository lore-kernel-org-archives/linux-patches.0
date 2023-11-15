Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73BC728DDE
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 14:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GDDrK/IU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700059383;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sqWGwV812/CXYndzj2W50PA7KOMPm+tHC+e+xjD2/M0=;
	b=GDDrK/IUxJxyaD9Eesf2xMM34fW5yMAURIvUv5FeWryyArZuABKnsc08VlSvE/LsL5ov3M
	eOIxokebuzQpJYfcIRFoDSh0grb1Y2UFS1ZiiEhnIv2pCEfMHiKv0O/zGGuax4GABgeBF/
	io3r2J3JvVfANMV4AbK41AWfNGr+3tI=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-OdmRHvuoPhaxMhe0GfPb3Q-1; Wed, 15 Nov 2023 09:43:01 -0500
X-MC-Unique: OdmRHvuoPhaxMhe0GfPb3Q-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-66da680f422so81189346d6.3
        for <patches@lists.linux.dev>; Wed, 15 Nov 2023 06:43:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700059381; x=1700664181;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sqWGwV812/CXYndzj2W50PA7KOMPm+tHC+e+xjD2/M0=;
        b=XBBjNZeSGKAdGf34G2bv2/vYaoyluNOOwZQgJHVRUz6RCqneENkCaebhVfppHrNQoi
         C3QxPn4zmkb+EeMoHD6s8SO8jeo2KpQ77MoiaqLNZyLSgzXA9Ze8Qu9LWNYvWa4qPcTI
         N9NfnA3W7NRQjZmAbVdDg1VzDk1s/BXQq+H5X9nPXzDQCdOCNwQZ+p5PNeANwrmRsgmS
         7UzK1OI5RDBPd++uc7FL3TBmWJrX0WI7nH1FZVkJ4+8IlLFMnAZgQbf7ocwUsnW6HQPC
         S5vfactAO41IyKf0Onwlxkx2larJl0fX+VPBxP1WKJ+/oXCw2EJCxtGsmH+JQKAFdVsG
         u/+w==
X-Gm-Message-State: AOJu0YxAoXow8aDfsJlnKXNsxLtnr/4Kkv3yRvHuWVNG6OMdd36CYQWI
	ZeIVoK0DCyaqhEpidVk5e9pAgUnJmxQKMcT6U4MHEwoJ8QNORqGu0Gc4a2gGUDmkdWlLAhu6jPQ
	aBbNdPBVApXplp3qurA==
X-Received: by 2002:a0c:c3cf:0:b0:66d:1100:7b81 with SMTP id p15-20020a0cc3cf000000b0066d11007b81mr5491027qvi.18.1700059380975;
        Wed, 15 Nov 2023 06:43:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF0jpQrK9oJO86ojMSo1dc0KOCSp7+RBS164Fh6GwHlgBAjmWNWgSHBdIgtMHXFSNVSzkNNdA==
X-Received: by 2002:a0c:c3cf:0:b0:66d:1100:7b81 with SMTP id p15-20020a0cc3cf000000b0066d11007b81mr5491005qvi.18.1700059380669;
        Wed, 15 Nov 2023 06:43:00 -0800 (PST)
Received: from localhost (ip98-179-76-75.ph.ph.cox.net. [98.179.76.75])
        by smtp.gmail.com with ESMTPSA id u2-20020a05621411a200b00674a45499dcsm578681qvv.88.2023.11.15.06.42.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Nov 2023 06:43:00 -0800 (PST)
Date: Wed, 15 Nov 2023 07:42:58 -0700
From: Jerry Snitselaar <jsnitsel@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: acpica-devel@lists.linux.dev, Alyssa Rosenzweig <alyssa@rosenzweig.io>, 
	Albert Ou <aou@eecs.berkeley.edu>, asahi@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>, 
	Dexuan Cui <decui@microsoft.com>, devicetree@vger.kernel.org, 
	David Woodhouse <dwmw2@infradead.org>, Frank Rowand <frowand.list@gmail.com>, 
	Hanjun Guo <guohanjun@huawei.com>, Haiyang Zhang <haiyangz@microsoft.com>, iommu@lists.linux.dev, 
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Jonathan Hunter <jonathanh@nvidia.com>, 
	Joerg Roedel <joro@8bytes.org>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-hyperv@vger.kernel.org, linux-mips@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-snps-arc@lists.infradead.org, linux-tegra@vger.kernel.org, 
	Russell King <linux@armlinux.org.uk>, Lorenzo Pieralisi <lpieralisi@kernel.org>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Hector Martin <marcan@marcan.st>, 
	Palmer Dabbelt <palmer@dabbelt.com>, patches@lists.linux.dev, 
	Paul Walmsley <paul.walmsley@sifive.com>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Robert Moore <robert.moore@intel.com>, Rob Herring <robh+dt@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Sudeep Holla <sudeep.holla@arm.com>, 
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, Sven Peter <sven@svenpeter.dev>, 
	Thierry Reding <thierry.reding@gmail.com>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
	Krishna Reddy <vdumpa@nvidia.com>, Vineet Gupta <vgupta@kernel.org>, virtualization@lists.linux.dev, 
	Wei Liu <wei.liu@kernel.org>, Will Deacon <will@kernel.org>, 
	=?utf-8?B?QW5kcsOp?= Draszik <andre.draszik@linaro.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	Christoph Hellwig <hch@lst.de>, Moritz Fischer <mdf@kernel.org>, 
	Zhenhua Huang <quic_zhenhuah@quicinc.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, 
	Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v2 03/17] iommu/of: Use -ENODEV consistently in
 of_iommu_configure()
Message-ID: <jtgj4qfpqzj5zowqwmcniaxd77kqvirspm2a7jkgg6vgmo2scy@5jpoatxkrkid>
References: <0-v2-36a0088ecaa7+22c6e-iommu_fwspec_jgg@nvidia.com>
 <3-v2-36a0088ecaa7+22c6e-iommu_fwspec_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <3-v2-36a0088ecaa7+22c6e-iommu_fwspec_jgg@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>

