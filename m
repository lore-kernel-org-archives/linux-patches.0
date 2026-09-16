Received: from mail-pj2-f39.google.com (mail-pj2-f39.google.com [74.125.227.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458884AA400
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 22:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789598721; cv=none; b=smtZ5FB6FJ5nn8v7UiEVbg5i+vsaJP9IzgQnLDeGc1i62M8LqwBL2Kwel0J+3sOD6g8GnD5Y0cIeG1yNf22yVQ4QdHBxX6m6RkSF6/vbTtYJo4QtSPNimRykNpJkiNGJRmYJmpu1wMfychwb73Ck2LhFdp+TUuBIetIzM3cJAjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789598721; c=relaxed/simple;
	bh=DCE6FnvywonaznENZKMO/6ORfAMl58VppAg00A7jaiw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HymHwKjGhKnWhzqGhh4nq9SH3jRJubFWj+J2Fn/KBG0d1A5+PVcD7ByxpgjetoeK+pZoW9aHZu/QiXBevvZwi7fw3wPSqQ6yyRmymxOP4/P2lsg6T947P7nJpp8QzjstRpneNXANd31sYzagVDnmbE+nlF+AkwoTLjTrzggdFdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bzQ8/G1y; arc=none smtp.client-ip=74.125.227.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bzQ8/G1y"
Received: by mail-pj2-f39.google.com with SMTP id d9443c01a7336-2d8fe517774so2828145ad.0
        for <patches@lists.linux.dev>; Wed, 16 Sep 2026 15:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789598713; x=1790203513; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HodbLW2WeOC+F5Igytr4/ZR9Af1xRSrYgRD/3purchM=;
        b=bzQ8/G1ydfUGUJ5r0OBkJDJ4OkGNIKR967IkbkvuQNlPwy/VQjfaTs+VNnUgnMh4Zq
         O+vBVeFP36CvBh/rtiCXSAsWeZACf8JRjXjBimcrpeY2Oj3pU7StBSXLuBnKqZLFd5u8
         wwmPPJZ+SVUG29XoPSf3tR3hjLclUKRD1fS2arbT9ebCj5O2RhOmpMeMwzRLyqAQoM+E
         E3BzbmVVqEH2W2NqOy1mhiAdlHzYNMmakIfq98QUE7WKXHfl5KYhOOLMUORIYMqaIMtw
         chX7L6HsX7mb3DbSBTOePtj9DimfChCyIY00cOCddJ8OXw6wixXWxDXgTItQbe3IegiN
         hnCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789598713; x=1790203513;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HodbLW2WeOC+F5Igytr4/ZR9Af1xRSrYgRD/3purchM=;
        b=oo8dquG4I3GhU80TKSmX1cbuhXD1vggOVUV4PChotGyERtMKRwUDbek5qkdZQMZNa1
         HfhK9QLAVkMbQf7PoapnIkyjy+JLIqNBm2z9zB1MuiJZE4H/B9qpov2ELBRH/yJVj8SM
         MWKa3NQWLU0MzPxsaagFqKNny1dqzu4GtFEbop6fxZatvqxVycwIFUTFMK43uCIsu9gh
         KZskG22iIIdsVtH6WpZRDgS7ncE0ZnQt2NEqemSfbHxXfqM9V4aTunNV9JxtzkYpNd1d
         GCWIQQSdciMsfzxzZ1pUZh1DGkWbYvZMH3Isu2Sya8uuVbuiGQVYHBxBnOFFqNRp0TYV
         sx3Q==
X-Forwarded-Encrypted: i=1; AKwUvBzoo30vubK8Qnqh92KNxuFiNs1WkfJsiA852IbUHm0BCw/HQc9Ros63CHBUC3phcONKijgld+UH@lists.linux.dev
X-Gm-Message-State: AFuF++nFnwnKU1oAwyRsRyf9pcHkSyCAy4zZUyu0/r7pMneyd47qoAMw
	1dcfKwxGx+IMV1K2BFOl6yiUbK2go63E9s++nqUu01Pb7XIWj4dy84yo
X-Gm-Gg: AYBFou0JybWHTYn0W+2eCVSYCOoSIKypJzvp3xiDo9FF6d7+MGeWdFWeVQv3bNXWIKH
	1qQ5qa0etYdUHKDoUe0qtYJCmb+nygKcKQ1vK/MH/KQ/Eon03Pr59a77PbgZILP6+rKsoUjyP9U
	6dy8x8TFQ9ck6K7sksdFJYnDJmrB9jF/20PlW00vjJO+cuVwNiMaP2TAnXMrdgF6r148rgTbJRR
	OipESFfbHN+klqbFtVhpIzxuzQrXRlt04zm2rXJYG2GFua2QsBFCiKxujhguRzu3B87ijekkZ/V
	qGIfeObdSRqd75AGFASvC9mJBrntDY8C76B48vLQa3qx2B372X04s+cUh6qKIq1aqUEC2FqDiU7
	fjb17qIBWx5kIrfvpTA5U0/+ZMHr4di5mFqSrJDADMmiANw8c/JJrQOHGFmaYJczkYbcLnzwj5i
	gBrKqtlcdOaBY3nUOMZCWh31dUZAGVJb94TBHpKgyOEQ8NT895ovPdptz9UfycmxSrYoyqiwb2R
	0mVkiQB1SrL/7diL/7qJ1+NMLkjQqodMSGa4PAz3p/CLExs4qsGO0iIfJgXBakNsITbjI6pxc7B
	NIeFyYi8Td1EbdzexBkiTPGHJ5wiv6+prW59Xgdm/LqW2jbRYp1xX+YQ
X-Received: by 2002:a17:902:ce81:b0:2dd:64:12ac with SMTP id d9443c01a7336-2dd8e632d3bmr86301035ad.11.1789598712717;
        Wed, 16 Sep 2026 15:45:12 -0700 (PDT)
Received: from Cyndaquil.localdomain (c-24-56-233-47.customer.broadstripe.net. [24.56.233.47])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd89d8e6a3sm17609805ad.7.2026.09.16.15.45.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 15:45:12 -0700 (PDT)
Date: Wed, 16 Sep 2026 15:45:09 -0700
From: Mitchell Levy <levymitchell0@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Tianyou Li <tianyou.li@intel.com>,
	Namhyung Kim <namhyung@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.18 1481/1518] perf annotate: Fix build with NO_SLANG=1
Message-ID: <aqsb9cc0sIUtI265@Cyndaquil.localdomain>
References: <20260912065623.398859879@linuxfoundation.org>
 <20260912065657.062881527@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260912065657.062881527@linuxfoundation.org>

On Sat, Sep 12, 2026 at 09:00:50AM +0200, Greg Kroah-Hartman wrote:
> 6.18-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Namhyung Kim <namhyung@kernel.org>
> 
> [ Upstream commit 0e6c07a3c30cdc4509fc5e7dc490d4cc6e5c241a ]
> 
> The recent change for perf c2c annotate broke build without slang
> support like below.
> 
>   builtin-annotate.c: In function 'hists__find_annotations':
>   builtin-annotate.c:522:73: error: 'NO_ADDR' undeclared (first use in this function); did you mean 'NR_ADDR'?
>     522 |                         key = hist_entry__tui_annotate(he, evsel, NULL, NO_ADDR);
>         |                                                                         ^~~~~~~
>         |                                                                         NR_ADDR
>   builtin-annotate.c:522:73: note: each undeclared identifier is reported only once for each function it appears in
> 
>   builtin-annotate.c:522:31: error: too many arguments to function 'hist_entry__tui_annotate'
>     522 |                         key = hist_entry__tui_annotate(he, evsel, NULL, NO_ADDR);
>         |                               ^~~~~~~~~~~~~~~~~~~~~~~~
>   In file included from util/sort.h:6,
>                    from builtin-annotate.c:28:
>   util/hist.h:756:19: note: declared here
>     756 | static inline int hist_entry__tui_annotate(struct hist_entry *he __maybe_unused,
>         |                   ^~~~~~~~~~~~~~~~~~~~~~~~
> 
> And I noticed that it missed to update the other side of #ifdef
> HAVE_SLANG_SUPPORT.  Let's fix it.
> 
> Cc: Tianyou Li <tianyou.li@intel.com>
> Fixes: cd3466cd2639783d ("perf c2c: Add annotation support to perf c2c report")
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This appears to be the same patch from [1] that was previously dropped.
With this patch applied, I'm seeing the same build error as Jiri Slaby
did on the linked thread when !HAVE_SLANG_SUPPORT.

For now I've reverted this commit, but I wanted to surface this upstream
as well.

Thanks,
Mitchell

[1]: https://lore.kernel.org/all/2025121754-breeching-aftermost-d10a@gregkh/

