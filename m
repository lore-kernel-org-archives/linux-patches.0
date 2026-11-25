Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795582329;
	b=EKaE21Y6ZSa0gQPByfmA8e89n5LdB9eMwiAbzeEAZzGAowmMV5X9F4FX7MYc7pabv6+F
	 PhglEHE2eE8lcGzOKWm8UpAR7xJrpvI2Yle158iwHkLaEgZzBi0d0VRcV9QfaIvfAUJeZ
	 i5IQ0LQ5zR2hgN4wCSBWFSVLMxr5K7iK58BwTjIgYK4UGUNMs1f3JVnpoT9ytM6NenJ/l
	 vh0JF7AQHunEC17p9fa3aEJ/tydGBjrHzAzyDykelc4e/MfTw6QILOQ2+ohyrfHjwJ7Lb
	 Rjm06quLSIb6FC/l+SvXgzSi1XXskhfn6SSNhaXKujRjPRCqW1EB3q1V0ehYg01ksLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795582329;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=UfsA9CwJ0qOfvuF+NW18HhX6r6LNmP5pTktEx9vryhc=;
	b=Nka/xV21toAsYEU4JPf2NlQcgNDPDsJ/INhZ12MOghHHdgL30T7B+VwhLAxn4fP632N0
	 uktw+lbLNky9t90EelMO19rvOWIEZE6miMe9X5cQZvyiulMxbLE2wwykdlJA6owY+LaLX
	 gIl7HFUD4OZAv8cAZtQrICqxk8thD2OflnKAPWLYoCIuVBPqI2MXKc8dqApOByV9djnQG
	 56ikF6gn0mIy12buxmRVyBP1gPvHE82PHwRvIuH27hylmcm97E4dxOokIPfRq13iNeeCW
	 yBROl8CZQF9a92KjSAYgaWuY6zVGFwGL90FKPKgCTjiDwmibVDVWtS08Gf6iPf7Ljww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N5WvpHxk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7754606A31E;
	Wed, 25 Nov 2026 04:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N5WvpHxk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1500F1F000C6;
	Wed, 25 Nov 2026 04:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795582327;
	bh=UfsA9CwJ0qOfvuF+NW18HhX6r6LNmP5pTktEx9vryhc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=N5WvpHxkDSBJ4VG//Q65BqDCUHQS56DYuBT+qbcytUhFnv9Jm42LjFWpw6L1GlrAw
	 IZkCRljOIpXsCcQJ+sbBv+anljYdVJOoLeyiiS17U92qiqcDM/fNrlLUeR7JjGyoaR
	 xxq6pzP4k30H/zxRSQZBeExU4iZHTKNAsF0bscd4=
Date: Wed, 25 Nov 2026 05:52:27 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	linux-coco@lists.linux.dev, Dan Williams <djbw@kernel.org>,
	Leon Romanovsky <leon@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Lukas Wunner <lukas@wunner.de>, Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	driver-core@lists.linux.dev, linux-pci@vger.kernel.org,
	kvm@vger.kernel.org, patches@lists.linux.dev,
	Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v1 01/10] PCI/TSM: Report active IDE streams per host
 bridge
Message-ID: <2026112519-hesitant-deviation-9917@gregkh>
References: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
 <20261123083337.2731019-2-aneesh.kumar@kernel.org>
 <f377271d-353f-4c8e-94d5-98159a66ab28@amd.com>
 <20261124024842.GB9566@ziepe.ca>
 <25fa4ffc-96cd-4851-8ac7-dd3750b71f15@amd.com>
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
In-Reply-To: <25fa4ffc-96cd-4851-8ac7-dd3750b71f15@amd.com>

On Wed, Nov 25, 2026 at 02:30:26PM +1100, Alexey Kardashevskiy wrote:
> On 24/11/26 13:48, Jason Gunthorpe wrote:
> > On Tue, Nov 24, 2026 at 11:11:49AM +1100, Alexey Kardashevskiy wrote:
> > > On 23/11/26 19:33, Aneesh Kumar K.V (Arm) wrote:
> > > > From: Dan Williams <dan.j.williams@intel.com>
> > > > 
> > > > The first attempt at an ABI for this failed to account for naming
> > > > collisions across host bridges:
> > > > 
> > > > Commit a4438f06b1db ("PCI/TSM: Report active IDE streams")
> > > > 
> > > > Revive this ABI with a per host bridge link that appears at first stream
> > > > creation for a given host bridge and disappears after the last stream is
> > > > removed.
> > > > 
> > > > For systems with many host bridge objects it allows:
> > > > 
> > > >       ls /sys/class/tsm/tsmN/pci*/stream*
> > > > 
> > > > ...to find all the host bridges with active streams without first iterating
> > > > over all host bridges. Yilun notes that is handy to have this short cut [1]
> > > > and from an administrator perspective it helps with inventory for
> > > > constrained stream resources.
> > > > 
> > > > Link: http://lore.kernel.org/aXLtILY85oMU5qlb@yilunxu-OptiPlex-7050 [1]
> > > > Reviewed-by: Xu Yilun <yilun.xu@linux.intel.com>
> > > > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > > > Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
> > > > ---
> > > >    Documentation/ABI/testing/sysfs-class-tsm | 13 ++++
> > > >    drivers/pci/ide.c                         |  4 +
> > > >    drivers/virt/coco/tsm-core.c              | 95 +++++++++++++++++++++++
> > > 
> > > I'll take to the tsm tree, thanks!
> > 
> > Lets not take any new sysfs APIs please. These all need a careful
> > thing and we are not having a good history right now on any of these.
> 
> hm okay.
> 
> > I'm not even sure what this is supposed to be for, is it debugging?
> yup, pretty much.

Then put it in debugfs please.
