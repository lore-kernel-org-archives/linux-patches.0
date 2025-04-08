Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA52823FC68
	for <patches@lists.linux.dev>; Tue,  8 Apr 2025 18:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744138335; cv=none; b=LHUQFqmNRnHrSF0R2FruenVuR9VDkwVi0JOTttb8DuNBtYflbooRc9OvSij5MpdJRjhZIyOxMVUziz9sbTbhsVJ82aVqYziH80bECSEFAg0d0yzsFqT8BwAspxmGVNJE45hDg3Qd9O2fgxoSiOWhrt6Om4xhY7zRfhpz/tU+LrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744138335; c=relaxed/simple;
	bh=HYSy2sOftqwQaNzUt/b9IHcr6YH6cULAdGjWOLniPyo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eHG0GQ9RNYbTBFrC6PF8lkQBx4k6fxhWPIh95kJAgSn/3c8mS8IG5sbatqKfL2jlv1EfhLyrIxdKn6NdFuvHdVzmIPxDbvMnSYJa2NFuCQQKj4Fpzt3/T3RzgIzz3wl44GPt+f+04iGjMwSa/Qs2E8VMmd9c/ruRLJZICvfCMSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KICENr2N; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KICENr2N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744138332;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Ee/bs0ku9KaZvAw/oGKbLdjqQXwZcnmqDGoEebH2XrM=;
	b=KICENr2NG9c5esvFya4QSel9jq6L/HlW052Y48aS+6K1GYLb32CwDd1gr6ePGI7yqCQ/uH
	rXyS341oNVQANwWgSmarnD9IsHqWyUp+rsWVoR0Zj8skk/8fB7tml4Pzp3fnUcbKp5ZJPI
	WH0rRyvs9D+XyuJ6y7vy2301FW4dPvo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-665-l18M2cIVNnqLyV5Eg1u-pQ-1; Tue, 08 Apr 2025 14:52:11 -0400
X-MC-Unique: l18M2cIVNnqLyV5Eg1u-pQ-1
X-Mimecast-MFC-AGG-ID: l18M2cIVNnqLyV5Eg1u-pQ_1744138330
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43ceb011ea5so39970585e9.2
        for <patches@lists.linux.dev>; Tue, 08 Apr 2025 11:52:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744138330; x=1744743130;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Ee/bs0ku9KaZvAw/oGKbLdjqQXwZcnmqDGoEebH2XrM=;
        b=eWxEltN3oNjNv9GXGvyB8OEAyCV5QOSe2TuJxWUOUnBeZmucEgez+eqUTJOEKchAQ6
         HoUFb8x6TDUjk3KfHmyu5laB6nxmpzM1fvIcBWiZdS1WzEE5mnEJiZtclV6BWqcDWrjY
         xenMpb6g6eYBbUVk2uuPtjaAfZPyWZ+BIZVFZ+Dm6iuGJ4TdnuPIGxOmuEyiV1KryDqY
         B/UCiTnA60p9vTLPQOLFRHAJKWHdBKZpGB7n6WeqpdD6RXpg6br1C4FyoPwRDycGWuUv
         kLh5lXQ5AMO4gGAJf3v0oRn/V0X990y8jM0xzocwkJA7geB8X8R2myeyL+HXXKj7o7zR
         ZWrQ==
X-Forwarded-Encrypted: i=1; AJvYcCV1QRiGYWyUh5d1nFlNrQLOKe5VvfsfKUGtaxp/dsAcoc+aIqMpRcs4mTIMVtlgdHDeFbVjONoa@lists.linux.dev
X-Gm-Message-State: AOJu0Yz+94htOsW7kR6NfkBh3GgNMTN47aqayCm26G58ARIrWve+/HFB
	oaJU33+OFKBMHaa/DDz4274EMkeCNhcHKJ/XXahygLPQ6E0PgFaSE8ZWAteMGPah+JwAHdxnAVF
	l9UTghVUCiUljI4+WJunfRbKwppTJ+SdBeVp3qi++hYtAqd+L+j3hx0I=
X-Gm-Gg: ASbGncthyq4uobk1o3RNKqWnzFd3CJEDmPbGB8AgZt3EmOk74futJhe8PeVkgWHgQNI
	VDUibIQazCIFxp/plQ9EvTspt5HgIphnyiwTx2TJNDtSMHFowACOjd+ZfHMfbLLy7+BDevBDZDB
	hTenZXMvSsEDpilzjLptZVmB36/f70VDNWswrxhRvSbP63iUbES9WqGeNW61Brx3ejGd8cVjBj6
	c2fYvDrTKHZEOYScgcK1h0tdalkJV2mPvXTwk6wLsm8lXRRTr690LOEeFCmEIqXe3iu/BrlHXUw
	+5Hv5Vi9rqzB44GjOuIHDZTmS+k3lwv9UQLOVhOhzXMUDrcv0qsAANA5HCy+UKs7mhd37Zf83jn
	7rCjmCTpBH32XKU0yoD+TYZM1hBG9r33dwrXW90L+
X-Received: by 2002:a05:6000:40d9:b0:39c:2692:4259 with SMTP id ffacd0b85a97d-39d87ab73d9mr248325f8f.21.1744138330434;
        Tue, 08 Apr 2025 11:52:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFQu6URvqOmqxm7oexseppX19HTRwqP+yE6xHJa8LtzuQvNdxB/B/3NcY2E5AvoUVsKbbhlJA==
X-Received: by 2002:a05:6000:40d9:b0:39c:2692:4259 with SMTP id ffacd0b85a97d-39d87ab73d9mr248305f8f.21.1744138330078;
        Tue, 08 Apr 2025 11:52:10 -0700 (PDT)
Received: from ?IPV6:2003:cb:c707:4f00:a44a:5ad6:765a:635? (p200300cbc7074f00a44a5ad6765a0635.dip0.t-ipconnect.de. [2003:cb:c707:4f00:a44a:5ad6:765a:635])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c301acec9sm15544784f8f.40.2025.04.08.11.52.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Apr 2025 11:52:09 -0700 (PDT)
Message-ID: <71f4bcea-0dcd-4f93-8ced-17b333398460@redhat.com>
Date: Tue, 8 Apr 2025 20:52:08 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/2] MAINTAINERS: add MM subsection for the page
 allocator
To: Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev, Zi Yan <ziy@nvidia.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
 Mel Gorman <mgorman@techsingularity.net>,
 Suren Baghdasaryan <surenb@google.com>, Brendan Jackman
 <jackmanb@google.com>, Michal Hocko <mhocko@kernel.org>
References: <20250407200508.121357-3-vbabka@suse.cz>
 <20250407200508.121357-4-vbabka@suse.cz>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250407200508.121357-4-vbabka@suse.cz>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6eVI8k10YQQYgHP_r3LMFCQPP-ZRqJ6PQ69BvysRxVg_1744138330
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 07.04.25 22:05, Vlastimil Babka wrote:
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
> ---
> Extra reviewers would be welcome, including/not limited the people I
> Cc'd based on my recollection and get_maintainers --git
> Also if I missed any related file please lmk. Thanks.

Likely we have sufficient R: at this point (good!); as there is a bunch 
of stuff in page_alloc.c, I'll likely do my usual linux-mm scan + 
keyword notification to spot changes in there that I can review with 
confidence.

-- 
Cheers,

David / dhildenb

