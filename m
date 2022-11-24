Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71BF28EF
	for <patches@lists.linux.dev>; Thu, 24 Nov 2022 14:26:06 +0000 (UTC)
Received: by mail-pj1-f52.google.com with SMTP id b13-20020a17090a5a0d00b0021906102d05so285118pjd.5
        for <patches@lists.linux.dev>; Thu, 24 Nov 2022 06:26:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IAlmDlf3J91/9mijeaog5st0f/5MkIiZF834ldeIBx0=;
        b=Lk+Axj7fdQi0yyxjccdwBH5rucopDiUHwkMJPcAFD7s4QwYPhq5ajHq09DdObQ2Uog
         wvdaypvnpIdGzvnl6AsKAxzZmxCeUbtC7znyGNbYEg7RN9iV4EwXh+GZf8DL+r6JQppl
         0+RXV3gkAXLlDxn/fNq6t7tixQd2bpUcJi2Ylyv3d52VAUk/OwKMDjpNV+LVUuioP10j
         sHDbN3vrfGaj2NkLLJ9I/PYietus+u8+w/+awCtXgEMK0AXEQT4XtdXgL22zcbuXIykW
         7fBCiTHNDknLsSPFRhsyiqhQ6LbQ1dEABMZHZ/VvRWXQTm/LwZnZBOB9rY33q5Je01kz
         UuWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IAlmDlf3J91/9mijeaog5st0f/5MkIiZF834ldeIBx0=;
        b=aqrwi4QjMd3yKJ0640iQdTi3kaF4eByUyDYkxBDz7FIB4sPyI3Txi/9D+TopSLKW0N
         ZQqJIyn8HIB7PQeKonI0X1ASqwsXa4TtmPnixL4P6hBoYrX4M37eZLwlgau0cV0ML3Jy
         b1foOpG7rBAa80yVOI5Q0TrdMwXNufS/I4Zej+jRnYpwSAY3BRW4HPUk+Qcw8LZWffrc
         M41/fCu6Cwy0hTTeS9vmnRE6gpbZorvCBRvjlV3b+MjPxYGiT4N/SueQMqK3cAmfL+Ng
         rDACZDb8QcK5RbkCya1lUCDCwQRjaQNTSpW/HeH1doEQysyK8Q/13rnw4bcj97knrrrP
         cihw==
X-Gm-Message-State: ANoB5pnP/UO685Uu8LMI3LPrD/0xpEeLMnCJeKQIiF98ksqGUgn/H/1U
	nIKxW/f6xh4XFkEe7ibAksM=
X-Google-Smtp-Source: AA0mqf5GMN96W6w9aQMjgL4hm3VPATsFalHprJKWDdJ0RfZ4rKCtYx8AcAblrrg7VOpxiQKs3Ex0HA==
X-Received: by 2002:a17:902:e807:b0:186:fb90:5774 with SMTP id u7-20020a170902e80700b00186fb905774mr14542983plg.137.1669299966305;
        Thu, 24 Nov 2022 06:26:06 -0800 (PST)
Received: from hyeyoo ([114.29.91.56])
        by smtp.gmail.com with ESMTPSA id b26-20020aa78eda000000b0056da63c8515sm1319439pfr.91.2022.11.24.06.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 06:26:05 -0800 (PST)
Date: Thu, 24 Nov 2022 23:25:54 +0900
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>, patches@lists.linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/12] mm, slub: don't create kmalloc-rcl caches with
 CONFIG_SLUB_TINY
Message-ID: <Y39+8mO5oT3K41si@hyeyoo>
References: <20221121171202.22080-1-vbabka@suse.cz>
 <20221121171202.22080-7-vbabka@suse.cz>
 <d77498f8-b15f-9dae-1803-2d2bbb99da50@suse.cz>
 <Y39wYPl5y3apKbD2@hyeyoo>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y39wYPl5y3apKbD2@hyeyoo>

On Thu, Nov 24, 2022 at 10:23:51PM +0900, Hyeonggon Yoo wrote:
> > @@ -859,7 +865,7 @@ void __init setup_kmalloc_cache_index_table(void)
> >  static void __init
> >  new_kmalloc_cache(int idx, enum kmalloc_cache_type type, slab_flags_t flags)
> >  {
> > -	if (type == KMALLOC_RECLAIM) {
> > +	if ((KMALLOC_RECLAIM != KMALLOC_NORMAL) && (type == KMALLOC_RECLAIM)) {
> 
> for consistency this can be:
> 	if (IS_ENABLED(CONFIG_SLUB_TINY) && (type == KMALLOC_RECLAIM)) {
>

My finger slipped :)
I mean:
	if (!IS_ENABLED(CONFIG_SLUB_TINY) && (type == KMALLOC_RECLAIM)) {

-- 
Thanks,
Hyeonggon
