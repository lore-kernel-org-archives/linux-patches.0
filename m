Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290342BD11
	for <patches@lists.linux.dev>; Tue, 23 Sep 2025 00:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758588699; cv=none; b=KoJT97d0arnyw65Nhw7bEmoCskvxl+WYnKjUaw8yxg9oUHhLhE1x7Nw8JVsDYF8JbnDiQHAR7M4h19EP2mTmoMgLhm9CAggDj9ZvUJhdtyZIiJRhBSxhhdchjGkiHCLWskJ2ltC/+tHJXm0+9A8288mP5sxEkeRosOBiuowpwbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758588699; c=relaxed/simple;
	bh=dLhm4LgNhR5mdQZSmBFvKzdtUHvA2mS6/XQxGDbK3Fk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ftjng88+avJFkToExZ/AzBMr/cNne8GAVkYhPl/xHLKyOQcxFfYlrKbtK85fwMRL1CWhaw5SFIKzjro3/og5nxaTH8GbeDBYkvcZ0GBXE+C2hwdx6cjZ3PvkLrQ/VkwLAepa+C9exNo+0egCQO4+lx8p6M9ZOymH2rOI/Ycszi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O83h0cuA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O83h0cuA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758588697;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H5iTHO8SAQmP6KeYsXAWuHLqRvS2XzjaWtgcdw6rXFw=;
	b=O83h0cuAvF8QDNkFm5YkLrvvU5eJSi5XKUoH7cv9dx3RTh3XWe6XE7nACP97prp8nJ/3Hu
	B4ZzvxjL07b7dPdUVT0b4mtjmJPM+sAo0xqgjNezbujKgvQFct+XMt/ErKXlrviCJGwLM6
	MAcnL8ow3FyBNgf2k9evXnDtJJJU118=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-640-ihx6D_qvNc62do9l8YimOA-1; Mon, 22 Sep 2025 20:51:35 -0400
X-MC-Unique: ihx6D_qvNc62do9l8YimOA-1
X-Mimecast-MFC-AGG-ID: ihx6D_qvNc62do9l8YimOA_1758588695
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-79538b281cdso78396856d6.0
        for <patches@lists.linux.dev>; Mon, 22 Sep 2025 17:51:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758588695; x=1759193495;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H5iTHO8SAQmP6KeYsXAWuHLqRvS2XzjaWtgcdw6rXFw=;
        b=fBKMHcVZHVTAVGNozRdCbpx7ZEVtGG5/TK1z3JA1UYqYepceKX35hvF5y/iq/bnR9h
         NtTz6RrNwocVcN1E5n42hhiQMO/b93q7T9nWcgd40KlPGYC4bxwBE0OM42YgYDcte5wR
         uVtJG9jMYK8k0zu8YO/X60qYM4muLeXPw/2b3u2GKEAB3WoqTGAzj/Y6lRZw2nQMynEI
         LTkMHAPvbhb11gVBb3KIopTuXymM9TuJWLKWS0jucXYetaCLYlpqhx1elidJO/DTPIn2
         jYuVDoDA+U3wLyzywTLvj6/CD3oIRhzJmsr+oogA3wGWRM6HkkTW6aG7L4lJnYLC9rpu
         za9w==
X-Forwarded-Encrypted: i=1; AJvYcCVp+tumuIkYAA4KEUzsPQsLZnFKWzfGDpzZnzMITRyqB71JuBp3NJG2sqW1LYLGVnwqWzEDLZlu@lists.linux.dev
X-Gm-Message-State: AOJu0YyY69MV2hPkpg4R2YjQTtkrBuXFM3Okw91vnBDPgczNDM2j7gGK
	776Q15EWEeXEY+IkgPw5YEoSF8xiHZVYCenKrNJ3c2XQvMnnHLP4N/Vu0y2+j8LRsQscHSvUTAl
	dMdPS74qZHL949QS5al4saKbeWROiJ/CxzRbHBKzdYNE0vgXLklAEJG6HT/4=
X-Gm-Gg: ASbGncuNl2sz50nw5g8k/i/g9GprQt3DyanRdJdadHJFjjLTWnoow+gGb9zjdB0klDK
	MUdgqVDIkZJ4leo8uorBbpkwpVnAnO6wSUb0oaG2cMFir5/szezPGH421H803/UMIaOy4OEtHAw
	JjoSeeLUEecDL5QUEmJJgsYxgCt1FcSdvZPf1EIaUKadRw3scEtU8JH4u9rtqacXZoZ/c3E32mN
	CBGCQyJdVGTuD2wIn6wfRkrkmuHDe1KGxycD7QaZyO8RP8in0iC7raH92v8ESl2c4MIhBTg56Sk
	gukM2je6GTIHiRLsu6+B6pRZ1QmNbeSc+AFgO29N
X-Received: by 2002:a05:6214:240f:b0:70d:cef4:ea42 with SMTP id 6a1803df08f44-7e7a024aaa5mr8493836d6.1.1758588695285;
        Mon, 22 Sep 2025 17:51:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGtQ843uNCITnUkv1WbfVZrcAx/pYKTrBIqD6TgGbEMGluu0dapZ4MeWMUHT2U8u/TdPFwWnQ==
X-Received: by 2002:a05:6214:240f:b0:70d:cef4:ea42 with SMTP id 6a1803df08f44-7e7a024aaa5mr8493506d6.1.1758588694720;
        Mon, 22 Sep 2025 17:51:34 -0700 (PDT)
Received: from [192.168.40.164] ([70.105.235.240])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-79351b9de18sm82855666d6.48.2025.09.22.17.51.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Sep 2025 17:51:34 -0700 (PDT)
Message-ID: <1845b412-e96d-438a-8c05-680ef70c04e6@redhat.com>
Date: Mon, 22 Sep 2025 20:51:31 -0400
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/11] iommu: Compute iommu_groups properly for PCIe
 switches
To: Jason Gunthorpe <jgg@nvidia.com>,
 Alex Williamson <alex.williamson@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
 Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
 Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
 Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
 kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
 tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
References: <0-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
 <3-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
 <20250701132905.67d29191.alex.williamson@redhat.com>
 <20250702010407.GB1051729@nvidia.com>
 <c05104a1-7c8e-4ce9-bfa3-bcbc8c9e0ef5@redhat.com>
 <20250717202744.GA2250220@nvidia.com>
 <2cb00715-bfa8-427a-a785-fa36667f91f9@redhat.com>
 <20250718133259.GD2250220@nvidia.com>
 <20250922163200.14025a41.alex.williamson@redhat.com>
 <20250922231541.GF1391379@nvidia.com>
From: Donald Dutile <ddutile@redhat.com>
In-Reply-To: <20250922231541.GF1391379@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: lS4Rn7J5eo7jq9VKeIeq66HiKdzoVnYOMDJg4UrjBFg_1758588695
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/22/25 7:15 PM, Jason Gunthorpe wrote:
> On Mon, Sep 22, 2025 at 04:32:00PM -0600, Alex Williamson wrote:
>> The ACS capability was only introduced in PCIe 2.0 and vendors have
>> only become more diligent about implementing it as it's become
>> important for device isolation and assignment.
PCIe-2.0 spec-wise, was released in 2007, 18 years ago.
If hw is on a 3-yr lifecycle, that's 6 generations (7th including this year releases, assuming
gen-1 was 2007); assuming a 5yr hw cycle, that's 4 generations of hardware.

Maybe a more interesting date is when DC servers implemented device-assignment/SRIOV
in full-scale, and then, determine number of hw generations from that point on as
'learning -> devel-changing' years.
I recall we had in in 'enterprise' customers in 2010, which only shaves one generation
from above counts.

> 
> IDK about this, I have very new systems and they still not have ACS
> flags according to this interpretation.
> 
>> IMO, we can't assume anything at all about a multifunction device
>> that does not implement ACS.
> 
> Yeah this is all true.
> 
> But we are already assuming. Today we assume MFDs without caps must
> have internal loopback in some cases, and then in other cases we
> assume they don't.
> 
> I've sent and people have tested various different rules - please tell
> me what you can live with.
> 
> Assuming the MFD does not have internal loopback, while not entirely
> satisfactory, is the one that gives the least practical breakage.
> 
> I think it most accurately reflects the majority of real hardware out
> there.
> 
> We can quirk to fix the remainder.
> 
> This is the best plan I've got..
> 
> Jason
> 

+1 to Jason's conclusions.
We should design the quirk hook to add ACS hooks for MFDs that do
not adhere to the spec., which should be the minority, and that's what
quirks are suppose to handle -- the odd cases.

- Don

