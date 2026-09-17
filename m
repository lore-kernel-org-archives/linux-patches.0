Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BF4A554090;
	Thu, 17 Sep 2026 13:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789653202; cv=none; b=AKd3qtmCJM+MQVS4LVwJaa0Z39d9ybYPX74pfFceVOQ8h6oR/lkBXuAOlRVsA9hDeLDhAsTFqy1VvvazeG7yYtkmtlgjmyzwvTlU1zg0Bkp+C5Q1uAKRqTtNc2Z/xHM3CsXdGvQpsglwz88zMiQSUV8NkGCosD2GVATgyji9Fbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789653202; c=relaxed/simple;
	bh=t5colIHZPnqvp1qR2cHIYqN9edtoP17qxQ9J+aPMaps=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ihvygjBvool8E6ATHh7ry0878aup9iv5E6pFKWwTI5XVK0H8avkQYjRIm/R1niweW8mr8iDTJtDRfG3YwpJ2bBYU1wsEizw04Y8IDnmD5RUf0c6d6hXu/Tf21tBOe+RkL2wYM8rxbzer0oREFAP3xHtGFeRXPPOQhdovA2nVELQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=U8Rh1CZA; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="U8Rh1CZA"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3B3101476;
	Thu, 17 Sep 2026 06:53:03 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4F8523F7B4;
	Thu, 17 Sep 2026 06:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789653186; bh=t5colIHZPnqvp1qR2cHIYqN9edtoP17qxQ9J+aPMaps=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U8Rh1CZA1LqhgyuQt4FgAMAbwzomS66419rwgSoCSbkq/y0P9QKHld5Td7W3fRRg2
	 FDzWXA+vF5U18/zBboRDmwEpYQdiZ924F1rv0QbOIq+Zksryd1IZ+swQD+ziMEEVwr
	 CetYEA1YdmuplZjsKkx5vJ3+xtEE9PJltlxcp5iw=
Date: Thu, 17 Sep 2026 14:52:57 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Will Deacon <will@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	Randy Dunlap <rdunlap@infradead.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	David Matlack <dmatlack@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>, stable@vger.kernel.org,
	Vijayanand Jitta <vijayanand.jitta@oss.qualcomm.com>
Subject: Re: [PATCH v6 1/9] iommu/arm-smmu-v3: Handle ARM erratum for CONT
 under invalidation with SVA
Message-ID: <aqvwuUtw3P4cfgh-@J2N7QTR9R3>
References: <0-v6-9cd17417d355+281836-smmu_tlbi_jgg@nvidia.com>
 <1-v6-9cd17417d355+281836-smmu_tlbi_jgg@nvidia.com>
 <aquxuBnh6pdxu4-8@J2N7QTR9R3>
 <20260917131601.GY3968357@nvidia.com>
 <aqvuyse0hmNCGJqt@willie-the-truck>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqvuyse0hmNCGJqt@willie-the-truck>

On Thu, Sep 17, 2026 at 02:44:42PM +0100, Will Deacon wrote:
> On Thu, Sep 17, 2026 at 10:16:01AM -0300, Jason Gunthorpe wrote:
> > On Thu, Sep 17, 2026 at 10:24:08AM +0100, Mark Rutland wrote:
> > > On Wed, Sep 16, 2026 at 09:27:42PM -0300, Jason Gunthorpe wrote:
> > > > The erratum (MMU-700: #3777127, S3: #3673557) deals with under
> > > > invalidation of a CONT PTE grouping in the SMMU. The recommended work
> > > > around is to use a Range Invalidate (RIL) that spans the entire CONT. The
> > > > only user of CONT in the kernel right now is through SVA sharing a CPU
> > > > page table that contains a CONT created by the mm.
> > > 
> > > As someone familiar with VMSA, I've never seen "RIL" used to describe a
> > > range invalidate and I think using that in the code below is confusing.
> > > I *think* "RIL" has come from "SMMUv3.2-RIL", which is the SMMU feature
> > > for Range Invalidate *and* Level hint, where "RI" is Range Invalidate,
> > > and "L" is Level.
> > 
> > Yes,
> > 
> > drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h:#define IDR3_RIL                    (1 << 10)
> > 
> > Unfortunately I've noticed a couple of places like this where the SMMU
> > terminology and VMSA differ a little bit. In these cases we've
> > historically choosen the SMMU naming in the SMMU driver to be
> > consistent with its spec.. I've definately seen this gets confusing
> > when talking to people familiar with the CPU spec and IP.
> > 
> > I had guessed it ment "Rang InvaLidate", but you are right:
> > 
> >   RIL, bit [10]
> >        Range-based Invalidations and Level hint support for TLBI.
> >        The value of this field is an IMPLEMENTATION DEFINED choice of:
> > 
> > The driver also calls it ARM_SMMU_FEAT_RANGE_INV, but I thought
> > range_inv everwhere made some very long names.
> > 
> > > Can we please spell that out as "range invalidate" or "range op"
> > > (matching the arm64 architecture code) rather than "RIL"?
> >  
> > > That'll be easier to follow, especially as nothing in the code mentions
> > > what "RIL" means -- that's only mentioned in this commit message.
> > 
> > The whole series uses ril as a shorthand for IDR3_RIL, and the spec
> > often does the same:
> > 
> > [25:20] SCALE Range invalidation scale.
> > 		  * See below for use of this field in range invalidation.
> > 		  * When TG == 0b00 this field is RES0.
> > 		  * If SMMU_IDR3.RIL == 0, this field is RES0.
> >                          ^^^^^^^^^^^
> > 
> > So I'm certainly sympathetic, but I don't know we should diverge the
> > driver from the language in it's own spec.
> > 
> > Do you have a recommendation for a suitable short name? It is
> > meaningful work to rename everything in this series.. Will?
> 
> I think that using RANGE_INV / range_inv would be more consistent with
> the existing code, but IDR3_RIL should remain as-is because it maps
> directly to the spec.

Yep -- to be clear, I didn't mean to change the IDR3_RIL naming, which
matches the architectural naming of the SMMU_IDR3.RIL field.

My concern was that 'RIL' was being used to refer to a range invalidate
operation (e.g. "a RIL"), which doesn't match any existing terminology,
and is opaque to the reader.

Using RANGE_INV / range_inv, along with "a range op" or similar in prose
sounds good to me.

Mark.
