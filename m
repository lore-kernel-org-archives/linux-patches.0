Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A48A3FE7
	for <patches@lists.linux.dev>; Tue, 10 May 2022 23:04:12 +0000 (UTC)
Received: by mail-pj1-f53.google.com with SMTP id cq17-20020a17090af99100b001dc0386cd8fso420553pjb.5
        for <patches@lists.linux.dev>; Tue, 10 May 2022 16:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rpOOu3yloX9+o7QmB4b1fha0WPYoksvLJ9prqiOWMZA=;
        b=k00JKarFFBjlfYD+r85hwLg0trPXVpQEixLbgrBOuMBzDyi5b/kKU+CffB5c5ibqTD
         zxjGv7Zvu0lj5MfTWUoTgBkOspD19gvDGY+tGud+fgVwBXnUHjjkvby3B8BN9MveLS+P
         S6eZZopSzUB+t2aSvRryNcQnFK9X6XbfLNlJQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rpOOu3yloX9+o7QmB4b1fha0WPYoksvLJ9prqiOWMZA=;
        b=6o+jQJOSnWvTteQoLCljLwHo77QCPXgc42AXHx+eS5mH03MBdtehuW8HaO5m3EJO4G
         driG2K39A8Qv6XYJIzQkZwW7SHMgQTnaFc1X0BqtA+jjkL+j5tI15fWosyR9hxdw7WLc
         YZlCyoicGiVq6m9Xfl9D1Q2F/aFC2mVLjcUf+I3seg8c9Tpk2jKvcONwSidmDY1ghpRa
         3ENPsIy305oHg3efRu9EqRtaMaU5Sy3Un8zjzmwj5zuAOY1COUg3+Bv8mY59iYt5pNdV
         622GJ+GO15NEMymx1XQTiFI3ujiF+K5ASZv7DtZ1a7Y0uiFknV1uOtHWj4NdO8YNnzQL
         JDQA==
X-Gm-Message-State: AOAM530pf0sQ2irYBu2pNfTZbGYF+JvVt6OhZrgr5UhZtTj9Mqfpol6V
	zpbb0QN01y0c123RP00fFTZrgw==
X-Google-Smtp-Source: ABdhPJxEnJFubfWfGEANXo2HCxGCKtq5R1uXvOZ5g1XB3spi/HvrHYO1LvgE8enCGq/BukKn6rfDMw==
X-Received: by 2002:a17:902:e881:b0:15e:93ac:41ba with SMTP id w1-20020a170902e88100b0015e93ac41bamr22642097plg.160.1652223851502;
        Tue, 10 May 2022 16:04:11 -0700 (PDT)
Received: from chromium.org (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 137-20020a62178f000000b0050d4d156362sm97625pfx.1.2022.05.10.16.04.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 16:04:11 -0700 (PDT)
Date: Tue, 10 May 2022 23:04:09 +0000
From: Prashant Malani <pmalani@chromium.org>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	chrome-platform@lists.linux.dev,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
	Benson Leung <bleung@chromium.org>,
	Guenter Roeck <groeck@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Hsin-Yi Wang <hsinyi@chromium.org>,
	"Joseph S. Barrera III" <joebar@chromium.org>
Subject: Re: [PATCH v4 0/2] Input: cros-ec-keyb: Better matrixless support
Message-ID: <Ynrvadrl/P/6CrMQ@chromium.org>
References: <20220503204212.3907925-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503204212.3907925-1-swboyd@chromium.org>

Hi Dmitry,

On May 03 13:42, Stephen Boyd wrote:
> This is a followup to my previous patch[1] that skips keyboard registration
> when the matrix properties aren't present. This adds a compatible string
> for this scenario so we can ease existing DTBs over to the new design.
> 
> Changes from v3 (https://lore.kernel.org/r/20220503042242.3597561-1-swboyd@chromium.org):
>  * s/register_keyboard/has_keyboard/
>  * Pick up review tags
>  * Indicate properties are required in example #2 in yaml file
> 
> Changes from v2 (https://lore.kernel.org/r/20220429233112.2851665-1-swboyd@chromium.org):
>  * Drop rows/cols check now that compatible schema handles it
>  * Make binding require rows,cols,keymap for cros-ec-keyb compatible
> 
> Changes from v1 (https://lore.kernel.org/r/20220427203026.828183-1-swboyd@chromium.org):
>  * Better enforcement of properties in DT binding
>  * Skip registration by means of adding compatible to device id list
> 
> Stephen Boyd (2):
>   dt-bindings: google,cros-ec-keyb: Introduce switches only compatible
>   Input: cros-ec-keyb - skip keyboard registration w/o cros-ec-keyb
>     compatible

Do these need input maintainers Acked-by? Also, should these go through
the chrome-platform branch?

Thanks,

-Prashant 
> 
>  .../bindings/input/google,cros-ec-keyb.yaml   | 87 +++++++++++++++++--
>  drivers/input/keyboard/cros_ec_keyb.c         | 19 ++--
>  2 files changed, 91 insertions(+), 15 deletions(-)
> 
> Cc: Krzysztof Kozlowski <krzk+dt@kernel.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: <devicetree@vger.kernel.org>
> Cc: Benson Leung <bleung@chromium.org>
> Cc: Guenter Roeck <groeck@chromium.org>
> Cc: Douglas Anderson <dianders@chromium.org>
> Cc: Hsin-Yi Wang <hsinyi@chromium.org>
> Cc: "Joseph S. Barrera III" <joebar@chromium.org>
> 
> [1] https://lore.kernel.org/all/20220425210726.3813477-1-swboyd@chromium.org/
> 
> base-commit: 4352e23a7ff2f8a4ff229dd1283ed2f2b708ec51
> -- 
> https://chromeos.dev
> 
> 
