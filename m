Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C392EFD8C
	for <patches@lists.linux.dev>; Thu, 10 Jul 2025 16:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752165806; cv=none; b=r9aT+WW6QmNI0SC2DH83ZuQS2rQLdfmRq0tfSVNtk+ud2RhqoHH/v0ZN9rFjunGG5pIAFWIlKIoTtlxqJ3FeY9d4WkoUdc5NY72w4wOeGeQRrAFP6WnuxHc5t6Uzfu4TSJncWCy8Zc7qUZxNWXtsU7aK97J0mzG8QWbGt+O2F+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752165806; c=relaxed/simple;
	bh=FL1g7AAqZse2G2GgfyKga3py6hCil3qJCjBWU6lZuGA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cvADoqS/OICkJ4RSyNq/jWCJz9qFTPXGBMM8lwAV0ltdhXd7WFbgqdIwQOc4zyK99MAUWHN4jZ/JRK3D5usiddPg5/6tzRRYDO5YiZUKCEGvEZEJItLTwllqYJAiUwGpdohToDIiRKQYEjBTaAtNeil8PLIVh7G0fbEUx8m7H1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uuktmy9m; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uuktmy9m"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-237f18108d2so3945ad.0
        for <patches@lists.linux.dev>; Thu, 10 Jul 2025 09:43:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752165804; x=1752770604; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=C2eyvzlKuLCQH5Cuh9KFE8Y+QAaptwkDzMvAXLYmk8E=;
        b=uuktmy9mSpVFr6T3xSCXF1CeLiV+SJN+kefx6OEeh7yA0MCxWcS6SPYAN5H97/9pVe
         02+vBv19PtXGSvFKN9Nv1JEMpSnYhdDYpiUgoegnT68jNjRhvgyJ1wmb+cjcsX56Rly+
         6JY1LKc9mtVZcGkG/NaA8vDhVgpCw7WNTo4JGTJhUYXNp1TmXNr+DQjzxmbljoG5YxID
         q6K7qqXqJwzNlvBU5HA19vFySIkell42jO98188YrEwu0LnTh9iJ4Y65k8MQtRafmK6N
         0QhVYSHpCZW9gxNysGNPnkw2VlnI3gn4z7ijIzCKJEotbYbZpCg3GmfzRFtItR9x1/FN
         LoNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752165804; x=1752770604;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C2eyvzlKuLCQH5Cuh9KFE8Y+QAaptwkDzMvAXLYmk8E=;
        b=Ib+rxVPyv3c7l7nvpizt7hRtDecMpYi7Yge3TS/Yi8Xax+CQ2Yaa3tKNd45dFPaNzq
         e+dUnG3MmFG+E9ktzyqjL1+kXRoY1avPTGxZzrVHUEPgmRyFCfye0p63/mKfanLPr0Jc
         /9m+FW0+VPvQ1KZYMv+daszP3qjh87VUTczE86eosi3lT3SOFzUS4yPfyK5eDqg9qZMT
         Z59fJc6oua58QrzIxBkANzi0paqU+SqnIIMaH1s+oS34vBDpJH5Bd/BO7vzbRVUtsZR/
         evI1XP8369JLJrIgaxukL7gQV7sQfPL4Q9X6hBdcgcFY/Q5WVjECGY24YymrftS/WYhM
         k8Hg==
X-Forwarded-Encrypted: i=1; AJvYcCWtKirDGJYo6vWRtH84ZHPIZsDUoyiK85Tt6yrcaXgqbJVoK/eGnr7IZjxyGF8/MZpriPbNCrgn@lists.linux.dev
X-Gm-Message-State: AOJu0YzogKM1k6haFZscc6GLj1OGzDNJZK7ig0MUnjXDFBATwNzDG6Kw
	ng2/oU9bUORX9rMJb0k2k+pcI8RAVIDBd0eVRsIWb4Cy/bTHMAibZCrTEGf3AoYaXQ==
X-Gm-Gg: ASbGncupiTaMGYGe2mryQ2+bYnbsCDv/BO2MLkbbg9VkqhptXmJaCf6gsI7QB7T7Ze7
	82cPA8+3N/KmHXh6QMK5AK9zFErJ+/wpqepYuv4JtZ18otsZ5twFn2br5Iz9ZiRkxAHpMKE+APf
	6pbMYaj9ZyTto9qegvae9TxR6oJ6QhBa69wCU64kweYAvIeheO1AeNPc+EaQkBLdJVOXt6eBu+O
	IhgoSbNzb0vAia2iQ79FGk5cyKTOn0bfINjWnnHij7CoRNZcFduPLF6rdQWXTzjVRQl/dL9KBwW
	kt/m7DvlpPki3nxjh5tv2IGIluEA2nqUsu5+zwXxdWNIt27luEksTM6+bTgti04o6ZnYlemd05v
	ix5eouVMNyOQiJuXLOuyI/375zDuwxVk=
X-Google-Smtp-Source: AGHT+IEFm5EK2K+aFRgM2luBkKYZSMINjT3NZbf79E/WEwhVEuFkFUby27jaM+gbx9d+ftRkB3XZMQ==
X-Received: by 2002:a17:902:e94c:b0:234:9fd6:9796 with SMTP id d9443c01a7336-23de43702c4mr3052595ad.19.1752165804369;
        Thu, 10 Jul 2025 09:43:24 -0700 (PDT)
Received: from google.com (232.98.126.34.bc.googleusercontent.com. [34.126.98.232])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23de435c2e3sm24897415ad.226.2025.07.10.09.43.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jul 2025 09:43:23 -0700 (PDT)
Date: Thu, 10 Jul 2025 16:43:14 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Nicolin Chen <nicolinc@nvidia.com>, kevin.tian@intel.com,
	corbet@lwn.net, bagasdotme@gmail.com, will@kernel.org,
	robin.murphy@arm.com, joro@8bytes.org, thierry.reding@gmail.com,
	vdumpa@nvidia.com, jonathanh@nvidia.com, shuah@kernel.org,
	jsnitsel@redhat.com, nathan@kernel.org, peterz@infradead.org,
	yi.l.liu@intel.com, mshavit@google.com, zhangzekun11@huawei.com,
	iommu@lists.linux.dev, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-tegra@vger.kernel.org, linux-kselftest@vger.kernel.org,
	patches@lists.linux.dev, mochs@nvidia.com, alok.a.tiwari@oracle.com,
	vasant.hegde@amd.com, dwmw2@infradead.org, baolu.lu@linux.intel.com
Subject: Re: [PATCH v9 22/29] iommufd/selftest: Update hw_info coverage for
 an input data_type
Message-ID: <aG_togvop53dLSZM@google.com>
References: <cover.1752126748.git.nicolinc@nvidia.com>
 <f01a1e50cd7366f217cbf192ad0b2b79e0eb89f0.1752126748.git.nicolinc@nvidia.com>
 <aG-fZv39ci6yip3z@google.com>
 <20250710153202.GO1599700@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250710153202.GO1599700@nvidia.com>

On Thu, Jul 10, 2025 at 12:32:02PM -0300, Jason Gunthorpe wrote:
> On Thu, Jul 10, 2025 at 11:09:26AM +0000, Pranjal Shrivastava wrote:
> > On Wed, Jul 09, 2025 at 10:59:14PM -0700, Nicolin Chen wrote:
> > > Test both IOMMU_HW_INFO_TYPE_DEFAULT and IOMMU_HW_INFO_TYPE_SELFTEST, and
> > > add a negative test for an unsupported type.
> > > 
> > > Also drop the unused mask in test_cmd_get_hw_capabilities() as checkpatch
> > > is complaining.
> > > 
> > > Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> > 
> > Reviewed-by: Pranjal Shrivastava <praan@google.com>
> > 
> > Note: I see a couple of warnings while building the selftests on Jason's
> > tree, but these seem unrelated to this series:
> 
> This is fixed in v6.16-rc5
> 

Alright, this was on the `for-next` branch when the head was at:
3e2a9811f6a9cefd310cc33cab73d5435b4a4caa
iommufd: Apply the new iommufd_object_alloc_ucmd helper

But I see that on `for-rc` [1] the fixes are merged.

> Jason

Thanks
Praan

[1] https://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git/commit/?h=for-rc
