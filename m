Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42FD39F
	for <patches@lists.linux.dev>; Sat, 22 Apr 2023 15:05:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B781AC433D2;
	Sat, 22 Apr 2023 15:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682175912;
	bh=BeZWKYSkt4SNVVDk2ptTpOM40WXmKmAHxoXJN5J50xI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jmoudyiWOvBgSTxsgwV9/zAyB6ulsKA0X6WKt29r0pZVlGxmdSSmc+bl9pskqphTz
	 JxADDFYVFccUzfxBJ3OkLJhO8YAk6iUbWQrBPwKK+rEtyPBr6w5zgOUkOORrvJYRv0
	 AbdClQseaXRhJMifyln+sGsPjdv4AROHAlkQ1qvc=
Date: Sat, 22 Apr 2023 17:05:08 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Guenter Roeck <groeck@chromium.org>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 003/124] pwm: cros-ec: Explicitly set .polarity in
 .get_state()
Message-ID: <2023042239-sloping-sprite-7c24@gregkh>
References: <20230418120309.539243408@linuxfoundation.org>
 <20230418120309.688458749@linuxfoundation.org>
 <20230418130121.rx2zfwkzjyasghkg@pengutronix.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230418130121.rx2zfwkzjyasghkg@pengutronix.de>

On Tue, Apr 18, 2023 at 03:01:21PM +0200, Uwe Kleine-König wrote:
> On Tue, Apr 18, 2023 at 02:20:22PM +0200, Greg Kroah-Hartman wrote:
> > From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > 
> > [ Upstream commit 30006b77c7e130e01d1ab2148cc8abf73dfcc4bf ]
> > 
> > The driver only supports normal polarity. Complete the implementation of
> > .get_state() by setting .polarity accordingly.
> > 
> > Reviewed-by: Guenter Roeck <groeck@chromium.org>
> > Fixes: 1f0d3bb02785 ("pwm: Add ChromeOS EC PWM driver")
> > Link: https://lore.kernel.org/r/20230228135508.1798428-3-u.kleine-koenig@pengutronix.de
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> I see you picked this one and the similar sprd patch, but not
> 
> 	8caa81eb950c pwm: meson: Explicitly set .polarity in .get_state()
> 	b20b097128d9 pwm: iqs620a: Explicitly set .polarity in .get_state()
> 	6f5793798014 pwm: hibvt: Explicitly set .polarity in .get_state()
> 
> (At least I didn't get a mail about these). These should qualify in the same way.

They didn't all apply very well (one did).

> Maybe you also want to pick
> 
> 	1271a7b98e79 pwm: Zero-initialize the pwm_state passed to driver's .get_state()

I've queued that up to 6.2 only, the other trees it didn't apply to,
want to send a backport?

thanks,

greg k-h
