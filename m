Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 254AB10E0;
	Mon, 16 May 2022 15:20:20 +0000 (UTC)
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-edf9ddb312so20500027fac.8;
        Mon, 16 May 2022 08:20:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=W9tLM70Tw8Uss/GVBVK6u77pI6LLmHXNFXi2ajwOZKg=;
        b=LaqqWUp27BhFiPTRqZjEXOxHLswU7P6rNVYxlpo/wbiCDNp6ZqCgymtyL0RGZjJNyT
         YHZdRbqqvdP0i3SRgQDdHEEUAxW8GOR2DMrAvElPYVC/Ay9ri45OUPgzfbucj+hSPhcS
         GigmUrniHKEIC9HH0HAAAT+gseHEbfHIZZs4j13l/Tt6kJExfrB/2ZqANrHpzLDq5aBl
         g0T5W6WcYMV8aktYFZy/DHCFOPBjNBdWWxzfdpVr9wXHahg7BpVx4PgnfVS6UjNWQUsy
         HoL4MFTKl9ckLH94WQYNBQRkiLiUTxiCqMcOx6wdHztUWC9oJoosRPbLDtqrB15h3uM2
         BliA==
X-Gm-Message-State: AOAM533TyUKA/NTrLeKvVhy4e3Al3iYo3p4VqD6vCx3M7v+ZQclDwNCP
	IzJK2nFIE/cmhV6ZlXbEww==
X-Google-Smtp-Source: ABdhPJwWZu/rR2p0J2pBoKL+4f8o2cPL9O9K6Q6XK2gBUPSYwyTDQrNXhiS2kWe+LpFOkwSgldwWJQ==
X-Received: by 2002:a05:6870:9a2a:b0:e6:2cdd:6124 with SMTP id fo42-20020a0568709a2a00b000e62cdd6124mr15314808oab.3.1652714419789;
        Mon, 16 May 2022 08:20:19 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id l9-20020a4a8409000000b0035eb4e5a6b8sm4149620oog.14.2022.05.16.08.20.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 08:20:19 -0700 (PDT)
Received: (nullmailer pid 2666522 invoked by uid 1000);
	Mon, 16 May 2022 15:20:18 -0000
Date: Mon, 16 May 2022 10:20:18 -0500
From: Rob Herring <robh@kernel.org>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Guenter Roeck <groeck@chromium.org>, devicetree@vger.kernel.org, Douglas Anderson <dianders@chromium.org>, Lee Jones <lee.jones@linaro.org>, Rob Herring <robh+dt@kernel.org>, Tom Hughes <tomhughes@chromium.org>, Alexandru M Stan <amstan@chromium.org>, patches@lists.linux.dev, Tzung-Bi Shih <tzungbi@kernel.org>, linux-kernel@vger.kernel.org, Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, Craig Hesling <hesling@chromium.org>, Benson Leung <bleung@chromium.org>, chrome-platform@lists.linux.dev, Matthias Kaehlcke <mka@chromium.org>
Subject: Re: [PATCH v5 2/3] dt-bindings: cros-ec: Reorganize property
 availability
Message-ID: <20220516152018.GA2666468-robh@kernel.org>
References: <20220512013921.164637-1-swboyd@chromium.org>
 <20220512013921.164637-3-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220512013921.164637-3-swboyd@chromium.org>

On Wed, 11 May 2022 18:39:20 -0700, Stephen Boyd wrote:
> Various properties in the cros-ec binding only apply to different
> compatible strings. For example, the interrupts and reg property are
> required for all cros-ec devices except for the rpmsg version. Add some
> conditions to update the availability of properties so that they can't
> be used with compatibles that don't support them.
> 
> Cc: Rob Herring <robh+dt@kernel.org>
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
>  .../bindings/mfd/google,cros-ec.yaml          | 39 +++++++++++++------
>  1 file changed, 27 insertions(+), 12 deletions(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
