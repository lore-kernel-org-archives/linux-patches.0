Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79471361
	for <patches@lists.linux.dev>; Tue, 13 Jun 2023 23:15:29 +0000 (UTC)
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1b1b51ec3e9so72665ad.0
        for <patches@lists.linux.dev>; Tue, 13 Jun 2023 16:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686698129; x=1689290129;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8uyQg9FJf1ujfXr9f268eDNpOT0Va/5nApJsu9c/ceI=;
        b=ZU1TKS+Chn34vLFJwibDHRoEMvmMiSzpf0ZDVkri5ROYoqs8V2zaY2gNqlFnh3FM9W
         DAfgIDaZfN+2aLQtYCYtmoYPiN7JOh7oTfXWyO/zsl4jhbkkwuJgb7gGO9atdO9mcjGz
         xeycv9Kjlo2A2wW73U+OW03nshU6dNBbPmU1NS9CvyIgiPMHPEkbB3U9BtZlVx5oqvMj
         6fLUMYeML4SdpsgO8ChyciHmoZnlyyxqL8fsGl8FExrKWpb+z83m0JOw3AxJdvkM//Yd
         UgEAXqhcEFtsBq5fHl5j1MGD/WK2Vg/xSiB3L6ZdStIV9vrh9oia48S+bPbcnTMZg0cp
         LA9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686698129; x=1689290129;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8uyQg9FJf1ujfXr9f268eDNpOT0Va/5nApJsu9c/ceI=;
        b=lfEUCFdFnjIAYJn/Dhiys+VeOwiu652ZgMiGLxbqQeUUXzvXBC4kMANMT3IdWIooqy
         Tmh061TqeL0FkkjpgCj2AQDSOETDvBuljqBbR7lJ2y9swHs52fLkWzssLDkP39AO3YPX
         j7Z4Gtdl/YXe7pIu7DX4DEWbrl9iVu4amkGvl18vtwqHYDna3BGr/k2jraEwBZYB3ZJs
         qDb96ox2W4IuIpcGMV0fuHhttcicw21mfcYJqGAiNUD5eGpTeFccyE32a0ZuIyktIEfD
         LF0vuLtOTkA+wtEHb3Wc4Rtj8irF+mHFJ57mtG0qT+abU+CacBDndRzcFnwyeWNf2BUk
         Uw3w==
X-Gm-Message-State: AC+VfDwcCsATB3H5eFCqwPqoA0kaG1/lchI/EOygDk2ZS7fvmDuSf12E
	dVG0Gq2vadm63LAUnbvSPa0L+Q==
X-Google-Smtp-Source: ACHHUZ48GxbxKpQWOMS+G+8jVGNcR3YlGU7DNqyZtqK/fyTpBYFnk38p2ckYqoGkswYn/FM3bj+NDA==
X-Received: by 2002:a17:902:cf0b:b0:1b3:c97a:1e90 with SMTP id i11-20020a170902cf0b00b001b3c97a1e90mr98471plg.4.1686698129085;
        Tue, 13 Jun 2023 16:15:29 -0700 (PDT)
Received: from [2620:0:1008:15:18be:6c84:11a2:b54] ([2620:0:1008:15:18be:6c84:11a2:b54])
        by smtp.gmail.com with ESMTPSA id rj6-20020a17090b3e8600b002599ef80ab9sm11613374pjb.3.2023.06.13.16.15.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 16:15:28 -0700 (PDT)
Date: Tue, 13 Jun 2023 16:15:27 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Vlastimil Babka <vbabka@suse.cz>
cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, 
    Joonsoo Kim <iamjoonsoo.kim@lge.com>, Hyeonggon Yoo <42.hyeyoo@gmail.com>, 
    Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
    patches@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slab_common: use SLAB_NO_MERGE instead of negative
 refcount
In-Reply-To: <20230613102820.19153-2-vbabka@suse.cz>
Message-ID: <11b6e080-8820-87bb-2686-1c78debad4c5@google.com>
References: <20230613102820.19153-2-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Tue, 13 Jun 2023, Vlastimil Babka wrote:

> When CONFIG_MEMCG_KMEM is enabled, we disable cache merging for
> KMALLOC_NORMAL so they don't end up merged with a cache that uses ad-hoc
> __GFP_ACCOUNT. This was implemented by setting refcount to -1, but now
> we have a proper SLAB_NO_MERGE flag, so use that instead.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Acked-by: David Rientjes <rientjes@google.com>
