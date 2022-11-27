Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC544256E
	for <patches@lists.linux.dev>; Sun, 27 Nov 2022 11:05:59 +0000 (UTC)
Received: by mail-pf1-f180.google.com with SMTP id b29so7910091pfp.13
        for <patches@lists.linux.dev>; Sun, 27 Nov 2022 03:05:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Yktw0YNbfJViRzOBK1z1I3DiZx0Xo+QXXrahApjTukw=;
        b=dsfe0IZycca1vKvPwH0+SS5PnahlyMoY18LuHqrV4rMcpk9V74A+jred7IP/Ms4NAD
         4S1o7vIrooX8tyVA6iDKcoYDosvFFcTSN6xS7wTYh+BQfBKKG33oAqJAQJ3zHhs5EGiz
         y7CNB3c2+7nu4yvVXyiU/AgxeXwwSuKq9BcbSSQo8crxcTFLwNFaSaM0ws4LIuwC9unC
         xLYSuNmDlkTwurv3fwqsOL+9r25NcgJHB4JucUtMmBeON+IMitFWRD8CVO460c3yLn1B
         DyZvxxl0ibCIwOJwwKyKkxxKYJhWueM02jw6I+PtVf7/PFmqgtXjZhTmM5m4QVO89upz
         PkQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yktw0YNbfJViRzOBK1z1I3DiZx0Xo+QXXrahApjTukw=;
        b=rFwzZIcsNBSDQ5PFQ7MvGpp1NH3aAaFdD6t4euNzJ+8lC175YNGWZfM7+hBuwCOMFY
         4fJ8Nb5MIG2MQ6Ks+vKO4L8XWaPr2pzb2xlaC2BcOTaygUg8Yi8ZwKJb8gLiT1A7sRBC
         apyb8MUTfdr/sOXrs1Gh1nYMA5Br6FVl4Z9pjtBEB+LQjelzFA/9jbCpU2jkXA90OG44
         IyDwFDFr9Hh5W7P4aHyfwAycd03sMH+dF8BsGnvHfC8lnz2055jzGkpMzDLa0SWC9nmg
         aoDE15D7fdb2x6ye2ALmMqJlWQYiU3Jjh7QkrDh7k/MjSpy0E8aI3ZLCmj81JbzTbRhL
         LY2g==
X-Gm-Message-State: ANoB5pm4Yt8soXu8WAgA9EnFKOgcOarNuUvIcufyMYSjKDU0NOGRs7JK
	9kxKw0WaiY+Tm3ZgPEQt90Y=
X-Google-Smtp-Source: AA0mqf545L0iENUMeOl6Wu09GKFsw4mhesGxrH3UpIYCwlJIZcO+SXoT7tW4i0Z5mXftI9+FkT3ILg==
X-Received: by 2002:a62:605:0:b0:574:ec7f:20d0 with SMTP id 5-20020a620605000000b00574ec7f20d0mr5952033pfg.77.1669547159386;
        Sun, 27 Nov 2022 03:05:59 -0800 (PST)
Received: from hyeyoo ([114.29.91.56])
        by smtp.gmail.com with ESMTPSA id x4-20020a170902ec8400b00186b04776b0sm6680417plg.118.2022.11.27.03.05.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Nov 2022 03:05:58 -0800 (PST)
Date: Sun, 27 Nov 2022 20:05:52 +0900
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>, patches@lists.linux.dev,
	Dennis Zhou <dennis@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/12] mm, slub: remove percpu slabs with CONFIG_SLUB_TINY
Message-ID: <Y4NEkF8DI1uXFRv4@hyeyoo>
References: <20221121171202.22080-1-vbabka@suse.cz>
 <20221121171202.22080-11-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221121171202.22080-11-vbabka@suse.cz>

On Mon, Nov 21, 2022 at 06:12:00PM +0100, Vlastimil Babka wrote:
> SLUB gets most of its scalability by percpu slabs. However for
> CONFIG_SLUB_TINY the goal is minimal memory overhead, not scalability.
> Thus, #ifdef out the whole kmem_cache_cpu percpu structure and
> associated code. Additionally to the slab page savings, this reduces
> percpu allocator usage, and code size.

[+Cc Dennis]

Wondering if we can reduce (or zero) early reservation of percpu area
when #if !defined(CONFIG_SLUB) || defined(CONFIG_SLUB_TINY)?

> This change builds on recent commit c7323a5ad078 ("mm/slub: restrict
> sysfs validation to debug caches and make it safe"), as caches with
> enabled debugging also avoid percpu slabs and all allocations and
> freeing ends up working with the partial list. With a bit more
> refactoring by the preceding patches, use the same code paths with
> CONFIG_SLUB_TINY.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

-- 
Thanks,
Hyeonggon
