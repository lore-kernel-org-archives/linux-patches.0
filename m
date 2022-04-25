Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5904C7A;
	Mon, 25 Apr 2022 03:47:07 +0000 (UTC)
Received: by mail-pg1-f176.google.com with SMTP id s137so12344416pgs.5;
        Sun, 24 Apr 2022 20:47:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7VhljdC5qfgvF8YkpQHi5caMI2K36nYGNnMwDGsYTi4=;
        b=PLJQOMoBO2sR0lbBytKX+x7YhWEmudhd6tkz1e0TrsQQhULjx++oJMZBbvkoeraHC9
         GXOUe7XeiXg7WQmzb/Fzq4r99noiAAr0b0tTsPq3Lh0YDE/MZ1NBHrmLsjmY99IVxQYI
         Xswdw1cHjnQ4CDHMUELJV4e5TBeJfxk4PwnASI+dq80Yt4WoV0GRfacTgWJ0Dpxjomz7
         nReMFscLp28UFfVU3cr0iigUYQW4CFOGqds+ZPAA5bhvfN5yyymEhSXQxzeKO/gr9tAj
         vgyWi/BsG6EE7zzSBSID0RLUYb01vRZqkQq5lJ/T2eBKcXAhl7oxG1milmieGth+opj8
         svZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7VhljdC5qfgvF8YkpQHi5caMI2K36nYGNnMwDGsYTi4=;
        b=ObDP4iFariJA2EuD0KWa8GKvECrhvrr3WuESPPc9e24VRAQQy+CFH833NLo9Yw3V+i
         PQJVTVKMMUlJ7IpYQbxMZUlhWfFL2RQc7xiV+HVRFd78Do7Xup6kYXGnrI6Ea1DYrZlT
         fHzQX2o9ZXJCB2HsJ8KeRcrCCQnnkaM6ovvHkDNjk+/BwmmfRFtcT4rUDL+puc4ag6f0
         AL+DyNN0etg47wKuEkh5nrp8KfqYXDt0etyuBcUE54u4fwKhiZNgD8N/XNKpulTJsny/
         a26eSGLy0mHLkaV+hXVpfIXNsQtv4YG+wdegYH9KJabzcGelniKyLHTCF3FQV1C8d4Wv
         34yQ==
X-Gm-Message-State: AOAM531KZa0bbLH4TpiUMtPEYQPCHgXLC6ayVvxrGguLCw3OPRAW8hhr
	+beTTDbI+L7nbfZQkZhjLpA=
X-Google-Smtp-Source: ABdhPJyzITr4L56y2maJflc4flrw3rp7brBf35hCOREn6LkiCOJKjLCoM5NRBv3jnt8R81I7BCISGA==
X-Received: by 2002:a05:6a00:856:b0:50a:431b:c298 with SMTP id q22-20020a056a00085600b0050a431bc298mr16683814pfk.75.1650858426733;
        Sun, 24 Apr 2022 20:47:06 -0700 (PDT)
Received: from google.com ([2620:15c:202:201:282a:d50e:e0fc:c145])
        by smtp.gmail.com with ESMTPSA id 9-20020a631449000000b003aabd688921sm8025285pgu.13.2022.04.24.20.47.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Apr 2022 20:47:05 -0700 (PDT)
Date: Sun, 24 Apr 2022 20:47:03 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stephen Boyd <swboyd@chromium.org>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	linux-input@vger.kernel.org, chrome-platform@lists.linux.dev,
	Benson Leung <bleung@chromium.org>,
	Guenter Roeck <groeck@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Hsin-Yi Wang <hsinyi@chromium.org>
Subject: Re: [PATCH 1/2] Input: cros-ec-keyb: Only register keyboard if
 rows/columns exist
Message-ID: <YmYZt7WQC17aE1fS@google.com>
References: <20220413033334.1514008-1-swboyd@chromium.org>
 <20220413033334.1514008-2-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220413033334.1514008-2-swboyd@chromium.org>

Hi Stephen,

On Tue, Apr 12, 2022 at 08:33:33PM -0700, Stephen Boyd wrote:
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
> ---
> 
> I tried to use mkbp info to query the number of rows and columns, but my
> EC firmware doesn't have commit 8505881ed0b9 ("mkbp: Separate MKBP_INFO
> host command from the keyboard driver") so it always returns 8 and 13
> for the rows and columns. Sigh. With updated firmware we could query it,
> or we could rely on DT like we do already.
> 
> Originally I was setting the properties to 0, but
> matrix_keypad_parse_properties() spits out an error message in that case
> and so it seems better to delete the properties and check for their
> existence instead. Another alternative would be to change the compatible
> to be "google,cros-ec-keyb-switches" or something that indicates there
> are only switches and no matrix keyboard.
> 
>  drivers/input/keyboard/cros_ec_keyb.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/input/keyboard/cros_ec_keyb.c b/drivers/input/keyboard/cros_ec_keyb.c
> index 6534dfca60b4..ac9a953bff02 100644
> --- a/drivers/input/keyboard/cros_ec_keyb.c
> +++ b/drivers/input/keyboard/cros_ec_keyb.c
> @@ -537,6 +537,15 @@ static int cros_ec_keyb_register_matrix(struct cros_ec_keyb *ckdev)
>  	u32 key_pos;
>  	unsigned int row, col, scancode, n_physmap;
>  
> +	/*
> +	 * No rows and columns? There isn't a matrix but maybe there are
> +	 * switches to register in cros_ec_keyb_register_bs() because this is a
> +	 * detachable device.
> +	 */
> +	if (!device_property_read_bool(dev, "keypad,num-rows") &&
> +	    !device_property_read_bool(dev, "keypad,num-cols"))

Why are we abusing device_property_read_bool() for properties that are
not flags instead of using device_property_present()?

> +		return 0;
> +
>  	err = matrix_keypad_parse_properties(dev, &ckdev->rows, &ckdev->cols);
>  	if (err)
>  		return err;
> -- 
> https://chromeos.dev
> 

Thanks.

-- 
Dmitry
