Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4008917C68;
	Sat, 26 Oct 2024 19:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729971186; cv=none; b=XAJdgt56m+L6yVlHkkqUCnQzBGOughF5iw13oZ5qYWaT6N2ZevzjKOGF59ZGDgTUWIrlfT3cFXsvkm8lBoxsuSIghCKe0JqFl6yoohZoZ+TBXXF6qQrQrYbjCCn39YYFAnuBDCr2V9V8FehT+AqgYdEDzgA3PphRnFQfe/3fiyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729971186; c=relaxed/simple;
	bh=h1tvQN0ujSLRhRuaYe2gHgA1A5/lnDVPlmG49m6jiKA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Kv3aOOWsuDVqKekixxTbUS4qXX2D4XvjCbwfF3KKYdFr21OZNlfdDt1MyMK4UD3Wu9Z0wDfQNs8R8o5VcXBnQr0iFI+H25PmjCh7/ov/5IB1+HcS0D4deQTD6CmfbQX0h6RgE3ZhyscDOh/wR+OY7t08auRPIjWIZgrJNQVnNOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mYDOTXbD; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mYDOTXbD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
	:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=f5q5xdGBpGFSxQE99uacYmuVt6wIeZEp1bjJpFjivWo=; b=mYDOTXbDsVk0rR+Fja2VkwkzE+
	ae/yasVPCG1fSnqlsLjAWEeFbEtzaOsIPlgrTDjEZ/cv1W5cicC9HxgDRxdWh673BvLfcmEjL0ZCt
	DHjNcISnpVYB+Bu52kEI7H86fOvimKIwu5Qnxtk1VDoepJAAMHzgBwG9iB09Gkb5QziBhdy7vJ+vq
	7VWyS83CqdFu7oaSxOXiURHzl5lmmTwj7WOH8bF/cQzXW610Ofh902VdREZIMFF+iLMVUX99C0Q30
	FW0yUFDHj1PMalp9Ya4HJnmOFpRpKSuD1hcCF0nEezuJD5yFSNCZ7S87TC7HH24iw7cyiwE599XnA
	1yNxPuLA==;
Received: from [50.53.2.24] (helo=[192.168.254.17])
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t4mWt-00000009Hp1-09jX;
	Sat, 26 Oct 2024 19:32:55 +0000
Message-ID: <b7787a08-3b06-4d52-8e4b-8a82bfdbe21b@infradead.org>
Date: Sat, 26 Oct 2024 12:32:44 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] time: revert cleanup on msecs_to_jiffies()
 documentation
To: Miguel Ojeda <ojeda@kernel.org>, John Stultz <jstultz@google.com>,
 Thomas Gleixner <tglx@linutronix.de>
Cc: Stephen Boyd <sboyd@kernel.org>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>,
 Geert Uytterhoeven <geert@linux-m68k.org>, Ingo Molnar <mingo@kernel.org>,
 Nicholas Mc Guire <hofrat@osadl.org>, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
References: <20241025110141.157205-1-ojeda@kernel.org>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20241025110141.157205-1-ojeda@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/25/24 4:01 AM, Miguel Ojeda wrote:
> The documentation's intention is to compare `msecs_to_jiffies` (first
> sentence) with `__msecs_to_jiffies` (second sentence), which is what the
> original documentation did. One of the cleanups in commit f3cb80804b82
> ("time: Fix various kernel-doc problems") may have thought the paragraph
> was talking about the latter since that is what it is being documented.
> 
> Thus revert that part of the change.
> 
> Fixes: f3cb80804b82 ("time: Fix various kernel-doc problems")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
>  kernel/time/time.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/time/time.c b/kernel/time/time.c
> index 642647f5046b..e1879ca32103 100644
> --- a/kernel/time/time.c
> +++ b/kernel/time/time.c
> @@ -558,7 +558,7 @@ EXPORT_SYMBOL(ns_to_timespec64);
>   *   handling any 32-bit overflows.
>   *   for the details see __msecs_to_jiffies()
>   *
> - * __msecs_to_jiffies() checks for the passed in value being a constant
> + * msecs_to_jiffies() checks for the passed in value being a constant
>   * via __builtin_constant_p() allowing gcc to eliminate most of the
>   * code, __msecs_to_jiffies() is called if the value passed does not
>   * allow constant folding and the actual conversion must be done at
> 
> base-commit: 42f7652d3eb527d03665b09edac47f85fb600924

-- 
~Randy

