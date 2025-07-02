Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB4D54758
	for <patches@lists.linux.dev>; Wed,  2 Jul 2025 01:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751420326; cv=none; b=VQCAxZ0m3snCBC0ZdRzlOFvR9MFpfhFQ2uTqc+iJ2AEUFENInDwJfMTf+fdkjnGvWWoHBxyuLqG9ifAbExPxlUVlnHZfjTfc/Ddtz6zDFvG0vHIzdqTJrr2o1xnoPRr1UeCT7wOygIrvfcd4yJfuZEHFwdt8n9PLtWeNaj/DCyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751420326; c=relaxed/simple;
	bh=vPktWFba1CaphVOiurjNVMsrvjbgo6h4NsplM3lBGxg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EvaysHw8hOF9Ilj6cPm3zYHmI7rXcqT1ZFkWU7ys1uqGarGasvqxbHgl0pvi9exRzuklwN0YnE+UVw3bIron5GWiINSMNFuYPcNqZh2e92iQA53y5WXYm+xwx/1VK1hYtxtijapH/SMEFcwixDgpvltH2Ybi0/Pnl2j71yIJqCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=l+ik+NHg; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l+ik+NHg"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-237f270513bso280415ad.1
        for <patches@lists.linux.dev>; Tue, 01 Jul 2025 18:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751420323; x=1752025123; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kp2cPDX2Gx1yqqbKf91cIrL6zATVqvS/PN2+ecRrrmc=;
        b=l+ik+NHgmz2d3TXzEWNXWOsIkUjSVCH9Nb5gvq2UKemHtCjPyO/Ox7b6JX7GJbqvp6
         yC/BvqzPE/Z9m0xpgkN9SEcKMdXPM5AZt1X8dIzysHAHamAOInA8Rn2W1rBVJ0jdfv5d
         Yk6vVAseBtHD1QDlApYCRil8sJFjOJgDlKcP8SbPyGtF/BTeHUXQK6Iz19XZZQ3EnG2i
         xPZokgjjn5SlM6VKmDs3WJlj1uIsTnY+FxS/q6zwfpZMsMGAiVcv7DZMrjD7Ax2Hsyfb
         j2P1hkDYwT1zaK/+howsD94LDAhCPSUILAGEKnMdXV4txdOEqPk9dVhcsjoV6Zgdyz3V
         UcSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751420323; x=1752025123;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kp2cPDX2Gx1yqqbKf91cIrL6zATVqvS/PN2+ecRrrmc=;
        b=KMnZ53rQRPkKQAENzqn4/B9ccD+TocypSh0hJncmo/w04l2e8qRnF0lgeSgB6LTeDG
         6w3aWqNcpT/xew6qE+tv+hnrVo6qbsDKdtR0Iy2H33GDGJGrgPDE/AcPON6OV+dYvgX+
         I3+L4OZPrKE7KMqBw6BfENxcCZqOmIu9cHWS+IXfyYGr6TBQRkS/SbMLPt9Q8AYYU9Hx
         mGFppy2ptZ/I3AkcGyF8TBiX6FC/gdj241gIwS/AuzATPh2DDq12726aAJ0egDzFXXNe
         8QPvTq5qW5ZcNmgtRu6l59PULsQfA7mumWv+T8S9HK639u/JD+Dwv+uCDOQzM4NgRvdo
         IriQ==
X-Forwarded-Encrypted: i=1; AJvYcCW0sG4KJzwwgJtCx1M7MQNSI3HFbURJ662ogUjG0ZfLTHomK7cyB631hOlfy10UTLFOyARGbIje@lists.linux.dev
X-Gm-Message-State: AOJu0YxgpvacsjcCDfd2F87jIJTSK8xZ4ZWiMKc1v6XaOds+lQrwtJvE
	1e6P9O8oSYnFEqXtWThN9VN0bnIXabxW/Kl5nOWp81R9zY8uRcmXMFGRmkm+bai3uQ==
X-Gm-Gg: ASbGncu5E+pxfcYHlnD4NLfaoQkpUHGW9ItmycSjBEsY4WG9UXPiSVXCgtn57k1xI7n
	rLCzmgp7VgpE6V+gi+JTDWuzwNvkF85IP7FSIFfsCtrDqfpw5JNjK29PHT04W6+uDSevPxmJvEI
	XTN03oODqDVHq4NupKdy2rq9lpARxBjpWz8xw01w3AIWSKKOeB/hdwCvjItoBI2+wIs5bcrprBu
	PFzzTa7gd/UKZ5E+mXiZlgG2aOpkOJHi1kCvIDezlCi3vAiPLFPWSOx9kt9VUsF16DhrX2qYFNS
	maL0nIo3LPPXUZtcF2Bgzh51BfYoR1uWjeVsE0FfwVcgM6MdMvgXe4hhetlrNHsqeuMhF7QH8mm
	CDJtrjWh+cT7Gw3xWWBlA
X-Google-Smtp-Source: AGHT+IGlz2Z9E445R3idcc5ZRjEaWuytfr7E4KLC8vSsZvwO+Dw22SVfjYoD7L1quVzpUqXy09mcbA==
X-Received: by 2002:a17:902:c401:b0:235:e1fa:1fbc with SMTP id d9443c01a7336-23c5fd70ee8mr4718365ad.0.1751420322911;
        Tue, 01 Jul 2025 18:38:42 -0700 (PDT)
Received: from google.com (232.98.126.34.bc.googleusercontent.com. [34.126.98.232])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74af540b394sm13073470b3a.36.2025.07.01.18.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jul 2025 18:38:42 -0700 (PDT)
Date: Wed, 2 Jul 2025 01:38:33 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: jgg@nvidia.com, kevin.tian@intel.com, corbet@lwn.net, will@kernel.org,
	bagasdotme@gmail.com, robin.murphy@arm.com, joro@8bytes.org,
	thierry.reding@gmail.com, vdumpa@nvidia.com, jonathanh@nvidia.com,
	shuah@kernel.org, jsnitsel@redhat.com, nathan@kernel.org,
	peterz@infradead.org, yi.l.liu@intel.com, mshavit@google.com,
	zhangzekun11@huawei.com, iommu@lists.linux.dev,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
	linux-kselftest@vger.kernel.org, patches@lists.linux.dev,
	mochs@nvidia.com, alok.a.tiwari@oracle.com, vasant.hegde@amd.com,
	dwmw2@infradead.org, baolu.lu@linux.intel.com
Subject: Re: [PATCH v7 27/28] iommu/tegra241-cmdqv: Add user-space use support
Message-ID: <aGSNmf5Q82xEbDpX@google.com>
References: <aGQGm1-i4M75b9Qp@google.com>
 <aGQ6KCI9OZEwHdxS@Asurada-Nvidia>
 <aGQ_F7Qx3scbbA-J@google.com>
 <aGRDtYRXFLoT+PrI@Asurada-Nvidia>
 <aGRIctg4T6cQECx4@google.com>
 <aGRcPSwaJkTeUrMx@Asurada-Nvidia>
 <aGRmaOORg-YDfncY@google.com>
 <aGRozoIDIlgl9H9x@Asurada-Nvidia>
 <aGR55PUBnwb8qT8U@google.com>
 <aGSBTpY0nkdp2TTL@Asurada-Nvidia>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aGSBTpY0nkdp2TTL@Asurada-Nvidia>

On Tue, Jul 01, 2025 at 05:46:06PM -0700, Nicolin Chen wrote:
> On Wed, Jul 02, 2025 at 12:14:28AM +0000, Pranjal Shrivastava wrote:
> > Thus, coming back to the two initial points:
> > 
> > 1) Issuing "non-invalidation" commands through .cache_invalidate could
> >    be confusing, I'm not asking to change the op name here, but if we
> >    plan to label it, let's label them as "Trapped commands" OR
> >    "non-accelerated" commands as you suggested.
> 
> VCMDQ only accelerates limited invalidation commands, not all of
> them: STE cache invalidation and CD cache invalidation commands
> still go down to that op.
> 

Right, I'm just saying the "other" non-accelerated commands that are
NOT invalidations also go down that op. So, if we add a comment, let's 
not call them "non-invalidation" commands.

> > 2) The "FIXME" confusion: The comment in arm_vsmmu_cache_invalidate
> >    mentions we'd like to "fix" the issuing of commands through the main
> >    cmdq and instead like to group by "type", if that "type" is the queue
> >    type (which I assume it is because IOMMU_TYPE has to be arm-smmu-v3),
> 
> I recall that FIXME is noted by Jason at that time. And it should
> be interpreted as "group by opcode", IIUIC.

I see.. I misunderstood that..

> 
> The thing is that for a host kernel that enabled in-kernel VCMDQs,
> those trapped user commands can be just issued to the smmu->cmdq
> or a vcmdq (picked via the get_secondary_cmdq impl_op).
> 

Ohh.. so maybe some sort of a load balancing thing?

> >    what do we plan to do differently there, given that the op is only
> >    for trapped commands *have* to go through the main CMDQ?
> 
> If we do something differently there, it could just do a one-time
> get_secondary_cmdq call to pick a in-kernel vcmdq over smmu->cmdq
> to fill in all the trapped commands.
> 

Alright.

> And this is not related to this series at all.

Agreed, sorry for the confusion then.. I thought that the "type" meant
the queue type.. I guess it's all done then. I have no further questions

Thanks for the clarification!

> 
> Nicolin

Praan
