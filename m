Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33EB3FB1B
	for <patches@lists.linux.dev>; Wed, 17 Jul 2024 13:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721222286; cv=none; b=S13NLU4QXiDYsHM61G1ijFBQNJBHRJjCRuXO6IvmO1O8vaDgCjGKEnhwPRTT2R6U0hGuHOXPZwh+2GAi+r24yroZ0WSyAVo7qKfjD8COVlAuGMG2bBT/5txbx0U28W0ujfQzcUIGeOSGJrNzJL6i9HXQGk2ILFrVP+5kUm+bE4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721222286; c=relaxed/simple;
	bh=7iqN++i3ZubS2iWpxN4zveL0Qnvppbp3N9IY9JdbnCk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ytw8bT2GRX134UxUWzDhFyhUuDDBmlIaIa74pvNdCtsb4EYDtVEDk8wRkoeE9TjM5YT1+34M8SGRFkeq5VPvR9J38+kARehBuEeX4RJ/rnj9qaN29GZN8BFNOQEhaAd9B6qfG6pU2AlmLPP5+o8bnUfzyZ/EBvINrCHVLs9Dao4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kHcLqBw0; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kHcLqBw0"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4266b1f1b21so47670085e9.1
        for <patches@lists.linux.dev>; Wed, 17 Jul 2024 06:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721222283; x=1721827083; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NAhyVZeZNHfTLcG66iU3ZKzdyO8F8izpO1LD0DjM+SY=;
        b=kHcLqBw0VlyMbI9rzyIpjq27cPy/1w5CdvFZX1CP9hs8l3vaUHY1R0qpegJdxRJ0u7
         M98y3npCfuakbOuFpPY+f0CysId5g7v/KUTIre/oi9QnkleHqLMWqURtFdKa8+J0r+Dd
         YlgTKsHz61rrqT9p+bypTsscxKIFli7iH51nDzw7cO6NXtSoEdsSdrkBFuFp0dK5Orm2
         7X9+3R6xrLmkBL+90a6n4XRDI27mwzTXTfDQFYy9AgPHswltWNIgnflWl2m9fQ40BzUW
         HRavb7W6JOaxjyE72mgDfRi9Qgx9z1rEAoOkCDG7bim3BSpLNlc7d5KUqKVFetazAtmz
         Pdgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721222283; x=1721827083;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NAhyVZeZNHfTLcG66iU3ZKzdyO8F8izpO1LD0DjM+SY=;
        b=eUkomrAKmj+1cg4PVFvNmyzNXYbco4A834csWXq+4rGHVr3nveG2rnn6rUW/xKCG6f
         +JSLTeC4sN7zlyTI0Dk3KPnFruasL2KcIbgJcq9do1qFXAxFHEoU60Yrq39RZFh/DV4v
         rI1Tp2YPzQ7s01Q/GGWF0rW6psjW2Gb08fMd9bXd3yQbR/fKLmxH8obJW88YDDSv8ixH
         aEQJ6lyWd3XE3OfQfu4QE+b+TYcx4sJreLhJMnGf0QI0zJGhSPqb7OSA9gbl+slOOZuv
         08eOeDc9oL5p7VjkswFM0zM1iydYqg2aQcXxujTGhLqQAmI//hL6/KKzs3UXaNUCCH/u
         DTrw==
X-Forwarded-Encrypted: i=1; AJvYcCXmpRk0+Ol8PK/UKND1Sg6/txYTynkTlL6HYZ7utx7r9qZXkA/WhzeKjsOSJjLHaLrEnNTKAFPVinhQC7JUXS+YMjdrdVNLBg==
X-Gm-Message-State: AOJu0YwBWJeXchswBeAroTkvA6SXmmvSLJkfK54+tP0Pp6UG79FA174p
	mGRvyTwulOgsbP/LRbl5syqPQ1UPFbrayZe6rcq1Xi8vqbsGJN1+
X-Google-Smtp-Source: AGHT+IG73iIVHWwFvMUzu8BFUqMeRaf43cFZU+nf7tUgwHKOxX90SsCq15JXtQj9Ir9B66zbf0CCIw==
X-Received: by 2002:a5d:54cb:0:b0:367:9522:5e71 with SMTP id ffacd0b85a97d-368315f599dmr1162577f8f.10.1721222283046;
        Wed, 17 Jul 2024 06:18:03 -0700 (PDT)
Received: from skbuf ([188.25.155.184])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3680dafbb12sm11601866f8f.88.2024.07.17.06.18.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jul 2024 06:18:02 -0700 (PDT)
Date: Wed, 17 Jul 2024 16:18:00 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Christian Eggers <ceggers@arri.de>,
	Michal Kubiak <michal.kubiak@intel.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.9 015/143] dsa: lan9303: Fix mapping between DSA port
 number and PHY address
Message-ID: <20240717131800.s3xygkvilgiwopfe@skbuf>
References: <20240716152755.980289992@linuxfoundation.org>
 <20240716152756.575531368@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240716152756.575531368@linuxfoundation.org>

Hi Greg,

On Tue, Jul 16, 2024 at 05:30:11PM +0200, Greg Kroah-Hartman wrote:
> 6.9-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------

This patch has a trivial conflict, in the context:

> diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
> index 666b4d766c005..1f7000f90bb78 100644
> --- a/drivers/net/dsa/lan9303-core.c
> +++ b/drivers/net/dsa/lan9303-core.c
>  	chip->ds->priv = chip;
>  	chip->ds->ops = &lan9303_switch_ops;
>  	chip->ds->phylink_mac_ops = &lan9303_phylink_mac_ops;
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        here - this line is simply not present in stable kernels

> -	base = chip->phy_addr_base;
> -	chip->ds->phys_mii_mask = GENMASK(LAN9303_NUM_PORTS - 1 + base, base);
> +	chip->ds->phys_mii_mask = GENMASK(LAN9303_NUM_PORTS - 1, 0);
>  
>  	return dsa_register_switch(chip->ds);
>  }

But I don't advise backporting commits dd0c9855b413 ("net: dsa:
introduce dsa_phylink_to_port()") and cae425cb43fe ("net: dsa: allow DSA
switch drivers to provide their own phylink mac ops") in order to get
that one line into this patch's context - because that line is just noise
as far as this patch is concerned.

I'm confused of what happened here.

It looks like who generated these patches _knew_ that already, because
when the patch was backported for 6.6, that conflict was properly
resolved (notice how the chip->ds->phylink_mac_ops is not present in the
context here: https://lore.kernel.org/stable/20240716152751.831607687@linuxfoundation.org/).

But following that approach all the way to the end, "[PATCH 6.6 012/121]
net: dsa: introduce dsa_phylink_to_port()" (https://lore.kernel.org/stable/20240716152751.792628497@linuxfoundation.org/)
has no reason to exist! It is marked as a Stable-dep-of: the bug fix,
but said bug fix was not backported in its original form anyway.
Please drop it, it serves no purpose.

I would advise dropping the following Stable-dep-of: patches for 6.9:
https://lore.kernel.org/stable/20240716152756.461086951@linuxfoundation.org/
https://lore.kernel.org/stable/20240716152756.498971328@linuxfoundation.org/

and do the same for 6.9 as was done for 6.6: respin the patch without
the "chip->ds->phylink_mac_ops" line in the context.

Thanks,
Vladimir
