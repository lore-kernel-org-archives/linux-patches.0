Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD58309F1D
	for <patches@lists.linux.dev>; Thu, 28 May 2026 22:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780005762; cv=none; b=iNjkA8/bS+shLPgIuggZyTbz3nsJUkNJ3t/IADLV6Td6fBlrZli4OYlbr0vUhRl99gNE1+yV7iHG6JQfQkF4L3QaQOgNQM7U3gQZiKQXhD84L1p9j8/yjJsg8HwqxDo/bCezHwgaWS2W65h+wMoGQje9EKw2hEdXyz47i1OdpQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780005762; c=relaxed/simple;
	bh=LdY5w1w9JKQhpaZBSyVUr8rGqdk+R+saAIJWzDuNvjo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nouWKNlPWuy2may6qHjCqO3xsj6AyiLeBuy5/pF8yMoY5dj+ozYBeHnPiFDxBGgBo48NnzOiou533faw3rUPYFPg3flWViVU8kVLEFKXzgyfd0+tFROrxUXRtMzHeqbe2IlRDZ+lXt19pP3xAqvzfOfhcPuQGKzKm8Pluh75Z5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i7mxkX9V; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i7mxkX9V"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-c796163fac5so10120065a12.1
        for <patches@lists.linux.dev>; Thu, 28 May 2026 15:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780005759; x=1780610559; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=a7lu1PeNcCkgTIxgc3W2FpjZdWenBKdIMuLJ/NcoWBc=;
        b=i7mxkX9VF8vMnCY4eB+7c7uUuRN5vrESW4YZCyr9C+BNxlKVFCIi3sA63ANfAsemT3
         YcwsMuZ2IxDsV3D9NBOHgDwOJdOnQD17IMVmu/wRcQoViDzWe36n7d+uFP5cpagotLrv
         qnsHpXEm04VlOJ2/+BsNs+o7b07mFqaCCFvledTHxqouu2Jali7MzxonGCTNWXoBqWJF
         +Hxe6XGIfkFxKAa1BoXYrgYzJX/p7ursHgqABlbwrenqj1JlJnfPVuG60yvnlxbrwUWI
         +4usbNIsRMNK5KHIcKabAjrW8KwvOPZmFLlX0PSGBq/U70OqM1YaNnFbZYEqZxWlqpkA
         ggMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780005759; x=1780610559;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a7lu1PeNcCkgTIxgc3W2FpjZdWenBKdIMuLJ/NcoWBc=;
        b=CObOXb0m1zwnlOa950htUjfsYE9Y2Gv+6FGYeSCwQcoK48MfBClQC926lg8m85+Lqf
         +yBH2e6xxDng41iGbq4lcfUX4H2uX7FxUMWH1Y9lowNbscYb2a2UT+QdGP1mnMHo6EzA
         7GPxS4Hy278+WEE/meHMWj70uzx8FPMjKR6Cx4uZ1x0tjLYFieudPM1KP7vTCatZXh28
         pPrGSwksuMqQjg9SAHWpN2w1Pfk5t8/r2jq2acjQktv3AGwxu6pzWWetp+2QMuooeR5f
         S6iBr9pZU3MKGdg/BBkl9orMDYR/5qwz07CNw6FNRtO7e2spaQQP9AWdUiT0VC9RFuM1
         6CHQ==
X-Forwarded-Encrypted: i=1; AFNElJ+77c4o4l1ZpWrj5/azyFDu3kdJdRZcdm0gNPn99+zWd9XesoKm0rYV2HEMMiL8co55NQSToi/+@lists.linux.dev
X-Gm-Message-State: AOJu0Yy6sOjq0qIoNSvuLhZg7P0DH71QApmJ2s71DcrGdikTqkJU94Uf
	793ulTHJgKkMmLXOGS6utuAJkE7kXeiLINH7OeQ2ZdcgN9bikeQIJRSNQaOKl3aW1g==
X-Gm-Gg: Acq92OFQ1ybHhSXGZkAz7uCD/Uhu7YNQe6TtEPWPSOWMEnWJyu5wkAbW+YzNY2WVECd
	detKTl82ISJrIyev3FcCZNqbUGFOrXMcBgd+IaHU5D5Kqo0bFHwqAKTLJAJplesuCRoadZYTaqV
	oj/TXw7ewvWi7XcskmQ4gvg/0w3kZU2CVtbnmXu9Z3sBuxDbqJM7wI8Dqoq/jCZOCqf5wcZM+GB
	mE2ul0XeBdq9NrQywfH1HQO7++/XUlwJ1AEqkue0r+/qoufBAGYfw2Qtv1c0pQAXM2tbJ3Nfu3k
	YNLUFWr/s/EpKjiePjIaz5MLPMb30wq8czr/rdm5q1KNl3iitNPcXwTDkL21oEqsHXDC+9fF+mP
	VZTO718Z+mK9cXbq+6rpq4nwMGWE5rf8tHqY4UlARYNd/PiaYWvrmgwJFNoY2YJJnDqK2UsHYbN
	gh14V6j5Q7IkoAZ63LJ4oFrbOVBB6vmfic95yMDcmJEitGtqMakShK1Sj6wrm9MvwRtRfN0KWR
X-Received: by 2002:a05:6a21:648f:b0:39b:9644:6e94 with SMTP id adf61e73a8af0-3b40e32b279mr628896637.9.1780005758951;
        Thu, 28 May 2026 15:02:38 -0700 (PDT)
Received: from google.com (56.149.168.34.bc.googleusercontent.com. [34.168.149.56])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c85759af1f5sm31047a12.11.2026.05.28.15.02.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2026 15:02:38 -0700 (PDT)
Date: Thu, 28 May 2026 22:02:35 +0000
From: David Matlack <dmatlack@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>, linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
	netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
	Shuah Khan <shuah@kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
	patches@lists.linux.dev
Subject: Re: [PATCH v2 08/11] vfio: selftests: Add dev_dbg
Message-ID: <ahi7e1MEoHwk-rtF@google.com>
References: <0-v2-72e9640932fd+2c64-mlx5st_jgg@nvidia.com>
 <8-v2-72e9640932fd+2c64-mlx5st_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8-v2-72e9640932fd+2c64-mlx5st_jgg@nvidia.com>

On 2026-05-15 02:30 PM, Jason Gunthorpe wrote:
> Enable it with a #define DEBUG at the top of the file. Allows leaving
> behind debugging prints that are useful in case future changes are
> required.
> 
> Assisted-by: Claude:claude-opus-4.6
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: David Matlack <dmatlack@google.com>
