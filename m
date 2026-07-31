Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10BF41D5146;
	Fri, 31 Jul 2026 15:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785510324; cv=none; b=Znoq6zfv2XLYwbmFVI6F9MEq7CzGZrylLdBt1gUz6M5uUqJ2oDmaLdTJc1OwwOOx4iZK9FphfQdGYQik3tjSc94yBygcbLKdgVkgA3TzeHlnL5oGglRMtg6iH/EFDIOaFe1sKczbIs7XF/zf9Du+SkTvZlBdAyV0NbLJdPjxmFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785510324; c=relaxed/simple;
	bh=2kIbpzDU2FeBTCCuzlNrlnZ3PNRv77u7+QoQ4s/2HVk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZcH4b5aZtANc6Jq7TyQgNbimHohekDHrAHmEKzf12jaj40LoM0fCylQuJ4pVTQK2oEQvaG8TiHbJE7H6TFVsZ6dxDs5ilaF/6WwkrqGLxSCIV9FbU0Sgs6YeP5J5rTZ4+Qt0U/zju0SfUFt2vkshw7WB4UQDKTubpWOFYXxeq8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1r6LxA0P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1r6LxA0P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5245D1F000E9;
	Fri, 31 Jul 2026 15:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785510322;
	bh=CIFMjpzT0Af143fvKTVQpHVurPcd1jGgaTF0FyzCmUM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=1r6LxA0PEjO2QBYDGUp5NlNkDjk/cIs+/THVee/Dy60kFGAQLNpFAvSZisXa8bczI
	 SyfmCEHs+bD/q1MwyRSmVgzva2Ivs2Ulyxap+Iwh8Q4HrHfGtqoiyxqpRd9VVLUMcv
	 cZtRlOmhIj56ifDouESCeUBkHhMG4024EOz9s2fo=
Date: Fri, 31 Jul 2026 17:05:08 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Johan Hovold <johan@kernel.org>
Cc: Wentao Guan <guanwentao@uniontech.com>, patches@lists.linux.dev,
	stable@vger.kernel.org, ulf.hansson@linaro.org,
	zhoubinbin@loongson.cn
Subject: Re: [PATCH 6.6 456/484] mmc: vub300: fix use-after-free on disconnect
Message-ID: <2026073152-angular-pyromania-032a@gregkh>
References: <20260730141433.390818444@linuxfoundation.org>
 <20260731033117.506282-1-guanwentao@uniontech.com>
 <2026073134-vindicate-kissable-e3e6@gregkh>
 <amyxS1dyw49Rvsha@hovoldconsulting.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amyxS1dyw49Rvsha@hovoldconsulting.com>

On Fri, Jul 31, 2026 at 04:29:31PM +0200, Johan Hovold wrote:
> On Fri, Jul 31, 2026 at 08:51:45AM +0200, Greg Kroah-Hartman wrote:
> > On Fri, Jul 31, 2026 at 11:31:17AM +0800, Wentao Guan wrote:
> > > Hello,
> > > 
> > > The backport is wrong and not as is discribe in the title.
> > > It just renames the goto and I don`t know what the backport fix not in the tree
> > > for 'git log v6.6.147 --grep="mmc: vub300: Use devm_mmc_alloc_host() helper"'
> > > not found it fixes for, so I see just drop the patch.
> > 
> > Odd, yeah, let me go drop this one, good catch.  something went wrong on
> > my side...  I'll also drop it from the other queues.
> 
> Yeah, this fixes a commit in 6.17 so shouldn't be backported further
> than that (unless that commit somehow ended up being backported as a
> dependency somewhere...).

It was a dependency, but backported wrong so I just ripped them all out
:)
