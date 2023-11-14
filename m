Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A237BBA26
	for <patches@lists.linux.dev>; Tue, 14 Nov 2023 04:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="O6pim3u/"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6b20577ef7bso4431378b3a.3
        for <patches@lists.linux.dev>; Mon, 13 Nov 2023 20:34:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1699936472; x=1700541272; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=o11HARQxoCvg8Gx5zjjgZkRsPvVu73rMm7hpUxapQ0A=;
        b=O6pim3u/+JeTJm5E2bs7WFRueRkDqzWtg5geLcGQchIfcCE5oqNYFiOWdioCD9z3o0
         3pTyVMgtgz5ozIZ4ZB09Qz7YJBqmoo7aYdQFo9n4vQ9+oh1gUeXXiKavmy84sMVTS/iW
         K8lLkP/kiQJgxtg4h0vBpCFHJaUEDWVNFj31w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699936472; x=1700541272;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o11HARQxoCvg8Gx5zjjgZkRsPvVu73rMm7hpUxapQ0A=;
        b=Xhk2uuDGp9LfoPh+iiezcBzD0hqs2RCrokDmr7N3uf+RSpfq0CDqreYIs9yhn+v6iW
         zHFozb1ISAq1R076soPxPSLl4uI3l1gbOaSlSRnnqgIQZ8I26AsKAlQdtGrmHHxIb88E
         /AE1UqOXGRMzusM/xOE4gCoGf9zya1YaajmVQowidhQ623xmupprFw5H+4Rtdl2L0hb6
         tImwU9AcoAJsUK0XalwyKh4uNh66YoINxnq6SqrYha7yz9gXNx+rdH9DWF33N+WOF2tl
         +//9qLd37OcuJY1+fnm4l0k4yAuhK5ckNXjnYj6ZIM7TWxpoZlTaS/y+HIHsjsV0l2Qr
         yZGw==
X-Gm-Message-State: AOJu0Yw4/k+J7X+DPCgapIa7RNBiD8MucUzzgQFkL4xN+A+Hbc3hTQvM
	tFIl8xW4B9cZpdeax6SkDosvvg==
X-Google-Smtp-Source: AGHT+IGseueIFF+JmLoGhwnqLpZw2W4u0dwVJZMG/dnzFetGq2hz6yOEFr5CcVgcKPJNd+w2yidtYw==
X-Received: by 2002:a05:6a20:729e:b0:186:7ac3:41c8 with SMTP id o30-20020a056a20729e00b001867ac341c8mr4469072pzk.56.1699936472009;
        Mon, 13 Nov 2023 20:34:32 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id a13-20020a170902b58d00b001c465bedaccsm4835731pls.83.2023.11.13.20.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Nov 2023 20:34:31 -0800 (PST)
Date: Mon, 13 Nov 2023 20:34:31 -0800
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
	cgroups@vger.kernel.org, Mark Hemment <markhe@nextd.demon.co.uk>
Subject: Re: [PATCH 08/20] mm/slab: remove mm/slab.c and slab_def.h
Message-ID: <202311132032.1BB9A17@keescook>
References: <20231113191340.17482-22-vbabka@suse.cz>
 <20231113191340.17482-30-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231113191340.17482-30-vbabka@suse.cz>

On Mon, Nov 13, 2023 at 08:13:49PM +0100, Vlastimil Babka wrote:
> Remove the SLAB implementation. Update CREDITS (also sort the SLOB entry
> properly).
> 
> RIP SLAB allocator (1996 - 2024)

/me does math on -rc schedule... Yeah, okay, next merge window likely
opens Jan 1st. So, this will land in 2024. :)

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
