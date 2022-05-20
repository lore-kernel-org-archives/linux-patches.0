Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E0A7A
	for <patches@lists.linux.dev>; Fri, 20 May 2022 13:26:09 +0000 (UTC)
Received: by mail-lf1-f43.google.com with SMTP id bq30so14349765lfb.3
        for <patches@lists.linux.dev>; Fri, 20 May 2022 06:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=/1UN+TaMaEHcux1d6IJ2KDdfHYHO4F5ExU+odphW0WU=;
        b=duNEHjCO0S0AOhMSt8aOd7DDMhxLHCQYK4g5GNHpXgS79y73DaQzAHn91LKMBCeOgD
         1ZCPBLge3Cn96dQLOkEBsSLL8tRzqmO3sGp3nbRNnSbFVVEe05nol/Ts0rtg+UAT5qf9
         KrNsl2YTbt0ua/0c/1wDITK3tAgfp6sVbaMT/a5Z5VnEQvz8Oiu5GqFx3STskU1zBxBj
         WAOOE/4pBlOlTxjiZHB9p7CsDOnB+gRVfv5zGcBZsLKkBGcQE8O7ImKGFxpuI6e/D3tb
         3gHeJLsT5Hvg9DpkdOoOJfn7w5twy49l2wvF9yWDtJfERc9MdiKHDpnN+gWxhwOaosHA
         xfbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=/1UN+TaMaEHcux1d6IJ2KDdfHYHO4F5ExU+odphW0WU=;
        b=Xc/mPKSqlwAP7H5Oht3545JTnqVG3le3S6mWNX+UVFFbDkaPLQOSajFwNAKf3W5GSz
         nZnQEKxPVqcoMmzZEx0Ke6XVIKIGw0sptrNUn2aV4+hluwl/FxZeU1xcrhYqU9FBQ8RS
         bOE+CQPlm3T/ReWRIwPMqyUQaJvp8v5EV28pfWjdB3hqrNCboiyRLvCcLyQew4D9V8G8
         WwKMgmBdzNJE5PAhaggaPL0wEByOZVBTb+mYI/sqjCluypMx6Av2aslGB2Y41TslRcOb
         N+xCQiFhnZvX15dcEfiX1OO8kY7JhjnogNFq2xFaAIEnIZ54gGn0/4BeKQDVHpQGy2L3
         5W9Q==
X-Gm-Message-State: AOAM530Ea2EoNDSHWurCMj0KISIL+n72oF8G1UhyKa4Bo86HGgauTR5j
	DKIhTA76GKo38LndXFuSqg1dPA==
X-Google-Smtp-Source: ABdhPJwzB3/PlRlrkNXbK7mwUivWQKZ0qAFrQcRwuovyF2EoriPwqD771ALNFGv+zdxasA/ruuX6Zg==
X-Received: by 2002:a05:6512:10cf:b0:473:b735:4fae with SMTP id k15-20020a05651210cf00b00473b7354faemr6947736lfg.93.1653053167466;
        Fri, 20 May 2022 06:26:07 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id o3-20020ac24e83000000b0047794db1ffasm659901lfr.237.2022.05.20.06.26.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 06:26:06 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
	id 61396104AAB; Fri, 20 May 2022 16:28:00 +0300 (+03)
Date: Fri, 20 May 2022 16:28:00 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Jakub =?utf-8?Q?Mat=C4=9Bna?= <matenajakub@gmail.com>
Cc: linux-mm@kvack.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, vbabka@suse.cz, mhocko@kernel.org,
	mgorman@techsingularity.net, willy@infradead.org,
	liam.howlett@oracle.com, hughd@google.com, riel@surriel.com,
	rostedt@goodmis.org, peterz@infradead.org, david@redhat.com
Subject: Re: [RFC PATCH v3 1/6] [PATCH 1/6] mm: refactor of vma_merge()
Message-ID: <20220520132800.hijytnlyjqeesjfj@box.shutemov.name>
References: <20220516125405.1675-1-matenajakub@gmail.com>
 <20220516125405.1675-2-matenajakub@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220516125405.1675-2-matenajakub@gmail.com>

On Mon, May 16, 2022 at 02:54:00PM +0200, Jakub Matěna wrote:
> Refactor vma_merge() to make it shorter, more understandable and
> suitable for tracing of successful merges that are made possible by
> following patches in the series. Main change is the elimination of code
> duplicity in the case of merge next check. This is done by first doing
> checks and caching the results before executing the merge itself. Exit
> paths are also unified.
> 
> Signed-off-by: Jakub Matěna <matenajakub@gmail.com>

Okay, this looks good:

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

I would also consider renaming 'area' to 'vma'. 'area' feels wrong to me,
but maybe it is only me.

-- 
 Kirill A. Shutemov
