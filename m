Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9A71E0B73
	for <patches@lists.linux.dev>; Tue,  7 Jan 2025 08:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736239909; cv=none; b=mEUj8LKYQ+W1r2MVEMhIFB7Hr83MlmxncFoBcYVUd0SCyugoQym4+g1DZLDzmoxW1N4CelyeEeH4g9PnefvJKL9GdTprR8urTh0jvhOVxBIk3+71PM7PxAXDagYxYDY0YEtwTJNasNVXsyHddUpDADoCixx5Dr5N9eeZPTsczH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736239909; c=relaxed/simple;
	bh=6aHPkVRSld10/ZLBMT33VvIMpAPlAQRb5b5nRaz2hdM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j8U67ZG0nBwWFhc+cz6FH/QaIs+ih5FRcFHBH3MO/y06qA9RH6/S/32HP+BsOi/3IQFxIpCXeJRoLWXFe7ixlIONcjQAi8yM1/k3+rvA/NvWcnhc7hGjR/EnDBULDvxayfLiq2r6CYE4BXoThJmdNSo0OVzbZJdlbX5KZVDWksI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=gl3j9FDj; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="gl3j9FDj"
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 68E6F3F846
	for <patches@lists.linux.dev>; Tue,  7 Jan 2025 08:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1736239903;
	bh=0sU83y1dsztIjs1YS1vlseJqtDmQU0LMIMsCceg3sQk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:In-Reply-To;
	b=gl3j9FDjlDj7dsalvp4nvGLc9xNTavxg0+1PRkLxsvWORgb3xqOnI6joUzbxMidKb
	 kdTasB0N9/b8pLi2wcTonYax+lcV+HjR8yvkj4yUumv+tAJ6vXpXYApPoNjmmZ+bcp
	 pOVGOkBAHFOiVdBWBvLMU0pUVk/C2jJ8inxyggfXnYaxYPIrgWtINb3W3Fo8UkZzJf
	 lmKVmlf2AfpKUjGqORL78uj++ViIAEKVFz89xQaFyW7v2MUP+1f68NTpLwyjyV5PIR
	 Ht7+iz1HN1OySCx+UaQcXVQV1HOOb9OcWbjq08C5wEoZaDeSvEWpHUijBMBLpbr7LK
	 N+sDQZo7nyD9w==
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-216311faa51so214504395ad.0
        for <patches@lists.linux.dev>; Tue, 07 Jan 2025 00:51:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736239899; x=1736844699;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0sU83y1dsztIjs1YS1vlseJqtDmQU0LMIMsCceg3sQk=;
        b=oyH21ON3g0PLe2dYsl+x7giT43XEjZtcoEpS7cwh3tD1oW/l8j1SUX/QRr7v2zLgYz
         /nXwlCrpfMPwOk2fpI7E2BUdwvcRpWPZ//xnhLQpPOCGr43IIiF9fGzb1JxbaP2rJxks
         NF8W3G8izr9+ptL2O1ocdJ2zE/xVytoTld7dQKuJ2ibu6/Jotd4JSTw5jlHBGI6T7Dzi
         DoamPNDWMvzEC6GsHixBzMdGa4+PFbr8oiThI92r42Dyyy6OsygLbMuQrao9i4kR6cI/
         1Cu3yM98tBdVhkZrbAdYdYRo1dG+Btzey7fkbiu9rd5fLOqxE+iMudFGLRlnZX/mGUyC
         2eoQ==
X-Forwarded-Encrypted: i=1; AJvYcCUzhVXNlcMqd4610hkZrHAKFuULKIjoS+lsEPoGGeB7uGl4PukpEQbE9xwNXoLzcrBmELHY+KRU@lists.linux.dev
X-Gm-Message-State: AOJu0YwpQa9AqLYPuMuet7cJ+1OPOl4DouDePEKMIiaLVAMCD7jxKpNu
	XnBaVXlay6fZ+9TDg6FKfbIN6wcdv8XtSVLMoEPDCJll9eiRzxlYg9CIIdGt4wlK0wNkrLRM8mi
	8x9PakAtngDh6CMEK4wvEq6E7TABafsx44tJrTKs7mjYr9h3Y18NQxoHPbKfIctnAcDK0RKA=
X-Gm-Gg: ASbGncvHfbWWovKsbjv/1h+Izg5sdFeZoOfUxtHcbz6vV49VwZcK4wt9MTvt8DwfRju
	iIaFXwaWl6j26wY1dlnU+1JxH3sqtH8A4ATy1L6W9IkgecG2M8WOro0rEgk/EqH1eIg3Mhl7SYm
	WtsEQVHETTQWbmUOaHzAiJST96dm9h4/3W1oxwZVy8P4ay4Z4A8wpzsI0uXMwSYgC87iXeW3Eu6
	GoIebUjoXr9m9W3xvpx/jj+piEjxG9Y9/tNyjQ8giIZ5bSnxMYPIfD78vQ=
X-Received: by 2002:a17:903:22c2:b0:215:b1e3:c051 with SMTP id d9443c01a7336-21a7a2257f3mr35062415ad.11.1736239899233;
        Tue, 07 Jan 2025 00:51:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH+zky+hnn7Rfzi1PsLbeCOVDrLCRsjAjqavNRLpB29Q6S0+E+rjPN1jKkX7JhZuvo2JJP8Gw==
X-Received: by 2002:a17:903:22c2:b0:215:b1e3:c051 with SMTP id d9443c01a7336-21a7a2257f3mr35062135ad.11.1736239898821;
        Tue, 07 Jan 2025 00:51:38 -0800 (PST)
Received: from localhost ([240f:74:7be:1:ce95:9b16:a5ed:15a1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dc9d4635sm306455295ad.162.2025.01.07.00.51.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2025 00:51:38 -0800 (PST)
Date: Tue, 7 Jan 2025 17:51:36 +0900
From: Koichiro Den <koichiro.den@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, mhiramat@kernel.org, 
	mark.rutland@arm.com, mathieu.desnoyers@efficios.com, 
	Steven Rostedt <rostedt@goodmis.org>, Zheng Yejian <zhengyejian1@huawei.com>, 
	Hagar Hemdan <hagarhem@amazon.com>
Subject: Re: [PATCH 5.4 50/66] ftrace: Fix possible use-after-free issue in
 ftrace_location()
Message-ID: <74gjhwxupvozwop7ndhrh7t5qeckomt7yqvkkbm5j2tlx6dkfk@rgv7sijvry2k>
References: <20241115063722.834793938@linuxfoundation.org>
 <20241115063724.648039829@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241115063724.648039829@linuxfoundation.org>

On Fri, Nov 15, 2024 at 07:37:59AM +0100, Greg Kroah-Hartman wrote:
> 5.4-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Zheng Yejian <zhengyejian1@huawei.com>
> 
> commit e60b613df8b6253def41215402f72986fee3fc8d upstream.
> 
> KASAN reports a bug:
> 
>   BUG: KASAN: use-after-free in ftrace_location+0x90/0x120
>   Read of size 8 at addr ffff888141d40010 by task insmod/424
>   CPU: 8 PID: 424 Comm: insmod Tainted: G        W          6.9.0-rc2+
>   [...]
>   Call Trace:
>    <TASK>
>    dump_stack_lvl+0x68/0xa0
>    print_report+0xcf/0x610
>    kasan_report+0xb5/0xe0
>    ftrace_location+0x90/0x120
>    register_kprobe+0x14b/0xa40
>    kprobe_init+0x2d/0xff0 [kprobe_example]
>    do_one_initcall+0x8f/0x2d0
>    do_init_module+0x13a/0x3c0
>    load_module+0x3082/0x33d0
>    init_module_from_file+0xd2/0x130
>    __x64_sys_finit_module+0x306/0x440
>    do_syscall_64+0x68/0x140
>    entry_SYSCALL_64_after_hwframe+0x71/0x79
> 
> The root cause is that, in lookup_rec(), ftrace record of some address
> is being searched in ftrace pages of some module, but those ftrace pages
> at the same time is being freed in ftrace_release_mod() as the
> corresponding module is being deleted:
> 
>            CPU1                       |      CPU2
>   register_kprobes() {                | delete_module() {
>     check_kprobe_address_safe() {     |
>       arch_check_ftrace_location() {  |
>         ftrace_location() {           |
>           lookup_rec() // USE!        |   ftrace_release_mod() // Free!
> 
> To fix this issue:
>   1. Hold rcu lock as accessing ftrace pages in ftrace_location_range();
>   2. Use ftrace_location_range() instead of lookup_rec() in
>      ftrace_location();
>   3. Call synchronize_rcu() before freeing any ftrace pages both in
>      ftrace_process_locs()/ftrace_release_mod()/ftrace_free_mem().
> 
> Link: https://lore.kernel.org/linux-trace-kernel/20240509192859.1273558-1-zhengyejian1@huawei.com
> 
> Cc: stable@vger.kernel.org
> Cc: <mhiramat@kernel.org>
> Cc: <mark.rutland@arm.com>
> Cc: <mathieu.desnoyers@efficios.com>
> Fixes: ae6aa16fdc16 ("kprobes: introduce ftrace based optimization")
> Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> [Hagar: Modified to apply on v5.4.y]
> Signed-off-by: Hagar Hemdan <hagarhem@amazon.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  kernel/trace/ftrace.c |   30 +++++++++++++++++++++---------
>  1 file changed, 21 insertions(+), 9 deletions(-)
> 
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -1552,7 +1552,9 @@ unsigned long ftrace_location_range(unsi
>  	struct ftrace_page *pg;
>  	struct dyn_ftrace *rec;
>  	struct dyn_ftrace key;
> +	unsigned long ip = 0;
>  
> +	rcu_read_lock();
>  	key.ip = start;
>  	key.flags = end;	/* overload flags, as it is unsigned long */
>  
> @@ -1565,10 +1567,13 @@ unsigned long ftrace_location_range(unsi
>  			      sizeof(struct dyn_ftrace),
>  			      ftrace_cmp_recs);
>  		if (rec)
> -			return rec->ip;
> +		{
> +			ip = rec->ip;
> +			break;
> +		}
>  	}
> -
> -	return 0;
> +	rcu_read_unlock();
> +	return ip;
>  }
>  
>  /**
> @@ -5736,6 +5741,8 @@ static int ftrace_process_locs(struct mo
>  	/* We should have used all pages unless we skipped some */
>  	if (pg_unuse) {
>  		WARN_ON(!skipped);
> +		/* Need to synchronize with ftrace_location_range() */
> +		synchronize_rcu();
>  		ftrace_free_pages(pg_unuse);
>  	}
>  	return ret;
> @@ -5889,6 +5896,9 @@ void ftrace_release_mod(struct module *m
>   out_unlock:
>  	mutex_unlock(&ftrace_lock);
>  
> +	/* Need to synchronize with ftrace_location_range() */
> +	if (tmp_page)
> +		synchronize_rcu();
>  	for (pg = tmp_page; pg; pg = tmp_page) {
>  
>  		/* Needs to be called outside of ftrace_lock */
> @@ -6196,6 +6206,7 @@ void ftrace_free_mem(struct module *mod,
>  	unsigned long start = (unsigned long)(start_ptr);
>  	unsigned long end = (unsigned long)(end_ptr);
>  	struct ftrace_page **last_pg = &ftrace_pages_start;
> +	struct ftrace_page *tmp_page = NULL;
>  	struct ftrace_page *pg;
>  	struct dyn_ftrace *rec;
>  	struct dyn_ftrace key;
> @@ -6239,12 +6250,8 @@ void ftrace_free_mem(struct module *mod,
>  		ftrace_update_tot_cnt--;
>  		if (!pg->index) {
>  			*last_pg = pg->next;
> -			if (pg->records) {
> -				free_pages((unsigned long)pg->records, pg->order);
> -				ftrace_number_of_pages -= 1 << pg->order;
> -			}
> -			ftrace_number_of_groups--;
> -			kfree(pg);
> +			pg->next = tmp_page;
> +			tmp_page = pg;
>  			pg = container_of(last_pg, struct ftrace_page, next);
>  			if (!(*last_pg))
>  				ftrace_pages = pg;
> @@ -6261,6 +6268,11 @@ void ftrace_free_mem(struct module *mod,
>  		clear_func_from_hashes(func);
>  		kfree(func);
>  	}
> +	/* Need to synchronize with ftrace_location_range() */
> +	if (tmp_page) {
> +		synchronize_rcu();
> +		ftrace_free_pages(tmp_page);
> +	}
>  }
>  
>  void __init ftrace_free_init_mem(void)
> 
> 

Hi,

I observed that since this backport, on linux-5.4.y x86-64, a simple 'echo
function > current_tracer' without any filter can easily result in double
fault (int3) and system becomes unresponsible. linux-5.4.y x86 code has not
yet been converted to use text_poke(), so IIUC the issue appears to be that
the old ftrace_int3_handler()->ftrace_location() path now includes
rcu_read_lock() with this backport patch, which has mcount location inside,
that leads to the double fault.

I verified on an x86-64 qemu env that applying the following 11 additional
backports resolves the issue. The main purpose is to backport #7. All the
commits can be cleanly applied to the latest linux-5.4.y (v5.4.288).

  #11. fd3dc56253ac ftrace/x86: Add back ftrace_expected for ftrace bug reports
  #10. ac6c1b2ca77e ftrace/x86: Add back ftrace_expected assignment
   #9. 59566b0b622e x86/ftrace: Have ftrace trampolines turn read-only at the end of system boot up
   #8. 38ebd8d11924 x86/ftrace: Mark ftrace_modify_code_direct() __ref
   #7. 768ae4406a5c x86/ftrace: Use text_poke()
   #6. 63f62addb88e x86/alternatives: Add and use text_gen_insn() helper
   #5. 18cbc8bed0c7 x86/alternatives, jump_label: Provide better text_poke() batching interface
   #4. 8f4a4160c618 x86/alternatives: Update int3_emulate_push() comment
   #3. 72ebb5ff806f x86/alternative: Update text_poke_bp() kernel-doc comment
   #2. 3a1255396b5a x86/alternatives: add missing insn.h include
   #1. c3d6324f841b x86/alternatives: Teach text_poke_bp() to emulate instructions

  Note: #8-11 are follow-up fixes for #7
        #2-3 are follow-up fixes for #1

According to [1], no regressions were observed on x86_64, which included
running kselftest-ftrace. So I'm a bit confused.

Could someone take a look and shed light on this? (ftrace on linux-5.4.y x86)

Thanks.

[1] https://lore.kernel.org/stable/CA+G9fYtdzDCDP_RxjPKS5wvQH=NsjT+bDRbukFqoX6cN+EHa7Q@mail.gmail.com/

-Koichiro Den

