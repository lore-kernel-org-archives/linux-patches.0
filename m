Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CFAC3BB661;
	Mon, 14 Sep 2026 10:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789383506; cv=none; b=hUI5sdZ7GqTwwqWH1RIdgGpHbTG8C7LT4JyoHiVHCsmzyy73LKMFYtFSOdA/vgMK/R5HkLdnZvSzDHahh/pVB7Y+iidiK9+aqD0JJkIxXFSSshY1L03m75rdgJ0qJMWNYYml1ERGz5uePsJ9qXt7Gwc8DU37McvJPtDqIGzYOcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789383506; c=relaxed/simple;
	bh=PsugdXf4SfJvJc9HsVtCBFHIyj/fFRAJs891Ji6Ibvc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K55iPn5XH7nyOA5sJsHlr+gpY77TC0BzWVybGQQf2wSe3ll2JTXDcvcNHBH9KX9kfPl/ZjNfv4XN7Pop6BYXxCMBf43xHzFu3A4seqGoO/5+prGV2EIe5PS8GPna3Bs6fS1os0Cms26KW0j7N+//tAvYzLXhKSUo+e+24G8omCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Go+PTuO1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Go+PTuO1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69B441F000FF;
	Mon, 14 Sep 2026 10:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789383505;
	bh=gXiRiyLMfuI6f1e2LOhLXQrEor6/QGnnFL102NWG6p4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Go+PTuO1ha0TgIV0/c3D32sB3tZUUTc95gGZpGMZ59z+tRqA+WwCO//ykq4Q5udkd
	 l6T/Uo6j/4Zv8xvuvgxoSIIhLdGYRg5pKvnX4dsy8Zf+CZQ4Khb7EkSyEYy+6kZTks
	 TMcAH+nyPmiFUKAkhGkbJlHEsvYYh3Qvg/gKnMus=
Date: Mon, 14 Sep 2026 12:58:15 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Ritesh Harjani <riteshh@linux.ibm.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 712/798] tracing: Have TRACE_DEFINE_ENUM affect
 trace event types as well
Message-ID: <2026091455-negotiate-guidable-e194@gregkh>
References: <20260912065516.948645775@linuxfoundation.org>
 <20260912065533.404747135@linuxfoundation.org>
 <20260913213414.5425-1-kmehltretter@gmail.com>
 <2026091411-runner-regime-a298@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026091411-runner-regime-a298@gregkh>

On Mon, Sep 14, 2026 at 12:44:21PM +0200, Greg Kroah-Hartman wrote:
> On Sun, Sep 13, 2026 at 11:34:14PM +0200, Karl Mehltretter wrote:
> > Please hold this patch unless an adapted 5.10 backport of upstream commit
> > 795301d3c289 ("tracing: Have type enum modifications copy the strings")
> > can also be included.
> 
> Odd I missed that, now queued up, thanks!

Nope, now I know why I missed it, it broke the build.  I'll go drop both
of these for now, thanks.

greg k-h
