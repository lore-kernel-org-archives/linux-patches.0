Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4BD2D9EE3
	for <patches@lists.linux.dev>; Mon,  3 Nov 2025 07:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762154366; cv=none; b=Xgq0xmujZ7XcRU8bXZAUbyRomG+DJwl+c+XQW4XSKCMCgJfohvp6VzDLov+bVRQiDoou09IEb03J8i0BLEilnUcvMYgcUUGXbePKCdxJGdKxmgtIK5bfXHhMOkuDu5WHTUDenYYpm8A6y9H/tSF8suvcNTRSCoSqpt+V4mNot98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762154366; c=relaxed/simple;
	bh=bTu+sl9W2Jx7okIIkeQnTAXEp3nqEUfmyMval1/FNXk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VCqiIOVVGq0P8mY/nOhbDJlT7J5+5snjtaSVyhCf6fmGg5JPK2WB20nZPg3xVJP8sYL2yt38sPo/qtUzRLYpTfJMHKJHNPi9wr3tkOlOB8ZcVmAOntcHA6pCI3fZBFYWVBd6X2Go8lD7grl7HGD7517dOWbDyiC3+UyLdnIeKDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Uf1Z1AMx; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Uf1Z1AMx"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2959197b68eso194025ad.1
        for <patches@lists.linux.dev>; Sun, 02 Nov 2025 23:19:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762154364; x=1762759164; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=o0HFTQsa219SiFwfMSsmBPJDLvHU+B5q0B3I9fdpwts=;
        b=Uf1Z1AMxGvwvEyhc6k2ha2xRgpsNikztS0w1k5Ra7ENJRcI/0FxLRH+bNQqdyyJRw4
         1Urk7sAlsMgtpVvil5V5JDxpleD+mtAzhuNSfOvE/wOlhgqwQtKSgxka8MdFGduyp6HD
         A9Kl2pB37RufLjdvudy5S5xlfDPP6HvNRilJaWKcag7qyr1ItlUgBELGFQILrP8QrzJ9
         veD+5s+9nICeFDR06wxzj6ZWaO9F+z/nWeXYIYV7ZeTBP5bbL3tm3Dr5QNa8ZmbkBHuE
         rTZRDnM0kEZuRzqyqtr5KnTdXtCnrfW+CYadAjCdy5TeUhe94BXkN0iVmfitJEEjU6bD
         L5zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762154364; x=1762759164;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o0HFTQsa219SiFwfMSsmBPJDLvHU+B5q0B3I9fdpwts=;
        b=uWczOCRikmuN0cjGUleoVq+TbPO5MCxIBP4iCnR4x8zQpFXTbyG5rTcdroq+TkX4vw
         qHl/xjDK1SMZglipMvrZG46DiD3wCeQQEy843fDfrvLe3UuGeZ/DeBgfad1GLXdS1GKe
         HHSf2vUyd+PIny/XzORm52VlwKZ5QA5qHG6AhCpKdM+SmNss/PbCyEQEpNnseFQzGFVA
         qHRRIjVXFp8WYPAJ5Q1oYrcDyfotwEm6+jvoqHdIxYG15BeMnqoYUdQWYOPryG54THZv
         uKDz4pvAIwUCPrzqrEeK7AxtlFpP7ioh2YX0VJE9u3bE7HyA22NzMdDM4HRR1SVqrHBS
         /H5A==
X-Forwarded-Encrypted: i=1; AJvYcCVluIERKlOzKt/F8ed+SNd+keWTTSDq4//WNctEgahd3omtleaT+0e5KgjYpcF599CgHnks3JcF@lists.linux.dev
X-Gm-Message-State: AOJu0YxkryknLO6Yp1dEKBa3CivK/VgODhgkTmDZOi6kHmQN/ttAHj5O
	LzvORF0mXiFpaiq3okrg9AsSlZ9PZL6ctTkK/UlBRkX4nwKk7061YoWoltWxgGfRFA==
X-Gm-Gg: ASbGncujbR9VBTORodHFU5N2SM3h4PsGUTPQkIpkJw/jp/W/Guhs3UizEAAJ2ojnor8
	kzL5af/VKIVJaWtZbzXztTmdOApb/puGx/yR4fg7TpnqJLn2pjb0iRn8ydxQ4KtfLIGp3I6S38z
	XyXfj4GnUe9qjQUU37tOqMpCiQew56PUAyd34mshsfVtsoQo8vbiUpyHM8btF+k7H5oNQd+v7bY
	nxIkLptbxSm5cuUb3errAihS0duZk5aTwf95+D/rSg3U+qVCgPdi0s38/RroJIEWk1eDl8lZAH+
	wh14BQc2eXbIZPcFw22tN9uBKXhEerNxBo7uRA2SMquf565Tvx6YLP/hMiH7rn+Qm+6PF01vVvY
	Clr2ZZdUbnUUpKpBnNJBz5W+QNEJgju/jAjoN1yuSxotpEw3+l7SJJNJ6+ggVkkSQ7DoaKVE+gv
	+1DACLTAZ04KLtV7OMKQqmxwmTD2URRHVApcRbsanYfuHYEuXZ
X-Google-Smtp-Source: AGHT+IHBQG+HPW97p+DH7DuUW/9lAGzWwwSGGkvrgXSHhhLN9zwUvIOn1ehyN1vXIvTruEG3QceI6g==
X-Received: by 2002:a17:903:228e:b0:295:1351:f63e with SMTP id d9443c01a7336-29554b86336mr7219425ad.10.1762154363599;
        Sun, 02 Nov 2025 23:19:23 -0800 (PST)
Received: from google.com (164.210.142.34.bc.googleusercontent.com. [34.142.210.164])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34050992e91sm13497150a91.7.2025.11.02.23.19.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Nov 2025 23:19:23 -0800 (PST)
Date: Mon, 3 Nov 2025 07:19:13 +0000
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
Subject: Re: [PATCH 08/22] vfio/mbochs: Provide a get_region_info op
Message-ID: <aQhXcaRDSXkmPuCb@google.com>
References: <0-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
 <8-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>

On Thu, Oct 23, 2025 at 08:09:22PM -0300, Jason Gunthorpe wrote:
> Move it out of mbochs_ioctl() and re-indent it.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  samples/vfio-mdev/mbochs.c | 56 +++++++++++++++++++++-----------------
>  1 file changed, 31 insertions(+), 25 deletions(-)
> 

Acked-by: Pranjal Shrivastava <praan@google.com>

- Praan
