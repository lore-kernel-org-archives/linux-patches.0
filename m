Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E7D1843
	for <patches@lists.linux.dev>; Mon, 16 May 2022 22:16:11 +0000 (UTC)
Received: by mail-qk1-f181.google.com with SMTP id a76so13337742qkg.12
        for <patches@lists.linux.dev>; Mon, 16 May 2022 15:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=EDpKgH3/WPZM/363RddYVU5cX26QwXiUYlUKXjvLI+w=;
        b=rr0Lzlh4RQe5+hFaBPjqPfkCkryQUmL7dQa++VAGdy52rMii+uf5cEQYN0/J/o1IBf
         uR4WcAfuUSb+weiCYWwpFa9EXBjFsvyC81WKH1B6mUA5Qzt666Yf7WWD+0r2SOXltpcV
         vUL6IUV/O21kvSj5iTVHZ6ivPLn6NrIyG3S4zB2HCc3fbp/3NKE85/Zir1Qn8NjQSBs5
         Gk4FCwBor0V8fIPZ0q9GztHXRakIuhk8qYv0TXQjtVS7TBVlG4obJhZjI5EiRWhUZ2U8
         jYX21mOkrSrXPHuDr1mRj4m9lLMhCMAiYONHrx93BZriczvyMaHaSnLEuPRceClGuftI
         SFnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=EDpKgH3/WPZM/363RddYVU5cX26QwXiUYlUKXjvLI+w=;
        b=4nfDc7oqEgTd+YT5XTn4evjK7E72q0V8JUdafvdonqms/GjpuAAKDgSl6ITU1v9DDX
         CvuTiLc31RSFnH+hr1pjDKh3rOdDTJ64k/BVyMVxi8RLOI5AJdIfKZwOe51OdPIe2h9N
         wgRIsioWpSjH5Ut6jxM10fzC6GpVoyP0FzKKfUjdArSg5sW87lolqN2M3CLsHgjNMRan
         M1sC1MbcWJP5jyWhFV5fmehln9R/nhgEo4WrGj+zafriGgRkX3j8en3IENSIVvHONDuK
         eHlOKlpIbMcrEdqmNGDJOw75R35V8QvA5pOuarU0Ze6y6/ZaD/1EBHQ9avwvpQ+bDDJh
         +uBA==
X-Gm-Message-State: AOAM530Ygpfg1dhs9jFqG1UcIyRhNjc+imQdgzZ9m9K7DS/fH07TgyFH
	lx+6Yw3NSQnjIuoGjipirkQSuA==
X-Google-Smtp-Source: ABdhPJxG7XD4iDKgNS58sELNuzjPJk3namOwny1F4tvwGJp483qDx5nUXnvRn7ROwnWdZjAvvLQlyQ==
X-Received: by 2002:a37:b986:0:b0:69f:ed3a:55cc with SMTP id j128-20020a37b986000000b0069fed3a55ccmr13892091qkf.558.1652739370681;
        Mon, 16 May 2022 15:16:10 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id 2-20020ac85902000000b002f39b99f6b3sm7091530qty.77.2022.05.16.15.16.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 May 2022 15:16:10 -0700 (PDT)
Message-ID: <a17603a8-f273-0dde-8e84-3c0616ff04aa@linaro.org>
Date: Mon, 16 May 2022 17:16:08 -0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 5/2] dt-bindings: interconnect: Remove sc7180/sdx55 ipa
 compatibles
Content-Language: en-US
To: Stephen Boyd <swboyd@chromium.org>, Georgi Djakov <djakov@kernel.org>,
 Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 linux-arm-msm@vger.kernel.org, linux-pm@vger.kernel.org,
 Doug Anderson <dianders@chromium.org>, Taniya Das <quic_tdas@quicinc.com>,
 Mike Tipton <quic_mdtipton@quicinc.com>
References: <20220412220033.1273607-1-swboyd@chromium.org>
 <20220415005828.1980055-1-swboyd@chromium.org>
 <20220415005828.1980055-3-swboyd@chromium.org>
From: Alex Elder <elder@linaro.org>
In-Reply-To: <20220415005828.1980055-3-swboyd@chromium.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/14/22 7:58 PM, Stephen Boyd wrote:
> These interconnects are modeled as clks, not interconnects, therefore
> remove the compatibles from the binding as they're unused.
> 
> Cc: Alex Elder <elder@linaro.org>
> Cc: Taniya Das <quic_tdas@quicinc.com>
> Cc: Mike Tipton <quic_mdtipton@quicinc.com>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
> 
> I don't know who should apply this. Probably whoever takes the dtsi
> patches, Bjorn?, because otherwise dt_bindings_check will fail.

I don't see this commit applied anywhere, though I
might have missed it.  Is this for Bjorn, or Georgi,
or someone else?

					-Alex

>   Documentation/devicetree/bindings/interconnect/qcom,rpmh.yaml | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/interconnect/qcom,rpmh.yaml b/Documentation/devicetree/bindings/interconnect/qcom,rpmh.yaml
> index 5a911be0c2ea..ab859150c7f7 100644
> --- a/Documentation/devicetree/bindings/interconnect/qcom,rpmh.yaml
> +++ b/Documentation/devicetree/bindings/interconnect/qcom,rpmh.yaml
> @@ -31,7 +31,6 @@ properties:
>         - qcom,sc7180-config-noc
>         - qcom,sc7180-dc-noc
>         - qcom,sc7180-gem-noc
> -      - qcom,sc7180-ipa-virt
>         - qcom,sc7180-mc-virt
>         - qcom,sc7180-mmss-noc
>         - qcom,sc7180-npu-noc
> @@ -68,7 +67,6 @@ properties:
>         - qcom,sdm845-mem-noc
>         - qcom,sdm845-mmss-noc
>         - qcom,sdm845-system-noc
> -      - qcom,sdx55-ipa-virt
>         - qcom,sdx55-mc-virt
>         - qcom,sdx55-mem-noc
>         - qcom,sdx55-system-noc

