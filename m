Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4D228137C
	for <patches@lists.linux.dev>; Tue, 18 Feb 2025 18:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739902650; cv=none; b=gz+HMJu3cYIM+vVxMVZAjaxQJgYZyYd9Pj7OCJ7j6LCbx8Ffza1Vfgs/EWnapcUs0WQz2RXFDha9si929qqDDR6VDNbLny6gsCImrzmnLz8PLOmQSGGJgB0j3RqxiBoPvFjxY4AFsZ8Q0mItyaG9fPI+4PAYqemn8win7U6gJTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739902650; c=relaxed/simple;
	bh=BOUyx5EsWWjCZqwoILlVSGflf8blEnkgIikzItCUqP0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H1GLD6yByPAJLDNi44sa/5EkTVQcXJ2auP4cFR0PzE6BFjALIzsRh41RiMfZKs5gt0/z3wsDcoC5s69bot9EWoh5p8fZVXtGgm/w4Rl1Hp6aanaOTy14hkfAeiNR06s8e+sbQmIl3b+5DzmULmy7MknCoTbCXDMzhJ3EaYCyWaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pneuUPyQ; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pneuUPyQ"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-219f6ca9a81so492695ad.1
        for <patches@lists.linux.dev>; Tue, 18 Feb 2025 10:17:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739902647; x=1740507447; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=M89M9SRzWTrfxkPQChi6cYghdfRxV0Kb26Fn5pPvW98=;
        b=pneuUPyQCty5bxfduXqlUuf8qHqrBMB0cAUeHAweZwgeLumARGcJD5k+pH9+XNp5s2
         RFrW42fe87mPM+pzqEFM65CBfFXPnE2ygC1IKUsNnp5CDyVW0JqZKmKxuvcAZHY4oPoh
         FnRl5CLXihIn8Itjtq8ilKfPWrtbQzGntAzJ0+MZdInsVO56KCXQ1d1FQXHkr/oYnqts
         1R7w6IcNK4ON4UNGmL8pZvfye/VbufX7rHp25JF6MWHolBG0kjP/CyHJrv+JuDFOB1f9
         MvDxpQoq1DGxq1V138GSBtVa/9FIkyXqmSgKLjSkDmms7U/SpLWbdSRpCtmhWuEI7PGg
         ePyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739902647; x=1740507447;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M89M9SRzWTrfxkPQChi6cYghdfRxV0Kb26Fn5pPvW98=;
        b=TG4YwC1wjNsXSBSluqFnRjYwSEChjF1nQNdnZ3WbqVh31DQ4ym7R5qP+WrL7/U8ZMT
         v885jO8V7iq8SbmIg+CUE40i6OrKdSUKI4xpG3MuLW6Aux+6A4klIGNaRy4B6dH7X0lu
         u+Fv7lFwpSZC2HmPnlCQ7kF8zg5wi7TPDrCQNjm+35pdkmBeIiJ0R41hksn0LBU/IM3L
         oGfXrFLKuQg/0aEWVTNIQW91J0Ys1bP+8xekCclf85Jmmnm4lzw52ccXQLVzwL0cn4Ny
         beT5A/6SQ94QL09eAFHedUdxHdGbhwlkcJ2bAGGDyPvvD8pVuxCSoYrS45CNJLS6qlo+
         54WQ==
X-Forwarded-Encrypted: i=1; AJvYcCW9iYerO6vqhNMoHtZ+ZFON8m72lC5VbVZmfUiLo+G5kRUVGlIJVhlfQEndBYIfgC4e/kYLOwW9@lists.linux.dev
X-Gm-Message-State: AOJu0YzgezeT5alFrpk3BkQpKu+wCYNgYM6ezrngx1o86oEfo5vvv89m
	zyDXjc0ZZXkEWkwO8Vu6IPQ+nzde1aJNQbQAV7UL422FjQKvNMMHfTNj/0Kamw==
X-Gm-Gg: ASbGncu2hanfFm78hYm4iqDlLDjrnWSAg9m8Gy/5oQAi+R8KEdUeb9RvHOiIoVVclQz
	L7GZ1IR+ulHyU9YCnfBfWfPzce9OAopy5lrbsYm3qsZ6DMmfEmZ3hWqfd9v+iWrvSiq68em8lc4
	zYobgkGGmExJtw2mYadrWt5sJX0oFyJbruAlN/71Cice54u2/TlMq/YHBvJVP1kQAifngeSgz+Q
	ENbgZAgUc6M6g5yD0M3cAs3nsnoms3/okmFpwUsBcWjvAkGB+HCJ6o6XCEGETErWYMDodBs6gTL
	t9q9wiTf68ZpFkouQCMNITzfEAjigjKygmuhXEIZFyPnm73hYXCu
X-Google-Smtp-Source: AGHT+IFkiHL5TTpaBclB/MgmM3kcQbDHYVWCGmPRDpeRclWjC4Poa8aWW8CJbN/ySGXple0OccOeRQ==
X-Received: by 2002:a17:902:fc4e:b0:216:48d4:b3a8 with SMTP id d9443c01a7336-22104c939afmr7012905ad.16.1739902646969;
        Tue, 18 Feb 2025 10:17:26 -0800 (PST)
Received: from google.com (169.224.198.35.bc.googleusercontent.com. [35.198.224.169])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-220d55960ecsm91516115ad.253.2025.02.18.10.17.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2025 10:17:26 -0800 (PST)
Date: Tue, 18 Feb 2025 18:17:15 +0000
From: Pranjal Shrivastava <praan@google.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Nicolin Chen <nicolinc@nvidia.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
	"corbet@lwn.net" <corbet@lwn.net>,
	"will@kernel.org" <will@kernel.org>,
	"joro@8bytes.org" <joro@8bytes.org>,
	"suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>,
	"dwmw2@infradead.org" <dwmw2@infradead.org>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
	"shuah@kernel.org" <shuah@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>,
	"jean-philippe@linaro.org" <jean-philippe@linaro.org>,
	"mdf@kernel.org" <mdf@kernel.org>,
	"mshavit@google.com" <mshavit@google.com>,
	"shameerali.kolothum.thodi@huawei.com" <shameerali.kolothum.thodi@huawei.com>,
	"smostafa@google.com" <smostafa@google.com>,
	"ddutile@redhat.com" <ddutile@redhat.com>,
	"Liu, Yi L" <yi.l.liu@intel.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH v6 14/14] iommu/arm-smmu-v3: Set MEV bit in nested STE
 for DoS mitigations
Message-ID: <Z7TOq-gIGPY_ztW7@google.com>
References: <cover.1737754129.git.nicolinc@nvidia.com>
 <436ac2021bb3d75114ca0e45f25a6a8257489d3b.1737754129.git.nicolinc@nvidia.com>
 <BN9PR11MB5276291C74E2DF0C8821BE718CFA2@BN9PR11MB5276.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276291C74E2DF0C8821BE718CFA2@BN9PR11MB5276.namprd11.prod.outlook.com>

On Tue, Feb 18, 2025 at 05:24:08AM +0000, Tian, Kevin wrote:
> > From: Nicolin Chen <nicolinc@nvidia.com>
> > Sent: Saturday, January 25, 2025 8:31 AM
> > 
> > There is a DoS concern on the shared hardware event queue among devices
> > passed through to VMs, that too many translation failures that belong to
> > VMs could overflow the shared hardware event queue if those VMs or their
> > VMMs don't handle/recover the devices properly.
> 
> This statement is not specific to the nested configuration.
> 
> > 
> > The MEV bit in the STE allows to configure the SMMU HW to merge similar
> > event records, though there is no guarantee. Set it in a nested STE for
> > DoS mitigations.
> 
> Is MEV available only in nested mode? Otherwise it perhaps makes
> sense to turn it on in all configurations in IOMMUFD paths...

MEV is available at all times (if an implemented by the HW) and doesn't
depend on the nested mode. As per the Arm SMMUv3 spec (section 3.5.5):

Events can be merged where all of the following conditions are upheld:
 - The event types and all fields are identical, except fields explicitly
indicated in section 7.3 Event records.

 - If present, the Stall field is 0. Stall fault records are not merged.

I'm not sure to what extent, but I think *trying* to merge similar event
should reduce some chances of overflowing the hw eventq.

> Is MEV available only in nested mode? Otherwise it perhaps makes
> sense to turn it on in all configurations in IOMMUFD paths...

I think the arm-smmu-v3's iommufd implementation only supports nested
which could be the reason.

Thanks,
Praan
