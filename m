Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FED4A22
	for <patches@lists.linux.dev>; Fri,  4 Mar 2022 08:18:19 +0000 (UTC)
Received: by mail-wr1-f51.google.com with SMTP id j26so1102549wrb.1
        for <patches@lists.linux.dev>; Fri, 04 Mar 2022 00:18:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=KHvgGTih2dVoUEaH61oQ42JGeTYk4JGgudGnLS9971U=;
        b=u0n+IPWNbY4HzO5MAQdFq+nogfDQDq2mUjKhkhY8vQHB+CBjNtWqxy6h7vKvbG5E++
         JQ0a4Ui+PjFo7PnbPcYc1P9/V5VZwEw7AKHSanNI1+jUrTOlmlngAZSd7yzIwmND0ofm
         Noztmv14PL7HWthkf1ftO7dlbvVFtKY5qHrKL/8SKReN+rrmDzWXIbRTYPuX8FIu/q/j
         YycuDnwcrNqBm8ixbGoOYKHycgtIz3d4q1wTKEufEyDAylvgNsC4vxhy0JN7hIB0VqlW
         FoqX4oYvGSbXXW7Oa2jyowRdUMrYdyupwp8GwWiHBx8+4n351Ik2arpvC9iXI/ESO7jA
         N1jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KHvgGTih2dVoUEaH61oQ42JGeTYk4JGgudGnLS9971U=;
        b=Vutzn70ITucZaN6jehBCBlWoHDvECRFaosHh7I55uMcr6yws09dTLk05wBb9H61RiH
         SKNLXI1rFtm4sPHfGhhkeRgkpjN3bYPTgjt3dEVl7eJkOqq7bpt5XIfEWZ3UL+sn9rwT
         JdcJF8tA2975Elo6WCsyu8cSvPP8pnqxOZhvPpBtDdvi8iK4LhTgcMHl5Hvwov0mzzeP
         WEc0A4dq6Bk1nvsx8uYyRSRxO17Nz2wF068eAlIoOvJvWz978hgOhjfAZbDSOcPmB3Ea
         UjIS53C69X2XkZZKerROMyKHKmtlSTcENxXy57164m9nb/DbcrqTE4JyX1yxOPLX5lvl
         Zobw==
X-Gm-Message-State: AOAM5336ljVhPgY+ok9OoZaXGjbyZ65HbMe3BINQ6cT8mafGMFOFdJi3
	YP75jrRb3CCwJgLf/5uOzuomjA==
X-Google-Smtp-Source: ABdhPJzxdM8deXKouzdgjNPY43ykpYWNxmiMKuoUK0JBgLG1mk7sq7VRJQGPUSX50J0Z9N1xzC1ufA==
X-Received: by 2002:adf:fa8c:0:b0:1f0:47ef:a04 with SMTP id h12-20020adffa8c000000b001f047ef0a04mr6664397wrr.398.1646381897794;
        Fri, 04 Mar 2022 00:18:17 -0800 (PST)
Received: from ?IPV6:2a01:e34:ed2f:f020:551f:d79e:5d4c:9b99? ([2a01:e34:ed2f:f020:551f:d79e:5d4c:9b99])
        by smtp.googlemail.com with ESMTPSA id n5-20020a05600c3b8500b00380fc02ff76sm4783611wms.15.2022.03.04.00.18.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Mar 2022 00:18:17 -0800 (PST)
Message-ID: <5ca8ba3b-e5e0-805d-bc48-7a00d424722f@linaro.org>
Date: Fri, 4 Mar 2022 09:18:15 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH -next] clocksource/drivers/imx-tpm: Move
 tpm_read_sched_clock() under CONFIG_ARM
Content-Language: en-US
To: Nathan Chancellor <nathan@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>
Cc: Shawn Guo <shawnguo@kernel.org>, Sascha Hauer <s.hauer@pengutronix.de>,
 Pengutronix Kernel Team <kernel@pengutronix.de>,
 Fabio Estevam <festevam@gmail.com>, NXP Linux Team <linux-imx@nxp.com>,
 Peng Fan <peng.fan@nxp.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, patches@lists.linux.dev
References: <20220303184212.2356245-1-nathan@kernel.org>
From: Daniel Lezcano <daniel.lezcano@linaro.org>
In-Reply-To: <20220303184212.2356245-1-nathan@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 03/03/2022 19:42, Nathan Chancellor wrote:
> When building this driver for an architecture other than ARCH=arm:
> 
>    drivers/clocksource/timer-imx-tpm.c:78:20: error: unused function 'tpm_read_sched_clock' [-Werror,-Wunused-function]
>    static u64 notrace tpm_read_sched_clock(void)
>                       ^
>    1 error generated.
> 
> Move the function definition under the existing CONFIG_ARM section so
> there is no more warning.
> 
> Fixes: 10720e120e2b ("clocksource/drivers/imx-tpm: Exclude sched clock for ARM64")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---

Applied, thx

-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog
