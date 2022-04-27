Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C887B
	for <patches@lists.linux.dev>; Wed, 27 Apr 2022 14:35:51 +0000 (UTC)
Received: by mail-ej1-f43.google.com with SMTP id l18so3803308ejc.7
        for <patches@lists.linux.dev>; Wed, 27 Apr 2022 07:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iBjVwlfQHfJTzGZmbfEvXhaX1IO5OkSRicNnSdosqfE=;
        b=NSdJkx1jUjjiXuAhxMA30qKgzaND/A7AqoOWPp5E5YGLrXn7dcO3OQMupXUipJJWOA
         JUFRfFkfl9q1bKNHk3/zQMSwlO/gsV/x5hR66QT7FXzr1siOkocOBQR/F+ktgDFUNnWb
         X5fL4fh2Ok7wc8jM9Rp0R1OuGPLDz4fwit9ro=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iBjVwlfQHfJTzGZmbfEvXhaX1IO5OkSRicNnSdosqfE=;
        b=Ir1H0gjXSOkw6Gb0OU3zkb9RsioF0x48YKd0W48UI8ZRC8ss1Ew0FSfQkmOOYGy5Fo
         QYXI91fi3yqSE0KmShWXDsl/MNfVWZSEwqdqvf5Ow3udxnsDPc23hk1jRlsXid9poKD9
         XqmunwYy9GAZ9LMpV1FD2ngjFSgij5nbXMVmUA2fC0S5ixP/XOYbLjTiKreG7CeEWgxI
         0FZeIFwSflnU7bGh6uLRDjP8HfkGQmZM0JOHo/xnwaySwGWaKZGCD2bAqmkc8EM9PEJo
         LFDEG31o9NMHPGTmqSg0ApCKb2la4M714XL4D8ahjOoIp6ns1qZa+oHL/MzCpBLqT/UG
         7EWA==
X-Gm-Message-State: AOAM5319PkCH93MXJ3m134e5YPEUugmxoVLMu5KAyKiYhqKtjcS7sOJO
	DciZINSQHus1aYaQMJUpl0+ramu2AOwyeVbZeIg=
X-Google-Smtp-Source: ABdhPJwCheneFDzZp4cpK1/82JiClRODNGHJmYfpqxOZbeBzP+S17LbeoZCeN4/DGrERhIUM7bseHg==
X-Received: by 2002:a17:907:6284:b0:6e0:f895:15a with SMTP id nd4-20020a170907628400b006e0f895015amr27177038ejc.713.1651070149126;
        Wed, 27 Apr 2022 07:35:49 -0700 (PDT)
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com. [209.85.128.47])
        by smtp.gmail.com with ESMTPSA id ao9-20020a170907358900b006f3995f0fe0sm4159312ejc.6.2022.04.27.07.35.48
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Apr 2022 07:35:48 -0700 (PDT)
Received: by mail-wm1-f47.google.com with SMTP id ay11-20020a05600c1e0b00b0038eb92fa965so3559551wmb.4
        for <patches@lists.linux.dev>; Wed, 27 Apr 2022 07:35:48 -0700 (PDT)
X-Received: by 2002:a05:600c:3c99:b0:392:b49c:7b79 with SMTP id
 bg25-20020a05600c3c9900b00392b49c7b79mr26204171wmb.199.1651070147811; Wed, 27
 Apr 2022 07:35:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220427013226.341209-1-swboyd@chromium.org>
In-Reply-To: <20220427013226.341209-1-swboyd@chromium.org>
From: Doug Anderson <dianders@chromium.org>
Date: Wed, 27 Apr 2022 07:35:36 -0700
X-Gmail-Original-Message-ID: <CAD=FV=UK522o=zak8ryR4e8yGTm=wGtMjxtfYNJ4DXk5ayAGhw@mail.gmail.com>
Message-ID: <CAD=FV=UK522o=zak8ryR4e8yGTm=wGtMjxtfYNJ4DXk5ayAGhw@mail.gmail.com>
Subject: Re: [PATCH] interconnect: Restore sync state by ignoring ipa-virt in
 provider count
To: Stephen Boyd <swboyd@chromium.org>
Cc: Georgi Djakov <djakov@kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	patches@lists.linux.dev, Linux PM <linux-pm@vger.kernel.org>, 
	linux-arm-msm <linux-arm-msm@vger.kernel.org>, 
	Bjorn Andersson <bjorn.andersson@linaro.org>, Alex Elder <elder@linaro.org>, 
	Taniya Das <quic_tdas@quicinc.com>, Mike Tipton <quic_mdtipton@quicinc.com>
Content-Type: text/plain; charset="UTF-8"

Hi,

On Tue, Apr 26, 2022 at 6:32 PM Stephen Boyd <swboyd@chromium.org> wrote:
>
> Ignore compatible strings for the IPA virt drivers that were removed in
> commits 2fb251c26560 ("interconnect: qcom: sdx55: Drop IP0
> interconnects") and 2f3724930eb4 ("interconnect: qcom: sc7180: Drop IP0
> interconnects") so that the sync state logic can kick in again.
> Otherwise all the interconnects in the system will stay pegged at max
> speeds because 'providers_count' is always going to be one larger than
> the number of drivers that will ever probe on sc7180 or sdx55. This
> fixes suspend on sc7180 and sdx55 devices when you don't have a
> devicetree patch to remove the ipa-virt compatible node.
>
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Cc: Doug Anderson <dianders@chromium.org>
> Cc: Alex Elder <elder@linaro.org>
> Cc: Taniya Das <quic_tdas@quicinc.com>
> Cc: Mike Tipton <quic_mdtipton@quicinc.com>
> Fixes: 2fb251c26560 ("interconnect: qcom: sdx55: Drop IP0 interconnects")
> Fixes: 2f3724930eb4 ("interconnect: qcom: sc7180: Drop IP0 interconnects")
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  drivers/interconnect/core.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)

Ick, but seems like an expedient fix to get us back to working while
we try to come up with something better.

Reviewed-by: Douglas Anderson <dianders@chromium.org>
