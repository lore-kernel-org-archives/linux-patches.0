Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4394813E409
	for <patches@lists.linux.dev>; Tue, 18 Jun 2024 17:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718731665; cv=none; b=XdEmWLGCdPHs66D6iwKTD2Y6NLcQGOJML/3LFerTJnE1jUNRABtQFad8oTSq2VVJmr2tUzHOt3WlcItwYKDo8WXsm/AtACmNJSEHPewxK5IASYFyjjQlAkcVxujSbxRpcpOgvmHSEOR66wlj2q1wgBynDHQi4b+3q6Hdr9i6N8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718731665; c=relaxed/simple;
	bh=UcBlVIfyhzyatIBzaGtoXKCPX2Zgj5bWJa/znlgXM9c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=Wid/qnxkPQbDvlAsX1ceqBz3f9G2reclyY3YSWuQ0TGrE8vtLxIikvIRNiLUpBglFUSEERHXZ5hxsEV8JXZzVtBH5yJ1jPw+S8OISc0SsVTGFxdTec2bok0bm4M3cYyrrXqA7LR41jk2sLjs/C8wTE0cIa40kXLBOOPjB2QCWZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WodHzQt1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WodHzQt1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718731663;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KY4cYpr7OGAgBF1z5TUy3J3eXP0t4BCyHmgbv9I9nQk=;
	b=WodHzQt1h1cD+3z3/7m+1HmKjbVYsUFyOcx6CdOy+04rtJcwmd85pzsbVAJxmxoul/7sSv
	EdfDzUcMjthwO2F8/YZfWocJo5u1KBBkzFVojbIv+8XJQoBV4b20wM6ESBfpt9Xqq6Uc6j
	DN8ZqzNyKx1tVyFpcZ2TdQvgVNzn7hw=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-674-5JY1WBVCOe2GWtn5Q1oFGw-1; Tue, 18 Jun 2024 13:27:41 -0400
X-MC-Unique: 5JY1WBVCOe2GWtn5Q1oFGw-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-79557d418e0so6352185a.1
        for <patches@lists.linux.dev>; Tue, 18 Jun 2024 10:27:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718731661; x=1719336461;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KY4cYpr7OGAgBF1z5TUy3J3eXP0t4BCyHmgbv9I9nQk=;
        b=cNBoklTTHBRUVmrIKOuk6GBYB6VIbN4P6cTQ953hSab/iDpVKPnHTPOsLU2Nu5efym
         ZwPEQtGz6PYwt0N/bSngkKIi7drmujSMXLOTUxErE51DLBQmT/V1HlTJQypRkZo68aXD
         /Q1BdWG6zAFI3dEZfJt7s8t6eSTNTU9W6DzsS+tfHNzQUC//luHdQty+8VtSlWTsyWpo
         fjiWC96M1ZZsfFY1wp2Md0WskyP224QqpcoYOuqjUIVxr9l/m4WY5l3rOQKTFA8eEJrP
         9IaO3nTRQYQEllEZzIUPpoj/puRA2vABM0Aaue838RDp0aXke2YOcgrC7i4HG9M5nESj
         e3bw==
X-Forwarded-Encrypted: i=1; AJvYcCVJsXI1uU7gckP6t2FD7a1wJiQM+u8/tW0b/vBmlDtEh7+/Ff9DyVQsIxzdjHa2e85TKsEUulNwha/7BZlbmp0AKoGnhq/uaw==
X-Gm-Message-State: AOJu0Yya/wdDxqL70IYu3+vr6Ws12sGygGAqy3G/jfQvPx/r5Km8xYek
	P/zVAkVqDh9avdQeV8EBl7p0yu/LYFBOXHWVS5zcxxMHzLgKnkoEjfVDwwmMRCmqofDnueKxUeA
	fHDt0+XOkHLKxFgEQwGmUIB5u280UTGsiDUTwJN4WIROG9pl9mss4gd0=
X-Received: by 2002:a05:620a:3903:b0:795:2391:bc36 with SMTP id af79cd13be357-79ba76e3bebmr526291085a.21.1718731660834;
        Tue, 18 Jun 2024 10:27:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEtXoSVoWCAsjsTzixnT8ic4JjoCi/m7ZDPk1Wd03/TCxy0NULHKDf3CrXQHrcYhg9e3OznWQ==
X-Received: by 2002:a05:620a:3903:b0:795:2391:bc36 with SMTP id af79cd13be357-79ba76e3bebmr526288985a.21.1718731660497;
        Tue, 18 Jun 2024 10:27:40 -0700 (PDT)
Received: from localhost (ip98-179-76-110.ph.ph.cox.net. [98.179.76.110])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-441f30f142esm57948651cf.83.2024.06.18.10.27.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jun 2024 10:27:40 -0700 (PDT)
Date: Tue, 18 Jun 2024 10:27:38 -0700
From: Jerry Snitselaar <jsnitsel@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>, 
	linux-arm-kernel@lists.infradead.org, Robin Murphy <robin.murphy@arm.com>, 
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>, 
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer <mdf@kernel.org>, 
	Michael Shavit <mshavit@google.com>, Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev, 
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v8 01/14] iommu/arm-smmu-v3: Convert to domain_alloc_sva()
Message-ID: <736p5z2eubxzg2ikeqbdbs563gouvzfwlxdxalga7cezjv4xqx@jygkrfs6g3ca>
References: <0-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
 <1-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <1-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 03, 2024 at 09:15:46PM GMT, Jason Gunthorpe wrote:
> This allows the driver the receive the mm and always a device during
> allocation. Later patches need this to properly setup the notifier when
> the domain is first allocated.
> 
> Remove ops->domain_alloc() as SVA was the only remaining purpose.
> 
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Reviewed-by: Michael Shavit <mshavit@google.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>

