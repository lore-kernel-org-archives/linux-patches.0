Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795460311;
	b=MRfQ/UZow90FRFPdWUoXZjtwNz4UU/+CxqgMq2BHhb0EWbJvrU8KW06131qkX+Rwv1yX
	 yGukaBNpo1NI2qG8iYlQJqQRHbU0i+1irGZdFyqDLvrwk7I/D6Se81rx9on+CuIWfhXQj
	 POunSAaxu98VyU8EExy31B4E5y0ete5lhTUXAqb/rtoJFFc6bhwFSPa1OFzc8xkNs3PbE
	 2NeF9La3WDa8TK9lhUeW1PzL0Cfil0BRoVxb9l05KwSll5uNpXyGr7T8DrpwYYz0jy3cV
	 znHZegXv9Me95QCE+iJUmaGEfjVK7ZJumN1CdNYR06vaSos04/zw2Sy2p91ZEJF2TjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795460311;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=fR7a34se89HC2qbh5eWb38xvg0rF06ySJI22k3+ve78=;
	b=uq3+LcilOnp1VXmS+iYx4QsWewhDJTG3lEYJUslb2qybTjz+k7UU5dzCcHD57zw0eCic
	 9ehKO+gf0KLvJZ/IM1bPGqSfIGN/Cwd/9UqDtwNkqkNKTi+9KUgE5EVLwgBQMKEtczZHK
	 oPj/yY93uE4Vk5TDsHdT5V5rykdy97oAX76fRn+YVrwgge6J/SNFIW4gMaouhp8CZ9bt+
	 50JAAjIz/oszv/RRYYGXpHYQVyU3qLT2zf3Y8lquPBgOUVZ5PEwHPtdEU0F967sLA/oO3
	 4u+H7OovgDtFtFaIoWqbF0SQSAnicamy6wtl8zZcpLAUtfX6IPV6ofFGTDhi60gasnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RPAFbQgJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7953D606A31A;
	Mon, 23 Nov 2026 18:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RPAFbQgJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F8401F00A19;
	Mon, 23 Nov 2026 18:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795460311;
	bh=fR7a34se89HC2qbh5eWb38xvg0rF06ySJI22k3+ve78=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RPAFbQgJIsY6Cbfkts+Xb5iSEc3MKvrSOSy/0vixNIZgILppJcQli8+0SVtZIg1IV
	 8qO3Ur+Tr3b0kf+oIsu0pVCEKMpIVKbY3s7i40Y9j7c9YoA5dQFSJOfSyi2IiT1XZb
	 h//2/06SmpC30k6uoIK8tlSZT2DEvfU+fGyeW7+AQkY7bQP5mnjnbLio8yNywl09RM
	 esz+e2V0VTsg69f43sQ9LjNM0S0eNmxEUZffnfwC3k8rp/7+MvS60l27Rte98OEQLO
	 rXQvmnF7XK9oLc08ls2volRTMSbUckS0KR8QUnl7wxsRSojiwh0sVma6/2xiTrKOKd
	 q8igKXUIvrBBA==
Date: Mon, 23 Nov 2026 20:58:26 +0200
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
Message-ID: <20261123185826.GP14811@unreal>
References: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
 <2026112325-emit-squeezing-5d96@gregkh>
 <20261123090623.GK14811@unreal>
 <yq5a7bi3riha.fsf@kernel.org>
 <20261123115803.GN14811@unreal>
 <yq5awlq3pto0.fsf@kernel.org>
 <20261123135638.GO14811@unreal>
 <20261123152533.GE179082@ziepe.ca>
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
In-Reply-To: <20261123152533.GE179082@ziepe.ca>

On Mon, Nov 23, 2026 at 11:25:33AM -0400, Jason Gunthorpe wrote:
> On Mon, Nov 23, 2026 at 03:56:38PM +0200, Leon Romanovsky wrote:
> > > >> >> But it should not, as you are making driver core changes that will
> > > >> >> mirror the same thing that that patchset is attempting to do.  Please
> > > >> >> work together on this.
> > > >> >
> > > >> > +10000000,
> > > >> >
> > > >> > Greg,
> > > >> >
> > > >> > This series came as a surprise to me given the fact that device trust
> > > >> > series is exactly for that - allow confidential computing.
> 
> Device trust's primary role in enabling confidential computing is to
> give space for the userspace to do all the TSM and attestation stuff
> to get the device into T=1 private DMA mode.

<...>

> Getting the device into T=1 should influence how the userspace decides
> to set the trust level, but it doesn't interact inside the kernel.

The point is that I’m describing the reverse relationship: the trust level should
determine how the device is configured, not the other way around, as you suggest.

Thanks
