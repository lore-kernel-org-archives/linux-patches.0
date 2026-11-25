Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795591425;
	b=HVOBExS1lbhzoUcVDoWwVbmXHIDwaM7G5Mk3cfhLQAkMgdZBJwj/Gcrk/+YVi5J47EbV
	 k1ecxg7sS8QHBViROEbxRTQY/15FMbvBz32NFh5JG1ZTg5LW3tnL17Zyfq6Vu/J2C/45e
	 hCK4/euEztzkyIHdsfe+ArK3gnrMudKziCY+AXXPj1HovYSnXD7bgCykm6zl/YSRHZgTV
	 u0lN71KkFWDN3UT+hC5UiekXreBxzDvKuXX6PEwucyJVmj0OyCk1G0np0BlA5LEtxjodX
	 n4YW1GLTQuQZI9CZa9G57e81UiUkJ3Gw1ejiAaJBMxYYAJAWX/eQrpmOyLCbgRWwT8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795591425;
	h=Received:DKIM-Signature:X-Mailer:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:MIME-Version:Content-Type;
	bh=q0hHWQYAcpLXZYWDPR8xQDF7EnYAaANCqBcrQywzfyU=;
	b=UoMrFac7m34Et3F50/BYl0lPsuxYYaVf4gwEPCrosJj0lf+WESompr7lgYdD5ycAXtUj
	 UCz5N0Rj+UIxwQd1TxTbHiSLv+8Pd6144tD6iF+r0DkLGOlWAEYHClCueqwhudQf8doRi
	 AuelNPUjK4XJDueNUkUNw2mJpcctUGzf6GWOtRWzMoQ0Zx7aWvysasF/K2Nj/vagohmR+
	 pKjp1XNDFabaKlA68R9ksjG39plzP1irvMhKV7ZbONC8Ifgbt27W4q0mdbswCmRdqsgYC
	 lb9y+QI4qkYP6OPdjAVadi4psJfSEtBK09XwRMeRxBFAIQTDDa41Jk4EsoA9+V85hpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hnofm9ol;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F98606A323;
	Wed, 25 Nov 2026 07:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hnofm9ol
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F13F1F000C4;
	Wed, 25 Nov 2026 07:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795591424;
	bh=q0hHWQYAcpLXZYWDPR8xQDF7EnYAaANCqBcrQywzfyU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=Hnofm9olul8X7U563TFP9EoBxPQH6Cku69KsUU7t9hAkp1G7O+zSkVsJ+Bkpp0frG
	 ZSjjNSGxc3K6ajhlxq8OpaFfMOzGPEO5qjmvN/TE3MOIqkAE4hqkyKJa8E/3sCX+oj
	 9GIj48Rbpb8Rl+AxOtn9LBH2pz9gANgrYN0LyP3g8simq3jeo8oyFbbmjAx+1mNgDQ
	 4TbSCb5P27rkXsOAJnJdA9m8Z8f++u/h0mFS5FNNGPoaB9w16axwBSN+P2ep1JooBl
	 J4b6wPabWVhiIlwly9lhGfeSMBacvaND+/vHY7GMKEoeHHZWcY5jlq4JijHtodTLcb
	 DpgwCjZvWXZSw==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Alexey Kardashevskiy <aik@amd.com>
Cc: linux-coco@lists.linux.dev, Dan Williams <djbw@kernel.org>,
	Leon Romanovsky <leon@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Lukas Wunner <lukas@wunner.de>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	driver-core@lists.linux.dev, linux-pci@vger.kernel.org,
	kvm@vger.kernel.org, patches@lists.linux.dev,
	Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v1 01/10] PCI/TSM: Report active IDE streams per host
 bridge
In-Reply-To: <20261124024842.GB9566@ziepe.ca>
References: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
 <20261123083337.2731019-2-aneesh.kumar@kernel.org>
 <f377271d-353f-4c8e-94d5-98159a66ab28@amd.com>
 <20261124024842.GB9566@ziepe.ca>
Date: Wed, 25 Nov 2026 12:53:33 +0530
Message-ID: <yq5azeux9xxm.fsf@kernel.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

Jason Gunthorpe <jgg@ziepe.ca> writes:

> On Tue, Nov 24, 2026 at 11:11:49AM +1100, Alexey Kardashevskiy wrote:
>> On 23/11/26 19:33, Aneesh Kumar K.V (Arm) wrote:
>> > From: Dan Williams <dan.j.williams@intel.com>
>> > 
>> > The first attempt at an ABI for this failed to account for naming
>> > collisions across host bridges:
>> > 
>> > Commit a4438f06b1db ("PCI/TSM: Report active IDE streams")
>> > 
>> > Revive this ABI with a per host bridge link that appears at first stream
>> > creation for a given host bridge and disappears after the last stream is
>> > removed.
>> > 
>> > For systems with many host bridge objects it allows:
>> > 
>> >      ls /sys/class/tsm/tsmN/pci*/stream*
>> > 
>> > ...to find all the host bridges with active streams without first iterating
>> > over all host bridges. Yilun notes that is handy to have this short cut [1]
>> > and from an administrator perspective it helps with inventory for
>> > constrained stream resources.
>> > 
>> > Link: http://lore.kernel.org/aXLtILY85oMU5qlb@yilunxu-OptiPlex-7050 [1]
>> > Reviewed-by: Xu Yilun <yilun.xu@linux.intel.com>
>> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> > Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
>> > ---
>> >   Documentation/ABI/testing/sysfs-class-tsm | 13 ++++
>> >   drivers/pci/ide.c                         |  4 +
>> >   drivers/virt/coco/tsm-core.c              | 95 +++++++++++++++++++++++
>> 
>> I'll take to the tsm tree, thanks!
>
> Lets not take any new sysfs APIs please. These all need a careful
> thing and we are not having a good history right now on any of these.
>
> I'm not even sure what this is supposed to be for, is it debugging?


I think this helps users identify active IDE streams and determine how
many secure streams remain available on the host bridge. I would not
classify it as a debugging-only aid.

A sample output for a toplogy given below
# lspci -t   
-[0000:00]-+-01.0-[01]--+-00.0
           |            \-00.1
           +-02.0-[02]----00.0
           \-03.0-[03]----00.0
# 

# pwd
/sys/class/tsm/tsm0/pci0000:00
# ls
0000:00:01.0  0000:00:03.0              pci_bus  stream0.0.0  trust_policy
0000:00:02.0  available_secure_streams  power    trust        uevent
# cat available_secure_streams 
255
# ls -al stream0.0.0
lrwxrwxrwx 1 root root 0 Jan  1 00:48 stream0.0.0 -> 0000:00:02.0/0000:02:00.0
# 

Here, I have set up an IDE stream with 0000:02:00.0.

The previous discussion cited in the cover letter indicated a need for
this because the number of streams available at the host bridge level is
limited.

-aneesh
