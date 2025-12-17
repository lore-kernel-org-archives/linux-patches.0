Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C51A2BEFFB;
	Wed, 17 Dec 2025 09:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765964578; cv=none; b=tgmTXLIZbrFUSyF8Y3Eqm2g/sdO9Tn9S9RmZBGY8+Fj+exWwgmH4/np5nawiBN7FM2j9i+t2474HezLjPkE9Jkn5+T37iHKnY41wUU3OaaFVxJspFZeOUm6VwxdJ49QIwefTYAGdM/4xWixKk+1CoZ/Sm6kp/mleEyUpRRyKQBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765964578; c=relaxed/simple;
	bh=STrvD8J20okz2S7mubYnGdCz/fGgovpVdE6Vgo0vRGE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jkkr5yjXulhAjzByrFPxbm8QgwSx5O3DJKZTfJviKXJY1/b+du+Dp4R04OIpgm6w4MVV9r6Adpo6d/8b8/CDjoWFG2qkkDzCT0xP72PfnwDXtieCeQ+mnPn1mJDnCYvuhTf8Jktuw1azU+dF85CiKauAYxfpuOntDFY/KPv/B9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bjBlE7VC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bjBlE7VC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 712F2C4CEF5;
	Wed, 17 Dec 2025 09:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765964577;
	bh=STrvD8J20okz2S7mubYnGdCz/fGgovpVdE6Vgo0vRGE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bjBlE7VC13WaxmgfK1sXplA0B0M58TxJsjS7FsDyGh7qs5CTI3BDmtTD32MQG0Eni
	 29UqNJGJi3HaDfM2m5MKxPIcEfby+haJgIINX+VuMxqji2FoTC4Yyj3LEEP2WMhJnG
	 pRPJyBKvVnvlzYO+EUlkaux9QKUMw/zoYJySZyGBHNmY/mAC6fI89IRTld46L2VRNM
	 7jWIsxrtNYl68VA+6auB/n2Ah1/LzXyqDQPKWzERD9Xt9Hmpf+XYuuAjh5F1PET9u0
	 ve+MZ7u3X+xN+c7iKvgv4JLDcs1YPfqi1tkcdIOuFy1jiZ8DZg8pZ1MnUFUp15Goj6
	 n4wmUAAw43D+Q==
Message-ID: <25751506-e4df-4ae3-9ea8-4b2800146ba2@kernel.org>
Date: Wed, 17 Dec 2025 10:42:54 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 215/614] perf annotate: Fix build with NO_SLANG=1
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Tianyou Li <tianyou.li@intel.com>,
 Namhyung Kim <namhyung@kernel.org>, Sasha Levin <sashal@kernel.org>
References: <20251216111401.280873349@linuxfoundation.org>
 <20251216111409.165603959@linuxfoundation.org>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <20251216111409.165603959@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 16. 12. 25, 12:09, Greg Kroah-Hartman wrote:
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
>    builtin-annotate.c: In function 'hists__find_annotations':
>    builtin-annotate.c:522:73: error: 'NO_ADDR' undeclared (first use in this function); did you mean 'NR_ADDR'?
>      522 |                         key = hist_entry__tui_annotate(he, evsel, NULL, NO_ADDR);
>          |                                                                         ^~~~~~~
>          |                                                                         NR_ADDR
>    builtin-annotate.c:522:73: note: each undeclared identifier is reported only once for each function it appears in
> 
>    builtin-annotate.c:522:31: error: too many arguments to function 'hist_entry__tui_annotate'
>      522 |                         key = hist_entry__tui_annotate(he, evsel, NULL, NO_ADDR);
>          |                               ^~~~~~~~~~~~~~~~~~~~~~~~
>    In file included from util/sort.h:6,
>                     from builtin-annotate.c:28:
>    util/hist.h:756:19: note: declared here
>      756 | static inline int hist_entry__tui_annotate(struct hist_entry *he __maybe_unused,
>          |                   ^~~~~~~~~~~~~~~~~~~~~~~~
> 
> And I noticed that it missed to update the other side of #ifdef
> HAVE_SLANG_SUPPORT.  Let's fix it.
> 
> Cc: Tianyou Li <tianyou.li@intel.com>
> Fixes: cd3466cd2639783d ("perf c2c: Add annotation support to perf c2c report")

That fixes line ^^^ appears to be wrong, as now I see:
builtin-annotate.c: In function ‘hists__find_annotations’:
builtin-annotate.c:522:10: error: too few arguments to function 
‘hist_entry__tui_annotate’
     key = hist_entry__tui_annotate(he, evsel, NULL);
           ^~~~~~~~~~~~~~~~~~~~~~~~
In file included from util/sort.h:6:0,
                  from builtin-annotate.c:28:
util/hist.h:757:19: note: declared here
  static inline int hist_entry__tui_annotate(struct hist_entry *he 
__maybe_unused,
                    ^~~~~~~~~~~~~~~~~~~~~~~~




Because in util/hist.h, we now have:
int hist_entry__tui_annotate(struct hist_entry *he, struct evsel *evsel,
                              struct hist_browser_timer *hbt);
...
static inline int hist_entry__tui_annotate(struct hist_entry *he 
__maybe_unused,
                                            struct evsel *evsel 
__maybe_unused,
                                            struct hist_browser_timer 
*hbt __maybe_unused,
                                            u64 al_addr __maybe_unused)
{
         return 0;
}



Was it meant to be
Fixes: ad83f3b7155d perf c2c annotate: Start from the contention line
?

> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   tools/perf/util/hist.h | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
> index c64005278687c..a4f244a046866 100644
> --- a/tools/perf/util/hist.h
> +++ b/tools/perf/util/hist.h
> @@ -709,6 +709,8 @@ struct block_hist {
>   	struct hist_entry	he;
>   };
>   
> +#define NO_ADDR 0
> +
>   #ifdef HAVE_SLANG_SUPPORT
>   #include "../ui/keysyms.h"
>   void attr_to_script(char *buf, struct perf_event_attr *attr);
> @@ -746,14 +748,16 @@ int evlist__tui_browse_hists(struct evlist *evlist __maybe_unused,
>   static inline int __hist_entry__tui_annotate(struct hist_entry *he __maybe_unused,
>   					     struct map_symbol *ms __maybe_unused,
>   					     struct evsel *evsel __maybe_unused,
> -					     struct hist_browser_timer *hbt __maybe_unused)
> +					     struct hist_browser_timer *hbt __maybe_unused,
> +					     u64 al_addr __maybe_unused)
>   {
>   	return 0;
>   }
>   
>   static inline int hist_entry__tui_annotate(struct hist_entry *he __maybe_unused,
>   					   struct evsel *evsel __maybe_unused,
> -					   struct hist_browser_timer *hbt __maybe_unused)
> +					   struct hist_browser_timer *hbt __maybe_unused,
> +					   u64 al_addr __maybe_unused)
>   {
>   	return 0;
>   }

-- 
js
suse labs

