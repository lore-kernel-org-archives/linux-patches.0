Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EACD239E9E
	for <patches@lists.linux.dev>; Mon,  3 Nov 2025 07:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762155030; cv=none; b=AvIypgVYKV60iOptZWGY2RhQ9AeeVH3ynyyNxma9Kdbvna2LRPf/P2PNW8jYhZH3o1IKWobjRi7TlbW2mEsPn01MYY9m86BKsCiIxfxu6fsvHbBGADXOFpFq98qmEkghLCwN1YDy4Yu2i6m/NmAg8PWh20JgmZtzt1aiJ4eoT38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762155030; c=relaxed/simple;
	bh=tcJ9j0rjVgX0LlfeiyBdhL1zp92EWqORHcfEAw97Bb8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nmreq00h6uka+oMchz3vMVR2CEM8kLBw/RKhm2v39mzCAEaU8X91L2sPRHRjGtmHXPnxCj0UhDTrYtp7OGPxBKCvj69h9FPZ/3k1e9PIV7GVMkJTGnWJyT9F3p1bR+v47Ij0UuLWWDJpTlik8OeTSxceYFAzdbTYwcYjQogv/38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DzFqCDEZ; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DzFqCDEZ"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-27d67abd215so384585ad.0
        for <patches@lists.linux.dev>; Sun, 02 Nov 2025 23:30:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762155027; x=1762759827; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=W00R51s/bFZ7FSKiqSW+6LDxOwjjTftHVYebWZvSUlk=;
        b=DzFqCDEZGdgsDqw1H6lchbzdtWPFwKlva+sispumZ60smqE6X81ShSSveg4pirZKPD
         4SgnHFIbN1HUKy8jsl5ArHqWXWtV9wN161V1K9cdgxWq9KYkj4QqrOTgvYbbU+MPJSxS
         UNzzhd/U4kQ6MC7YVCy+BlO8bRF1lwrY+r5VUGgRv1xQMHoG3hSoO2LVdIo2Lb8OWq8I
         cCX6MpT5qgRllFPMzo7ssS7WG4X+f+fZVIOLSj+Z/MS8Ugq76/o3neT7YBaA4b4mzYAt
         fwOnc9KKgkoFF0USmxPHqR1mJHeoIsZrv/S6YGT3+fjB1jajYRIhRoj4qoPYip/+Ihwc
         wZyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762155027; x=1762759827;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W00R51s/bFZ7FSKiqSW+6LDxOwjjTftHVYebWZvSUlk=;
        b=NC29ozq+t3RI5WKwHAsV/eWNcQyE+Nwetbd5YYLXEA/CQD3Exc9BEtVQ6JXajAuapE
         qkH2d8aDXqZigVjJXYBtBqDRul+khENhdXmhyQhOiPu7NHcOvnPSeBQ1ruDork4YzbMx
         tPMFoc9gv0DU8bUPpGamDd4VEr3HkBsES8xC9t04l0k+fDfpZSXPFC/kZeKTqQxtgBct
         lCbIsyqDAIor6krAaKfZYIa10KT0XwlW00cUne7zTNxK0kMveGWnzNhnTl+eiua4R1WG
         0jlk4MUet0bo9KjP5EMKsxfUbj+qpvA3IvLFOKKG28JA+R24MD2mby5CKY/GFT/0fDH7
         EYbA==
X-Forwarded-Encrypted: i=1; AJvYcCUVqGFPwjGAnj0hY9hG6n4jwtwswO8UA9RwFvqaEzOT28fjSm5XqXuzyTWpCoQbUFElgaiNRv3P@lists.linux.dev
X-Gm-Message-State: AOJu0YzOW8PxqKzedIyXxPxviF/cv01tL4qWvCgtNsxwo9y2EJZbcr82
	5pQZnNTJi5Q/d2AVMXZe4LZ56sy6OqCO1Uvg96lKvfwz2PWeNnyTUQR/6c9Z18qNUg==
X-Gm-Gg: ASbGncsIJKt2quoWTPCT8AZoro5g1KE/7xKRpodw+wfQgNOaVH6fAVE39IK1RP2smaj
	xwix0A4nfkiTe0hG11wK4+hOE2lfeJM/Inw2cKsiLUd5MM/lbVNNJ1q0OPsVsGW4Aehqkoon7Rt
	mfMGn8keRy42SGWZxk9DHWDjNaydffAIL6VXeB/GeDBeemHaYqYF3XD0Ybdczbo2osFjhVGvKLT
	EOwVgiTD+0vpIXNh9IGPD/rdn6SNCK2fsNTNUZjKaWyNzrCTPV55IknuT3Z0YDZoMMIJgYTTKaE
	niG23glYA+TbrM9JTwGHx2SEWy57DHMpTGpeZ8RfVIovj15nyDxUK+vFuiAeTv4L8F1flgWyhaw
	XnTX2Mgw5r92e/1aoV3w/0JimBjhkIhuJniO5Y4OiyAuqADoD+0CjavcAhtDRqjKK8f7JxntVjo
	fSz0r21fP6faz9SUcPRfgZFPudWQaoXImlovRhWQ==
X-Google-Smtp-Source: AGHT+IFjaXH+x0wDYP1YTleZ6beMQ7i4yOeGqaMcf/YJxMNIbFnQkDy7S1c8+nxpPDJ2MzqKvGx2GQ==
X-Received: by 2002:a17:903:1a70:b0:295:28a4:f0b3 with SMTP id d9443c01a7336-295549cab2dmr7007095ad.0.1762155027242;
        Sun, 02 Nov 2025 23:30:27 -0800 (PST)
Received: from google.com (164.210.142.34.bc.googleusercontent.com. [34.142.210.164])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-340acfa77b8sm8320159a91.18.2025.11.02.23.30.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Nov 2025 23:30:26 -0800 (PST)
Date: Mon, 3 Nov 2025 07:30:16 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>,
	David Airlie <airlied@gmail.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Brett Creeley <brett.creeley@amd.com>,
	dri-devel@lists.freedesktop.org, Eric Auger <eric.auger@redhat.com>,
	Eric Farman <farman@linux.ibm.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>, intel-gfx@lists.freedesktop.org,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
	Kirti Wankhede <kwankhede@nvidia.com>, linux-s390@vger.kernel.org,
	Longfang Liu <liulongfang@huawei.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Nikhil Agarwal <nikhil.agarwal@amd.com>,
	Nipun Gupta <nipun.gupta@amd.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>, qat-linux@intel.com,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Simona Vetter <simona@ffwll.ch>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Mostafa Saleh <smostafa@google.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	virtualization@lists.linux.dev,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Zhenyu Wang <zhenyuw.linux@gmail.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>, patches@lists.linux.dev
Subject: Re: [PATCH 10/22] vfio/fsl: Provide a get_region_info op
Message-ID: <aQhaCAAliYQVNjgK@google.com>
References: <0-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
 <10-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>

On Thu, Oct 23, 2025 at 08:09:24PM -0300, Jason Gunthorpe wrote:
> Move it out of vfio_fsl_mc_ioctl() and re-indent it.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c | 55 +++++++++++++++++--------------
>  1 file changed, 31 insertions(+), 24 deletions(-)
> 

Acked-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan
