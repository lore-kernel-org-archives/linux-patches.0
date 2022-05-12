Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595B233CD
	for <patches@lists.linux.dev>; Thu, 12 May 2022 15:20:36 +0000 (UTC)
Received: by mail-ej1-f48.google.com with SMTP id ks9so10951000ejb.2
        for <patches@lists.linux.dev>; Thu, 12 May 2022 08:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LSVMi3sIF030EU435n7TSz+80CX0XXIOGq6LT9c1iJs=;
        b=R93hpC55nIrmmOwCv9ozgHF6+ZEnHvkBliQAm+PzjJ4fRxcR9juR4MHn1tg0IZlYnP
         CnQQh8Snsq7U3+rULyhqoiz6ewotSFb6k/70frKD9FgAmPUEXNDgHCmE/oxf4DpP8f5D
         IBXQ/CfEcH2+c2yK7DrvTsPyCchAC3lE46gfrRIGfS2p659nmV/QAxG+5p3JnZ7EyOSR
         HqmpNvG18HLlgazoMmkwGhjOcarZiv4QymzOCYa/SFtOgOSLbYJGOsd8/MfvIjM9rJ+W
         L2ds0d3chFwZnUa4ex//ufhmLgYweHJ3dVMPse4gNyK1LA6iB1xuJzP+BJAJZvJHQTLI
         vNmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LSVMi3sIF030EU435n7TSz+80CX0XXIOGq6LT9c1iJs=;
        b=AV8oyScJ9+662SPKS+/DrFw+A3ut+nCe3N/fMMNpQTQW1cs5l91yYbdx7NePsPWumZ
         QkHblXDvZhLH/pTz4W8X0pWh//2QId7qvOzxYLGqhTdw3EOSa+JtYmwLOG587XsbWkma
         B67BlOGKEn5N3KU45KnJQIpHOtWL00quIfRW8JvqqyrAXrVLuPyETM79Dn1BNXxrv0fB
         JNvOjKJ82r4cHn5skoSUTzNoY17TG9bJLSdDT95Jl6zIJXFhpFjIAMSzbeMO6oB0NFIP
         g0sNjAVqvytXbbRLytD41GINnQUkpB0VgPDn5IJdc/ln4XFv/L30z+RW5MoYpi1mjyP7
         L7AA==
X-Gm-Message-State: AOAM531z/AHd1fAYh4B1lQsnM7Gsrc8hGREDphf2Ak+qqpQITreXy8Gp
	EmNYstp9M8xcI00T8kmHrhsghpnwAVyMM3a9qtdSCw==
X-Google-Smtp-Source: ABdhPJyfOvuHWuBNEzCDaf6KWjVCW5+Yh5xV+7u/r/xrZNVTzYvg+dpYbastpgLiZn/zH67ln5iDNrujvtfmyJbpnMI=
X-Received: by 2002:a17:906:58d4:b0:6f4:cebd:c4b with SMTP id
 e20-20020a17090658d400b006f4cebd0c4bmr385389ejs.492.1652368834342; Thu, 12
 May 2022 08:20:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220512013921.164637-1-swboyd@chromium.org> <20220512013921.164637-2-swboyd@chromium.org>
In-Reply-To: <20220512013921.164637-2-swboyd@chromium.org>
From: Guenter Roeck <groeck@google.com>
Date: Thu, 12 May 2022 08:20:23 -0700
Message-ID: <CABXOdTe9KAs8conb-LNh09dqZLkbuuhtxFirwtvZaeO=agfROQ@mail.gmail.com>
Subject: Re: [PATCH v5 1/3] dt-bindings: cros-ec: Fix a typo in description
To: Stephen Boyd <swboyd@chromium.org>
Cc: Rob Herring <robh+dt@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, 
	patches@lists.linux.dev, 
	"open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE" <devicetree@vger.kernel.org>, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, chrome-platform@lists.linux.dev, 
	Guenter Roeck <groeck@chromium.org>, Douglas Anderson <dianders@chromium.org>, 
	Craig Hesling <hesling@chromium.org>, Tom Hughes <tomhughes@chromium.org>, 
	Alexandru M Stan <amstan@chromium.org>, Tzung-Bi Shih <tzungbi@kernel.org>, 
	Matthias Kaehlcke <mka@chromium.org>, Benson Leung <bleung@chromium.org>, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, May 11, 2022 at 6:39 PM Stephen Boyd <swboyd@chromium.org> wrote:
>
> A 's/pf/of/' on rpmsg-name description.
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

Reviewed-by: Guenter Roeck <groeck@chromium.org>

> ---
>  Documentation/devicetree/bindings/mfd/google,cros-ec.yaml | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml b/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
> index d1f53bd449f7..99eda9ab0651 100644
> --- a/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
> +++ b/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
> @@ -61,7 +61,7 @@ properties:
>    mediatek,rpmsg-name:
>      description:
>        Must be defined if the cros-ec is a rpmsg device for a Mediatek
> -      ARM Cortex M4 Co-processor. Contains the name pf the rpmsg
> +      ARM Cortex M4 Co-processor. Contains the name of the rpmsg
>        device. Used to match the subnode to the rpmsg device announced by
>        the SCP.
>      $ref: "/schemas/types.yaml#/definitions/string"
> --
> https://chromeos.dev
>
