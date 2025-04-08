Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C0A320F
	for <patches@lists.linux.dev>; Tue,  8 Apr 2025 00:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744070587; cv=none; b=fDWvu883YCZ+SKyH6geK8/5LmEQrzk/SSlqod2P182YAd9z0ZGN70FW8VcccEmjnFQKMMSuB7hEbJhmIgjXUGjNhwuHqpgLzLpwsYQtI3M69PNXIUs4rbed+PkVuzT4ZBIWLLRrxSoyTxdj4wPmmZlmiEShpEEAEuSQ9Bcw/tho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744070587; c=relaxed/simple;
	bh=hsLgQYSvjOdzJXWdYqzBXca9hWM+lwBSlt/w5O3DlNM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ql7M/z87rKWlJhCmt3+1Iqi8suzmUqdkjO06sKd9hQy/csiAfdh95mZ3D928OWMoQgRLQj5p92gKqjg7U71XCVNQXJRcuVQ6b0bZv5DDcPmgLHfupfHmJ0LCDm7/gljTlmKDMlSFHf3fleQDEtk9ahOp1uWfLm0487lUNc9SWoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg-org.20230601.gappssmtp.com header.i=@cmpxchg-org.20230601.gappssmtp.com header.b=czYclTIJ; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg-org.20230601.gappssmtp.com header.i=@cmpxchg-org.20230601.gappssmtp.com header.b="czYclTIJ"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-6e8f7019422so44726576d6.1
        for <patches@lists.linux.dev>; Mon, 07 Apr 2025 17:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1744070583; x=1744675383; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kdYPNBOdCkdpUNjtde82AFcxfWzr1Kaf/k9vmv5kSGw=;
        b=czYclTIJ137eSF1vJeTt4yR14KubuV2O44ymytzRxvTx4+6T220yuvSwBHtJmibnRQ
         ZIZoDctWla3Bc2QxQ3wVbcnhrNqD6VYKNv+fpY4NC+K5grPYt3IH/lqVAiHsh34YpzRH
         UbfW/jd8ak+MWKuBhhWs8XXVkIoM5gfv3Z6/FTFHfN8n2hq51jpn2ykOItiuRBXZhofR
         SB1EYTXNHE/5IcgcDt7YxunDFHOTopToOfoq7FeuS6l87OvthWG9C8k78Tmck5BGuBcI
         liLcPAVJ6/Ta6/jcz3nnsFXXJbPiFODNtW65YrgoPlwOLcV/fZn6SnOWpSsnN+uexCym
         cL5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744070583; x=1744675383;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kdYPNBOdCkdpUNjtde82AFcxfWzr1Kaf/k9vmv5kSGw=;
        b=Hqg6abu5AE4WyGBAbfWFB3mhhD22dLOGk0s8hMeJRPVi6PHlJ13IN198zXaj6EAhiZ
         s+8fIpH3dRzYHthcvGMC0Mk4wvi/ub3JxUDrcfGcbE90WYkYsaTHrdKfrYB1FTWMLiYS
         p669VEdCafZdpdzVHMWD2mxJIHdMu1KcaPoS3lxjvXI4dbT/roAQgtMsZOIaHEvYnn4Q
         rqXA8RloYfJJZpUQa9Vf+wbU0WKtTqEoFb6oMcjllbi8yeU8HloFpR/A/kf+dSLRzFwt
         r/HVZm+gA16CubGSOJ4hr4VaKO/KQ2MRAxG2rF0pVZqjBsdUlZpVByFpCw85lfKNJ7EB
         Ki6Q==
X-Forwarded-Encrypted: i=1; AJvYcCWsw5Xf0FoeQ0fEC5/NNZVMBtIG5pG0u/cMYdQfk3u9Tk62LrFcQI9mxtGNVizshJj7tu/FfNaj@lists.linux.dev
X-Gm-Message-State: AOJu0YwsuKCbTMcxCJQrzh1lEzCYXNExRjhEpZff9CtJAyWiZzsXVKSd
	U3+3lkd0SJvteIa/4woDv/Sc58IpiUWnvb4FFNjxz0Ubh8S18DHvjiGVL9yCYeE=
X-Gm-Gg: ASbGncsbjm6CvJCYW5VXMC0O+NP8VuVccwORA7iexnzLPMYdYs6GZY/kQoNqD0vAZxw
	n+UxdKx55d+bzeRN6KjIiY1vcJ6WqPt4TYpdlIaugIzmYs8rV9LgeHHJOI5dz9FppN6fH1LjuDO
	H4ujtR2SA960pU95fBggXfKQHEzpYuPl3JbF118LXfLbqIquhpfsncxb2IgNuH+cpCaZSbP+WUk
	GWUZKA/dyYXksV8fM7m++Gu//pJhBxk9LvjwiusGmZ+kXP2Y02O2bGBAuQTrxO28ShSGhqYkhVZ
	nrSrgkQ5NuL0D4oFRn9PIeMUyu7oOZst3189ESSJsos=
X-Google-Smtp-Source: AGHT+IHKTKgC/tTQpHZWwfrSdql45T85g+gHDDSpqTa0Jcy9A7+YTBLmLSmvDIZT9rURXS8hn2xDaQ==
X-Received: by 2002:a05:6214:cae:b0:6e8:fde9:5d07 with SMTP id 6a1803df08f44-6f01e7724fdmr164498126d6.26.1744070583416;
        Mon, 07 Apr 2025 17:03:03 -0700 (PDT)
Received: from localhost ([2603:7000:c01:2716:365a:60ff:fe62:ff29])
        by smtp.gmail.com with UTF8SMTPSA id 6a1803df08f44-6ef0f164d49sm65390186d6.122.2025.04.07.17.03.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Apr 2025 17:03:02 -0700 (PDT)
Date: Mon, 7 Apr 2025 20:03:01 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Mel Gorman <mgorman@techsingularity.net>,
	Suren Baghdasaryan <surenb@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@kernel.org>
Subject: Re: [RFC PATCH 2/2] MAINTAINERS: add MM subsection for the page
 allocator
Message-ID: <20250408000301.GA4545@cmpxchg.org>
References: <20250407200508.121357-3-vbabka@suse.cz>
 <20250407200508.121357-4-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250407200508.121357-4-vbabka@suse.cz>

On Mon, Apr 07, 2025 at 10:05:10PM +0200, Vlastimil Babka wrote:
> Add a subsection for the page allocator, including compaction as it's
> crucial for high-order allocations and works together with the
> anti-fragmentation features. Volunteer myself as a reviewer.
> 
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> Cc: Mel Gorman <mgorman@techsingularity.net>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Brendan Jackman <jackmanb@google.com>
> Cc: Michal Hocko <mhocko@kernel.org>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Thanks, I would love to help review allocator patches. Could you
please add me as well in the next version?

R:	Johannes Weiner <hannes@cmpxchg.org>	
