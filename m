Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12701F61C
	for <patches@lists.linux.dev>; Thu, 29 Aug 2024 08:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724920747; cv=none; b=W2AxTYBMKqDmbASLznpjPuYKZb4ekkDAlNkbcnSAFOHErf5y9RpQlZbLdXJHjyq0Drm0QgTx4/Z1NKCCeAn5MREZ2bpmGGCqiTqU8HU+dmny8XJO+9jXtNKt405WxX21wXJVFEUGSeT6B6kUbRZ1/o+3o7IWVekpWmuZo5I8sW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724920747; c=relaxed/simple;
	bh=jblHVtPlSRyRcTc1sapQUz8zWsXCqzPBsWFiHN5Cij0=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=XSD8sChVXGLPBlLmUNK9I1fsh31JundQUiyrsKc9449doqNSSxhJlR+rCE6+rWjvNZlhckzXPVqvr7X7lclyRxs9CPnC/yrTW6daelQkmMsgvH5QzV4xWwRU99zgHoRqUR7r1z3VRuTScAcjxkVOx8EaJ7gDmjpM9NW30GNI4rQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=LquvXUiK; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LquvXUiK"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-371b97cfd6fso221972f8f.2
        for <patches@lists.linux.dev>; Thu, 29 Aug 2024 01:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1724920744; x=1725525544; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CO2qDrsMP+yzCovNk6lA4Pu0Mr9YSLT3he5TsfVnVjU=;
        b=LquvXUiKRmWjytRTJaHH9mohdvQkDqH5IkcZifB1zKlCvVXs3BvQINQD3Q1CaA/c21
         lahHW/CTuuBEFAiFsoe3QTYLvAx7KlsztBJffPVlCt0KNrB+DUIb0ezUi8Xz1JiTLhge
         TMQQWNv3Tb+6vjq0KX606dsKX5gA2Ok3kKEAszxMndGRklc6rgAR6xTwulvvZVwLidcJ
         GeMlal32rg53I2jffPzbmuDBWPgbVNaA4lydhWDwu8890XOF36IHpOAe33NyOECiNp12
         AEgzwumPd/lnfN9ju+rjY/x6hQui2JsrziIR17a2RWOOGr3BQgWMFjTLhnwdkWOhvjaX
         8ckg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724920744; x=1725525544;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CO2qDrsMP+yzCovNk6lA4Pu0Mr9YSLT3he5TsfVnVjU=;
        b=bsGL0oVDolLoGWd5pZuN/ad9L5kF8eaoNRQ330jc2BIlf9CzD1wMjvRMRC2FH1B5Bg
         V4BeyyR9RZTSi8rV/B/ft3BgDLpm3UF97iQG4QQZshf2+Qal6qj26q5ywazsoJTpAPNK
         9CtMVJytDttWw6bBTnvNMNZwYJuTcWEjrPwtuv4ZR0xigmb+4d+qaibVYsrKxV/c5Xhl
         MD0mkSFvrCHOoF0OqNaVbIRuHRHnvhaZU7ggul3Za4x457E+hMuyUz9h23dvxQ53w5TY
         N8zzS0zGsXFCEr79NmSopoLvuSJ8xgxaAgxXjtBXT9jbViOVD9m3t97/6SaiiNZy3aRS
         38oQ==
X-Forwarded-Encrypted: i=1; AJvYcCWqbGEmpLsLYHKA8C5dQEjt9hFnRQ7iVDucCWwYrTZhAeNg37yEpc49LSaEu/PDFQBFeM8+2T77@lists.linux.dev
X-Gm-Message-State: AOJu0YyKRBaKufxX+s0nZ76WFLFehuHuvGa//5UCnORgZQN7xvWkBcAM
	R6Sh743lunzdnttapjiLb9StiSmCpDRYux4KfOeJ6wEzZFhP+5fssLkfE8r295I=
X-Google-Smtp-Source: AGHT+IHJ6YMQtL6bF1ZYAujgdoTC0F57VZqnjoZTloLOVyRjTt1XAYtUUXQV0H+lzvpfFlFKW4qPmA==
X-Received: by 2002:a5d:4e83:0:b0:371:8ced:52e2 with SMTP id ffacd0b85a97d-3749b5882a6mr1297289f8f.52.1724920743786;
        Thu, 29 Aug 2024 01:39:03 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:982:cbb0:12f5:c9c:a0e1:6915? ([2a01:e0a:982:cbb0:12f5:c9c:a0e1:6915])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3749ee9ba83sm826888f8f.54.2024.08.29.01.39.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Aug 2024 01:39:03 -0700 (PDT)
Message-ID: <e93b223b-5988-422f-888c-b648ad6e0ea4@linaro.org>
Date: Thu, 29 Aug 2024 10:39:02 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Neil Armstrong <neil.armstrong@linaro.org>
Reply-To: neil.armstrong@linaro.org
Subject: Re: [PATCH v2 2/2] clk: qcom: gcc-sm8550: Don't use shared clk_ops
 for QUPs
To: Stephen Boyd <sboyd@kernel.org>, Bjorn Andersson <andersson@kernel.org>,
 Konrad Dybcio <konradybcio@kernel.org>, Stephen Boyd <swboyd@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 patches@lists.linux.dev, linux-clk@vger.kernel.org,
 Taniya Das <quic_tdas@quicinc.com>, Amit Pundir <amit.pundir@linaro.org>
References: <20240827231237.1014813-1-swboyd@chromium.org>
 <20240827231237.1014813-3-swboyd@chromium.org>
 <1684855f-5901-459a-beb7-2569003b30ac@linaro.org>
 <00adff607d757702fa673942ed60c354.sboyd@kernel.org>
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
In-Reply-To: <00adff607d757702fa673942ed60c354.sboyd@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 28/08/2024 19:13, Stephen Boyd wrote:
> Quoting Neil Armstrong (2024-08-28 05:22:37)
>> On 28/08/2024 01:12, Stephen Boyd wrote:
>>> diff --git a/drivers/clk/qcom/gcc-sm8550.c b/drivers/clk/qcom/gcc-sm8550.c
>>> index 7944ddb4b47d..0244a05866b8 100644
>>> --- a/drivers/clk/qcom/gcc-sm8550.c
>>> +++ b/drivers/clk/qcom/gcc-sm8550.c
>>> @@ -992,7 +992,7 @@ static struct clk_init_data gcc_qupv3_wrap2_s7_clk_src_init = {
>>>        .parent_data = gcc_parent_data_0,
>>>        .num_parents = ARRAY_SIZE(gcc_parent_data_0),
>>>        .flags = CLK_SET_RATE_PARENT,
>>> -     .ops = &clk_rcg2_shared_ops,
>>> +     .ops = &clk_rcg2_ops,
>>>    };
>>>    
>>>    static struct clk_rcg2 gcc_qupv3_wrap2_s7_clk_src = {
>>
>> I think you missed gcc_qupv3_wrap2_s7_clk_src
> 
> Nope. The diff header shows it is in gcc_qupv3_wrap2_s7_clk_src_init
> which is assigned to the gcc_qupv3_wrap2_s7_clk_src clk's hw.init
> pointer.
> 
> 	.clkr.hw.init = &gcc_qupv3_wrap2_s7_clk_src_init,

Ack

Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>

Even if I wasn't able to reproduce the original issue:
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-QRD
