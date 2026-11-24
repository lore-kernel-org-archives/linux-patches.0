Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795526205;
	b=R3VimZFf+BvFSNFA82HcFxERUpQN/Q+eLPPtBWZbmf4eF1tbAUO57uVD2PD9SiZbdG54
	 aCvCshY1lEgHRgSK0rX3T6aEj7/A0n2TfAi/LjifMUvkakh8NUM9QvuMZzRRqeAfFys1V
	 lcbyiHyIPpYJw1beq2RNRph3LPPjwBhPLhFTitbaW3Ue/xRhRyY93RK1DEFPeBykbH1ys
	 BuPOs9pKKkAyuhWN+XFMeZqjNNKszaHLMGvtayIxYt4Nt9TxyfjzXPZjU0X1JGUxn9mX2
	 qRUBlqiaTAmRfmD22wEbNszC4pfP7993KUEZxZw/vDMU5jGbLQaLUCcFfaNy4Ls38TQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795526205;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=0prXWPyKnaONv+XVyeK4p1EFWEfFGuwvhH1CWWabhJE=;
	b=lFD/kElQMGKm8G1PTUnN76vza7BSR8YDpc9yZ4+b09vU0AEcg2Ahy0mKGlJAAh83KqO7
	 GuP6X9fY3E2l8ynXa2UJOTmI6ChRj891+uTSGj0hiWChrC5S5w2fw+FXR3FU6Xl/+FwIj
	 iW9jfRwCUhzCslsi/WT4AuPD1i2vNjkaiMllloHfcEcMWYXirDNwQ8VjlcDDgqkup81I1
	 gYrymOU+0yRi9xwDBMKh4ziMAWhkNIcO8d3nKfL7J6ZsX6RNFfK7AwRKLsMzPI7AN5iFi
	 ll4+OcFaV0dH+zoOyyIFigh0r3OgpIQdSlhBsX0SDbus/fsNT0mXViI8zwXLF42jAqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=J4uJFFk0;
	arc=none smtp.remote-ip=74.125.224.50
Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3479B606A322
	for <patches@lists.linux.dev>; Tue, 24 Nov 2026 13:16:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3479B606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=J4uJFFk0
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-67df3b1ca06so4998574d50.2
        for <patches@lists.linux.dev>; Tue, 24 Nov 2026 05:16:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795526203; x=1796131003; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0prXWPyKnaONv+XVyeK4p1EFWEfFGuwvhH1CWWabhJE=;
        b=J4uJFFk0mntqXD0jfAznYbPniXa8DWEftiyUdzaBg0Qcljpc4/bQBLckmTm/jWh+RS
         W6rBbFYOuw12GhmMihNykU/Bn0iCP0bUf9qTJ6jTjiGfpHITrGR9BdA4zESfMp1lpdmM
         wIsa/Pg1EMjeOydb/vXNTnud6urcnZpQOsRaAmQTXFTSZ/EjWJDIUyI5cafz9HAgj4h6
         9XEdZ87gLYsQTdHeMiBDtIV/LX59mzcoAMEGVGy5ihAlq4dkXF49imXFVOj6+HDk5Vv8
         HAMVhl9PZoYyKRtObPqht0mtagh6/dtcbL6HQ1szljyOcarCixfNW8hL30S7GmaKiWKX
         NZLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795526203; x=1796131003;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0prXWPyKnaONv+XVyeK4p1EFWEfFGuwvhH1CWWabhJE=;
        b=lQlA7K2GGt5+ZocSktaoB3UqQ7jnrdCqGobqhVlU3KCMbflm7/x9WmdH5A4XV+tDbc
         vGZmC6bpJrsl6KrWnETQCZvwyhvVFpemR/vropUvJWvPBDI0NceQUY8m7JvhZTVwwUTg
         doPMslNmh+t14od7Uqj3w4IT33G/jyYTdIkshwAcCtxwYwmX1gQV0dm33kPLNVR6Ebjw
         IDkRyKUjL+oNpe0O81q6uEzuUA1koHvtdDygGLi8OfCfSS0ecRn/6YWI4CWUauUBRGLZ
         1RYKnU2Wdq67t3BTHGQkYCPUwHQHu1Gss7YaywtRh7UTCEOV8Oa7fG+ZhusdsvIjVMSJ
         mXwA==
X-Forwarded-Encrypted: i=1; AL+hErHQSozj8VT9WWghhwGAHHbGhWXx7iGDT9Uvt5+FXyKi2Lf6CKNCcWdFCudpnaA2ItBY5+aNw52L@lists.linux.dev
X-Gm-Message-State: APuU4Z/wyedaCkuWGK0C53+09oZG3KIAyReS+UlYegz41KS6X2i7rVrm
	8+/YVIui7N9L1WN4GJWg/aT44Iye9gU/hoDsU6i0oaTCEvLnB6oaVM7SH18xaWQv0m4=
X-Gm-Gg: AZFdTZcw5krX7V7EWy7lTzBa0dqzOl7C2bysC9q2ZGKVaBgOT/7UlvlQSF3k9yYaTO1
	lM3SPb4c2THqAjE2M5eEAhaS/oFFawMSRpRe1rkfGrdn5VVZ0MyAwzfG1H4YSHrUFmNLc3vX3Sq
	nU5pSFUMu+ho68eKJEnyesBlMZrnsUiaG8YdDQ3QRTOubrG5RF0oV6jFb2r8QykxEXlSbF/F+AW
	DLM7DJ1Es0dSGFfXA18g0X21iPiF8ZiHw/VigS3qC28jRGGBr1q42eHJmOzFKfUcCtWZIRKWKH2
	lWEZya0/0QdACXOsSoNW/BwaV706B/gD6tRUgrYY8w5tTJHlg8SWzTF1Z8jb5uer5NMDs14S+CH
	6b1PyxH4j8/v9jXrAdNLOXaN7H1MdGTPbQShSELZpOzhO16bsjOjoZvw7EwWrG8flvGoD84x+6j
	GSjrGegFw4EQ23on9qOLb4Dnffml8x2RnrDOCTdSUlhs+JHTBv0RgCTDFIi2SFvqCeQOyehrViL
	CQnEtnddmspefH4T9tz+/Q1h8oZ0mpvo85lDh3UHsH8S+klNnWNDPJpMvhiY8wKTHGzzzUKNuo7
	7nZpwA==
X-Received: by 2002:a05:690e:813:10b0:67c:11c9:2d10 with SMTP id 956f58d0204a3-67df449142amr3986970d50.89.1795526203028;
        Tue, 24 Nov 2026 05:16:43 -0800 (PST)
Received: from ziepe.ca ([142.177.118.84])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-949bb38322csm1037775085a.17.2026.11.24.05.16.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 05:16:42 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xVqO1-00000000P3N-3lUT;
	Tue, 24 Nov 2026 09:16:41 -0400
Date: Tue, 24 Nov 2026 09:16:41 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Leon Romanovsky <leon@kernel.org>,
	Nicolin Chen <nicolinc@nvidia.com>, linux-coco@lists.linux.dev,
	Dan Williams <djbw@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
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
Message-ID: <20261124131641.GE9566@ziepe.ca>
References: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
 <2026112325-emit-squeezing-5d96@gregkh>
 <20261123090623.GK14811@unreal>
 <yq5a7bi3riha.fsf@kernel.org>
 <20261123115803.GN14811@unreal>
 <yq5awlq3pto0.fsf@kernel.org>
 <20261123135638.GO14811@unreal>
 <20261123152533.GE179082@ziepe.ca>
 <yq5aik1n4iz3.fsf@kernel.org>
 <2026112429-expansion-wilder-a0c2@gregkh>
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
In-Reply-To: <2026112429-expansion-wilder-a0c2@gregkh>

On Tue, Nov 24, 2026 at 07:44:03AM +0100, Greg Kroah-Hartman wrote:
> > @@ -617,6 +619,7 @@ enum struct_device_flags {
> >  	DEV_FLAG_OF_NODE_REUSED = 7,
> >  	DEV_FLAG_OFFLINE_DISABLED = 8,
> >  	DEV_FLAG_OFFLINE = 9,
> > +	DEV_FLAG_DMA_CC_PRIVATE = 10,
> 
> Again, NO!  No "cc" nonsense for device states please.  That's an insane
> policy decision that will be driven by userspace crazyness, NOT
> in-kernel stuff.  The kernel will give userspace the tools to enforce
> this type of policy if someone so desires.

This may be the wrong place to put it, but this is not a *policy*.

This is a "DMA property" like dma_mask, coherent_dma_mask,
bus_dma_limit, dma_range_map, dma_params and so on.

The name mirrors the DMA API name for a related idea:
DMA_ATTR_CC_SHARED

Unlike the other DMA properties this one is changable dynamically
depending on how the HW is configured. The TSM is in control of this
HW block.

The userspace policy input is how to configure the HW, but once
changed the DMA API switches to following the new HW parameters.

Nicolin, can you put this in its own patch with a good commit message
so we can have a discussion where it should live?

Jason
