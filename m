Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795447536;
	b=xgQJPxU6snawPo6WzLPaK7Us6RzyoEbS0jGV30Rcit1CrXNRC1nt2Rum6V/1YjrdEHsp
	 a1aPrf8AJTkWorSQWyLpLXJqwq1B8mtAn1YGJxvpbPRAI7uKI5mKNfZR6K/e4W/Gt05hv
	 Lg+Fw8ej5DcvkjPoaNACnAu31LVbLOok8W0qBzetavVuK+uEKQ0WzABqF6W8cygQ8uj/J
	 iqo2c9iv9nsorPkUDzQdXbMJExeojSDrNE3vRSl2UPJPVzqTTG5BqhOB2wZNVJjBdo6pY
	 Je4J3B+FBXHNXow9qsbPHyQcXLBkwCSz4KVUxzDB8PdjZxslosKo4+JUeJp+/89p7gQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795447536;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=uJeUtw5BXBG6B+iGuyb9j1OIKHpejrpTmDWG1agjBxs=;
	b=ZlN83HuCpgx2BD+BakJKiHhGtY4v4auzeO8yilFZ12EQ6ay2VZyVWpY77/NUbO6nmF/g
	 oHWAUMatFCT7C7oibxqljem8Mea4FYMHEXEuJ7ty3l1Hs5TetlaFJ0li9avQxN0XOTWDq
	 625tohpKgbB4YfgYZmEIfnrhVLKntsOIHd93sXTKweUM2xvEr7xX2v1wDstDNrHXEqxFK
	 glNfVris6R1hobgJf11CpZNXMxvI32y81BcRcFg1Dqay57azTMPIoF8X8JIVbAt5bBun+
	 8o6/sE7VdjgCYDKeyZfNmEsh3f4cdkUrxAcZ2W5JElYJjLFy0is0pJDY0mD+r3UDRwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=Q5iwmH+d;
	arc=none smtp.remote-ip=209.85.160.169
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C2C606A68F
	for <patches@lists.linux.dev>; Mon, 23 Nov 2026 15:25:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E2C2C606A68F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=Q5iwmH+d
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-5366ae57896so36085971cf.3
        for <patches@lists.linux.dev>; Mon, 23 Nov 2026 07:25:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795447535; x=1796052335; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uJeUtw5BXBG6B+iGuyb9j1OIKHpejrpTmDWG1agjBxs=;
        b=Q5iwmH+dNQzpihQspnPZ5EknU6HI/0PvP1I+036hQnLg13miFGooYywZ5CGnjd+ApV
         OdeNzbgSAc12r4zav2Z3u5ePi/tGH1XO/MQjx1g8hLrD0tYqBGpal/o6v9dn0eOm7Wk6
         4G0KZa0rfSGJdq/iMF3tdCuYNHszH6oH+YLxBCbui9po9540zCW1rD6+nVW5jCG5eXkY
         4xU7PYb/KWFxFwA2mX32ExZ8JAujcfUWv19lrYBC945TsgLEPTyId2qOTY9ZDFyyZpPl
         Gq3yIAgusZE4aezbrXyYud4Jtwfm80O+dxzkya3D3GKEZCyM8w8gLGmrJINnagaI/zW7
         exrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795447535; x=1796052335;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uJeUtw5BXBG6B+iGuyb9j1OIKHpejrpTmDWG1agjBxs=;
        b=OjmFgjMC2KlvIm3bIdTVM/l8e3NRC5E+YClVwkRUWB3qsz3IJD4BmC43f3J+KcXpin
         dQTO0fXP8DUtQcHjYXYZHSybTbr8cOrA3/sCamxepHzLh5qcbQwm+4wzn5AguxnlfISX
         7oDEYhacEGi4936s5OtlQPdTblVpOizciCwVw0oSGCHqK6tMVUZrpD5iumZn/iFS14ZJ
         SSIR3a/+UPjjFWrCQ85pWDVZneiy0ScHeNb43YGWx/bIH6Jx4N+Sdf9kVEAvP7QJsAT2
         GJRrALYRU2DkmfYyZCRLKSUtKCgJcnVX8RZZNWuvX9GEFWMCAT9Zw9XzQvLG08kOn4dR
         eyew==
X-Forwarded-Encrypted: i=1; AL+hErFgpm5/ynsDZZR47fxWLeIMM0wwNc7o7mAD8YqCkBw+ZEJC2JaovuqYmUgliOMMrwqd4n2YzhwO@lists.linux.dev
X-Gm-Message-State: APuU4Z+sEvU9rHEKhqsliV9ZHNEkriiV1nRXmLTyzXHv2rn1RkpWQPBu
	FWs9rg8BdCjnBr9vXNKU51EcvupLqADbbfLHtw8qajODAO3yBFSeGVUrUjKgeYqHfh4=
X-Gm-Gg: AZFdTZcadR6PsirjisARraJk4Xbg4UwrMt55cU9a/l8JZ2fHln+s3WaUcNURyDpuBid
	P/IjPZRRsJuht98bcIAmZdzK1EpQ6Unouo9hpe5gRXdT5BYmtBBkhIPihOArDJ8J3K/IYZW8PVX
	HMnlxPuIId6VxjHk/Lnpy1v8Uz8jQ1MzXdCMftdGS7kO2ykyvqFSfsjk+N/QHmt26HnNh6JrdZi
	Bd1B/yyZzEu6DM84L19jGPepmkukIjrwczRBFpHM2iqWDH9vfnYcMr5sz1cgZnsYkqpl4L3oQqg
	X2igCsdNxiC+0b/gYJrMA6hL6ZAbONlQRZhNdb+AaZ+qvVehWY/6Jf8g8zi3pMJM5AOTHP4yvUz
	cbRQRQr9ZNdKngixuWVFecizyYB3qwuYY111s278d7JF6K3yv42TXStEKH6x0a6cs+afEcoGChP
	w+P3j1/IjJQMN9qfQAsU+QIixHdyNjAB3tRoQzHJ4dj2FxCJH2aTrTia0cLtuSnB7Tw8OlNhNH5
	KrmNHfp0+Xqd1Z+q2INSp90r5+Y9M3dZmyYbnp0wmmk3QQjaBFzbyBC2iLI1+VET6i5coR0odSw
	Yo/uLBTmC+hedTqy66pkf0fi8t+Sv9AqccbuOen+Dj1UTqje/d96AOZGEAT3I602xwM74X/pcOp
	+KF0=
X-Received: by 2002:a05:622a:a881:b0:536:6f7d:1145 with SMTP id d75a77b69052e-55d76a27f9fmr215459771cf.21.1795447534734;
        Mon, 23 Nov 2026 07:25:34 -0800 (PST)
Received: from ziepe.ca (stjhnbsu6iw-159-2-142-59.dhcp-dynamic.fibreop.nb.bellaliant.net. [159.2.142.59])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d78807b5fsm100671031cf.6.2026.11.23.07.25.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 07:25:34 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xVVvB-00000000sLi-2ANX;
	Mon, 23 Nov 2026 11:25:33 -0400
Date: Mon, 23 Nov 2026 11:25:33 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Leon Romanovsky <leon@kernel.org>, Nicolin Chen <nicolinc@nvidia.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
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
Message-ID: <20261123152533.GE179082@ziepe.ca>
References: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
 <2026112325-emit-squeezing-5d96@gregkh>
 <20261123090623.GK14811@unreal>
 <yq5a7bi3riha.fsf@kernel.org>
 <20261123115803.GN14811@unreal>
 <yq5awlq3pto0.fsf@kernel.org>
 <20261123135638.GO14811@unreal>
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
In-Reply-To: <20261123135638.GO14811@unreal>

On Mon, Nov 23, 2026 at 03:56:38PM +0200, Leon Romanovsky wrote:
> > >> >> But it should not, as you are making driver core changes that will
> > >> >> mirror the same thing that that patchset is attempting to do.  Please
> > >> >> work together on this.
> > >> >
> > >> > +10000000,
> > >> >
> > >> > Greg,
> > >> >
> > >> > This series came as a surprise to me given the fact that device trust
> > >> > series is exactly for that - allow confidential computing.

Device trust's primary role in enabling confidential computing is to
give space for the userspace to do all the TSM and attestation stuff
to get the device into T=1 private DMA mode.

It is the userspace that does all this and the userspace bridges from
"I got the device into T=1 mode" to "Now it meets my userspace policy
to be trust level Full" and then finally "Now I can bind and start a
driver"

The two concepts work together, but they are not linked inside the
kernel.

> > >> > Adversarial is equal to the "cc_accepted".

I expect most policies would make "cc_accepted" as a full trust level,
but we do want to allow adversarial as an option too.

> > >> I think the confusion stems from this thread:
> > >> 
> > >> https://lore.kernel.org/all/yq5amrr8yldi.fsf@kernel.org
> > >> 
> > >> Based on that discussion, I understood TRUST and eligibility for private
> > >> DMA to be complementary attributes. Device acceptance determines whether
> > >> a device may access private memory, while trust determines whether the
> > >> core must enforce additional restrictions. 

Yes.

> > > Device trust does little beyond preventing driver binding and recording the
> > > trust decision in "struct device". The missing piece, which I would expect
> > > you to address, is ensuring that the IOMMU and private DMA are configured
> > > only after the trust level has been decided or as part of that decision,
> > > rather than beforehand, as they are today.

They are orthogonal and unrelated.

All the TDISP and T=1 DMA flow is about how the DMA API works and has
no direct impact on trust level. You can choose any trust level for a
device using T=1 DMA.

Getting the device into T=1 should influence how the userspace decides
to set the trust level, but it doesn't interact inside the kernel.

Aneesh has it right that these are orthogonal and unrelated
activities. There may be some confusion as Dan attempted to couple
them, but after discussion we have moved away from that since it
doesn't meet all the use cases.

> > What I am still trying to understand is how you view the DMA allocation
> > and mapping paths determining whether a device can access private
> > memory. Paths such as force_dma_unencrypted() and SWIOTLB receive a
> > struct device pointer and need to decide whether to use private memory
> > or shared buffers.

It is Nicolin's work here that needs to go before the TSM drivers:

https://lore.kernel.org/all/cover.1794343501.git.nicolinc@nvidia.com/

Because that is going in and starting to fix the DMA API to work with
T=1 DMA devices.

The TSM side should sit on top of that to enable it for PCI devices,
not just integrated devices.

I think for now lets just focus the TSM series on the attestation side
and we will tackle the PCI and DMA API issues as another series.

Jason
