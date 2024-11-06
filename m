Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0705205129
	for <patches@lists.linux.dev>; Wed,  6 Nov 2024 16:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730909725; cv=none; b=TKZkuJiZJVTzyuRAcZNiZcoppu8fcpQZlWYgjVvaURReBXVFoiRU7MyEeBhjRmIkDTbL3O5P7ClWZWE0z1tnAylo0WHdeyfW5TOlchhJzAZYsl0XtJaCBDWa7q23kTzy3twZBJ6DK38YfcS78aCIBoZfJmsAd4Kiw0inR/JoxyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730909725; c=relaxed/simple;
	bh=4IEA5CT2OJ1TXjN8LNwKEd35uSTQ404HcVnPzFp9gEE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g0/qJA6+pNFDOwXd39wmzIaF3kqoS/DrIw6V+ln7Jna/936ZnuvOPkaQuknxTYU7tibQYMmbUjbPuEp3UxJ8uz61ryUZXfXVvPD+ixJXE0ONWWtKURBgGyPS6pfA30MAvsAlNQhoiWkAJN39yjpAleZ1qX7V8/qRELf2vB+9yg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=WOJ/Ruxu; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="WOJ/Ruxu"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-6cbd12b38b4so40521226d6.2
        for <patches@lists.linux.dev>; Wed, 06 Nov 2024 08:15:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1730909722; x=1731514522; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6nSgGdK6NvqqFV9LyhiXVQ/e823UrG8JIi5eQbgWpwM=;
        b=WOJ/Ruxu7/79JBCLlkvxoLGm6fc35l1yTGONpPtuolqV54ZeLFyUSIEVu1LUDjuSzn
         cohxQXH/pe4hGW2BBvotTWfqVUVQZ5qdy4bZ/NP80E95bI+SSUfY35OAmisa1Ls8FPxT
         kHV2wmn8kvmH0H8I+xYpbZil3SILGq2whqtjAu0YvDT7oDrWS5imjlJ7NieqNvo736Wm
         GB2AId2ZfHEahHFghTu7atnAGVE2voWMMmbC13Sptn1XG6SJ2J8ueWz6zKZQvkj9bO56
         5oiVytt6lYfH/zp7CJ2CGz90wXbTZ9yawHuhd4xDHdgh6PT54T34+ueNmjte7myBh5DJ
         a03Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730909722; x=1731514522;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6nSgGdK6NvqqFV9LyhiXVQ/e823UrG8JIi5eQbgWpwM=;
        b=Xk8mYJ0abeYBkdgW4dkA9LKIl7JkvwZRLOxCa96jAJfKzIFK8/m9ImD9IH+Q47jCOq
         EN0pKTBjlsTqe1csVd23VzudHRf7qa5XLlhrOXHSpc8/PncsNz0YPz5zd+4PI9DPA8Hm
         QIhlu8Azv4suU65V5ZSVB0sM5jsbuK5w0VavaJK6nG4mqiwRKMpe9hON1YSOtaQkbBzX
         z8RhqtUizE79xJZUjXtqoWEYpYbUqAVJC4t2ZXfykQsC6A4cJsKbbxZ7B3YYyTH6h4R/
         GlwjwpOxQvcNx2BE4t74fqMY6VJ+iX3IWE6ZtiMA2bdHu0+t8alh1T3ENUvt2bTYuDb7
         1mUg==
X-Forwarded-Encrypted: i=1; AJvYcCWRvf/R7xM1UZrUHwuMSkpPB6L+l7p6EaJGtotW4LyzUoznSiSD/g/BSRgp1ff4CFzUaRK4RITD@lists.linux.dev
X-Gm-Message-State: AOJu0Yy2aWJUJpWF7Z43sCyKhDgh0m5KBEPzLP50nk/DC8zX/OMstzi6
	ebw+R3wAF92DFKYmxzYWyE5S0wRhzXjQZWMZmqXHF2bW4HMfL+sVRNuVbkNUyUg=
X-Google-Smtp-Source: AGHT+IEwombH/Npcr6xgQKI4hUOBNWDndBBc7puCreP3V/CqgxTRomKyutXho3m/FUi9CO1Dgd2M5Q==
X-Received: by 2002:a05:6214:2c13:b0:6cb:f654:55ac with SMTP id 6a1803df08f44-6d185683569mr561328396d6.11.1730909722261;
        Wed, 06 Nov 2024 08:15:22 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7b2f39ebaadsm644777685a.2.2024.11.06.08.15.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2024 08:15:21 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1t8igi-00000002BDj-3v7y;
	Wed, 06 Nov 2024 12:15:20 -0400
Date: Wed, 6 Nov 2024 12:15:20 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Will Deacon <will@kernel.org>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, catalin.marinas@arm.com,
	kernel-team@android.com,
	Boris Brezillon <boris.brezillon@collabora.com>,
	dri-devel@lists.freedesktop.org, Liviu Dudau <liviu.dudau@arm.com>,
	patches@lists.linux.dev, Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v3 0/3] Remove split on unmap behavior
Message-ID: <20241106161520.GJ35848@ziepe.ca>
References: <0-v3-b3a5b5937f56+7bb-arm_no_split_jgg@nvidia.com>
 <173090505900.4167208.10850898110820689849.b4-ty@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173090505900.4167208.10850898110820689849.b4-ty@kernel.org>

On Wed, Nov 06, 2024 at 03:53:23PM +0000, Will Deacon wrote:
> On Tue, 05 Nov 2024 14:14:23 -0400, Jason Gunthorpe wrote:
> > This is the result of the discussion on removing split. We agreed that
> > split is not required, and no application should ask for anything that
> > would not unmap a full large IOPTE.
> > 
> > Instead of split the two ARM drivers will now WARN_ON and return 0. This
> > is in contrast to what several other drivers do of removing the whole
> > IOPTE and returning 0.
> > 
> > [...]
> 
> Applied to iommu (arm/smmu), thanks!
> 
> [1/3] iommu/io-pgtable-arm: Remove split on unmap behavior
>       https://git.kernel.org/iommu/c/33729a5fc0ca
> [2/3] iommu/io-pgtable-arm-v7s: Remove split on unmap behavior
>       https://git.kernel.org/iommu/c/fd50651636fb
> [3/3] iommu: Add a kdoc to iommu_unmap()
>       https://git.kernel.org/iommu/c/6ac7dffe7cca

Thanks, can you add this hunk to fix the W=1 warning?

--- a/drivers/iommu/io-pgtable-arm-v7s.c
+++ b/drivers/iommu/io-pgtable-arm-v7s.c
@@ -820,7 +820,7 @@ static int __init arm_v7s_do_selftests(void)
                .pgsize_bitmap = SZ_4K | SZ_64K | SZ_1M | SZ_16M,
        };
        unsigned int iova, size;
-       unsigned int i, loopnr = 0;
+       unsigned int i;
        size_t mapped;
 
        selftest_running = true;
@@ -868,7 +868,6 @@ static int __init arm_v7s_do_selftests(void)
                        return __FAIL(ops);
 
                iova += SZ_16M;
-               loopnr++;
        }
 
        /* Full unmap */


Jason
