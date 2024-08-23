Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C671C7B69
	for <patches@lists.linux.dev>; Fri, 23 Aug 2024 20:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724445207; cv=none; b=Mp1/vn9C+WOgwDZjUWIuH5Z3RUyJPUAaVqendTi7OmfPd7PLf7nl8O2JyIunouxlqRCzewf2SnAdG+6YuFGIiXqaGEVX38Jr/Yl0UVbPd6RJLzTCeYoZvrZhxnIPmE4/1CKXfP7mUb3A3dJ8y4p4y2E9BNXj7Tq8Nj8j/BUcCMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724445207; c=relaxed/simple;
	bh=MsOMxkYeIW9qydJzRqD0Ihv3BRacgITErjIgiRvw2KI=;
	h=MIME-Version:In-Reply-To:References:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VnuA2epa2uhrbzHKr6F22AyodqdDTh4WkLraBzK27DituR/cdRLoNplakxjPWjUd/bn9Qirj00YhzZH3iULf4EwNF61cafxfQSyyyS98sBphT75J7QFN0ZlWSFm1b6pwu6RIC6/NpgDEWaaTplceKiUWlo7csiIVluvRrcirIzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=P6oPLauR; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="P6oPLauR"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-7a1e0ff6871so151505685a.2
        for <patches@lists.linux.dev>; Fri, 23 Aug 2024 13:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1724445205; x=1725050005; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/0Yyeee2Vf8r1D/wovFCOKuxZaGFv9fKeG3mfjxEVas=;
        b=P6oPLauR8e0p/bMnM6pmwhmK6T0zOALhIDVcjmqvxXEfRCEE9iCt79bk5YuHjNjBUY
         1ReQOLigX1EQG9yMfSkcjs3fVE2jBgQp4FCtASGjzd88JeZ2U3TELvAGaiqYNmXzL+T/
         1GwsdmfDoY6rgW8BqBDBSVguG80N6HPs7nmBo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724445205; x=1725050005;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/0Yyeee2Vf8r1D/wovFCOKuxZaGFv9fKeG3mfjxEVas=;
        b=Ii8XtRhOZ0vSAFiWDi0X1Kcotc4uzJnic8D9q5xfuSQlE6JBhgqkauJIPlwpdF6Qzs
         nqYtm0UZiyygHh6wYXeym36n0jhHVGLiOP+bNsnpA1zbWvwG2u5EnQa78xdPysjFhZ6+
         1Mww+1xTUJ2/SJdIzC8V2VhMU3tQx44vtqQi725M40Nhrb+TVN92VijN34w3KuyGWxqM
         dOs3WORiWoorWfhmLaBy/EoJkUL3hxZeHA5B1mGwFFkOHdczgi3MdEGvhsRh0LjMbN8Z
         BQbE8VQfqoKrbOuUbDAk78SE87M3Uc87qfOP5KZUOrRMeUngkUs9c3Oo3JQ6gGpOMiHw
         INwQ==
X-Forwarded-Encrypted: i=1; AJvYcCX4gBMuXxz/zklHxYxcZd5ef87tz+rLUPq1+EeaciCpM+gHw61wNL9tsEEHaXOybdKkg1LnvyR/@lists.linux.dev
X-Gm-Message-State: AOJu0YzybY+pY0Z0y+o1efAlBNivvVQ6UrPHBA1YSxv94o7WcUsZeNcY
	q5geXeeFaQhiuGe9YXk2WlYCKS4lKUipnQHFGx97h8MxYJpotsz6np5MicYE3NgvhFWZe33K2Yx
	PKU5hNN0Mq0bnKnbVYv4UxZQGp498vwFYlX+A
X-Google-Smtp-Source: AGHT+IGW/VO5LDbH2qUnWbdRuqhhtG11KOFQeC4peX75Dv4BIQ4AXaDFfDgoU0VrJw72vzH9xwkXBWdGeZo2zOTAGgE=
X-Received: by 2002:a05:620a:461e:b0:79f:dce:76c7 with SMTP id
 af79cd13be357-7a6897c444dmr460409785a.68.1724445205109; Fri, 23 Aug 2024
 13:33:25 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 23 Aug 2024 13:33:24 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <d03d5425-bd7c-4c20-a54e-5708ffd059e0@linaro.org>
References: <20240819233628.2074654-1-swboyd@chromium.org> <d03d5425-bd7c-4c20-a54e-5708ffd059e0@linaro.org>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Fri, 23 Aug 2024 13:33:24 -0700
Message-ID: <CAE-0n52=kQzEx76D5AmZfui_X0jqejQ+ENz+VQunY_ovph65Hw@mail.gmail.com>
Subject: Re: [PATCH 0/2] clk: qcom: gcc-sm8550: Fix shared clk parking breakage
To: Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konrad.dybcio@linaro.org>, 
	neil.armstrong@linaro.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	patches@lists.linux.dev, linux-clk@vger.kernel.org, 
	Amit Pundir <amit.pundir@linaro.org>, Taniya Das <quic_tdas@quicinc.com>
Content-Type: text/plain; charset="UTF-8"

Quoting neil.armstrong@linaro.org (2024-08-21 08:44:00)
> Hi,
>
> On 20/08/2024 01:36, Stephen Boyd wrote:
> > Amit Pundir reported[1] that a recent commit 01a0a6cc8cfd ("clk: qcom:
> > Park shared RCGs upon registration") broke USB and audio on sm8550-hdk.
> > These two patches fix the issue by skipping the parking bit of the
> > shared RCGs for devices that can't run so slow.
> >
> > [1] https://lore.kernel.org/CAMi1Hd1KQBE4kKUdAn8E5FV+BiKzuv+8FoyWQrrTHPDoYTuhgA@mail.gmail.com/
> >
> > Stephen Boyd (2):
> >    clk: qcom: gcc-sm8550: Don't use parking clk_ops for QUPs
> >    clk: qcom: gcc-sm8550: Don't park the USB RCG at registration time
> >
> >   drivers/clk/qcom/clk-rcg.h    |  1 +
> >   drivers/clk/qcom/clk-rcg2.c   | 30 +++++++++++++++++++
> >   drivers/clk/qcom/gcc-sm8550.c | 54 +++++++++++++++++------------------
> >   3 files changed, 58 insertions(+), 27 deletions(-)
> >
> >
> > base-commit: 8400291e289ee6b2bf9779ff1c83a291501f017b
>
> I'm pretty sure sm8450 & sm8650 (and probably other SoCs) could be also affected, could you check ?

Does someone have the hardware to test? It looks like sm8450 isn't using
the shared ops, but sm8650 is, likely incorrectly.
