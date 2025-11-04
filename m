Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA1E242D88
	for <patches@lists.linux.dev>; Tue,  4 Nov 2025 17:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762275669; cv=none; b=ueSuN/AN2ZBy/2SLbh9rqa7xAHpQ7QjZWAewHWuCk+RWUaQnJMgU9Lnn7ndorY96Uu7vNNUyyqBkZQY4O+DqgmchsNs0ISKEZBOtoamspJlqAWugDNFr7qdIgXe3ICH2JIV89Jn/PvwvVrSOuu72mpahsD11yFNhmFTpYFx3rgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762275669; c=relaxed/simple;
	bh=A5hVs65aVEjMq28wLqSGze1IxyHY/ziAOGAuCp034rU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pU2Li4Kc0MiGoX1Ae0MuD6gjdfnX2FzcjXNZ+nD8oHTJ9Xs/irFC6n1ycCZQGXFNovwYg++BTAYjZVYXBO3ggIjYzmfy1JGn9A1l/VTVnjb8oYE81JRf4Kf3/1kRaIr3f47SB4ByIGe9Gl0ZK27+V2sgGJoQosrSGF43w2QCXy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HUOSlfUN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HUOSlfUN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D304CC4CEF7;
	Tue,  4 Nov 2025 17:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762275669;
	bh=A5hVs65aVEjMq28wLqSGze1IxyHY/ziAOGAuCp034rU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HUOSlfUNGPF0XIHP239Y3KM2928OhCG/CMcUKqlFDLASvpETQEkQyq/5IIazW/w0S
	 wInfDwWPBMyjRGsWLjHji+VtSUmxr28A4Syxr1a8f6JDcmbgHgYXhzvxBehospKbPY
	 SycxH1UXRaCXTqPoV3f5LW00sD3+9313yA8FXb24FCOLAX7zrPwzO9DpiRLboBc+q8
	 XvqilpF5OoYQu2ZINL4nfSnnxZw+7XzH/WHKCq/ul1vcOF+zJPWHp36JIkyRwa+XAl
	 xJNKMGlLBKmIYLfr7tlTyGKkieEXhikFDwc0DjZu8FvZx7ckV+dqpodmIY69IEzor7
	 J4gJgJaSqDntQ==
Date: Tue, 4 Nov 2025 10:01:04 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Lee Jones <lee@kernel.org>, Daniel Thompson <danielt@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	linuxppc-dev@lists.ozlabs.org, patches@lists.linux.dev
Subject: Re: [PATCH 2/2] macintosh/via-pmu-backlight: Include linux/of.h and
 uapi/linux/fb.h
Message-ID: <20251104170104.GA1416336@ax162>
References: <20250925-ppc-fixes-for-backlight-fb-h-removal-v1-0-d256858d86a6@kernel.org>
 <20250925-ppc-fixes-for-backlight-fb-h-removal-v1-2-d256858d86a6@kernel.org>
 <c1aecfba-fa12-4572-885d-925e9afa1494@suse.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c1aecfba-fa12-4572-885d-925e9afa1494@suse.de>

On Tue, Nov 04, 2025 at 01:43:26PM +0100, Thomas Zimmermann wrote:
> Hi
> 
> Am 26.09.25 um 01:46 schrieb Nathan Chancellor:
> > After the recent removal of the fb.h include from backlight.h, which
> > transitively included of.h, there are several errors from
> > via-pmu-backlight.c (errors from bl_curve not being properly defined
> > omitted):
> > 
> >    drivers/macintosh/via-pmu-backlight.c:22:20: error: 'FB_BACKLIGHT_LEVELS' undeclared here (not in a function)
> >       22 | static u8 bl_curve[FB_BACKLIGHT_LEVELS];
> >          |                    ^~~~~~~~~~~~~~~~~~~
> >    drivers/macintosh/via-pmu-backlight.c: In function 'pmu_backlight_get_level_brightness':
> >    drivers/macintosh/via-pmu-backlight.c:63:38: error: 'FB_BACKLIGHT_MAX' undeclared (first use in this function); did you mean 'BACKLIGHT_RAW'?
> >       63 |         pmulevel = bl_curve[level] * FB_BACKLIGHT_MAX / MAX_PMU_LEVEL;
> >          |                                      ^~~~~~~~~~~~~~~~
> >          |                                      BACKLIGHT_RAW
> >    drivers/macintosh/via-pmu-backlight.c: In function 'pmu_backlight_init':
> >    drivers/macintosh/via-pmu-backlight.c:144:17: error: implicit declaration of function 'of_machine_is_compatible' [-Wimplicit-function-declaration]
> >      144 |                 of_machine_is_compatible("AAPL,3400/2400") ||
> >          |                 ^~~~~~~~~~~~~~~~~~~~~~~~
> > 
> > FB_BACKLIGHT_{LEVELS,MAX} are available from the userspace API fb.h so
> > just include that avoid dragging in the full fb.h header unnecessarily.
> > Include linux/of.h for of_machine_is_compatible().
> > 
> > Fixes: 9f218f9bb9d2 ("backlight: Do not include <linux/fb.h> in header file")
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > ---
> >   drivers/macintosh/via-pmu-backlight.c | 2 ++
> >   1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/macintosh/via-pmu-backlight.c b/drivers/macintosh/via-pmu-backlight.c
> > index 26bd9ed5e664..f7b7853b3802 100644
> > --- a/drivers/macintosh/via-pmu-backlight.c
> > +++ b/drivers/macintosh/via-pmu-backlight.c
> > @@ -11,7 +11,9 @@
> >   #include <asm/ptrace.h>
> >   #include <linux/adb.h>
> >   #include <linux/backlight.h>
> > +#include <linux/of.h>
> >   #include <linux/pmu.h>
> > +#include <uapi/linux/fb.h>
> 
> Should this not be <linux/fb.h> ?

It could be but as I mention above, this file only needs the UAPI
FB_BACKLIGHT_LEVELS and FB_BACKLIGHT_MAX constants so I did not really
feel like it was worth it to drag in the whole fb.h header.

> >   #include <asm/backlight.h>
> >   #define MAX_PMU_LEVEL 0xFF
> > 
> 
> -- 
> --
> Thomas Zimmermann
> Graphics Driver Developer
> SUSE Software Solutions Germany GmbH
> Frankenstr. 146, 90461 Nürnberg, Germany, www.suse.com
> GF: Jochen Jaser, Andrew McDonald, Werner Knoblich, (HRB 36809, AG Nürnberg)
> 
> 
