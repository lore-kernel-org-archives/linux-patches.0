Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E195BA3A
	for <patches@lists.linux.dev>; Fri, 13 Jan 2023 20:49:46 +0000 (UTC)
Received: by mail-lf1-f48.google.com with SMTP id f34so34712341lfv.10
        for <patches@lists.linux.dev>; Fri, 13 Jan 2023 12:49:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fkHnDayGcMAohLKGEspej/e05EdmPSY3auvLO5nhKvg=;
        b=B1hyLm+idg00BzqYNZMLiXGprSAGG6i9IwN0XKFvJoTp+bbSmW2iNf+GJtXCutZOO3
         8RgU6vVG5lOlOdS4Jh+/EFjzMIfNlQs2UESZqPIAVNO8K6uwqRQpbb6GfpuoMr4V1iJU
         C54ylt/YF1UuhIaYBPOGvyctdx3Rtziy4tGIc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fkHnDayGcMAohLKGEspej/e05EdmPSY3auvLO5nhKvg=;
        b=EUS+pwd5Hmu6uk5J0jtBUfiTw+QQXMZQVgVAthI/rOIH5dZffU5wCg9DZ6YEJYLJdH
         EcBTd8X+1nzumXkGrpjIFKjQ6ewnNRcV04FASPw8Vfh9zX44iZpx8ZHfeDaK8DCQuvYh
         tGq468zWlwD1abc+Y7ftVtk9qYXB4PbkMqOnC5nDStS/C1Xh3VxeWRXQgrQwxuk+XKnK
         G0wESUA17GooQ6C5BXOlseUL/y2Caes0ZyvBHxukBiLvdq4sKX+uymwY3ecKakXPa0Xr
         ZKxElr/AkT1y3bOXxYbhsIeOKjfDJdaoZjyaMBIFk26tPvXxLMuWkJOw6UR340Bq9QNm
         WL5Q==
X-Gm-Message-State: AFqh2koauXLmKECR+i2W5UhlbymONx5AdsslSp/lk6t0tzUZMSXdq2QX
	YlQpHU3VUNIVnO6urEJSqgI8+v4ITnSlC6OKD7Ihcw==
X-Google-Smtp-Source: AMrXdXsFLXpkYgLqPlD2aDMji/uNDYTLN9rr6vjDLKKJD82SrMUZ1JiyUGLTXyWhvAyNsS4E39x10UQlL6/nncEdZ5s=
X-Received: by 2002:ac2:4e50:0:b0:4ca:e48d:2b4b with SMTP id
 f16-20020ac24e50000000b004cae48d2b4bmr8301849lfr.511.1673642984424; Fri, 13
 Jan 2023 12:49:44 -0800 (PST)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 13 Jan 2023 14:49:43 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <Y8FwGTWeYtX0j8MX@ravnborg.org>
References: <20230106030108.2542081-1-swboyd@chromium.org> <Y7nV+aeFiq5aD0xU@ravnborg.org>
 <CAE-0n50QOv_+j1Pe19xKj4Cx2Y5_Ak5Kt68UBJuZt10D-jQ44g@mail.gmail.com> <Y8FwGTWeYtX0j8MX@ravnborg.org>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Fri, 13 Jan 2023 14:49:43 -0600
Message-ID: <CAE-0n51XmyzSeKuGNn2BsJew3fK_cEHNoDpVVRqStNAF+Zzp1A@mail.gmail.com>
Subject: Re: [PATCH] drm/panel: boe-tv101wum-nl6: Ensure DSI writes succeed
 during disable
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Thierry Reding <thierry.reding@gmail.com>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, dri-devel@lists.freedesktop.org, 
	linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, 
	yangcong <yangcong5@huaqin.corp-partner.google.com>, 
	Douglas Anderson <dianders@chromium.org>, Jitao Shi <jitao.shi@mediatek.com>, 
	Rob Clark <robdclark@chromium.org>, Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Sam Ravnborg (2023-01-13 06:52:09)
> Hi Stephen,
> On Tue, Jan 10, 2023 at 11:29:41AM -0800, Stephen Boyd wrote:
> > Quoting Sam Ravnborg (2023-01-07 12:28:41)
> >
> > >
> > > For this case we could ask ourself if the display needs to enter sleep
> > > mode right before we disable the regulator. But if the regulator is
> > > fixed, so the disable has no effect, this seems OK.
> >
> > What do you mean by fixed?
> What I tried to say here is if we have a fixed regulator - or in others
> words a supply voltage we cannot turn off, then entering sleep mode is
> important to reduce power consumption.
> But any sane design where power consumption is a concern will have the
> possibility to turn off the power anyway.

Ok got it!

>
> >
> > >
> > > Please fix the unprepare to not jump out early, on top of or together
> > > with the other fix.
> >
> > After this patch the unprepare only bails out early if the bool
> > 'prepared' flag isn't set.
> OK, then everything is fine.
>

Doug pointed out that enable isn't symmetric because it doesn't do the
DSI writes. I've updated the patch and I'll send a v2.
