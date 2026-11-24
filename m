Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795526740;
	b=3UO/rmhpNDROKyuN5wH+Wt757eFwVAx7dlOQEePYnuyUIvs/lU4GL6kLcSi/46drBLZD
	 o5ftCk0bSzQiY8AZWp/Wh4+S+lSmDzS4aj7OzOJLdIHp+0VkTkvy37CmJac+Axth7QQEO
	 BD9Sx1tDGnjiud8WGvaaUcuXjmt/I3MibBKL0AmIkjz6I3X7laHED9ictvjds6GklpWmS
	 WtPgyZGZnd/bi3tj6UWVjCTZPxhP0sKGcdOZHhZZHhWd/xLWFXXqxQVvkIiM1Y9Wj5eo5
	 pSHIIOn/7sz9SBGf8RC0P0mlwWYIVikSKXtvhAg0rVDm3C7Q6syEbkcJKw+ruspi2Qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795526740;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=r5dD9s9FuhBNn4Ff1ZcKdILM46rO3ylOWd478evROc8=;
	b=FeeZlRqMUp8QEIO0W3ov5CAtIW3ak7wcNO71b40mCpVxgZznzoIWjskVLVnmgr5qnTJP
	 P7u7vrg0DpY+cdkNzLyNagS547s4LiulqHvXZjlNhgTt8iRrqvMnjbnhrzIMQJoi/j4SE
	 QAyJPk2BXWJvcgjT0k4WlJR3BSdo8TWl+OJuppZqq7MOKEjaBC/rlWjjb/qAQ10+kIIgL
	 +E1ncLOjiAAjJ+uiE/RdI1tKJl9nLYHAQ57gRzF3ilp1ptmwX7TBbVSlJ1XtyDnVBx4xx
	 lJEP2BgGY8YsSB3ihAg93kp1IdYbGHjzbAy7rMnGQ0wHx8O2a/3sKk/nFcEJiGiWnEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a7VtzHqC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80CD4606A321;
	Tue, 24 Nov 2026 13:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a7VtzHqC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 848491F000C4;
	Tue, 24 Nov 2026 13:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795526740;
	bh=r5dD9s9FuhBNn4Ff1ZcKdILM46rO3ylOWd478evROc8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=a7VtzHqCy/wmyJE3p2zv8lRvaXv0SqDbCICu/Nbfm1hHEiHj5caoQtBYtk+QN4Q7q
	 BfYRtkFs0bGN83HkDopScSSmwyWoJlf9GN9Pk5Lny0PbimRGuTS17cvEIfrI8VWTPa
	 rIxjkkUPee9U8AYMyRMofQUQbe+3e/G+M7W0U4qouGgQuYvHQbydFFZ29DnQT9OsrD
	 pZ7g4f4TR0HgMtbSmAyGUF54etza95SW0vCIj0ld+R/oxMZ29KjdZARq0Ms1TxQskP
	 4garfneAL9ClMXY2VpjIg64ipqruAPvAtUjIXrntUsfNqyT047kcQ+MfNfg4K7lOCs
	 nvKjP3XxzVNMw==
Date: Tue, 24 Nov 2026 15:25:36 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
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
Message-ID: <20261124132536.GS14811@unreal>
References: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
 <2026112325-emit-squeezing-5d96@gregkh>
 <20261123090623.GK14811@unreal>
 <yq5a7bi3riha.fsf@kernel.org>
 <20261123115803.GN14811@unreal>
 <yq5awlq3pto0.fsf@kernel.org>
 <20261123135638.GO14811@unreal>
 <20261123152533.GE179082@ziepe.ca>
 <20261123185826.GP14811@unreal>
 <20261124131754.GF9566@ziepe.ca>
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
In-Reply-To: <20261124131754.GF9566@ziepe.ca>

On Tue, Nov 24, 2026 at 09:17:54AM -0400, Jason Gunthorpe wrote:
> On Mon, Nov 23, 2026 at 08:58:26PM +0200, Leon Romanovsky wrote:
> > On Mon, Nov 23, 2026 at 11:25:33AM -0400, Jason Gunthorpe wrote:
> > > On Mon, Nov 23, 2026 at 03:56:38PM +0200, Leon Romanovsky wrote:
> > > > > >> >> But it should not, as you are making driver core changes that will
> > > > > >> >> mirror the same thing that that patchset is attempting to do.  Please
> > > > > >> >> work together on this.
> > > > > >> >
> > > > > >> > +10000000,
> > > > > >> >
> > > > > >> > Greg,
> > > > > >> >
> > > > > >> > This series came as a surprise to me given the fact that device trust
> > > > > >> > series is exactly for that - allow confidential computing.
> > > 
> > > Device trust's primary role in enabling confidential computing is to
> > > give space for the userspace to do all the TSM and attestation stuff
> > > to get the device into T=1 private DMA mode.
> > 
> > <...>
> > 
> > > Getting the device into T=1 should influence how the userspace decides
> > > to set the trust level, but it doesn't interact inside the kernel.
> > 
> > The point is that I’m describing the reverse relationship: the trust
> > level should determine how the device is configured, not the other
> > way around, as you suggest.
> 
> They are unrelated. Neither influences the other. The user gets to
> make orthogonal choices if they want T=1 DMA and if they want
> adverserial. All combinations are useful and valid.

Our proposal is to represent these combinations with an internal trust-level
enum and manage them in the kernel through that FSM, rather than maintaining
two parallel sysfs flows that permit every possible combination.

Thanks

> 
> Jason
> 
