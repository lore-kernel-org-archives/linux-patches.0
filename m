Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C0929CA
	for <patches@lists.linux.dev>; Tue, 14 Dec 2021 14:20:40 +0000 (UTC)
Received: by mail-qv1-f47.google.com with SMTP id bu11so17395087qvb.0
        for <patches@lists.linux.dev>; Tue, 14 Dec 2021 06:20:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rqhkmjsKvOcy1ry3udZwgQuODoYhJPDi5y7wwXLtKlc=;
        b=wkA0cClSDCeGnRhQI2+gokT7A4LP5TxeO9JX5qp64/w9PVDFiptMa5BZ5mkOauNLe3
         HE7sQqjDqAPgSJ9vCcDHBhXVDBbVAjUUkXXYKRmbV30KVrGLdtcl3DE6dWYvLqLwjjOL
         U+4btHib/T4Bh9Igu7yC0NH/hxRYhZhbOTlv8Eykn+djnS5QI+A1Wr12p56c8rSO+GCS
         k7h2mhDNwGywUa0l9nIrw7L25uwWXWvzYIwj9+1Qe8hvFuA2UW/hjtxniglWlwLJFifm
         yJljoOQT+GtgIWrirLUDPGK79TzR3McuayjZ7A0mHICoY6WrnBIBHbYOIUpkEvniZZc1
         R28w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rqhkmjsKvOcy1ry3udZwgQuODoYhJPDi5y7wwXLtKlc=;
        b=EuSoN7oHREXj8mf8ZX/v+SDwB/+As2Ge68EaoYzkx6LDkAUtqX9U3eY+qYH+RI7DvC
         4L5yoL9QpnRxgGpVGt1oI67JHqS3tU3b6p/OZwI1IAomDYynlgzcfZLeBcbS6w0LbxDr
         6gYNT5v7fwOOz5qnfLvwORquL9HgRCta/5VE8Qec53tyFACwzBS6Y6VnpErsL/WMn/3C
         49oISNElKCAmjXigQwsWHNdHPPcimfqvCBCvpcMNnk/vkMxGGVo2n/2K/vcZmBEEA0Ig
         al8UeJBo/f/G5kDYiavwPWlSnLCNsiLJsaYUpBSODkMwjc5tocHv3e80z0kWcwC/Uwci
         NhhQ==
X-Gm-Message-State: AOAM532SKqpG+nwMNpW9O21qUmwcb1sFnlWVj/aPyGeKLnpeD7uXzIBg
	8byHQLlv5kePRrJGFS0uKWnm3Q==
X-Google-Smtp-Source: ABdhPJwvPvEL/7mKBm54xAv5jc0ZF1d7RSra9YvKJ8vFemsxxDf0LTnorjhFll7BpkNz2rqkF+9DFw==
X-Received: by 2002:a05:6214:411e:: with SMTP id kc30mr5631096qvb.38.1639491639373;
        Tue, 14 Dec 2021 06:20:39 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1:e1e4])
        by smtp.gmail.com with ESMTPSA id w13sm7683623qko.20.2021.12.14.06.20.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 06:20:38 -0800 (PST)
Date: Tue, 14 Dec 2021 15:20:35 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>, Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>, patches@lists.linux.dev
Subject: Re: [PATCH v2 01/33] mm: add virt_to_folio() and folio_address()
Message-ID: <YbioM6V+j5+R2Dah@cmpxchg.org>
References: <20211201181510.18784-1-vbabka@suse.cz>
 <20211201181510.18784-2-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211201181510.18784-2-vbabka@suse.cz>

On Wed, Dec 01, 2021 at 07:14:38PM +0100, Vlastimil Babka wrote:
> These two wrappers around their respective struct page variants will be useful
> in the following patches.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Slight reviewer preference: introduce helpers when they're first used,
as it's a little easier to understand the application without having
to chase new folio_address() -> new slab_address() -> first user of
slab_address() through the patchset.
