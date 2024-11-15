Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1074820B20;
	Fri, 15 Nov 2024 15:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731684223; cv=none; b=sgRw9he3nNCE+m7BUO7X1DuAFJxWvFnGU4rEebyibTtsnTort1/PEDo5ubyzWu2RlE7GPBU24bW1kB7UJAzUyB9b17FaeQzSq690kpgKRuYLOC8NXalPyRE4r3WdrDkzyAQKIygiUFBkNOWRRLGYcxbzS/TlKcHpP1D6w0pthlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731684223; c=relaxed/simple;
	bh=o+sDd9/eOefHat8x4DhNdKBfaZOxFnKXucOrjArqtr8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m969gxRVgMt70uhSpeqXTjLN8YaaNz02MWb3sCryR/+PC49u3TW8RDKNMwIBqq4nFyRLN205IFBvjm7Xs3okHkKeqKC+u6YWL6wsTxcza8t6L5a6fAslYD4DfElfO97JL0HZkxJfSIYbmNICyvAAhJ7XWUmuYpoCf2mf408r85w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D05C4CECF;
	Fri, 15 Nov 2024 15:23:41 +0000 (UTC)
Date: Fri, 15 Nov 2024 10:24:05 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, mhiramat@kernel.org,
 mark.rutland@arm.com, mathieu.desnoyers@efficios.com, Zheng Yejian
 <zhengyejian1@huawei.com>, Hagar Hemdan <hagarhem@amazon.com>
Subject: Re: [PATCH 5.4 50/66] ftrace: Fix possible use-after-free issue in
 ftrace_location()
Message-ID: <20241115102405.7f17d9e5@gandalf.local.home>
In-Reply-To: <20241115063724.648039829@linuxfoundation.org>
References: <20241115063722.834793938@linuxfoundation.org>
	<20241115063724.648039829@linuxfoundation.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 15 Nov 2024 07:37:59 +0100
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

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

There should be a v2 of this patch to keep proper coding style.

-- Steve
