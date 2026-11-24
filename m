Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795488525;
	b=elPBanufeQV2ol+vAR/Wbc5DeKhHWMt9det3HpNxkFCCq0f/Wa28SajwKSr/H7lnRE5i
	 lzh82F/rmFizvHIZQbFxCU5wXHswrQa0ut04kh8vEO1+xsgsbyAwQk1a6hRS7HG4B0M8y
	 +DXyrTx9c+a/nlfOnBzOPn4ozPVf0G8WxLNYZIejQ8RI9q5eZ/x5vHVbTReFTNrG4ZEiU
	 K074I2TLdm/1x6u2chADbYW/e/k4sC5YM7/QJ98XSW8ZFdgXc41LdN3mDWnNg9+MrZtqH
	 C9FrYzylSnaa9C8ZjsGAWxH9GQloIXGtwEkgCZZ4mRB/YQEWzOi4uX3c6aksgTbMYJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795488525;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=feBMC46Kg9xglm0UM1RjR22Aujb6Qvmmma1ih7AmJ8A=;
	b=RLmSFy3IJ+xSiGOGNriDVaj6mQdtOiP4QsWmc23IGsL4giInDM3FASDXwtDG9ccg0NcK
	 W3b3SKBH1u9ce3SbsjTJisj0LdkU+MXZeQ2EW9TpXJHj+/3WFdeQUN1WaiNohf2OEDx+f
	 VEttYDPSESvCJ0Da3yggsvtntenAPA4w9ySBIhwr93eUYeXnnKYLv9jMavsErMFVm1eOQ
	 hkiGXQ/dxrbwB+wsBSZ/+MCE83KIPVjRbKh87owAcfBDh+OXnLwv9sXdqJ1frgZkilOXR
	 rSmWi3M+YOo4krOw+JyXlGCs4BBkeIps1Jhdvpx63gWhEgb+pwCBiPE2/YvgkrYuBJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=RtNA4YSv;
	arc=none smtp.remote-ip=209.85.219.47
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A3D606A321
	for <patches@lists.linux.dev>; Tue, 24 Nov 2026 02:48:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D2A3D606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=RtNA4YSv
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-91c847584b8so45987986d6.0
        for <patches@lists.linux.dev>; Mon, 23 Nov 2026 18:48:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795488524; x=1796093324; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=feBMC46Kg9xglm0UM1RjR22Aujb6Qvmmma1ih7AmJ8A=;
        b=RtNA4YSvLFMZ5lnSiZh1m1NlL+D+riCXGTcQdepviTMC3WSnMRhYxcLrqMYSyFcISA
         lc5MWZXgRQcIAsAbDjrgEqTk7DeXyYZZkiOm8X/uCU3eZtVKJK44Zom4T03iQ1AsVoyT
         Ysblwh8C/dugkHM2f0c7Fh0Epz+5BFxRCOOgTwFZc9cS5mbyKjmom07PZOt+nOjlfznH
         MFUlvndIDvQCLlNAIid00vWeHyvV3nrPiutokTEH9blml+TO3aC9SOSR2z5WXqsHP1Wu
         Ogmu+Tq4grBPADLinR+htLAeN+MAHIra8jOwTHLVZ0KugquZv+w+xIOtHSdODzTRKb/H
         d7Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795488524; x=1796093324;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=feBMC46Kg9xglm0UM1RjR22Aujb6Qvmmma1ih7AmJ8A=;
        b=gZ9HpNhlIdC9wL6EgKsRRDTpTqGITKe5M3WMMJu57fW1k8OkUw9YLGAj+/QNMcoRTq
         FpU+R/QSGFVFsFCzsQmIRYC0HcgrTeWix1BBl0WyM9t2QsBSrNEHZUCREyLLbd49cjOI
         7AU+7KDebzfcOwCga1Vj8hb16CduaTWRzvKx8ItMlWsUUqxjqFMdVw4RXUo9D+e2+BPM
         UCOi1Lcgfn+zTAHDC4tJrMff39MmIZBfF5eUHnzPzQzrh2JhDB0Sb/Op8smmnXmLk6vc
         BF7iZwJ6+S7y09QR4ptVpcMbkOJIY/2nJU8ZkFab1akljuB/G7anh6cpOlYOt1+d8im2
         DdwA==
X-Forwarded-Encrypted: i=1; AL+hErF66h09zAkur+01GbDLfgwKtrOGbBTCyWAfwFLUtkxn60gaefLvSxdTd7R4+3Wu/B6VkArnoLNY@lists.linux.dev
X-Gm-Message-State: APuU4Z8fITc5mjJRrV3tNoxksAwr/6EPkv65aPHfg7G28b8/VXiIbZNj
	puFnBB0kKGTR3Zx6xKMhOAxWd8hsSpXHQOXK7XrR/Wqc+TX9ZfPU0txjaUnDxr4YZpo=
X-Gm-Gg: AZFdTZfIAQNPSz4cmR1A9lax81E3auw6n83szFL+Lup3hRsD43Ezob+jJrn6O+MYNMT
	kt5/1OZGCFKev2wY9XYe6CbQmiOqlxAZBQtH95epoFfBqcK2aDi8B6UdjVvfSQ+S5LVlJXOqxWB
	w/0q1+HdHPidBkX7pZaHUcO8HwPCL0OGh3p+Pu0j2/1TLfIqfIwK1Ym1aytpTde1khtvXfYqkUC
	Z+B7vFY+08vtghs2snST7MqDHEdu0D9LOSh7WviDmuZSeEuzlQi/8xLQxVe2jChj9yau5tWqAqS
	Ph3hxlFGDVO+ZNXlcgPXeQXxps7iHbp8wZtXZZJSN3PQKyAtnLrJyY1mVviAZYcF2xN1O+6o+vH
	FS8R1cKAyklD0QYbKFH4Htbr5+WCLiY/DD4J+1nuHNw7GOhw7N9QB0/3USnykJxXqB8i9ZdwUAu
	186si7QQrmyaRWRxKnMibhJTLsHYemRdF0lkULTA4Hs/7VEni78QSucFJPrUxyHQBqEE8x1of33
	drGIC1i4s7EcCubKxa3/4BBVwveMcla8Zo5DNbpNrtDDErirJrKGv+9U4UmRHmQoEqZ0QcuLH01
	lY1fwQw=
X-Received: by 2002:a05:6214:2263:b0:921:37ed:5c6 with SMTP id 6a1803df08f44-92137ed06efmr217313286d6.22.1795488523691;
        Mon, 23 Nov 2026 18:48:43 -0800 (PST)
Received: from ziepe.ca ([142.177.118.84])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-921349d14d1sm122581686d6.18.2026.11.23.18.48.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 18:48:43 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xVgaI-000000002sY-302b;
	Mon, 23 Nov 2026 22:48:42 -0400
Date: Mon, 23 Nov 2026 22:48:42 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	linux-coco@lists.linux.dev, Dan Williams <djbw@kernel.org>,
	Leon Romanovsky <leon@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
Message-ID: <20261124024842.GB9566@ziepe.ca>
References: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
 <20261123083337.2731019-2-aneesh.kumar@kernel.org>
 <f377271d-353f-4c8e-94d5-98159a66ab28@amd.com>
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
In-Reply-To: <f377271d-353f-4c8e-94d5-98159a66ab28@amd.com>

On Tue, Nov 24, 2026 at 11:11:49AM +1100, Alexey Kardashevskiy wrote:
> On 23/11/26 19:33, Aneesh Kumar K.V (Arm) wrote:
> > From: Dan Williams <dan.j.williams@intel.com>
> > 
> > The first attempt at an ABI for this failed to account for naming
> > collisions across host bridges:
> > 
> > Commit a4438f06b1db ("PCI/TSM: Report active IDE streams")
> > 
> > Revive this ABI with a per host bridge link that appears at first stream
> > creation for a given host bridge and disappears after the last stream is
> > removed.
> > 
> > For systems with many host bridge objects it allows:
> > 
> >      ls /sys/class/tsm/tsmN/pci*/stream*
> > 
> > ...to find all the host bridges with active streams without first iterating
> > over all host bridges. Yilun notes that is handy to have this short cut [1]
> > and from an administrator perspective it helps with inventory for
> > constrained stream resources.
> > 
> > Link: http://lore.kernel.org/aXLtILY85oMU5qlb@yilunxu-OptiPlex-7050 [1]
> > Reviewed-by: Xu Yilun <yilun.xu@linux.intel.com>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
> > ---
> >   Documentation/ABI/testing/sysfs-class-tsm | 13 ++++
> >   drivers/pci/ide.c                         |  4 +
> >   drivers/virt/coco/tsm-core.c              | 95 +++++++++++++++++++++++
> 
> I'll take to the tsm tree, thanks!

Lets not take any new sysfs APIs please. These all need a careful
thing and we are not having a good history right now on any of these.

I'm not even sure what this is supposed to be for, is it debugging?

Jason
