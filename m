Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080BE15D5
	for <patches@lists.linux.dev>; Fri, 31 Mar 2023 03:42:16 +0000 (UTC)
Received: by mail-pj1-f49.google.com with SMTP id l9-20020a17090a3f0900b0023d32684e7fso7483489pjc.1
        for <patches@lists.linux.dev>; Thu, 30 Mar 2023 20:42:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1680234136;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=D2yoA6/ZMAiU5n58XnU5GRn99au0wJfFSmiuyy5JMiA=;
        b=l2BgSx22kuf8Hs3D7qJk6EE10cDBOjYG0ia03DbUz+keXgFSqQ0kOnwuvFo1mqJ7e8
         sr2sOplzSkPKNkE9f69WVC7cUXhYU+E/lJhlnq9gDVmZxBMPX8IDgw7cLxCFn7kC+pdl
         eP+vfO5qQh+5YySDiX2/XfMPhhzlNGGAVojJE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680234136;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D2yoA6/ZMAiU5n58XnU5GRn99au0wJfFSmiuyy5JMiA=;
        b=eALkazvfhXdC7Olx6qhG4uUnwAXJ2yJtFQaYlY8oiuiOw+vlDzLD1o2xKpQjD6HLLB
         SMS0E3Y0UaEER90a1C/ZUnueIz/V7oYMe4rx/TDSbD1L7+4mWMDCLsnI3iGMMmk3LrnK
         taycI4gEF/RsQbph+fs6s/Z05ZbPEujRkchWVvMi53G5d/lK5tNAnOF7jYiU+OFWA3xT
         8sIIU62LbkN0swZy7PMspt433bR9oEhHU9EZuHGeybLqVgMMGRVS7lE61csXfYnnVN5U
         uY1liwRWHrqaT/po66VKYWqNxZNHhsplUqwwhpjchoQ4Zl2fNSAjcvio9L3X3uxUR3cA
         5bKA==
X-Gm-Message-State: AAQBX9e6hMCWh3zSMuP4ZuxyzpTvtKiYSVxRfMx/YxxYc563cDgLzP7Y
	ci/EKYxfW3Vo6jhLQNvR8uLIGQ==
X-Google-Smtp-Source: AKy350YEadHnIPucAgMaeBL0HMKusS65/ZM2KAeXc/wd10yIBt72Hu/asTJYkl9H5ZaueGU8YrY2TA==
X-Received: by 2002:a17:903:230d:b0:1a1:9787:507d with SMTP id d13-20020a170903230d00b001a19787507dmr9866306plh.3.1680234136348;
        Thu, 30 Mar 2023 20:42:16 -0700 (PDT)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id d9-20020a170902aa8900b001a1d7329235sm427500plr.234.2023.03.30.20.42.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 20:42:15 -0700 (PDT)
Date: Fri, 31 Mar 2023 12:42:09 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Petr Mladek <pmladek@suse.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Luis Chamberlain <mcgrof@kernel.org>, david@redhat.com,
	patches@lists.linux.dev, linux-modules@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	petr.pavlu@suse.com, prarit@redhat.com, gregkh@linuxfoundation.org,
	rafael@kernel.org, christophe.leroy@csgroup.eu, tglx@linutronix.de,
	song@kernel.org, rppt@kernel.org, willy@infradead.org,
	vbabka@suse.cz, mhocko@suse.com, dave.hansen@linux.intel.com
Subject: Re: [PATCH 4/7] sempahore: add a helper for a concurrency limiter
Message-ID: <20230331034209.GA12892@google.com>
References: <20230329053149.3976378-1-mcgrof@kernel.org>
 <20230329053149.3976378-5-mcgrof@kernel.org>
 <20230329072112.GG4253@hirez.programming.kicks-ass.net>
 <ZCPuFLDgU5fBFtug@bombadil.infradead.org>
 <20230329091935.GP4253@hirez.programming.kicks-ass.net>
 <CAHk-=whF6Ta_KcJP2eC78+Mstv+vAku8ATRMbv98sf9VhdvySQ@mail.gmail.com>
 <20230330115626.GA124812@hirez.programming.kicks-ass.net>
 <CAHk-=wgF34MkhZnM_Kc1zggTWCAQ=BzEgAaAbE5wDM07bWiYeg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgF34MkhZnM_Kc1zggTWCAQ=BzEgAaAbE5wDM07bWiYeg@mail.gmail.com>

On (23/03/30 09:23), Linus Torvalds wrote:
> Although we also do have some other issues - I think down_trylock() is
> ok in irq contexts, but mutex_trylock() is not. Maybe that's why
> printk uses semaphores? I forget.

Yes, correct. IIRC we also cannot safely call mutex_unlock() from IRQ
context because it takes some internal mutex spin_lock in a non-IRQ-safe
manner. Semaphore is OK in this regard, both semaphore try_lock() and
unlock() can be called from IRQ.
