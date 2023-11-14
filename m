Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1AC48C1A
	for <patches@lists.linux.dev>; Tue, 14 Nov 2023 04:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="WzSl/kAL"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1cc3bb4c307so39933365ad.0
        for <patches@lists.linux.dev>; Mon, 13 Nov 2023 20:45:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1699937149; x=1700541949; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZBMZCd1RTYcku4fr+eS/5T5vGEq4PYQLNXmfcgCc7wA=;
        b=WzSl/kALc5eaNUKcCun9OQ7oYC32E7LIWURAD0a0SivXEFQOQ1caQ2s2+BFw5gzx4b
         D9siXwpQAxrnRMmY3a/ML1T1vtXaBceGTEKjKt7UbJjZSYQ3tCxrtr0FYpVJemTN8n+Y
         xeDalvD09Sz3InHB5dbdtVAF3MjKe00vsytxg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699937149; x=1700541949;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZBMZCd1RTYcku4fr+eS/5T5vGEq4PYQLNXmfcgCc7wA=;
        b=MmS5HWc/gyYoNR2zQzQr7cBIJwmbGvIAOkJY0MiMAL82310m0hKjDZRWPajypfyBVz
         ZhRxQiZSKn1abNMY9IUEdoHM7kpHVL8wvojGkzp9eqYG7zct8FxvIEqrg5pMmg6cZG5w
         ClirXHQNtdSYoyKMjXti3Dts5i63hmGNxVV8DxpwIGycLgkociNFF50wtw3+CgttiqJE
         v66k8S7Kke1LRCp/0GK1X2AjIfkkgIpQxNQCPuBh/5H3uSB6vCWZHa9Ub2doDXhx08gM
         IoZe8a0+nzyx4r0ymKVoP4VsiGQa8J3BZjkN7mHrCniUlX48bLMqPfrYcpbSh+36t3a2
         LvDw==
X-Gm-Message-State: AOJu0YxVEA5OCEaq8mCsq+znihoLJRY4fsvbT5zXUwSYVYciTcXU5Rrl
	SVuRkQVeA8XOiun/uw5q/HnInA==
X-Google-Smtp-Source: AGHT+IEsjAp3cBiJSP3PyvVvmPuSm+aeTJB4FD5LC9ruHOoqYzxrBqIrhGMYXmyQPi4w72yy/WPkjg==
X-Received: by 2002:a17:902:8542:b0:1c3:1f0c:fb82 with SMTP id d2-20020a170902854200b001c31f0cfb82mr968412plo.41.1699937148885;
        Mon, 13 Nov 2023 20:45:48 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id u12-20020a170902b28c00b001c55e13bf2asm4804097plr.283.2023.11.13.20.45.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Nov 2023 20:45:48 -0800 (PST)
Date: Mon, 13 Nov 2023 20:45:48 -0800
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
Subject: Re: [PATCH 15/20] mm/slab: move kfree() from slab_common.c to slub.c
Message-ID: <202311132045.D84400ED@keescook>
References: <20231113191340.17482-22-vbabka@suse.cz>
 <20231113191340.17482-37-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231113191340.17482-37-vbabka@suse.cz>

On Mon, Nov 13, 2023 at 08:13:56PM +0100, Vlastimil Babka wrote:
> This should result in better code. Currently kfree() makes a function
> call between compilation units to __kmem_cache_free() which does its own
> virt_to_slab(), throwing away the struct slab pointer we already had in
> kfree(). Now it can be reused. Additionally kfree() can now inline the
> whole SLUB freeing fastpath.
> 
> Also move over free_large_kmalloc() as the only callsites are now in
> slub.c, and make it static.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
