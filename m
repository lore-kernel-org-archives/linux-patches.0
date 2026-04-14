Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B4F356A0A
	for <patches@lists.linux.dev>; Tue, 14 Apr 2026 10:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776164016; cv=pass; b=Gm3vx+aVeLGBXlXyjdS2MRGpklnmjXzYYJ8XkhzMe4UGz895Hmi8RnD+ZEgBoqyGSg94XnT9zrPm1YcDCQxQPDnyhNme7hZSsDfvfMgEGX3xY+FNaOF09zI1EfHbDbxNISInWue0SeTSiMjuZ9yybYnHT5yEn+F3HL+IjisMhek=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776164016; c=relaxed/simple;
	bh=3Mq7kU0ij9LNAekgyk28BMaUIZSuE1bTDnMCbACGw2s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e+R/9SbQgyUo60vbEMVv6TaNwlE5+ve8MPaIOm7yDBCemwfnnVPzNr3HBKUjwrZBbjWnQEhODitr/ZO06Nwtb0nONWuTFHR0mZfmXmnhYPheca05tnvyRoeSP+lEpRlypHGob2TmVfoz051j8GQA3ZXWlf5W8bK3wJxFFW8/Hw4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KwJollKr; arc=pass smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KwJollKr"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5a402b2d102so1366781e87.3
        for <patches@lists.linux.dev>; Tue, 14 Apr 2026 03:53:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776164012; cv=none;
        d=google.com; s=arc-20240605;
        b=hiGR0AAA0UxsqzGAFzA7mm0jFcl2+p5BG8qmv/+a79I2QKHhtoP1Rl4CkVRSnbqOqx
         K1VE2lI1HgM1X7KqWAkcu91yTo2TdZOQCF9JSyfTbv/eJb2Qr5xAAkzaa12wSYtRPzlc
         TcEknUcIhCR1fqq0q9JydCjxLG5aTHQQu0ZPonsaUmLzH+ABHvMWldjefd3ozi2Wj58j
         Dw0PvFFMoVsatEXHng7CtIdp0rWQir8Eox5S33Pm/4Mdqxao9DZDujOvedzzKfhtIqrj
         el0DlCBIm2k/JCqBy9bQNsOolAowuAGe2mSQh/RL85vcDyz/iztYekH/RojOq2fIAZf1
         estw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=E41YxX1sAguGiwh6zEbSng5G2cnuAQxPK/F52SLRHFc=;
        fh=j4fhqUVAarjnsVfFNxNTXLMf5UY3hb3aUrbeuJtx0fU=;
        b=FefdOGN5EcXZQI7G5RCzHdx97SZwGzHPlETznhw6lD3sdA8LxEi556mfWokePKft25
         AgNMcEssknUBo5hNg9NHWs2m9GQqKmIql3JlH975p65yGSyWkEXlry0DGTu+SaiSO9l0
         lCCLiHCpMDUqzBXfvSOgwPkifsxXkpJsjXAD+q7I2hh+EdmlbiAy61Pdlhb1fymGY5WW
         ejkOA8mJX0VTNCmEsCa/Ayz0uCShKLwkpR4Bf86QQeXhh8aM82o7akCpWyIGclQzS5OX
         aWlctHCuFpSDv8/2nGa0mwi4E8oja1UNxRUaetomo3rLpg4aP32teILCgzYx/f5S/JHh
         uOrw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1776164012; x=1776768812; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=E41YxX1sAguGiwh6zEbSng5G2cnuAQxPK/F52SLRHFc=;
        b=KwJollKrhbYRMW3zHac94mr4PinTC+Xd0YvHtSUrcp1Ef4zQIzo+Us6CibMF87+GqM
         l4qWO2Szzz3VuQEGhH3awZ3MN7QXILq23KNA5md7PvtcBdbvt02eIacApk6Ss78Xs7YF
         S+WChU8LxOgOPyRApoQiuT+MU0/AR9cpo5mfoLGjpfSb0S7ftrh412n791jozEhyimgk
         qP6sGUg7TAglMG6fnvbNrS7CwfyyUSlFur8lE/x1TzbjHBxr1X59X6tGI36C9ewzAzaW
         0q1S64LYCAtDvBAHQ8Nacybq5rNM/G96Tqtybhemt8dyl18T3/5zL7N57AYRCUCD9Lx9
         IAzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776164012; x=1776768812;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E41YxX1sAguGiwh6zEbSng5G2cnuAQxPK/F52SLRHFc=;
        b=LvWdXqTBFxyd65OMzW6K0Tf32dsQZk/XXW7XcJK3iahNjiOYI/v9lgFt0kP3f48+Qi
         4zPuZfp5Ue28wIAwjLsrsKQzBsSqP7AkKBqETyeia2qWwBO5ItkIgNKxkS6ev/KPsj9A
         qt54eQBR3i0phuqMKIqujC6eKaYfKr9x2jZS/sSEYD1qpYWPnqkU0qqMG4oGgIZzq+Bc
         ltGub6Dsuq6acn+kbpKy6j1E3il1kA+yE6c0+GWvofJSLzohWWHQMyO5XmGswSuiP52F
         vvNlEFbV7DfcDueRUesm4ICeoM2HshP5w4omZrriShkjCjv+utoR7rv8z3GEa1xoz+5c
         VGGw==
X-Gm-Message-State: AOJu0YxZdJZuGktGzFll2deGQrtY08Gf26CBOjxuuCKIXEPvOfmpIU71
	hnhkzt9t2fG3iTRhJ5/WQ8qZcFgjLDK+V53KArsHmWhNwAba8dQJv+bz29wSKM3YX0TOKQr/QVa
	Uubrd3/BSsIiWu1+aFvYrURGkOZHwWC6tf0n8jXBaKg==
X-Gm-Gg: AeBDietOQgXx3olZvYz/WAqpJwrJbdh03UMyUVHsgyjABrhgOhTTZKdqWL/f5TVmCqi
	5yQvHesAzfrBuGu4zdIoQi0L+tyr7PLK/gOXPXMZa9bCkwtdq6l3f4rkRB3ZluQGwi78x7Z6CSi
	FYd71uKE2XN/56yMEPNRAxFzImiYvPyy7FCWOq/hH3bWS1gv9LkyETPLBcOduR+9nsdw99ghWrR
	4YuRRia/1xUXUDa2zJL6HQAg/IMjQb2c6K1u1vfyoz/VnkicuX7QnbuoUP/PjkHv63sxBRuLkJ/
	PuZlC15q
X-Received: by 2002:a05:6512:39c6:b0:5a3:cc81:efdb with SMTP id
 2adb3069b0e04-5a3efb8ba02mr5334362e87.21.1776164012025; Tue, 14 Apr 2026
 03:53:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260413155819.042779211@linuxfoundation.org> <20260413155836.794775290@linuxfoundation.org>
 <65cd5a0b7c68af467b8b13b4fbce51cc2febb5ad.camel@decadent.org.uk>
In-Reply-To: <65cd5a0b7c68af467b8b13b4fbce51cc2febb5ad.camel@decadent.org.uk>
From: Ulf Hansson <ulf.hansson@linaro.org>
Date: Tue, 14 Apr 2026 12:52:56 +0200
X-Gm-Features: AQROBzB8UduscqLXoj3HY1wGSVAb7et8WKMiE9PyT9lKdB3KXH6kPAKVBpwdnvk
Message-ID: <CAPDyKFo1DWRbidKrMg+DkwOxsdzDrfF5+YVhjjzGZzkAC7=Yfg@mail.gmail.com>
Subject: Re: [PATCH 5.10 474/491] mmc: core: Drop superfluous validations in mmc_hw|sw_reset()
To: Ben Hutchings <ben@decadent.org.uk>
Cc: patches@lists.linux.dev, Adrian Hunter <adrian.hunter@intel.com>, 
	Sasha Levin <sashal@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 13 Apr 2026 at 23:10, Ben Hutchings <ben@decadent.org.uk> wrote:
>
> On Mon, 2026-04-13 at 18:01 +0200, Greg Kroah-Hartman wrote:
> > 5.10-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Ulf Hansson <ulf.hansson@linaro.org>
> >
> > [ Upstream commit fefdd3c91e0a7b3cbb3f25925d93a57c45cb0f31 ]
> >
> > The mmc_hw|sw_reset() APIs are designed to be called solely from upper
> > layers, which means drivers that operates on top of the struct mmc_card,
> > like the mmc block device driver and an SDIO functional driver.
> >
> > Additionally, as long as the struct mmc_host has a valid pointer to a
> > struct mmc_card, the corresponding host->bus_ops pointer stays valid and
> > assigned.
> >
> > For these reasons, let's drop the superfluous reference counting and the
> > redundant validations in mmc_hw|sw_reset().
>
> Is this reasoning still correct for older branches such as 5.10?

Yes, I think it should be fine.

>
> And if so, do they also need commit 406e14808ee6 ("mmc: block: Remove
> error check of hw_reset on reset"), which claims to fix this one?  I
> don't really follow the explanation in its commit message.

Yes, good point, this commit is needed as well!

Kind regards
Uffe

>
> Ben.
>
> >
> > Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> > Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
> > Link: https://lore.kernel.org/r/20210212131532.236775-1-ulf.hansson@linaro.org
> > Stable-dep-of: 901084c51a0a ("mmc: core: Avoid bitfield RMW for claim/retune flags")
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  drivers/mmc/core/block.c |    2 +-
> >  drivers/mmc/core/core.c  |   21 +--------------------
> >  2 files changed, 2 insertions(+), 21 deletions(-)
> >
> > --- a/drivers/mmc/core/block.c
> > +++ b/drivers/mmc/core/block.c
> > @@ -987,7 +987,7 @@ static int mmc_blk_reset(struct mmc_blk_
> >       md->reset_done |= type;
> >       err = mmc_hw_reset(host);
> >       /* Ensure we switch back to the correct partition */
> > -     if (err != -EOPNOTSUPP) {
> > +     if (err) {
> >               struct mmc_blk_data *main_md =
> >                       dev_get_drvdata(&host->card->dev);
> >               int part_err;
> > --- a/drivers/mmc/core/core.c
> > +++ b/drivers/mmc/core/core.c
> > @@ -2096,18 +2096,7 @@ int mmc_hw_reset(struct mmc_host *host)
> >  {
> >       int ret;
> >
> > -     if (!host->card)
> > -             return -EINVAL;
> > -
> > -     mmc_bus_get(host);
> > -     if (!host->bus_ops || host->bus_dead || !host->bus_ops->hw_reset) {
> > -             mmc_bus_put(host);
> > -             return -EOPNOTSUPP;
> > -     }
> > -
> >       ret = host->bus_ops->hw_reset(host);
> > -     mmc_bus_put(host);
> > -
> >       if (ret < 0)
> >               pr_warn("%s: tried to HW reset card, got error %d\n",
> >                       mmc_hostname(host), ret);
> > @@ -2120,18 +2109,10 @@ int mmc_sw_reset(struct mmc_host *host)
> >  {
> >       int ret;
> >
> > -     if (!host->card)
> > -             return -EINVAL;
> > -
> > -     mmc_bus_get(host);
> > -     if (!host->bus_ops || host->bus_dead || !host->bus_ops->sw_reset) {
> > -             mmc_bus_put(host);
> > +     if (!host->bus_ops->sw_reset)
> >               return -EOPNOTSUPP;
> > -     }
> >
> >       ret = host->bus_ops->sw_reset(host);
> > -     mmc_bus_put(host);
> > -
> >       if (ret)
> >               pr_warn("%s: tried to SW reset card, got error %d\n",
> >                       mmc_hostname(host), ret);
> >
> >
>
> --
> Ben Hutchings
> When in doubt, use brute force. - Ken Thompson
