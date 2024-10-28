Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 977971DB360
	for <patches@lists.linux.dev>; Mon, 28 Oct 2024 14:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730127233; cv=none; b=UGmuwh7BL42nMnosfuKe4peR88KyEvw1FI3fICd9YiKFyU2nEtHciUQe5fi9JDfB/JfGqkq9yZdLz/8HMgjAapDusRaJGMR4xlOaqcPGY0/ZcCWFaKRUJS7H/mHzzwYfiLN19SOeUNsKlMLH2Fak7z56YCsvkI1/yR4WiI+kXvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730127233; c=relaxed/simple;
	bh=tYb/zBUosi1Aw03l7Ek5wmBbG3dG3J1OV92E6B3BlZg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HT1sPMIHigruzu7Tyx5OUQ3kopUrQfQzaBcQocnjMb10hBKLT2cz5PqMeuO3xuOSJpTwimKTd3i5/fxc871Het6MNkqfupHmow3DyYhkOOnxwbfKfFxad0IfGv9bIXtRISIpgZGHR2vRrWumm9agruKZFdalS0DILbRVdfZVf4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=PDaKcSkb; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PDaKcSkb"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-539f1292a9bso5115494e87.2
        for <patches@lists.linux.dev>; Mon, 28 Oct 2024 07:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730127230; x=1730732030; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tYb/zBUosi1Aw03l7Ek5wmBbG3dG3J1OV92E6B3BlZg=;
        b=PDaKcSkb9e2Z0PWf0leCEZ0BHIGmhL+96AVrORTIOXt9Pjwofdpep+FgA4bqO+wPIP
         Z5uvJyZH0ov1FmxeHPXuLDjsY6CAjORHURVNlARpHc31G9vsb/a3D+MZHXzDfPgTwnoc
         T0VA3CHxw9R35+uM+fKoKdZ3rbRCvmib1RPYZAjTgj7A+d0rbyX7IbA36qpEeRZ6VGtk
         Cwxzi8KV9lOM5yWALjiA2VgdaXSrjljv+CBqDsNfrg1+4mx95BLh57jr/uReOlES80ru
         2HsMghO372y2fc7ukuzNY9VXwcmiLRdHhcDFJS7rqakVtYJUQouHHJWw7FInLAv1Qb1M
         x1Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730127230; x=1730732030;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tYb/zBUosi1Aw03l7Ek5wmBbG3dG3J1OV92E6B3BlZg=;
        b=UC5Y0eTF03ZlpXhtSDrIPx/MNpevnjk+3z8S/KSiAiZEWk8tKFMgcDm4OFQREvlOGa
         82W6cpqQbHxEucfFGGMN8gyEjNL7/+/4EiV7FanKUftgOcqyilxcOXGdv0ft3oCuldhe
         P6vi//SsgLjRJ5CbdDae5EB5nJLA0FMLh7sn2zCC+kKPmbOLWUbP4pQq66snl3ViDaRR
         ujz/Xk/0AltXbv4jshzkHAZCUi9LqrdCGCISc2VNgH1IBPSIFsqgZYHgRmNS8IAG90tE
         HJHkuUOLmlm4i8+BoFnL7D7jafny+3Diy1rLkHfSBDzYHHSCGdjQi/Db9akElrscGXxc
         DTbA==
X-Forwarded-Encrypted: i=1; AJvYcCX7cBTiVzjE1G8UQw7YNgKi6VM1y8sSpP/7GU+v34U53AyNorVFFQebiWRiJdQptODUptihUxcO@lists.linux.dev
X-Gm-Message-State: AOJu0Yzv0kgbIDynblayufI5P4L0gjT/fYO25KPJH83RjE3aMbbgUUrx
	WoRAlRDUcS2sk3uPoZUW+RwOmEp83Yn7MrTnEmMQ8PEVMLjxRBRFuBlkG2hTY4prqy/2Xk2KMZx
	CClhfgDr+b5llPfnw68j/v94DjF4srfnSWAuGqA==
X-Google-Smtp-Source: AGHT+IGlKQWc3SNm51s3PmWaJ7k8IkmWwj+g1zwTCjME9I3N35fBxQXDjWPZqSRQvbi+ZoURs9MmaNgH4mwrA6FxW5g=
X-Received: by 2002:a05:6512:1590:b0:539:f554:78ac with SMTP id
 2adb3069b0e04-53b348b9125mr3453985e87.9.1730127229738; Mon, 28 Oct 2024
 07:53:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1729897352.git.nicolinc@nvidia.com> <4f5ed9d75c23a503ffe672a85cf9010569652794.1729897352.git.nicolinc@nvidia.com>
 <CABQgh9Gkt5tsw+wr_=WeA+m=Kz2xY5Z7aSBNhHCvBG2r=7O3TQ@mail.gmail.com>
In-Reply-To: <CABQgh9Gkt5tsw+wr_=WeA+m=Kz2xY5Z7aSBNhHCvBG2r=7O3TQ@mail.gmail.com>
From: Zhangfei Gao <zhangfei.gao@linaro.org>
Date: Mon, 28 Oct 2024 22:53:38 +0800
Message-ID: <CABQgh9EgXsyHDzZHK2FMuUw-eu9zeczyMGLTUjS3AKYUHKwwDg@mail.gmail.com>
Subject: Re: [PATCH v5 06/13] iommufd: Allow pt_id to carry viommu_id for IOMMU_HWPT_ALLOC
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: jgg@nvidia.com, kevin.tian@intel.com, will@kernel.org, joro@8bytes.org, 
	suravee.suthikulpanit@amd.com, robin.murphy@arm.com, dwmw2@infradead.org, 
	baolu.lu@linux.intel.com, shuah@kernel.org, linux-kernel@vger.kernel.org, 
	iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kselftest@vger.kernel.org, eric.auger@redhat.com, 
	jean-philippe@linaro.org, mdf@kernel.org, mshavit@google.com, 
	shameerali.kolothum.thodi@huawei.com, smostafa@google.com, yi.l.liu@intel.com, 
	aik@amd.com, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Mon, 28 Oct 2024 at 11:24, Zhangfei Gao <zhangfei.gao@linaro.org> wrote:

> By the way, has qemu changed compared with v3?
> I still got a hardware error in this version, in check

Found iommufd_viommu_p2-v5 misses some patches,
Simply tested ok with iommufd_viommu_p2-v5-with-rmr, (with some hacks)

Thanks
