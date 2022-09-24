Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6542193
	for <patches@lists.linux.dev>; Sat, 24 Sep 2022 04:57:49 +0000 (UTC)
Received: by mail-pf1-f173.google.com with SMTP id b75so1894247pfb.7
        for <patches@lists.linux.dev>; Fri, 23 Sep 2022 21:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=v7kWrPbPEQnUozxdNS5JdmbVNWJ4CHYPrZUZ4V2zRBs=;
        b=enyqEF6ygA7V87gDWotsh10kd6fPVz5rTFRXsc8xm7ENhXrESwtah2QDneBSLsG1Ix
         KzZUA+2b81cD+ep20K1LmiSzAQxvp65GCkZaCzRv6RENRU5LRCtVo+aecNTwn/7ZguoZ
         z4ogI8vGaQeq1Bk+y2dUEOMuIwJpIpR7h4BSM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=v7kWrPbPEQnUozxdNS5JdmbVNWJ4CHYPrZUZ4V2zRBs=;
        b=Iby/1Z97xRyZEzqZcgkIVSsXmCqv1GleZLuY5dHHvXXRbEquONQ1emt6/MEnIkraKJ
         ADFlHIu2LA4QpjFS/XKfAz6HVW0vc3bNo6RQcHhIqhFFybxlUUGjlZhzJGa+S1qBJhOU
         66G8z640C0b+mNw9GOKLKi63oyhDYi/GkEEKkaZizA4BiLYsm3uaN6zQsugtDU3BtcX5
         zRhmF2jJOPMNKbyyhk2s7QBkjC4K55X1dBUEbX2b5hnGE3bP792wHAQ2k41mD/J3JkWg
         W8DFRmfpLD9M2Y7ooyijN4+/IRjKFwLx/RWPsErQWxT9s8cgdBeEhNF3UyrqnMxw2KO3
         a2mA==
X-Gm-Message-State: ACrzQf0neZkfjLsQAn+OUozyzbHFfqowpxHaiV7b/XY3GHVBEttutS/i
	OR2OGneqNnoITDuySv7OHy7UQg==
X-Google-Smtp-Source: AMsMyM5ALGEW52BP/WsgdiSVqzxe8HxFAHDE8Rb8WicdYa03ISm4MLjN1PxlV8W1MXz8rEfQ7pygUw==
X-Received: by 2002:a63:1546:0:b0:42c:50dc:2115 with SMTP id 6-20020a631546000000b0042c50dc2115mr10662678pgv.613.1663995469373;
        Fri, 23 Sep 2022 21:57:49 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id z8-20020a62d108000000b0053e984a887csm7497176pfg.96.2022.09.23.21.57.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 21:57:48 -0700 (PDT)
Date: Fri, 23 Sep 2022 21:57:47 -0700
From: Kees Cook <keescook@chromium.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>, Sami Tolvanen <samitolvanen@google.com>,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH] drm/i915: Fix CFI violations in gt_sysfs
Message-ID: <202209232143.172BCCDC4@keescook>
References: <20220922195127.2607496-1-nathan@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922195127.2607496-1-nathan@kernel.org>

On Thu, Sep 22, 2022 at 12:51:27PM -0700, Nathan Chancellor wrote:
> [...]
> To make everything work properly, adjust certain functions to match the
> type of the ->show() and ->store() members in 'struct kobj_attribute'.
> Add a macro to generate functions for that can be called via both
> dev_attr_{show,store}() or kobj_attr_{show,store}() so that they can be
> called through both kobject locations without violating kCFI and adjust
> the attribute groups to account for this.

This was quite a roller coaster! I think the solution looks good, even
if I'm suspicious of the original design that has the same stuff
available twice in different places. (I have a dim memory of rdma
needing a refactoring like this too?)

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
