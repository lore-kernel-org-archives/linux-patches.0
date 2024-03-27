Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2727C47A7F
	for <patches@lists.linux.dev>; Wed, 27 Mar 2024 09:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711532710; cv=none; b=uhO4e95m4j1TXO0B8oG8bs6uTbBNtaOoXI1dLhDAzveLZljQdc+MDeqdVxqGnkvdhvO8wTHZ67tTNo0lCzqspTIf16jG24Jp4R2zUpdTFY9sDAQMGqJKu7nQAhcRviRsKmLR6wAmxOeTuEXcRnamIQjHptYnh0dyWu4w6uI5LQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711532710; c=relaxed/simple;
	bh=ZbttmVnJJAbv9nn2CzBE5AAgM1MnF9lflRwLiMMmvCE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QXzqikiMaF6bE3UvQCBwiIj8iioM1VqPKk/BVw1J3z279PToIG8rEjStDXKeJWVfQg0yfY8ylJ+Daqnq5CuKFNNYyAMZKembWumMUFJyvxWEnuESXkSnLqQwMkauV/w+YoesORAjT38t2ZYrIyrjExXf/V/Pa5/9gX2zQa4kNgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aMqa84tC; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aMqa84tC"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4140eed8a4fso51425e9.0
        for <patches@lists.linux.dev>; Wed, 27 Mar 2024 02:45:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711532707; x=1712137507; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OryA0DL61czc89Wzep0XB0rzJHnSp9bK/m8Spm5OPdc=;
        b=aMqa84tCnDT35NMiPPt7ryI5AG1czikkMS+HRT+MzXThwNTTGp1+kX4QoZ9ql4s9j2
         yFBf+es9NjylkFgAfRIs+ZvkuCAFCzGoHfE+nbUT1y+B3k1li7/zqGARGtwolfOqtjG4
         PBAQFDigleVojr2RDjfTzdx0TM9ximWOqvRcyM3Cg38zEngqWKSCDjMmh7HHeB0/8LvZ
         u/b1Z0CTt7o/4jZOtFoBzYIvbEAMVCD9Nh/rNS3OI4Ro9QGO3TEUyPzfvXpk/WXD+A+o
         d6VGdaFXslBanJHZVHWMBZeDUITH/MSNm6C0lWFkiLLU2bv7WlXWEASJqimFSJpI52Ea
         qAmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711532707; x=1712137507;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OryA0DL61czc89Wzep0XB0rzJHnSp9bK/m8Spm5OPdc=;
        b=RrU2p/3SCpAZdwVhQMAn37bUEP2Ffsjfhl0JRJdenDzCuaeoHpfkKLVf+rzAwWHjye
         RcLEM9OWFLQKvh90UBSXQYnz4XCObcJX/NoAbeATkNbzTzkO40JwolNDZrxxLP8nvRTo
         lOyw0N0t9qozmELXK9gyPbfAJPsjJgNJ8K+hJMJAsr/ZYW+3tWsTDuErF77LHceO26VZ
         txVfluWyZRhgvykQ1wOJfI6Uv5g3x7MXLQByH8GL1fadwvWYzboXxZMAEolZVikouZP6
         BrLeYsPuul/7s55Djws3mtpwUN/KpymDPt5wcklUwLvmEjJRWDZw1GNIjpPJy232ncOo
         ocBA==
X-Forwarded-Encrypted: i=1; AJvYcCVajddvahVgsEI2GkQf+OsNprnCml3Lwc4gebifEsyL4WG+vqf0dPEpISAuUFXLQJkk/xfpcgAPa8sVz1AN9OrWg90WL+ea8Q==
X-Gm-Message-State: AOJu0YwcY697bCSKGwM2KC1Izv+oreje1TPVbGofCvakSttgrF4LZ0bP
	eWEjkD2drKY8Qls7Rye3kBmt6iMvG1t+NiCSUOC5nUwJXOZGwUBlOhbWFX4giQ==
X-Google-Smtp-Source: AGHT+IHGxC+UcFmgO1pgvObazWB/Eg7/jxwHvz1SR3oU22gwkCQVZujrI3wM0Nhp4dZpcAGjG2YAYg==
X-Received: by 2002:a05:600c:35c8:b0:414:1400:a776 with SMTP id r8-20020a05600c35c800b004141400a776mr71704wmq.5.1711532707236;
        Wed, 27 Mar 2024 02:45:07 -0700 (PDT)
Received: from google.com (180.232.140.34.bc.googleusercontent.com. [34.140.232.180])
        by smtp.gmail.com with ESMTPSA id bg16-20020a05600c3c9000b004149530aa97sm1014168wmb.10.2024.03.27.02.45.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 02:45:06 -0700 (PDT)
Date: Wed, 27 Mar 2024 09:45:03 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v5 05/27] iommu/arm-smmu-v3: Make CD programming use
 arm_smmu_write_entry()
Message-ID: <ZgPqnzA_a4ZdYGXM@google.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <5-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <Zf7S109OKJlRVXiR@google.com>
 <20240326183055.GL6245@nvidia.com>
 <ZgMeNZP08aZu-nVe@google.com>
 <20240326222758.GB946323@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240326222758.GB946323@nvidia.com>

On Tue, Mar 26, 2024 at 07:27:58PM -0300, Jason Gunthorpe wrote:
> On Tue, Mar 26, 2024 at 07:12:53PM +0000, Mostafa Saleh wrote:
> > On Tue, Mar 26, 2024 at 03:30:55PM -0300, Jason Gunthorpe wrote:
> > > On Sat, Mar 23, 2024 at 01:02:15PM +0000, Mostafa Saleh wrote:
> > > > > +static void arm_smmu_get_cd_used(const __le64 *ent, __le64 *used_bits)
> > > > > +{
> > > > > +	used_bits[0] = cpu_to_le64(CTXDESC_CD_0_V);
> > > > > +	if (!(ent[0] & cpu_to_le64(CTXDESC_CD_0_V)))
> > > > > +		return;
> > > > > +	memset(used_bits, 0xFF, sizeof(struct arm_smmu_cd));
> > > > 
> > > > This is a slightly different approach than what the driver does for STEs,
> > > > where it explicitly sets the used bits. Is there a reason for that?
> > > 
> > > It is just more compact this way
> > 
> > IMHO, it seems too much to have this mechanism for CDs for just one
> > SVA case, but I'll need to go through the whole seires first to make
> > sure I am not missing anything.
> 
> It is pretty ugly if you try to do it that way. You still need to
> create some ops because the entry_set should be re-used (I mean I
> guess you could copy it as well). Then you have to open code the
> logic. And then the EPD0 path is somewhat fragile. Something sort of
> like this:
> 
> void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
> 			     struct arm_smmu_cd *cdptr,
> 			     const struct arm_smmu_cd *target)
> {
> 	bool target_valid = target->data[0] & cpu_to_le64(CTXDESC_CD_0_V);
> 	bool cur_valid = cdptr->data[0] & cpu_to_le64(CTXDESC_CD_0_V);
> 	struct arm_smmu_cd_writer cd_writer = {
> 		.writer = {
> 			.ops = &arm_smmu_cd_writer_ops,
> 			.master = master,
> 		},
> 		.ssid = ssid,
> 	};
> 
> 	if (ssid != IOMMU_NO_PASID && cur_valid != target_valid) {
> 		if (cur_valid)
> 			master->cd_table.used_ssids--;
> 		else
> 			master->cd_table.used_ssids++;
> 	}
> 
> 	/* Force a V=0/V=1 update*/
> 	__le64 update = target[0] & ~cpu_to_le64(CTXDESC_CD_0_V);
> 	entry_set(&cd_writer.writer, cdptr->data, &update, 0, 1);
> 	entry_set(&cd_writer.writer, cdptr->data, target->data, 1, NUM_ENTRY_QWORDS - 1);
> 	entry_set(&cd_writer.writer, cdptr->data, target->data, 0, 1);
> }
> 
> void arm_smmu_write_cd_entry_epd0(struct arm_smmu_master *master, int ssid,
> 				  struct arm_smmu_cd *cdptr,
> 				  const struct arm_smmu_cd *target)
> {
> 	struct arm_smmu_cd_writer cd_writer = {
> 		.writer = {
> 			.ops = &arm_smmu_cd_writer_ops,
> 			.master = master,
> 		},
> 		.ssid = ssid,
> 	};
> 
> 	/*
> 	 * Target must the EPD0 = 1 version of the existing CD entry, caller
> 	 * must enforce it. Assume used_ssids doesn't need updating
> 	 * for this reason.
> 	 */
> 	/* Update EPD0 */
> 	entry_set(&cd_writer.writer, cdptr->data, target->data, 0, 1);
> 	/* Update everthing else */
> 	entry_set(&cd_writer.writer, cdptr->data, target->data, 0, NUM_ENTRY_QWORDS - 1);
> }
> 
> IMOH, at this point it is saner to have just implemented the used
> function and use the mechanism robustly. Less special cases, less
> fragility, less duplication.
> 

But that adds extra cost of adding ops, indirection, modifying STE
code..., for a case that is not common, so I think special casing it
is actually better for readability and maintainability.
But again, I need to finish going through the series to get the
full context.

Thanks,
Mostafa
