Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795448110;
	b=hfrc0uGGnQd79WTBn7ZertPSvvHf6aBeXkni/IkI/JsSvepw0spBfYDJ+uYH4xVRJnPQ
	 g89HMprucThGUj+HKyMTN7irdN2i2G5ZUBLzBVihnOeows/2kAtYPgzCdyPUosJ/7sP4v
	 nGsMTgA+KsSBT8IelhMKUzF3Wwei3Ctq6BLolOPWsm/rKWktT0meChPZKWbvDHDvVMLBw
	 3gU7Rxs+wMsRjjX3n/CoDtVeGiajXYGollDfZhIVDlIgziSmTIdixlj/TJk6MR3y0rB9V
	 G6nxB9yvTSuGnTfVDWO1bcd6uHLr3wgjsbHtFNL/b3E1nkhswhGjkjwlhmQ7Dy09KDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795448110;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=jVozDBZgp+27gMR99l+UaMITrh6vU8pxKuFZh102SrU=;
	b=kNE6BiWvvzmcISOkWbrXOKQIBPKoRJMGyo6hXxKscOr+6Gd1QWBkCaB56iuM5IVZy2Cl
	 BYxV/hjNmCI0DFCoGLcGE0M+kepfiixjIZIs2iN/hq0/372S22/CLGiBik6HuGkPhNMr+
	 F3jqnIq1PbgbxWqFPmWIKlriGzqUlm3i/eWon/QI03Lhokgkr3QFP+G3iityJrCBlmwzO
	 kpGB4T+R2dEtbLWMDodC2NmqNmTqngpE8csd3xQ3ElnSZ/FMu0KVDZw7/UyXn/cea+CMR
	 S7amANqJ693zGO5hHK0kjIt34QLRKuNDXmJQq5wj9+aSUgFNpnMm4zDkgEE563nS/vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b="i/FamW0d";
	arc=none smtp.remote-ip=209.85.222.51
Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com [209.85.222.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A450606A32E
	for <patches@lists.linux.dev>; Mon, 23 Nov 2026 15:35:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7A450606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=i/FamW0d
Received: by mail-ua1-f51.google.com with SMTP id a1e0cc1a2514c-99ac154431bso488661241.0
        for <patches@lists.linux.dev>; Mon, 23 Nov 2026 07:35:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795448109; x=1796052909; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jVozDBZgp+27gMR99l+UaMITrh6vU8pxKuFZh102SrU=;
        b=i/FamW0dqItDKDcrh3YbiVAMzqFr59iuN2XqiRyjTzhAwQfMU8S6oLV6LTanYRcOVM
         ilZo1vYlPgRc3m6Uteam1cUHRpNMKm0mA+C3rDE4hX8ygwywpxz6Ew+0kxiEy/p2UIQd
         kUGakSNyZ7uEE86lr3JK+gSbvNpoV2cq6gVc5fru5/0SpvBBi9JMyKnhtyAIi41j5Rvz
         1oFEiPIbHhai+HGhF73sb2slrwFLc/dSSqvKreY/Q59Yse6N8opLHTxR+29KvuadJH88
         16JY4LYooSm8rdutY3D2aa46c1tJgBhBcjI8P42I2mrI/Zoe1P+mn2duVw2Cc3alcQTq
         QSsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795448109; x=1796052909;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jVozDBZgp+27gMR99l+UaMITrh6vU8pxKuFZh102SrU=;
        b=OYfbW3iQH+KJfcn+iVhdvpbp/5LqXjBAJ75wBGhSxPr6s4bcyjQj971tLDPn3tUZ/9
         Nk15P3hGijJQ1ijRxrGoNcwGNCNnKXA9/97EIQCMYa/H5YcrZOTefzKmVdv1S83nbFPG
         PwPe0MvcGYenXhAe38OWlNPzbmve/l3+07Fkcfjqx05dzs/9lxjpa/rhhjyTNM0yvLjc
         +39xBfXYsU0mhU9kpLOUtCpRTxaT3HMp7U+f4frFMlzHIJCLN3ICK7WeHJUHENEw5mK1
         PHUr5lZiVLJ0k/wOMikVNiI5lPb1bGk8Bz9d12D8p+C7YmXzFrIMqxk/85LYCpiQuivW
         DlZg==
X-Forwarded-Encrypted: i=1; AL+hErGwNE5IyGEeRQ33mLgJSBBp1O0Pnk43NEBvaQ/nmm014hOOyHthyJ2NwbbXx/oUTRfiY3PWneNZ@lists.linux.dev
X-Gm-Message-State: APuU4Z+vp8U1Sj/0aaw2V5Fi6AgCLwJLPjeMh22RyL/11C/MXbmtWnLU
	lkAne5cl0CfRbgnIMiN4czZ6SzdNfe6TE5OTTphCq+MgQR+RYpMuM/pctHqzHtDUbIM=
X-Gm-Gg: AZFdTZfhhJZ9v+nMO2A2X25H225NFIoWiM/bJP3teefEGaLcbb7UjOA1+plhODtgHcu
	hB5mYWnpBDlkEOLoe3I7oZglNs3tY8Ufzpc8a8jfHVZBb7qMTvcTYvMm+AzhloQTLiqFxZfMXZy
	ZVp0Sn1qzj1mTapEW0u7pjm50YtN15dMIyhSX1kaAvWQBdrq9U02ps+zfhcWQb/KGL5o0m+kdSP
	jVn3ZtvKI4N/6OVthEw0tOtwP69zGKS12o56och4GoKroSX1Lsu91k5EY3si16HukqUwfmAnZfw
	oJ6jo9GVPNT7tox0QGY330eDSsJMnR7CBYoKVx5PfKp6z4zwK62b5TA03UVNTj4TVyMUPkPCGFl
	wneVRid2vP58Vjy7DBXjsZUGUzLReVbIIpSzfz5PbOiXtE91CoOa4s1TmDAI0zmw/7CmqUDAXd2
	4ct1KQ68/iTQZF2m4mgXr4mZx+DAP9S5kuPsu9CxuyIzh/2DwhnfC9d0FHv02oqovktk3T23M+L
	D7uXoMqh/3Z8aatNP2rgRQhz71cBJbDdRTZDhJi/c/ZM+JAJA81MXD9PYfbd7CF7OEYcWAWYdEq
	P9WCuBj0Kif5gfHhbrvmkEUJBhuTDqK9cJiIQqUA0M3sdTefxKzeWl0FokHTrzhrL0kVNiX3ipy
	3Z0Y=
X-Received: by 2002:a05:6102:5811:b0:7d2:76af:fcce with SMTP id ada2fe7eead31-7d7393c88e2mr5087905137.9.1795448108741;
        Mon, 23 Nov 2026 07:35:08 -0800 (PST)
Received: from ziepe.ca (stjhnbsu6iw-159-2-142-59.dhcp-dynamic.fibreop.nb.bellaliant.net. [159.2.142.59])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-949bb0315f4sm823500485a.3.2026.11.23.07.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 07:35:08 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xVW4R-00000000swq-2uP1;
	Mon, 23 Nov 2026 11:35:07 -0400
Date: Mon, 23 Nov 2026 11:35:07 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: linux-coco@lists.linux.dev, Dan Williams <djbw@kernel.org>,
	Leon Romanovsky <leon@kernel.org>,
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
	kvm@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v1 05/10] PCI/TSM: Add association locking helpers for
 evidence acceptance
Message-ID: <20261123153507.GH179082@ziepe.ca>
References: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
 <20261123083337.2731019-6-aneesh.kumar@kernel.org>
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
In-Reply-To: <20261123083337.2731019-6-aneesh.kumar@kernel.org>

On Mon, Nov 23, 2026 at 02:03:32PM +0530, Aneesh Kumar K.V (Arm) wrote:
> Later attestation patches let userspace finish device setup through
> evidence-accept after host sysfs connect or guest sysfs lock returns.
> Those commands use a saved struct pci_tsm and must prevent disconnect or
> guest unlock from changing pci_dev::tsm or freeing the saved structure
> while setup is in progress.
> 
> Add pci_tsm_trylock_association() to acquire pci_tsm_rwsem for write and
> check that pci_dev::tsm still points to the saved structure. For a TSM
> implementing devsec_ops, first take device::mutex to prevent driver
> attachment during MMIO validation and device acceptance. This matches
> the device-mutex-before-rwsem order used by PCI DMA preparation.

This doesn't seem the API I'd expect here.

When we trigger SPDM session start AKA lock through the CTLV it needs
to capture some kind of 'session cookie' for this locked that ties
back to whatever the TSM is using to prevent a hostile host from
locking/unlocking while we are working.

That cookie should be held in the attestation driver and when we get
to acceptance it should be presented to confirm that nothing has been
tampered with.

It is a further reason why we can't have lock under sysfs control.

It should be attestation that provides a general purpose lock that
serializes all attestation operations including lock/unlock so we
don't need a TSM lock like this.

The driver should rely on that lock and use its internal mechanism to
process the cookie.

Jason
