Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79772F29
	for <patches@lists.linux.dev>; Sun, 27 Feb 2022 09:44:12 +0000 (UTC)
Received: by mail-pj1-f51.google.com with SMTP id em10-20020a17090b014a00b001bc3071f921so12198025pjb.5
        for <patches@lists.linux.dev>; Sun, 27 Feb 2022 01:44:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kcVCh7MZ2s0H7mQ8KjsOc+AnnXv/uz5a9s+gE8EpkdI=;
        b=WA+WWfj/mtf8DGK2jeKBXYh6JG+I6OdvQ6eKzyMr/JSQRhci2o+TLMHSAoGVU1CJuq
         7c1eFHqUGJqg7mkcR/+ig6pjF+VciV/7klL/a1Yitwo63XKd4Pc42m+ubgf7ZbxTIQaS
         aPTLbpTpcF0CVUb12lPWrG/oVd7RXpHc9An/+UxjmbCbgxbb5W49SemR/g/v6Pp6tzST
         yoVaur7lE/sXhc72ssoofszXvrchtHI3E8vZymOHy65hZvKGAVeolf8IKVcANGWnJPfI
         I9FxPHeaSXFWcd/bASynaaDI1wCB7uEFfCekXTsOsHg0zc66Aka+As8RK0QvnFbp8wHL
         sIUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kcVCh7MZ2s0H7mQ8KjsOc+AnnXv/uz5a9s+gE8EpkdI=;
        b=bEbSsowwRSOtDkO7ja3Jm40jvrYq/3c1Khtpo7A7L/jlTztDuf0kG6EAM255T8sDPh
         M1LCSDN/vsxw2DEdNtoOTZpW9LhwEUWlRuatKesnMKhj9+jLA6Bt0J1Rp3lfyqPGPToW
         iLvAJxPU1dYxu3qpjr4iaR0TWLrB6hQHE04CxYwzLxpNmbT6JsCNXYQMoUvBCZEvlcCm
         jLuWp/uGAnnPyVw8SDUaeuJzt76tyuc5RS9kVALjDnbuTlYYTNvE2pD5xNh+rZHHz/4e
         HC40+CnLY72yqqjwrkPGdfPodfv0Flxv2BJIgyg1mCSniOcDqqH3cnTdgY/oyb/F+1k1
         RC0A==
X-Gm-Message-State: AOAM531XgdZkjRHlBXCE5ul0RQbHHZGGNFkToFAjDzsEa+y+7X53n/2Y
	/REKx80O7KxEahBDcTDmank=
X-Google-Smtp-Source: ABdhPJz661f8MDaAvkFbcNZOi2/He7q7u7ZL1ZJ6cN5DiPBbpJDTXTBCdlArZS3Fz2KNQPVaFjgxxg==
X-Received: by 2002:a17:902:a3c6:b0:14f:b4bd:a1d7 with SMTP id q6-20020a170902a3c600b0014fb4bda1d7mr15292728plb.173.1645955052286;
        Sun, 27 Feb 2022 01:44:12 -0800 (PST)
Received: from ip-172-31-19-208.ap-northeast-1.compute.internal (ec2-18-181-137-102.ap-northeast-1.compute.amazonaws.com. [18.181.137.102])
        by smtp.gmail.com with ESMTPSA id b3-20020a056a00114300b004e099ec2871sm9314294pfm.154.2022.02.27.01.44.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Feb 2022 01:44:11 -0800 (PST)
Date: Sun, 27 Feb 2022 09:44:06 +0000
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	Oliver Glitta <glittao@gmail.com>,
	Faiyaz Mohammed <faiyazm@codeaurora.org>
Subject: Re: [PATCH 2/5] mm/slub: use stackdepot to save stack trace in
 objects
Message-ID: <YhtH5o2+7r85THg1@ip-172-31-19-208.ap-northeast-1.compute.internal>
References: <20220225180318.20594-1-vbabka@suse.cz>
 <20220225180318.20594-3-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220225180318.20594-3-vbabka@suse.cz>

On Fri, Feb 25, 2022 at 07:03:15PM +0100, Vlastimil Babka wrote:
> From: Oliver Glitta <glittao@gmail.com>
> 
> Many stack traces are similar so there are many similar arrays.
> Stackdepot saves each unique stack only once.
>
> Replace field addrs in struct track with depot_stack_handle_t handle.  Use
> stackdepot to save stack trace.
>

I think it's not a replacement?

> The benefits are smaller memory overhead and possibility to aggregate
> per-cache statistics in the following patch using the stackdepot handle
> instead of matching stacks manually.
> 
> [ vbabka@suse.cz: rebase to 5.17-rc1 and adjust accordingly ]
> 
> This was initially merged as commit 788691464c29 and reverted by commit
> ae14c63a9f20 due to several issues, that should now be fixed.
> The problem of unconditional memory overhead by stackdepot has been
> addressed by commit 2dba5eb1c73b ("lib/stackdepot: allow optional init
> and stack_table allocation by kvmalloc()"), so the dependency on
> stackdepot will result in extra memory usage only when a slab cache
> tracking is actually enabled, and not for all CONFIG_SLUB_DEBUG builds.
> The build failures on some architectures were also addressed, and the
> reported issue with xfs/433 test did not reproduce on 5.17-rc1 with this
> patch.

This is just an idea and beyond this patch.

After this patch, now we have external storage that records stack traces.

It's possible that some rare stack traces are in stack depot, but
not reachable because track is overwritten.

I think it's worth implementing a way to iterate through stacks in stack depot?

> 
> Signed-off-by: Oliver Glitta <glittao@gmail.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>

-- 
Thank you, You are awesome!
Hyeonggon :-)
