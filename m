Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057C07C
	for <patches@lists.linux.dev>; Mon, 23 Jan 2023 11:07:59 +0000 (UTC)
Received: by mail-lf1-f46.google.com with SMTP id h24so13333467lfv.6
        for <patches@lists.linux.dev>; Mon, 23 Jan 2023 03:07:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DWWvq/P2rQvC944dHoFoJoaCJsFP0QQ/YpqQ85XOpVk=;
        b=xlVmUlnce8mcOV95i8iMua1zPcCngTN5MWrfnKG5ipN0/e9uX4fQQJd+C/GHFpF9vi
         aF48PdvD3Wo2vYrsOtnJ82LZMEnCR7PhDDmGFuKPlcflSiy9ayRYfliLQo7i4y3ik8TE
         diobAqRXGznqiYzol4m3/N+4Hs00blHCip1VQgRs1UWB07rMrPKR1GkTtGcoh+2mp2z6
         gra3qm0b2xaCiGIh0Cs/Fw4t8qTMBXJ+gQBIf0tVSYriUO0rr3EGwOv67RlxXUshKgmk
         uLz9EO+bwnhl4a2a8vcYE1ul0ucBIVJx6ua2sLC+1TPLryoIuvxFWcwTyN2NRfcrZhb8
         45tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DWWvq/P2rQvC944dHoFoJoaCJsFP0QQ/YpqQ85XOpVk=;
        b=HciiHsOkZ4wGtpnIf4pbc2ddZdJEwwdHLzN/upolub9ay0YJ9epkA/DU72JENX6m4G
         zNwxiB0iraXoFEmQud+ZCt5pGXdHNnsprtnHr6p6V6P+BY1+Spz/qqg2lTof4iAZsXV1
         VvUap/YS+5A3ClHkNJ6ZL9FrkAktHJV2A0y8nLW/eQUhh+ZgwoSl6WCFwjG9bjRiOz6T
         v3gxWB2Dv/+5n99lV6NI8UPQFrOXeQvt5GlkbOmOYu61Y2aTogBbwEKW/+zg5Y+OYfcz
         Au3GzEKkxPIgaBJ6fxABbMZzX3S5TWpxohgXdSOcvTzWZS3PQ6Zst1w24oVCD9z2REnV
         uuPw==
X-Gm-Message-State: AFqh2kqe+90WmxxZJ5Iw9jjvSqRoHmf4W+/8AQL3vLmE3oZPA7E9o7L6
	slHeLzKs3y0NheDHNAC4DU53Qw==
X-Google-Smtp-Source: AMrXdXss9WKzPKtAzjxDfNCYuw33PRC7qMBIXqzr3PPEyoU775UKFXrJ60jxxXh+Iaq6da7YeygnKw==
X-Received: by 2002:a05:6512:b99:b0:4d5:95c9:4eb9 with SMTP id b25-20020a0565120b9900b004d595c94eb9mr6473785lfv.44.1674472078039;
        Mon, 23 Jan 2023 03:07:58 -0800 (PST)
Received: from [192.168.1.211] ([37.153.55.125])
        by smtp.gmail.com with ESMTPSA id c19-20020a056512325300b004cb3d77a936sm6494240lfr.46.2023.01.23.03.07.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 03:07:57 -0800 (PST)
Message-ID: <a8d0a067-f5ff-6bd8-0552-99554b52ace6@linaro.org>
Date: Mon, 23 Jan 2023 13:07:56 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] phy: qcom-qmp: Introduce Kconfig symbols for discrete
 drivers
Content-Language: en-GB
To: Stephen Boyd <swboyd@chromium.org>, Vinod Koul <vkoul@kernel.org>,
 Kishon Vijay Abraham I <kishon@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
 Johan Hovold <johan+linaro@kernel.org>
References: <20230114000910.1256462-1-swboyd@chromium.org>
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
In-Reply-To: <20230114000910.1256462-1-swboyd@chromium.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 14/01/2023 02:09, Stephen Boyd wrote:
> Introduce a config option for each QMP PHY driver now that the QMP PHY
> mega-driver has been split up into different modules. This allows kernel
> configurators to limit the binary size of the kernel by only compiling
> in the QMP PHY driver that they need, or to split the module up into one
> per PHY driver instead of one module for all the QMP PHY drivers.
> 
> Leave the old config QCOM_QMP in place and make it into a menuconfig so
> that 'make olddefconfig' continues to work. Furthermore, set the default
> of the new Kconfig symbols to be QCOM_QMP so that the transition is
> smooth.
> 
> Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> Cc: Johan Hovold <johan+linaro@kernel.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>   drivers/phy/qualcomm/Kconfig  | 50 ++++++++++++++++++++++++++++++++---
>   drivers/phy/qualcomm/Makefile | 12 ++++-----
>   2 files changed, 52 insertions(+), 10 deletions(-)

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

-- 
With best wishes
Dmitry

