Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25DA815098E
	for <patches@lists.linux.dev>; Wed, 21 Aug 2024 15:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724255048; cv=none; b=tfCs7v7IlAIcX/l+9hHPeg9/UQTiSuUg7L7ifPn+Pw+STdoPbvFK4VaDDGnN5tcG5DIXQcGTx3soPC2c/KiDsMEo9H1DvfrLyXll86/yNGk3fMx0fFuIX0eJElTGi8NpAcWS7c8oeGdiGl/rqc1vG+W38b7f3Qk1ngomXnL5Gbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724255048; c=relaxed/simple;
	bh=WVDc094V5VgmBhTZ4yJ53gMdHqdV+z83OelE/ZBW6i0=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=t1KgdkMUIUE2VAlG2Ci2+bASC1At+puvh4qbIG3gNIjBb5PZ2ac69gdMDiGmubZP2lnoMg9JUafw/4xQqWLPGpkZc09HGjGoe4kEDlq3D8GmA+HV8hK7WqANbb2NeAcDKwAm+Cid+yxOVYwbOADj+GcjrZljZE0vqXyPgiji2oY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=axywt85e; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="axywt85e"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-428243f928fso75232015e9.0
        for <patches@lists.linux.dev>; Wed, 21 Aug 2024 08:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1724255045; x=1724859845; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+LGqD1Rl0TDjEjqitQZboKy5wEBm7w43+UzWNh+se/Q=;
        b=axywt85eNuXrXC14wTS71MLaqL0yk1zdEE48vHObKEmgb4KPRhf5uXmhWwHkeQ1cFc
         Ire9Cig7maag4fcvsGcikdFzKkFc3yLDeapr1hhYALQ6WggRXQY2mIJ+QjkP2cHgDBme
         MkZxPd/QvW7xat3G1bb+FEqyff4ln6tYnJtypkn2KHQgeP1bziUO4prrptJ4L7F5+o+9
         i4I86Q1OLyH+0zxnpaiqLdEmyQPMPLXNoV6V10/h5aMx9Ho2e6fJnAuqP9pB3Kz6qWoe
         4EJ873SjfIbbIhB2Re+EBbmxgM/hWMUj7RgKAdEmX2qDEYVl6dWtj6sMmir1jpjBpGDD
         818w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724255045; x=1724859845;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+LGqD1Rl0TDjEjqitQZboKy5wEBm7w43+UzWNh+se/Q=;
        b=rBo7Fr0iTbzJRnyYYR1y63f9jhzV03APFWIA0ESgaXQ+1yW4VF5Sv7k+b+e/oDf7pr
         kM0X1bb6VbzSxxZ2tvraX4+QMxxV5pMWXAYgvex4mgIz8clCnyHqFooZIPVmQnc4oylh
         yhhdLQJ+KHdsa78jtIkk2MMvpuorKdpg6GF1O9HXeiltOM6iQtpCFTon64iq6TEGbZBI
         Jw3sH7H71mokDLrJ7c1wJ2ZV4ovkDYiGdoWZJUgRZ1H1XqoKWY3pwW5QyGwEiCC9unxQ
         F+m7Ps2QzXqa1kSJhP/pZir3WJAqeVIt9yH9grFWpCzeDXDo1rZbaKOcWHaGg0BIQvYB
         VLCA==
X-Forwarded-Encrypted: i=1; AJvYcCWQAP9zbRiPDKthC9/ockq5CDkiKScVJZ17HpjGVvvy+5NFK/uBEjVE9gcPniVRJt1JGZj+dZDP@lists.linux.dev
X-Gm-Message-State: AOJu0YwMH8sTRszaopeCDRe4jfx/0H887WV1+gx0nXUf4zsvlRdWQ891
	Q7RYtya3izQbpUhNhbg0UjMPH4p9+czCKZMdJRVAVu7seXUhK9GotUTJ9XKCQ2A=
X-Google-Smtp-Source: AGHT+IF8q678X99SovUy4vRlqxU0N0rv7K01kOPh7R6EhqrUSplZZE2HWWkRDXdvhNXiWeXe9Z28Yw==
X-Received: by 2002:a05:600c:4689:b0:428:e820:37b6 with SMTP id 5b1f17b1804b1-42abd255065mr24867395e9.31.1724255044880;
        Wed, 21 Aug 2024 08:44:04 -0700 (PDT)
Received: from ?IPV6:2001:861:d40:6fb0:ac85:2805:6b0e:5197? ([2001:861:d40:6fb0:ac85:2805:6b0e:5197])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42abef97f7asm29182985e9.22.2024.08.21.08.44.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Aug 2024 08:44:04 -0700 (PDT)
Message-ID: <d03d5425-bd7c-4c20-a54e-5708ffd059e0@linaro.org>
Date: Wed, 21 Aug 2024 17:44:00 +0200
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
To: Stephen Boyd <swboyd@chromium.org>,
 Konrad Dybcio <konrad.dybcio@linaro.org>,
 Bjorn Andersson <andersson@kernel.org>, Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 patches@lists.linux.dev, linux-clk@vger.kernel.org,
 Amit Pundir <amit.pundir@linaro.org>, Taniya Das <quic_tdas@quicinc.com>
References: <20240819233628.2074654-1-swboyd@chromium.org>
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
In-Reply-To: <20240819233628.2074654-1-swboyd@chromium.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 20/08/2024 01:36, Stephen Boyd wrote:
> Amit Pundir reported[1] that a recent commit 01a0a6cc8cfd ("clk: qcom:
> Park shared RCGs upon registration") broke USB and audio on sm8550-hdk.
> These two patches fix the issue by skipping the parking bit of the
> shared RCGs for devices that can't run so slow.
> 
> [1] https://lore.kernel.org/CAMi1Hd1KQBE4kKUdAn8E5FV+BiKzuv+8FoyWQrrTHPDoYTuhgA@mail.gmail.com/
> 
> Stephen Boyd (2):
>    clk: qcom: gcc-sm8550: Don't use parking clk_ops for QUPs
>    clk: qcom: gcc-sm8550: Don't park the USB RCG at registration time
> 
>   drivers/clk/qcom/clk-rcg.h    |  1 +
>   drivers/clk/qcom/clk-rcg2.c   | 30 +++++++++++++++++++
>   drivers/clk/qcom/gcc-sm8550.c | 54 +++++++++++++++++------------------
>   3 files changed, 58 insertions(+), 27 deletions(-)
> 
> 
> base-commit: 8400291e289ee6b2bf9779ff1c83a291501f017b

I'm pretty sure sm8450 & sm8650 (and probably other SoCs) could be also affected, could you check ?

Neil
