Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D17E264619
	for <patches@lists.linux.dev>; Thu, 29 Jan 2026 00:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769647604; cv=none; b=TC7wotWudSjliGlqmVCY6XwF3pzhdJTz6QJ8550kX+ZcEyl9bt0urleusCeLq7fMoVo0+WAF/nXahb0m7xPB7gtYB94dTU9MqcBBWPj37HkD31FthY3ymKrPoCOswpK/1iARG0VOLSc2oI83TUjOfxSZ9Q3C/M0Mwhj7+n8TThs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769647604; c=relaxed/simple;
	bh=OF+MmJBRYqLO4yfcVi+gc8uySaBfiQSsc840eoOTyAI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SqrtJaUevOEFNwHmPPDQBW/yj13Ea75weRjvtafExwm+qr2YN0rllVv7Go5bpSDl0gD+fed7WE8SAw1YHXXWDuV9IHHZOItkPGnaBbv+nUiCOPPYu+buKl+h2P1yR5fBk+4+0tZoJGSAHMv3DqyAaVU3wBTytxh6cWLr11VrK+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=l/Qed0j6; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="l/Qed0j6"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-50146483bf9so4295071cf.3
        for <patches@lists.linux.dev>; Wed, 28 Jan 2026 16:46:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1769647602; x=1770252402; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AaqVgHlI2seUK2YRo3bqtWiP6hNp3fDsIh3WrTJfgb4=;
        b=l/Qed0j6fBcO2mibjtY3g/i2lXJsshiw76DLyVisO4fDliL8S84L9qI1tO10uOFUkk
         0g1w8D3J2ItFP0ZydrVbew2Y7l2TWvsHlV12vAPGkloTFPkEx7Zlql/ZVGHJiPziynHh
         Zo62sPX+BxpQXgNT6u93ReBPRfO5J+S1SPUreebmvOR2OAgeqpoETr7p5KUz/GIc7hHA
         KwcdC6fQB+uYHuijOpHm8ZyNbjvxT8sLr7aZjM1FEuJ/MxK9Z2znBbSvYezEhebttq99
         H8uYjYXkm1hG56G7/17J6JqovXrUa2RdNGhTWZ96Wd76KnifHLiIWNjE5fbICIJvYR2Y
         ywjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769647602; x=1770252402;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AaqVgHlI2seUK2YRo3bqtWiP6hNp3fDsIh3WrTJfgb4=;
        b=T/za2LKjWtWMSjr9Gfp4GLX50Smn6Cw3nn+YD2PTew0SEpjGTpoe1knp02sZtCQz9s
         Z335TB9PPn4tqPn5I4Ozwt0Ff1nBUCfxY6bc0UKxD5j7wjzhe4pVkkin2n2wTQQoUWXD
         oS0gUaB5p9RkeaKRhrMCUWxdTW1jTVajaG4ecFURqFOR1SRGJ14OaeHmH0+ajLCSA8k3
         3KeW7+u/S9J8fRDXLiCH/TcRdeKBRXSueDcdlb2Z4FfJYJcHAcYOrDOHzbNBJsjR2Hjq
         9Hd+cD/JtVXp87F0t2fEZAjOMSyB2KNEKINEvPKbep97Wgp60PRlFaSZHVOuUxTjgoA7
         jkTw==
X-Forwarded-Encrypted: i=1; AJvYcCXnSkaSH3XirZ4XWLrBCa/TK/BdUwvm5zzZrn1GIwB1Ne2zUSaAIO21iuMVW788L+ZNtjNalAXH@lists.linux.dev
X-Gm-Message-State: AOJu0Yzn9MkmyiXeLItKUw83UKdYFvQkGWKgfqrabwjnCy0dGGF8QhIc
	7WRfO+WfPwCpA2c83j0eBXEusl/DTr2QRD/Cr+n0YNAoMbxOLFvFidIzlWMR6cd9Q/k=
X-Gm-Gg: AZuq6aJdwRfXIgSEgjaDY4jKJ8Jpfk8YOsBbG6DqcR3L2Mg3AAsQRm1nJioe3sKu1Yz
	B1X1r3m25nfyKVIBucfyn/hyut7exDDbm6rNdwpejybeNW1ljiSEsOYq1uVif44lWsez62pxvG9
	HNgP5QMxZtHRyKLv5yBD05f5r41xlJ/pXv6467phvOCLn/07/+kjde2UjLCsU+hVNcvHVFpjZER
	X0PJQiKlFP59KBgvmVVj5WLKogTp6PRaHG2BJJhlgxC9eUQ//aD5lAiK3USvNcznfRQB5yud4rz
	e7GYrTtFGBAG1WGPyQtYFrfViSNcOniD324vAvAJAFJgd8Ni//+rSpywFJHJP/36SPfNHBLuzOU
	t7p04gd99SCdxLLKQhx9NJwu+XoRRzXssH3S+HucxC265IygXpbWHUgrR66PTVkbMBYAS+MKVJ0
	iCylCYcY726siBUEMvtGHQ0ziQoZpHtZQdc0e9zU8yaum2NLVd9NmFvSw7+9NBSlFqGJ4=
X-Received: by 2002:a05:622a:188e:b0:4f4:bfc8:b7be with SMTP id d75a77b69052e-5032f742fe3mr89269221cf.12.1769647601991;
        Wed, 28 Jan 2026 16:46:41 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-894d36c2413sm27296786d6.15.2026.01.28.16.46.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 16:46:41 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vlGBE-00000009gA4-3SP9;
	Wed, 28 Jan 2026 20:46:40 -0400
Date: Wed, 28 Jan 2026 20:46:40 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Joerg Roedel <joro@8bytes.org>
Cc: Tomasz Jeznach <tjeznach@rivosinc.com>, Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>, iommu@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	lihangjing@bytedance.com, Xu Lu <luxu.kernel@bytedance.com>,
	patches@lists.linux.dev, xieyongji@bytedance.com
Subject: Re: [PATCH v2 0/5] Convert riscv to use the generic iommu page table
Message-ID: <20260129004640.GB1641016@ziepe.ca>
References: <0-v2-b11ebca8abb6+c096-iommu_pt_riscv_jgg@nvidia.com>
 <72olk767l4goaqsrkyelhtnzg33nxbtwnammy4asnqxukbolnh@gwypmg6n5t3e>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72olk767l4goaqsrkyelhtnzg33nxbtwnammy4asnqxukbolnh@gwypmg6n5t3e>

On Thu, Jan 22, 2026 at 08:56:12AM +0100, Joerg Roedel wrote:
> Tomasz,
> 
> On Tue, Jan 06, 2026 at 11:06:44AM -0400, Jason Gunthorpe wrote:
> > Jason Gunthorpe (5):
> >   iommupt: Add the RISC-V page table format
> >   iommu/riscv: Disable SADE
> >   iommu/riscv: Use the generic iommu page table
> >   iommu/riscv: Enable SVNAPOT support for contiguous ptes
> >   iommu/riscv: Allow RISC_VIOMMU to COMPILE_TEST
> 
> Any opinion on that series?

Let's take it if we don't hear from Tomasz this week? It brings
the contiguous page feature people wanted and now that it is tested
I'm not especially worried about it.

Jason
