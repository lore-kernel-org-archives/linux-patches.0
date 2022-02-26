Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8257B;
	Sat, 26 Feb 2022 19:49:54 +0000 (UTC)
Received: by mail-ej1-f53.google.com with SMTP id a23so17270920eju.3;
        Sat, 26 Feb 2022 11:49:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oQm/8EZuv4iUVCQpgzsPLxIp+cQmk1vzpMnG8eElwKU=;
        b=aK7vV+zQmw92jwTFKg3Hv1G1NQMlqA8DmitQ74nuYFKaheC3dqOedikiAJ+GevbUhs
         wvfVGXggoYAh6GYYsdDE2sNenuNSKtFjjY2THSRxr8Ur1lHq3u7fpYVKo6NbRzfyT+i7
         sL4RYEzQbM5OGgQb6okvl4yuQ1F5mXMUW2mk50FJycxZpPiQxbk/Gq2MLFmcFhRC0VCG
         odkahNJ6CbUytX6nwoeIgw99i5trw9IWIebUw7shFmtRflyPi5JpTnJ7RV3ZEbgsNvTZ
         B60xh60ChCKmbUYFICWo6+lLI0KPEte5Yfk/w58WXqHDfSWVSIMtttdmR9AE8DYvjdEA
         I1DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oQm/8EZuv4iUVCQpgzsPLxIp+cQmk1vzpMnG8eElwKU=;
        b=4GVdNn9LZOUWhfY3nPQGJ7KwXTBGwFK2kcZJF+PM3NZ2MoN/s/GxVbngdfAZQjbP4d
         FS+yvk+1ythj+kyncwRK3tEhwUjbrm2/L65zf42RbnHTE+W2Sp+GaZSoPICaf4ZLh3ix
         zwsgjUnsaN60ZUiJGxmyNsGqDt0nmIZt1f/dPngkTM/1NH/QQA5wdJbIN07xzf5CAkni
         AqlMcvVSZQ6ZBjykHxHbzW9xl9YFF4SpKPFBznkr14+7rUjkLYzUHuJfthmGtcCcumrB
         NE76vsSnwa5vcwR4R2Oo19D0nVpLsXr6/3r4f1vldUQKeafXM45jVpeytRF9+GDm/gUb
         4Fyg==
X-Gm-Message-State: AOAM533TShLh6x5kmyLzDuen3bVpxzpPJGQa97R3Jj50Zab1wNvfbB8Y
	nv4moabMwoWNlr/CO4JlgRDdVpv3HAOZzYkVmcA=
X-Google-Smtp-Source: ABdhPJypRQeHXDbuGguWBy1Sz2iNxxu850tG52VrjJNCRPekzNZ/EbAMd1R4aGg3tvIBjga53FrFAI4WI9IY19MFfD4=
X-Received: by 2002:a17:906:5950:b0:6b3:65b7:82d3 with SMTP id
 g16-20020a170906595000b006b365b782d3mr10152248ejr.636.1645904992690; Sat, 26
 Feb 2022 11:49:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220224211034.625130-1-nathan@kernel.org>
In-Reply-To: <20220224211034.625130-1-nathan@kernel.org>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Sat, 26 Feb 2022 21:49:16 +0200
Message-ID: <CAHp75VdW8g_bvPvvfWOW5SUkEm9PYu8UvO9Mf_wshLLB3u=zPw@mail.gmail.com>
Subject: Re: [PATCH] iio: accel: adxl367: Fix handled initialization in adxl367_irq_handler()
To: Nathan Chancellor <nathan@kernel.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Michael Hennerich <Michael.Hennerich@analog.com>, 
	Cosmin Tanislav <cosmin.tanislav@analog.com>, Jonathan Cameron <jic23@kernel.org>, 
	linux-iio <linux-iio@vger.kernel.org>, patches@lists.linux.dev, llvm@lists.linux.dev, 
	kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Feb 24, 2022 at 11:25 PM Nathan Chancellor <nathan@kernel.org> wrote:

...

>   drivers/iio/accel/adxl367.c:879:14: note: initialize the variable 'handled' to silence this warning
>           bool handled;
>                       ^

>                        = 0

Bad advice (at minimum it should be false, but in general it might
hide a real issue)

>   1 error generated.

-- 
With Best Regards,
Andy Shevchenko
