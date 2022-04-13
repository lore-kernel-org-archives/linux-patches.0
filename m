Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81AA92F5C
	for <patches@lists.linux.dev>; Wed, 13 Apr 2022 23:14:05 +0000 (UTC)
Received: by mail-oi1-f178.google.com with SMTP id k10so3725094oia.0
        for <patches@lists.linux.dev>; Wed, 13 Apr 2022 16:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:in-reply-to:references:from:user-agent:date:message-id
         :subject:to:cc;
        bh=dorfVU/xJSabHsQtVBWrq/Iqc9CAJtp4oOExMJgEUDQ=;
        b=m+OmSD/e4we/K+vygGa6butFRkA8E+g/p2ckEiZ/uW+cVdyspvoJRGw+9FyyXam5cq
         tKUR+8UFC5n7VmwCQP8rHi/+hQ5PDk//cvhjT5HtpMvvW9ER33VqwEDQkbDEFxhsM7hb
         z5Yse8JE+ZpUXuCYKRHbRXAPEJQEZ0GE9T76A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:in-reply-to:references:from
         :user-agent:date:message-id:subject:to:cc;
        bh=dorfVU/xJSabHsQtVBWrq/Iqc9CAJtp4oOExMJgEUDQ=;
        b=d9qF463ZgngK1VWkuIPNdosEjYjRqvdQb7cBJvg3r0P4n+vcj3s+5FsDnyQVLzIG6d
         jQbo9CpHlpTzXel5Wb4Cv7QZph28JkIVT6WClYKT89kZPMRw8CGPwyfwh4DnE/3d2/gw
         SadQ13tmHBIWe5W5O9JDYhIqkBDA+iA0+P7G6lbzkmS83sI/gl7HOqs7B8bRlpG00uEx
         S9VE9iImT2zmMsp0+RbmcM23xPK0uTWbZ/0gGVY35cEmEQVHioELRf3u4KAblrwJNNlZ
         nl8n4ccdGai2cvIEGAiDZLor130EEG51f8ejPGnCdtVbIOPOfVlMDQ8o7pS9gCznKH/M
         Jxvw==
X-Gm-Message-State: AOAM531bva5Or2tLgLiFE4uaav/0dDZOHAa7/Q927uiUBaQFDx7Mb6CK
	9KB1DVW7wJq9L3hSovn5yVL8WLEPOygN06S3+UN0DA==
X-Google-Smtp-Source: ABdhPJy/y7cGBki5XtEew+aPGYslTH0aAHoZeAOee7B/n9e30cebHJofLtYmhLy+51DqypLaLc+k7XKo3IKWa8yDq70=
X-Received: by 2002:aca:bd41:0:b0:2ec:ff42:814f with SMTP id
 n62-20020acabd41000000b002ecff42814fmr195472oif.63.1649891644404; Wed, 13 Apr
 2022 16:14:04 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 13 Apr 2022 16:14:02 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <d80ece40-fdd7-f304-3989-47ae152d5ac9@linaro.org>
References: <20220412220033.1273607-1-swboyd@chromium.org> <20220412220033.1273607-2-swboyd@chromium.org>
 <CAD=FV=UFbOhs0ggxDbVwKM_8x=ELT85zFd-Wk6dJ_M+Awz+Pxw@mail.gmail.com> <d80ece40-fdd7-f304-3989-47ae152d5ac9@linaro.org>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Wed, 13 Apr 2022 16:14:02 -0700
Message-ID: <CAE-0n53kebRHTogSkiAOcA4tMpA+EcXQHtNX0Zzut-xE2vCkpw@mail.gmail.com>
Subject: Re: [PATCH 1/2] interconnect: qcom: sc7180: Drop IP0 interconnects
To: Alex Elder <elder@linaro.org>, Doug Anderson <dianders@chromium.org>
Cc: Georgi Djakov <djakov@kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	patches@lists.linux.dev, linux-arm-msm <linux-arm-msm@vger.kernel.org>, 
	Linux PM <linux-pm@vger.kernel.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, 
	Taniya Das <quic_tdas@quicinc.com>, Mike Tipton <quic_mdtipton@quicinc.com>
Content-Type: text/plain; charset="UTF-8"

Quoting Alex Elder (2022-04-13 14:02:00)
> On 4/13/22 3:55 PM, Doug Anderson wrote:
> > Hi,
> >
> > On Tue, Apr 12, 2022 at 4:20 PM Stephen Boyd <swboyd@chromium.org> wrote:
> >>
> >> @@ -519,8 +500,6 @@ static const struct of_device_id qnoc_of_match[] = {
> >>            .data = &sc7180_dc_noc},
> >>          { .compatible = "qcom,sc7180-gem-noc",
> >>            .data = &sc7180_gem_noc},
> >> -       { .compatible = "qcom,sc7180-ipa-virt",
> >> -         .data = &sc7180_ipa_virt},
> >>          { .compatible = "qcom,sc7180-mc-virt",
> >>            .data = &sc7180_mc_virt},
> >>          { .compatible = "qcom,sc7180-mmss-noc",
> >
> > I have no objection to ${SUBJECT} change landing and based on all your
> > research and Alex's review/testing I think it's good to go.
> >
> > However, now that you're removed the driver that cared about
> > "qcom,sc7180-ipa-virt", should we also be removing it from the
> > `bindings/interconnect/qcom,rpmh.yaml` file and the `sc7180.dtsi`
> > file? I think that removing it from _either_ the driver (like your
> > patch here does) _or_ the sc7180.dtsi file would fix the bug, right?
> > ...and then removing it from the yaml would just be cleanup...

Yes, but that's mostly a cleanup. I didn't include it in this series
because DTB is supposed to be "stable" and thus backporting a fix to the
kernel by removing something from DT is sort of wrong. I don't know or
expect that the kernel DTS files will be used from the stable kernels.
It's better to fix the kernel C code. We can of course remove the
binding, but there's a part of me that would prefer that we put the IPA
clk back into the interconnect driver, so leaving the binding is another
motivator for me to hopefully excise the IPA clk from the rpmh-clk
driver in the future.

Anyway, I'm happy to remove the compatible string from the binding if
folks want that. Having the DT node is wasteful because the kernel makes
a device so we can certainly remove that as well. I'll send another
patch for that if this patch is accepted by Georgi.

>
> That's a good point, I hadn't thought about that but you're right.
>
> I think we were too pleased about identifying the problem and
> proving it could happen (and cause a crash), so we didn't think
> hard enough about this other piece.
>
> Stephen, I think you should re-spin the series and add the
> proper change to the binding.  You can keep the tags I gave
> before.

I will not combine the removal of the binding from this patch. This
patch is good as is and fixes the problem while ignoring the DT binding
and that larger discussion.

>
> I've got a note to follow up with similar changes to other
> platforms where the interconnect driver includes resource "IP0"
> and will plan to do what Doug suggests there too.
