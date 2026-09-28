Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE83D4E3223
	for <patches@lists.linux.dev>; Mon, 28 Sep 2026 14:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790607427; cv=none; b=ZLGNlPmEStVeT84HZunL3bHWSuJ1f1Z8Yx+rmk8cuftTjf7PARFCGezKm5IdOnMvegoTeVsZKL8llYiF220yT/RMwnAPPPSPZijmffC8y3d/EZcZwtFYtEUN9DyejAHJo6n5SrBunSgLO8nZmiTo0yaEtok6VDsLFOro5b6lJwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790607427; c=relaxed/simple;
	bh=hnhQkpKoMw2Zhfw9DM4few3dVnMySo2yIHKJrwxV20g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ihXPmX+vU5k4rxVVtKBK0Hf54eBsr7lc3E84qw3nys+fw2mJnPLj4R4vT32raJS6mCud4+3f8alUxi1NN0DaC/8haJGSWBHv39Acv80FHKEDN/qBvoDPpJt7noe/HACJDIwPyo9QHS7LULAPDWtdPna5BD3bsuI4/B9aSIxvo3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ctG+Y3WS; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ctG+Y3WS"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2d3b445a84fso82095ad.1
        for <patches@lists.linux.dev>; Mon, 28 Sep 2026 07:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790607425; x=1791212225; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Go9hn601ofYGhTbmTXvodFkeQSZutx3QY5olFYU9dfU=;
        b=ctG+Y3WSq7wPpkwHVlmydJSouSru19Ur3NfkABhz8Ru+f/GyrXX4qYJ+kUgBJRQTBu
         4mw+a+FxkMjFVmHWFjpJCpPBLDeg4RNpMCR3v6nTlyyMQovDiAJBNWZWgQu6oi9as1nX
         yn8HIfXOKeC3m/FYO6GUdEWY1tT5iVNiF8XY4WlZTqrDMhBNV5lwY6KJevhpo+wPDY1x
         +0FQRmrIFHvnh6bXSWCFzBnsnVWS630FjMhnUMLJnXGMDUyvXQIvc1Sux+4bLAGNFJ0Y
         /QHCWPhnyJYZ0D2Kds1hFO2musaQRnyBZTS2rLkORXE7dl5YX+iWNxAxwbdCX81CR8MC
         toWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790607425; x=1791212225;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Go9hn601ofYGhTbmTXvodFkeQSZutx3QY5olFYU9dfU=;
        b=qmBkrsyiMwfAVsAUObsYQjZuRbh1+zXSR8B5qS6z+Y8TqIef4YefmkYIEyJe5FM8jL
         st1hCbZbZCXQliVqi062PIJzDH2DuAsK80Ig1VAOhkBpCz47IPeUVpNtlHGwrXrpuM2D
         ee5zXKDGHpXugEUoqSNU7f7SBCuidxbq7U6ZJv9qkMFcswefTGqF9RIYEwtEF8xYFexu
         LRj4hnQn/4x/uf2VlFVt/qaLpx0PNs2fqqaoJLUFOiFdkFGlAzJW7HqXHT0/mQlPIF6x
         Z0idWdafFB+rFp0KBd7AjvJX/hq+a09hozaw3wO2MGqoL9k0j6cGeUnycUc5no9BYmpa
         dfqg==
X-Forwarded-Encrypted: i=1; AKwUvBw7hMzh9BJFiUz02GxYS7X9npS8xDTpRpKQB30oJ+p++jD/JF2y8DSuUr2U0v4QYAbP8RIzSxOQ@lists.linux.dev
X-Gm-Message-State: AFq9FYLy3NL/+0uS0NgTxRpcx4VYNeeHaNOhjlgnU0GDTuCBQAlDztOz
	q+3tgCSFqniII07cWrU+gMYqRtDgSLJUi5gQHvT9uonPp5JqpNkxUW4oWnwRLciZjw==
X-Gm-Gg: AYBFou0Ew6vT94+aXQ2ze7clTF9p1UkP2/6fqMf9cULtpgLJY3LaCg59vDW5VbaQY7t
	Q5nZa5mFFtMTHX5hHYAcfiwB+dN4GoZVEkH4WlvY0nEK1EU3V2prTQ6mbbLkvKodxkAPcBDtlGJ
	r0YWI5mnH3cjhI2DhiUz+pAyxcuZ4Jh2jBTD/uY1dVZARcM+/AiPRQjIv08d/JRdf4UWikdnnFF
	19AbXLR6GcEkd1vNipEqmmuT+v+741mmYPVqMjRHAmU+t3b10XqN2bHFVoSIZTNqe6x8iV51qyz
	VyOdMsar+BlkKobhewuQlpj9noERyzWbU5rbqtWEkD0STNyjlgJXfQmLQP8JHdQEvRN8h2QMpkw
	27gTMBqigwEcbg5oH5FiuJx+8e8+tHdZJs+V6pc1pyuHfl80JmkoNZ+XfiFjNbHn1JuhifTOUrw
	Pk+n1uR5p+tYK6kRvVJLNTNHAHdVgrFoCHrS+9BnYiYIszoyTt3kYDNXxV+Zvp2HlHoOLpWWb/J
	wsJ/O9gRZqoUbYF//BFZsMr34csboAH8onm
X-Received: by 2002:a17:902:d4d2:b0:2df:42af:2f9f with SMTP id d9443c01a7336-2dfa968ef1cmr5442355ad.1.1790607424172;
        Mon, 28 Sep 2026 07:57:04 -0700 (PDT)
Received: from google.com (105.211.142.34.bc.googleusercontent.com. [34.142.211.105])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b9feddd0sm7198628a91.2.2026.09.28.07.56.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 07:57:03 -0700 (PDT)
Date: Mon, 28 Sep 2026 14:56:54 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	Mark Rutland <mark.rutland@arm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Will Deacon <will@kernel.org>, David Matlack <dmatlack@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>, stable@vger.kernel.org,
	Vijayanand Jitta <vijayanand.jitta@oss.qualcomm.com>
Subject: Re: [PATCH v7 5/9] iommu/arm-smmu-v3: Keep track in arm_smmu_invs if
 range invalidation is used
Message-ID: <arqANvAwIz6GSXJp@google.com>
References: <0-v7-e84261bbe7cd+2ea80b-smmu_tlbi_jgg@nvidia.com>
 <5-v7-e84261bbe7cd+2ea80b-smmu_tlbi_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5-v7-e84261bbe7cd+2ea80b-smmu_tlbi_jgg@nvidia.com>

On Mon, Sep 21, 2026 at 08:55:13PM -0300, Jason Gunthorpe wrote:
> Summarize if any of the inv entries will use range invalidation and if any
> need ARM_SMMU_OPT_FULL_CONT_RANGE_INV. The next patch will use this to
> avoid range invalidation pre-calculations unless the range commands will
> be used.
> 
> Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
> Reviewed-by: Mostafa Saleh <smostafa@google.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan
