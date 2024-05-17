Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC061EB36;
	Fri, 17 May 2024 09:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715937760; cv=none; b=We+Iyv7QH5u9JoTNfblbT+EwX5t6sOk/LnCgN/HRa4xN95fVsbs54IkfQlpTWN5hzxZZNXEp/EILLEt9F/I07T8VO+e6jRoMAbSVzBl5asgKvXAnrbUh4/FMp+fNlbcIQS5fGcm73YcY70vUztfyI4+vr6JlVettYk+IsKsjo2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715937760; c=relaxed/simple;
	bh=EmoyoU0ptgoe4UYZLSeZng24uZGWBp7Ks7ThjHd2vR4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XeWyL+Yyfd5CjDfbRQA1KG21umU11RL1ghszz+UV2V6L0+kxQsreo5VtUu9mfYuzUz/BtrjmztK+KMzgyuoopk393498e3haboVabZsB0PfQFa9MezY76RAdh9Az8Iti9VxydJr7qZmNVuZXUEFLEy50NNaPf1zMiIms9cer3mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c167o6Eu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c167o6Eu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 841FEC2BD10;
	Fri, 17 May 2024 09:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715937760;
	bh=EmoyoU0ptgoe4UYZLSeZng24uZGWBp7Ks7ThjHd2vR4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c167o6EudeuobrY+9IECdythJm0Ay4nYXFRqzOUJp82WYaPm6spkrzLuAqqYgbp2l
	 82VUiKBWftliiiTsfdt3TXlYKdCmdfbZnvP+AUGZpMyQEAbkh5ukAd9QmU+eO7Taxm
	 KXWySU4mOkSnejCqOMRJnGIcakE2fixo3gHNBP/E=
Date: Fri, 17 May 2024 11:22:37 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pavel Machek <pavel@denx.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 5.10 000/111] 5.10.217-rc1 review
Message-ID: <2024051700-jubilant-rotunda-eaac@gregkh>
References: <20240514100957.114746054@linuxfoundation.org>
 <ZkX+WBV4vJNpwX1i@duo.ucw.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZkX+WBV4vJNpwX1i@duo.ucw.cz>

On Thu, May 16, 2024 at 02:38:48PM +0200, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 5.10.217 release.
> > There are 111 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> 
> > Stephen Boyd <sboyd@kernel.org>
> >     clk: Don't hold prepare_lock when calling kref_put()
> 
> Stephen said in a message that this depends on other patches,
> including 9d1e795f754d clk: Get runtime PM before walking tree for
> clk_summary. But we don't seem to have that one. Can you double-check?
> 
> (
> Date: Tue, 23 Apr 2024 12:24:51 -0700
> Subject: Re: [PATCH AUTOSEL 5.4 6/8] clk: Don't hold prepare_lock when calling kref_put()
> )

Ugh, please use lore links when referring to other threads so that we
don't have to figure it out on our own...

Anyway, that one commit seems missing, I'll look into it.

greg k-h
