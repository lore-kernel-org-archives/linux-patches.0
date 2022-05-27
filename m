Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E127C
	for <patches@lists.linux.dev>; Fri, 27 May 2022 23:37:21 +0000 (UTC)
Received: by mail-lf1-f46.google.com with SMTP id l30so3845475lfj.3
        for <patches@lists.linux.dev>; Fri, 27 May 2022 16:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=J+HEM1XZa0sy/b3V0gcwypiEOba1ZZAFxr2ass/Bc/k=;
        b=KaiJVkdhS9GxcUZdH7TXoY1kzZIbIL0KGrXTtPH5vePuGcMbiuQz0wFdE/sZxznQXm
         Ij+X6IJxXLKGUi3PNdt1yuRitQzFbNpUTjqY6DyQybVIUFPibzEQgjH/hGp7iRdUsP24
         67agV3aZTV/fDEuduTEIOxX/V/rfUSmCcfK4oJ1wexCdLLv8boBR/OHgrC7gh0Z9JLDI
         xfoDUHMarvR4VhTQPSPoDMueMxhLIs8TKd7o5GyU90nSAN2/qYNTvhXs3xBaF4U0mqd/
         sljAlT3BpxRD+1a0WwOA7BIaEAtjPNllKi4bRd7AD6BUWfcZEze72uxYz2kImwzNXsJY
         E98A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=J+HEM1XZa0sy/b3V0gcwypiEOba1ZZAFxr2ass/Bc/k=;
        b=7TFdJF8+P3a4p0OAqNRCLIR4JfvAmRhi+I7Iz3OkZB/MgU1Zdn2E5TRMjmiuoRn88k
         lVUiXlK8QfiGpYt/FbvfeDFLsqZd0QyNXwQoP6zlyZnLpQPjflQ5OpyfSQdjK/EOEL31
         HOHr1Acz2LAvFGNSP0JQxc8t4DkgzMJNhRH3KVL9aWkuFyaVNEwyuKgZFAIPC1nQ8DEv
         kY0wh3QTIu/T9B2fKgql0n69GqONaC2ZhLXAtBTJz34nafVTrWPmJPBwJC/4OKh/GcKy
         n9DAZsmPGN0+Isn0N9NdpZm7cnd7SgdTerFEeFRlPJkQgns206lK6gAj+3TqBmnsP0lO
         FCzA==
X-Gm-Message-State: AOAM530THcNYZ/cHSIeJXr1TVYdvVlFixo5xZxjP6BFcGmaE5f0LLcBH
	ypjD5ozU46EedvzielGtniJa7A==
X-Google-Smtp-Source: ABdhPJya26gfWjXOurelttGI3jMJSVrxfCHFs3URpcAcCY2mOlGUtdts0WB3wFjgiifG5/VPAwXMmA==
X-Received: by 2002:ac2:5e73:0:b0:478:9aca:4a00 with SMTP id a19-20020ac25e73000000b004789aca4a00mr12438267lfr.394.1653694640018;
        Fri, 27 May 2022 16:37:20 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id o22-20020ac24c56000000b00477b11144e9sm1061804lfk.66.2022.05.27.16.37.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 16:37:18 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
	id 86A191094B9; Sat, 28 May 2022 02:39:15 +0300 (+03)
Date: Sat, 28 May 2022 02:39:15 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Jakub =?utf-8?Q?Mat=C4=9Bna?= <matenajakub@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, vbabka@suse.cz, mhocko@kernel.org,
	mgorman@techsingularity.net, willy@infradead.org,
	liam.howlett@oracle.com, hughd@google.com, riel@surriel.com,
	rostedt@goodmis.org, peterz@infradead.org
Subject: Re: [PATCH 1/2] [PATCH 1/2] mm: refactor of vma_merge()
Message-ID: <20220527233915.55oe6jittuogavot@box.shutemov.name>
References: <20220527104810.24736-1-matenajakub@gmail.com>
 <20220527104810.24736-2-matenajakub@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220527104810.24736-2-matenajakub@gmail.com>

On Fri, May 27, 2022 at 12:48:09PM +0200, Jakub Matěna wrote:
> Refactor vma_merge() to make it shorter and more understandable.
> Main change is the elimination of code duplicity in the case of
> merge next check. This is done by first doing checks and caching
> the results before executing the merge itself. The variable 'area' is
> divided into 'mid' and 'res' as previously it was used for two purposes,
> as the middle VMA between prev and next and also as the result of the
> merge itself. Exit paths are also unified.
> 
> Signed-off-by: Jakub Matěna <matenajakub@gmail.com>

You've ignored my ack. Or is there substantial changes that you want me to
review again?

-- 
 Kirill A. Shutemov
