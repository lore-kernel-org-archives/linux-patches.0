Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B3D21B808
	for <patches@lists.linux.dev>; Wed,  2 Sep 2026 03:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788319065; cv=none; b=XtXCmpK4gf1KjYzr1nvfDRGr23LYPTVDvEuY88QrUQfH9+DRNNDVKmTp6U2hyxXYW/kQCVDE83PvJ6NUb1cUl94oq9lz7NZefvt0t66w3W0lrzX7aNINwkquvyu6n91MmaJVJX02YXhrm4LAfTW6r6foRUtjFwlV14q74e0I75Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788319065; c=relaxed/simple;
	bh=uRgdatM8lpgXibRALPB1Q/7MF1332nK+00r7Kuztk5w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e5Ji145DeF10J0kTZsez2Ecf73ST1wquubwCuU7OhgcsUlro4tgv4sCR/PjERcAIrmnfYeKqBt7vy0MgCfcJ51radCG9sSAdsdhkiiWXsR0gQ1kO8+v3/YFgMij8peo+3D1WwEwXDZKtScWh9X04Pud0r/L0JJukKyV9uaYoORE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hZSZ55cRSzYQtny
	for <patches@lists.linux.dev>; Wed,  2 Sep 2026 11:16:45 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 43C60407B7
	for <patches@lists.linux.dev>; Wed,  2 Sep 2026 11:17:26 +0800 (CST)
Received: from [10.67.110.36] (unknown [10.67.110.36])
	by APP1 (Coremail) with UTF8SMTPA id cCh0CgCnjwpFlZdqDqq+AQ--.57637S2;
	Wed, 02 Sep 2026 11:17:26 +0800 (CST)
Message-ID: <7a6417ca-fb4c-40da-8ad1-b9d76a2fa142@huaweicloud.com>
Date: Wed, 2 Sep 2026 11:17:24 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 095/261] tracing/probes: Reject $arg0 in meta argument
 expansion
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Raushan Patel <raushan.jhon@gmail.com>,
 "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
References: <20260807143415.358597922@linuxfoundation.org>
 <20260807143417.434454264@linuxfoundation.org>
Content-Language: en-US
From: Tengda Wu <wutengda@huaweicloud.com>
In-Reply-To: <20260807143417.434454264@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgCnjwpFlZdqDqq+AQ--.57637S2
X-Coremail-Antispam: 1UD129KBjvJXoWxAw4rury5CrWfXFW8Jr17GFg_yoW5AFyDpF
	93tr9xtr1rJr48CFWj9F18CFyFy3ykJry3Wa95Jw13XF15Gr4rZr4Sga9Fq345Z3ykK3yf
	tFn0qr4UKay7ZrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUylb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAK
	I48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
	xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xII
	jxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
	67AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxU7IJmUUUUU
X-CM-SenderInfo: pzxwv0hjgdqx5xdzvxpfor3voofrz/

Hi Greg,

On 2026/8/7 22:37, Greg Kroah-Hartman wrote:
> 6.6-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Raushan Patel <raushan.jhon@gmail.com>
> 
> commit 00a8ce2a2a9fa17674e1feec4d9105c1a5d6a419 upstream.
> 
> traceprobe_expand_meta_args() parses $argN with simple_strtoul() and
> calls sprint_nth_btf_arg(n - 1, ...). For $arg0, n is 0 so the index is
> -1. Because ctx->nr_params is signed, the "idx >= nr_params" guard in
> sprint_nth_btf_arg() does not catch the negative index, and
> ctx->params[-1].name_off is read out of bounds.
> 
> The normal per-argument path (parse_probe_vars()) already rejects
> $arg0 via its argument-number check, but meta-argument expansion runs
> before per-argument parsing and substitutes the value first, bypassing
> that check.
> 
> Reject $arg0 explicitly during expansion.
> 
> Link: https://lore.kernel.org/all/20260724054435.146279-1-raushan.jhon@gmail.com/
> 
> Fixes: 18b1e870a496 ("tracing/probes: Add $arg* meta argument for all function args")
> Cc: stable@vger.kernel.org
> Signed-off-by: Raushan Patel <raushan.jhon@gmail.com>
> Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  kernel/trace/trace_probe.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> --- a/kernel/trace/trace_probe.c
> +++ b/kernel/trace/trace_probe.c
> @@ -1721,7 +1721,11 @@ const char **traceprobe_expand_meta_args
>  				ret = -ENOENT;
>  				goto error;
>  			}
> -			/* Note: $argN starts from $arg1 */
> +			/* Note: $argN starts from $arg1, so $arg0 is invalid. */
> +			if (n == 0) {
> +				trace_probe_log_err(0, BAD_ARG_NUM);
> +				return ERR_PTR(-EINVAL);

The control flow here is not quite right.

Returning directly within this branch fails to free the new_argv memory,
resulting in a memory leak.

The mainline does not have this issue because the preceding patch
4af0532a0f47 ("tracing: Use __free() in trace_probe for cleanup") introduced
__free to manage the release of new_argv memory. However, due to the extensive
changes involved, directly cherry-picking that patch does not seem to be that
straightforward.

Therefore, it might be more appropriate to simply change it to goto here:

diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 2fa7b596f03e..1f55268fbf63 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -1724,7 +1724,8 @@ const char **traceprobe_expand_meta_args(int argc, const char *argv[],
 			/* Note: $argN starts from $arg1, so $arg0 is invalid. */
 			if (n == 0) {
 				trace_probe_log_err(0, BAD_ARG_NUM);
-				return ERR_PTR(-EINVAL);
+				ret = -EINVAL;
+				goto error;
 			}
 			ret = sprint_nth_btf_arg(n - 1, type, buf + used,
 						 bufsize - used, ctx);

Thanks,
Tengda

> +			}
>  			ret = sprint_nth_btf_arg(n - 1, type, buf + used,
>  						 bufsize - used, ctx);
>  			if (ret < 0)
> 
> 


