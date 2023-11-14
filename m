Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17437BA26
	for <patches@lists.linux.dev>; Tue, 14 Nov 2023 04:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Ch0u4cmF"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1cc5916d578so46590285ad.2
        for <patches@lists.linux.dev>; Mon, 13 Nov 2023 20:42:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1699936971; x=1700541771; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sCrSsxjAq1jCq+B2JpsAc9Scn9B6dHAemDj3eFlW1CE=;
        b=Ch0u4cmFDSxq+m9ypCX4pc0EjXvG9t5P4uAjxF/IEELonq0Ilq6yB5m6VuykSv15ux
         +kYlPhWFcXR1fX80oF/yFg88KVrbUs6zfWfoYoGMwr9surfAKqslkd1fRUgEPiSs5zrR
         H/BCMs/2FVa0xv2ckx/kdjUBpQgyryNw7YFJ0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699936971; x=1700541771;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sCrSsxjAq1jCq+B2JpsAc9Scn9B6dHAemDj3eFlW1CE=;
        b=Ql2XqeO5xNEUxuQOmJaAevfAWRjaOnnkKHHAaw6MEvClb/IeNkqEAL3Xs4tgrZNZRL
         zw3B2BfTgj/8uze6AZgGi3P1eK9RSmbc/XHXprJwAfnkLJiyGEpxBpUUGD9hJTeen5DG
         e63xtfNqeheNpaZAEjhsZKgZJaqNO9ibtH0AsG3G9Vt+TMMbNY6seQtTVi6oNxOjV09O
         rL/yalfRk2Or7SHrRTOmekSLzy8LbQaO5efFBXkmAP0jPI4kJp9wSfDE1uU5Dh1Vs/sT
         ZlCX4ajDiCKh6VlPhbRf/UgccI77GAMe8DkkegvAzPY7UsqNlxQGTBzZeGr2btKyJdQE
         Jg1Q==
X-Gm-Message-State: AOJu0Yz5cU4b5hMWkwpP2XyvQTghkMmYhv1o8WwMN0tNz5OHyZoJCOdG
	2sYD7X0X6O8l85lpjEmu41awHw==
X-Google-Smtp-Source: AGHT+IGdwyQZzmA4/9nwfKzzB4u85s8j9BkjlV/hZKmIfu7UdDuaDJSnLL1zsdTxEYzRzIo24svtGQ==
X-Received: by 2002:a17:902:db0d:b0:1cc:4467:a563 with SMTP id m13-20020a170902db0d00b001cc4467a563mr1181743plx.3.1699936971495;
        Mon, 13 Nov 2023 20:42:51 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id z5-20020a1709027e8500b001b8622c1ad2sm4947830pla.130.2023.11.13.20.42.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Nov 2023 20:42:51 -0800 (PST)
Date: Mon, 13 Nov 2023 20:42:50 -0800
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
Subject: Re: [PATCH 12/20] mm/slab: move pre/post-alloc hooks from slab.h to
 slub.c
Message-ID: <202311132042.CA0081D@keescook>
References: <20231113191340.17482-22-vbabka@suse.cz>
 <20231113191340.17482-34-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231113191340.17482-34-vbabka@suse.cz>

On Mon, Nov 13, 2023 at 08:13:53PM +0100, Vlastimil Babka wrote:
> We don't share the hooks between two slab implementations anymore so
> they can be moved away from the header. As part of the move, also move
> should_failslab() from slab_common.c as the pre_alloc hook uses it.
> This means slab.h can stop including fault-inject.h and kmemleak.h.
> Fix up some files that were depending on the includes transitively.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
