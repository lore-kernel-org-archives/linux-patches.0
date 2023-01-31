Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C74B629
	for <patches@lists.linux.dev>; Tue, 31 Jan 2023 03:11:40 +0000 (UTC)
Received: by mail-oo1-f41.google.com with SMTP id t24-20020a4a8258000000b005170b789faaso1007718oog.5
        for <patches@lists.linux.dev>; Mon, 30 Jan 2023 19:11:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tAhy3CTZnrCcAKrqL6ZpsJfMdmRkXr9FJxeCsifZi9A=;
        b=ob4X7MH6nHFOpXTxbBp2YC579tKv5s9Bs/Nkbnoj0Ko+jCdwl3xoMMNOYtFSaaEJTd
         3AhgR1iEZQ3oxJdZukpmQZQd/SK4G2AcfbSVogZOUewBTAoTjp3N7EXPKGgu1qs1dhb7
         4zAwpIOJ0WifaFbQt8q+Rm4ikR0eckZrHVfRKIKl0V7gzAaf3rByI/xGdWeDRaA8KTmv
         8MfEi0bMPlXu1mqs1JsXbDPLPzApOyoO/u3zfgi3muln8V9nYWxDr3Nvgod3bIcTbDB3
         ZlotVhzwUmMve+TIlaDyPI4V3kPBlBvGizBuqJN+Tng11PJRr+HEUJpoKIwurgR+JPSH
         G5WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tAhy3CTZnrCcAKrqL6ZpsJfMdmRkXr9FJxeCsifZi9A=;
        b=5jYAY23TlWL4m/RtCThTbPjtH9EZ+vOpwawbX9fsJMEExRoCOgV/m0bMBc1bbyt+lV
         S6tdFozhNSH9C3eZjNfejik1dTi/3Nq4bMDqsot+w8DbEG0+PvYL/Rxgba+8npdtpqeq
         uK4c4Y8TOCvTLbl5yfv7GnMuiPXELA6q1GFPJtL3YOkkdW9eCq24vqNkSLxe5MGpUcGa
         deQ3JcYJ/twYCIYfJsz17YeVO75m6p0nyHvCKvZ4Xoh1kyfa6dWC4kPJtxDePoofJ123
         QFQ6Tid8lBeHsFbH/jJl+oXcrWeuBczcsLCyzHmQDkC0vEl1Ekc7Lq3xyCQh5fDb/LDm
         sd0g==
X-Gm-Message-State: AO0yUKUbBzwl0lyAVFGxoT+SgIN0gtlD3DtWnOaW5ytx5SmyCjApQgj7
	rD1sz742C7Q6GqG+80yOo14=
X-Google-Smtp-Source: AK7set+DBg+e0aalCtvWuzFb5vBG7OiThncOMJ71BQdsbPmXl3IEQA/C8Gyo+qgqqDxnsTcBLmwNqw==
X-Received: by 2002:a4a:490f:0:b0:517:4123:9cf with SMTP id z15-20020a4a490f000000b00517412309cfmr5508252ooa.0.1675134699475;
        Mon, 30 Jan 2023 19:11:39 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b4-20020a4ab484000000b004fca8a11c61sm5590524ooo.3.2023.01.30.19.11.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 19:11:38 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 30 Jan 2023 19:11:37 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/143] 5.10.166-rc1 review
Message-ID: <20230131031137.GA835036@roeck-us.net>
References: <20230130134306.862721518@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>

On Mon, Jan 30, 2023 at 02:50:57PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.166 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Feb 2023 13:42:39 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 478 pass: 478 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
