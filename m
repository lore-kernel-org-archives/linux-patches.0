Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5F9224F1
	for <patches@lists.linux.dev>; Tue, 24 Oct 2023 18:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L0TayIMQ"
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-5a7d532da4bso47919647b3.2
        for <patches@lists.linux.dev>; Tue, 24 Oct 2023 11:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698171118; x=1698775918; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SSqGcfPDMAQJZbk5712WGjiVTfSLolcvvugGpbe3I98=;
        b=L0TayIMQ4yZq/q+jNbDCQjjDpItymIczOxVdlnlD2KzFo2F4Zjtp8uhDh03vo4Lqvf
         rnhCtxTHFCrHJkF3/nhFWB/FNKIZWklZlj4WMmunNI+5/N8Q1UDvc9VlFCHflF2hXGf6
         6rROwlqkTM1JLGM31DBmZUNlBUXel48fyMi8DKRC6Kamizdb7okwLr+STyemZjHa7htq
         4nsE2lD9u8XUuk0V46yoNkLnkBZqiAOEcLQbrEdVpzenW9otBuarP6F0K7EIzKDM7qvU
         I5Um5ONFqnFOd6WlI+z6LrbbqXLhIJvubhMK6kD1iJLObtOtLWT2xCP5AzUgz4HX+2sM
         whGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698171118; x=1698775918;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SSqGcfPDMAQJZbk5712WGjiVTfSLolcvvugGpbe3I98=;
        b=EhYfHKO2Lrznti6izHmlg0+h6qJ1+a3hAkKY+HHEpGfLbJtJWwQNcWNsYcBX4kr6Yj
         FSVfJZSX6bX6u608SC/MK+xQYIxmmLe6xWmC4wp1YO9FzDAaX+mX6G88NGVexjGt1/qK
         O5b6KZa6udiVBwO2Av8SjD/CqaRSaOR38kJefURK+NorPQOh/34eB7crik3UXXKDLeHR
         S7pIyagl0VPvX636t1WevMymEsmhHxSL1L5HL4vxFNtl+yNbCcl/Esjbk5/lcdN7S9SU
         +DHcLlb43/D5Ix8mEn+sERL+OfbBc7lm9Q5tT49f4TmwLMppPOO+Z5uNcfGcEYDSEnOi
         s7SA==
X-Gm-Message-State: AOJu0YxXodTj7RX7gewpsqMBz9IYXMl8DaFoqWBjWPEHBWhgI5sX8BHo
	ExQkhQRTsz3TyLmlQ8CEDRs=
X-Google-Smtp-Source: AGHT+IGo8qG9Uq/Oh2cHbKXi40hnTB4WA1qnHbMVz2nb9wBIDZjtOntSpoNtANEIVGZgQLpRUoyw+A==
X-Received: by 2002:a81:6c58:0:b0:5a7:f933:c8c4 with SMTP id h85-20020a816c58000000b005a7f933c8c4mr13738496ywc.14.1698171118021;
        Tue, 24 Oct 2023 11:11:58 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id ee6-20020a05690c288600b005a7b8fddfedsm4232438ywb.41.2023.10.24.11.11.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Oct 2023 11:11:57 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 24 Oct 2023 11:11:56 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 000/196] 6.1.60-rc1 review
Message-ID: <8843b9c4-090f-4938-bfe8-16cafd4a0cec@roeck-us.net>
References: <20231023104828.488041585@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>

On Mon, Oct 23, 2023 at 12:54:25PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.60 release.
> There are 196 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Oct 2023 10:47:57 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 529 pass: 529 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
