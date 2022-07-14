Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D467E
	for <patches@lists.linux.dev>; Thu, 14 Jul 2022 21:00:24 +0000 (UTC)
Received: by mail-qk1-f172.google.com with SMTP id o21so2174693qkm.10
        for <patches@lists.linux.dev>; Thu, 14 Jul 2022 14:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=yIg/KVaLEuC2RtyiuXSCOyIm3fgZQfPCt7jLgzFy4VQ=;
        b=W8/8ApiW6CvDLhzVE6KCkN+YGDCLOhHeE16LhyAbzGVAm2MbsJkTIZp5/jHlbk4beZ
         /S5fsLRl1y61d++xUsXHaeC2WZFjESOfT/13Fhicxw2gXEUUxiFr4YPyJ4yfyoJEpTxH
         fkbnttXJ3OHy0MRJ9H+pcmdR8rtDgiEwjcZGA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=yIg/KVaLEuC2RtyiuXSCOyIm3fgZQfPCt7jLgzFy4VQ=;
        b=l6y/WuXMsgogbAiH7aFw0Mo+Gq4S1+n+q7mHWa2ZASiGR7xIT+ePHRewRw32wwEw1Z
         vIWO6Cqw6taKC2gNYXG8GFusO1etD40bq0oreTpocwALiIlNHRaATLEBuvgsxdISnmuB
         XMt0Jf6bUeMB/nWUlXvffdO2wL8ZcRUx+G+jDvb+iDjdxubuHHrlNy2Dcv9XoGPI54q0
         /H310X6veme9nWFTbqx+3o9fcpN2i22Rbj/iGyOftwmOq4UgPvWVQObgCuSnJELXFsPN
         rrKJDtljdif9XItNL39T/bjcWc+c4GyXda7OIrfpzlr5VuMVs1OVsp6w92brxsIMfrNk
         /8Sg==
X-Gm-Message-State: AJIora+4CyjWZdiBweRsF9ybYnthF811JsvuPR4LrgwtnbzG1e2041T6
	R4IXQ8K5gdw8LQVrRPgOsVzixDCQ6+7WWQ==
X-Google-Smtp-Source: AGRyM1uVq1kfO8BfEqWLqPNHyDuMsNLKU+jlnky1smT4niNG5jac/QAxhdm/XgbJJFRAZ0jlJJWGVA==
X-Received: by 2002:a05:620a:c8e:b0:6b5:91da:9b04 with SMTP id q14-20020a05620a0c8e00b006b591da9b04mr7382295qki.25.1657832423127;
        Thu, 14 Jul 2022 14:00:23 -0700 (PDT)
Received: from meerkat.local (bras-base-mtrlpq5031w-grc-30-209-226-106-245.dsl.bell.ca. [209.226.106.245])
        by smtp.gmail.com with ESMTPSA id k11-20020a05620a0b8b00b006a6b374d8bbsm2155104qkh.69.2022.07.14.14.00.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 14:00:22 -0700 (PDT)
Date: Thu, 14 Jul 2022 17:00:21 -0400
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc: patches@lists.linux.dev
Subject: Re: [PATCH WIP v1 3/3] Add myself as ultimate maintainer
Message-ID: <20220714210021.37u4qxvejcsjuvql@meerkat.local>
References: <20220707-my-new-branch-v1-0-8d355bae1bb5@linuxfoundation.org>
 <20220707-my-new-branch-v1-3-8d355bae1bb5@linuxfoundation.org>
 <b49b97df-8051-ea88-dfa7-5c64f611a10f@gnuweeb.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b49b97df-8051-ea88-dfa7-5c64f611a10f@gnuweeb.org>

On Fri, Jul 15, 2022 at 03:02:54AM +0700, Ammar Faizi wrote:
> Tested-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Nice:

    $ b4 submit --sync-trailers
    Calculating patch-ids from 3 commits
    Checking change-id "20220707-my-new-branch-1325e0e7fd1c"
    Grabbing search results from lore.kernel.org
    ---
      Add myself as ultimate maintainer
        + Tested-by: Ammar Faizi <ammarfaizi2@gnuweeb.org> (✓ DKIM/gnuweeb.org)
    ---
    Invoking git-filter-repo to update trailers.
    New history written in 0.03 seconds...
    Completely finished after 0.27 seconds.
    Trailers updated.

Now I just need to add --reroll and open it up for wider testing.

-K
