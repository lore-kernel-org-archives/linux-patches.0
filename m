Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C322CA6
	for <patches@lists.linux.dev>; Tue, 14 Mar 2023 22:10:48 +0000 (UTC)
Received: by mail-wm1-f52.google.com with SMTP id k37so11382281wms.0
        for <patches@lists.linux.dev>; Tue, 14 Mar 2023 15:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678831847;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XOm5rYLYVzCqPgdOgZlYvvxQEGH2cR4WoabHTdB2XTc=;
        b=jEzZzddbSnH6HLoRTbU0J41xJ6EwUSMB1obXmPgFsYPLyylYewJRGT6bdusBGKQlhs
         qqua4VFJpoPfxTvR1HAj2ErF7WaukuiWa3xN/27SorHhN6w+2zs+hdS8IGQxrKGb4UXq
         ZAWy+j8TKthIx6xUAUTviRPkfbWcL4gBErnh1zBE/e4KVVgounC6ZJIPrAnUXKcheFpd
         7ELASOoDJ3suifJZ+gAlKmvKs+jPUsP5a19PGWC0UaWHKgQotdcUu7cpL4l4Lg7rCtmQ
         h4qIWHjMof6LgwHaOeTZDiaR8UEpw7aaN//D7fL413Ek3hoYAPH0iEu9vWP4J2zKdF5A
         suoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678831847;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XOm5rYLYVzCqPgdOgZlYvvxQEGH2cR4WoabHTdB2XTc=;
        b=KNNB7b1qYUn8eZy1o8jle/K1akRcO3YZVX6G9oYHarfOzWdqnc0uATsMMM4zp1upLC
         tJCZCR+NvmHewHtcO67jWEYrhfvnzVePUGxaCgySZ7+3sb1J6S50T79uAeRloZT+DWyO
         Llo9UQ71Eg2JB/x6YJquV5YCfUMzrWbQrBtCoq0ERGkNIlIGIyBUZRg6tW+FGhZpIYCU
         xI+oM2NTtCM9+BliIzMRe1Urxjqo0Epvrm4IXaxzrc8NQkykHQXgXDBgJeJix7KFk2SL
         oE34RqKFI4Sv20WETw+RtDn/j+Uq43L41wyYJ5eilf6kUC58bK9uuiZL9u5PKsfG4lOd
         gJIg==
X-Gm-Message-State: AO0yUKW4URv9Ulzy/YB+QDFFkXSl6iHxZ33K1zIHWeE38MA1Tv8Q6itF
	e5r1K3pOfrougWZrvmRb0Uw=
X-Google-Smtp-Source: AK7set/LLjuI1UJN7XrwhAnLm6yhPHUm3AdRkBcTVIEVq6SVbL08lC3lUyr8ctQdrpwYwuUYEFzSvw==
X-Received: by 2002:a05:600c:4f91:b0:3eb:29fe:7b9e with SMTP id n17-20020a05600c4f9100b003eb29fe7b9emr15098520wmq.17.1678831846616;
        Tue, 14 Mar 2023 15:10:46 -0700 (PDT)
Received: from localhost (host86-146-209-214.range86-146.btcentralplus.com. [86.146.209.214])
        by smtp.gmail.com with ESMTPSA id n17-20020a05600c3b9100b003ebff290a52sm4522859wms.28.2023.03.14.15.10.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 15:10:45 -0700 (PDT)
Date: Tue, 14 Mar 2023 22:10:45 +0000
From: Lorenzo Stoakes <lstoakes@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <mike.rapoport@gmail.com>,
	Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	rcu@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	netdev@vger.kernel.org, linux-doc@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Joel Fernandes <joel@joelfernandes.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Josh Triplett <josh@joshtriplett.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Mike Rapoport <rppt@kernel.org>,
	Neeraj Upadhyay <quic_neeraju@quicinc.com>,
	Paolo Abeni <pabeni@redhat.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 0/7] remove SLOB and allow kfree() with kmem_cache_alloc()
Message-ID: <eeb8c896-120f-482f-97c0-0cff22a53e0f@lucifer.local>
References: <20230310103210.22372-1-vbabka@suse.cz>
 <ZA2gofYkXRcJ8cLA@kernel.org>
 <93d33f35-fc5e-3ab2-1ac0-891f018b4b06@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93d33f35-fc5e-3ab2-1ac0-891f018b4b06@suse.cz>

On Mon, Mar 13, 2023 at 05:36:44PM +0100, Vlastimil Babka wrote:
> > git grep -in slob still gives a couple of matches. I've dropped the
> > irrelevant ones it it left me with these:

I see an #ifdef in security/tomoyo/common.h which I guess is not really
relevant? And certainly not harmful in practice. Thought might be nice to
eliminate the last reference to CONFIG_SLOB in the kernel :)
