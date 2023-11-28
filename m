Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F071B14000
	for <patches@lists.linux.dev>; Tue, 28 Nov 2023 07:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kjZRNNvl"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-9fa2714e828so697421266b.1
        for <patches@lists.linux.dev>; Mon, 27 Nov 2023 23:46:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701157615; x=1701762415; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AUAz0H3G3l2pPKMEVI5IMXVW7cl/rE4q4fuQCBhjU/k=;
        b=kjZRNNvlNf+KqHTko0MZjPvcZUFLN6KNb0fug66wipKwoMWawjwICkpYxgnwohTGNs
         W+ILY6UQmQ0llD18zndsHsheJW3B72uojNhSliGTKd28CBdV74letC8UEVyk82hs+I/7
         0u4rkPZykCQFqt/C2uIj3MNtJsQVoBFdwmleef29lEIdC/kJxhtfIWVKH6ncIgi3MaBC
         OSnZFqC+yOf/oPUbJRyFNy+FzPZf2RNCAcsCfMbySR3Q/o8V4zZmdyZtSHouwx09WwnI
         LfeMWUids30canYoAYy2Y5zJNsbOEGyk2VlIR0J5GUo++iZcfrjysDpz8EfGVBc2Zl1v
         Yt0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701157615; x=1701762415;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AUAz0H3G3l2pPKMEVI5IMXVW7cl/rE4q4fuQCBhjU/k=;
        b=hn/ALnIaKOPchkBAr2JuD88lvhaWXeFYNYIdE0z7Oyvf1Y51rUaUhufZnX4+MRx67b
         GqHfV+QmwAhDcFhOyE366Uqxb3E0qBK2q6bPK4SO07oia+SikTLDRhsftkwWVbxGnkLT
         g9CfHuJUbngWoKVckqTaA04ZI0IvX0nuBdbowVLgWVJvIeDi9sBYHVIVv7PZlvcyyqdJ
         lWnzFEv1NFrOcI5Li2Mr1tP2vNYaTOq7AbxMGadvMLzHbxny6o3v9rEvEalGWWqPp1fn
         iOYhJCKOdBCpkr5sgyuE4D//TAvrMDIcOu3vMlJ3464Wnhu/4k3C//sRa8SBmY7tV+uI
         /IkQ==
X-Gm-Message-State: AOJu0Yxl9F70BotAwk9b1G5n1yp62xf8OF8+ywDsTR9VvCRhHh68t3Mv
	h72K8r0ABL2z5YL154MvhHykKg==
X-Google-Smtp-Source: AGHT+IHeV55drtGcGbTo0/PFi0iTdSzYCxnZ6gYwA664kVcCWSeVfC3kE53SmVsXopbsXabTsdwwog==
X-Received: by 2002:a17:906:18c:b0:9fe:354c:b754 with SMTP id 12-20020a170906018c00b009fe354cb754mr10614765ejb.53.1701157615158;
        Mon, 27 Nov 2023 23:46:55 -0800 (PST)
Received: from [192.168.1.20] ([178.197.223.109])
        by smtp.gmail.com with ESMTPSA id s8-20020a170906354800b00a0ca5672f7bsm3387014eja.123.2023.11.27.23.46.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Nov 2023 23:46:54 -0800 (PST)
Message-ID: <0ea669ad-9a33-40e0-b4df-aa2b2a1b92de@linaro.org>
Date: Tue, 28 Nov 2023 08:46:53 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dt-bindings: arm: qcom: Fix html link
Content-Language: en-US
To: Stephen Boyd <swboyd@chromium.org>, Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 devicetree@vger.kernel.org, Alexandre TORGUE <alexandre.torgue@foss.st.com>,
 Yanteng Si <siyanteng@loongson.cn>, Jonathan Corbet <corbet@lwn.net>,
 Bjorn Andersson <andersson@kernel.org>,
 Douglas Anderson <dianders@chromium.org>
References: <20231128002052.2520402-1-swboyd@chromium.org>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Autocrypt: addr=krzysztof.kozlowski@linaro.org; keydata=
 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
 D2GYIS41Kv4Isx2dEFh+/Q==
In-Reply-To: <20231128002052.2520402-1-swboyd@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 28/11/2023 01:20, Stephen Boyd wrote:
> This link got broken by commit e790a4ce5290 ("arm: docs: Move Arm
> documentation to Documentation/arch/") when the doc moved from arm/ to
> arch/arm/. Fix the link so that it can continue to be followed.
> 
> Fixes: e790a4ce5290 ("arm: docs: Move Arm documentation to Documentation/arch/")
> Cc: Alexandre TORGUE <alexandre.torgue@foss.st.com>
> Cc: Yanteng Si <siyanteng@loongson.cn>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Bjorn Andersson <andersson@kernel.org>
> Cc: Douglas Anderson <dianders@chromium.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  Documentation/devicetree/bindings/arm/qcom.yaml | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)


Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

This should go via Qcom, but you did not Cc msm mailing list.

Best regards,
Krzysztof

