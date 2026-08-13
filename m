Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE0A3BE16F
	for <patches@lists.linux.dev>; Thu, 13 Aug 2026 13:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786629201; cv=none; b=YnCN8+kf5ltEap+e2jvrRCB0X2yqMww3wdjzD+6yKDvfXsrjIMgIBSEeHohABhwhN3+gtIk71Zy4ZaagUJHQTgheCtC+DHT41SWLe1WpBdrGX/PZ2X0PRIFjhYbTuE3gAmJwXDeZQghZcRv0TI5VE6xE/8xS4crG1BUJHd2JXdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786629201; c=relaxed/simple;
	bh=8Zioy32OXdm4oPXxw5VQR4iPqo7Y0Tou8teJq3YeTJk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TY1hYEnMsL0Xh3RIJi3qTrtmq9axElJAaG8NucQrtMSvgnW383BK9fCAqyhwM3YCXFPnNwOG78cT1YYyZSODXvrJiBwUFtNN2QOTNUJI8CLbiJqWS6aX4lGKLogO6yUX1qze9DCy/OL5mz8Z5JaKxRmR4eCcbq5pL/XZzmTGJzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oQDOrD17; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oQDOrD17"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-495509b08ebso42665e9.1
        for <patches@lists.linux.dev>; Thu, 13 Aug 2026 06:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786629198; x=1787233998; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ogSpcSG1OWMwO8aqJpRjbVxMlNAfNW4F47lS0hCZOts=;
        b=oQDOrD17Un86E/Gn8u+obPNHm3fMxBhPXK95jmawEvj59y+4uJCwEE2uU3FRizvHmB
         YhzKmgJGw4yw/+cawAuvYpLwxUl3wqGxLlM/jAKMU42SNeAs/5gf8eRGu03LiT5ofX/u
         hpJIyLTbSag/oABMQBDSd+wbq/8wGbU7df7Jn0cJastBESHZiJkFO7YZMnLzsjYS7gzy
         pfPpg5b9oH1GxfyUXYQmV9gdyRkIYbUWOXRx7U46DFgRlNDNQtaMXXAZw1A/VQbo4Opt
         WLouULz45jNBeyRh1fpPYHxSW2AZBxp56lih5x9DmC8GitHfofzdTby+sLRgS3pGjDRK
         /+bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786629198; x=1787233998;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ogSpcSG1OWMwO8aqJpRjbVxMlNAfNW4F47lS0hCZOts=;
        b=TjCYiWmOhhED2tGVQb7XDwwWCHfrEOr/i1wwSZb02bXq1pu+HqszO2XH//f6unlXHd
         Gtv4H1YPHwXPKORKsBgIVYlrKW+JB6p0e7+mb1/Q9MNXUQRXDXZnNwa8Qh8V0VrKWDpU
         SXBgYRwoihH7ACR8tlYcZ1f7nkkzT7ekaZocdDZXjIzZB9sacq0/IbEpelQSP0R3Y5Lh
         Q8ltlfGRlWsXmf9QAn/B04N+q1In24v3ppeYR7fjTJOGiXtZE1Max5xb+Cbl5sm7ZBQM
         b50SpjKhgjfMEG6CpKRlkYX7pediCJKZUJDzFuIdD7NGHf0Jxvj8/e6UizFJ8yzzX/SH
         jZIg==
X-Forwarded-Encrypted: i=1; AHgh+RpV01dACFnA/cWw555WQH2tTNxMJYQ5PQXa4P8BlYhYPAXWkt6XZV0+AvhAf6smZxrRoWNPjObB@lists.linux.dev
X-Gm-Message-State: AOJu0YwOMSCp33gwelPd8qFmPpTpABh/sfyPBUXJeDl5Jl8rvUjP0POn
	H1UwFIoHYP/JYxf7kWKlZRNav97xkQzSKCrYkmYCm1mnd+Mb12l3ms+HKO6MQsxy5g==
X-Gm-Gg: AR+sD1182VkiQ1YqSbMTpqYUFuhUHvhUBhvhnvR1HQUv2wJ016/WNE3pEH+dWvNfbE2
	wVgA+0p1iwe0jq+TbpGNQjldTVo0bI0+EJgM8m8LvYk/Ejr9OIQFrEIGQpk+cgywPNv7Wgl8nk9
	QK2sG6pjOORTGQypiPP/bbHXWC+iPuXjOCykSWyS7h1VQu+hgNL/JkKemZ13bq1EWWbAb1PWRSu
	VCvOPMQ7haPqvBSDqjJRZDUh6bW7zM4UVA83Dl/9CFgguJr+ay3uiMn4BBsf2VFCjUzofke1XJd
	WroEcOg+eno2jDaf9FPtolmR46JZMPLSLSF0fXpPDuk5RIlr6zERLb1vLXKnfz7ucuqY6AsVorL
	7civaxad3haJ6c3FoqfcD+LJzj+nCPFr5IykEq4gv6rJOBfQHQQWned0CzsHCzR42uqpQj+DQ6V
	JmqClEacDXyGHyVoWPIG36+yoKminOam8LXkbS8kKfba1B22kFm3Kc+U5F2+0eTUwvK6EyHXG/A
	he2Up6NU+xJxx9v5Sn1AG1e+D85Pg==
X-Received: by 2002:a05:600c:17d6:b0:495:51b1:3b7c with SMTP id 5b1f17b1804b1-4998273aa2cmr847895e9.8.1786629197039;
        Thu, 13 Aug 2026 06:53:17 -0700 (PDT)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4815a5b6c2dsm5990307f8f.26.2026.08.13.06.53.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 06:53:16 -0700 (PDT)
Date: Thu, 13 Aug 2026 13:53:12 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, "Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>
Subject: Re: [PATCH v2 3/8] iommu/arm-smmu-v3: Optimize range invalidation
 for latency
Message-ID: <an3MSKEj7VhT4WkP@google.com>
References: <0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <3-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <akzm5BoV0rToJ7ij@google.com>
 <20260708001058.GA422027@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708001058.GA422027@nvidia.com>

On Tue, Jul 07, 2026 at 09:10:58PM -0300, Jason Gunthorpe wrote:
> On Tue, Jul 07, 2026 at 11:45:40AM +0000, Mostafa Saleh wrote:
> > > Calculate the smallest SCALE such that NUM can cover the range to minimize
> > > over-invalidation. Always use a RIL command if RIL is possible working
> > > around the spec limitations to form a valid one. If RIL is not possible
> > > then do full invalidation.
> > > 
> > 
> > That may be beneficial for servers, but I am not sure about other use
> > cases, we already know that the invalidated entries are unmapped
> > and not used. However, over invalidating might impact live DMA which
> > would be bad for workloads sensitive to translation latency (as
> > embedded cameras, displays for example). 
> 
> The isochronos stuff I've seen has a latency budget for translation
> lookups and has to be tolerant of an occasional full walk.
> 
> Prior to RIL you had a much bigger issue, the cap on the range ment
> you'd face a full invalidation from time to time if the domain is
> being used for DMA while something ischronous is ongoing. Compared to
> that a RIL over invalidation is not significant.
> 
> I have been talking to people about some formal isochronos support
> that could do several things to try to manage the latency of DMA, it
> would be reasonable to include some alternative RIL algorithm here if
> that happens someday, and it is an issue.
> 
> But otherwise, I think we should leave it. Over invalidation is
> consistent with how single works, and single has a long history in the
> field so I don't think RIL is any worse.

Sorry I lost track of this thread and I just saw v4.

In the mobile space, I haven't seen an SMMUv3 that does not support
RIL.

However, I have seen workloads that are really sensitive to translation
latency (display, camera...). And I'd be concerned about those
regressing.

There is a clear trade-off here as you mentioned with TLBI latency,
would it be make sense to make that behviour configurable from a
module param?

Also, looking at SMMUv2, it does not qualify single commands to
over invalidation (but it exposes and knob that is used by qcom
driver), so it is always accurate by default.

Thanks,
Mostafa

