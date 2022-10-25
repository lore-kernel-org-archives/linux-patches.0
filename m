Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F046D6FC0
	for <patches@lists.linux.dev>; Tue, 25 Oct 2022 19:39:42 +0000 (UTC)
Received: by mail-ej1-f48.google.com with SMTP id f27so4853305eje.1
        for <patches@lists.linux.dev>; Tue, 25 Oct 2022 12:39:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KO4jYktTVlE4tPrXjK/e9XeWuNWY6QxpH8jzqQKB8q4=;
        b=Tg/pZVEKhlBVoyA2jinR/rTmorWbG6k16SdM2i53Q9zn6kQnqPdi6bOfnyP3OFYfzy
         2/4Hm9OiwRN8k15sj6sljo0XoZy6QIv5B901LDWdVFrBLOJ244WD9Plh337cI7iglRw5
         abxm0O73GgHNkMntQriim9vqLl5kNYeQ6WfoA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KO4jYktTVlE4tPrXjK/e9XeWuNWY6QxpH8jzqQKB8q4=;
        b=WZpWDTf/qg+19iXnn3mGvCqc5rRBTeVJNNdIqGoZJ5SLMlU2EZuFOGwczWAgPz4Gg1
         tTK7xZvJ/IlcoTLUALhW9DE5P8XbZ4+Fx08owlZ9MdOyOhWIWF8pvCpjUIEbTUvOPSyH
         zI9gWMwwcR1rKScVvd1cLIUuilQc5P8AZF2KVO1OAJPu+yr/mCzKVWgU1WRPiSghVBqK
         dggNWwFAitVR05xGhSsDe/21cd/lsIzvXdPLCwqOWMQZJ/2+XJS1DuNLPezcbvysZc0P
         prxFuKPprJHaM16S5hErNxYrpV/bD9lQNA/8B263mpPokY/KfeyOXrXcxIR8J1j3+qU3
         Gv8g==
X-Gm-Message-State: ACrzQf1Rq3gMl0/KgKZzmY2wS6ZQvw0WSa7n01e1pwm5oMbJMnoDVp7S
	ug9k9doJjq/qPspUGSJVl4u4DOBCIagYQZ+s
X-Google-Smtp-Source: AMsMyM7HQhRlY2c/vErFdPPyshY7bho9fvkoglHWYVjfeZk0B36vLJoLwm902+ml697sGkwHsapzBg==
X-Received: by 2002:a17:906:8458:b0:7ac:a48d:a680 with SMTP id e24-20020a170906845800b007aca48da680mr3557799ejy.105.1666726770617;
        Tue, 25 Oct 2022 12:39:30 -0700 (PDT)
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com. [209.85.128.43])
        by smtp.gmail.com with ESMTPSA id z10-20020a170906434a00b0079b9f7509a0sm1847644ejm.52.2022.10.25.12.39.29
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Oct 2022 12:39:29 -0700 (PDT)
Received: by mail-wm1-f43.google.com with SMTP id i5-20020a1c3b05000000b003cf47dcd316so987197wma.4
        for <patches@lists.linux.dev>; Tue, 25 Oct 2022 12:39:29 -0700 (PDT)
X-Received: by 2002:a05:600c:5493:b0:3c9:c18:87d5 with SMTP id
 iv19-20020a05600c549300b003c90c1887d5mr12934748wmb.188.1666726768937; Tue, 25
 Oct 2022 12:39:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221025180703.1806234-1-swboyd@chromium.org>
In-Reply-To: <20221025180703.1806234-1-swboyd@chromium.org>
From: Doug Anderson <dianders@chromium.org>
Date: Tue, 25 Oct 2022 12:39:17 -0700
X-Gmail-Original-Message-ID: <CAD=FV=VArrvWtxbrT_t=kUqX54MM1_TvTv7pA2PuAhT2QHmF0g@mail.gmail.com>
Message-ID: <CAD=FV=VArrvWtxbrT_t=kUqX54MM1_TvTv7pA2PuAhT2QHmF0g@mail.gmail.com>
Subject: Re: [PATCH] arm64: dts: qcom: Remove fingerprint node from herobrine-r1
To: Stephen Boyd <swboyd@chromium.org>
Cc: Andy Gross <agross@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

On Tue, Oct 25, 2022 at 11:07 AM Stephen Boyd <swboyd@chromium.org> wrote:
>
> It turns out that only a few people have the fingerprint sensor hooked
> up on their board. Leaving this enabled is slowing down boot for
> everyone else because the driver slowly fails to probe while trying to
> communicate with a sensor that isn't there. Remove the node to speed up
> boot, developers with the board can manually enable it themselves.
>
> Reported-by: Douglas Anderson <dianders@chromium.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  arch/arm64/boot/dts/qcom/sc7280-herobrine-herobrine-r1.dts | 4 ----
>  1 file changed, 4 deletions(-)

Reviewed-by: Douglas Anderson <dianders@chromium.org>
