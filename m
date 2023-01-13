Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79DFFBA3A
	for <patches@lists.linux.dev>; Fri, 13 Jan 2023 21:12:10 +0000 (UTC)
Received: by mail-lf1-f50.google.com with SMTP id g13so34821861lfv.7
        for <patches@lists.linux.dev>; Fri, 13 Jan 2023 13:12:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:user-agent
         :from:references:in-reply-to:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r5E2jUOsmFLtdYppT5Vp0YBT45RVJ+ABe3kgqhVZhkI=;
        b=IkJ+FOVocZ4ttJ4pEh+dqaYc1loiq1VzM4s8rw3sfw+1LDPtVXu3+QCzwNyI/P+Oz3
         Q8GtrQlQFVgEw2AwhcdO9Y+lo70CcrUxOaUVv6K3tg9hOQIlRZure7tE16OwYGB+40y7
         IkaTssjuMdbN49fZTK+WSj6EXgdB+69XdqZus=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:user-agent
         :from:references:in-reply-to:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=r5E2jUOsmFLtdYppT5Vp0YBT45RVJ+ABe3kgqhVZhkI=;
        b=GEdV42gDW+2wTOHgXPoTIUuM9KYWdlN0odAKWgm2WzNxqbXXuZtq6xSkMndUhsiOI+
         UC/n+bTB8YJciJ6DEumeuJz/8J9wzY6cauWbbGbQ0364yljHg/6Aa1/eO8GUAA1ofXkK
         BgE4JcO864JqfLjvcFWlC31IhnGnfClE3M0uuXp9Y6pfAuU5eVM5Uh1p97axc0aYZ/6W
         ICa4CFRCMZv2AexI3NiVDfp0PBzjFqPXsJeUBv8asgyFkmsxD3vEqGB3tUnBshZgcdmv
         HTZ1e2Y+O2oNXckFJFfAISKM0vw9+ZBttcYFRXY875q1PXP7jOUkgctN0H/WiD1a+CzD
         q+Ig==
X-Gm-Message-State: AFqh2kqJvsf0omSG4MXKUDISavnUVMG72jpq7BqTUH0KcOyHI+gpz8TD
	6sQqr1Zf4lvHObJl96bwOny6kYqcXCjQZ0DCS7T/Mw==
X-Google-Smtp-Source: AMrXdXsEHDMUikQ5Emug3xW/Z4eyYFdBuE++yVRLiUqBN6JN5+W+1CZEk4riH+MmzQZSNNRp1Leh8neGlYysREAjyE0=
X-Received: by 2002:a05:6512:4017:b0:4bd:35fd:65b5 with SMTP id
 br23-20020a056512401700b004bd35fd65b5mr8207466lfb.297.1673644328511; Fri, 13
 Jan 2023 13:12:08 -0800 (PST)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 13 Jan 2023 15:12:07 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAPY8ntA=Dq6GFQ3gEOm9PzPyOa9bHTr8JrpXLibnai7xKqRbpQ@mail.gmail.com>
References: <20230106030108.2542081-1-swboyd@chromium.org> <CAPY8ntA=Dq6GFQ3gEOm9PzPyOa9bHTr8JrpXLibnai7xKqRbpQ@mail.gmail.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Fri, 13 Jan 2023 15:12:07 -0600
Message-ID: <CAE-0n53UFuyYvjJUWViXy9Eex2mpBRJGtt4vGc2cbFZS9i8xFw@mail.gmail.com>
Subject: Re: [PATCH] drm/panel: boe-tv101wum-nl6: Ensure DSI writes succeed
 during disable
To: Dave Stevenson <dave.stevenson@raspberrypi.com>
Cc: Thierry Reding <thierry.reding@gmail.com>, Rob Clark <robdclark@chromium.org>, 
	Douglas Anderson <dianders@chromium.org>, Jitao Shi <jitao.shi@mediatek.com>, 
	yangcong <yangcong5@huaqin.corp-partner.google.com>, linux-kernel@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, patches@lists.linux.dev, 
	linux-mediatek@lists.infradead.org, 
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>, Sam Ravnborg <sam@ravnborg.org>, 
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Quoting Dave Stevenson (2023-01-13 08:27:29)
> Hi Stephen
>
> On Fri, 6 Jan 2023 at 03:01, Stephen Boyd <swboyd@chromium.org> wrote:
> >
> > The unprepare sequence has started to fail after moving to panel bridge
> > code in the msm drm driver (commit 007ac0262b0d ("drm/msm/dsi: switch t=
o
> > DRM_PANEL_BRIDGE")). You'll see messages like this in the kernel logs:
> >
> >    panel-boe-tv101wum-nl6 ae94000.dsi.0: failed to set panel off: -22
> >
> > This is because boe_panel_enter_sleep_mode() needs an operating DSI lin=
k
> > to set the panel into sleep mode. Performing those writes in the
> > unprepare phase of bridge ops is too late, because the link has already
> > been torn down by the DSI controller in post_disable, i.e. the PHY has
> > been disabled, etc. See dsi_mgr_bridge_post_disable() for more details
> > on the DSI .
> >
> > Split the unprepare function into a disable part and an unprepare part.
> > For now, just the DSI writes to enter sleep mode are put in the disable
> > function. This fixes the panel off routine and keeps the panel happy.
>
> It is documented that the mipi_dsi_host_ops transfer function should
> be called with the host in any state [1], so the host driver is
> failing there.

Thanks for the info! It says "Drivers that need the underlying device to
be powered to perform these operations will first need to make sure it=E2=
=80=99s
been properly enabled." Does that mean the panel driver needs to make
sure the underlying dsi host device is powered? The sentence is too
ambiguous for me to understand what 'drivers' and 'underlying device'
are.

>
> This sounds like the same issue I was addressing in adding the
> prepare_prev_first flag to drm_panel, and pre_enable_prev_first to
> drm_bridge via [2].
> Defining prepare_prev_first for your panel would result in the host
> pre_enable being called before the panel prepare, and therefore the
> transfer calls from boe_panel_init_dcs_cmd boe_panel_prepare won't be
> relying on the DSI host powering up early. It will also call the panel
> unprepare before the DSI host bridge post_disable is called, and
> therefore the DSI host will still be powered up and the transfer won't
> fail.
>
> Actually I've just noted the comment at [3]. [2] is that framework fix
> that means that the magic workaround isn't required, but it will
> require this panel to opt in to the ordering change.

Cool. Glad that we can clean that up with your series.

Is it wrong to split unprepare to a disable and unprepare phase? I'm not
super keen on fixing 6.1 stable kernels by opting this driver into the
ordering change. Splitting the phase into two is small and simple and
works. I suspect changing the ordering may uncover more bugs, or be a
larger task. I'd be glad to test that series[2] from you to get rid of
[3].

>
>
> [1] https://www.kernel.org/doc/html/latest/gpu/drm-kms-helpers.html#c.mip=
i_dsi_host_ops
> [2] https://patchwork.freedesktop.org/series/100252/
> [3] https://github.com/torvalds/linux/blob/master/drivers/gpu/drm/msm/dsi=
/dsi_manager.c#L47
>
