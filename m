Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA397E
	for <patches@lists.linux.dev>; Fri, 20 May 2022 23:16:32 +0000 (UTC)
Received: by mail-oi1-f174.google.com with SMTP id j137so649451oih.6
        for <patches@lists.linux.dev>; Fri, 20 May 2022 16:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:in-reply-to:references:from:user-agent:date:message-id
         :subject:to:cc;
        bh=yxlZFui2Yaf/yMfrSBImiOBBtFzo9plT1mEwwLvskcQ=;
        b=QQ3Ji43YCSMIg8zi7tO8mgLiPY7ZQlKggsWtAYpivQLNqk+AhHphjiJJkj5BEw3goj
         FHAHKy8fWM7leVzFHXGZMrZAsYfuKb1BN8Imu8P6lDBZMim3CdRugYFXBeJvJ565G170
         wl0TR4s69nBhT8PKphKsRvd+mvXC6hs6/WoYs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:in-reply-to:references:from
         :user-agent:date:message-id:subject:to:cc;
        bh=yxlZFui2Yaf/yMfrSBImiOBBtFzo9plT1mEwwLvskcQ=;
        b=eoLFHNaiP9jYlBaJn2gmgfisLz4t/W31fyFDCYogJMygPjyb9uGXAglpxFYihudtJE
         5cOGIzMGaC/EzpF6+7Dba+GsC6wj5xIKA+p9/SpFsH990z/CCge71ddPMm4DPO5vxraY
         zvrJS6P1l6pFCfv2LGnrh78Ngog4JSRlWVn+R6BlqmXLd+KnxMXmr3m0uTSypAjkMMjm
         JPEzRvfztuH39LAHcAXtKa7DNokogpV7CuF4kenX65xuFx6vr8nacUVglv1HMW51s2Dq
         YLvqVIPSZegiAdbsZjbRnXD5ANLBTVB8xeXKShIaTyAM9dgicjfWjmHseKY54NboeW9O
         hEjg==
X-Gm-Message-State: AOAM531CWJf2JotybTLoKHPCDeA/yJ44xWtScSdvoyfwa8d3GKj5d95M
	UC4JPyemVmW0fRhgdzF1AxYKB2NO0uopLMEJ1pRRJw==
X-Google-Smtp-Source: ABdhPJze2O0r826Wkv9TYht2+IV2909AuAPrg2Bpl39RVQNOr0gbPg1aiFpRQF/hshBLa8Bf37FBjT5mXHnyiWqAZ6w=
X-Received: by 2002:a05:6808:23c3:b0:326:bd8d:7993 with SMTP id
 bq3-20020a05680823c300b00326bd8d7993mr6933836oib.63.1653088591458; Fri, 20
 May 2022 16:16:31 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 20 May 2022 16:16:30 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAD=FV=VSMyJrs9bTE2XEC=q7VtZi6YKFaKJQJyLTZhVaYa9-Jg@mail.gmail.com>
References: <20220427020339.360855-1-swboyd@chromium.org> <20220427020339.360855-4-swboyd@chromium.org>
 <CAD=FV=VSMyJrs9bTE2XEC=q7VtZi6YKFaKJQJyLTZhVaYa9-Jg@mail.gmail.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Fri, 20 May 2022 16:16:30 -0700
Message-ID: <CAE-0n52dG8ucjgsaDVXDw1hXsG3YNZRPKyYVTr+JVJHpFoAizA@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] arm64: dts: qcom: Only include sc7180.dtsi in sc7180-trogdor.dtsi
To: Doug Anderson <dianders@chromium.org>
Cc: Andy Gross <agross@kernel.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, 
	LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev, 
	linux-arm-msm <linux-arm-msm@vger.kernel.org>, 
	"Joseph S. Barrera III" <joebar@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Doug Anderson (2022-05-20 15:16:03)
> On Tue, Apr 26, 2022 at 7:03 PM Stephen Boyd <swboyd@chromium.org> wrote:
> >  arch/arm64/boot/dts/qcom/sc7180-trogdor-pompom.dtsi            | 1 -
> >  arch/arm64/boot/dts/qcom/sc7180-trogdor-r1.dts                 | 1 -
> >  arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi                   | 3 ++-
> >  19 files changed, 17 insertions(+), 19 deletions(-)
>
> While reviewing a different change, I found something fishy and
> tracked it down to ${SUBJECT} patch.
>
> Specifically, after ${SUBJECT} patch then I run `git grep
> include.*trogdor.dtsi`. When I do that, I see that
> `sc7180-trogdor.dtsi` is double-included in all lazor devices. :( It's
> included in the actual dts files and also in the lazor.dtsi file.
>
> That's probably not right. I think we need to remove the one in the
> lazor.dtsi file?
>

Good catch! I sent a patch to fix it[1]. I recall I compiled
before/after and didn't see any difference, so I suspect it's just a
waste of time during the compilation phase but otherwise not causing a
problem.

[1] https://lore.kernel.org/r/20220520231355.1559104-1-swboyd@chromium.org
