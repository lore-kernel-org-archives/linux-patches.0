Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856BD22126C;
	Wed, 24 Jun 2026 10:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782295414; cv=none; b=WD1zqtcW1zDb4O+Qv5y7j4kvTHyon9nZLQ07WsGfnrw2vL58WgVfItGhibXOIEiZXUd+3JSFvU3Ht2PVXNvDjwUZizGWjHG4oHZmjV9a7U+ArnFJIaEnlBmcKtBtNKudaz275LYuDmEg3qpucuSSu5tw4BbyOg3IDeQFsEvEMpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782295414; c=relaxed/simple;
	bh=FVXutdEyC0x0cYFJWy0uhvg1KlpMoLrmECvCw+Pc0rA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DPsB5ggwpJGKW03uMiYmAotv/jLNGsk4kEeryTQT0F64FcbSFeKsjOkEEfYY/9VLnjkrtE2P+Zi05NRhcadTUXO5ZSigPTHo3IIdZDJB8jvyx72ES+u+OWN6MKEk4Y0zfsaeN6qr39+hYdpfpI735g6Lbv32RwKYJUArfHeVEWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mng0XmTb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mng0XmTb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432671F000E9;
	Wed, 24 Jun 2026 10:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782295412;
	bh=954vwfv0onOMTvLBwot3VrPpWzQAzKYexf8k6owoKRY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Mng0XmTbHJolB4hGA0HOv7x4doOtSehYCzZ1XaUA8kpa7UiBYSxPhwWYAA2E6MxdI
	 fjJC8kbO3yBodd/oMNgj09pwGrLNSD+6b7hOAz3ZevrHrOHUOTuHtmnnBsbUtbFnoO
	 pN1y8RFs7Uhh/53EtKNZZBhKTYf1MS9Zbo7OZaCk=
Date: Wed, 24 Jun 2026 11:02:21 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Wentao Guan <guanwentao@uniontech.com>
Cc: 00107082@163.com, iklatzco@gmail.com, patches@lists.linux.dev,
	peterz@infradead.org, sashal@kernel.org, stable@vger.kernel.org,
	yeoreum.yun@arm.com
Subject: Re: [PATCH] perf: Fix dangling cgroup pointer in cpuctx backport
Message-ID: <2026062404-unusual-nutmeg-87d5@gregkh>
References: <2026062455-obtrusive-sandbox-d6d1@gregkh>
 <20260624095920.2558406-1-guanwentao@uniontech.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260624095920.2558406-1-guanwentao@uniontech.com>

On Wed, Jun 24, 2026 at 05:59:21PM +0800, Wentao Guan wrote:
> recently backport of ("perf: Fix dangling cgroup pointer in cpuctx")
> use a middle version, so aligned with the upstream commit:
> 3b7a34aebbdf2a4b7295205bf0c654294283ec82
> 
> Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
> ---
>  kernel/events/core.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index a4187dea6402a..73a86db06cc9b 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -2384,10 +2384,9 @@ __perf_remove_from_context(struct perf_event *event,
>  	 */
>  	if (flags & DETACH_EXIT)
>  		state = PERF_EVENT_STATE_EXIT;
> -	if (flags & DETACH_DEAD) {
> -		event->pending_disable = 1;
> +	if (flags & DETACH_DEAD)
>  		state = PERF_EVENT_STATE_DEAD;
> -	}
> +
>  	event_sched_out(event, ctx);
>  
>  	if (event->state > PERF_EVENT_STATE_OFF)
> -- 
> 2.30.2
> 

What kernel tree(s) is this for?  What git id does this fix?

thanks,

greg k-h
