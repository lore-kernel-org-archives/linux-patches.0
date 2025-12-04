Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44A6349B04;
	Thu,  4 Dec 2025 16:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764865103; cv=none; b=Rh+SRmn9PTHDlQoVDixVnVxNdfijlIZ7pjdaDkct8nw7O7SljrVFjSQInhBU8Yuk/7njN62HIaGZJ2+v+ibaWfOjmf73lkJgUIdquAdRRfpU0S5Pi+sKFKr5F3/3RQ0Wh1XLaHEh3kyCAyMkdxFZcze/Itl+M2yEAIO2kwEiV6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764865103; c=relaxed/simple;
	bh=hZZzBNQ85Cyj5r/py0IyyWj/HxWMJgHqx0pz+fV913o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LrS3p50qwfW6hkPSpLP89LMIhRjqzes3f68/Fhzc4MY228KaZvjECKQ/W0VmqhyNPHumALxXliys295xXAXv/3mWbUGD+pK7uA3zr1baPq/AyFk/TSUgE9xbeuvSMq78ocT6nv3ugL2kEJo6hJgkNFQx06LYwJBCEvMRzw0pHvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZkRL27+9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZkRL27+9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD4EDC4CEFB;
	Thu,  4 Dec 2025 16:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764865103;
	bh=hZZzBNQ85Cyj5r/py0IyyWj/HxWMJgHqx0pz+fV913o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZkRL27+9HnwAiQyNVjCaHEh3TqFB0/cotbxgXRTVPIw4mKyazNRt1W01eL4KWMpdX
	 qNzDlM7NtZkRAPy+kWQ2CfJoh1P1Rlb2f80kkVxRFoe2EeKS5lRxE86WQGOFZX2ZO8
	 Qcy8vnYzRv8REmDawxIA8dsUiUOKjmrednLQqocE=
Date: Thu, 4 Dec 2025 17:18:20 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Chen-Yu Tsai <wens@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 283/568] clk: sunxi-ng: sun6i-rtc: Add A523 specifics
Message-ID: <2025120413-gizmo-prepaid-468d@gregkh>
References: <20251203152440.645416925@linuxfoundation.org>
 <20251203152451.071218150@linuxfoundation.org>
 <CAGb2v66AhhbEdXJVOZbUiUa2yJ-XAroSvHi3Xqyot6dUkfj7iQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGb2v66AhhbEdXJVOZbUiUa2yJ-XAroSvHi3Xqyot6dUkfj7iQ@mail.gmail.com>

On Thu, Dec 04, 2025 at 12:39:19AM +0800, Chen-Yu Tsai wrote:
> On Thu, Dec 4, 2025 at 12:34 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > 6.1-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Chen-Yu Tsai <wens@csie.org>
> >
> > [ Upstream commit 7aa8781f379c32c31bd78f1408a31765b2297c43 ]
> >
> > The A523's RTC block is backward compatible with the R329's, but it also
> > has a calibration function for its internal oscillator, which would
> > allow it to provide a clock rate closer to the desired 32.768 KHz. This
> > is useful on the Radxa Cubie A5E, which does not have an external 32.768
> > KHz crystal.
> >
> > Add new compatible-specific data for it.
> 
> Support for the A523 SoC was added in v6.16. I don't think we need to
> backport A523 specific stuff any further back.

Now dropped, thanks!

greg k-h
