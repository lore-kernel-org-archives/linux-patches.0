Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F92D539E
	for <patches@lists.linux.dev>; Wed, 18 Jan 2023 18:24:43 +0000 (UTC)
Received: by mail-lf1-f47.google.com with SMTP id d30so48010675lfv.8
        for <patches@lists.linux.dev>; Wed, 18 Jan 2023 10:24:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Na6xMADEzYhZzXrlHJxxzhXM5YRKt3/PwZV0GUrKKGc=;
        b=FtbWDIbw43u/20f6aUHdQZhGNF5q7hwzxM44DWYHHZguw4CyS+ovFhwIGEtmOHfbj9
         I94uNKk6/UXOxgfSZKCPkOSVywK307UXAxAhrHPaBiplbKj8UD7F85O5zsEjYiafZ4eP
         vTQhrJ/8od1gBb2UvbLmF2hi3hTlYVOQ84Jp8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Na6xMADEzYhZzXrlHJxxzhXM5YRKt3/PwZV0GUrKKGc=;
        b=1JZSYj05BPrC+kV+nwQKh1qRW239RfbegCn9Dgc5TyTL+wwtuJBErwv2keqd5lwMBj
         yetGaUbLF173qEK357mXfpNWRb3Pm3Bnb/iwnb7GuPRwHYl3DTKJuA3uppAiKs7iG0ZK
         C5qq5FVvnHDiCkPqf5FuFSOQovfoj1yfKN27SbkmXYIHVSsuMaCueSSXwViirvqCpppu
         b8g9ZxmIPFnNw5bPY0TbnZs/QJi0dr6tJErG0nng2xz55WHhWZhR61IfborcSObB7Yt1
         R2YWOQg75CGEYUIdJ8CuCJ3HQPP9xUniK+9mc8i7WNaVJREK0v9Z9d5rmbX8bu2EtPiG
         5OiA==
X-Gm-Message-State: AFqh2kqy9Et25VCB+ZBHMzesxfi7h5sJQbFALCvh1GWi5/qwZmYg/6DX
	gGVg6d3+Iuk6Xy89hDIzdGJa1faW5gECWbEIMAYCsw==
X-Google-Smtp-Source: AMrXdXu8H4rHNVOE2wtoG3S0Z9KJVoxXo4Da1sSK6RbMP0C1hgRXWtHRAK5N7Qtj8aQOi1yS8Qs1CTyTfwDonhSoIJg=
X-Received: by 2002:a05:6512:2114:b0:4bd:35fd:65b5 with SMTP id
 q20-20020a056512211400b004bd35fd65b5mr759204lfr.297.1674066281456; Wed, 18
 Jan 2023 10:24:41 -0800 (PST)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 18 Jan 2023 12:24:40 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAE-0n51XmyzSeKuGNn2BsJew3fK_cEHNoDpVVRqStNAF+Zzp1A@mail.gmail.com>
References: <20230106030108.2542081-1-swboyd@chromium.org> <Y7nV+aeFiq5aD0xU@ravnborg.org>
 <CAE-0n50QOv_+j1Pe19xKj4Cx2Y5_Ak5Kt68UBJuZt10D-jQ44g@mail.gmail.com>
 <Y8FwGTWeYtX0j8MX@ravnborg.org> <CAE-0n51XmyzSeKuGNn2BsJew3fK_cEHNoDpVVRqStNAF+Zzp1A@mail.gmail.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Wed, 18 Jan 2023 12:24:40 -0600
Message-ID: <CAE-0n51HAkYAcGdsJ=0gbV7JRJSGt9cZ_vHPC3kDepa4rooyvg@mail.gmail.com>
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

Quoting Stephen Boyd (2023-01-13 12:49:43)
> Quoting Sam Ravnborg (2023-01-13 06:52:09)
> > Hi Stephen,
> > On Tue, Jan 10, 2023 at 11:29:41AM -0800, Stephen Boyd wrote:
> > >
> > > After this patch the unprepare only bails out early if the bool
> > > 'prepared' flag isn't set.
> > OK, then everything is fine.
> >
>
> Doug pointed out that enable isn't symmetric because it doesn't do the
> DSI writes. I've updated the patch and I'll send a v2.

Turns out that splitting prepare into prepare and enable breaks the
display even more for me. For now this is the best patch I have and it
fixes the regression I see in v6.1 kernels. Can I get your Reviewed-by
on this patch?
