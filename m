Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65EF8487
	for <patches@lists.linux.dev>; Tue, 14 Nov 2023 04:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="XUjtc313"
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-586940ee5a5so2685392eaf.0
        for <patches@lists.linux.dev>; Mon, 13 Nov 2023 20:38:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1699936706; x=1700541506; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cKLnTTpcsA4GTSpHutPlS9fMo+BLZ8ixEQsC9MUWwLk=;
        b=XUjtc313FTMriB41V10tSS5TI05ihsXP8P9KHfJ3goIWI9ti3rgeIquiS/AgEWiDi6
         LccspAkLq+WwamNh/xX3TUWpe4GD6YXXgpXk5ob/IJ0ZOJm8ri/DtAK5dId8EhApFXxq
         TC3DbIVCWc2qaVSQXf4la9SHQD1BCn8T/p898=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699936706; x=1700541506;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cKLnTTpcsA4GTSpHutPlS9fMo+BLZ8ixEQsC9MUWwLk=;
        b=MWCvHdEGyadwTC4KRGmFwpIUds4WIoVDJrAnF5EEF3+TX/qx5pCK1hDgjQyTNbhzAo
         NxL+fNCpm8QeyiPKJyb2WCj8FkV0jG/aXxNWqRKmcx/jZldMHjNnWLrM1i+PPEjN70vr
         qLslfzdjthBcqJGH3qtykRv2+BRb3H3Xhb99buocpbpVi+0kbZxPwgKw9A9ZavSoGbyU
         zdG1SMgqB/NqtqqSWvOf73LcOLuN+BNA8s8IPspdZxEVZveymweiIVBHJYeGQGam0b+K
         z3NwlLMThbNRextSi+NDwhMoR6pnTSPV200E7zIyrhZq6s8TN8Qw/P5TBLm+4v0XEm26
         8Lbw==
X-Gm-Message-State: AOJu0YwaRFB5T/IxBaDOfNIn4E6H/ph6YDfuU8SeqnXcYpApZxr9PQB7
	1eaJF6v4CQeyxj4cl5SvvBy7AA==
X-Google-Smtp-Source: AGHT+IFDSeKpFIR7EqfcNMWsaO6kBeTgiI6AAPV/dcvwqXilQHmw3/CSiZnWYA9Y/YDdW/YrAaS6hg==
X-Received: by 2002:a05:6358:914:b0:168:eded:d6c9 with SMTP id r20-20020a056358091400b00168ededd6c9mr1639355rwi.29.1699936705986;
        Mon, 13 Nov 2023 20:38:25 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id q14-20020a63e20e000000b0056946623d7esm4832935pgh.55.2023.11.13.20.38.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Nov 2023 20:38:25 -0800 (PST)
Date: Mon, 13 Nov 2023 20:38:24 -0800
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
Subject: Re: [PATCH 10/20] mm/slab: move the rest of slub_def.h to mm/slab.h
Message-ID: <202311132037.F4FA0B2@keescook>
References: <20231113191340.17482-22-vbabka@suse.cz>
 <20231113191340.17482-32-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231113191340.17482-32-vbabka@suse.cz>

On Mon, Nov 13, 2023 at 08:13:51PM +0100, Vlastimil Babka wrote:
> mm/slab.h is the only place to include include/linux/slub_def.h which
> has allowed switching between SLAB and SLUB. Now we can simply move the
> contents over and remove slub_def.h.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Now is the chance to do any whitespace updates! I saw a few #defines
that looked like they could be re-tab-aligned, but it's not a big deal. :P

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
