Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF131B29B5
	for <patches@lists.linux.dev>; Thu, 29 Aug 2024 15:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724945573; cv=none; b=mWAFhUwWiRh0uwCQQz+LeMGaweD9scSFuTRy5dyYJWM0cwnHgf3hH6ELRs38sfLfGA91S0C14dRCKpfQiQaY17oCq1ZeKOv/V138vzT7yn+guh2H6l7pMJ8eCRFfxfxm1IIxQpdYvClw4GG9JaktQq8QmLWqYYHr3L5W6ccy/3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724945573; c=relaxed/simple;
	bh=0G7mze1wqVFZhZ50FKq6hXqQeQruWH7KyxgzMCGv9Jg=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=aP5AMpZlv4kttypUXSt3OvM0Tjam0bY/CJ61LFmwtrLzHnTtcxulSgaAOOuOzYHADX7LNcwOWzbm+rllQZwf3/xPAgExLkzpuMfena48wmEME/mJmuAtn/iOqtDMXcB6G4W5Rgg3KWSZxI8dpWOQNF4DSFPRc9HpvKBATime49I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bw8zqFys; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bw8zqFys"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4280c55e488so5453285e9.0
        for <patches@lists.linux.dev>; Thu, 29 Aug 2024 08:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1724945570; x=1725550370; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uwIrcvcDSEkc0RK+FZLEdtiYNR69eb3bXf7QeoQAwQo=;
        b=bw8zqFysq6lJEyDuCtUBHJ6AmK+EVUn2T6VFfEscbw0X14RaaAVhK8t0W/zMXF8wzU
         4YSfufhXzqme6Uuk1VQtL8mwl5DHOPSzmHLOUm6RmIzi+Xf0WtU/K/GnzXoOxh0ngsHs
         tZ5G3Uec1b4uToFm5GX/kqqtoNp2f61NblL6P/Xnn9aFKOF/6mDmDO1VloadLniN+K5Y
         LCYZRNhs6LZTAgYi+Acru5kN17oMrBLWGp1lW3WcF/BUyGSaaEQrapt5iHxBI6LhUPRD
         jh+IcUM0YljZovNzBfaQNlWIOTKI1n8nH2hemmLEdrWi1eZASkLMOH7MH0UUkQ00jgUw
         KNYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724945570; x=1725550370;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uwIrcvcDSEkc0RK+FZLEdtiYNR69eb3bXf7QeoQAwQo=;
        b=WOz2kQqJ+uV60rScLxbcohJIjRxLvSh+1yq6mOuUMSttll/5lRlcm3SXT2483n2PrW
         SET62OIjaTcpiZcjiNCyPQP9IDaoAoBbAPxaaiXuVg28cBhiLCR8Cd+WNTuuq+YyQinh
         k3cPk31wilG0+0fDQ2cwZuIJi+Zsp9ntLrVM2sLwbQz8mrDdHLfbIwx4a5JCG3YoJDZc
         9lPikZ/7LOVxpvNFc64Pyry85KBuWEI4cm0tq3LhDn34aa/BpDCIcUKWlQC+3dP7Egjw
         vTi0iZAWHhbWnmefkD4jRCQT7o6XwAeX/LzC59ErCGmakbnDwdTKD1Ou3cMkDaq+wC/b
         5ZMA==
X-Forwarded-Encrypted: i=1; AJvYcCWEshCJUc0PNGvshPeD6BA6G6qVHNwUteM6o89I9ZrDBDhvw2PjW6PfRYWQEMgMrjI/yRwTxj4k@lists.linux.dev
X-Gm-Message-State: AOJu0Yy96Ik3qSLi05F3EAPliKhm1vYfR/ap6rX2hb2Vywk36QgpT0bM
	wZOpNaxQ0f+cus64KhNlOZNk/IQEXBFl4ngPHOZIuQxW5RHhZYfUgDzebrckbQA=
X-Google-Smtp-Source: AGHT+IH9+8PYMVuyhooHnEKm7HBNRG/ZhyKn3bATO2CBKzTwDuYlMBgk64q+sm8/yfyRVK6phMfsFQ==
X-Received: by 2002:a05:600c:2214:b0:426:5e32:4857 with SMTP id 5b1f17b1804b1-42bb7396721mr22388775e9.0.1724945569542;
        Thu, 29 Aug 2024 08:32:49 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:982:cbb0:12f5:c9c:a0e1:6915? ([2a01:e0a:982:cbb0:12f5:c9c:a0e1:6915])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3749ee9ba8esm1699175f8f.50.2024.08.29.08.32.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Aug 2024 08:32:49 -0700 (PDT)
Message-ID: <c1e35d3d-fa00-4453-aaa3-9f23a07acb4f@linaro.org>
Date: Thu, 29 Aug 2024 17:32:48 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Neil Armstrong <neil.armstrong@linaro.org>
Reply-To: neil.armstrong@linaro.org
Subject: Re: [PATCH v3 1/2] clk: qcom: dispcc-sc7180: Only park display clks
 at init
To: Stephen Boyd <swboyd@chromium.org>, Konrad Dybcio
 <konradybcio@kernel.org>, Bjorn Andersson <andersson@kernel.org>,
 Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 patches@lists.linux.dev, linux-clk@vger.kernel.org,
 Amit Pundir <amit.pundir@linaro.org>, Taniya Das <quic_tdas@quicinc.com>
References: <20240828171722.1251587-1-swboyd@chromium.org>
 <20240828171722.1251587-2-swboyd@chromium.org>
Content-Language: en-US, fr
Autocrypt: addr=neil.armstrong@linaro.org; keydata=
 xsBNBE1ZBs8BCAD78xVLsXPwV/2qQx2FaO/7mhWL0Qodw8UcQJnkrWmgTFRobtTWxuRx8WWP
 GTjuhvbleoQ5Cxjr+v+1ARGCH46MxFP5DwauzPekwJUD5QKZlaw/bURTLmS2id5wWi3lqVH4
 BVF2WzvGyyeV1o4RTCYDnZ9VLLylJ9bneEaIs/7cjCEbipGGFlfIML3sfqnIvMAxIMZrvcl9
 qPV2k+KQ7q+aXavU5W+yLNn7QtXUB530Zlk/d2ETgzQ5FLYYnUDAaRl+8JUTjc0CNOTpCeik
 80TZcE6f8M76Xa6yU8VcNko94Ck7iB4vj70q76P/J7kt98hklrr85/3NU3oti3nrIHmHABEB
 AAHNKk5laWwgQXJtc3Ryb25nIDxuZWlsLmFybXN0cm9uZ0BsaW5hcm8ub3JnPsLAkQQTAQoA
 OwIbIwULCQgHAwUVCgkICwUWAgMBAAIeAQIXgBYhBInsPQWERiF0UPIoSBaat7Gkz/iuBQJk
 Q5wSAhkBAAoJEBaat7Gkz/iuyhMIANiD94qDtUTJRfEW6GwXmtKWwl/mvqQtaTtZID2dos04
 YqBbshiJbejgVJjy+HODcNUIKBB3PSLaln4ltdsV73SBcwUNdzebfKspAQunCM22Mn6FBIxQ
 GizsMLcP/0FX4en9NaKGfK6ZdKK6kN1GR9YffMJd2P08EO8mHowmSRe/ExAODhAs9W7XXExw
 UNCY4pVJyRPpEhv373vvff60bHxc1k/FF9WaPscMt7hlkbFLUs85kHtQAmr8pV5Hy9ezsSRa
 GzJmiVclkPc2BY592IGBXRDQ38urXeM4nfhhvqA50b/nAEXc6FzqgXqDkEIwR66/Gbp0t3+r
 yQzpKRyQif3OwE0ETVkGzwEIALyKDN/OGURaHBVzwjgYq+ZtifvekdrSNl8TIDH8g1xicBYp
 QTbPn6bbSZbdvfeQPNCcD4/EhXZuhQXMcoJsQQQnO4vwVULmPGgtGf8PVc7dxKOeta+qUh6+
 SRh3vIcAUFHDT3f/Zdspz+e2E0hPV2hiSvICLk11qO6cyJE13zeNFoeY3ggrKY+IzbFomIZY
 4yG6xI99NIPEVE9lNBXBKIlewIyVlkOaYvJWSV+p5gdJXOvScNN1epm5YHmf9aE2ZjnqZGoM
 Mtsyw18YoX9BqMFInxqYQQ3j/HpVgTSvmo5ea5qQDDUaCsaTf8UeDcwYOtgI8iL4oHcsGtUX
 oUk33HEAEQEAAcLAXwQYAQIACQUCTVkGzwIbDAAKCRAWmrexpM/4rrXiB/sGbkQ6itMrAIfn
 M7IbRuiSZS1unlySUVYu3SD6YBYnNi3G5EpbwfBNuT3H8//rVvtOFK4OD8cRYkxXRQmTvqa3
 3eDIHu/zr1HMKErm+2SD6PO9umRef8V82o2oaCLvf4WeIssFjwB0b6a12opuRP7yo3E3gTCS
 KmbUuLv1CtxKQF+fUV1cVaTPMyT25Od+RC1K+iOR0F54oUJvJeq7fUzbn/KdlhA8XPGzwGRy
 4zcsPWvwnXgfe5tk680fEKZVwOZKIEuJC3v+/yZpQzDvGYJvbyix0lHnrCzq43WefRHI5XTT
 QbM0WUIBIcGmq38+OgUsMYu4NzLu7uZFAcmp6h8g
Organization: Linaro
In-Reply-To: <20240828171722.1251587-2-swboyd@chromium.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 28/08/2024 19:17, Stephen Boyd wrote:
> Amit Pundir reports that audio and USB-C host mode stops working on
> sm8550 after commit 01a0a6cc8cfd ("clk: qcom: Park shared RCGs upon
> registration"). That's because the gcc_usb30_prim_master_clk_src clk is
> registered and clk_rcg2_shared_init() parks it on XO. Running USB at a
> slower speed than the link supports is effectively under-clocking the
> USB link and probably confusing the downstream USB devices.
> 
> We didn't need to change all the shared RCGs to park on XO at
> registration time in commit commit 01a0a6cc8cfd ("clk: qcom: Park shared
> RCGs upon registration"). Instead, we only needed to park the few
> display related clks on sc7180 to fix the issue.
> 
> Fix sm8550 (and likely other qcom SoCs) by skipping the parking part of
> clk_rcg2_shared_init(). Make that the default init clk_op for shared
> RCGs, but keep the part where we cache the config register as that's
> still necessary to figure out the true parent of the clk is. Introduce
> another set of clk_ops 'clk_rcg2_shared_init_park' that does what
> clk_rcg2_shared_init() was doing and use that for the display clks on
> sc7180. This fixes the sm8550 problem and limits the "park upon
> registration" logic to the display clks that need it.
> 
> Fixes: 01a0a6cc8cfd ("clk: qcom: Park shared RCGs upon registration")
> Cc: Konrad Dybcio <konradybcio@kernel.org>
> Cc: Bjorn Andersson <andersson@kernel.org>
> Cc: Taniya Das <quic_tdas@quicinc.com>
> Cc: Neil Armstrong <neil.armstrong@linaro.org>
> Reported-by: Amit Pundir <amit.pundir@linaro.org>
> Closes: https://lore.kernel.org/CAMi1Hd1KQBE4kKUdAn8E5FV+BiKzuv+8FoyWQrrTHPDoYTuhgA@mail.gmail.com
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>   drivers/clk/qcom/clk-rcg.h       |  1 +
>   drivers/clk/qcom/clk-rcg2.c      | 36 +++++++++++++++++++++++++++++---
>   drivers/clk/qcom/dispcc-sc7180.c |  8 +++----
>   3 files changed, 38 insertions(+), 7 deletions(-)
> 
<snip>

I've been testing this serie on SM8650, and with 01a0a6cc8cfd ("clk: qcom: Park shared RCGs upon registration")
it fixes an issue we have that triggers:
[   18.740736] ------------[ cut here ]------------
[   18.745837] ufs_phy_gdsc status stuck at 'off'
[   18.745929] WARNING: CPU: 1 PID: 197 at drivers/clk/qcom/gdsc.c:178 gdsc_toggle_logic+0x15c/0x164
...
after waking up UFS from runtime suspend.

So I suspect we'll need to figure out which SM8650 GCC shared clocks would need
to use clk_rcg2_shared_init_park_ops ?

We also had random boot crash when initializing the display very late on multiple platforms,
and so far "clk: qcom: Park shared RCGs upon registration" fixed that, but I also suppose Ill
need to reflect the changes done to dispcc-sc7180.c to dispcc-sm8650.c and others.

Neil
