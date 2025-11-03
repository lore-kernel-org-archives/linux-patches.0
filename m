Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1055296BDA
	for <patches@lists.linux.dev>; Mon,  3 Nov 2025 06:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762152115; cv=none; b=FF9n2FiRdt24oHb29ugxSl08GAnDL13EX7Qnlje5I1MRzccJHTZXoclNlewRgDyGff4jf0/KhabwHb5fPP+sVsm3AGQSXYjs6PmeBkhe8p04q6Jbnss42byDsZ8rgZevFOH8tTntAmBe501tKxK5ZqdoAAoBIw/Zxe3Dbio6OuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762152115; c=relaxed/simple;
	bh=+CzUqqO06i/e7Ypbz0z7VulGOd2vXLPuLoDoGKacS4A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aZNwkLBErvJyjK1mk7DUQADGdS4g1CIn8GS2KrQgQZ/s1vLqnCERkK589k9HhkrhkqjjpJA7ZKqc7Xlpn/OjjcN7ybPNOwW/14xq6vLOdpPOnULZn2MykN8K2shfoyoiTX6FhK5CP79TgqUCn7r7OnzXtNaHGNmcDAyezCk4eL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zHXC5Gvv; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zHXC5Gvv"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-294f3105435so334075ad.1
        for <patches@lists.linux.dev>; Sun, 02 Nov 2025 22:41:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762152112; x=1762756912; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xy09bbBV2an4SjPwDAIo8320NA2LlnNWvmRboTY817s=;
        b=zHXC5Gvv+SlmVCaUcJ0TifIW4sy88vZX1oP8trkVmHfnBQ0miEJBF+F6ASM3pu7d0s
         Wbr89m1Y337X4AfATfaLwbKJ4fKEytvq4SWL6pnD5eiX4CSeKcjqs2tO5ksdLPfF2RGD
         qEt3OisRD9ZjEia7dUpLMLASDxsiLTBR/MWiFzQDlVMfyl4H2hS74xP3E3XruPYvblRL
         0sLYJnOJGQCI9VkJWiYSdQ0oTenisYcga9TT1abcTApp64Qhd3EDdNUKUHK6xG7JgGn0
         1WCX6ISpAtobetVBDo0jT7ms/uiqchtBet8+SkTIk/RCK37lK7zLfSV/4GEAYQtFXLew
         xAzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762152112; x=1762756912;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xy09bbBV2an4SjPwDAIo8320NA2LlnNWvmRboTY817s=;
        b=V5aL+ydg2QCVPsAMxslxKeI+cD43Jp8NJ59iKCk4ZhLdrpr2WOOCVcBIG8/LFmTmNR
         thaYAIctNL2g6qmBHHWtFM10qHCnoz4EEDK7kX+kyfjI0KeXGMNT5Rkn3phBWpJM+d5c
         v2GQ5+9axJYTdYk3tBtopTzHz77KPCsIQIC0jRy2Lu8KgIA6Oe98qv9+stY+vDYBL1XF
         4QzZvDy4Ty38k6OF3tAVRq6sLazCSeM8h9WNL4KKy4aWC/DvpQ8/VEBaMwWOQeSDEhtv
         PpzoC2qWfDL4aa+vI4grqFp9tA34ykeru9taFe+2taDHpkxraOxwqTQAENwp4wH447nn
         TUtA==
X-Forwarded-Encrypted: i=1; AJvYcCXwJHHsDX9le8V63OxzerbtZpiFnPbNtPVbiy0kYR/1cur4wqkK5+bqphFVl+kOzEoyzUoNKbY5@lists.linux.dev
X-Gm-Message-State: AOJu0YzkSzhLftJNwy6cw6tLcGoNHYiH1Mp8td+snd04U69RhWFtcQ7o
	WQdTrlqiRCZUMGkhnFFZgJ9roZaeGPXaLbASqUfhejs/urqx1SPkhd8aD/SzmARx3g==
X-Gm-Gg: ASbGncv6dIh0a8QFBYQLCobB6EnPObkwAgMwix5EomrlWlMWB5DvcQPmvmWMSRpXfc0
	2JrbrPIeonSZhBtWRhKtI5FSFzmRqeYpeEZnXieoucg74FMaA8S8VnOWxTY9D3CPwuKapSMrVH3
	LFEoHvQTJEnatNQHXLMr1TvGUvM6eA3It4ViAgSz1c99/n9ncUotS9bUfNLDN+VOOw6hqjk2zcE
	sOk6hZGlVlWstieCoEGlVx+bwRYdKm2xfkTkTqQ6pOKuZr1vUqcvjr+8V9L2aAUHnSBgOkLrk02
	wea0AfMnSnVU5liIhoBoXwOn/Tr3+4l1Tq22VhGgId24/Qpahzo7de3EOV6G/XvDgF80LF3lIuz
	queEOtep0S/+kWHHjfvKOPdp0gvM4wjOl1PNZkso+M1qrAsw0LFz+XHOMgyJA2xisqhrZJ/HPbC
	UlxmcE+eIYw+NK1XQKJPef5ll6hiMPU6C8Bof8NMoRGbd/V5Tz
X-Google-Smtp-Source: AGHT+IGU3X/bvekwg5vtQ6XJGr9uQJGWUTHzyQr+Es6KbcLgu8QfXVso61Ocr0oWX8j6FOttuRoGtw==
X-Received: by 2002:a17:903:1ce:b0:292:b6a0:80df with SMTP id d9443c01a7336-29554bb5aaemr5658455ad.10.1762152111810;
        Sun, 02 Nov 2025 22:41:51 -0800 (PST)
Received: from google.com (164.210.142.34.bc.googleusercontent.com. [34.142.210.164])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2952696eb6bsm105902925ad.58.2025.11.02.22.41.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Nov 2025 22:41:51 -0800 (PST)
Date: Mon, 3 Nov 2025 06:41:41 +0000
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
Subject: Re: [PATCH 04/22] vfio/nvgrace: Convert to the get_region_info op
Message-ID: <aQhOpec7prJD3zKm@google.com>
References: <0-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
 <4-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>

On Thu, Oct 23, 2025 at 08:09:18PM -0300, Jason Gunthorpe wrote:
> Change the signature of nvgrace_gpu_ioctl_get_region_info()
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/main.c | 15 ++++++---------
>  1 file changed, 6 insertions(+), 9 deletions(-)
> 

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan
