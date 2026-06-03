Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00C93CAA47
	for <patches@lists.linux.dev>; Wed,  3 Jun 2026 11:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780485700; cv=none; b=Ua8XlLxsOok1tu7UGqDE3IAIEgI6xxizTvemqRIRsCQhspzqCSr04PPs7ZbwgEGtVzZmHCGfHQw2+vHC/VTM9OcmB7Y+lk1It9/pYJmpUUooe8A2/65sCBL8tgrSgIvGervqz/GUPYps/hkRv6jh6tdnBf8vDctV3EsWqiOP81Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780485700; c=relaxed/simple;
	bh=HTPmKUvNupQRiIlnkTWVHFoNHhl+8FOWGUotjzo8VPA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=U+8QjyO6Nk0QmuuiXaQH4HFp+tqlK0EveunlqO+uT7M+PFhlOzbzN9auWM7A6sylGzEQolY592VwJOFENR9+eRLzpUWDi8eYSkswo+CFRNu2ryNsB0Pjwcn+FGKDq6h5Zav6dCd5n/9jMjEujA0fmkIiLi3ZqkltId2QEj0u2Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=bRlZ9OhC; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="bRlZ9OhC"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-bebbc325000so488914066b.0
        for <patches@lists.linux.dev>; Wed, 03 Jun 2026 04:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1780485697; x=1781090497; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mmWYQhsLy8u3OL3FpmVNlvrqjfjo/sGOnkY3CQlMd0M=;
        b=bRlZ9OhCQmfap8H2W6a26TIU+4qao+L6AhZbfDPNnSFmU1KULPwTr3snz6xuZBAx5I
         JqKMXnryyRZ+a0OG+6/xAvfCACqdAv8VnRaAUzqKTTwEnmOIYlNHJD11qBsjxCSULckW
         iUt2sbwayF5snwxsXErkysPKqAfmfKYm8nDX0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780485697; x=1781090497;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mmWYQhsLy8u3OL3FpmVNlvrqjfjo/sGOnkY3CQlMd0M=;
        b=euJEfCEHu+B8wEBEeU2Ee7xkZteBgq1YKe2RnJn+nKKtC6USHE6nnTmek43xwjVWl6
         lwgBjtkVv9/rCLl2ntBC/OXh1X9ScxMf7TR6DYPiY9e6hdm+u7/kFgrx1OcChfzwXiqo
         eYE+50IJzeXrHjWQJhfZMCXb82JlZipYG41Eay0R6uvsrvZIYMo1i4f/3uP6kNV6r1uu
         XaNt7nNqZGnI0rEwVeAaOPGpydxqWAyXNQiJ80nF5G8GV0PoZoM4jaM4uUqvrNmSclQD
         rsGZZ72D3qt3a6GpoNLA+vtmHY+fWqb0titYFSanE7Ex8d9mAlw9bTtdSdqnQojy26/3
         2wpw==
X-Forwarded-Encrypted: i=1; AFNElJ9q5fnVfYBfMMmfnw5oh8dWUYnPXIgp3ppx6X36+cTlFf9qYg8k1Or5PsV0arudRvUUxA8DQjSO@lists.linux.dev
X-Gm-Message-State: AOJu0YysOoZQKAf4gkfP8lnq3dwitzWOm/CTv28ty4TCTNBYFjRpyvYZ
	5jAkjA1Lk/IvxXDhpjctOpImG9LPQATS1sJZgfh40d2UlpuRch2TIUF3hO61ipXRzQdKIEq6kIU
	kFelscw==
X-Gm-Gg: Acq92OG8tfSS2jIoq8B8sHRjcW0WdVhYhoXMTWnENUBQ+8AwPOpG1Wo00bkebO+OtKX
	3WE/UvyfF+E2+7Itxwq1B/p779YSOQwxJ/A7aoTT6OeNuUjKFxOqeHN4rpaBG64n5oar4Mm/GS1
	n/Tz4/9XvDsuG86WOyS+92kBKr/d1tfK/wKKp/ruMgj75ZdfZhV1Of8vbubP8DdEm4aoEIvShIs
	U30pR8x9PazqSUoZKSfOmvHYAGJMM0SjwjCNIwMoxREPe8XiE0NOLxQs8V9Pv8/2rm0lNa0zbKy
	EyAhO5FRKl1YZE+OEuyS1irtAklWxJ+sLm0bBuMbW04PTOtMvQwisDYxp4FSGYNgO+82hdlvfSx
	3uv3AsnUXH7GV0LzFnnxyyFJHGKB9HzGjX3qF2l+B08cmDkP09/JgM1FoiD1TQoPuuLV6PIs0Ct
	iwMuGY6m1zSxpDPCkmQMkN8JQXq0amSFPRMm3gECZEUCRhlc7KtZOM8xXD2YENQxyNAURgnNw=
X-Received: by 2002:a17:907:cbc5:b0:beb:7979:47dd with SMTP id a640c23a62f3a-bf0b2bd0608mr140341566b.27.1780485697441;
        Wed, 03 Jun 2026 04:21:37 -0700 (PDT)
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com. [209.85.208.49])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bf05176fd20sm140843066b.7.2026.06.03.04.21.36
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2026 04:21:36 -0700 (PDT)
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-68be16c61d1so10617606a12.2
        for <patches@lists.linux.dev>; Wed, 03 Jun 2026 04:21:36 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/7hkX9lSh9tws5acitFRGiOuDywdb7BroJyEFteWyIv0wp1fWAJoimXEa7qNGrlae4CVrSdZpI@lists.linux.dev
X-Received: by 2002:a17:906:c106:b0:bd5:405c:7964 with SMTP id
 a640c23a62f3a-bf0b3dadc24mr156021466b.48.1780485695242; Wed, 03 Jun 2026
 04:21:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260530160224.570625122@linuxfoundation.org> <20260530160226.496219768@linuxfoundation.org>
 <5e2ac444-451c-4220-8013-0e6382b5f165@pobox.com> <136f03aa6f51bdfecc786e5278f5fd03b4a6966e.camel@decadent.org.uk>
 <20260601015021.rc-uvcvideo-heuristic@kernel.org> <CANiDSCvh6u6AWnarEtso=zKPD3upEsaJBMOm1x35fHyPMaEMyw@mail.gmail.com>
 <2026060104-customs-naturist-7a58@gregkh>
In-Reply-To: <2026060104-customs-naturist-7a58@gregkh>
From: Ricardo Ribalda <ribalda@chromium.org>
Date: Wed, 3 Jun 2026 13:21:22 +0200
X-Gmail-Original-Message-ID: <CANiDSCsjR5NHqu_Ui5cOqWdJgFqmYsQ9WR8O7m0WOhngaYXFpw@mail.gmail.com>
X-Gm-Features: AVHnY4LaRyBJK0yrJYhC3WjO7GVxRuwz4FcveLyMZupXOph9y2DtgyUwl2vn084
Message-ID: <CANiDSCsjR5NHqu_Ui5cOqWdJgFqmYsQ9WR8O7m0WOhngaYXFpw@mail.gmail.com>
Subject: Re: [PATCH 5.10 072/589] media: uvcvideo: Use heuristic to find
 stream entity
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org, patches@lists.linux.dev, 
	Angel4005 <ooara1337@gmail.com>, Hans de Goede <hansg@kernel.org>, 
	Hans Verkuil <hverkuil+cisco@kernel.org>, Ron Economos <re@w6rz.net>, 
	"Pavel Machek (CIP)" <pavel@nabladev.com>, Brett A C Sheffield <bacs@librecast.net>, Mark Brown <broonie@kernel.org>, 
	Peter Schneider <pschneider1968@googlemail.com>, 
	Francesco Dolcini <francesco.dolcini@toradex.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Jon Hunter <jonathanh@nvidia.com>, Florian Fainelli <florian.fainelli@broadcom.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Vijayendra Suman <vijayendra.suman@oracle.com>, 
	Ben Hutchings <ben@decadent.org.uk>, "Barry K. Nathan" <barryn@pobox.com>
Content-Type: text/plain; charset="UTF-8"

Hi Greg

On Mon, 1 Jun 2026 at 17:13, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Mon, Jun 01, 2026 at 08:41:14AM +0200, Ricardo Ribalda wrote:
> > Hi Sasha
> >
> > On Mon, 1 Jun 2026 at 04:11, Sasha Levin <sashal@kernel.org> wrote:
> > >
> > > On Sun, 2026-05-31 at 12:53 +0200, Ben Hutchings wrote:
> > > > This doesn't properly fix the problem.  Commit 3d9f32e02c2e "media:
> > > > uvcvideo: Create an ID namespace for streaming output terminals" (which
> > > > reverts this) needs to be applied on top.
> > >
> > > Rather than carry the heuristic and then layer the namespace rework on top
> > > in 5.10 only, I've dropped this together with its regression source
> > > 0e2ee70291e6 ("media: uvcvideo: Mark invalid entities with id
> > > UVC_INVALID_ENTITY_ID") from the 5.10 queue. That mirrors what 3d9f32e02c2e
> > > does upstream (it reverts the heuristic), and avoids exposing the
> > > 0e2ee70291e6 regression that would otherwise enter 5.10 in the same batch.
> >
> > Are you going to apply:
> >
> > Commit 3d9f32e02c2e "media: uvcvideo: Create an ID namespace for
> > streaming output terminals"
> > ?
>
> It wasn't planned on.
>
> > We need either that patch or this one: media: uvcvideo: Use heuristic
> > to find stream entity
>
> What id is that?

Sorry, I should have been more specific. I am talking about Upstream
commit 758dbc756aad429da11c569c0d067f7fd032bcf7.

(this patch that we are discussing)

Regards


>
> thanks,
>
> greg k-h



-- 
Ricardo Ribalda
