Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50FC42E371C
	for <patches@lists.linux.dev>; Sat,  5 Jul 2025 20:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751746344; cv=none; b=SzYE3wVIfUWZjquSXbKGT/0yFVew4KFBSlL/AapubuECgGXqATyx4rSYCX80ZzOUxom0brSTep+3rysvuvVF9T6pzN4cKaC/7F+d7x+MDJ3Vd//+0ItEMxHFzAujskPnHBnK9rv8O0lcxI+C5k24Wjxme6ZXIvqbCG6YDuNpdh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751746344; c=relaxed/simple;
	bh=9z08aVLb91ru0Ot02TohgmJftasWTWVr+dxaYwP4DqM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gOWGY/O75xqmjGwbZdoBN470XpoJQ8ETKvTSgzpHG35XnPJHyn9EY8C8nNxOUY4REfC8qlghHzmvNmZF+uiO9AlPVkKKBy7YpzU7NZJAqQnF5Q80uNVfOvdCXpgfymGZTmfTt84tVEhpXPAfxpMuyLvyQmGhCQVJ2gnV36CDDrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Y4LiTK+j; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y4LiTK+j"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5f438523d6fso23160a12.1
        for <patches@lists.linux.dev>; Sat, 05 Jul 2025 13:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751746341; x=1752351141; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9z08aVLb91ru0Ot02TohgmJftasWTWVr+dxaYwP4DqM=;
        b=Y4LiTK+j+4LcVfZYCdZCs/2IVy0Y9IbhiitUhDqxwEQ2qCjPfOfTZO6U3vDdjhYAdI
         rfglyf0N3/cAW9/1xvRAhP/80s0RUuJXviH0IBPYPayyudbaLNGNm1B3fkKZGna4Qj6b
         /oBin9qjSyP6z4YBAvGA3omMd+1q7VhkWYdzDfDY/JebRFMzeaRI5KFjVBDj0JUh1hCT
         K5xhX7avhvUiHm55abay6Lv00zE6O48sr5HEIiGzJovZybajfWUKtwXgOsav8NHtO00V
         9MloKGUxlfIuqlV854ftX7mqZqvoLXUnoSG3/rFJLCMmddkeSVzTkfChGGGD0jQ5bHjZ
         R98A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751746341; x=1752351141;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9z08aVLb91ru0Ot02TohgmJftasWTWVr+dxaYwP4DqM=;
        b=JO2OX2fmgIpWWZdAzb2Ef0xUDw+ArvighcXmNm6n8TR7eDF7K0gnosD2RxsL97Xwrx
         gXg8pjV9TxTY1V84ZBYDcA6o8npf/S5pgb29N8pOjki/k8RroG+JX5bpxsoJP2NjiFsF
         4HtzE7lpEjiskN47zbVV+/HQhjcknWfdJxNizHPd0GDwm9QHuVXQsxoTFyb8rAm9LH/3
         XcJVjaN62ZS0ldoW4JRyFA3lO7YPIrrA7B9iYfGqyqd59Fovvjx6MbxZXPfauWn4+b9W
         wFjYxJ3/Ftyk6ZNCG9knAVGqVmio1UBQIVT+l2yYZsmjLc5k3HA/5D+T+xKtyeUMvjuT
         JLSQ==
X-Forwarded-Encrypted: i=1; AJvYcCVoLr1qW79DpjbZxxeBjahEyDcgk7DuRfWfwFi62pt1ffyTGSNm0Mpg0OrgBmmHBq5ByC1TF1ZE@lists.linux.dev
X-Gm-Message-State: AOJu0Yyeug1rEI3rPh8Z2qqZ/9gz1wsm/FhySPec8dnDM+DytIkXrE7r
	DlUf6wc5KnfwhlOaxCLq3e96tugHAuec30FQ4qNktygu4xBSMWdFo8Dl8UJa0m/4FTbPpK0AD5t
	xMQzA7XfsZGm8+30lm6YJDITKklwYyGhJbwyUwF18
X-Gm-Gg: ASbGncuB2sa0I5Whu1fmuAYQgsHTGw/v06TaSCj+TScBeOKwMEeFWkotcqpJke99iK7
	2msULoXbioIioPT5CjV8tOg/BEp/B0bzj1NF6VzRVG03Ax+LwDnxAwkaFcE+k3U8GMIak3G8mXa
	oiNw28ZJSc5RYkUJO0lTC0CGussdPDDOcDdGUwJUQs
X-Google-Smtp-Source: AGHT+IGJer1bSae1hTy+VdVDgBmIxrnrLy6/1vEbuh3ihuiTHeYj5NRruSmZ30W23oHspApAquJQsquajOdAT1S7J30=
X-Received: by 2002:a05:6402:5107:b0:60c:bf83:65fd with SMTP id
 4fb4d7f45d1cf-60e73d1b918mr259571a12.7.1751746340448; Sat, 05 Jul 2025
 13:12:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v1-8c5f369ec2e5+75-arm_no_split_jgg@nvidia.com>
 <20241101134005.GA109739@nvidia.com> <20241104113237.GA11481@willie-the-truck>
In-Reply-To: <20241104113237.GA11481@willie-the-truck>
From: Daniel Mentz <danielmentz@google.com>
Date: Sat, 5 Jul 2025 13:12:09 -0700
X-Gm-Features: Ac12FXzjkeaKni9wvVsiCi9BzDFbIznXFt9RbbGeY2UoHjBPMAYPOLioSuEBQ6M
Message-ID: <CAE2F3rDcq-BQYM1yYq6RNSYSOovdoyRcbYw8Jy+BXCHLkrWN3g@mail.gmail.com>
Subject: Re: [PATCH] iommu/io-pgtable-arm: Remove split on unmap behavior
To: Will Deacon <will@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>, 
	linux-arm-kernel@lists.infradead.org, Robin Murphy <robin.murphy@arm.com>, 
	Boris Brezillon <boris.brezillon@collabora.com>, dri-devel@lists.freedesktop.org, 
	Liviu Dudau <liviu.dudau@arm.com>, patches@lists.linux.dev, 
	Steven Price <steven.price@arm.com>
Content-Type: text/plain; charset="UTF-8"

With the removal of arm_lpae_split_blk_unmap, I believe the following
macros are now unused. Is there any interest in removing those as
well? If so, I can draft a patch.

#define ARM_LPAE_PTE_ATTR_LO_MASK (((arm_lpae_iopte)0x3ff) << 2)
/* Ignore the contiguous bit for block splitting */
#define ARM_LPAE_PTE_ATTR_HI_MASK (ARM_LPAE_PTE_XN | ARM_LPAE_PTE_DBM)
#define ARM_LPAE_PTE_ATTR_MASK (ARM_LPAE_PTE_ATTR_LO_MASK | \
ARM_LPAE_PTE_ATTR_HI_MASK)
#define iopte_prot(pte) ((pte) & ARM_LPAE_PTE_ATTR_MASK)
