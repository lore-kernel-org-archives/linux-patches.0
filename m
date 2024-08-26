Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF12145B0F
	for <patches@lists.linux.dev>; Mon, 26 Aug 2024 09:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724666129; cv=none; b=TXTY0u0T5SMUTgyMou0WTdBTF1k6XIBk5rzP8LV6ZE87som496JiRAVqPrPAMKFGDmOgxxvxgjkTbXYGlAh0B2qBK/uz9QH6oHBnNYJ3KU24y4xeVRNQrXkztOx0wVsXKnuWKubBjtz/McLfFrTR48r+sa3a+otNO3yYJxrvncI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724666129; c=relaxed/simple;
	bh=5j3I46k6ptwrT5KLfjuvRJi02PLBHAdj9fxSvDP75Io=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=iQK3Armv4I3BaCjycfc3UJmRcypfwTOpraVfnVaIr5L1JSc6oRnEW7kR8HLnZOx8UzIzqod9v1Wb83Wz0mTLMxvQsdr0pa1rVupz2lUyruRJtg3zdUNYIX35/3DaoNripm1hiI7/1naoLvpu3x9loI+YxkVDIigv/Ua7Z6hiK8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=q8ewLP0q; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="q8ewLP0q"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3719753d365so2177159f8f.2
        for <patches@lists.linux.dev>; Mon, 26 Aug 2024 02:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1724666126; x=1725270926; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VK7ceKk9+QuKgFb+l7lbOmbbJTuc/8ZMI5BdFql0QbQ=;
        b=q8ewLP0qFnNScmbXrfiWHqnYR4F10Q5UmMh/Dk7MwuP4hqELXYD2HWgRCFlErv7KhD
         L/0oP7uzMvCJpP1XGnKbaRQeG4duRr9xtah97RVagMmDl9hF/C5jc4eN0snCxKq5Zvjx
         OSeUn/L3A6rgoVOwjCvcJ/lopUoZ4RSlb3O67BHZPGKOj6CxFd+8yU/Uku7eHWoTmiKh
         AXxUKQiSh5nBuRWY8nl1zSf/IhAc7uN5RUNFiRcFb/Bc6N16iJbwiCpZYxDmlsywqr3I
         XB/9NxXmVIs2n6lVokO1pWL5Y05YToBVpb10qRaHhEp65ZdFulxOXlZ2JD3vly5j6nH5
         LW8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724666126; x=1725270926;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VK7ceKk9+QuKgFb+l7lbOmbbJTuc/8ZMI5BdFql0QbQ=;
        b=kyv1rEVJfCYFpm5IJQ6vZdAvoJ3guUSshHZovPkR2mX7kyid0JCJPVt6HWMP2XQEBD
         LFRr/MyTsQm9flfJd9L4/CmgIy2fA9up3qlOY88GYr89J/Y1FInK6lseoNqLkcqRA8rG
         5Sr0OPkZAHywpPtEYbOmZNF9J5F/hDCpVchB30N8gXocXMUpxw8xGC4Ef5RMyYSR8Bnw
         5+nalZhuX2Tsur4PmtMT88hY2OrY/sQ7/O/A1PH7Ri7Ir9TLDvZappEOpd1CsQtYFXfP
         fLJg7+nB3f54Cs1GwhGvFntybhD9mroewVCa/rSNG9bvyG9VC8VGCtEJwOGWMYgG7aG5
         kjYg==
X-Forwarded-Encrypted: i=1; AJvYcCVFK9k7+Rnwe4HWQt0D2bMdxY0m9TjmjP5QKAb+qH9e2K/4iVYwWffRzWnP/uMGzx1sbQhhJBuA@lists.linux.dev
X-Gm-Message-State: AOJu0Yy3m+fxkwDZ+XDnub9YjtUX9XTK/upgNlux5373lwcPU4HcVAnR
	2OSPoYr8tXdEEpfs8F84oeaY8flM5R5YJoZG+oCvWIZj8saErj1uqeorN15WuDk=
X-Google-Smtp-Source: AGHT+IFreUR3/E7uHdXTquMSkJpFO/dW71VumcJUcTwCvc9tqzIioKTR8C4yLeHdVUzlxat4VoCD7g==
X-Received: by 2002:adf:a209:0:b0:367:8f29:f7b6 with SMTP id ffacd0b85a97d-37311919579mr5512128f8f.51.1724666125502;
        Mon, 26 Aug 2024 02:55:25 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:982:cbb0:7355:c4a4:da66:6d71? ([2a01:e0a:982:cbb0:7355:c4a4:da66:6d71])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42ac51860e8sm147572485e9.48.2024.08.26.02.55.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Aug 2024 02:55:25 -0700 (PDT)
Message-ID: <c6fa1da6-c244-4fe8-9ef1-dd2c9b76f2f9@linaro.org>
Date: Mon, 26 Aug 2024 11:55:24 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: neil.armstrong@linaro.org
Reply-To: neil.armstrong@linaro.org
Subject: Re: [PATCH 0/2] clk: qcom: gcc-sm8550: Fix shared clk parking
 breakage
To: Stephen Boyd <swboyd@chromium.org>, Bjorn Andersson
 <andersson@kernel.org>, Konrad Dybcio <konrad.dybcio@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 patches@lists.linux.dev, linux-clk@vger.kernel.org,
 Amit Pundir <amit.pundir@linaro.org>, Taniya Das <quic_tdas@quicinc.com>
References: <20240819233628.2074654-1-swboyd@chromium.org>
 <d03d5425-bd7c-4c20-a54e-5708ffd059e0@linaro.org>
 <CAE-0n52=kQzEx76D5AmZfui_X0jqejQ+ENz+VQunY_ovph65Hw@mail.gmail.com>
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
In-Reply-To: <CAE-0n52=kQzEx76D5AmZfui_X0jqejQ+ENz+VQunY_ovph65Hw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 23/08/2024 22:33, Stephen Boyd wrote:
> Quoting neil.armstrong@linaro.org (2024-08-21 08:44:00)
>> Hi,
>>
>> On 20/08/2024 01:36, Stephen Boyd wrote:
>>> Amit Pundir reported[1] that a recent commit 01a0a6cc8cfd ("clk: qcom:
>>> Park shared RCGs upon registration") broke USB and audio on sm8550-hdk.
>>> These two patches fix the issue by skipping the parking bit of the
>>> shared RCGs for devices that can't run so slow.
>>>
>>> [1] https://lore.kernel.org/CAMi1Hd1KQBE4kKUdAn8E5FV+BiKzuv+8FoyWQrrTHPDoYTuhgA@mail.gmail.com/
>>>
>>> Stephen Boyd (2):
>>>     clk: qcom: gcc-sm8550: Don't use parking clk_ops for QUPs
>>>     clk: qcom: gcc-sm8550: Don't park the USB RCG at registration time
>>>
>>>    drivers/clk/qcom/clk-rcg.h    |  1 +
>>>    drivers/clk/qcom/clk-rcg2.c   | 30 +++++++++++++++++++
>>>    drivers/clk/qcom/gcc-sm8550.c | 54 +++++++++++++++++------------------
>>>    3 files changed, 58 insertions(+), 27 deletions(-)
>>>
>>>
>>> base-commit: 8400291e289ee6b2bf9779ff1c83a291501f017b
>>
>> I'm pretty sure sm8450 & sm8650 (and probably other SoCs) could be also affected, could you check ?
> 
> Does someone have the hardware to test? It looks like sm8450 isn't using
> the shared ops, but sm8650 is, likely incorrectly.

I can't reproduce the uart issue on 8650, I'll try moving some dependencies (CLK, ICC, ..) as modules.

Bryan reproduced it on X1, and he posted a patch.

Neil
