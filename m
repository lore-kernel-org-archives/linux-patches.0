Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0E5292B2E
	for <patches@lists.linux.dev>; Mon, 16 Jun 2025 13:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750079355; cv=none; b=NkqGgofgaIT2T3A8Hkio7Chdt+rYSRDBQ1BWahZ1OjUzs2c/Qjf7C4WM2ZadUZivk14FtQ5KpTP6pmSQx4z0/CSPDgWTX9osixYNemxA1dIJ59lMhoKAKe3k+9OQb3a7Hq7ueBqsS7IB0VGVuQi0YhFl79ar4AImqgZdscOS+CQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750079355; c=relaxed/simple;
	bh=mbyl5OXkWqYUPxXU7YEwGwzWceS42PNsUXDiLKdjHeM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ONAYLINeL2E7Rzx5ryUiR321Me4tV6r5lWP4y/gelSKXsVXkLdIasttxvBQmwmxutefdC6/thSPuHbO/ld2MXYS3Mcm5J8BUVWcHhex+MmLp8Ih1T+MRwai6ptH4nBtz2GOsULaxL86e8U8ZOc9pyDNSqXEi9wYFxNeS8ijC6tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=YiQZrE86; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="YiQZrE86"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-6faf66905baso64318656d6.2
        for <patches@lists.linux.dev>; Mon, 16 Jun 2025 06:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1750079353; x=1750684153; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OlPt6HGrhBZHmQKdGeykmC3k0brj4QqdFhzAJiZkO8k=;
        b=YiQZrE86rpJav95S9hsTOgMg7MDv+SCJCVIt/6kJTmvoftCAV3jtt2XRjjy57LwAUT
         B0N8d//ZLt6VEi6qn+C/S+ChAdQgm65eqVe2oIR4isWyPbvoERSTEbO8FYQ/fSfy3+VJ
         wBTeNadIfah52SbQvKN2mb2KKxh696KTj0jH9tuq5yC9Vzee0n5EpkxiYLbPbUBpj/yp
         i5E859Ic9AHtnYIzVQVmqQbHHC48fXf4OQs8Pqb/woQamSLkS0tyGGltXY32BkRX/tX4
         k5lFmiOicvP2k5PryGWvvokBcqaIIbb3PEb4/LvtOvgB5JnzuD7G4I++OHxjTM5Ih4Gc
         c7sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750079353; x=1750684153;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OlPt6HGrhBZHmQKdGeykmC3k0brj4QqdFhzAJiZkO8k=;
        b=dawJb/jqFcASFGae2POcQKVeJ+k+I1LILNPYTXDdrzGfvW4y1BSJnb0mdLNisEWIGg
         aQjb4zDLSurdING4qfufs4vaDVpYUWomPHB/BDhF0stJVDnvcx1Ag0DCeUgnzIZk/mmx
         oPMz8jmnqaYRrwOtooKVYZ3DmjXX7RdPc3jz4z4/gGg1+uDpLmZdCnhqKBVbU6bk7BnY
         explcM+4E5QC6fpCrKUYayzkwtUx4z4mMnlCRnRHAAI5DmVdx+gQApnZ6eCZeHWSzsXn
         T/43y7bXE8k0URIotfLpU9GBu6c8E/EnSd0NAScd+EiK9XyDmeXM/4THFDbJNYZQKoAD
         WIpQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQVa/FXeWCAKwb6bCgMfFen3914BhEh99hB5Ae/7eKNvcSUW1iRf6nu2utxk8/p7KpSYdGA/PZ@lists.linux.dev
X-Gm-Message-State: AOJu0Yyh1OjIuwgVf/oOBde3mGp7Ied4pEHE2728GzkODR2w0t1TSoNm
	V9mPXK0dNffQfJmzs7+Mc5tdXoUdQ3dVLlI5Nmxdrz4VP6NLhd4Raz6HzlNV6S3LVGI=
X-Gm-Gg: ASbGncveyJ+9xCfRzsFCaUDI1lxEjLAskl3l8nvYnklQSJYPI0RaHzohZ9juWUxFIsp
	/Vml2EfNu6cq1J5wcjAjNb5vZcpOC8Vx3zA1vzuttdgTM8B20sJGuO+5hfWzInn0TeicJ0EOZc1
	yGlJuQ0nRujTgL/CudyQDLrsIizVWux2VpGayaBPv+qHTUvJmbfh+cAopAOJoikSqsnn561KlSJ
	Pv28QnWiqow7JKGY4RtfiBuU0P8QRdAkqwx3buAQccy0UJgKgyX7MyXEFTKv4AN1NaKfabV6Clf
	dpxc9fY6AmSghGYgC32vHuK8l8cO/XOM48ixlKEnTbWfs5U7+94NGvUYTW7lH6FLpXT8Zouduml
	0WK7R1sUqhTnLPzMM2l/fKjGgHOi3AZjkXqIvZg==
X-Google-Smtp-Source: AGHT+IFYwnfrlyEOgdj8TrGnzF9X6IlaZQJ38GRIzTE1wgTjrgnCanKObhnDaStP1HkHOZyR/IYWjw==
X-Received: by 2002:ad4:5d6f:0:b0:6fa:d8bb:294c with SMTP id 6a1803df08f44-6fb47726e99mr137566516d6.14.1750079352531;
        Mon, 16 Jun 2025 06:09:12 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-56-70.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.56.70])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6fb35b20f67sm50759076d6.16.2025.06.16.06.09.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jun 2025 06:09:11 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uR9aJ-00000005gPp-17Iv;
	Mon, 16 Jun 2025 10:09:11 -0300
Date: Mon, 16 Jun 2025 10:09:11 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Robin Murphy <robin.murphy@arm.com>, Nicolin Chen <nicolinc@nvidia.com>,
	joro@8bytes.org, will@kernel.org, bhelgaas@google.com,
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org, patches@lists.linux.dev,
	pjaroszynski@nvidia.com, vsethi@nvidia.com
Subject: Re: [PATCH RFC v1 0/2] iommu&pci: Disable ATS during FLR resets
Message-ID: <20250616130911.GA1354058@ziepe.ca>
References: <20250610163045.GI543171@nvidia.com>
 <20250613192709.GA971579@bhelgaas>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250613192709.GA971579@bhelgaas>

On Fri, Jun 13, 2025 at 02:27:09PM -0500, Bjorn Helgaas wrote:
> On Tue, Jun 10, 2025 at 01:30:45PM -0300, Jason Gunthorpe wrote:
> > On Tue, Jun 10, 2025 at 04:37:58PM +0100, Robin Murphy wrote:
> > > On 2025-06-09 7:45 pm, Nicolin Chen wrote:
> > > > Hi all,
> > > > 
> > > > Per PCIe r6.3, sec 10.3.1 IMPLEMENTATION NOTE, software should disable ATS
> > > > before initiating a Function Level Reset, and then ensure no invalidation
> > > > requests being issued to a device when its ATS capability is disabled.
> > > 
> > > Not really - what it says is that software should not expect to receive
> > > invalidate completions from a function which is in the process of being
> > > reset or powered off, and if software doesn't want to be confused by that
> > > then it should take care to wait for completion or timeout of all
> > > outstanding requests, and avoid issuing new requests, before initiating such
> > > a reset or power transition.
> > 
> > The commit message can be more precise, but I agree with the
> > conclusion that the right direction for Linux is to disable and block
> > ATS, instead of trying to ignore completion time out events, or trying
> > to block page table mutations. Ie do what the implementation note
> > says..
> > 
> > Maybe:
> > 
> > PCIe permits a device to ignore ATS invalidation TLPs while it is
> > processing FLR. This creates a problem visible to the OS where ATS
> > invalidation commands will time out. For instance a SVA domain will
> > have no coordination with a FLR event and can racily issue ATC
> > invalidations into a resetting device.
> 
> The sec 10.3.1 implementation note mentions FLR specifically, but it
> seems like *any* kind of reset would be vulnerable, e.g., SBR,
> external PERST# assert, etc?

Yes, there are a bunch of states where a PCI devices is permitted to
ignore ATC invalidation TLPs.. Aside from all the resets power
management is also a problem.

Jason
