Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E78153BED
	for <patches@lists.linux.dev>; Mon,  3 Nov 2025 07:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762154323; cv=none; b=gKwV7RkDxBgaaafisfJfsBdOtxgeF4SoqCarFbYkomx58ymGaISqs5RXIZmetezj3+D556znHNuGFzNHh9ZHc8ky0MmDTnIXJdd+dVFroFCSiHzGinb1S72uQN73iKjp1ceXd/FgWmIP+gzjr3MjTIJauUkOE+XSinyuuxnqGDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762154323; c=relaxed/simple;
	bh=Vm2BtOrr7/4guLkxjFZFHOZoayeqUbBXepUyeDwPM+g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DnopVCX2NwcfBlCWTM1NmfFc+J2SrCr9Yy1smDehwDQhqEKk8UOpOZSjlkEJ9KRGTaJDBz01pPBySpNUS1dNTCEwPFk4bgfrjAoXQSoD8dT6Gosdc03DSb14cH1J6bkI2ZvPTR6E7qJtIAL5whLXbrM2IjSxFp0ZQ9QaY13XlwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oSM+VBUN; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oSM+VBUN"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-295c64cb951so84815ad.0
        for <patches@lists.linux.dev>; Sun, 02 Nov 2025 23:18:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762154321; x=1762759121; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y22k5ngiq32o4MbKE/s0CLErP3q9IoFtmfwfCLBHatI=;
        b=oSM+VBUNSop6YNaxcEI6m+472U8sxfYz8xkpLsWw8hGh/nUpBw7GRs0VUHQi8FtZjA
         xQGFHzyVj0t+Zp1dkp7rSK4NMbvH7fPDiBuqb8XXoZ+BbmRZvmsn02zsSV/TBWQ+Kn1W
         KoOsV5Yopl1PPtx/DcIv2jgvHlUHMtghgRYfjnkegXv+tj0ehrVWVo8wNbXl6Lcp19db
         6TawpRDZ7plNIbQg/wfw7H/dju/U0PAs87644ziuekiQVnVgYAz9X2ddzjdJbaPih0za
         bB6FbWOm4jDSrcUZ+VvEpCMzNIAad0Fr03j4DXsgnLFYTC9tm5k37V8mxWAabLQ3+pEl
         Meww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762154321; x=1762759121;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y22k5ngiq32o4MbKE/s0CLErP3q9IoFtmfwfCLBHatI=;
        b=YV3r3b5L33bnQYduvHDzqBtaGGWN7urD+W3/ePZ9QMblM4UB9jATxr7hrEVFpK7FLi
         /xasg76OVVKVuXLLbKu91uaPxfitv72+BHXVWKNZI/ibAV70GTZdNf4JvVVuKMy3xrn+
         j7Gru7anNvFqio0SxqCISGHFpupBx9QfH07WsF/U/ZUbw5Qyz9Ch8MByiMVvg2HpNnLA
         BPphM9JOfQVjPmetuAWICrH3PHWfL7VeA3Sws51BL5qxnruA2G1RTBSliulbA8IPnuws
         /EaG3r9Q4G10J88RsuBhsJuRDl27S7ddHIN9CzLk5l6XFP46KibOjNDDvabZFehcSfsj
         pjog==
X-Forwarded-Encrypted: i=1; AJvYcCW0NCi9UpnAnudbGmPF3xY1lYniibRlGn+WHCFp0wlrbufliAPguKZJf1fhWYxxFunT+suAPkH9@lists.linux.dev
X-Gm-Message-State: AOJu0Yxhr7sQrwILySy41/cfxG8V7Y/bzjNM1QPPyHdZBnjQPdayfaCp
	Pc29aPKPvnVaeEbUYDknmrT/OpjOo+Sy6kOkftsMpsv3nWe3UxjqbDtYefyeSncqVQ==
X-Gm-Gg: ASbGncsBQloG+pOS6todR6587HbvrxiSHE11MIcUNshQiFqLQ4gnTDElYZHrTnWo+zk
	rDaH6v3ky/Oyk/ObzaHDWxxdzva1iMEFJnS6/3vZs4lK+inJtk2Fyi+p0/KG3NQLtpbLxRcmkxQ
	tVxyv112yrnOS38WyzWT8fVAGKnJvQVKZuGq7BWsJpjZ+WEIORBqdoLk9H7MC8bZUodOPm4rx7j
	MmSJMpivLGlpwGNp7LzetVB+6BT4ReJrL8DRLYmSYYSEnlgs6qHjSD1RJQ9/vm30k6eJUu9Zlum
	frOh760KuPgqv6obG3tpTBsZUli4wqBNGfQquxUUy1u1xAyCzYUxyzBN1d8J9ruMHVix0SOzC9n
	SgIV/I57MiKxzklX7fPq2qrRcIqxE9CiVNwRnrLYFt/xbdRJeBVYRlXS5dJZ7kVJ/eP5RFbsEdi
	hQvWrRVUs0zW+xtXv2c8RvqhU1juUbs4z0LLPfVA==
X-Google-Smtp-Source: AGHT+IHz7vQ0cm4SGWCD8qu7hNB41Aed4i8aC1NkscOeFOjchnLwW8gMwvqn5xaYYumt7DzVtDnmgQ==
X-Received: by 2002:a17:902:d2d0:b0:295:30bc:458e with SMTP id d9443c01a7336-29556477728mr5855785ad.3.1762154320729;
        Sun, 02 Nov 2025 23:18:40 -0800 (PST)
Received: from google.com (164.210.142.34.bc.googleusercontent.com. [34.142.210.164])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a7db197340sm10108242b3a.44.2025.11.02.23.18.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Nov 2025 23:18:40 -0800 (PST)
Date: Mon, 3 Nov 2025 07:18:31 +0000
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
Subject: Re: [PATCH 07/22] vfio/mdpy: Provide a get_region_info op
Message-ID: <aQhXR2M6riHmufl7@google.com>
References: <0-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
 <7-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>

On Thu, Oct 23, 2025 at 08:09:21PM -0300, Jason Gunthorpe wrote:
> Move it out of mdpy_ioctl() and re-indent it.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  samples/vfio-mdev/mdpy.c | 53 ++++++++++++++++++++++------------------
>  1 file changed, 29 insertions(+), 24 deletions(-)
> 

Acked-by: Pranjal Shrivastava <praan@google.com>

- Praan

