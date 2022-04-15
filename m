Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 544C033D6
	for <patches@lists.linux.dev>; Fri, 15 Apr 2022 20:15:24 +0000 (UTC)
Received: by mail-qt1-f179.google.com with SMTP id cp8so3534278qtb.6
        for <patches@lists.linux.dev>; Fri, 15 Apr 2022 13:15:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=AVlaJ3+JyBV6uy3xWobzUMDIswV9zZwop66b5nDrPzo=;
        b=wSdp3PScNWgt43IiKr/hciI5s/OwStC/qks/OfNtWzDi5vqCFYT1i4FUnT/yyo45y7
         I2QnHgsoHk/9Fon0tTmegIm+Qk1aHed2P7V1tJgFrNo+gP8syAbBrI5XUouhDZ8LkI67
         LAzOTg08807jITxKhC2Ikja3M7B9BJd9GeGIelqA3Px1WYCFkdvhPdxPO3l2A3sdMgpR
         gY2kU4MnkUGQLd6uiuPhOkILltUAsVyS8zuvC9tjKksHf1+t0DX7rgHNUTSbza/xKkQ+
         mYTONn6lSMFITX2u4+9HlpWlOa3t88u1ui9j/fiiUtPhA2GtctviRH9RO0i1vweJNzyp
         60tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=AVlaJ3+JyBV6uy3xWobzUMDIswV9zZwop66b5nDrPzo=;
        b=pPnt5zaWh9MzgABAeQAN0FzWiQ/0oqkOPqsgURFsa6mJn/s1SGXNI1r993eiaaX33n
         RhMeS2S/DTUbJjkBRfcmBPteqR17CscMBkZi6CoBEOYn6Y8xRQw8iyD8mHzq7hBK4qP+
         GFpjbaTWM0Mq/2ZuZujVTKnI7pDNT3jIQwFIxRJlmdrHCqw/YCM9gxdu9FEQBswgdUEQ
         K+lV6TG8bA618k3Jmtxb7v710T/ZQKbTtvdKEeN7Pxn9JmsBWUZII70rqA1/wsejp3cx
         vhtjObbwW7egeplR2q8BFD/Gx5r6vGvArC8Gy4TvrcF1Tz2djRGb/NB+gP3y9U+hKw/d
         lUkw==
X-Gm-Message-State: AOAM530ZiLevTfRgbj0A0BbgfmryVA7VZ2XY+iKETmRqUiaC4npvh3gU
	9h76q1nKQTHArxY7Y/WSpNvFjg==
X-Google-Smtp-Source: ABdhPJyeAw9SUhcl+oEJ0iNchLSf6F+3IxtcHl+vy/czuU6D6/1++E3JAQBfCLpeJMs+r5OYN919yg==
X-Received: by 2002:a05:622a:1987:b0:2f1:df49:44fa with SMTP id u7-20020a05622a198700b002f1df4944famr588791qtc.125.1650053723200;
        Fri, 15 Apr 2022 13:15:23 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id y15-20020a05620a09cf00b0069c80404de6sm2168915qky.31.2022.04.15.13.15.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Apr 2022 13:15:22 -0700 (PDT)
Message-ID: <d32fc9f8-65cd-a30f-cdf2-f019bbe7cd69@linaro.org>
Date: Fri, 15 Apr 2022 15:15:21 -0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
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

What's the proper thing to do for properties that stop being
used?  Do we delete them, like this, or deprecate them somehow?
Old DTBs might define the values that are deleted here.

Shouldn't devicetree@vger.kernel.org
  be copied on this and
the other DTS patches?

					-Alex

> ---
> 
> I don't know who should apply this. Probably whoever takes the dtsi
> patches, Bjorn?, because otherwise dt_bindings_check will fail.
> 
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

