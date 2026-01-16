Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8159C366DB5;
	Fri, 16 Jan 2026 11:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768561659; cv=none; b=YJ1JeQTKkNPqggEROneQCx9pqGxz0jKc80mgXY0+NkyYoQuN7C4vW7gVIGdbsKNxoY9/6P+Sme8J0DJ4kkm7op/dJxCQbrpoZE0jT+xZQs33Ylo/cVG8rPMNbopRCGImONBB458sna498yQyzB2o4XmMi3yN/UvJsIMZ93JNzF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768561659; c=relaxed/simple;
	bh=Qx/fqFqAFpHDudV7S6oyoApPtcnS8CberJhxPURFgqI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GR2V4xOFgNzhtc+Dmu8t0mxHr43/QTAuZSTgarIHzrBVyXKXTzWYe4rkWzxwVNslRLENpRyKY5vRdsFmPc+fhjOuLglbE5P3xcatX5MaDajf0ylNFRQbmFQw4H6BrknB7LxuPfwKWdbVHI9ZRoof0cVZLl9a4E9YMr1uGSX/vTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l3e3dlK1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l3e3dlK1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6BD5C16AAE;
	Fri, 16 Jan 2026 11:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768561655;
	bh=Qx/fqFqAFpHDudV7S6oyoApPtcnS8CberJhxPURFgqI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l3e3dlK1ceCxUfvk7KMciIJiUkba1U9BAHsvlAdc6cXepQO/iI1FFMcoqHaKmixrt
	 QmdkDjKVJ59NAxoB7Va5Oq36kQD06sKibsjJPY1ag85ry3SAYE/VBsmhHovHlHEnu+
	 ekuaZL2ItmC2nB+pH79opR/+tyxFeDJJ6s6FdzPA=
Date: Fri, 16 Jan 2026 12:07:32 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@baylibre.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Mark Brown <broonie@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 477/554] ASoC: stm: stm32_sai_sub: Convert to
 platform remove callback returning void
Message-ID: <2026011624-mushiness-violate-e860@gregkh>
References: <20260115164246.225995385@linuxfoundation.org>
 <20260115164303.569810160@linuxfoundation.org>
 <3tzxbwj2j7jph4virzzizrd66qikkjofz34koc5s5hmrynhaek@dyx2xciugqep>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3tzxbwj2j7jph4virzzizrd66qikkjofz34koc5s5hmrynhaek@dyx2xciugqep>

On Fri, Jan 16, 2026 at 10:00:16AM +0100, Uwe Kleine-König wrote:
> Hello,
> 
> On Thu, Jan 15, 2026 at 05:49:03PM +0100, Greg Kroah-Hartman wrote:
> > 5.15-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > 
> > [ Upstream commit a3bd37e2e2bce4fb1757a940fa985d556662ba80 ]
> > 
> > The .remove() callback for a platform driver returns an int which makes
> > many driver authors wrongly assume it's possible to do error handling by
> > returning an error code. However the value returned is (mostly) ignored
> > and this typically results in resource leaks. To improve here there is a
> > quest to make the remove callback return void. In the first step of this
> > quest all drivers are converted to .remove_new() which already returns
> > void.
> > 
> > Trivially convert this driver from always returning zero in the remove
> > callback to the void returning variant.
> > 
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > Acked-by: Takashi Iwai <tiwai@suse.de>
> > Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
> > Link: https://lore.kernel.org/r/20230315150745.67084-139-u.kleine-koenig@pengutronix.de
> > Signed-off-by: Mark Brown <broonie@kernel.org>
> > Stable-dep-of: 23261f0de094 ("ASoC: stm32: sai: fix OF node leak on probe")
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> While this patch is trivial and there are many patches like that in both
> mainline and already backported to stable without any known problems, it
> is also not very hard to backport 23261f0de094 to 5.15.y without this
> patch. The merge resolution relevant is just:
> 
> diff --cc sound/soc/stm/stm32_sai_sub.c
> index 2a2fc2f0ebbd,c7930d8f9ded..000000000000
> --- a/sound/soc/stm/stm32_sai_sub.c
> +++ b/sound/soc/stm/stm32_sai_sub.c
> @@@ -1579,8 -1587,7 +1587,9 @@@ static int stm32_sai_sub_remove(struct 
>   	snd_dmaengine_pcm_unregister(&pdev->dev);
>   	snd_soc_unregister_component(&pdev->dev);
>   	pm_runtime_disable(&pdev->dev);
> + 	of_node_put(sai->np_sync_provider);
>  +
>  +	return 0;
>   }
>   
>   #ifdef CONFIG_PM_SLEEP
> 
> I don't feel very strong here, but IMHO this is trivial enough to skip
> backporting the conversion to .remove_new() and it would be the right
> thing from a pedantic POV. OTOH I also don't want to reply to each such
> backport, don't object getting patches into stable, don't know how
> the stable maintainers feel here and don't want to impose additional
> work on anyone if just picking up the conversion is considered ok and
> easier with the established workflow.

Good idea, now done, thanks.

greg k-h
