Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E15267B6B
	for <patches@lists.linux.dev>; Tue, 29 Apr 2025 20:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745960161; cv=none; b=ZLG1dvOtl6fgqKZ8yKSF/QImmbSyCcbbCB+YKIx5T83p7E37TjfYEjIYsf9tv/wpEGD8kckVhKE1v7H8M1uCt91+Iy2SNTNQWJdPwW7Nit0n28Kq39GFOcsj7e8QzC/raSbuM98MPvgxY9JonfBWb6+03PH7PVXjTA3sdsnoYmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745960161; c=relaxed/simple;
	bh=7mNKgw7B4gWkWk/1cFhoOBWm42l3r4EBHfns+bKE79Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fhJbvx6YcvEkHLbpoXsyAKFxbrGbD1haxodnf3pY7PR2ffbyBJbGCTpQ8qMtHG/j8W0Xsg/9T8eGcoq5MZc5ouI1g8mNIGaO/SHQD9iAyF1fy2FDB/nfXbLEriNPSqfW0YveO5vr+LqlA0nWOxTmLu0bIjfBGAd5z8ACOBZYAuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xdYgfgAg; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xdYgfgAg"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2263428c8baso75275ad.1
        for <patches@lists.linux.dev>; Tue, 29 Apr 2025 13:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745960159; x=1746564959; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QtvWyMaXoETtgU57TiX3zqHKqBuRh1/oEuSWwfTYD+M=;
        b=xdYgfgAgoXsPeb8b181rgORm6a9hqgqi1jmonEonuC0BEoNmd2SIBb1aQDK6S3J6GH
         aQ4wWP93dDI5cJDp17m4eY5ss8e4S0hft8K5xuq73IJCACLIdeSts3eaDE5bWSlkBsQ6
         mAp7qiK+VYSWcbYDD2uChrTjfw99oq3sUfiSEjiW+SmvLKqXV5aKg0BOmDQgsqANTR7T
         WC/qNLt9X9TTKna5YGkXI2d2WCCqS1r2vo7I9NwKsliwjAzXjbR8cXcGbQiIC4xz/UA3
         UaPSEbCS5Z9Cso9TNi36o0+9SjqqEkm7ohOscdTf6APRX4rfowns08s1suj4ZugWrEdk
         +dDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745960159; x=1746564959;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QtvWyMaXoETtgU57TiX3zqHKqBuRh1/oEuSWwfTYD+M=;
        b=iuU2MNW9K+L1pEIKO0fnJmbNSw7DtCi82yn+c5OlzGzF8O+AzyUmnQEy7ykdf2uHM6
         o6UFeMrATGWHcUyOKJlKJcutTO5ZIhNcAkBxc4jnW4aWTp5OHXA2Xqebl1iqljXcT1VI
         AChDO+4Y2v1QMzCc2OJ1KRYXY3NPRu5T/1P1mMESK70BTStwQTPP362x/P1mpd90Oa+H
         rNAbMg9bid5pZrxHqeEP7qluLM/u9YzRfG43UpCiuWSVxpGP2lmR2ZJJXtL1xw2M5sUR
         YmusZ732vWXLlaR6AxCoU9bJmdIMphN41MsC2CoMYd1jy41Q3fU7YahwtMSsEZeRz22L
         4Faw==
X-Forwarded-Encrypted: i=1; AJvYcCWiK2uywiYOi2RywlI39aCV/wy1dvg06FVLQK5Ogaa5PNN+4d8yIWa/StZQDmpVolxY6GPT3RBR@lists.linux.dev
X-Gm-Message-State: AOJu0Yx9XTN45sO+pNMOkzrVD0iEzeONtLH8Rnqb/YeNv0bHUKZyEf1v
	Ghy5t13pWXQJyiQVgr+YSN1+a+chIsxugaNqOAlBF/s6ICuNMZoWKokEXh7OeA==
X-Gm-Gg: ASbGncum0qMidGICUR8+9imhou0u0Gq7eKzCriHOEpwvka1kB7BWV3fYBqnrZddmBN9
	EIB7zIapjMXG5K3iwEU5XH76V8cIwTE/HneY9033fpxM95tZalJNm0FO2E+dRvt2Natc+R67+Lm
	QSFJnDOD7tK9gD+VB538NvfXCJfVVTtoIgXpODRA9J1FgqNg9dJ+Q/efj/txPXP9HmuK4bL3Cbo
	p4YjyHtjLaHTSSi7YPos8V7PIhgIB8FfmHd1Oj8z/1xH8A4cmjeBUrcvAF1t1KA1W/NuYGLxu4P
	08u4R0tAYv7F47pKI0Hr4ku7E6iZiu0CKgtUxTWNLffpa8ZfL7FB1mII793nGfohpo/IfHeh
X-Google-Smtp-Source: AGHT+IEDLG3SJps6W1WWtS+Z1B6wTQS34GYl+OTkQIvhX6qglLU7EkbEpqx51RkV1YpDBN8wRt1Y4A==
X-Received: by 2002:a17:902:ecc5:b0:21d:dba1:dd72 with SMTP id d9443c01a7336-22df545d1d5mr63705ad.15.1745960158589;
        Tue, 29 Apr 2025 13:55:58 -0700 (PDT)
Received: from google.com (2.210.143.34.bc.googleusercontent.com. [34.143.210.2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db52168b9sm107756155ad.226.2025.04.29.13.55.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Apr 2025 13:55:58 -0700 (PDT)
Date: Tue, 29 Apr 2025 20:55:47 +0000
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
	mochs@nvidia.com, alok.a.tiwari@oracle.com, vasant.hegde@amd.com
Subject: Re: [PATCH v2 13/22] iommufd: Add mmap interface
Message-ID: <aBE800DsAOOZ4ybv@google.com>
References: <cover.1745646960.git.nicolinc@nvidia.com>
 <7be26560c604b0cbc2fd218997b97a47e4ed11ff.1745646960.git.nicolinc@nvidia.com>
 <aBE1gUz9y415EuBQ@google.com>
 <aBE38GwvGBnpRNLc@google.com>
 <aBE47aySzDp2lsAz@Asurada-Nvidia>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBE47aySzDp2lsAz@Asurada-Nvidia>

On Tue, Apr 29, 2025 at 01:39:09PM -0700, Nicolin Chen wrote:
> On Tue, Apr 29, 2025 at 08:34:56PM +0000, Pranjal Shrivastava wrote:
> > On Tue, Apr 29, 2025 at 08:24:33PM +0000, Pranjal Shrivastava wrote:
> > > On Fri, Apr 25, 2025 at 10:58:08PM -0700, Nicolin Chen wrote:
> > > > +	struct iommufd_mmap *immap;
> > > > +	int rc;
> > > > +
> > > > +	if (WARN_ON_ONCE(!immap_id))
> > > > +		return -EINVAL;
> > > > +	if (base & ~PAGE_MASK)
> > > > +		return -EINVAL;
> > > > +	if (!size || size & ~PAGE_MASK)
> > > > +		return -EINVAL;
> > > > +
> > > > +	immap = kzalloc(sizeof(*immap), GFP_KERNEL);
> > > > +	if (!immap)
> > > > +		return -ENOMEM;
> > > > +	immap->pfn_start = base >> PAGE_SHIFT;
> > > > +	immap->pfn_end = immap->pfn_start + (size >> PAGE_SHIFT) - 1;
> > > > +
> > > > +	rc = mtree_alloc_range(&ictx->mt_mmap, immap_id, immap, sizeof(immap),
> > > 
> > > I believe this should be sizeof(*immap) ?
> > 
> > Ugh, Sorry, shouldn't this be size >> PAGE_SHIFT (num_indices to alloc) ?
> 
> mtree_load() returns a "struct iommufd_map *" pointer.

I'm not talking about mtree_load. I meant mtree_alloc_range takes in a
"size" parameter, which is being passed as sizeof(imap) in this patch.
IIUC, the mtree_alloc_range, via mas_empty_area, gets a range that is
sufficient for the given "size". 

Now in this case, "size" would be the no. of pfns which are mmap-able.
By passing sizeof(immap), we're simply reserving sizeof(ptr) i.e. 8 pfns
for a 64-bit machine. Whereas we really, just want to reserve a range
for size >> PAGE_SHIFT pfns.

> 
> Nicolin

Thanks,
Praan
