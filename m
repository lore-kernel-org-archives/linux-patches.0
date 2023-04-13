Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019617E
	for <patches@lists.linux.dev>; Thu, 13 Apr 2023 00:15:03 +0000 (UTC)
Received: by mail-pj1-f48.google.com with SMTP id h24-20020a17090a9c1800b002404be7920aso13436008pjp.5
        for <patches@lists.linux.dev>; Wed, 12 Apr 2023 17:15:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1681344903; x=1683936903;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8Ur7pWq3YTZwupZ6RTjyothfqMg5i206ZuFZxJk6Y/I=;
        b=fekDZhA4lBbIEAAXrevCLVrnD0hxBCdiXWLGDnJ/LupciNG57pUvvPOdVZucB1N8P1
         peVBTaAZknhpoXK217eCiyjhtNCKaiOeYLEuYrtoj7pQRyATAnfqgnhOgKb0jBZSpYL8
         CXWYlWInT4yUzGeB2aZW2yvuzaknGlNjyP7s0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681344903; x=1683936903;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8Ur7pWq3YTZwupZ6RTjyothfqMg5i206ZuFZxJk6Y/I=;
        b=Ed4+SC71Xkr+RVT0eE2C8u/UBogLGmjCUp4jBBOwoObBuROnXILmaxDIKnbwAT+GSe
         WkofknJM/n5ZngK7uEILpsLL5Yc/XoCJTviKtLFCC7AoCaWUtAiP8jPoo/z39ygBts6v
         fWOtFjT50ORUEJW7Fv/AbXLow2IPALQO8JRWzyRXX1qnQE7WIir3HuSfTy6G1I2JgPKR
         NzsTLThgGXdAohQFrU8OaKCNY0Fg4BHeHKjsl2E2mKlgqzBwDHOM4UvFzzDWnShw/WmG
         hGra0dR7xYvjly1+BLbtOitxNPWJTxZqcllAynw9PtcV9/rUvuSN3mW87NWYsJUUSsSA
         WM/w==
X-Gm-Message-State: AAQBX9fhCd7ugNTJwg2QdrSYlViRvNbbQI25nrWpoj1hDBMo6bz/5sUT
	7m6hjrBQ6ofboiUA2WbmXBjVNlPY6+BVlE13zxg=
X-Google-Smtp-Source: AKy350YoxGMRze3wEaT0ozyp4hV8MB3wRu4HvkTMGjZUxoLtiAQ94b70km38bi/aCBDXSpqg7iVTWw==
X-Received: by 2002:a17:90a:5606:b0:23f:e675:9c4a with SMTP id r6-20020a17090a560600b0023fe6759c4amr4177207pjf.21.1681344903416;
        Wed, 12 Apr 2023 17:15:03 -0700 (PDT)
Received: from google.com ([2620:15c:9d:2:d67d:c31:eaee:d33e])
        by smtp.gmail.com with ESMTPSA id p15-20020a17090a2d8f00b00246626343aesm2010779pjd.25.2023.04.12.17.15.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 17:15:03 -0700 (PDT)
Date: Wed, 12 Apr 2023 17:15:01 -0700
From: Brian Norris <briannorris@chromium.org>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: Re: [PATCH] driver core: Don't require dynamic_debug for
 initcall_debug probe timing
Message-ID: <ZDdJhaZibUC0/nfc@google.com>
References: <20230412225842.3196599-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412225842.3196599-1-swboyd@chromium.org>

On Wed, Apr 12, 2023 at 03:58:42PM -0700, Stephen Boyd wrote:
> Don't require the use of dynamic debug (or modification of the kernel to
> add a #define DEBUG to the top of this file) to get the printk message
> about driver probe timing. This printk is only emitted when
> initcall_debug is enabled on the kernel commandline, and it isn't
> immediately obvious that you have to do something else to debug boot
> timing issues related to driver probe. Add a comment too so it doesn't
> get converted back to pr_debug().
> 
> Fixes: eb7fbc9fb118 ("driver core: Add missing '\n' in log messages")
> Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Cc: Brian Norris <briannorris@chromium.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  drivers/base/dd.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)

Reviewed-by: Brian Norris <briannorris@chromium.org>
