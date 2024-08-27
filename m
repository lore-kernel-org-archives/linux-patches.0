Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CBFA1BC9EE
	for <patches@lists.linux.dev>; Tue, 27 Aug 2024 12:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724762856; cv=none; b=rCk9InJmrmFGaYjD2V3CgCzbSh3QzKZ0FKZDl3KEPOCBTb43Yayqo452DBaMFpRBxbZb1LtkSEzgLOxnIrm9AgxykUymFU0au6cHAzNCxuV5HUJ2gQXTYz1NS167KgQbt+xfNlCvx1N7I6FVzPIyNMAKvYNDxpq9rWej4rcTq4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724762856; c=relaxed/simple;
	bh=3HCTVcNovF0MeeI0ysdeWokm3L1qbp7raTPLakXqCQQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kffA8lap/esSAOp1pscbchgK69TxC7KawCNKT8UAoPS7RTVpYoVaI61RQ3a9vhxXL1bqt1ED0fm7B8GvGzKqiE1n9J5hIRFyFK6p3WOTDuHLYT2cazq/6HdLvWJJuKcKffAG5QOgvNf3AwHLHDp6G/lRHndBi5JGHN0u4l3/c6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=SAVHX4QZ; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="SAVHX4QZ"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-6bf705959f1so46104336d6.1
        for <patches@lists.linux.dev>; Tue, 27 Aug 2024 05:47:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1724762853; x=1725367653; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tJf38CaphXNMGt5jFxO/UJoK/6Ew+48M1qmB9QmL+XM=;
        b=SAVHX4QZ94t8N9PoVlmo3iKgMNxIB3q2y7WkmcEtg0qOG8Mh2XTwfsgWmFPoPuC7Cl
         is27nfQpNCe6P43W0B/foo8z4xL+KNjQYGiFrTtBGynUTkYcW9Avv5xfQyiY9FRnZr5A
         SCteL1tU+Jftw97n3PnEW4kMYwNAiRMHvLesKqQxZ/9/nC0ljXo1oAi2klPAqo9LQZFW
         iyoJ32OqYKyiaoeSEHwNHK1Rb6jZN1WKQBWRHIAB7NuFowfbLVBujiL4EYKKmq72thJe
         eNRw+RFXH5JPI+kYmnHrlpJPlkraLc2jcZSABJJnfYc/OEWb0es6K1GeG3jNFofjbF3e
         zSZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724762853; x=1725367653;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tJf38CaphXNMGt5jFxO/UJoK/6Ew+48M1qmB9QmL+XM=;
        b=DfO2e87Kk1YbDK0qrCk9LaLuHaNY/PeGZCchwVGxCpDD9FxzUiJbut0pufdyLehzgK
         pnN4CKfiowbRLbj8Mg7zK5MDYebmnnwb1Hm/n7JLZAjWDMvwJ9m3qjyhREcyTeH3E3g3
         0GCpBHK0tjIrKDVEdMaW71CqmF8Zzlj7ZX3E+YAshzYZyDQpjjSs/hIDfXwNeDaTI2vb
         Ua3firzE1pce1I1Y7OpzmP6+O/HXxops+qdAXHLR+NaRdDz/kD5DgyNnzqtivx9TDw1D
         x/sZxHh+ZBWFftXqVsS2MayM1z4pFrXth2znhXq+Rj9BZ/zPfGfjvnN82R0AcqzcZwzj
         clhQ==
X-Forwarded-Encrypted: i=1; AJvYcCUyamnCPBzoFhO2dK3NAOIo/NuylBdFIOi1i1NC3bdUMvVq8ejlxV4uiDkvcjIMijVWB4GTsF3n@lists.linux.dev
X-Gm-Message-State: AOJu0YzPcU6q+pxA7NBKGiZWNVzKTlRhZMjcFkxQHm9R06CAb5CZdPYK
	zgrXyd+2iWY6DBYoZ5e1coQClngTzeqlXy9Hi3QT0lGUuZ/CLDVKRIM5I28TRZY32xi8glFpZgN
	F
X-Google-Smtp-Source: AGHT+IFggHZP5nVRykjVU0WzDPU4GkV1B65t9v++rWmP7nXz0t41CO3P/jYgttttTxSFOZ0y0c4YFw==
X-Received: by 2002:ad4:430e:0:b0:6c3:2eb0:23b7 with SMTP id 6a1803df08f44-6c32eb025f6mr21223316d6.1.1724762853127;
        Tue, 27 Aug 2024 05:47:33 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6c162de8c17sm55443476d6.140.2024.08.27.05.47.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2024 05:47:32 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1sivbg-000hv4-9U;
	Tue, 27 Aug 2024 09:47:32 -0300
Date: Tue, 27 Aug 2024 09:47:32 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>
Cc: Joao Martins <joao.m.martins@oracle.com>,
	Kevin Tian <kevin.tian@intel.com>, Matt Ochs <mochs@nvidia.com>,
	patches@lists.linux.dev
Subject: Re: [PATCH] iommufd/selftest: Fix buffer read overrrun in the dirty
 test
Message-ID: <20240827124732.GO3468552@ziepe.ca>
References: <0-v1-113e8d9e7861+5ae-iommufd_kasan_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-113e8d9e7861+5ae-iommufd_kasan_jgg@nvidia.com>

On Thu, Aug 22, 2024 at 11:47:09AM -0300, Jason Gunthorpe wrote:
> test_bit() is used to read the memory storing the bitmap, however
> test_bit() always uses a unsigned long 8 byte access.
> 
> If the bitmap is not an aligned size of 64 bits this will now trigger a
> KASAN warning reading past the end of the buffer.
> 
> Properly round the buffer allocation to an unsigned long size. Continue to
> copy_from_user() using a byte granularity.
> 
> Fixes: 9560393b830b ("iommufd/selftest: Fix iommufd_test_dirty() to handle <u8 bitmaps")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/iommufd/selftest.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)

Applied to for-next

Jason
