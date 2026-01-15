Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DA12EA151
	for <patches@lists.linux.dev>; Thu, 15 Jan 2026 14:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768488069; cv=none; b=mAQlBk+czq7rqOADPwy5AVAc6q5e1EAGaMCzUM8pXqBh4cczjHOeExtcp5avAnxb3TFfxovy3aLzfTirqezKUDOYGLeUn4h5RsRVwl02/wXVG487bUdDzJJ0xVcH8LbSU/YjVt1Ebc7IbCmvbOs2E8gEMQ27eLnq8u12xVLIHms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768488069; c=relaxed/simple;
	bh=GInh3nUv0oilWh4/RLwMQ0PHdeVF5xMKr3XHFWhjCro=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jFDzvWs6MHOxE6SBdm1FtQuUDIZ4tqgXrsTSihS9X692PHYcGYrPj6qEEjMdlhQIu/7vCIBnOco4D0ZY1IULU/hcndTdU7UPn+VSA6+UzkTgwrQmWgVtoQ1CvfLIWOHwUPJB5h8xWEfke1LxyUfPGy2Ol1uuitUfDZvJpc0d9TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bOS3S2LC; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bOS3S2LC"
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-7927b1620ddso14872817b3.0
        for <patches@lists.linux.dev>; Thu, 15 Jan 2026 06:41:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768488065; x=1769092865; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z81HGMXqVmwkEbr9DtP4R35AytWB4ncl1E46T6NrNg0=;
        b=bOS3S2LCwurQV7zZX+kQWbc2BQtiZYP4LldVvIC6Ig8Gd8P6X0aY7q5Kq8myBmRODo
         xRzSU5ew6pgLHTT3F7OB/oMp8V6BKuK8T31qAR5fyeypYVmu5fNyNDfxLn/dLmjnMYCt
         el8UNcclwh+5jr6l0Bye1ajQS99VSEDedMoCBpIbe3Cdj0Cbx1YpTruNc4CqGr2c1H6Z
         QlUUMvvMb25rbtq2kVjaryz6BsxoTTAoEOlihkGoCGRMEdzdvitOEum9q8mSrsZ6AdUZ
         qu1O0CUHoWhK0vpva7GdSUXT7tZx5HcH0nR81AtuuQmhUc2Rr8dwHXycvcZV9+DQCfdE
         D5NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768488065; x=1769092865;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Z81HGMXqVmwkEbr9DtP4R35AytWB4ncl1E46T6NrNg0=;
        b=ojpjGWOjUbrdFSgROsn7eIxKKJYbbDbKEfmISlDOvPdwzcs/vdlLGAZeYZCpeWwLIM
         h/w/ZNR1l8BTDGHzzacRTuVBGzvu5OaB/j/jGLULRX6xXkMyq5+pTPP0z0sl7AO7Bkq6
         Xq8IcpPqgop3i2JV8JOZdTyLHXju9hZ/0wNCIm82uWMvXp1Rx/MTArUELIaROf2Bkdu1
         K8P0lABBqOxFxEm742/C7Fg/OSlehAZ+gVXkqcevjE85dySLRMWniY0MlNVannQ9jA3b
         fntU5DgLY6OaOW+X2yXNp4a3tbGdhTQPZ+f7kyELhCJxdiOgeRjhIN3UZyrVKnqQtFEV
         HO2w==
X-Forwarded-Encrypted: i=1; AJvYcCWxZIqZaNaNGk/L/wTKSMoxDmr2+T/SmtrUUEns5r4Bc2ewG95FMdF7N3/B5t9ibWE+YnB7S9eO@lists.linux.dev
X-Gm-Message-State: AOJu0YySHNvvjs7CxOgRym8+gw1bIWstcWCmzxeRyviayJn84aJz/It1
	pUgZ15GJZOjh2RZVR/T8so4vWOVuKKrx2v2Tggk0419E3WOqtE1s3eInAIZEI2TfBB4TrvaadxL
	NHp1QN/kYifJ6tuYY8gdo7ljdG4X4X/VBmUri
X-Gm-Gg: AY/fxX66H3cQ23Iyd9jDYyCNZgvU3vz08NT3j4l0t46N2WTJoza002TiPxnp0tfc1B7
	mrOT/fFO2i9ZbP6AhYKnavfHJ6NCHBqjNtdHsOFn63QnL6Um3ukOO1Y+8YxyyUiJAfmdlvIvIuk
	utkvfydnWvhHYgr1/s+Q75aruTITcvzrWhgfFrZuKFYtTwdUd7D/R0ZX8sXgNws9TjWwgjo6xJG
	SeyDpoteNJZJYYeiSrVYqYW+vLm2TZyrFQlHlQRCYRpW+r1G22xOisdcw8KMP0lphEnqfY=
X-Received: by 2002:a05:690e:bc5:b0:644:50c7:a50f with SMTP id
 956f58d0204a3-6490a6349c2mr2227428d50.24.1768488065507; Thu, 15 Jan 2026
 06:41:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251215004145.2760442-1-sashal@kernel.org> <20251215004145.2760442-3-sashal@kernel.org>
 <CAPnZJGD0ifVdHTRcMzKBFX8UEf_me1KTrkbwezZrhzndcTx-3Q@mail.gmail.com>
 <aV5Ap8TgMEDLucWR@laps> <CAPnZJGCJ1LZRzfzO=958EfcrLm4Z3pYdtHZEpp812fstsUcOAQ@mail.gmail.com>
 <2026011119-stadium-trilogy-22ac@gregkh> <CAPnZJGAXLEgqKx+XA3RugES1kcawtqMEYPTzFERcf2kgRjNbFQ@mail.gmail.com>
 <2026011237-stage-cognitive-53c0@gregkh>
In-Reply-To: <2026011237-stage-cognitive-53c0@gregkh>
From: Askar Safin <safinaskar@gmail.com>
Date: Thu, 15 Jan 2026 17:40:29 +0300
X-Gm-Features: AZwV_QgBhEkHg8G4nrRtDlicjTzqS5qOFrS_cH_u9ZI-9GPpebn_HVcGMuB8Eec
Message-ID: <CAPnZJGCPM2hjbjX6_V5ko0KZ4m1gQ_fA2bL8R51UwiwQ3=ForQ@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 6.18-6.17] ALSA: hda: intel-dsp-config: Prefer
 legacy driver as fallback
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>, patches@lists.linux.dev, stable@vger.kernel.org, 
	Takashi Iwai <tiwai@suse.de>, Peter Ujfalusi <peter.ujfalusi@linux.intel.com>, 
	kai.vehmanen@linux.intel.com, cezary.rojewski@intel.com, 
	ranjani.sridharan@linux.intel.com, rf@opensource.cirrus.com, 
	bradynorander@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 12, 2026 at 1:54=E2=80=AFPM Greg KH <gregkh@linuxfoundation.org=
> wrote:
> On Sun, Jan 11, 2026 at 07:01:53PM +0300, Askar Safin wrote:
> > On Sun, Jan 11, 2026 at 3:24=E2=80=AFPM Greg KH <gregkh@linuxfoundation=
.org> wrote:
> > > Why?  I see no context here :(
> >
> > Please, backport 161a0c617ab1 to all stable kernels, which have 82d9d54=
a6c0e.
> >
> > 161a0c617ab1 fixes bug, reported by me here:
> > https://lore.kernel.org/all/20251014034156.4480-1-safinaskar@gmail.com/=
 .
> >
> > I did bisect and found that 2d9223d2d64c is the culprit. But then Takas=
hi Iwai
> > explained that the bug appeared earlier:
> > https://lore.kernel.org/all/87345iebky.wl-tiwai@suse.de/ .
> > Iwai said: "the bug itself was introduced
> > from the very beginning, and it could hit earlier".
> >
> > I assume "the very beginning" here should be interpreted as
> > "commit, where intel-dsp-config.c appeared", because the fix
> > modifies "intel-dsp-config.c".
> >
> > "intel-dsp-config.c" introduced in 82d9d54a6c0e, so
> > 161a0c617ab1 should be backported to all kernels, which
> > have 82d9d54a6c0e.
>
> This only applies to one tree (6.18.y), can you provide working
> backports for all of the other stable trees?

I just sent backport to 6.12.y.   I hope this backport will also apply
cleanly to older trees.

--=20
Askar Safin
