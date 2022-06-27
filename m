Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C16DB4C89;
	Mon, 27 Jun 2022 21:35:56 +0000 (UTC)
Received: by mail-io1-f47.google.com with SMTP id p128so11039216iof.1;
        Mon, 27 Jun 2022 14:35:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=J4+Oe1+Ks7fs9x2qE+51qC+TASVHbNeF5ScNp5f4ruk=;
        b=YyWwy9e86uOffS+R+A6u4Qc782QorKvP6RVc/IR3DrQziP0wRMAa3Lo+m00PLjcOVL
         AgDKheUM9uvDfyasEleovRO9S4BiJa4/W2cPrWfrtGQv7D7pmU1qEUTo9TAsS5c/ctsW
         hltKIHYjVfrLpHJ1rqCpRjWk4mwP4lYWuNh+k6qa510B132TTZzlHN9IUQfM3nC/T3az
         LAz29btMOA78ki8IXNc29WBDrQUxNi8ysY9Y95y7TmNbRp2NtvzMdnfD1VJgnD0etzrr
         gVMm5DwVve5Ia1np63CSfmE2DVTqejfiNxRPIQd9792tDmksQRnv3okEm4JSF8UeT6nu
         K8Kw==
X-Gm-Message-State: AJIora/qYP2oGTa86+0CQnzO2MWga2qLkWlkjsqOfTTbDEIGWhD+gwxz
	81ESfoAdX3sEOWvxQG7N3A==
X-Google-Smtp-Source: AGRyM1uNj7R49wFEo8bf5b1jSrlWjqwGl6lXAK8Bb4OHTyG3386pOh86YFZokhZsHfXb3M5MIOxHQA==
X-Received: by 2002:a05:6638:16ce:b0:332:44e:af98 with SMTP id g14-20020a05663816ce00b00332044eaf98mr8778280jat.112.1656365755798;
        Mon, 27 Jun 2022 14:35:55 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.253])
        by smtp.gmail.com with ESMTPSA id b13-20020a026f4d000000b00335b403c3b4sm5263466jae.48.2022.06.27.14.35.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 14:35:55 -0700 (PDT)
Received: (nullmailer pid 3004663 invoked by uid 1000);
	Mon, 27 Jun 2022 21:35:53 -0000
Date: Mon, 27 Jun 2022 15:35:53 -0600
From: Rob Herring <robh@kernel.org>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, Guenter Roeck <groeck@chromium.org>, Alexandru M Stan <amstan@chromium.org>, Matthias Kaehlcke <mka@chromium.org>, chrome-platform@lists.linux.dev, Benson Leung <bleung@chromium.org>, Lee Jones <lee.jones@linaro.org>, Craig Hesling <hesling@chromium.org>, devicetree@vger.kernel.org, patches@lists.linux.dev, Tom Hughes <tomhughes@chromium.org>, Tzung-Bi Shih <tzungbi@kernel.org>, linux-kernel@vger.kernel.org, Douglas Anderson <dianders@chromium.org>
Subject: Re: [PATCH v6 1/2] dt-bindings: cros-ec: Reorganize property
 availability
Message-ID: <20220627213553.GA3004606-robh@kernel.org>
References: <20220614195144.2794796-1-swboyd@chromium.org>
 <20220614195144.2794796-2-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614195144.2794796-2-swboyd@chromium.org>

On Tue, 14 Jun 2022 12:51:43 -0700, Stephen Boyd wrote:
> Various properties in the cros-ec binding only apply to different
> compatible strings. For example, the interrupts and reg property are
> required for all cros-ec devices except for the rpmsg version. Add some
> conditions to update the availability of properties so that they can't
> be used with compatibles that don't support them.
> 
> Cc: Rob Herring <robh@kernel.org>
> Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
> Cc: <devicetree@vger.kernel.org>
> Cc: <chrome-platform@lists.linux.dev>
> Cc: Guenter Roeck <groeck@chromium.org>
> Cc: Douglas Anderson <dianders@chromium.org>
> Cc: Craig Hesling <hesling@chromium.org>
> Cc: Tom Hughes <tomhughes@chromium.org>
> Cc: Alexandru M Stan <amstan@chromium.org>
> Cc: Tzung-Bi Shih <tzungbi@kernel.org>
> Cc: Matthias Kaehlcke <mka@chromium.org>
> Cc: Benson Leung <bleung@chromium.org>
> Cc: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  .../bindings/chrome/google,cros-ec-typec.yaml |  1 +
>  .../bindings/extcon/extcon-usbc-cros-ec.yaml  |  1 +
>  .../i2c/google,cros-ec-i2c-tunnel.yaml        |  1 +
>  .../bindings/mfd/google,cros-ec.yaml          | 29 +++++++++++++------
>  .../bindings/pwm/google,cros-ec-pwm.yaml      |  1 +
>  .../regulator/google,cros-ec-regulator.yaml   |  1 +
>  .../bindings/sound/google,cros-ec-codec.yaml  |  1 +
>  7 files changed, 26 insertions(+), 9 deletions(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
