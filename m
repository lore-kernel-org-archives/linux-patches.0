Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC595822E
	for <patches@lists.linux.dev>; Mon, 19 Feb 2024 22:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708382867; cv=none; b=JNgO5KbbIsdylE/8vPxioMaTlqHLS44gONl/YuHvWGLnNwBg3pJgFJfENUX5xdZAo74f1mWts7PYyHLoLLUY7g2uFjIU9vsMMMx4FZEpkp6BA5+oUMXjFo7Gidrcp+sSNVhPu/T3JCkjwPswxaKxHgElUYhUxXUcslOD31UrtaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708382867; c=relaxed/simple;
	bh=Q/ImW+zsHYEsCPvW4yGDRGpbx1UzM5/ZYfm5kjMZ0DQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VpbTlK8c0XCJjR92cI556WRNGzMHWhcmSyg23O/6PGIYVVIh9xeUegiPG4egPA9X12P2vJHrhGCQJWXyI/qos76sCK0eXwmDXeJfZoalFR+vAwLh6f/aUGDfztVxYqFnkFYh3YLtn1jNCHx9nwEQRc1qkiZgOzTdrtnX6/nEgOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3khTO0SA; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3khTO0SA"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-563dd5bd382so20540a12.1
        for <patches@lists.linux.dev>; Mon, 19 Feb 2024 14:47:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708382864; x=1708987664; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MfAKRwR9Hei9hFvoDzDETlxDaiDBjg2fLW/ybtnAeqQ=;
        b=3khTO0SAjg74OVkt7n+G51JH1jWu+5V+K3iLLtbAzM80GLqlKBWCFuD7zgnmsnQ/FL
         dOJjOdZhU6jOCxWiHijJUzqGh0ijDTLAt+DBgIpIMugV2x83hZ1clIGTvx8jJg+RdTgR
         E1bm9s3+Vlhc4W5PF5L/99YpGo5Quk+DrMtWsbyXID1goGyZldrKlGE6c4/2IPS7dnUF
         xeWq5w3wSDaYiRq9JTlkz5vpa/x4gd6uBQvr/IgsoKBaLBTypNVVeNnkQ614dIV5RFgQ
         6uQyeioZSUaLRbdyLMgWAQfnMvN9pzRewot/LyCugG+6huyRT+p8wqsAoknA7jWlgrOI
         5D4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708382864; x=1708987664;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MfAKRwR9Hei9hFvoDzDETlxDaiDBjg2fLW/ybtnAeqQ=;
        b=Z8okrl8GQKKxIvEtnzLq+K/BWskuXwlmrnE1IrFVyNeWwFNp9rlL4TZuK2MvxgcbAt
         vbl+uT0R6cNgmNG8VAsmOTceQHrHFhsnRE1717n1/Ne+Mkc+oPns3Q0l9SXDn0f2Nmjp
         lcVKU2kilvZWfkWXSNtnVr33oTq7W7+N+lBUhYP5U1f0+rUXb+31zH6DrQKK5Jm566F+
         laHV69OXXAjv36+zuygbRZw4zcMYe0CFraxd0Q8Uqy4RAFXuXoO0QylGhHcXCtb7C8db
         ArL872mq7QZmkkP3a/Fsah1j6NCgJhUhiVb/1nQay9QOu0yd2yxPcn3V6G7nclBtjdku
         Y2Lw==
X-Forwarded-Encrypted: i=1; AJvYcCW858MFgb1kGxKyL58+fOr+5HCwzYaHgq4AGJF5ker+3Q+NOabVFURW3p7gozTtjPc1mr6dJ2sFXtDfoVYsAqwm7jBvAUXubQ==
X-Gm-Message-State: AOJu0YwhTfgFow7ajpRSjVX08Z4x2GXyMMH4G4rF8KYI2K0BeNwyf1Jr
	1Mt3EZpw5cvjflcwVp7keifiBDhILnvHaFp7pskp7JEVCnB7utyscyw3M/68cH5wOrhybRo2ghT
	u5O+WZ8e0zGg2EcS/v/hhP+OD1/3+2ZVOFayC
X-Google-Smtp-Source: AGHT+IHwISqHlrXK2gTUotGn9+5d5YVg/CQsmVlR6ZlMRwiQyinWPPQAX3eKIo2lkqOwZ7GJ9qx5dfVYbY57uMxziyI=
X-Received: by 2002:a50:d696:0:b0:560:e82e:2cc4 with SMTP id
 r22-20020a50d696000000b00560e82e2cc4mr304769edi.3.1708382864300; Mon, 19 Feb
 2024 14:47:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com> <20-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <20-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
From: Daniel Mentz <danielmentz@google.com>
Date: Mon, 19 Feb 2024 14:47:31 -0800
Message-ID: <CAE2F3rBip7oe4ip-kK5GR6+nY_efsVrrxcxv=4m4_aWGKOg=gw@mail.gmail.com>
Subject: Re: [PATCH v4 20/27] iommu: Add ops->domain_alloc_sva()
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>, 
	linux-arm-kernel@lists.infradead.org, Robin Murphy <robin.murphy@arm.com>, 
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>, 
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer <mdf@kernel.org>, 
	Michael Shavit <mshavit@google.com>, Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev, 
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 26, 2024 at 10:15=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> w=
rote:
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> @@ -654,7 +654,7 @@ static int arm_smmu_sva_set_dev_pasid(struct iommu_do=
main *domain,
>
>  static void arm_smmu_sva_domain_free(struct iommu_domain *domain)
>  {
> -       kfree(domain);
> +       kfree(to_smmu_domain(domain));
>  }

I'm wondering if this particular change belongs into the other change
with title "iommu/arm-smmu-v3: Make SVA allocate a normal
arm_smmu_domain"
