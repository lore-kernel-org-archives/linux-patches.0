Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F7612B73;
	Sun, 11 Aug 2024 10:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723373174; cv=none; b=Wq079Q/GdPa0myuki4ZW5pl86DiH30Gb3vdvWWK2hPLNcq5dx+77BX3BDUEjTjWeRWfCCUPiqSKJF364bTA8h/shi3wtjeNUpS3rKtjTtjEcH+3JcU/Hhh0biBmAirWaPO11BM1u99peVpiabWJHIHr9BFyY2WkfVqzbRvPsDRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723373174; c=relaxed/simple;
	bh=ya0U/CukjHEuE3EJl1uejmb+OWvglDDyYnGGSl5ClmM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q863gpbBii1f2kPtoqwJ/KtI8sfR9fJLjxTUg1gXjN+SY7U5H7Nf9syrXi9ZSCcz/PzV9bNsMDisNJILIC8xEhMPmpeJIiRWoddF5CfZjvYVABDe2aFyfedQvFj0gyNkJIc5Pa6+ojxMXUZyoVRmnjNTp65KbUn5EA5Mg0y/wEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0pYrzlbn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0pYrzlbn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3665C32786;
	Sun, 11 Aug 2024 10:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723373174;
	bh=ya0U/CukjHEuE3EJl1uejmb+OWvglDDyYnGGSl5ClmM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=0pYrzlbnb7h/U7lTEmJ4NQEge2FamTxuq9d1aOf9fjzo7BeZ/oouMKG81aAou13JF
	 Mrj5ScKz5MeCKyHR1K5MSPYTaWtfmdaFErVhlL+LuMEib5/BCT+ru1hucqE7gXA8Tm
	 6pHxtWgLWXkdf11TB3nhHAo1UwM6KywC8CP3DjNg=
Date: Sun, 11 Aug 2024 12:46:11 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@baylibre.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 011/121] thermal: bcm2835: Convert to platform remove
 callback returning void
Message-ID: <2024081154-unwary-alphabet-8d63@gregkh>
References: <20240807150019.412911622@linuxfoundation.org>
 <20240807150019.742020612@linuxfoundation.org>
 <fqozvio6zhj3vow2h6zayfmtbi3c5ups6vkihymzabhk6cfuf3@gu4b4j7cyltj>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fqozvio6zhj3vow2h6zayfmtbi3c5ups6vkihymzabhk6cfuf3@gu4b4j7cyltj>

On Thu, Aug 08, 2024 at 08:11:04AM +0200, Uwe Kleine-König wrote:
> Hello Greg,
> 
> On Wed, Aug 07, 2024 at 04:59:03PM +0200, Greg Kroah-Hartman wrote:
> > 6.6-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > 
> > [ Upstream commit f29ecd3748a28d0b52512afc81b3c13fd4a00c9b ]
> > 
> > The .remove() callback for a platform driver returns an int which makes
> > many driver authors wrongly assume it's possible to do error handling by
> > returning an error code. However the value returned is ignored (apart
> > from emitting a warning) and this typically results in resource leaks.
> > 
> > To improve here there is a quest to make the remove callback return
> > void. In the first step of this quest all drivers are converted to
> > .remove_new(), which already returns void. Eventually after all drivers
> > are converted, .remove_new() will be renamed to .remove().
> > 
> > Trivially convert this driver from always returning zero in the remove
> > callback to the void returning variant.
> > 
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Stable-dep-of: e90c369cc2ff ("thermal/drivers/broadcom: Fix race between removal and clock disable")
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  drivers/thermal/broadcom/bcm2835_thermal.c | 6 ++----
> >  1 file changed, 2 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/thermal/broadcom/bcm2835_thermal.c b/drivers/thermal/broadcom/bcm2835_thermal.c
> > index 3acc9288b3105..5c1cebe075801 100644
> > --- a/drivers/thermal/broadcom/bcm2835_thermal.c
> > +++ b/drivers/thermal/broadcom/bcm2835_thermal.c
> > @@ -282,19 +282,17 @@ static int bcm2835_thermal_probe(struct platform_device *pdev)
> >  	return err;
> >  }
> >  
> > -static int bcm2835_thermal_remove(struct platform_device *pdev)
> > +static void bcm2835_thermal_remove(struct platform_device *pdev)
> >  {
> >  	struct bcm2835_thermal_data *data = platform_get_drvdata(pdev);
> >  
> >  	debugfs_remove_recursive(data->debugfsdir);
> >  	clk_disable_unprepare(data->clk);
> > -
> > -	return 0;
> >  }
> >  
> >  static struct platform_driver bcm2835_thermal_driver = {
> >  	.probe = bcm2835_thermal_probe,
> > -	.remove = bcm2835_thermal_remove,
> > +	.remove_new = bcm2835_thermal_remove,
> >  	.driver = {
> >  		.name = "bcm2835_thermal",
> >  		.of_match_table = bcm2835_thermal_of_match_table,
> 
> While I'm confident this patch not to break anything (there are so many
> of this type in mainline now and none regressed), it should be also easy
> to port the follow up patches onto 6.6.x without this change.
> 
> No strong opinion and maybe being able to cleanly cherry pick later
> changes is important enough to keep this conversion? Otherwise I'd tend
> to drop this patch.

Thanks for the review, I'll leave it in as it made it simpler for the
next commit.

thanks,

greg k-h
