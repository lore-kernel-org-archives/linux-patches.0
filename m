Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68BB72103
	for <patches@lists.linux.dev>; Sun, 22 May 2022 07:54:39 +0000 (UTC)
Received: by mail-lj1-f172.google.com with SMTP id e4so13345386ljb.13
        for <patches@lists.linux.dev>; Sun, 22 May 2022 00:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=zMBWfLQ7VImibIUBNFQNVRlWsCmwgRNDbMx0Ehor3dY=;
        b=srmBhmrTRJ7fZsq0Y4dU7NYMGkfv9n5fNKhtlUHcyUWJAuFeJ3G89DN1ab/uwLf6i4
         fLLCYIUTxs7sOgmmjRJxunlYC1iDF94NN4WY+DpJerD8jRkZ46p+oNf37cQ4k9hqR5BB
         OQPBJnfnN5RTaIELY5ty/XntFGZMF0K2ajkf+fL8dnB8fhlVrqga4UZNHch9l+20fGGL
         zfWIDeyW1QE6ISsjjddCPARId+rjKLLEoJoE/xpKc3uq7cPo/ODcJ9dBq/LWKLAzMLms
         Evc26zLELI5qwO/jc4+5c2EdYe7Klz25CIQ7l9rrFKBLN0gCa+UvqF6T00ESAjQo6Lh3
         guAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zMBWfLQ7VImibIUBNFQNVRlWsCmwgRNDbMx0Ehor3dY=;
        b=rxEe0+wiKWSbG82VXs0t2PWkyFFU/TOUaIFqbnk7nqfS+hmSWjSNX+URznS+6Dzvz3
         xJHrkfkGh55dwABlBf90QiU2zxCpJPY+srxh7QhBRyKzD+0Ev0SY1XqIkfsE7Ub9X3X+
         BwdrTkQ96qqpWULJjgEF6VZtWZutWDpBfNVo1PQvgzwm4JkKkozJ08EJzrSqd78Vf/LL
         prLh7XKnBnLIJRtv/8UTNyvxyymUpjKoLbo7OITL8+eKuKAbxOK2AvWi7A7ac5nIs5IU
         p8DtgFJ3qxk+2zmvirjKCQSjDwwkv0/+YLJo9+Vo+XwMaOqU0QajGeCMYh/RIo65mfai
         36/Q==
X-Gm-Message-State: AOAM53265obNf6jSa9bwBY9tGGzGT2Wqd0btyaWs7fuqvDfGGaWQLfXl
	CYbrp93iGEDRgPUJXxPMnIRbLQ==
X-Google-Smtp-Source: ABdhPJzYIUnOGXUEgsBP/qmKc1VkeCf2Mkm+8uXJ9Od4YU8W/4O+2cg7SkkcBV5kjin31GbZGZUKfw==
X-Received: by 2002:a2e:9350:0:b0:250:6a11:ff24 with SMTP id m16-20020a2e9350000000b002506a11ff24mr683753ljh.31.1653206077441;
        Sun, 22 May 2022 00:54:37 -0700 (PDT)
Received: from [192.168.0.17] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id q26-20020ac25a1a000000b0047255d210e0sm1357111lfn.15.2022.05.22.00.54.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 May 2022 00:54:37 -0700 (PDT)
Message-ID: <17456770-78fb-7c27-06e5-9102179239fb@linaro.org>
Date: Sun, 22 May 2022 09:54:35 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v4 2/5] dt-bindings: arm: qcom: Mention that Chromebooks
 use a different scheme
Content-Language: en-US
To: Douglas Anderson <dianders@chromium.org>, Rob Herring
 <robh+dt@kernel.org>, Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Matthias Kaehlcke <mka@chromium.org>,
 Alexandru M Stan <amstan@chromium.org>, patches@lists.linux.dev,
 linux-arm-msm@vger.kernel.org, Julius Werner <jwerner@chromium.org>,
 Andy Gross <agross@kernel.org>, Stephen Boyd <swboyd@chromium.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Rajendra Nayak <quic_rjendra@quicinc.com>,
 "Joseph S . Barrera III" <joebar@chromium.org>, devicetree@vger.kernel.org,
 Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org
References: <20220520143502.v4.1.I71e42c6174f1cec17da3024c9f73ba373263b9b6@changeid>
 <20220520143502.v4.2.I6418884d8bab6956c7016304f45adc7df808face@changeid>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220520143502.v4.2.I6418884d8bab6956c7016304f45adc7df808face@changeid>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 20/05/2022 23:38, Douglas Anderson wrote:
> The qcom.yaml bindings file has a whole description of what the
> top-level compatible should look like for Qualcomm devices. It doesn't
> match what Chromebooks do, so add a link to the Chromebook docs.
> 
> Reported-by: Stephen Boyd <swboyd@chromium.org>
> Signed-off-by: Douglas Anderson <dianders@chromium.org>
> Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
> ---


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof
