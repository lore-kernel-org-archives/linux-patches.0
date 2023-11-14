Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A18A8BE3
	for <patches@lists.linux.dev>; Tue, 14 Nov 2023 04:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="iiD1bPnn"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6c10f098a27so4047199b3a.2
        for <patches@lists.linux.dev>; Mon, 13 Nov 2023 20:44:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1699937052; x=1700541852; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6ONkBbb+HnFKyr5bwkUFFQAkj5jFzRIolELIrPxQNcw=;
        b=iiD1bPnne+pF3q1SVg8wCnvkD2xooZwPXeJAx0jy9NN+eMmNLcLdxkqPPrirmrcRTc
         vhA8tCu7NATEiOaq3Y6M667cuqjcpVgPf2wQzga5cPU5rXwS4mGWcLBVSlMy0TclTpui
         Kr8uj4hadDNJ1bPv2XeYm5JiPLrj7dqiDWn2s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699937052; x=1700541852;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6ONkBbb+HnFKyr5bwkUFFQAkj5jFzRIolELIrPxQNcw=;
        b=rcXlgswmwC6e0XhdlS5PnKAKF+a5CUM7kKG+4TkuBZrKqzK6rKtZ9UtWGzqXOmuQYq
         sjBFZ3mAWLTB9u4JcjUFohZfoV9vLns1+8LHxYyKFVARB0Daw5MGehriWpA+LnIDlmb9
         K9Iubs7ileomz0sTfsJE2bBHLHR+OU8JljVl7jS2oVy1RH6Ww2sJITsspF7VuPbVbM22
         rGdUyr7838mMFhUYdYv/6FOz4JZG9SqvkJHQ4/n/m5DUp1d4v8toIomZv/dQb7Ox7gn2
         nzfG0dyAryVi75tgrSa7zuUvUdDTzFT29/71g7jGuqPvRmP0ZKEKPI01WgZiKpKhVqkb
         mywQ==
X-Gm-Message-State: AOJu0Yxm45ZaSvXHhP7HATpC8sxx3rz2ogieKjmgDVLxq/ijbG/5KxBh
	SpSQdjhDQa3YNEKklnBxKYEg3g==
X-Google-Smtp-Source: AGHT+IEvf5pYK6DfVdWq7oR/LeTR2EzKGTFOoIWwPF4qXeh10Ft7VrEO5A5ARaNGpev0/vRNIRBDhw==
X-Received: by 2002:a05:6a00:3a1f:b0:6c6:9b11:f718 with SMTP id fj31-20020a056a003a1f00b006c69b11f718mr6590354pfb.4.1699937052092;
        Mon, 13 Nov 2023 20:44:12 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id b22-20020aa78116000000b006be5e537b6csm389373pfi.63.2023.11.13.20.44.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Nov 2023 20:44:11 -0800 (PST)
Date: Mon, 13 Nov 2023 20:44:11 -0800
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
Subject: Re: [PATCH 13/20] mm/slab: move memcg related functions from slab.h
 to slub.c
Message-ID: <202311132044.C7D682723@keescook>
References: <20231113191340.17482-22-vbabka@suse.cz>
 <20231113191340.17482-35-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231113191340.17482-35-vbabka@suse.cz>

On Mon, Nov 13, 2023 at 08:13:54PM +0100, Vlastimil Babka wrote:
> We don't share those between SLAB and SLUB anymore, so most memcg
> related functions can be moved to slub.c proper.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
