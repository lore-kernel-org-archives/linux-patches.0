Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795527859;
	b=nJPxgPPy+zYGU7hsqQtNqozi7+cv7UG+fkbvSOlowu1Sh4OkJuw4WvIPrUnqaGfFL0/M
	 X4wgZILEkb9W84AxZN23+DWf82CdLE08qlEP8k9uE7dqJj6XtUWimhvQrhvDWdvKjzijh
	 HRW1aNqM0ATEHNgcjSk8pnaJdxdFkLk5KhDWSxBZ1PMlVPb7BteVv6KF37Bq0wXS6gDHF
	 UIW86qW5jMsxjFtIBD8cslzgUVO9Jt2JifalLp5/RM9S0iQLwQ7Jq4oyOVO+iLuHwodZC
	 yzEMWZxq52p7ajssXXEBBJe70FfKJcvyy8BQww1B33bGhE9kuDcsahOXaU5NsKfj47A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795527859;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=GOO2liEeh3ZNTv2cYVirV3xpcqc+Z2dTdYpM4j0pd4M=;
	b=BppNxYyu95dfaf/2rElXNPlJqauDqVrOiFI651Y5zCouAMrVE4KN9rn01kC7RnFNUHtH
	 j5sVXpkV0B47+DxVbfhmzjjGqOLeRIBVY+kBLOkkp80JUaaDQEzAkUVi3f/VJ/MEtrGbF
	 z7Eq0PGuAp+61VTHAnPniWb62CLv67XFRghfw7alOOqY9mQxyiQRhNxpbjYorvg6vRwBn
	 DIRRaAhiksr6JUDcp1pG2mI/R6Ay0/uOi2AVsIEIrwbJCwKQ38XIY3JMcc/s5IoNT2GCc
	 fyJW8yi3AH0S+ZeyGACLVZFTM0Jg7FSXLoSjVha1zmQtDTFrvL3co8ftONbYpEwiAuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b="fxBd6d1/";
	arc=none smtp.remote-ip=209.85.219.46
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA41606A327
	for <patches@lists.linux.dev>; Tue, 24 Nov 2026 13:44:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0AA41606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=fxBd6d1/
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-91e8a05ec5aso62635446d6.1
        for <patches@lists.linux.dev>; Tue, 24 Nov 2026 05:44:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795527858; x=1796132658; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=GOO2liEeh3ZNTv2cYVirV3xpcqc+Z2dTdYpM4j0pd4M=;
        b=fxBd6d1/8uC1nMuxQ26Hy97S88WFxPZpKH9iERv491Rw3cwRIDH6U6QK5PqpwalQaP
         y241V5L9IQCKoZ+XwCrcqq/ZsiZkim6aOF9ev6lTFe6GuaKjZjlzBtMj0fUiJo1qUmpm
         Z2dx2RUoaAKBK0N8wU3UqeIk5J3TuOPwJYg31cSLwqdBZTvHv+qGbDbgG+K0TqBC1OaH
         Ov8zmAdg364g/mUbDSGSED57D/F86datpbDZZ+SOjLpeVCu84VIHTjWaLftjRrIT9IEa
         h9by/FazbgIVm3Z84KxjHt2hz/vJ9mZaWXmok7YA3cu88hdd3KBaF7GXojSqjhmNzkr9
         WKPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795527858; x=1796132658;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=GOO2liEeh3ZNTv2cYVirV3xpcqc+Z2dTdYpM4j0pd4M=;
        b=QETzD/zNZfTUX0DAucj0iGEY3OqUHVx2i5mV5fozGod8lFf3wLhioYU0hw2LgWY8gw
         gHtmBOcU/oAt8EWqysF61eY+OuFaJkfdZ9hYZAng3mC8P8R0u/0mitUCyXgV7mIeOT0V
         fJb1l7h5Tt0az8zTfzYOuXh8Wc4I8UlNVkpERi90SHsbpFeDu6o0w22m32fJWLUdIBiu
         VfIFZhfKNzog6aWEEWLW8abKtzQEkWBaaYJzvgYW8oS7OMwxEaJP0fekXyNf5+7HZxhE
         8RkLcR4D7zrnhEr3oH1SU/LrSLO9zHxchf0L5VLYIPHh9yUxhkz5AhoZUxpEvDZjuI+Z
         63+Q==
X-Forwarded-Encrypted: i=1; AL+hErGN40EgzArBD6odoLPqlwBTmRMWvLk1G6sdh73GXOrN33nWRzcuay1yCtiZ/4xBiIq0SUix07Si@lists.linux.dev
X-Gm-Message-State: APuU4Z/LLj9v8kDKAYvSw5VGWDtY/xx0XEDf04jfj7qWgegOvc7BsS1m
	7kviz4VF3VHL02eMWNs/PzWmH8SBeuMCCbpnd0SmQAFP9JSEPLx3SBrRHEhEZrXU6Bo=
X-Gm-Gg: AZFdTZfdKt+hGV9Vlm0Gt7MOR0NzAjc54c9v7RjUbUZ5wfrMS+OkoYLBhde/TsBNe3j
	k9tM9QLoJdyZfSzucUsD1r1+Za/qNOXxIzv+VeqdQsCMoM1FpF0booCkvUITus/z3MShyQTfFBO
	593ykod2Pl65YF3gA54890ymc0kYyoHttrdDZh+ZMA1151qDsSIAdADI9iKynpwzQQ0ssD41gxg
	QnBkjFwCKHBj9XNNW8fLlhal3dVfVk3xzfLOhO0YZZeQRZRoa+lEolVG0pA4Jh5ZZ2KM62V6SsH
	tc0apPYlMAM7ATHp3IcCMfqYem2FmSw8SAOBG6ACth9G0N54VnLZ/xR3Nve6N5TGLrV0dBEnN8I
	TmcRhStr3NRxKs9iV0/F2RbQwHKqcQczDsMruQE+oG+vWt2E+RhNUJ6Hm6cGKCTa+JFuCLX49J/
	sQKfdD+q14trQfjZGDe0qS6B3UlwEfBrIC5uycDG/ZCmdcdRLsfuW8nl/d3Ki19/H5D4yinSv67
	ejt+FQlvdRxRVPT6J9vhGDa9mrZ4KUP3kv7Fmq2Jkt0pr6KoS5ztFKmT3SMv4OxPLvTfjLzCWUW
	qL4OSQ==
X-Received: by 2002:a05:620a:6c01:b0:93e:c12c:43f9 with SMTP id af79cd13be357-949bab6e243mr2406376285a.70.1795527857835;
        Tue, 24 Nov 2026 05:44:17 -0800 (PST)
Received: from ziepe.ca ([142.177.118.84])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-949bb3ba04bsm1055445785a.24.2026.11.24.05.44.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 05:44:17 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xVqoi-00000000QDP-3RBH;
	Tue, 24 Nov 2026 09:44:16 -0400
Date: Tue, 24 Nov 2026 09:44:16 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Leon Romanovsky <leon@kernel.org>
Cc: Nicolin Chen <nicolinc@nvidia.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
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
Message-ID: <20261124134416.GH9566@ziepe.ca>
References: <2026112325-emit-squeezing-5d96@gregkh>
 <20261123090623.GK14811@unreal>
 <yq5a7bi3riha.fsf@kernel.org>
 <20261123115803.GN14811@unreal>
 <yq5awlq3pto0.fsf@kernel.org>
 <20261123135638.GO14811@unreal>
 <20261123152533.GE179082@ziepe.ca>
 <20261123185826.GP14811@unreal>
 <20261124131754.GF9566@ziepe.ca>
 <20261124132536.GS14811@unreal>
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
In-Reply-To: <20261124132536.GS14811@unreal>

On Tue, Nov 24, 2026 at 03:25:36PM +0200, Leon Romanovsky wrote:
> On Tue, Nov 24, 2026 at 09:17:54AM -0400, Jason Gunthorpe wrote:
> > On Mon, Nov 23, 2026 at 08:58:26PM +0200, Leon Romanovsky wrote:
> > > On Mon, Nov 23, 2026 at 11:25:33AM -0400, Jason Gunthorpe wrote:
> > > > On Mon, Nov 23, 2026 at 03:56:38PM +0200, Leon Romanovsky wrote:
> > > > > > >> >> But it should not, as you are making driver core changes that will
> > > > > > >> >> mirror the same thing that that patchset is attempting to do.  Please
> > > > > > >> >> work together on this.
> > > > > > >> >
> > > > > > >> > +10000000,
> > > > > > >> >
> > > > > > >> > Greg,
> > > > > > >> >
> > > > > > >> > This series came as a surprise to me given the fact that device trust
> > > > > > >> > series is exactly for that - allow confidential computing.
> > > > 
> > > > Device trust's primary role in enabling confidential computing is to
> > > > give space for the userspace to do all the TSM and attestation stuff
> > > > to get the device into T=1 private DMA mode.
> > > 
> > > <...>
> > > 
> > > > Getting the device into T=1 should influence how the userspace decides
> > > > to set the trust level, but it doesn't interact inside the kernel.
> > > 
> > > The point is that I’m describing the reverse relationship: the trust
> > > level should determine how the device is configured, not the other
> > > way around, as you suggest.
> > 
> > They are unrelated. Neither influences the other. The user gets to
> > make orthogonal choices if they want T=1 DMA and if they want
> > adverserial. All combinations are useful and valid.
> 
> Our proposal is to represent these combinations with an internal trust-level
> enum and manage them in the kernel through that FSM, rather than maintaining
> two parallel sysfs flows that permit every possible combination.

We already talked about this when Dan proposed it. Combining entirely
orthogonal things into a huge enum is not a good idea. It creates a
combinatoral explosion, there are more security related knobs than
just these two :\

It is not even a FSM, it is a bitmap of enabled functions, and that
isn't an enum.

They are orthogonal subsystems, they should remain orthogonal in the
uAPI and we definitely don't want to use trust level to control the
TSM, that would make a mess of the SPDM flows.

All this was already discussed, it is why these two series look the
way they do..

Jason
