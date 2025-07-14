Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DEBE25A65A
	for <patches@lists.linux.dev>; Mon, 14 Jul 2025 15:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752505981; cv=none; b=t3aTqlVS0lPTX5YplQuGsgR5tSwMLlcMKjkxmZLWzIRACpz6C1vsElWUqFhKCuA1r0nwVbdbYNuMJbpp8ck3f3on+KD17n0lBMQ4iMSTyE7GH12yU9cm0yOo5VU1myZrX31fwpaD6brU00r92VF/gmXa2SxbfVXyWJ/HxN0dDHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752505981; c=relaxed/simple;
	bh=wq3jkDXmL2kbDR8yLPZKxT4RkHzlMSQh4F6k/stG0gE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DSJ5YNfjes6JXm9KOlahRINetloqcLoUhVM0PKxA8zafSh9tj8QOhKhk5yIgVwYM6Rt6vm3UhEqMlZgPZhZ1Qcxn0O6R5c5TS/+WrtUDwzJ6Tzqte2aZPcEI92lk4wWklt0Vf3IUH4UarcmgAipJtJ5ABfMbXMYp4lhuHx+sga4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jKr0gCAc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jKr0gCAc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752505978;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UAuWLDvGONYS4aGI3o9+xx7hOflsVGv3mSCNJ1rkux4=;
	b=jKr0gCAchVHMtUoYhZ5rlFxSz+wGhZ/YKpbhjjGrH/98yLYF97HrVcbjV0gKbYfZut6SMm
	BjKpGgldyERoLP7z2WPTxlC0XWxUfdaEFyXxYNLgNk1gqvY+RmWEalGflEb1Z0r9tTG5+A
	U2Ugto7lvIMcMR07OwhAMfrlCCej0V8=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-613-e8WKboIuOhWXT1F14MdOBA-1; Mon, 14 Jul 2025 11:12:57 -0400
X-MC-Unique: e8WKboIuOhWXT1F14MdOBA-1
X-Mimecast-MFC-AGG-ID: e8WKboIuOhWXT1F14MdOBA_1752505976
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3ddd689c2b8so5104745ab.1
        for <patches@lists.linux.dev>; Mon, 14 Jul 2025 08:12:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752505976; x=1753110776;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UAuWLDvGONYS4aGI3o9+xx7hOflsVGv3mSCNJ1rkux4=;
        b=dQVDdIDiyAkHeD7fjex7vYE5Bh5aHZaeJxI8H4huJNzmPzuu5/ERLPvhelBlTUgrnE
         tYGnwZkpA66Ps8Zrwra02BjemybJDJHKoDOr6fl9Q8m8wCotcis4CA8fOoJ6tPDXS8pe
         D0ERtCh+SyOryo4W8HnqcxGOnJ+vCX+vKa3FHc5RYqDREqqk15Keby+AvBIK/7uYl/Hv
         8mYOV58LhAT4KC+RTPMk0KBBmGF+MH26abuckdXk4Lq3wiZdCFLitZhHAPzfTxcCIe5G
         crKUmBarbqaE/Ty4Pmkg4MMBsi/CsfjfJszQI5eSYxrYstbFDrhPtiLbHYq8uxDcAyts
         8iKg==
X-Forwarded-Encrypted: i=1; AJvYcCXgmLXnfs7NsIPUHkBLEcqukkFVllvRqE1/v5gAnqYNLEGloeAn7oZEM5VApslhJZyhnFh887e6@lists.linux.dev
X-Gm-Message-State: AOJu0YwuylC2EPKmKWq4ZOB1+hFIYhQkWlOeSEJe2zoIIwI8wfThnplF
	ffPjmgVPZ4BRF1cuV4wJ0J52InUZ1iqQEXSoUVgCRZbR8DxvaQF/307VaJ67yYW+a9bCn94e+6y
	Kk6qmhlvaMwbSaH8HWTOVd0G5BXXGzkQ1xGAlxXSSiTczDpcV8/NDp+dAthY=
X-Gm-Gg: ASbGncvym2ZrMiSz22+PJhFMeuL/Tx9xBbn+XWF4h1DgJVKqZOfFj3woHF5jLbIf+jZ
	kDNAvjKIN5m4X1Ry5UIYUnV379NmwMss9RKfOY9Sj9VW1UZAxkx1Q78ssiMksGODePFyAEYXflx
	m/ArjCQ6l/R6QsYZcC5W3mFwxQYRmlVEnFPlPNE58MxKfVk796Loo49aRTKBEN5Yl97J2vsxdA2
	4UXjJllLlhwh41BqTNmIxEvEWoHMihzza5lHC4dnfgtuqBvKcMPFlA5nF62xwcpQtq8ckXXX2TG
	VKA/l7FhNQIsnT1kA21FGHlTRQHQZsIQ/pEASdIqcNE=
X-Received: by 2002:a05:6e02:3083:b0:3d4:6d6f:6e1f with SMTP id e9e14a558f8ab-3e2543f45a2mr42634865ab.6.1752505976219;
        Mon, 14 Jul 2025 08:12:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHQWWnsQP46KCBBDLLmrvxRjBMZE+wrW8uiPq3ltdhzNoM6uXIgiwf7w6/nI+O/Wf1S85BaBQ==
X-Received: by 2002:a05:6e02:3083:b0:3d4:6d6f:6e1f with SMTP id e9e14a558f8ab-3e2543f45a2mr42634705ab.6.1752505975706;
        Mon, 14 Jul 2025 08:12:55 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50556970df3sm2049358173.90.2025.07.14.08.12.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jul 2025 08:12:54 -0700 (PDT)
Date: Mon, 14 Jul 2025 09:12:52 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Yi Liu <yi.l.liu@intel.com>, Ankit Agrawal <ankita@nvidia.com>, Brett
 Creeley <brett.creeley@amd.com>, Giovanni Cabiddu
 <giovanni.cabiddu@intel.com>, Kevin Tian <kevin.tian@intel.com>,
 kvm@vger.kernel.org, Longfang Liu <liulongfang@huawei.com>,
 qat-linux@intel.com, virtualization@lists.linux.dev, Xin Zeng
 <xin.zeng@intel.com>, Yishai Hadas <yishaih@nvidia.com>, Matthew Rosato
 <mjrosato@linux.ibm.com>, Nicolin Chen <nicolinc@nvidia.com>,
 patches@lists.linux.dev, Shameer Kolothum
 <shameerali.kolothum.thodi@huawei.com>, Terrence Xu
 <terrence.xu@intel.com>, Yanting Jiang <yanting.jiang@intel.com>, Zhenzhong
 Duan <zhenzhong.duan@intel.com>
Subject: Re: [PATCH v2] vfio/pci: Do vf_token checks for
 VFIO_DEVICE_BIND_IOMMUFD
Message-ID: <20250714091252.118a4638.alex.williamson@redhat.com>
In-Reply-To: <20250714142904.GA2059966@nvidia.com>
References: <0-v2-470f044801ef+a887e-vfio_token_jgg@nvidia.com>
	<a8484641-34d9-40bf-af8a-e472afdab0cc@intel.com>
	<20250714142904.GA2059966@nvidia.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3MQU-Ev8qiIsaQoY2gvJ_vomEFOErNQzcUjvzwOAiX8_1752505976
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 14 Jul 2025 11:29:04 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Jul 14, 2025 at 09:12:30PM +0800, Yi Liu wrote:
> > On 2025/7/10 23:30, Jason Gunthorpe wrote:  
> > > This was missed during the initial implementation. The VFIO PCI encodes
> > > the vf_token inside the device name when opening the device from the group
> > > FD, something like:
> > > 
> > >    "0000:04:10.0 vf_token=bd8d9d2b-5a5f-4f5a-a211-f591514ba1f3"
> > > 
> > > This is used to control access to a VF unless there is co-ordination with
> > > the owner of the PF.
> > > 
> > > Since we no longer have a device name, pass the token directly through
> > > VFIO_DEVICE_BIND_IOMMUFD using an optional field indicated by
> > > VFIO_DEVICE_BIND_TOKEN.  
> > 
> > two nits though I think the code is clear enough :)
> > 
> > s/Since we no longer have a device name/Since we no longer have a device
> > name in the device cdev path/
> > 
> > s/VFIO_DEVICE_BIND_TOKEN/VFIO_DEVICE_BIND_FLAG_TOKEN/  
> 
> Alex, can you fix this when applying the v3 version?

Hmm, where's this v3 version?  Did you already send a version with
Shameer's fix (s/bind.argsz/user_size)?  Lore can't find it.  Thanks,

Alex

