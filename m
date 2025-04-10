Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A59284B2D
	for <patches@lists.linux.dev>; Thu, 10 Apr 2025 12:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744288683; cv=none; b=heQHscUr1ikWdUitNSqUrcnYzXm1b+wZcNdCnit9JAnl3wANtEiUiyK+H4uYoabYReKSTTrZSegf2dMIuU6K14wZZHHaRbRRD0Ncnkp9WF4Ykx6NQQVMOFTp3vUU8SuJHj2GxwWjvlvA+HAIgkAaN/WQ1e9GnJJ+Y6hz3mI4fDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744288683; c=relaxed/simple;
	bh=KDR1DTOJoPA5spgrGIsm6Y8dkDP/dvIskw+tyzOF4ss=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gXht4PTU0SCI7o9GRDe8WpQIP4DAys1Ers6ZCsPS4FRHsd4FPwvaHQK0nj12QcbK5QzCEkajX/vfyg7PZ0jKvVatvkXTHxTTxUBYC/CiPfSt6uR9t6pGnMS7+0k9DFYXGfq5c1dm33QWHjQK587NtzedIP+FWHatMHdXcpJIzuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YAuwd8Qb; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YAuwd8Qb"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-39126c3469fso284005f8f.3
        for <patches@lists.linux.dev>; Thu, 10 Apr 2025 05:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744288680; x=1744893480; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ueJ9D/uWYLPcpSQZDS2W9kWTYeSr9KuH7P7A0rcqzzk=;
        b=YAuwd8QbWkj0yNaNcB+UdKzD5ZIii/jiELUR/zR9ZPOWenS1BRnkqS0+D4/HPp0Fr+
         Ih+XYaZ8TctTfP81LKRPq6qkS/VFmovTPyKBVyst2k61dME6nLAcw6fXptno1lC7z4Kh
         L1YXFTUVgWkvh+KlTlHjH4PlrkuYipICTfSk6Gs7aquUqWJSS/XV/XMED55CpzXE+Bna
         bW/9nl5mufDFq0mIBwlnykXuLp8Byu8w3i+XIff/DB9C9RwOK9ZX0XFmQEabimdY2PA3
         UTie0rNnpJw5iKkCILjx8HHjGaRl8aP0sYbe/VLOz43YwoHCD8SyD4bu6JIhTDKRlwpP
         7y9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744288680; x=1744893480;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ueJ9D/uWYLPcpSQZDS2W9kWTYeSr9KuH7P7A0rcqzzk=;
        b=mLcfpvSH0Tm4FCSVX0aYOEMW5AJ3215dlcGRByceZ6Jktfrh7NebvouMeA7PDSC2xU
         onuKbZlsBhHTlwfiz0hMMcnYZwpIlAKpy1VIfz71366cFBY5aCWWHWzb8jnTRvdMg8kN
         7W08VVUWYTVeTz5RqzLa8/FWEbEr5SrCY0hqhQadQissOrQbxK9MbS2U1bIxQa2je5Pe
         Bme4orbzqcirqPNlyM91PuqOHPb17uhXYovVYuQYoXq7SD+bq56zdH96pbUl5CZWz/YH
         IxXZm/sQbDqZHNH+5g/4GUT13DYrNx0h4FbA45z1dmIh8GtVXHYP3jBPqW7Ab4QCysOx
         g9EQ==
X-Forwarded-Encrypted: i=1; AJvYcCW/6QoQgTl05W4Q3YFEIIv6E1lBf8lu9LcfnFagqLRmrm6DX7R7RHGbbx43GulqQHjEkwvgPBXX@lists.linux.dev
X-Gm-Message-State: AOJu0YxvyR7grLi8ftrnJAo2PxX5S6j1K0QNp3CgM+TJVOmc58NL2yVh
	5fGBcsYevce8hcbO2tDVStVC0XdEQ5RcR8NYV6lz82ozhltmPHSeXSd0amIzqSajqgA10GVM2uy
	dgEFaDXpEJw==
X-Google-Smtp-Source: AGHT+IEg7mcjbdCYRVempPQhQObfFqsfDUHviFlES7EqAPGFgS+OQ2JKD1mbbO6MAY8vl/nP0uVJ3b1LYVUaZg==
X-Received: from wrom6.prod.google.com ([2002:adf:f386:0:b0:391:831:4d82])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2282:b0:39c:30d8:3290 with SMTP id ffacd0b85a97d-39d8f276007mr2441096f8f.7.1744288680297;
 Thu, 10 Apr 2025 05:38:00 -0700 (PDT)
Date: Thu, 10 Apr 2025 12:37:58 +0000
In-Reply-To: <20250410090021.72296-4-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250410090021.72296-3-vbabka@suse.cz> <20250410090021.72296-4-vbabka@suse.cz>
X-Mailer: aerc 0.20.0
Message-ID: <D92YQCM785D0.OVHMVHQFWF2L@google.com>
Subject: Re: [PATCH 2/2] MAINTAINERS: add MM subsection for the page allocator
From: Brendan Jackman <jackmanb@google.com>
To: Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, 
	<patches@lists.linux.dev>, Suren Baghdasaryan <surenb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>
Content-Type: text/plain; charset="UTF-8"

On Thu Apr 10, 2025 at 9:00 AM UTC, Vlastimil Babka wrote:
> +MEMORY MANAGEMENT - PAGE ALLOCATOR
> +M:	Andrew Morton <akpm@linux-foundation.org>
> +R:	Vlastimil Babka <vbabka@suse.cz>
> +R:	Suren Baghdasaryan <surenb@google.com>
> +R:	Michal Hocko <mhocko@suse.com>
> +R:	Brendan Jackman <jackmanb@google.com>

Acked-by: Brendan Jackman <jackmanb@google.com>
