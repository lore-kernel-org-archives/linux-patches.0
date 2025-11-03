Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A387B2FD66F
	for <patches@lists.linux.dev>; Mon,  3 Nov 2025 10:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762165031; cv=none; b=QMYnL4Nf6ZH5gL62FMXyhu3iNKxf24fMw6Zk+Iq+chdNTV6vwHQa4TCu6EsdBSeXTmU6a6BIiVHCl0eZuK7+ZWM/zAasK27jdA9vYuACZsYGQYCqY7Pd6qAo/9QO6p3ASFwnWNHZYKltnd/OG4+4/F2CPjZv7it3mxBWvz866eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762165031; c=relaxed/simple;
	bh=FFZiNUWIFKtxHxItZumM7duOWwpaz/Ziw593xKPC374=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=djRvGGaay3/D4+19ipte/aOtOmU4NClmEqVyyrlnCYIt7VK6vCvZaa1VvwkMchhg1xaDQEGVWO2coI3IASq4MV/sxY9cvz+uafyjIfnqk+3Z+7guJf3Vp36Ib1EkdT0mp7gbADzrOjLzDNJy91gyKWoJCJyrDgO1bV3Hg4S4chc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uFnRG729; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uFnRG729"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-27d67abd215so417985ad.0
        for <patches@lists.linux.dev>; Mon, 03 Nov 2025 02:17:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762165027; x=1762769827; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+B58KtJn/bs233pgZmMdorp656WS5EnyOqIx/RHoAag=;
        b=uFnRG729emlMwN0PW3bibkJAPn+XqXoTVqbZRj/qqvM3kA19neNEkbOdPEesu/aR/o
         UxpXlzKWCOvD0NqzD+jfja5O4zIlrvvOvmAg5H2vKv7Yy1Mg5b0hi4OGmJtJuE/Ewfgc
         p87dPpVTkhGqFW7aLFNRUeAJQWuTCjMoujdkJZuhh8JDyiv84Qch9Mov06I/Xte93iGC
         YWkBpA595+0Rs7MyfxAmhjjUzwC4hQ4Trh8ASaiRiLj//al7rtQM1eFBwYIPgYNJ2/Qw
         hjvtDKI6vCU+OecLlE8RVQi1qav0USiNOsgZm/QLYUvn+JxxIaeNKPbDdSTGJ7u3OJK6
         XmwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762165027; x=1762769827;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+B58KtJn/bs233pgZmMdorp656WS5EnyOqIx/RHoAag=;
        b=L2Wx0NALRsMI51K4KyHJsyVjwcuvQCVfi49dPKet+AUFu2YKuhsZyHDVzXulUvSNq6
         CVYYwFujtTcm3vKsflbnnLxUdgAfhtLFGyuZIH7Lv3hDr/+332FSSTMcHYnP6ukP4CFT
         Cf31mDWy7W5ljMj8+ZThhW8k/ofuwskdLTm0bpIeHtSC7fSdBCvs82ycANmz1Zz2sUHb
         LAFdpGhJ8yOjB7LfigrDkWG9I5C0TLfm1c03mC+/VT4KLNTyi5vTqddeHYBkqNccKLsW
         w/GfNEnYgGlrmMbyFdKps7TQ9tY3J2XKc9fF36BWDjHkHyYVNG6WtQd3kp6KSEwSSOj0
         gmNg==
X-Forwarded-Encrypted: i=1; AJvYcCV2LfJcAv92z0y7kXyeZL0lh7kiHOgQmxZ6SUZaqw6dIlRsxCD6EXSZy4JPMEddHvbli7jd03N6@lists.linux.dev
X-Gm-Message-State: AOJu0YyjpqBxClyF5ivroaoDcwPGr1d9GLs3XMzdnJD/XKrCLLgivqXX
	xRyyCEgshvEy/sZmV9yP/xKwHsKk1nvJuK66JwijK1sHikZAY9wRuh9GoicD0WbLZg==
X-Gm-Gg: ASbGncsRfXzyMcTdteCkEJ88SwP7Smho3I8xOPvrU4K5WZVHxCrObP943obyWWorUvY
	EKa8GB8OFHItRYkPRXs0ASjRWEiG92durQK8Me/6EjcNa7g0KomvBCi0Gr4XfvmiNsjZq/di8EC
	OLaS38Y+bx2BcpIo5hH5R8oJrV8tvjuU44HKaAW0sIY0kmXoLbP50lsOyfiMNykz2f7FchS/mFa
	NAdq76HzFdTH1KBshFh0alx3sEJy+xy0G4dITV8Uku7bv5e37MYauPPeDVND6Wuoq3WonH7EMVL
	gqrlN+G2+Nyjb4mwDi+2JzrlDgGEOLZueqlQ2ISWjiDmhguv5dXqKynsHqo6s35wR+w7nPx+nYW
	zSx0EMc7tIS/skqI7tBp8BZqJTwdOzvyeu228ZHFc+PgEz2UxuSAp8ptVHmLMmv6GXQdooh5zOP
	TeZX7Gk5v7OyfVDskRq1jwatkJfikrFOYcAolAKg==
X-Google-Smtp-Source: AGHT+IHxzXLAyCFx7IPmcOnpFb2vp8Rgf1l3Kna0V2OUhXGSl0YxnYi8nj1MD1lWW9qX+m9LVNsxvQ==
X-Received: by 2002:a17:902:e88c:b0:290:d4dd:b042 with SMTP id d9443c01a7336-29554bc5206mr7508255ad.16.1762165026873;
        Mon, 03 Nov 2025 02:17:06 -0800 (PST)
Received: from google.com (164.210.142.34.bc.googleusercontent.com. [34.142.210.164])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7aa4f4c28easm4658013b3a.31.2025.11.03.02.16.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 02:17:06 -0800 (PST)
Date: Mon, 3 Nov 2025 10:16:56 +0000
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
Subject: Re: [PATCH 15/22] vfio: Add get_region_info_caps op
Message-ID: <aQiBGEgQ3vCpCvXM@google.com>
References: <0-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
 <15-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>

On Thu, Oct 23, 2025 at 08:09:29PM -0300, Jason Gunthorpe wrote:
> This op does the copy to/from user for the info and can return back
> a cap chain through a vfio_info_cap * result.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/vfio_main.c | 54 +++++++++++++++++++++++++++++++++++++---
>  include/linux/vfio.h     |  4 +++
>  2 files changed, 54 insertions(+), 4 deletions(-)

The newly added vfio_get_region_info seems to pull-in common boilerplate
code (like copy_from_user, arg size validation) into the core code,
removing redundancy across all other vfio drivers. LGTM.

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan
