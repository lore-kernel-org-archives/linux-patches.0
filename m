Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F08F88F70
	for <patches@lists.linux.dev>; Tue, 14 Nov 2023 04:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Qzg5HLSm"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-6bd0e1b1890so4028703b3a.3
        for <patches@lists.linux.dev>; Mon, 13 Nov 2023 20:07:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1699934850; x=1700539650; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KGZDmoEeCuoU4ORpnmk9KfAQBb9nHs+S5VafgrXpLog=;
        b=Qzg5HLSmnxhi7gDWHGVbAzDSe8cKxhxorOLGRbhD9DMv+cLgxRNAK5bWP9rPEc7B5G
         ZsvqvzHPH/CaZuxZ1F1OD7ACiY9YxXjVWpD3aZVFjbRWlmWVNxt0oU2verc+EVsqOe2V
         TnntBQAGAOEzc0gjzyDeDXzf1ZSmqMEyH7QYE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699934850; x=1700539650;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KGZDmoEeCuoU4ORpnmk9KfAQBb9nHs+S5VafgrXpLog=;
        b=h/r+k+CUxyR99mo7dMTX49AkWVLbGb+jGy7YNAtUKVTcALuLMd+aydq1DE8WNQIQiN
         zmUzgctWH28ED4AtyKuVJy0fuP1cMqWWNRrQeeYfwpxdexUjpxiuFjSRAClPwWGCM9WR
         TdfgrvQroXIU1JjWZ4/RYsv5ntOdRu1D5cs6JUNUTh6TruGtGW0+lBaWGJWdFprLrtI7
         d1ZdPyE+MIynyWpVTBFGb8NlEl4O6gynO2GcpqVsW/oNgUm99Ojjn1VBjFlO9xOKj0Dt
         xH43w9MUPKYfOrtLOzD5ie4YTZ658A8037BPy5iVBQoZadirTaAvLRBJ/7zgFlIccT+t
         o+pQ==
X-Gm-Message-State: AOJu0YynfaTbylKIRXHOlmKka93+OmybSRaEVJlbR69lZEaJx4l9Wnkm
	Ajk+4HmJsNbahVBkBkSvJBtCbg==
X-Google-Smtp-Source: AGHT+IFyU2MADg9EleoYCMTUi5z42Da4Qrzy3K4tyZn3glXnx25v+sXlqweMXpTqFAPp362Amxy4Qg==
X-Received: by 2002:a05:6a20:6a04:b0:186:7988:c747 with SMTP id p4-20020a056a206a0400b001867988c747mr4329657pzk.19.1699934850013;
        Mon, 13 Nov 2023 20:07:30 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id j15-20020a170903024f00b001c62b9a51a4sm4782100plh.239.2023.11.13.20.07.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Nov 2023 20:07:29 -0800 (PST)
Date: Mon, 13 Nov 2023 20:07:28 -0800
From: Kees Cook <keescook@chromium.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
	Pekka Enberg <penberg@kernel.org>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Marco Elver <elver@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeelb@google.com>,
	Muchun Song <muchun.song@linux.dev>, kasan-dev@googlegroups.com,
	cgroups@vger.kernel.org
Subject: Re: [PATCH 16/20] mm/slab: move kmalloc_slab() to mm/slab.h
Message-ID: <202311132006.51222C473@keescook>
References: <20231113191340.17482-22-vbabka@suse.cz>
 <20231113191340.17482-38-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231113191340.17482-38-vbabka@suse.cz>

On Mon, Nov 13, 2023 at 08:13:57PM +0100, Vlastimil Babka wrote:
> In preparation for the next patch, move the kmalloc_slab() function to
> the header, as it will have callers from two files, and make it inline.
> To avoid unnecessary bloat, remove all size checks/warnings from
> kmalloc_slab() as they just duplicate those in callers, especially after
> recent changes to kmalloc_size_roundup(). We just need to adjust handling
> of zero size in __do_kmalloc_node(). Also we can stop handling NULL
> result from kmalloc_slab() there as that now cannot happen (unless
> called too early during boot).
> 
> The size_index array becomes visible so rename it to a more specific
> kmalloc_size_index.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Yeah, removing the redundant size checks does make this nicer to look at. :)

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
