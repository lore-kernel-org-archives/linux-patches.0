Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED46322D7B0
	for <patches@lists.linux.dev>; Sat,  6 Dec 2025 00:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764982111; cv=none; b=FjQuv2uYk7At3hmAQdGGacTdzyqjbzlxqfTx+RtXMV9P0JdixJeD34c/WsW/9K+MvRxqES1mLw0WRUi4CNWqCVr8vLsHf1QdjuxGqYRXbzhvDxoGkmvw+gfUTCwgS5Tq1ssbxmGbaWperYZHKgss1ewlqLr0RIZNs7pDae9bF4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764982111; c=relaxed/simple;
	bh=dvZED7I5EaWFDhOiPzTV12QUqtQZj+HgZ6ZZDFaq2uI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=vAgxEE1jF5iDZtvqU/2+WhQIAGLjHeiCzkFIGShHANcoNSKymO77KUgnZ3+xJd7OFCShEff7dgf/kl8HXM0dcb6BZYRKKPxdeVjOID1NlGWtAQm48zXh7UsDsTToZeUXo+JYz8P+FC8SFWGwhJ+ZsgrtWSZGCCWKJSQ0P0CueRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=VjdwJnQo; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="VjdwJnQo"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6419b7b4b80so4055940a12.2
        for <patches@lists.linux.dev>; Fri, 05 Dec 2025 16:48:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1764982108; x=1765586908; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hYFSn4Mla56zrJfrsS9OVnybbb/9yNVAJbUr5EfaPD8=;
        b=VjdwJnQodacvVgkq2HMPit4tHX+RTjXXIJLUnYudsCz3IMy5nz12mDXARvHEI1r6ZJ
         wnCHOGUIfOf3x5Yzj8FZW1xoJeu2rbZQAeUTEkn9y/81j5mb6O+Ui92XeTzh8plL1Dhc
         4eNR6nH3zDLipXkPQk/PR1Ghiu2JHirbcxtf7wG7MzGp9Np2YuUGnzl6o/gQFRWcJ/nc
         7TreB6FDXdfizE55q95ofNjplzTh0esEReTyyrDYIeKwH5kDc2Kfmab7AodXtEJvFGk2
         bub/Lrn/j10awHvUP84Kb+HtjNb3wUCy5DEiXD0RtAcSsNrObuHgqPfFZ/X1kuzAl25D
         Acfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764982108; x=1765586908;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hYFSn4Mla56zrJfrsS9OVnybbb/9yNVAJbUr5EfaPD8=;
        b=PKDOP+HMWBLnW51j5aiYg5so6KDbMCOQcQKtvuhRNsExYcl2xiLLtjUvokhmyt3u5W
         ZruA0xq4J0wU4FNXiIjoQjZs6YrTLFsh3Q9ZxXcuSgbTxrTKjbjnC6FDDLYnUBLvJZSB
         U2NknllvIH/pzENfdjohxHB2zH/J14LNbuvfemBzPmh/1DS/O1P8F4niDZCzVjFIctp2
         OMap6yBSonZ2TCCxZPh0fkFc41ipg1b3ESki4WmC8wnq25eQnHXOsTmYZYjtqxAamf4b
         PWOxE6KT2f1ebu3U521cETxmfuDrDGIdkoEFsGJ3ftUOtYOvt2/xpRcUIhqInwLcmxEL
         xOaA==
X-Forwarded-Encrypted: i=1; AJvYcCVsj3NqVB/fNvi4SQAtQiQZv/86GQk6nx/L5s3p0aSXc/bn9A38hAK+VqYuNIa5bjcrcnotNirf@lists.linux.dev
X-Gm-Message-State: AOJu0YwDNo67izcHplW7FVGclxgecbo1opcr9+b2KjjaOYJFXsFjiTsD
	7OALyS7bnh6/Xh8CjwlMldvAYiHLEbRMowGzvxhAgxCWYyY8K0rXXF0PVyBRQ8MvK4Yud8zsv7V
	NBsupxRlVLhCMniIHKcCpnO+0L1x+mlpMr4tXxrTuuw==
X-Gm-Gg: ASbGncsKgf/HUq58zMEfaiVE6wjiyn9jciJRr6AwQ9iJBAq+am8e43rREzKe/J8ky+o
	WdsMlf4I9sipxeYTj9CEMHYjpwvSUlaF4FfQpPe0GGNj/EyjAt1I9I1EviFHuMN4JgQypuMv36f
	hFFz4O5G5+xVR4K66xp5GtKSNvrvVFAcD3rIsO3WdhilUNzX3VtAHCjOGVxVDX2T6vaJiCHgVHz
	BT2OymcAi+Aq0OgGnm5G/2iiUwA6dmfIYYiSIpd3Lm8FVH8GacJTjk6amqyCYZMXPaWit2kYw==
X-Google-Smtp-Source: AGHT+IHeuea7f018W/ybeuOlyuBz3yajrAEMzeUHfvEK3l9q7hep1NqHdVXjVJEaRnPLDzqQLTlpbkDwXtGRJpndsRM=
X-Received: by 2002:a05:6402:5241:b0:640:a03a:af98 with SMTP id
 4fb4d7f45d1cf-6491adef3a4mr604730a12.18.1764982107917; Fri, 05 Dec 2025
 16:48:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v1-c8ed57e24380+44ae-iommufd_selftest_hwpt_leak_jgg@nvidia.com>
In-Reply-To: <0-v1-c8ed57e24380+44ae-iommufd_selftest_hwpt_leak_jgg@nvidia.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 5 Dec 2025 16:47:44 -0800
X-Gm-Features: AQt7F2ogqxyh6MmWmgDQORDb7kXEZHiqdN2QBJWMJQd5nBv7GMEfINDGJAQTmqc
Message-ID: <CA+CK2bARGxxeafk3R06256dFRB_VNj02N41iADTSQOT35Z-K4g@mail.gmail.com>
Subject: Re: [PATCH] iommufd/selftest: Do not leak the hwpt if
 IOMMU_TEST_OP_MD_CHECK_MAP fails
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>, 
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>, 
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, Joerg Roedel <joerg.roedel@amd.com>, 
	Kevin Tian <kevin.tian@intel.com>, patches@lists.linux.dev, 
	Samiullah Khawaja <skhawaja@google.com>, "Lai, Yi" <yi1.lai@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 5, 2025 at 4:40=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.com> wro=
te:
>
> If the input validation fails it returned without freeing the hwpt
> refcount causing a leak. This triggers a WARN_ON when closing the fd:
>
>   WARNING: drivers/iommu/iommufd/main.c:369 at iommufd_fops_release+0x385=
/0x430, CPU#1: repro/724
>
> Found by szykaller.
>
> Fixes: e93d5945ed5b ("iommufd: Change the selftest to use iommupt instead=
 of xarray")
> Reported-by: "Lai, Yi" <yi1.lai@linux.intel.com>
> Closes: https://lore.kernel.org/r/aTJGMaqwQK0ASj0G@ly-workstation
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
