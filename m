Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D843204
	for <patches@lists.linux.dev>; Tue,  3 May 2022 15:09:21 +0000 (UTC)
Received: by mail-ej1-f43.google.com with SMTP id n10so16625431ejk.5
        for <patches@lists.linux.dev>; Tue, 03 May 2022 08:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7tccEYmP1Up3dLXDN+1M0rIsKvh0911h46EMldmvN7I=;
        b=b9ShGJ5SZTplKe0QbTIy+x0O2zCSuwbYR2O/20m2BPYhSQDrLmIGDywLO0FRQQrwcH
         Ly89HKMYQuR7uMZPvGFDet7K7qr1mGKyVs/NixIsXhg6ywD3joeB7yiiDXuwPkVn61HR
         yH5tjEQ+qoNKZohYEhk8radCiM3/+7F2b2k8U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7tccEYmP1Up3dLXDN+1M0rIsKvh0911h46EMldmvN7I=;
        b=oTSqfrFBErEBcHq5uQ+GJgqIA7GvmlP2pU0VRrNibYpPkIfQg2WaACWlothBtIeZNR
         c5OpQxkz9UPbYsxBV/C00pHcDRbc1pbAKNg0qpiDkT+VICFhfkb9YUzSPPVr7F/E73AB
         MkyCza3Hvzg857/1zaj5g3LanOJbqvm35NwKwHT7hVGuIO+y3QmXE3UQMzIZA/Nvo76M
         d0uof7IhGNrepOY6V+Plkgz9IdSGLupeUWMb2JDaGOz+O8yh0CpqF651egK6qBIyo3+Y
         p7VOxlBnkyfyWTJxMKpuiOW4egKXoq3ZLj2hfgtfDTQuUh2FX4bI+DhSnnyzBHK5t3Zs
         6VWg==
X-Gm-Message-State: AOAM532syqufze7Txap4DI+GnyjOo3xl8/SlacMXafefb+1dryaiOoSs
	jikynShz6mgu/A59cMNYmv2uCALN2Cbsv0l+
X-Google-Smtp-Source: ABdhPJx61GAth9XyP5sJlCNYl0ny+XQ6Dec3VwuIjm5gHraPi8NdO/zbOiEQL0auo1i+rYbbtpHe/Q==
X-Received: by 2002:a17:907:948b:b0:6d8:27f8:ab4a with SMTP id dm11-20020a170907948b00b006d827f8ab4amr16179548ejc.39.1651590559597;
        Tue, 03 May 2022 08:09:19 -0700 (PDT)
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com. [209.85.128.49])
        by smtp.gmail.com with ESMTPSA id dq8-20020a170907734800b006f3ef214e23sm4697266ejc.137.2022.05.03.08.09.17
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 May 2022 08:09:17 -0700 (PDT)
Received: by mail-wm1-f49.google.com with SMTP id r1-20020a1c2b01000000b00394398c5d51so1459620wmr.2
        for <patches@lists.linux.dev>; Tue, 03 May 2022 08:09:17 -0700 (PDT)
X-Received: by 2002:a7b:c4c8:0:b0:394:26c5:b79e with SMTP id
 g8-20020a7bc4c8000000b0039426c5b79emr3744035wmk.15.1651590556954; Tue, 03 May
 2022 08:09:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220503042242.3597561-1-swboyd@chromium.org> <20220503042242.3597561-2-swboyd@chromium.org>
In-Reply-To: <20220503042242.3597561-2-swboyd@chromium.org>
From: Doug Anderson <dianders@chromium.org>
Date: Tue, 3 May 2022 08:09:04 -0700
X-Gmail-Original-Message-ID: <CAD=FV=V8kfRYidvQRmx_XmGm8X3XHR_GxTkKvxkqUHdqJ5CMNg@mail.gmail.com>
Message-ID: <CAD=FV=V8kfRYidvQRmx_XmGm8X3XHR_GxTkKvxkqUHdqJ5CMNg@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] dt-bindings: google,cros-ec-keyb: Introduce
 switches only compatible
To: Stephen Boyd <swboyd@chromium.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, LKML <linux-kernel@vger.kernel.org>, 
	patches@lists.linux.dev, chrome-platform@lists.linux.dev, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Rob Herring <robh+dt@kernel.org>, 
	"open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>, Benson Leung <bleung@chromium.org>, 
	Guenter Roeck <groeck@chromium.org>, Hsin-Yi Wang <hsinyi@chromium.org>, 
	"Joseph S. Barrera III" <joebar@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Hi,

On Mon, May 2, 2022 at 9:22 PM Stephen Boyd <swboyd@chromium.org> wrote:
>
> @@ -113,3 +135,56 @@ examples:
>              /* UP      LEFT    */
>              0x070b0067 0x070c0069>;
>      };
> +
> +  - |
> +    keyboard-controller {
> +        compatible = "google,cros-ec-keyb-switches", "google,cros-ec-keyb";
> +        /* Matrix keymap properties are allowed but ignored */

nit: s/allowed/required/

This now looks reasonable and well explained to me.

Reviewed-by: Douglas Anderson <dianders@chromium.org>
