Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35387C
	for <patches@lists.linux.dev>; Wed,  8 Jun 2022 12:44:12 +0000 (UTC)
Received: by mail-qv1-f43.google.com with SMTP id b11so14382094qvv.4
        for <patches@lists.linux.dev>; Wed, 08 Jun 2022 05:44:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=hb8MwiN3S2BS3ZcquesnHRXVBFHmUaMmZQ1CMIJfFHU=;
        b=AIs5Z6ldkgO0SaS7vh2G4FA8/1EMqUmbtNgCkOLckKSRkywfxBetJWIZK4n9PKNArz
         tTc9lLCoDy1OKbX1sobOqG/eHj/lb/xa+ZPQym6XcThss5W0t/gQBOk95VXdldxU04q9
         q/jljvBZruVu34MhdmesDcdVz6J+hWmrxRRTCC7nygjyDqepEyaHKWboXm1ESfN/JYb3
         fRJSxhSj6qKo6vyROKD1sPPy2PTBUx1ZrBBygjftm9T7aR1NLPxen0V80D2voyyYkqsN
         gZnxnnqNJLR7Vtc71KGyzGh1TeIveIM6O2109otuCNM1QjKPGviZUSkEtWAzbqPbvrMi
         Q8eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hb8MwiN3S2BS3ZcquesnHRXVBFHmUaMmZQ1CMIJfFHU=;
        b=Qc2vR3nqlHKJvN5F52HyNPJj9j0oB+lZUIsj1AI+SlmDD0DhNzkG3KD/0GjrMUQSR/
         L11kUpsaG3o4vtIBU45BqGmBZuy4cUYPnbsNibAp5zot8rnt2dPiygWpS3ZhsDMQ2Z2q
         GpHhlHaWoFgFc3QRLQKSd3NLiyn4HsK8ryACZuVQYdxl15AHuk+2JKl19Vqu+HhSGIbk
         Wwvd0hrDinm4H2gXWLKwXJzFKJrXygmF+Q6QcEMtniqKSo2ZNhlQxO2++n6xq1vLn91b
         uI2ra3wZ0FZbcj0CbvoOCX/QE6Rwo7jj2xwZ1Td4xZ1ySKUeTHBWeZB+2KJwH/zydED3
         +z1Q==
X-Gm-Message-State: AOAM532HRj4iEsO2J46A7pY34DEESoqCES6PDDayqBOyHaod/d7Zp8Qd
	+eTsfKjgnkD0/yUOxLQ6XpfOGw==
X-Google-Smtp-Source: ABdhPJyjNXeT1zRZttMPAb3qKmpV5xMSvQQ+B0pu2en6721A3xxw7dREAgxaFpdcIn7GAjs61tZmag==
X-Received: by 2002:a05:6214:4104:b0:431:d89a:66bd with SMTP id kc4-20020a056214410400b00431d89a66bdmr81931579qvb.42.1654692251470;
        Wed, 08 Jun 2022 05:44:11 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id ck9-20020a05622a230900b002f3e2435ee2sm14301132qtb.63.2022.06.08.05.44.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jun 2022 05:44:11 -0700 (PDT)
Message-ID: <5f4f48a5-03c5-f242-2095-6a4053f84de4@linaro.org>
Date: Wed, 8 Jun 2022 07:44:09 -0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] arm64: dts: qcom: sc7180: Remove ipa_fw_mem node on
 trogdor
Content-Language: en-US
To: Stephen Boyd <swboyd@chromium.org>, Andy Gross <agross@kernel.org>,
 Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 linux-arm-msm@vger.kernel.org, Matthias Kaehlcke <mka@chromium.org>
References: <20220517193307.3034602-1-swboyd@chromium.org>
From: Alex Elder <elder@linaro.org>
In-Reply-To: <20220517193307.3034602-1-swboyd@chromium.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/17/22 2:33 PM, Stephen Boyd wrote:
> We don't use this carveout on trogdor boards, and having it defined in
> the sc7180 SoC file causes an overlap message to be printed at boot.
> 
>   OF: reserved mem: OVERLAP DETECTED!
>   memory@86000000 (0x0000000086000000--0x000000008ec00000) overlaps with memory@8b700000 (0x000000008b700000--0x000000008b710000)
> 
> Delete the node in the trogdor dtsi file to fix the overlap problem and
> remove the error message.
> 
> Cc: Alex Elder <elder@linaro.org>
> Cc: Matthias Kaehlcke <mka@chromium.org>
> Fixes: 310b266655a3 ("arm64: dts: qcom: sc7180: define ipa_fw_mem node")
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>   arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
> index 732e1181af48..262224504921 100644
> --- a/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
> @@ -42,6 +42,7 @@ charger-crit {
>    */
>   
>   /delete-node/ &hyp_mem;
> +/delete-node/ &ipa_fw_mem;
>   /delete-node/ &xbl_mem;
>   /delete-node/ &aop_mem;
>   /delete-node/ &sec_apps_mem;
> 
> base-commit: 42226c989789d8da4af1de0c31070c96726d990c

This is on Trogdor, which as far as I know only runs Chrome OS,
which doesn't use the IPA firmware memory carveout.  The problem
reported comes from the definition of the mpss_mem reserved-memory
region in "sc7180-trogdor.dtsi", so deleting the "ipa_fw_mem" node
in that file sounds like the right fix.

Reviewed-by: Alex Elder <elder@linaro.org>
