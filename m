Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E49D2E401;
	Wed, 22 Oct 2025 06:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761112886; cv=none; b=NrJbSY+u1qwH39YX+TOJZPp4DR/R/JlXs+8ZCZ04EE/kvlKPpBuMz2lq1ay0DMs6DAd4Yn0aTkae8TJpwd4lU45m+tYNjKrHdD6agtC5wcVDbeY6qCWYJK7aQ/kY++LMcV7ZRyuIZEezyvr45MhQGNHP7agDV9t/nlvXPIJt1kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761112886; c=relaxed/simple;
	bh=ljiLlxvsuemtkUTdxR99prnOHMvm/yaLMWqYL9E2vlY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SmwEsqttA2lGuwILvr8j8HqymCmyKKfY95McYR9j49IpUxBlVC99IWKkycTrSmvpBar2aHNggsStJ9e2AeZSnZsJAD8beIiSbYbAw4ZXd6eG6hOFprJUOzVF7vtQ0ugxh/oEAai1qif1EVxwHGVkJK/mTSNt1PFFvwH2koNU3QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PmoBmHf9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PmoBmHf9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8E15C4CEF7;
	Wed, 22 Oct 2025 06:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761112886;
	bh=ljiLlxvsuemtkUTdxR99prnOHMvm/yaLMWqYL9E2vlY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PmoBmHf9Ql6qH+pe9CemgRLWBAJhjSi/hoSABnk9ndpV+2zUxCziVK4S5Lo0Sm9Nn
	 Bp2qAEq953xvv8w4/luZLLy4s9ZTB4p0ZKutX2m0xj1MU1xszZbt6smCVpD1tSo4pD
	 +Qmik6bLUKZlATOg+pikO/bhM3h21XPwypLZ1APc=
Date: Wed, 22 Oct 2025 08:01:14 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Schneider <pschneider1968@googlemail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Nick Bowler <nbowler@draconx.ca>,
	Douglas Anderson <dianders@chromium.org>,
	Dave Airlie <airlied@redhat.com>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 6.12 020/136] drm/ast: Blank with VGACR17 sync enable,
 always clear VGACRB6 sync off
Message-ID: <2025102259-open-shallow-089e@gregkh>
References: <20251021195035.953989698@linuxfoundation.org>
 <20251021195036.457336682@linuxfoundation.org>
 <7015844a-7eca-469c-9115-b84183a94154@googlemail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7015844a-7eca-469c-9115-b84183a94154@googlemail.com>

On Wed, Oct 22, 2025 at 07:42:14AM +0200, Peter Schneider wrote:
> Hi Greg,
> 
> Am 21.10.2025 um 21:50 schrieb Greg Kroah-Hartman:
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Thomas Zimmermann <tzimmermann@suse.de>
> > 
> > commit 6f719373b943a955fee6fc2012aed207b65e2854 upstream.
> > 
> > Blank the display by disabling sync pulses with VGACR17<7>. Unblank
> > by reenabling them. This VGA setting should be supported by all Aspeed
> > hardware.
> 
> This patch breaks VGA output on my machine. I have already reported this regression against mainline 6.18-rc2, see here:
> 
> https://lore.kernel.org/all/a40caf8e-58ad-4f9c-af7f-54f6f69c29bb@googlemail.com/
> 
> When I revert this patch from 6.12.55-rc1, the issue goes away, just as in
> mainline. I'm still going to test 6.17.5-rc1 too and report back, but I
> guess it will be just the same.

Now dropped from this queue as well.  I'll go push out a -rc2 to be
safe.

thanks,

greg k-h
