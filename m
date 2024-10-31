Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66AA2823D1;
	Thu, 31 Oct 2024 01:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730339941; cv=none; b=H4tHyjL3RqolM3XXLPWzNpwITIZ90Z714MP8T3eICiPBV3g9efA8/69VwAHIQSevkKxJIuQWkv/ec5XFmB0m766mlQX+lAeuWRtF1GnLL1Tp/5qnnT79T08taQozTBlBWURRUyStuPR1T1/NuBp2IZnogwKhsTPUaja/3NsFrq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730339941; c=relaxed/simple;
	bh=ZshjuPjqLkToNERmxK+afu2pEYJV/tJCEPHg3M5Jeyk=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=Ta2oBXDmu4nM5QOS8dYxosXgjminU+Pn7RA8hZFvagWrvaloDJAn8rF/IsBSfFRt0Pbwt/MlmSKOgcPiL8owAY5+ZE8c9zScylRTRul5o0g9iWDZLWNk25Y9yHKZbvurcEPHAaH9LeBivMWecD8zRVUCUMxq1DzZ9rLF+LRaNlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=klAsBjv8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="klAsBjv8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38E63C4CECE;
	Thu, 31 Oct 2024 01:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730339940;
	bh=ZshjuPjqLkToNERmxK+afu2pEYJV/tJCEPHg3M5Jeyk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=klAsBjv8rYZyJa+gA2bSXseUHsCXFsivGnJFC9PEh3h0ZMnBXHOtKfoZTpOxAhCSE
	 TBQWIF+tmcdVgWoVoguO3Nxwu2rhJzyB3pc9SkNYIPZKZO3nGgnhrC2aH2AwsiH9KS
	 RcJebV61F+UjSUvy34g+kjlz63JZRutaXLS+/ukLgYDW/23i65tUxOXmnQ5khMx4Qi
	 aWuEaW1QupsDCHjolwXlL7yKEpuwsL8VYTvSw/0w+WqMetYjhZwPTFAA/QXlE3QsUJ
	 09WY5rzNvIrUSxsUYInoqxPRn+6TN13cffUDIhNsRNCRHGHZto0EqABayufKHq3NYM
	 DUbCYntMaYP3Q==
Date: Thu, 31 Oct 2024 10:58:55 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Naveen N Rao <naveen@kernel.org>, Anil S Keshavamurthy
 <anil.s.keshavamurthy@intel.com>, "David S. Miller" <davem@davemloft.net>,
 Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 Jinjie Ruan <ruanjinjie@huawei.com>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
 patches@lists.linux.dev
Subject: Re: [PATCH 2/2] kprobes: Use struct_size() in __get_insn_slot()
Message-Id: <20241031105855.6d88db454041f3cbd9723aab@kernel.org>
In-Reply-To: <20241030-kprobes-fix-counted-by-annotation-v1-2-8f266001fad0@kernel.org>
References: <20241030-kprobes-fix-counted-by-annotation-v1-0-8f266001fad0@kernel.org>
	<20241030-kprobes-fix-counted-by-annotation-v1-2-8f266001fad0@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 30 Oct 2024 09:14:49 -0700
Nathan Chancellor <nathan@kernel.org> wrote:

> __get_insn_slot() allocates 'struct kprobe_insn_page' using a custom
> structure size calculation macro, KPROBE_INSN_PAGE_SIZE. Replace
> KPROBE_INSN_PAGE_SIZE with the struct_size() macro, which is the
> preferred way to calculate the size of flexible structures in the kernel
> because it handles overflow and makes it easier to change and audit how
> flexible structures are allocated across the entire tree.
> 

But I like this patch. I'll pick this.

Thank you!


> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  kernel/kprobes.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index 2cf4628bc97ce2ae18547b513cd75b6350e9cc9c..d452e784b31fa69042229ce0f5ffff9d8b671e92 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -95,10 +95,6 @@ struct kprobe_insn_page {
>  	char slot_used[] __counted_by(nused);
>  };
>  
> -#define KPROBE_INSN_PAGE_SIZE(slots)			\
> -	(offsetof(struct kprobe_insn_page, slot_used) +	\
> -	 (sizeof(char) * (slots)))
> -
>  static int slots_per_page(struct kprobe_insn_cache *c)
>  {
>  	return PAGE_SIZE/(c->insn_size * sizeof(kprobe_opcode_t));
> @@ -177,7 +173,7 @@ kprobe_opcode_t *__get_insn_slot(struct kprobe_insn_cache *c)
>  		goto retry;
>  
>  	/* All out of space.  Need to allocate a new page. */
> -	kip = kmalloc(KPROBE_INSN_PAGE_SIZE(num_slots), GFP_KERNEL);
> +	kip = kmalloc(struct_size(kip, slot_used, num_slots), GFP_KERNEL);
>  	if (!kip)
>  		goto out;
>  
> 
> -- 
> 2.47.0
> 


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>
