Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32F87C
	for <patches@lists.linux.dev>; Wed,  6 Jul 2022 09:24:16 +0000 (UTC)
Received: by mail-ej1-f44.google.com with SMTP id g26so26012477ejb.5
        for <patches@lists.linux.dev>; Wed, 06 Jul 2022 02:24:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mH3EsXz6QKYwAcafuhaDfR4s9oNm5ypp5DWlodyKTRg=;
        b=T2E05GBaGL/11rGkmcjP8ofYsha1Lg1NrGjhf6Vf6PTqLFE1sxhfYNGxKRyCaym7zt
         7Cqy83eanVyRZ3X+FBg+xvSAC4LlkRn4bnPxuCe8rqoO9N3rwoA8jGPx6R7LlR4HY8ZX
         K1+DpaK1ni2AqrjsGHjcPKXusGVUho0vbdAoRe0vmruxy3c+UrOK5bMxZ60uMSGHgkZ1
         CNrR300sNqAAb2KamGxILiztzoP6sLO7e8kO9T4Yx81h0JzOFzK5+sj6GmAdmMjvOtKr
         KzmCpnF3KgmBiu8gEcb/VKPj17cD1M0XqFnXR9R58KkQqsExDINO3zUTauu5WDfxlQOk
         GGzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mH3EsXz6QKYwAcafuhaDfR4s9oNm5ypp5DWlodyKTRg=;
        b=xJ6bG5CZDi33gyff3SWxvfOD+Xs0NzztUakJ0yI9UBMA6ttO7TIF0amRGGKt5oJY2D
         jXw7HRUPV2AKnFARPvU9Z0Ke76Hpyreb4QeK9Kdi3P46Qtj1Pv6UxbJtzf2iItf6vdtP
         brzgK88ShGDnxf4Ys7fUus7QSKSV2jwbZYESCozvztL1jqy0PEbISIwdziCfyn3JtdnZ
         0gnvJGEZ3L60yxioKwPIHCJ+mtYRGUGvk6Zrl75AkKpjt7zs74pdyK6AmAYPRS2q/Tbf
         8HIPkY6BQbIN/YEfeV18BrjD/smRdtsZ1ZI2Uy6lTpwSFmexWYXsAOT+uXInVV2Q+usz
         epww==
X-Gm-Message-State: AJIora97nQ7MaToj4kk05K1RwHw5PgOyz7zkqUcCt3kh6sH6xPZyCTuU
	zHbBkLGO6PdaYLwUbdAgcQ==
X-Google-Smtp-Source: AGRyM1vHsjMQWhvXLrUH9P2YfOB8CTmQmNkcv3PLEUqJjzfaQBpZuSMiCotecRvuygXLLFWawjsfpA==
X-Received: by 2002:a17:906:2bc2:b0:726:d02f:dea with SMTP id n2-20020a1709062bc200b00726d02f0deamr38414559ejg.60.1657099455050;
        Wed, 06 Jul 2022 02:24:15 -0700 (PDT)
Received: from localhost.localdomain ([46.53.251.51])
        by smtp.gmail.com with ESMTPSA id u5-20020a170906068500b00703671ebe65sm16937724ejb.198.2022.07.06.02.24.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 02:24:14 -0700 (PDT)
Date: Wed, 6 Jul 2022 12:24:12 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Mark Hemment <markhemm@googlemail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	the arch/x86 maintainers <x86@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, patrice.chotard@foss.st.com,
	Mikulas Patocka <mpatocka@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>, Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Hugh Dickins <hughd@google.com>, patches@lists.linux.dev,
	Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
	Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH -final] x86/clear_user: Make it faster
Message-ID: <YsVUvK/zQaIW749P@localhost.localdomain>
References: <CAHk-=whCmmipbBDips0OJ=UiBUjZfgBGYruoOsqcq2TVd5kBSA@mail.gmail.com>
 <YnqqhmYv75p+xl73@zn.tnic>
 <Ynq1nVpu1xCpjnXm@zn.tnic>
 <YozQZMyQ0NDdD8cH@zn.tnic>
 <YrMlVBoDxB21l/kD@zn.tnic>
 <CAHk-=wgmOfipHDvshwooTV81hMh6FHieSvhgGVWZMX8w+E-2DQ@mail.gmail.com>
 <YrN4DdR9HN0srNWe@zn.tnic>
 <CAHk-=wj_MeMUnKyRDuQTiU1OmQ=gfZVZhcD=G7Uma=1gkKkzxg@mail.gmail.com>
 <YrQ1PPB77PBWyaHs@zn.tnic>
 <YsRuUl24zkhpE3s/@zn.tnic>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YsRuUl24zkhpE3s/@zn.tnic>

On Tue, Jul 05, 2022 at 07:01:06PM +0200, Borislav Petkov wrote:

> +	asm volatile(
> +		"1:\n\t"
> +		ALTERNATIVE_3("rep stosb",
> +			      "call clear_user_erms",	  ALT_NOT(X86_FEATURE_FSRM),
> +			      "call clear_user_rep_good", ALT_NOT(X86_FEATURE_ERMS),
> +			      "call clear_user_original", ALT_NOT(X86_FEATURE_REP_GOOD))
> +		"2:\n"
> +	       _ASM_EXTABLE_UA(1b, 2b)
> +	       : "+&c" (size), "+&D" (addr), ASM_CALL_CONSTRAINT
> +	       : "a" (0)
> +		/* rep_good clobbers %rdx */
> +	       : "rdx");

"+c" and "+D" should be enough for 1 instruction assembly?
