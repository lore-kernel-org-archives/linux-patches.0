Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com [209.85.222.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8180125DC
	for <patches@lists.linux.dev>; Tue, 14 Nov 2023 08:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DCpGeaxm"
Received: by mail-ua1-f43.google.com with SMTP id a1e0cc1a2514c-7b9f08482c8so2145791241.3
        for <patches@lists.linux.dev>; Tue, 14 Nov 2023 00:06:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699949197; x=1700553997; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7LGBUC9KsVeG0zIgCHu5xE4QSpLiIpSfaSXOL0b9rF8=;
        b=DCpGeaxm+6sOnV2WhZVwo4V/DJubQwyttC8X/fFBPfO1rG5tAp6Fs/FA2ddPJ87L1C
         T6ocYZUNcDrYyoYFpJ8j7yf3/TN4f1PUrVh+HIWoDXaNY0eMRGHRsA5Kk7aBB9erqMuq
         2eTLGD/xjPanHmUDSGR8wpr4HVuW+XQ3WlIPklBoYpqcIqkE7YIUhyQzNFKwkh6vpS9s
         Ro/537+4cgC+uVRfei9dA3qxTLFJPZkJIgJlKUnDWbISVtQCXoYXKh0cZEdJSD6ZFBut
         U6emarjFfoVeuP7s1kf+6pocNN9Q6cNl8WiBzcnLWm5Yy5+rmNXretqOTtx+m4ITgxFm
         kp/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699949197; x=1700553997;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7LGBUC9KsVeG0zIgCHu5xE4QSpLiIpSfaSXOL0b9rF8=;
        b=M9gfD3HFASnzMi49OnzONyvIEU5clCpJsqGg7aHTDVPioJMiJPMrhG2WVNxh5z3ARF
         nTPs6jmmzCz5ygmfjBjNfnoF4gfQPWkApW4y4QEkrTg2PX4YEEYeuC/OLAm+PtyrA/+R
         PlBBsNWuuBj4OIvPazD/AU6Qu3dA2vaMWoA75XuT7h+7A5RXjdu6EXrCkqIcoHdfYkls
         CQEqmrdFEEyC0UqlXg11L39XSElTAgRS6XmOVMyCscxlJUGrg+tzCqf26NWBj1llx+KF
         dBBiqwnieAJfd1ktCTlJqnOBHvpFuGzzWD1HHQzcgy0b9nA5BQJ5LcT+QMSYhj3qml4o
         jdIg==
X-Gm-Message-State: AOJu0YyhB+3EiATZOcqUsswB4ywb5bSdz8RA+9uhwv/wMgvgdba7cFWl
	LN9fJzakR00WmEQoZynKWMey9nIndJEj6DeGrCEG0A==
X-Google-Smtp-Source: AGHT+IHRIIJ2otFiB28Ipx0WgE1WaXBMqJrx1/oRb4fjPk7Cj1iPewjxrE+pVnHo7BMp6gIpNsFRoZRKbs2enis0SEY=
X-Received: by 2002:a05:6102:474e:b0:452:6178:642c with SMTP id
 ej14-20020a056102474e00b004526178642cmr8315473vsb.1.1699949197540; Tue, 14
 Nov 2023 00:06:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231113191340.17482-22-vbabka@suse.cz> <20231113191340.17482-30-vbabka@suse.cz>
In-Reply-To: <20231113191340.17482-30-vbabka@suse.cz>
From: Marco Elver <elver@google.com>
Date: Tue, 14 Nov 2023 09:06:01 +0100
Message-ID: <CANpmjNNkojcku+2-Lh=LX=_TXq3+x0M0twYQG2dBWA0Aeqr=Xw@mail.gmail.com>
Subject: Re: [PATCH 08/20] mm/slab: remove mm/slab.c and slab_def.h
To: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, 
	Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Hyeonggon Yoo <42.hyeyoo@gmail.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeelb@google.com>, 
	Muchun Song <muchun.song@linux.dev>, Kees Cook <keescook@chromium.org>, 
	kasan-dev@googlegroups.com, cgroups@vger.kernel.org, 
	Mark Hemment <markhe@nextd.demon.co.uk>
Content-Type: text/plain; charset="UTF-8"

On Mon, 13 Nov 2023 at 20:14, Vlastimil Babka <vbabka@suse.cz> wrote:
>
> Remove the SLAB implementation. Update CREDITS (also sort the SLOB entry
> properly).
>
> RIP SLAB allocator (1996 - 2024)
>
> Cc: Mark Hemment <markhe@nextd.demon.co.uk>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  CREDITS                  |   12 +-
>  include/linux/slab_def.h |  124 --
>  mm/slab.c                | 4026 --------------------------------------

There are still some references to it left (git grep mm/slab.c). It
breaks documentation in Documentation/core-api/mm-api.rst
