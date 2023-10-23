Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4FF1B279
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 14:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="niwtVRwz"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-53dd752685fso5196880a12.3
        for <patches@lists.linux.dev>; Mon, 23 Oct 2023 07:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1698071753; x=1698676553; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=thBbcDnCCIr+oLSwwKxaUY7Kp5osFavsrH9yvSs64sE=;
        b=niwtVRwz2xs9dUFnI+00T6CzY/xzd2yrUy0Hp8251mAQUqHkINc3feTz8RNUz32V6W
         R1J9/mgKKDbkQ+pVlTZMqAOjdn4EZp4HuqKwpFBgGQlNcUtJrA9N4HQg/wtDS0atC1TI
         e8mIhMGwu2Q7u9M9gfIMxWeQvkP0W3mnAu5Ao=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698071753; x=1698676553;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=thBbcDnCCIr+oLSwwKxaUY7Kp5osFavsrH9yvSs64sE=;
        b=nIOO26uBi8CYqNyfz/wnHykmXvW7YifcioiuZC2k9PG00YBQrgyZ5ZX5aPos6h6fw5
         Ct5dDt3bdlt8XIlMklAZnLF6KXLeYfL6cJv/79kmfKkgP43hXNXNbxDq2BvnC089leKw
         xIBoxlAeB2NlXtlgSc6zCZ6mLffrx7UPvn0hci/ZhCI7fXTI/xK/Z2j61ByhuNKBWu6n
         Dqlyegcwp/aUWzsImkXrgJz/BYDtqm0Bd/wKL8eBjkF11VRK6EYKuYK1Bg66GVfRyeZf
         kEU8uhJ8yplWFSgCIFqkfX86cNtGL2+yQ1SkN8OK0WxTCZjrHS4U8Klj6Rq5TUQeDaI5
         EF3Q==
X-Gm-Message-State: AOJu0Yw0IyXvghtqjWs7kZfQnxT3raeJN2yIxIWOcj+cXEURrq+8CkGr
	0rnB7lcWMGJz5YZZw+zSa0UWoQUkTw4Df5wucSI2mw==
X-Google-Smtp-Source: AGHT+IGgKWWL0IcsrvZHLKylmI+TUssFKaCHPVcR14oKQrYUn23tQs6UULbl5FJwnZEFItRG5gUZ9w==
X-Received: by 2002:a50:d742:0:b0:53f:6ed5:4dab with SMTP id i2-20020a50d742000000b0053f6ed54dabmr7675194edj.24.1698071752952;
        Mon, 23 Oct 2023 07:35:52 -0700 (PDT)
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com. [209.85.128.41])
        by smtp.gmail.com with ESMTPSA id e13-20020a50ec8d000000b0053e775e428csm6366698edr.83.2023.10.23.07.35.52
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Oct 2023 07:35:52 -0700 (PDT)
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-40853f2e93eso106645e9.0
        for <patches@lists.linux.dev>; Mon, 23 Oct 2023 07:35:52 -0700 (PDT)
X-Received: by 2002:a05:600c:4a22:b0:408:2b:5956 with SMTP id
 c34-20020a05600c4a2200b00408002b5956mr278445wmp.6.1698071751787; Mon, 23 Oct
 2023 07:35:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231023104833.832874523@linuxfoundation.org> <20231023104839.191685463@linuxfoundation.org>
In-Reply-To: <20231023104839.191685463@linuxfoundation.org>
From: Doug Anderson <dianders@chromium.org>
Date: Mon, 23 Oct 2023 07:35:36 -0700
X-Gmail-Original-Message-ID: <CAD=FV=XV9csGb273q8eam8bAPFR91a9p8DULCZ_Mm6bW0pBQ0w@mail.gmail.com>
Message-ID: <CAD=FV=XV9csGb273q8eam8bAPFR91a9p8DULCZ_Mm6bW0pBQ0w@mail.gmail.com>
Subject: Re: [PATCH 6.5 219/241] drm/panel: Move AUX B116XW03 out of panel-edp
 back to panel-simple
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Anton Bambura <jenneron@postmarketos.org>, Hsin-Yi Wang <hsinyi@chromium.org>, 
	Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Oct 23, 2023 at 4:12=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> 6.5-stable review patch.  If anyone has any objections, please let me kno=
w.
>
> ------------------
>
> From: Douglas Anderson <dianders@chromium.org>
>
> [ Upstream commit ad3e33fe071dffea07279f96dab4f3773c430fe2 ]
>
> In commit 5f04e7ce392d ("drm/panel-edp: Split eDP panels out of
> panel-simple") I moved a pile of panels out of panel-simple driver
> into the newly created panel-edp driver. One of those panels, however,
> shouldn't have been moved.
>
> As is clear from commit e35e305eff0f ("drm/panel: simple: Add AUO
> B116XW03 panel support"), AUX B116XW03 is an LVDS panel. It's used in
> exynos5250-snow and exynos5420-peach-pit where it's clear that the
> panel is hooked up with LVDS. Furthermore, searching for datasheets I
> found one that makes it clear that this panel is LVDS.
>
> As far as I can tell, I got confused because in commit 88d3457ceb82
> ("drm/panel: auo,b116xw03: fix flash backlight when power on") Jitao
> Shi added "DRM_MODE_CONNECTOR_eDP". That seems wrong. Looking at the
> downstream ChromeOS trees, it seems like some Mediatek boards are
> using a panel that they call "auo,b116xw03" that's an eDP panel. The
> best I can guess is that they actually have a different panel that has
> similar timing. If so then the proper panel should be used or they
> should switch to the generic "edp-panel" compatible.
>
> When moving this back to panel-edp, I wasn't sure what to use for
> .bus_flags and .bus_format and whether to add the extra "enable" delay
> from commit 88d3457ceb82 ("drm/panel: auo,b116xw03: fix flash
> backlight when power on"). I've added formats/flags/delays based on my
> (inexpert) analysis of the datasheet. These are untested.
>
> NOTE: if/when this is backported to stable, we might run into some
> trouble. Specifically, before 474c162878ba ("arm64: dts: mt8183:
> jacuzzi: Move panel under aux-bus") this panel was used by
> "mt8183-kukui-jacuzzi", which assumed it was an eDP panel. I don't
> know what to suggest for that other than someone making up a bogus
> panel for jacuzzi that's just for the stable channel.
>
> Fixes: 88d3457ceb82 ("drm/panel: auo,b116xw03: fix flash backlight when p=
ower on")
> Fixes: 5f04e7ce392d ("drm/panel-edp: Split eDP panels out of panel-simple=
")
> Tested-by: Anton Bambura <jenneron@postmarketos.org>
> Acked-by: Hsin-Yi Wang <hsinyi@chromium.org>
> Signed-off-by: Douglas Anderson <dianders@chromium.org>
> Link: https://patchwork.freedesktop.org/patch/msgid/20230925150010.1.Iff6=
72233861bcc4cf25a7ad0a81308adc3bda8a4@changeid
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/gpu/drm/panel/panel-edp.c    | 29 -----------------------
>  drivers/gpu/drm/panel/panel-simple.c | 35 ++++++++++++++++++++++++++++
>  2 files changed, 35 insertions(+), 29 deletions(-)

I responded to Sasha but managed to miss CCing stable@. My
apologies... Copying what I wrote there:

---

I feel that this should not be added to any stable trees. Please
remove it from the 6.1 and 6.5 stable trees and, if possible, mark it
so it won't get auto-selected in the future.

The issue here is that several mediatek boards ended up (incorrectly)
claiming that they included this panel and this change has the
possibility to break those boards. In the latest upstream kernel
mediatek boards that were using it have switched to the generic
"edp-panel" compatible string, but if this is backported someplace
before that change it has the potential to break folks.

It should be noted that it was confirmed that the "snow" and
"peach-pit" boards appeared to be working even without this patch, so
there is no burning need (even for those boards) to get this patch
backported.

For discussion on the topic, please see the link pointed to by the patch, A=
KA:

https://patchwork.freedesktop.org/patch/msgid/20230925150010.1.Iff672233861=
bcc4cf25a7ad0a81308adc3bda8a4@changeid

---

Sasha has already said he'd remove it from the queue, but responding
here just in case it's important. Thanks!

-Doug
