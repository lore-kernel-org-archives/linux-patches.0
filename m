Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269F63009C1
	for <patches@lists.linux.dev>; Tue,  9 Sep 2025 19:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757447750; cv=none; b=Dqvj/dQAsW6PEOmI+Cg6EcLlpaXgtKbpYyDMnJAQT3XgSwA18oMgqEyTcsbRV2IsmujKNoqQ/m2IirZFg9TD1NxjRxkzjfM8DLorJSmOVzyIwKsIk760Qsu+R747vaoeChgE3y6Jj4l+CXvl7LNiRt+bcoBk3nIoJSfTVZQFSG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757447750; c=relaxed/simple;
	bh=UBTwN9epOeHMQdtzqaWFx5uzJ4dIDcreN1C53Qvt8jo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IrK5k2KM9f993LiJADskVaUAImYN9Zvka3fdaW9QT8bgcqOyAcuZzISEup0G0AHdHvnTzoUIcFkKHixjDDxaxo9Z2wTaWvyXoi6QZlQX4dzbb40qyBpng+OnjehsmeZq95+wJUJvDzlk19/kKfttQeq16wBVcV/dexUtNvUX0EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N8BUWrtY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N8BUWrtY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757447748;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VwEaYTkppqVE2bssVNAxlDikzdrxi/t7gGAUHOOn71I=;
	b=N8BUWrtYCQn2ENL2WYj3KNdAOVBlLw4IuPeTC5WdfMlz5vMNIOgWFV49Ad/Af2FGknBiQ8
	y4sNXY2KKwS8ulImht7eBDPuc1SM7bDo/uF3T+UJGHhVcTe9EKi8+5xbjHYCEnG0/qKMmc
	chjV+OOxQZb1k4oPM+0MPB/HGIdbDcg=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-113-XeS4dE97PLWYDepSCGmGdQ-1; Tue, 09 Sep 2025 15:55:47 -0400
X-MC-Unique: XeS4dE97PLWYDepSCGmGdQ-1
X-Mimecast-MFC-AGG-ID: XeS4dE97PLWYDepSCGmGdQ_1757447746
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-811917bdcfeso1369730585a.3
        for <patches@lists.linux.dev>; Tue, 09 Sep 2025 12:55:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757447746; x=1758052546;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VwEaYTkppqVE2bssVNAxlDikzdrxi/t7gGAUHOOn71I=;
        b=nO2VrFfFz/zu8jGjQ65HMAK66AXcHOOyRqSM1zAUogYfVFrjFoBPi2B936o7ev9URT
         mHXtBziVcRLDNy6g6MdI+taMPiBH6NyZFQkJZTvQQtTJGRNOi6Wld0ZPly44b4Li8uZE
         Z/CmkMnN0MJUNXhnV74vNkTKvv1luLKZ3Yp3BLFKSQ9BbAgeAaThF6pxdBsV87bYCgs4
         mwKi+yETzLn0TNjAUCIIk387zP+m7q2dQSmhYIRtOtdX5hobHCDlbkxo9Oc6rL9Sf2XH
         cweWhM3eTQIc5NdxHGQX9fdDQ0jAy4RtbA4MJ2MyEZkQkf3WP6HtO8yTMA/zA2JOR+2A
         sSBw==
X-Forwarded-Encrypted: i=1; AJvYcCWQPw2P32Y7qtRR/C/JqEn9TPc42YzctqTDmhzX0IT7gc1I1YOSeNAU2DSgD9l1wo0QvPkEc7Q6@lists.linux.dev
X-Gm-Message-State: AOJu0Yy9te/jmi3ee33JB3bkOHEchn2tToN92RXHTq5kZwroDnkc4MaN
	qXiyZZQFGGbTsNUXH0Vu8Ky/e56C800bKQMIh91t6oLMZVAE+67YtVCZTJGrCW8oEEz5AYctyds
	Y0QZpsV2WL9yEUyR84IXlc6cX+3VWawyX4ebuQbFrBt5zYey2ljhRmifo3lo=
X-Gm-Gg: ASbGncsPnEqUjVM1eZ/XG+XE45pFYxk7h/HOrrhZabSortp64g+jqKPOtFRu3T4vfVj
	TX2pl55J0erJzanBQ74zgeZvFg5xAZtFKtQb7nzrNUpDB4CdxIVA21N+QHAjgjzVna9J5rCqi+6
	K2mFz740u6MHWi/2BDeiDnabw7y3kAigq7vhHp2Ee7hXUSc5SkEFBybCY3XgkMcTQLxc3QsxS6w
	VNL2kjKV2NURWoTIYQrzgl/vlSkyBo1cx/e6Y2OzJAEgLbrOO/Vy0F6rtJJ4wYDBAGTdkCKqpl3
	S50mU6jQyPSe9tDzxV5+pij2ydb3vfn10vWC/las
X-Received: by 2002:a05:620a:2695:b0:813:ccb9:509f with SMTP id af79cd13be357-813ccb9510emr1236085185a.5.1757447746511;
        Tue, 09 Sep 2025 12:55:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFaAcXU8kXFobnNvUqNWSUsQz0woT7+jL6jE0MUCrwRybPYjUTXel6RI/GHw+5Xzip867Mnsw==
X-Received: by 2002:a05:620a:2695:b0:813:ccb9:509f with SMTP id af79cd13be357-813ccb9510emr1236082685a.5.1757447746092;
        Tue, 09 Sep 2025 12:55:46 -0700 (PDT)
Received: from [192.168.40.164] ([70.105.235.240])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-73a16bb3ff5sm74385076d6.1.2025.09.09.12.55.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 12:55:45 -0700 (PDT)
Message-ID: <25676d12-57f0-4f54-8554-a6d77d2c6631@redhat.com>
Date: Tue, 9 Sep 2025 15:55:43 -0400
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/11] iommu: Compute iommu_groups properly for PCIe
 MFDs
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
 Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
 Alex Williamson <alex.williamson@redhat.com>,
 Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
 Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
 kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
 tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
References: <6-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
 <d0a5052e-fbbc-4bb7-b1cd-f3f72c7085d3@redhat.com>
 <20250909133128.GK789684@nvidia.com>
From: Donald Dutile <ddutile@redhat.com>
In-Reply-To: <20250909133128.GK789684@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wiPj0XQpKMg4an2X8EATqWVJK3ZCE0ezyTNjYaD0Gc0_1757447746
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/9/25 9:31 AM, Jason Gunthorpe wrote:
> On Tue, Sep 09, 2025 at 12:57:59AM -0400, Donald Dutile wrote:
> 
>> ... and why was the above code done in patch 3 and then undone here to
>> use the reachable() support in patch 5 below, when patch 5 could be moved before
>> patch 3, and we just get to this final implementation, dropping (some of) patch 3?
> 
> If you use that order then the switch stuff has to be done and redone :(
> 
> I put it in this order because the switch change seems lower risk to
> me. Fewer people have switches in their system. While the MFD change
> on top is higher risk, even my simple consumer test systems hit
> troubles with it.
> 
In 'my world' I see -lots- of switches in servers.
I don't disagree on the MFD being a higher risk, and more common across all systems.

> Jason
> 

poe-tay-toe, poh-tah-toh... It gets to the end point needed.
Thanks for reasoning...

Reviewed-by: Donald Dutile <ddutile@redhat.com>

