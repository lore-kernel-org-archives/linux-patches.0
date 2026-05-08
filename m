Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A6F141B35B
	for <patches@lists.linux.dev>; Fri,  8 May 2026 17:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778259646; cv=none; b=A9gAKLc0G1jOBpgQbJuIM1ql8S4IT6y6aT2d5KBdsxduy9MfILFn2YrU6zvk75Xchi0X0+L0EUMIjssKvaZQvxAm+vv7G2Tu/DsPSQU9pt/rQPmkoJv/5jjD7d3w246pocNd1RXKvNfhipVMPA6hmP3MApYI/MAnXgLB0jM5DfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778259646; c=relaxed/simple;
	bh=LQZWr2unc8sVlAWk2yUZEeONw0MTY23swA4fe2VvNAE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GbpNTW06bdOmx9Ii5HuIEtxHayGt7Az2FbtAcum2bUzLJgWL6aI4+5MrtA+DB4M4ZeOBzHqND3W3rCqbzu+sm0Jju7dvkLwcd1IkPKo7dmkNIZZhAv7mf52FHQtXT56hqcxuZq1CGx0Y68nDOsbVV4leKEDYC1EL4dDocyMMrt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i56LZ7LE; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i56LZ7LE"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2ba180a022dso114725ad.1
        for <patches@lists.linux.dev>; Fri, 08 May 2026 10:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778259641; x=1778864441; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KSX0WcNOlkvsZCAblteUbbAr85dTr3acCULxV7BG/80=;
        b=i56LZ7LEu2SN+mVGHsYDyH/SmRb8EtB4l1e4fY6fd6O1DmAoMxUefiJJT721cIVPAQ
         LKzbOHUqNhkrkdQsJUvZqc3p/05XWnCLG+L3F37DvwSuLFMYU57vlJ2fqfdWu3hXYOVS
         wQJix9uA3tYAlug5FHggTUsne1UZeMqK2L4PL+PVWm1fABOa7JbAx/A+WYccLPYkmCKb
         cAEtY8pRMsENkqCp0F6eM2UYbfuhjXI2QR5+Y9UvkG0Ldct3k4bV4ARtL3DdCIxunuCH
         vPbghOQqY9Ku7I/rYkNKwcdvzAntm/PlK6yasjnC9ifOUgWpnamXnPBtHPZp3Y21P4SJ
         xnlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778259641; x=1778864441;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KSX0WcNOlkvsZCAblteUbbAr85dTr3acCULxV7BG/80=;
        b=KqOSfxDdeqeswkaeJzSB4dHYv8F7shFOawB9GlKs6oe7Za5Ex0+lJDT6Nio+7P9iZf
         zLhNknyec0RXAgmpSnvrfomOr9QaURb77kZomfBFigzg5BQA+vvUR+NwCQCVGVRq64pU
         1+lW+epCaNCqoS4wJdqm3VOR5E4oIlUDXIclsF7aYXyH8a49OWVliairNYyHl9/mG++p
         QTJeBrvjhOmZzXDlpSWZBMb7aEMSSXj6H+Aa4a8X6jwxRIniyHDGAc62hF1ot4OHvJe0
         u9Tg7Sj212/yIgg2pVqIyT58wmqWyuL8lM15ARR7l2mq+diNkaQa2rSCddobjs2s2fCq
         IkMQ==
X-Forwarded-Encrypted: i=1; AFNElJ/G7V9th7Tk3Yp7Bqamo1MxTP+jgOkjt71+JHsu8exrTPp+aZmwpL5Qj6FMPNl7OjmHzoCJXK7Q@lists.linux.dev
X-Gm-Message-State: AOJu0YxP6r0iJ0//bOz72V/8WN42No5izgbs6vjtI6I4qSPSC5MYAeju
	5oph/TmXj/VKUHvqeQ/PndNAsRhgUPn4+D5z2V5PULCO2bsOlcu4hnkEqIFZnw5MxQ==
X-Gm-Gg: Acq92OH9962nQTHrRAAijS2YedBGcvytZ+1/AtNy9rnbnDR7VfquU9bzQHARA6hfYJd
	GsB67qCeBBIbKeHbZ72OGeVR+xF7k9IqdNepv5PvpAWVqjuO6DLmXa5R6BM6kQTxOlcFCiMapee
	uAAlxReO8lkoOrCTN4ZwD/0qN3c3N1yNn3tI6R6XhmHw/CzAEZE2hnEU+HJ96IRNDfH0V6B9bkM
	mz6+CroSv6g2ti5dVAEIT3xNlCgkl/YmdejydulJDXEyQSlLQb8prAK14N9YaXaOdXCDYy2KLy5
	Thview4nFUijJONMz8QVpKdNxGjvrqUDjhQ/O2qFzTNZNP8N9SY2RI2iaaA6SVThhqWy4KPOGBv
	Tti1fFrWxr4zWnq0E1Q1MAs764BsXZFGg2fKHjRSWkvkfGByAbD+iAgYVnNONpnXQ0ClUEp85R3
	rFrOUsIJq2ZNhXplNpDUql13cPHU6gCcYgWE3XH0K06a1EDNGwEUyLvVtSExpVIrV+e6jz
X-Received: by 2002:a17:902:da87:b0:2ba:f71:57a8 with SMTP id d9443c01a7336-2bae9e663eamr4007225ad.10.1778259640757;
        Fri, 08 May 2026 10:00:40 -0700 (PDT)
Received: from google.com (44.234.124.34.bc.googleusercontent.com. [34.124.234.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1d26944sm25742125ad.10.2026.05.08.10.00.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2026 10:00:39 -0700 (PDT)
Date: Fri, 8 May 2026 17:00:32 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Jonathan Hunter <jonathanh@nvidia.com>,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Krishna Reddy <vdumpa@nvidia.com>, Will Deacon <will@kernel.org>,
	David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH 3/9] iommu/arm-smmu-v3: Use the HW arm_smmu_cmd in cmdq
 submission functions
Message-ID: <af4WsCVOlOFBzy_Z@google.com>
References: <0-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
 <3-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
 <af2ebtfgOPzJMXFK@google.com>
 <20260508160041.GF9254@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260508160041.GF9254@nvidia.com>

On Fri, May 08, 2026 at 01:00:41PM -0300, Jason Gunthorpe wrote:
> On Fri, May 08, 2026 at 08:27:26AM +0000, Pranjal Shrivastava wrote:
> > >  /* Should be installed after arm_smmu_install_ste_for_dev() */
> > > @@ -4823,7 +4826,8 @@ static int arm_smmu_device_reset(struct arm_smmu_device *smmu)
> > >  {
> > >  	int ret;
> > >  	u32 reg, enables;
> > > -	struct arm_smmu_cmdq_ent cmd;
> > > +	struct arm_smmu_cmdq_ent ent;
> > 
> > This shouldn't be uninitialized, we only seem to be setting ent.opcode
> > later in the function. 
> 
> Yes, that's how the existing code is.
> 
>         struct arm_smmu_cmdq_ent cmd;
> 
>         cmd.opcode = CMDQ_OP_CFGI_ALL;
>         arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
> 
>                 cmd.opcode = CMDQ_OP_TLBI_EL2_ALL;
>                 arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
> 
>         cmd.opcode = CMDQ_OP_TLBI_NSNH_ALL;
>         arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
> 
> > Since arm_smmu_cmdq_build_cmd reads other fields
> > of ent to build the cmd, we are potentially sending stack garbage in ent
> 
> Ah, it is tricky, it doesn't:
> 
> static int arm_smmu_cmdq_build_cmd(u64 *cmd, struct arm_smmu_cmdq_ent *ent)
> {
>         memset(cmd, 0, 1 << CMDQ_ENT_SZ_SHIFT);
>         cmd[0] |= FIELD_PREP(CMDQ_0_OP, ent->opcode);
> 
>         switch (ent->opcode) {

Right!

>         case CMDQ_OP_TLBI_EL2_ALL:
>         case CMDQ_OP_TLBI_NSNH_ALL:
>                 break;
> [..]
>         case CMDQ_OP_CFGI_ALL:
>                 /* Cover the entire SID range */
>                 cmd[1] |= FIELD_PREP(CMDQ_CFGI_1_RANGE, 31);
>                 break;
> 
> Only opcode is used, so it's "fine"
> 
> Later patches remove ent and this trickyness so let's just leave it:

Ack. Sure. No strong feelings here. 

Praan
