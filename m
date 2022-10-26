Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC992AD23;
	Wed, 26 Oct 2022 20:09:32 +0000 (UTC)
Received: by mail-oi1-f178.google.com with SMTP id l5so20172097oif.7;
        Wed, 26 Oct 2022 13:09:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dSvnZNFrY/t8hO+otMGCt6SYXbtg48WlbzdEKm92cOU=;
        b=WLy+23c3ZMd3328dzSJgwR1UUQG/Dt5s+KkRoTg2Pkc+kP78vxMOczcPzqAvg8rVwy
         +AEJAltDCVlc6KObr9/6DkUx11wT4zp1l24hwSDrwh4aY1RaZ2eN15AFGxNOtM8IPfxu
         XccmV6Lle3QWgsNH7Cr+O9fhqESLrgcGiqu1/zRtvTEY5O1GbTmYUellJ3Ze6uIbJlHb
         3VjLi1dZ3Jntjcfl8qO0FBNKXUbIiO2RTAVYuN204ODuAMpq8YytkDVTQe6cq45StJTY
         cek0jDCJ+3S++cFlUaeY4/XHQg/cDe4IH6rp1bBqhPtDA2Tm1v/xKpWDp/6CQtY5iEB7
         N5fw==
X-Gm-Message-State: ACrzQf38/Te43Q4wKBCMv4jJvyPcmfV551yMAybKMRT2Ik7fa8MyKK8N
	S17cDmqwgpfubpOfXFy8bQJiq9u68g==
X-Google-Smtp-Source: AMsMyM6ntSDBnaABx1qDKv9FZuOk6gTVL2XjZEhmCAZh+IkqC1YfWA1d8IotgbNQZ/dmGPF9Q1UpYg==
X-Received: by 2002:a05:6808:10d6:b0:355:526b:fc0d with SMTP id s22-20020a05680810d600b00355526bfc0dmr2896689ois.258.1666814971774;
        Wed, 26 Oct 2022 13:09:31 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id x35-20020a056870b42300b0012752d3212fsm3653703oap.53.2022.10.26.13.09.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 13:09:30 -0700 (PDT)
Received: (nullmailer pid 1103965 invoked by uid 1000);
	Wed, 26 Oct 2022 20:09:32 -0000
Date: Wed, 26 Oct 2022 15:09:32 -0500
From: Rob Herring <robh@kernel.org>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Lee Jones <lee.jones@linaro.org>, Douglas Anderson <dianders@chromium.org>, Alexandru M Stan <amstan@chromium.org>, Guenter Roeck <groeck@chromium.org>, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, patches@lists.linux.dev, Craig Hesling <hesling@chromium.org>, Tzung-Bi Shih <tzungbi@kernel.org>, Matthias Kaehlcke <mka@chromium.org>, Rob Herring <robh+dt@kernel.org>, Tom Hughes <tomhughes@chromium.org>, Benson Leung <bleung@chromium.org>, chrome-platform@lists.linux.dev
Subject: Re: [PATCH v7 2/2] dt-bindings: cros-ec: Add ChromeOS fingerprint
 binding
Message-ID: <166681497103.1103616.12500217142449534506.robh@kernel.org>
References: <20221026003641.2688765-1-swboyd@chromium.org>
 <20221026003641.2688765-3-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221026003641.2688765-3-swboyd@chromium.org>

On Tue, 25 Oct 2022 17:36:41 -0700, Stephen Boyd wrote:
> Add a binding to describe the fingerprint processor found on Chromebooks
> with a fingerprint sensor. Previously we've been describing this with
> the google,cros-ec-spi binding but it lacks gpio and regulator control
> used during firmware flashing.
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
>  .../bindings/mfd/google,cros-ec.yaml          | 67 +++++++++++++++++++
>  1 file changed, 67 insertions(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
