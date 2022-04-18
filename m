Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60CD0A41
	for <patches@lists.linux.dev>; Mon, 18 Apr 2022 19:48:09 +0000 (UTC)
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-deb9295679so15241055fac.6
        for <patches@lists.linux.dev>; Mon, 18 Apr 2022 12:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:in-reply-to:references:from:user-agent:date:message-id
         :subject:to:cc;
        bh=R8MVyQVH63UKDlO5ebK94G5i5p2wDyYsAtV0teKaE/s=;
        b=ZhCqVdEkoLVNEjcGJlt+Orq1svQI51yFjZ5yzspPDulfEmlo4fFK77Zj/fvsCzAmzt
         0PiusX7wSluCRHHd/8c0/S5RUDr6NxLnpuvBYmGj1wnGgX4lUKcRNl3DDiy3uQvqz/jj
         ITwRwDMHccDzMO0LQuZiVYK7ZyYb3YYtHJEXE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:in-reply-to:references:from
         :user-agent:date:message-id:subject:to:cc;
        bh=R8MVyQVH63UKDlO5ebK94G5i5p2wDyYsAtV0teKaE/s=;
        b=x62Ft+28tj53bWt1JOuaQGjM0i3dmW2AuAe9SVLyw4/iAtx+ETTvGOgu9kHgpmS2cF
         HM6rZK907W71LZ5SEOjN0/ILqH2ZNoaWXiAqcYS2SghO6crgUylTbd5/qdaycu3PjmZN
         kr8AwN21oROqpsOLTYAW8VL+DGdbNwBJJqNzLNCzjOht0R3cwk24hJmLmJcqqzr5L9/z
         SPyreCzPNZOInlqbSIBWyIU0iYM4+dfMeFXzKWkeNzH2dnIJBVdmFBMqaNFjP1tfNFxj
         yhLn/JGwfxlHA/vPCjcNbAQvgFDE2TmW0WfJznh8uB/7snUVAHEllUmK8sE6xulXn5Qn
         hOlg==
X-Gm-Message-State: AOAM533XLAR2q0BHEzOV70X++wZRJ8jP1S2zSnWEyGT0B5zK8r8DTnrU
	8SSNvy/gPwEXtw7+l142PWmZ+koTO9RJ1aTRkUhuVw==
X-Google-Smtp-Source: ABdhPJxNTgtzk/Xz7kcv1RUxdYb0jMn0kKe1rbAUme2rCqK9BQTcKgtEnt+Xs0lHTfuvKTMKV0qsQkfn2jAOY12S3mE=
X-Received: by 2002:a05:6870:3907:b0:e5:a6fd:4047 with SMTP id
 b7-20020a056870390700b000e5a6fd4047mr4779741oap.193.1650311288551; Mon, 18
 Apr 2022 12:48:08 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 18 Apr 2022 12:48:08 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <d32fc9f8-65cd-a30f-cdf2-f019bbe7cd69@linaro.org>
References: <20220412220033.1273607-1-swboyd@chromium.org> <20220415005828.1980055-1-swboyd@chromium.org>
 <20220415005828.1980055-3-swboyd@chromium.org> <d32fc9f8-65cd-a30f-cdf2-f019bbe7cd69@linaro.org>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Mon, 18 Apr 2022 12:48:08 -0700
Message-ID: <CAE-0n53yggqX+mNcRQ+_iVHZhZgw-cCBVSC+ka++vwprpKMaGQ@mail.gmail.com>
Subject: Re: [PATCH 5/2] dt-bindings: interconnect: Remove sc7180/sdx55 ipa compatibles
To: Alex Elder <elder@linaro.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, 
	Georgi Djakov <djakov@kernel.org>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	linux-arm-msm@vger.kernel.org, linux-pm@vger.kernel.org, 
	Doug Anderson <dianders@chromium.org>, Taniya Das <quic_tdas@quicinc.com>, 
	Mike Tipton <quic_mdtipton@quicinc.com>, devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Quoting Alex Elder (2022-04-15 13:15:21)
> On 4/14/22 7:58 PM, Stephen Boyd wrote:
> > These interconnects are modeled as clks, not interconnects, therefore
> > remove the compatibles from the binding as they're unused.
> >
> > Cc: Alex Elder <elder@linaro.org>
> > Cc: Taniya Das <quic_tdas@quicinc.com>
> > Cc: Mike Tipton <quic_mdtipton@quicinc.com>
> > Signed-off-by: Stephen Boyd <swboyd@chromium.org>
>
> What's the proper thing to do for properties that stop being
> used?  Do we delete them, like this, or deprecate them somehow?
> Old DTBs might define the values that are deleted here.

I think we leave them around until the last dts user stops using them.

>
> Shouldn't devicetree@vger.kernel.org
>   be copied on this and
> the other DTS patches?

Sure. I added it now. Thanks.

>
> > ---
> >
> > I don't know who should apply this. Probably whoever takes the dtsi
> > patches, Bjorn?, because otherwise dt_bindings_check will fail.
> >
> >   Documentation/devicetree/bindings/interconnect/qcom,rpmh.yaml | 2 --
> >   1 file changed, 2 deletions(-)
> >
> > diff --git a/Documentation/devicetree/bindings/interconnect/qcom,rpmh.yaml b/Documentation/devicetree/bindings/interconnect/qcom,rpmh.yaml
> > index 5a911be0c2ea..ab859150c7f7 100644
> > --- a/Documentation/devicetree/bindings/interconnect/qcom,rpmh.yaml
> > +++ b/Documentation/devicetree/bindings/interconnect/qcom,rpmh.yaml
> > @@ -31,7 +31,6 @@ properties:
> >         - qcom,sc7180-config-noc
> >         - qcom,sc7180-dc-noc
> >         - qcom,sc7180-gem-noc
> > -      - qcom,sc7180-ipa-virt
> >         - qcom,sc7180-mc-virt
> >         - qcom,sc7180-mmss-noc
> >         - qcom,sc7180-npu-noc
> > @@ -68,7 +67,6 @@ properties:
> >         - qcom,sdm845-mem-noc
> >         - qcom,sdm845-mmss-noc
> >         - qcom,sdm845-system-noc
> > -      - qcom,sdx55-ipa-virt
> >         - qcom,sdx55-mc-virt
> >         - qcom,sdx55-mem-noc
> >         - qcom,sdx55-system-noc
>
