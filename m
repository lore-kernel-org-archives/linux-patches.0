Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794521981;
	b=a6p94EfdJaKTbsLVbJyJnP00VwSv6pA5/wtJJgIQcP6ic362XwrFSaUXVmF2UYN5XIE8
	 fA/mEQsB6qj9dB8bTOj5AHVHgt160qqB0zmM7bF+w8PZTw96BJheXsFx3U6t3TA0Uqz3m
	 6kBWmYVQarhpRNfrkPg5uerWGs7AVJ4hlMDHVyOu35U3AW5rs7qfcVmdSduFwwrJlRw7P
	 mSk0xP2kEq0pV/ykuLNw49cShRoZ4oIc6fANuixJtrmuz1pr2o89TN6eRDJ2Kd/BLv7lm
	 gB79UA7brlQMa0YfTDbg73vWYd3Tn0haXvZAjL8hMWt4iyO6Hbfl073puMMph8b0cnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794521981;
	h=Received:DKIM-Signature:Received:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:User-Agent:MIME-Version:Content-Type:
	 X-SA-Exim-Connect-IP:X-SA-Exim-Rcpt-To:X-SA-Exim-Mail-From:
	 X-SA-Exim-Scanned;
	bh=MdFOkR9T1vyvJTEbm/GmyrakOZfYhcZ9ZgO9mPMwqgE=;
	b=N4eGRyHzaLSeWnyH93Tbvyy71kSqiLbwFpgp4kB5jL+bkknBhbPbBGoV3/VLcEmTMh8g
	 3FUkoBs6/JHYFV0kTDEY3v8r3aanmzDxU1w4Kaw9Ze0/qpmNgpxI1w2fbDizu0HtxaRuw
	 NMAQR8/jxuiajfliFJGIGp9pOIo76ZCnDf0juYZVeFRziVk361sfsESD8jTwd/vRicBWs
	 YHYUurI0W9XHdp8TKlLS4r63tr7lzD3vVRg9vm1ZRxOfj5qvpxrr6yK57ovwzJ9IfVWdm
	 j+Ohpvvx+wMIlFIYU6SkRjmQV3SObF+F8sl94U2/jf7TPF18HutDqPwYUmlzQhISfSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KkJPMBad;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6BE1606A31C;
	Thu, 12 Nov 2026 22:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KkJPMBad
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A31C1F000C4;
	Thu, 12 Nov 2026 22:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794521981;
	bh=MdFOkR9T1vyvJTEbm/GmyrakOZfYhcZ9ZgO9mPMwqgE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=KkJPMBadtLEVv4ypOglQwOiufTUuvQXpZInKdUsDfVLX5m16RASaLRZGF3Pfpwq5k
	 Z3l76XFR6I6l2Ruv8Kj3Nwk4AFyFkGuK9xYfnJeQQTscKJVWq3zctGaoNQdWQbyQZM
	 JTfhw6EKmkNKKAx4UaeNOGU3vdAc9pBpcDvKS3OVMw3C+ZTuYa3o9nolv7dXk4a7kM
	 FNCFi6+G/UdRgo8wHU+FMyG3JGJMXBoJe6ln/FqhEDt8uoLumgEFgCtVUE6ufwZEUz
	 22ZFh7iknY4Ssw62qkkSZGpWu/c5KtAOmDmY1R2c/TjcUPFbtZo/AbBjdVW5PwfokN
	 nqgy8nw1bs8qA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=lobster-girl.misterjones.org)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xRd8r-0000000F2ee-31UM;
	Thu, 12 Nov 2026 22:19:38 +0000
Date: Thu, 12 Nov 2026 22:22:52 +0000
Message-ID: <87ld6x8zb7.wl-maz@kernel.org>
From: Marc Zyngier <maz@kernel.org>
To: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: linux-coco@lists.linux.dev,	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>,	Mike Rapoport <rppt@kernel.org>,	Pasha
 Tatashin <pasha.tatashin@soleen.com>,	Pratyush Yadav <pratyush@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,	Christian =?UTF-8?B?S8O2bmln?=
 <christian.koenig@amd.com>,	Jason Gunthorpe <jgg@ziepe.ca>,	Joerg Roedel
 <joro@8bytes.org>,	Marek Szyprowski <m.szyprowski@samsung.com>,	Robin
 Murphy <robin.murphy@arm.com>,	Steven Price <steven.price@arm.com>,	Sumit
 Semwal <sumit.semwal@linaro.org>,	Suzuki K Poulose
 <suzuki.poulose@arm.com>,	Thomas Gleixner <tglx@kernel.org>,	Will Deacon
 <will@kernel.org>,	Russell King <linux@armlinux.org.uk>,	Benjamin Gaignard
 <benjamin.gaignard@collabora.com>,	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,	Mark Rutland <mark.rutland@arm.com>,	Radu
 Rendec <radu@rendec.net>,	"T.J. Mercier" <tjmercier@google.com>,	Madhavan
 Srinivasan <maddy@linux.ibm.com>,	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,	Shrikanth Hegde
 <sshegde@linux.ibm.com>,	Alexander Gordeev <agordeev@linux.ibm.com>,	Gerald
 Schaefer <gerald.schaefer@linux.ibm.com>,	Heiko Carstens
 <hca@linux.ibm.com>,	Vasily Gorbik <gor@linux.ibm.com>,	Christian
 Borntraeger <borntraeger@linux.ibm.com>,	Sven Schnelle
 <svens@linux.ibm.com>,	Ingo Molnar <mingo@redhat.com>,	Borislav Petkov
 <bp@alien8.de>,	Dave Hansen <dave.hansen@linux.intel.com>,	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,	Kiryl Shutsemau <kas@kernel.org>,	Rick
 Edgecombe <rick.p.edgecombe@intel.com>,	"K . Y . Srinivasan"
 <kys@microsoft.com>,	Haiyang Zhang <haiyangz@microsoft.com>,	Wei Liu
 <wei.liu@kernel.org>,	Dexuan Cui <decui@microsoft.com>,	Long Li
 <longli@microsoft.com>,	Paolo Bonzini <pbonzini@redhat.com>,	Vitaly
 Kuznetsov <vkuznets@redhat.com>,	Andy Lutomirski <luto@kernel.org>,	Peter
 Zijlstra <peterz@infradead.org>,	dri-devel@lists.freedesktop.org,
	iommu@lists.linux.dev,	linaro-mm-sig@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org,	linux-media@vger.kernel.org,
	linux-mm@kvack.org,	kvmarm@lists.linux.dev,	patches@lists.linux.dev
Subject: Re: [PATCH v9 14/14] irqchip/gic-v3-its: Preallocate VPE L1 tables
In-Reply-To: <yq5ah5huoteu.fsf@kernel.org>
References: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
	<20261104164555.3555725-15-aneesh.kumar@kernel.org>
	<86zevn1c9a.wl-maz@kernel.org>
	<yq5ah5huoteu.fsf@kernel.org>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) SEMI-EPG/1.14.7 (Harue)
 FLIM-LB/1.14.9 (=?UTF-8?B?R29qxY0=?=) APEL-LB/10.8 EasyPG/1.0.0 Emacs/30.1
 (aarch64-unknown-linux-gnu) MULE/6.0 (HANACHIRUSATO)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: aneesh.kumar@kernel.org, linux-coco@lists.linux.dev, akpm@linux-foundation.org, baoquan.he@linux.dev, rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org, catalin.marinas@arm.com, christian.koenig@amd.com, jgg@ziepe.ca, joro@8bytes.org, m.szyprowski@samsung.com, robin.murphy@arm.com, steven.price@arm.com, sumit.semwal@linaro.org, suzuki.poulose@arm.com, tglx@kernel.org, will@kernel.org, linux@armlinux.org.uk, benjamin.gaignard@collabora.com, Brian.Starkey@arm.com, jstultz@google.com, mark.rutland@arm.com, radu@rendec.net, tjmercier@google.com, maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com, chleroy@kernel.org, ritesh.list@gmail.com, sshegde@linux.ibm.com, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com, borntraeger@linux.ibm.com, svens@linux.ibm.com, mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, kas@kernel.org, rick.p.edgecombe@intel.com, kys@microsoft.
 com, haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com, longli@microsoft.com, pbonzini@redhat.com, vkuznets@redhat.com, luto@kernel.org, peterz@infradead.org, dri-devel@lists.freedesktop.org, iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org, linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, patches@lists.linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Fri, 06 Nov 2026 15:45:29 +0000,
Aneesh Kumar K.V <aneesh.kumar@kernel.org> wrote:
> 
> Marc Zyngier <maz@kernel.org> writes:
> 
> > On Wed, 04 Nov 2026 16:45:55 +0000,
> > "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org> wrote:
> >> 
> >> VPE L1 tables are allocated from the CPU-starting callback, where sleeping is
> >> not allowed.  Remove the page allocation from this atomic path.
> >> 
> >> Use a blocking allocation for the boot CPU and record the resulting table
> >> order.  Allocate a page of that order from the sleepable CPU hotplug prepare
> >> stage for each secondary CPU.  Consume the preallocated page only when the CPU
> >> cannot inherit an existing redistributor or ITS table.
> >> 
> >> Reclaim unused preallocations after the CPU reaches the online state, and from
> >> the prepare-state teardown when CPU bring-up aborts.
> >
> > No. The way to do it is to move the ITS probing out of the
> > non-sleepable CPU hotplug path.
> >
> > I proposed a potential hack at [1] (which I find far more palatable
> > than this proposal), but the real fix is to probe the ITSs as
> > devices.
> >
> 
> Could you share a bit more detail on what you have in mind?
> 
> Are you suggesting that we create a platform device for each ITS and
> initialize it through the driver's probe callback, while the rest of the
> GIC initialization stays in the existing early boot path?
> 
> Would that mean the main GIC is operational during early boot, while
> ITS-dependent features, such as MSI delivery and direct injection, become
> available after the ITS devices probe?
> 
> Is that the split you have in mind?

Yes. Then once this is done, all the tables become normal DMA
allocations, for which there should already be adequate support.

	M.

-- 
Jazz isn't dead. It just smells funny.
