Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D269325C83D
	for <patches@lists.linux.dev>; Tue, 20 May 2025 15:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747755592; cv=none; b=E3mCTYqLyleTl9fshoKSy+I7MXpfG2jimnQP2wI2evl4nOw7MgRhQVclJETArNPwoenvFERERqp6SECr0LCFEx9t4LPlhlv2VzdDJPy2OHLv7wUoiFf4vJe8an+vLz2cm6pYcDo2ZMW+ckfs3FKDWnr4BQtlA81VQclfPAgOlcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747755592; c=relaxed/simple;
	bh=5qaDz5va7V/bOIPJZLz/3rD4zx13j2tjLgu6z+mJZvk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=psqEfDlMaXM/x6BlSvr44SHlpvXc4bqc239evSakUTONgkOgugkcXPg1rl09hI8DnF78QdjNtNqp+kxjuzqPcBP1b0SJqn6vup/o8LvS4tLAYnOvMZdyht9qGCh/DXF61gzIFK3wd8vfuvYZfcDWkKpvuh7lnKH6JK6PCuGGh0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g5QqVXuB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g5QqVXuB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747755589;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GJ0rFA5ozhMdO1IEpBbuVAQP+phCnmZbFuLhRhdhX4A=;
	b=g5QqVXuBWBtlgeWAmKN8VFW70sVZdwrChT7ExQMbbiIFhebWZoD9WJOYyX3sMDnWDy8YLV
	WmHyP+xChnK7fd1w3RSmNB97wmxNFW1Z/+qv9Y6HduL5aocKQFTuTR2diPOJ9DF/HxP8pY
	JEWeYtvlcsVY59At4diagQ0zXH8i2YA=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-192-eswdMxMbMR2sZgVUPTlkDA-1; Tue, 20 May 2025 11:39:47 -0400
X-MC-Unique: eswdMxMbMR2sZgVUPTlkDA-1
X-Mimecast-MFC-AGG-ID: eswdMxMbMR2sZgVUPTlkDA_1747755587
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-85df453e4c5so93002839f.1
        for <patches@lists.linux.dev>; Tue, 20 May 2025 08:39:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747755586; x=1748360386;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GJ0rFA5ozhMdO1IEpBbuVAQP+phCnmZbFuLhRhdhX4A=;
        b=TVQv1zBPfEPyJHLWkGtdrziydJHACkdD+zE1q6KuS+/yY40qViAq9GuTJrtHmZbY77
         V9yr/oU1DE91z4z+fBvhXWTpSJM9yVoxtTxlyW0iGej+lUf5kXEyHaiM4bsZjpdTbSU4
         knPH4S2xLQiGz+D9WspDiFzVr9RDE8UtHnPjXU0no8In19H9hJeTPpRgfS6FoNmYwAV/
         en772E/cYy6tTDovO6NBpMTHPu/D0IiVAlKbOO92xk+s3bGeUmFiw2pbXp1ZDplEmnpC
         U5ru8jdqfLEE5wgE+64xBsuU5HjaYh08YBvMLfwmgcEiANuc+ZgVLiMH4mojlQeLQlc9
         caKA==
X-Forwarded-Encrypted: i=1; AJvYcCXotYJfsmEDRAJfZ4kAiGeLjPKzmDwK9fc+VASoU8gsjXyAml78KT/wldSd/szmOjn6Rw8fJLFi@lists.linux.dev
X-Gm-Message-State: AOJu0Yw6lG+GYvFKo7qWjainBe3NNl5gOOdoilcZlZDNgGalNL0f5DQa
	xqofjOEfQoRkLL/3Lo6XgHZjiVXmbGvWXCwlSMx2U2lKzqb7wfq/Qd95aV4O26tGjSWYLqGgPPY
	K0wwrN/YVBba9dsizKSV5nOFkhWhOrjPxuxuJHoSi2HIJQYMiZM9vuInDRCk=
X-Gm-Gg: ASbGncsTkTWCt3MrS1EnHNHy0KDcV4coVkVr8nEeuTxNHMMQWBY217GjHX8C4XVvOV3
	iUZsXWc0LMz5u6Do5U6AaBqgINOeqZ5BHe/p2RvY/ZPus9CMouvaX02P6TZjSCUBIhC73SIOs+J
	IovvbHpUi1+W4VlW89rJ04ojI9fyx6lnjksKqYMfjXwQ/dS+F8s3LVzTFjLjByTcxox+sjATop+
	eYm943qesZj9HODoKuMnBbwsrifjWpoOk3LUBeQdIa1MUIvzMpyM5hkc/8TqxWedEAVHPYLBNHT
	a7dEqMc/fdBu6+w=
X-Received: by 2002:a05:6e02:4515:20b0:3dc:757b:3fa4 with SMTP id e9e14a558f8ab-3dc757b42a2mr12610625ab.7.1747755586650;
        Tue, 20 May 2025 08:39:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG3VbHHu3m+p8uONX+1ieaFf8GcikTyFLsLmu7hXitJ8VoWNtERX8CvL4Yw5GgMZaX+kUid8A==
X-Received: by 2002:a05:6e02:4515:20b0:3dc:757b:3fa4 with SMTP id e9e14a558f8ab-3dc757b42a2mr12610565ab.7.1747755586291;
        Tue, 20 May 2025 08:39:46 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc3b1a96sm2298549173.51.2025.05.20.08.39.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 May 2025 08:39:45 -0700 (PDT)
Date: Tue, 20 May 2025 09:39:43 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, kvm@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v2] vfio/type1: Remove Fine Grained Superpages detection
Message-ID: <20250520093943.05bbe2eb.alex.williamson@redhat.com>
In-Reply-To: <0-v2-97fa1da8d983+412-vfio_fgsp_jgg@nvidia.com>
References: <0-v2-97fa1da8d983+412-vfio_fgsp_jgg@nvidia.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: EWYRXJ0N0v2HT6EG1OSEaPPe93rdzoDx9NNR2JzW4ok_1747755587
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 14 Apr 2025 10:46:39 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> VFIO is looking to enable an optimization where it can rely on a fast
> unmap operation that returned the size of a larger IOPTE.
> 
> Due to how the test was constructed this would only ever succeed on the
> AMDv1 page table that supported an 8k contiguous size. Nothing else
> supports this.
> 
> Alex says the performance win was fairly minor, so lets remove this
> code. Always use iommu_iova_to_phys() to extent contiguous pages.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 49 +--------------------------------
>  1 file changed, 1 insertion(+), 48 deletions(-)

Applied to vfio next branch for v6.16.  Thanks,

Alex

