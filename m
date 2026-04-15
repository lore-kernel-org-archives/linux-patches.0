Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8A9361DD2
	for <patches@lists.linux.dev>; Wed, 15 Apr 2026 05:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776232159; cv=pass; b=rGdhm0QO26Uv9wkUVAPT1z9ikqrkOk/28a6IkfFINaPZx4gZmp3LsOtA1/TG6RQFSCPpsIGsJkeIKAmc6QOTG2YBG7AyjMRjLz89H64g2BvNwogOlY7CpgjILmMye6oDtYRngLSkPfBsQOqwlMytLkJW7MbhS7uU+nV1Q0NBRis=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776232159; c=relaxed/simple;
	bh=0Ko4VIiZxkI/O2taJ+3DwN8b1cZwadpXOzMv+Q9JyHg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z1v7nrtC788zEldY015VRKW88wztu+GvOLh3rnGPz8hqIGrs5j47Ca1x3UOqqOumeO7cxJGAS7PJHRuhz5pPWOv7pMxXDgLz3iQy626457/rvc8L+xoRFKG2+oneQ8m90Jcrrlb/wX+1exD2Dtf+loyp+If0sEuzCSBgjdNfGx0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bqe2JKKU; arc=pass smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bqe2JKKU"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-89fc349b5ceso99259546d6.3
        for <patches@lists.linux.dev>; Tue, 14 Apr 2026 22:49:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776232156; cv=none;
        d=google.com; s=arc-20240605;
        b=S0ccmUqOjHGFJGFyuSJuWnbdM143pvD64dSWOorSDiMfo7SozWOqmlCJvYWE8sc8/O
         ODymmZVg0poRPqq+PnW9/LiRrkmum/YqLFqgL3PeuIli0UFHepIKJvc/8OC6bcscsg7k
         HTO3K7+fViVeuxDC/tWpAuUwkAe7cst1R95ScxEiIXEzrcze1k0PBBzz++bKXRUT6dBt
         D4KTXf6TCUYUKoHfdkGShoXZ0zo6+xre19/pZZ7jPgEoHfd7C7jHJLceEBHog4Rcmgm2
         GjzNPoMd4grvLISGYYyXHBwtyZhsAKvD7uZYGSaUP5hVryskVkQDC0N/ur6EIn9xyV0h
         HOSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=g7jC+e6yTEY26VnAI6j6zPGlJNJqrM6o2NkoHZehI4k=;
        fh=Zq3XXl6IS4TdCnsE45rTgTO/gtqzLQKZ+RaNNUpFKvM=;
        b=HPTY/sHGDkHGnM4U3aCs7D5GiXP5FWaddvMFsXE6UK3z3KCuyPr1CUoxBJ13GEuQkp
         G6puCDdt3Viz8jBWHV02tDACRh8ifTq7dACHL+PnJLMlLZly8uzE5CaPfXdiw0xSu+wL
         6qCzups2FD3pG/5w1EtD3EqU3w73J/Db3OfmQZePtt55J5LQsfi+vG05XOniDZAGxXl/
         qDNIzkwiomvLXUIuvVDMSKbqcFatN7WlMAPizRz4RiNLBFQQVjQRPRA+QXbRv4V/bC0v
         TSeo1BMlA8UXUHdVvqzgmvWZoCGFNXLPmSsaqHebKuQ413E1NXwP6SddMjy0Mp28bXaE
         2smg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1776232156; x=1776836956; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g7jC+e6yTEY26VnAI6j6zPGlJNJqrM6o2NkoHZehI4k=;
        b=bqe2JKKU82ht0B3NOcKrXEUPrmebs6fTGrfj7TWy4DzgGPWcRQkIjaf3zwodpEUo5f
         9ryE1EZ073xVyHp8FoQiV7VuSZTLw4pNIuhhSs1VXrFr/WUJNoltmAf4+TQOMDLr7Lp7
         JCES892SXbB2Ghf7WphxfgP16UetTSfogHckfZHtUO3rgSw77vpd4PO0fZpNwrJoCSUl
         NHwqEwuowAOg3AW5QaJmGB97mr8plzE+dmz3OgY62V5AwDCZOhkKdYDbW/ZTsuBMM4fW
         v74jjrdaOXFxddjxXKgAOSHqm3TjraWvsk+8wDcKgyK1E4uwEh6DVWjTFAG/4OcbHlSJ
         aApw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776232156; x=1776836956;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=g7jC+e6yTEY26VnAI6j6zPGlJNJqrM6o2NkoHZehI4k=;
        b=YlWgLTXDuAXz9tkQrsXgMcWNPRw+79qfqvwpjqoYMdVCFIu1TjgFpSQ9hRRaph6U4B
         zSKNv6RMX3t7NG3w1VCqcsTmvw7FkkisUmGDpvg7YTx5cr0SFgeYLq5Yl7Va2AbJrKdh
         YP6YGCudA/0ALSl3QJKMU194MqtT9IuP69puexzW8r5Aae7uV7cxzkwa7QQIvO7oVs6y
         eEPBlWWrgunX4MSFcfhYHJeSynp8lRE5he71lwPxxjfUqMhMR8EqRwoYJkf41Q9I8U7w
         FnxvH94VBzaomZBhAJ5s6FMWiZBo/s+XDjaETiaVt0QarQIf3iwBKgItx4bQmdJPBfhs
         vjuQ==
X-Forwarded-Encrypted: i=1; AFNElJ8Q0//HSJvHA2K7PAk2v4dozjYNQTN3iA9xB7/WZjcqAnNm+n0fOeS0LbSmsB6ni0pGX/uXhWHf@lists.linux.dev
X-Gm-Message-State: AOJu0YxMzrzLNYUJmiTw6Jrv5EioqgocU5d/nLHM/y993mxeuccoNilm
	BKa8WBaGJEFyJwsTdIfDf/eQTuxdopi8fBde6iZ9W5hBgEccpmDFHMIVwIGZfzKfOHp6bwFN3Ph
	ZxFPAN6Mc932435vnLJSOlWMHrM2n4sid+koyB220
X-Gm-Gg: AeBDievezSfLnmOGFK44Q3tTf6Mfx/NqPcqANcKiW7TZlT/XRoWmM7QWMIEkX5o6yvc
	wDBQzKl+QRpz08PlWHNq5zpmAHJD/lsE7EaK0oL4/gSmbvcTdm51XBh55tnXbo6N0BQXj1VMh+y
	dNwujyPTwN0Z3dvjwR57T7D+PMhgiL3m/BgOgSwO1F/A/t5Blp8O3YxJ4vQ/5Gs89knu8jCIRcR
	BTIfku9wDdze0S05ulIqRbLhoUcLHAWgl33KBzNWMCMnY0reImPLVdbF1HMh7TXZD2kLoRtb0HT
	REH7M7uQNoqtH1JO0z/bvFVUcADEDamEmNUhEinerkLn9K6alH6YJPc0UMw9PvhshLURkjY=
X-Received: by 2002:ad4:5bc7:0:b0:8ac:ae56:b493 with SMTP id
 6a1803df08f44-8acae56b656mr198973546d6.40.1776232155593; Tue, 14 Apr 2026
 22:49:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260413155819.042779211@linuxfoundation.org> <39e878af-7418-4538-9e1f-8b62de3d1e3f@nvidia.com>
 <ad30ns8QQDzk0h72@duo.ucw.cz>
In-Reply-To: <ad30ns8QQDzk0h72@duo.ucw.cz>
From: Ben Copeland <ben.copeland@linaro.org>
Date: Wed, 15 Apr 2026 06:49:04 +0100
X-Gm-Features: AQROBzBEqY4mG6hUOd2h2ReML6KwVLMY91sTJvZDNC4GxKeXzWsyi3AnMxmOomg
Message-ID: <CAL0q8a65x5mK2K+X8bY3sPrG8JMhbN7uDMje7JJNvvmzaR_SiQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/491] 5.10.253-rc1 review
To: Pavel Machek <pavel@nabladev.com>
Cc: Jon Hunter <jonathanh@nvidia.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	stable@vger.kernel.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de, 
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org, 
	sr@sladewatkins.com, 
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 14 Apr 2026 at 09:03, Pavel Machek <pavel@nabladev.com> wrote:
>
> On Mon 2026-04-13 19:52:08, Jon Hunter wrote:
> > Hi Greg,
> >
> > On 13/04/2026 16:54, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.10.253 release=
.
> > > There are 491 patches in this series, all will be posted as a respons=
e
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> > >
> > > Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >     https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.253-rc1.gz
> > > or in the git tree and branch at:
> > >     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> > >
> > > -------------
> > > Pseudo-Shortlog of commits:
> >
> > ...
> > > Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
> > >      bus: omap-ocp2scp: Convert to platform remove callback returning=
 void
> >
> >
> > I am seeing the following build error due to the above change on ARM pl=
atforms ...
> >
> > drivers/bus/omap-ocp2scp.c:95:10: error: 'struct platform_driver' has n=
o member named 'remove_new'; did you mean 'remove'?
> >    95 |         .remove_new     =3D omap_ocp2scp_remove,
> >       |          ^~~~~~~~~~
> >       |          remove
> > drivers/bus/omap-ocp2scp.c:95:27: error: initialization of 'int (*)(str=
uct platform_device *)' from incompatible pointer type 'void (*)(struct pla=
tform_device *)' [-Werror=3Dincompatible-pointer-types]
> >    95 |         .remove_new     =3D omap_ocp2scp_remove,
> >       |                           ^~~~~~~~~~~~~~~~~~~
> >
>
> We see that one, too:
>
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/1390=
1155305
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines=
/2450043152
>
> Best regards,

This was also observed on KernelCI:

https://dashboard.kernelci.org/tree/stable-rc/linux-5.10.y/0abb5988a311f0e6=
17615aa4b08c90b3ade85c25?df%7Ca%7Carm=3Dtrue

The two issues:

https://dashboard.kernelci.org/issue/maestro%3A67d434ff5d6b71886d45efe758ca=
00ff45cb969a?iv=3D1
https://dashboard.kernelci.org/issue/maestro%3Ac970827f049cfd67124148e3c19a=
be1d4aa8347a?iv=3D1

Regards

Ben

>                                                                          =
       Pavel
