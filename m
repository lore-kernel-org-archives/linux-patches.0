Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E5DE33D6
	for <patches@lists.linux.dev>; Mon, 25 Apr 2022 21:17:38 +0000 (UTC)
Received: by mail-ed1-f52.google.com with SMTP id y21so13104519edo.2
        for <patches@lists.linux.dev>; Mon, 25 Apr 2022 14:17:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7MjmPAa3fuV4x9AO1hWu5W5LzK42h/xrrV3+xEL5r7Q=;
        b=W/yNy5Lne60psuJAyN141Qys5/VAQk7y/70nMc2zXcz9rKyq+1Z/+Rh3d7evsUbeg2
         bMNGAtB5OaeBS4zXipeKAaEZmEuOIIWW8kdGXceL2YIUzgsXNicxArZpPJ+ENcwVDtQR
         tzYpaGfNchGoL6bLTUO8R8NA8CW1AS+fOZPuCHA5lsqISiEB5+X85SwLCF/9XY8w2q1S
         qFsOIbMyRKjM6Ili/BKpuDrALDDKhxu2Va8K4wQ95l3r2tiFxQVOEQImdZQwqNcZtn6n
         O+RPAqdpixPpDWjsTl0Jf2l/zo8MwF73fMGrZXED3KhYL/m+9fmkp6sZgIaI+PSFjD1E
         z5Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7MjmPAa3fuV4x9AO1hWu5W5LzK42h/xrrV3+xEL5r7Q=;
        b=cCUKnji2MEZHKQ5gkM115TcIcmveeeSVEga2WfDPD21j3wrYfz7G5895APSJ1gxCsq
         MNnzUhUfnOtrSnByLLh4u3Vwhg1YykQ3Y/6rmy5gzGRM0llmP4EOtZVnfJsylGeukvgs
         DIn4n0wm9h1DRzcUoC73CixsrWO47nzdeFAOVI3LaYB3TAf1gvyQzV+kRwFPfw7KU2vr
         atiFMIFdS1SnebdNh3mkuqV+FrppcN1bsUUoe4t0f7zp0WWLmtv79Frj2IzwKIKXLsRd
         jXR7rCnV40Y+Ke6nGpGlQPA7tNQ4oHLKcKrzBuCMxnli9oOUMBLAi6WC4aKewnTexfAX
         Ghqw==
X-Gm-Message-State: AOAM531AEncDKNkdPDlg5lDTFp9ySy5WB3b66arDbZlS/eClMwEkPTkc
	uaSKRoYek7/wBoC3MhzUjjOWwMCu3Kwu9YAqgXvCfQ==
X-Google-Smtp-Source: ABdhPJx9cLKOfXpy6EJ6RwXdWQqyZdTcjXPpujIWqZxKX1TvWL9hA+z/+woQ9jrT5Nb+lYH1xyFrEpFrBCRURXo9rPE=
X-Received: by 2002:a05:6402:34c7:b0:423:d44a:4c6c with SMTP id
 w7-20020a05640234c700b00423d44a4c6cmr21153822edc.356.1650921456451; Mon, 25
 Apr 2022 14:17:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220425210726.3813477-1-swboyd@chromium.org>
In-Reply-To: <20220425210726.3813477-1-swboyd@chromium.org>
From: Guenter Roeck <groeck@google.com>
Date: Mon, 25 Apr 2022 14:17:25 -0700
Message-ID: <CABXOdTeAdi4ifPaA--_UfjP3=UShJUuruuOQmWKq0Dc7DVLa4g@mail.gmail.com>
Subject: Re: [PATCH v2] Input: cros-ec-keyb: Only register keyboard if
 rows/columns exist
To: Stephen Boyd <swboyd@chromium.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, 
	patches@lists.linux.dev, Benson Leung <bleung@chromium.org>, 
	Guenter Roeck <groeck@chromium.org>, Douglas Anderson <dianders@chromium.org>, 
	Hsin-Yi Wang <hsinyi@chromium.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Apr 25, 2022 at 2:07 PM Stephen Boyd <swboyd@chromium.org> wrote:
>
> If the device is a detachable, we may still probe this device because
> there are some button switches, e.g. volume buttons and power buttons,
> registered by this driver. Let's allow the device node to be missing row
> and column device properties to indicate that the keyboard matrix
> shouldn't be registered. This removes an input device on Trogdor devices
> such as Wormdingler that don't have a matrix keyboard, but still have
> power and volume buttons. That helps userspace understand there isn't
> a keyboard present when the detachable keyboard is disconnected.
>
> Cc: Benson Leung <bleung@chromium.org>
> Cc: Guenter Roeck <groeck@chromium.org>
> Cc: Douglas Anderson <dianders@chromium.org>
> Cc: Hsin-Yi Wang <hsinyi@chromium.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>

Reviewed-by: Guenter Roeck <groeck@chromium.org>

> ---
>
> Changes from v1 (https://lore.kernel.org/r/20220413033334.1514008-1-swboyd@chromium.org):
>  * Use device_property_present
>
>  drivers/input/keyboard/cros_ec_keyb.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/drivers/input/keyboard/cros_ec_keyb.c b/drivers/input/keyboard/cros_ec_keyb.c
> index 6534dfca60b4..ceb23e2e0d94 100644
> --- a/drivers/input/keyboard/cros_ec_keyb.c
> +++ b/drivers/input/keyboard/cros_ec_keyb.c
> @@ -537,6 +537,15 @@ static int cros_ec_keyb_register_matrix(struct cros_ec_keyb *ckdev)
>         u32 key_pos;
>         unsigned int row, col, scancode, n_physmap;
>
> +       /*
> +        * No rows and columns? There isn't a matrix but maybe there are
> +        * switches to register in cros_ec_keyb_register_bs() because this is a
> +        * detachable device.
> +        */
> +       if (!device_property_present(dev, "keypad,num-rows") &&
> +           !device_property_present(dev, "keypad,num-cols"))
> +               return 0;
> +
>         err = matrix_keypad_parse_properties(dev, &ckdev->rows, &ckdev->cols);
>         if (err)
>                 return err;
>
> base-commit: 3123109284176b1532874591f7c81f3837bbdc17
> --
> https://chromeos.dev
>
