Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D61C7E
	for <patches@lists.linux.dev>; Tue, 26 Apr 2022 14:19:41 +0000 (UTC)
Received: by mail-wr1-f52.google.com with SMTP id b19so25670928wrh.11
        for <patches@lists.linux.dev>; Tue, 26 Apr 2022 07:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=QS3yKNM0q2pZDAHA1IFWy/K8h6RY8QsWB8BvPEu/8J8=;
        b=hs8cD1vdRbGuUkUUDGWzBPd9FczxSWGXeA1xWmjjUAtpoizXH2ALAV++G3+yJzLgAO
         rfISoueXGrD1jFeIAhNyayqRQDISTsgBsufDc7XLL5pj8Opxkm0+0hQ/rSiiS4MFw6cp
         gq+M98jsTo9TR+j+oYPxX4Qvo1TfZyD90upEgVlwdTA1vqTZf6BMMwhjUAs0D4y4YXce
         XfUe5XnCcOFElrdDsIhYqZEW6Hns6Pnbeas+h9/4LttctEIxkJEZ5YoXthGLdzhhwhHl
         dmFSPwgf5X53q1Y1/pZY77HbOSxkI+BnWxVu397XEesiuG0BlJpVtg2w3oRz2d6Smt5V
         /a9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=QS3yKNM0q2pZDAHA1IFWy/K8h6RY8QsWB8BvPEu/8J8=;
        b=u5yA5Szg7k7gxL+i9jjemnoF2XeOXGhhBvQS+QOr3A8/KydyjICYZpxcgLKDWM9Etu
         lmhGbxZVVWXGE64bcS4BBR5L5Ic/PssxPcG0ch5tIPUPycLdPrNpwY3ANolLg/Je530G
         Irkp7x7EEt3bRwDOmS1B46w/gIBrmwCw7k8YCfucmyPgBLadr6IUxcd+0fAHiN5t7YNr
         fZqiosxhovN+RcpG/4rkaBpust61dGOHcShRXAUx7nZBr+1AuB1bSiYoeQGKyCHiSHx0
         /VUd0hWh8+tamyf4TCAu600HBJiei5fTYJIRc3FLGTBFHtBOWPS2PqsruZe/1bjSmQ1E
         ZjoQ==
X-Gm-Message-State: AOAM533j1JywVcnGQollwy4gfvKzZ5HamY+jqUHkFO25pc3c4XLDUjzs
	RUvwN5XCDy2y8DYBaSYoxfbBMA==
X-Google-Smtp-Source: ABdhPJxUgN7DLQYxCIIGBi53Jg9tpP9jWKFpfG7stGDElrwVpEw0+ekD5kQwtkL9ceflCvkm8ZwRqg==
X-Received: by 2002:adf:db11:0:b0:20a:bfd2:8557 with SMTP id s17-20020adfdb11000000b0020abfd28557mr18597013wri.485.1650982779415;
        Tue, 26 Apr 2022 07:19:39 -0700 (PDT)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id m20-20020a05600c4f5400b00393ea3bab42sm6412842wmq.19.2022.04.26.07.19.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 07:19:39 -0700 (PDT)
Date: Tue, 26 Apr 2022 15:19:37 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Stephen Boyd <swboyd@chromium.org>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	Prashant Malani <pmalani@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Daisuke Nojiri <dnojiri@chromium.org>,
	Benson Leung <bleung@chromium.org>,
	Guenter Roeck <groeck@chromium.org>,
	chrome-platform@lists.linux.dev
Subject: Re: [PATCH v2] mfd: cros_ec_dev: Only register PCHG device if present
Message-ID: <Ymf/ecKnqfkE5OOE@google.com>
References: <20220419000408.3202635-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220419000408.3202635-1-swboyd@chromium.org>

On Mon, 18 Apr 2022, Stephen Boyd wrote:

> Don't create a device for the peripheral charger (PCHG) if there aren't
> any peripheral charger ports. This removes a device on most ChromeOS
> systems, because the peripheral charger functionality isn't always
> present.
> 
> Cc: Prashant Malani <pmalani@chromium.org>
> Cc: Tzung-Bi Shih <tzungbi@kernel.org>
> Cc: Daisuke Nojiri <dnojiri@chromium.org>
> Cc: Benson Leung <bleung@chromium.org>
> Cc: Guenter Roeck <groeck@chromium.org>
> Cc: <chrome-platform@lists.linux.dev>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
> 
> Changes from v1 (https://lore.kernel.org/r/20220415003253.1973106-1-swboyd@chromium.org):
>  * Use cros_ec_command()
>  * Drop the other patches that aren't needed anymore
> 
>  drivers/mfd/cros_ec_dev.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)

Applied, thanks.

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
