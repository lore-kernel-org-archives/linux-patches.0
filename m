Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36BB53368
	for <patches@lists.linux.dev>; Wed,  1 May 2024 16:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714580317; cv=none; b=EWcTcocexZiLUXRMFoYbrF5fDA9WgxDeaQIa/Mprwq03FGDXRCO2Sg7Uz8w+h+3KTSlEuuzJlvEfo8ATDAgbJD8xM7G4oKdHL0OoFvTLnOBR/njpqj5JYeKSvF7F2MgDnDdlIqDSLZ71VU7DgMy/PUEoLAGm8rnzBAzDKLGn5Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714580317; c=relaxed/simple;
	bh=RrsRAJmWysXYR4n1Z7QuovA3tEKIJY2HwJxpKg4/cqM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=enNOjcUtaqEgCWVXj4jucy173yXj2SUvNizs2A6A0dcKoOxKA7aPROFpgi6EApwkqPkcl7EDY6Pzq12/NLtFa9DoLK1CdYTzDg3R9fsFLJ2gFa/St3AeIqi7WyhuBMcM2D+gxNR/tTJNL5TuxBmupWQSxfUCzhUHjrQxkjY4dJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=NaNITLut; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="NaNITLut"
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-3c861a87d6dso2461958b6e.0
        for <patches@lists.linux.dev>; Wed, 01 May 2024 09:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1714580314; x=1715185114; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RrsRAJmWysXYR4n1Z7QuovA3tEKIJY2HwJxpKg4/cqM=;
        b=NaNITLut8o1lqGN6bkWxrMLQUwa5CdgubVA9WjHRHoDygxqDENuHc+v40q0M3U+CN/
         ZAsomR6WlICdMNo/gxxJlmhF9OWmIv3VYi0BLq0lFr/kXe7+YJaSTLL3fS2XNMD/VlVo
         aB3m3kaufvgF4zTdKm5k5peuwTOWdQ2KDwzU8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714580314; x=1715185114;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RrsRAJmWysXYR4n1Z7QuovA3tEKIJY2HwJxpKg4/cqM=;
        b=PIRGTNJgdKvqVwO/zPU6wViMA+Q8Y0OKO5QtNlgHtbsnZ1iLQBEoNTkvzu+NbxBUcN
         6rDzqInypJNzrFKT44XGGOJY2R+XLFiWWtdGKr8y3Dh/N+7SmLvIbT8L0c/8yJvy+X1u
         YIum78W8oPzilh82jksv2kI31rfRWoTnIEhh4oWZmuG2j41P1EMkki5ZKq2NP3dU6ygn
         iwQAlk7Mfozs/WreELiYKhuSjE6+LTv0hrTUnquGrGtqrKvDqqH4WzG9+lvyYXhGuogf
         3seBJ5Hf+XvXlRG42VJpn66Iqxokp6jvgh+XFbpLjo5HnC35CT1QTRtC4og1C0yZrGnd
         qjxg==
X-Forwarded-Encrypted: i=1; AJvYcCXdIp/6qGXDmAOWLIOiZJkirKWgkOpg3XCENJWMvngnnZD+7GyAy/rLN0wIYd9kl8RiSPhtGhjnRJ8BJzzkmF1P1iELKI+mJg==
X-Gm-Message-State: AOJu0YztbAlVqDfdBlnASDbiLkAzdOh+6zRvBxAC4Pm3AGIH+GhEofr2
	WTm3178kN0cDTCNtvwPuQ1D5h4sEB4Pvj03b+dvN3Xf8I6FrBUPuEhTMqivX6DVvmhRc0QdEYiY
	=
X-Google-Smtp-Source: AGHT+IGwuC9wThSgbLUBW/Gn1PQEHUVNLRyTI/M2pwvDcZAhJR6RXQlgjt12NsAfLvhCdFFSMRIUMg==
X-Received: by 2002:aca:1b02:0:b0:3c8:6427:5b7 with SMTP id b2-20020aca1b02000000b003c8642705b7mr3079832oib.56.1714580314095;
        Wed, 01 May 2024 09:18:34 -0700 (PDT)
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com. [209.85.160.178])
        by smtp.gmail.com with ESMTPSA id w2-20020a0cb542000000b0069b55bf11a2sm12688296qvd.139.2024.05.01.09.18.32
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 May 2024 09:18:33 -0700 (PDT)
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-439b1c72676so82671cf.1
        for <patches@lists.linux.dev>; Wed, 01 May 2024 09:18:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCW7oLW/hBt1iO+1QXHV43e/AW0I4Hkh79f7MTD6fBkO6vLzf1QU/5Yp2S1fVD0lAyhxx03nl+2CDBN+r7h3krAg/uZO9BD5Sw==
X-Received: by 2002:ac8:5d8f:0:b0:43a:c84f:5689 with SMTP id
 d15-20020ac85d8f000000b0043ac84f5689mr236131qtx.1.1714580312414; Wed, 01 May
 2024 09:18:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240327202740.3075378-1-swboyd@chromium.org> <CAD=FV=VLwa0AFsrXXxKGG+hcyW+h7u7-tyg3uoDB8M_XdPti_Q@mail.gmail.com>
 <CAE-0n51osUcpqqh6o9OhURLbRKjcWbRZT-5oHLi_mwfJsUngEw@mail.gmail.com>
In-Reply-To: <CAE-0n51osUcpqqh6o9OhURLbRKjcWbRZT-5oHLi_mwfJsUngEw@mail.gmail.com>
From: Doug Anderson <dianders@chromium.org>
Date: Wed, 1 May 2024 09:18:20 -0700
X-Gmail-Original-Message-ID: <CAD=FV=USC_WO_cqYbuHBoScbV=TLtxKSfXmtOBruLSpzSTy4mg@mail.gmail.com>
Message-ID: <CAD=FV=USC_WO_cqYbuHBoScbV=TLtxKSfXmtOBruLSpzSTy4mg@mail.gmail.com>
Subject: Re: [PATCH 0/2] Fix a black screen on sc7180 Trogdor devices
To: Stephen Boyd <swboyd@chromium.org>
Cc: Michael Turquette <mturquette@baylibre.com>, Stephen Boyd <sboyd@kernel.org>, 
	Bjorn Andersson <andersson@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-clk@vger.kernel.org, patches@lists.linux.dev, 
	linux-arm-msm@vger.kernel.org, Dmitry Baryshkov <dmitry.baryshkov@linaro.org>, 
	Taniya Das <quic_tdas@quicinc.com>, Laura Nao <laura.nao@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Apr 30, 2024 at 5:17=E2=80=AFPM Stephen Boyd <swboyd@chromium.org> =
wrote:
>
> Quoting Doug Anderson (2024-03-28 09:39:54)
> >
> > I spent a bunch of time discussing this offline with Stephen and I'll
> > try to summarize. Hopefully this isn't too much nonsense...
> >
> > 1. We'll likely land the patches downstream in ChromeOS for now while
> > we're figuring things out since we're seeing actual breakages. Whether
> > to land upstream is a question. The first patch is a bit of a hack but
> > unlikely to cause any real problems. The second patch seems correct
> > but it also feels like it's going to cause stuck clocks for a pile of
> > other SoCs because we're not adding hacks similar to the sc7180 hack
> > for all the other SoCs. I guess we could hope we get lucky or play
> > whack-a-mole? ...or we try to find a more generic solution... Dunno
> > what others think.
>
> I think we should hope to get lucky or play whack-a-mole and merge
> something like this series. If we have to we can similarly turn off RCGs
> or branches during driver probe that are using shared parents like we
> have on sc7180.

This is OK w/ me, but of course I'm super biased since the only
Qualcomm platform I'm involved in is sc7180 Chromebooks and that's
handled by your series. If it helps, I suppose you could add:

Reviewed-by: Douglas Anderson <dianders@chromium.org>

IMO it would be good to get Bjorn or Dmitry to buy in and maybe post a
PSA and/or request for testing to a few IRC channels where folks hang
out (#linux-msm, #freedreno and #aarch64-laptops, maybe?)


-Doug
