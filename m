Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E911D63D1;
	Sun, 11 Jan 2026 13:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768139845; cv=none; b=SQW8SuTy1uqIHmYfr3bQoWfkxHpcoSF+/iGU3nMqFcfezsRIrnASA/JQb5Jqw7Hacy3AhUIxHRt4PSxFQh97KhNdFaF7XRM65uCUC/NNvfxi1iL21niyNq/5uRHmBAdMCrwK3Zt0GduDTIcQ7zDwIpGC+nsJHwywFw39vRnaL4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768139845; c=relaxed/simple;
	bh=47/pTHouZ+vMmyjz9AyyEU/G9yvYRgyMg1/L66YJnY0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bsdiWK91NCjDdhFNlSNbDLg9QyLhmLW5u9Wbdb+NQ4Ct4s/nC/gI8TdSyKcxIvueGhH/b/4ERJitFmpQbJUO38P2yYhq2Xm3occfrNeNv3LkFrOeIXx32inPH5BYAwUEQUy/ATL0dQKV0m73thMZYBBKIyF9gmShDVRnMlPn33M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dXrASIDG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dXrASIDG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E02FCC4CEF7;
	Sun, 11 Jan 2026 13:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768139845;
	bh=47/pTHouZ+vMmyjz9AyyEU/G9yvYRgyMg1/L66YJnY0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dXrASIDGsJPr2BiECswmLyBd9EjZSwyOvhwqRpQgnPzGhyWoBtDu83/BW3kvV+2Jx
	 LGMIp+9KZrUvgEnJ10v6/zY9bKfLtu+Zqo83plov5JYSmI++8kMjXTsHoykkg1w4r5
	 IiWQnRZDbsrYop1jaj6/7doMqh2JwJsWc5hG3ca0=
Date: Sun, 11 Jan 2026 14:57:22 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	syzbot+340581ba9dceb7e06fb3@syzkaller.appspotmail.com,
	Lizhi Xu <lizhi.xu@windriver.com>, Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 6.6 731/737] ext4: filesystems without casefold feature
 cannot be mounted with siphash
Message-ID: <2026011114-contact-vocalize-37b2@gregkh>
References: <20260109112133.973195406@linuxfoundation.org>
 <20260109112201.603806562@linuxfoundation.org>
 <aWEFUlM6PsTMMXxr@quatroqueijos.cascardo.eti.br>
 <2026010942-overdue-repayment-b202@gregkh>
 <aWN74hQARUawYete@quatroqueijos.cascardo.eti.br>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWN74hQARUawYete@quatroqueijos.cascardo.eti.br>

On Sun, Jan 11, 2026 at 07:30:58AM -0300, Thadeu Lima de Souza Cascardo wrote:
> On Fri, Jan 09, 2026 at 03:13:55PM +0100, Greg Kroah-Hartman wrote:
> > On Fri, Jan 09, 2026 at 10:40:34AM -0300, Thadeu Lima de Souza Cascardo wrote:
> > > Hi, Greg.
> > > 
> > > The followup to 985b67cd86392310d9e9326de941c22fc9340eec, that I submitted
> > > in the same thread, has not been picked up.
> > > 
> > > 20260108150350.3354622-2-cascardo@igalia.com
> > > https://lore.kernel.org/stable/20260108150350.3354622-2-cascardo@igalia.com/
> > > a2187431c395 ("ext4: fix error message when rejecting the default hash")
> > > 
> > > You picked it up for 6.1 and 5.15 though.
> > 
> > It's in the queue, odd you didn't get an email.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Ah, I see it now, when looking for the upstream hash and not my sign-off.
> It was a different backport that ommitted the original fix and only applied
> the fixup/followup.
> 
> The original fix adds a hunk that is then removed by the followup. So when
> applying the followup that ignores that hunk and then the original fix with
> that hunk, 6.6 queue now is carrying an undesired hunk message.
> 
> If you drop a032fc761cc3f1112c42732d9a2482f23acad5fc and apply
> https://lore.kernel.org/stable/20260108150350.3354622-2-cascardo@igalia.com/
> instead, it should be in the expected final state. I would rather do that,
> as then 6.6.y would be carrying the original fix, avoiding it to be
> backported again.

Ok, thanks, now done!

greg k-h
