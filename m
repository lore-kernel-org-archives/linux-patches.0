Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A3C2F2A
	for <patches@lists.linux.dev>; Mon,  2 May 2022 17:03:10 +0000 (UTC)
Received: by mail-ej1-f46.google.com with SMTP id g6so28948314ejw.1
        for <patches@lists.linux.dev>; Mon, 02 May 2022 10:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/u6ctPDMxVgGjtnFGMUjLT8WYXeEvvG7PHjNe0QwddI=;
        b=U+6pAjMkfydxMfXGeTmt3HKbxbXevcplbal5L1ckkQu9nHhDDr4SDRGgBekVn87CJd
         YrmGEanXaLZSZ82VJResvpoYyRkLUcrMX7ZgkOFM7hnObCOd86KUkbaj6zmv9dig+Cl6
         pXz5+eXdWfU0Vqp7yPjv4dFgsa7Lo+L0IpdMk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/u6ctPDMxVgGjtnFGMUjLT8WYXeEvvG7PHjNe0QwddI=;
        b=pZvefFGxlYuIAibDY2JSt4qglXZ9afNtFvHsfinE9oBw99ZYBvD0DOL9iGbmJnNM0K
         cYJ7KBQDxOPHj7aqK/0Z4huHfKKxRwB2H8+lVqgz2SmPwVWJBaP3emggI/gfoXhxeKiL
         gDfVTrnKrY7I2m7C/Gt0+KLof/Rz/q+K8sIAfWrpOXmpu8530j4Mqc4Rups0jk/YaUTQ
         ieUptMDGmGdwV7t5GR8/jvFWWGPYRLLHtTDp/oJavsffr1Z5sQMlcrtuddoLtHfiOvHw
         AqNRsDIITb6QzdzMedONItXz42sZZvk+9YNwXmzJXJbPMKSG1P6KkC0606qQhTQjOtk8
         ImHA==
X-Gm-Message-State: AOAM533oD18WBH7jtDI5yk27AOlWZBqZKCo5OZznNxnHzAEFaMbG4kP7
	NvTqhBR9D+j8hNgf5NqoBetBetMPnYmORLKV
X-Google-Smtp-Source: ABdhPJxrgc2HC8qeOv48Bq5h6sthENt17pkf4HOkpsCANY0Gj6roMAJFvNBINO2uoNQCBFVaC/aViQ==
X-Received: by 2002:a17:907:1623:b0:6e8:8678:640d with SMTP id hb35-20020a170907162300b006e88678640dmr11874930ejc.189.1651510988266;
        Mon, 02 May 2022 10:03:08 -0700 (PDT)
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com. [209.85.221.48])
        by smtp.gmail.com with ESMTPSA id c19-20020aa7d613000000b0042617ba638bsm6953611edr.21.2022.05.02.10.03.06
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 May 2022 10:03:07 -0700 (PDT)
Received: by mail-wr1-f48.google.com with SMTP id d5so20321204wrb.6
        for <patches@lists.linux.dev>; Mon, 02 May 2022 10:03:06 -0700 (PDT)
X-Received: by 2002:a5d:6d09:0:b0:20c:53a9:cc30 with SMTP id
 e9-20020a5d6d09000000b0020c53a9cc30mr9166713wrq.513.1651510986299; Mon, 02
 May 2022 10:03:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220429233112.2851665-1-swboyd@chromium.org> <20220429233112.2851665-3-swboyd@chromium.org>
In-Reply-To: <20220429233112.2851665-3-swboyd@chromium.org>
From: Doug Anderson <dianders@chromium.org>
Date: Mon, 2 May 2022 10:02:54 -0700
X-Gmail-Original-Message-ID: <CAD=FV=WAbfe9BC5QPDezz3FSEwHRFdQeZpARJYT4b9V1rNp_nA@mail.gmail.com>
Message-ID: <CAD=FV=WAbfe9BC5QPDezz3FSEwHRFdQeZpARJYT4b9V1rNp_nA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] Input: cros-ec-keyb - skip keyboard registration
 for switches compatible
To: Stephen Boyd <swboyd@chromium.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, LKML <linux-kernel@vger.kernel.org>, 
	patches@lists.linux.dev, chrome-platform@lists.linux.dev, 
	Krzysztof Kozlowski <krzk@kernel.org>, Rob Herring <robh+dt@kernel.org>, 
	"open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>, Benson Leung <bleung@chromium.org>, 
	Guenter Roeck <groeck@chromium.org>, Hsin-Yi Wang <hsinyi@chromium.org>, 
	"Joseph S. Barrera III" <joebar@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Hi,

On Fri, Apr 29, 2022 at 4:31 PM Stephen Boyd <swboyd@chromium.org> wrote:
>
> In commit 4352e23a7ff2 ("Input: cros-ec-keyb - only register keyboard if
> rows/columns exist") we skipped registration of the keyboard if the
> row/columns property didn't exist, but that has a slight problem for
> existing DTBs. The DTBs have the rows/columns properties, so removing
> the properties to indicate only switches exist makes this keyboard
> driver fail to probe, resulting in broken power and volume buttons. Ease
> the migration of existing DTBs by skipping keyboard registration if the
> google,cros-ec-keyb-switches compatible exists.
>
> The end result is that new DTBs can either choose to remove the matrix
> keymap properties or leave them in place and add this new compatible
> indicating the matrix keyboard properties should be ignored. Existing
> DTBs will continue to work, but they will keep registering the keyboard
> that does nothing. To fix that problem we can add this extra compatible
> to existing DTBs and the keyboard will stop being registered. Finally,
> if google,cros-ec-keyb is missing then this driver won't even attempt to
> register the matrix keyboard.
>
> Cc: Krzysztof Kozlowski <krzk@kernel.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: <devicetree@vger.kernel.org>
> Cc: Benson Leung <bleung@chromium.org>
> Cc: Guenter Roeck <groeck@chromium.org>
> Cc: Douglas Anderson <dianders@chromium.org>
> Cc: Hsin-Yi Wang <hsinyi@chromium.org>
> Cc: "Joseph S. Barrera III" <joebar@chromium.org>
> Fixes: 4352e23a7ff2 ("Input: cros-ec-keyb - only register keyboard if rows/columns exist")
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  drivers/input/keyboard/cros_ec_keyb.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/input/keyboard/cros_ec_keyb.c b/drivers/input/keyboard/cros_ec_keyb.c
> index eef909e52e23..1bbe2987bf52 100644
> --- a/drivers/input/keyboard/cros_ec_keyb.c
> +++ b/drivers/input/keyboard/cros_ec_keyb.c
> @@ -536,6 +536,12 @@ static int cros_ec_keyb_register_matrix(struct cros_ec_keyb *ckdev)
>         u32 *physmap;
>         u32 key_pos;
>         unsigned int row, col, scancode, n_physmap;
> +       bool register_keyboard;
> +
> +       /* Skip matrix registration if no keyboard */
> +       register_keyboard = device_get_match_data(dev);
> +       if (!register_keyboard)
> +               return 0;
>
>         /*
>          * No rows and columns? There isn't a matrix but maybe there are

As per my comments in patch #1, I wonder if it makes sense to delete
the "No rows and columns?" logic and settle on the compatible as the
one true way to specify this.

-Doug
