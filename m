Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901E14438B;
	Mon, 20 Jan 2025 17:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737394562; cv=none; b=KljiYZTkIDzQpFIycNDw9P6DC1RlhzLcg2ixLa0EXaZ9grYc6QueY727rIaPKDHMiqjo/oDqV52Zuo7jK5tQ6G4y7koTFeZHbJSeK521bXMIkxUPe9wLC3PA9HgOrbsb7r6YMJdrcNRQuymvvSyQQeye2mYZohmsou6iFJ9FQMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737394562; c=relaxed/simple;
	bh=FoDQ0IOChQV4Gr8f2WCznqwwtyyGJQxEIrmoPWjPRYM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AoaCIfpnzoJkyUM+XZ6ygx1MErjzlC02twIc1JPl+qZPdOPQnb7NHCciDAWkNX9ifkN/R5v0P+bCzBF6KdCVDWji9n5fNxi++QoKQzOgUeAKE3e4x/fpwuUgYikDLn2jb6weTa6LxGdLHPuppC0hHNtvh71YPSCsM0PUYNdwPZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29FA0C4CEDD;
	Mon, 20 Jan 2025 17:36:01 +0000 (UTC)
Date: Mon, 20 Jan 2025 12:36:01 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, llvm@lists.linux.dev,
 patches@lists.linux.dev, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] tracing: Fix -Wundef around 'struct event_mod_load'
Message-ID: <20250120123601.36aea213@gandalf.local.home>
In-Reply-To: <20250120-trace_events-fix-wundef-v1-1-61259cbbaa75@kernel.org>
References: <20250120-trace_events-fix-wundef-v1-1-61259cbbaa75@kernel.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 20 Jan 2025 05:29:24 -0700
Nathan Chancellor <nathan@kernel.org> wrote:

> When CONFIG_MODULES is disabled, clang warns:
> 
>   kernel/trace/trace_events.c:872:5: warning: 'CONFIG_MODULES' is not defined, evaluates to 0 [-Wundef]
>     872 | #if CONFIG_MODULES
>         |     ^
> 
> Use '#ifdef' to resolve the warning.
> 
> Fixes: b355247df104 ("tracing: Cache ":mod:" events for modules not loaded yet")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202501190121.E2CIJuUj-lkp@intel.com/
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Yes yes, I had this fixed locally but never tested nor pushed it out. :-p

Thanks,

-- Steve

> ---
>  kernel/trace/trace_events.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index ab04994e4510..de934332ba36 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -869,7 +869,7 @@ static int ftrace_event_enable_disable(struct trace_event_file *file,
>  	return __ftrace_event_enable_disable(file, enable, 0);
>  }
>  
> -#if CONFIG_MODULES
> +#ifdef CONFIG_MODULES
>  struct event_mod_load {
>  	struct list_head	list;
>  	char			*module;
> 
> ---
> base-commit: 9f3ccaeedbe0088f1b89474bcf4187c49cfe8de2
> change-id: 20250120-trace_events-fix-wundef-7a1153105f5f
> 
> Best regards,

