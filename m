Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9D61103
	for <patches@lists.linux.dev>; Tue, 17 May 2022 06:06:27 +0000 (UTC)
Received: by mail-oo1-f51.google.com with SMTP id l9-20020a4abe09000000b0035eb3d4a2aeso4467858oop.0
        for <patches@lists.linux.dev>; Mon, 16 May 2022 23:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:in-reply-to:references:from:user-agent:date:message-id
         :subject:to:cc;
        bh=hCNmcVkJkyr6UREPk/U3gfOYerfjOeNt4hoZ5B1uXTk=;
        b=cFZB+U9jeB3yfi38/Mfs3qMy7zVn/f9RjNOyAbXoQybgx9K6PuqkupAoXngkYu6PFP
         Wao2XWHQxMac/ZOyF3nkJyEju6SlwTblxxWs/R4Ga5rJH5cf8UNtsUMEN5nPALJThdfr
         OX40EDmD+6O2WIMQVW8mbnXI4zgwpveJpRNeI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:in-reply-to:references:from
         :user-agent:date:message-id:subject:to:cc;
        bh=hCNmcVkJkyr6UREPk/U3gfOYerfjOeNt4hoZ5B1uXTk=;
        b=lvz/bnf43lO+9voTlKubSe//5WTIRfFM+1s5APFJRHOswOtAs9dX3oM+8XDvJvTczK
         vWWIFHCAbFIhoDZGCzrBHnHsrD8G6OLnCzrlypilkDeGfSgXDVJid6jTqcBdEyhOHgwG
         XxDQ+43esYoYCql0xgQ2zCdtrxAPR2aJe8t/Aswt28nDrljgDorHVnito7OBIl9QWNcV
         5IHo1VwJJ9l0jLdr3ZLw3Y9FL/MD+4FQzQCj/JBEuZdrApkZGRp4r4WeqE4tk+BN5nWF
         LE1t2zcUvR7xGAPV0mqRsPx284TPLyN7KWMeTScpy3nwZSK03rc0O3FI81yxRtEpXPOa
         glXQ==
X-Gm-Message-State: AOAM532SR+qj8Ax4PxhR+eyC29lvkDz5lfeVq5wF0/toewqAsw3rrafz
	KM73UETvn6yLBva6vEvXwRtMFdB2tD05JAy/Xb6yPA==
X-Google-Smtp-Source: ABdhPJz3E5+o8ylS4apeBap5pfY7Cog+dvfGVMjGdgWuyn2+LmRYX7S/Cs7EjYLLIgeMzHEHVEj63CMyFfYwZLWsEsg=
X-Received: by 2002:a4a:6f49:0:b0:35e:1902:1d3b with SMTP id
 i9-20020a4a6f49000000b0035e19021d3bmr7476202oof.1.1652767586267; Mon, 16 May
 2022 23:06:26 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 16 May 2022 23:06:25 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <4e14f1d5-2abc-8c30-d54d-7e542ca4eccf@linaro.org>
References: <20220412194505.614002-1-swboyd@chromium.org> <YnKvoh+h07at8b65@builder.lan>
 <CAE-0n517iAS9KSdunMX18LpqDrQ4ac-yRCZq82j-XdExaGjCXA@mail.gmail.com>
 <CAE-0n53eXiz74iCHHQaC-eDFkuui9Y1xXvuqd2g0UnrwbYhZTg@mail.gmail.com> <4e14f1d5-2abc-8c30-d54d-7e542ca4eccf@linaro.org>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Mon, 16 May 2022 23:06:25 -0700
Message-ID: <CAE-0n526x45m_con53GuZtTzKS8Fx-Gs1Y=uPEHY0ftO_aay_w@mail.gmail.com>
Subject: Re: [PATCH] clk: qcom: rpmh: Set wake/sleep state for BCM clks
To: Alex Elder <elder@linaro.org>, Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Michael Turquette <mturquette@baylibre.com>, Stephen Boyd <sboyd@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, patches@lists.linux.dev, 
	Taniya Das <quic_tdas@quicinc.com>
Content-Type: text/plain; charset="UTF-8"

Quoting Alex Elder (2022-05-12 08:15:31)
> On 5/11/22 5:04 PM, Stephen Boyd wrote:
> >>> Will you take this in fixes, or do you want me to pick it for 5.19?
> >>>
> >> I'm waiting for Taniya to reply. For all I know this has no effect
> >> because there's some sort of copy/paste from one state to another. Until
> >> then it doesn't seem like we should do anything.
> > Taniya told me that if there's no sleep or wake state set then active
> > state remains even when the subsystem is in sleep. Not exactly
> > copy/paste but at least it is consistent. We need a comment here so this
> > doesn't come up again.
>
> If I understand what you're saying here, your original patch is not
> necessary, but there should be a comment in the code that explains
> why that is the case.  Is that right?  And am I right to assume you
> will be sending out a patch with such a comment?
>

Yes.
