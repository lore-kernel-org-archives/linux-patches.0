Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4D78F51
	for <patches@lists.linux.dev>; Tue, 14 Nov 2023 04:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ZsyL2BdM"
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-5872b8323faso2984494eaf.1
        for <patches@lists.linux.dev>; Mon, 13 Nov 2023 20:44:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1699937086; x=1700541886; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dTW82VIg1zc6gWMgLEgKtR0yngdsI70qEuPsuyspTwo=;
        b=ZsyL2BdM2/P/800atO0cr9324mxB75bupkufHwkgTR6o/ZsrbpQsb8nLwdQjbxaVkt
         rWJlBHaqKrOUvWVtK/QtsqiHGMXO8LTU7uAIVkKrjUKjmEM5h5kCHw96iIDK9vd9GahI
         VOBBQJ1k4/GwT/+MYWvyMewnhX/gvXmDL78f8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699937086; x=1700541886;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dTW82VIg1zc6gWMgLEgKtR0yngdsI70qEuPsuyspTwo=;
        b=ORu12BdYZfQjfiXF3CzakWxZ6jyo7rmCnQn/QN9bX5L4TwY62387CrdkApZbwFdOP7
         xQhe6Z4z9C1jWrUI1QvF3jldD0Eurt7CF1b79w2dBl1XeQE/TVPjP33eOrSCR4bmXjzS
         fSYbBNUOj4p28vAnzurVZqCcD/8Hy+Dcej8evTzfJ1hRy96G+3Vo6K+ajjQ4mK/j3Fwq
         k/yz9AIK6U6TrVktcyiNhnEx4HvAKGmLyMjFT28Na+Wk3PdtPLuX4m7LzQjoa4RHgeaF
         wCFyV8drozGstpyA5r7PNYRGt+BfGRi2q7hTO+INUr2++tJoaqJ8vnctFEtDM/758ISy
         OUow==
X-Gm-Message-State: AOJu0YyWPLE/GsRzse7oFDsj+jfGgQn8XMyyUibDQdFJvjosuqAnghO6
	wvWazUuQUBXd76i45D2J+X99mw==
X-Google-Smtp-Source: AGHT+IEHSCi3qmm+CEYh5S+KHw/ma3E20e49n+ffxfRFPgJdN9lczSQRNAtSX+4ACW6uKlNfJe1Emg==
X-Received: by 2002:a05:6358:3411:b0:168:e614:ace9 with SMTP id h17-20020a056358341100b00168e614ace9mr1513512rwd.11.1699937086576;
        Mon, 13 Nov 2023 20:44:46 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id s16-20020a656910000000b005bd3d6e270dsm4044377pgq.68.2023.11.13.20.44.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Nov 2023 20:44:46 -0800 (PST)
Date: Mon, 13 Nov 2023 20:44:45 -0800
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
Subject: Re: [PATCH 14/20] mm/slab: move struct kmem_cache_node from slab.h
 to slub.c
Message-ID: <202311132044.6DE1B717@keescook>
References: <20231113191340.17482-22-vbabka@suse.cz>
 <20231113191340.17482-36-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231113191340.17482-36-vbabka@suse.cz>

On Mon, Nov 13, 2023 at 08:13:55PM +0100, Vlastimil Babka wrote:
> The declaration and associated helpers are not used anywhere else
> anymore.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
