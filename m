Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C086F610
	for <patches@lists.linux.dev>; Wed,  6 Dec 2023 18:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LoysvLLB"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1d06819a9cbso610355ad.1
        for <patches@lists.linux.dev>; Wed, 06 Dec 2023 10:43:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701888235; x=1702493035; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cdXuM+3RECR9wpuVAjDzqo7lDiVL4BbUYlfdHlVoYqY=;
        b=LoysvLLBEUldyB/wWJHOnQrAImibs28o3RuaG/osnZqq7gTD4cRxCc8e1eqWkRPq8I
         FQzMqZvUtox6MdOiDtqQw5ul/hLcc+9C65h056fogiEOgcBsgo1ASu8SNpTK/oodP4MI
         utTYoWaXFIopcNEjfO8FkJoh/eH4kywpHQu8u6kTIBgTDjUb9C28yVqqpvEA8E9A/ssw
         sb72uwsxtE59HqnuYTwyL+ZYc1plA5u5G2kk2VNgnILX6gJ7TySd6YdUzsQsa56vLi9L
         EV7Uq6iPiMYCVeo2bid4DLkZPD9fdhb+WZLf6pGmKh4pKJxNCPzlZebYb28sSQ3xSpJM
         P+BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701888235; x=1702493035;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cdXuM+3RECR9wpuVAjDzqo7lDiVL4BbUYlfdHlVoYqY=;
        b=jhEajv/M377JcwcAbdpgYfbuv3qmCEUoDzMHQJJfJqcOwdmiM4Q7yES6rJ+wZUs03X
         6bzg9/DuJGYzZlXRyWUcUAEXSX56ux5lm8SVxJuYlu1y4LFGsltZ/A5gzQmfiB+JkEdK
         H9T8JneLNbIgkLifsUsTWnpObQ+Blbo0rezu/yl0Up65/+fTczYPPpz6sjUGQo7WyHcf
         dIdKGKX72enwFzrimTxK7uCwadK+ZCncB5HI6s9JT6vVzxSJoz0NYN/EUABog5cJIBcZ
         MsfsUibUUaOksHGC8kqZQAY4OlcqMcu46WpE09JQBiOaPOiIiWdDpysuobPvjqsJ7c4X
         8M/w==
X-Gm-Message-State: AOJu0YxFo/9TwEeKRE3v3+2+45aguSKnbxBC/mTTyJ/1VIGI+srFh5P4
	gFZQJpp7c9cIxJg66NFUnvc=
X-Google-Smtp-Source: AGHT+IEjS9sKWvSWp7drnooUQRHsOvfMPGWzpn2021pxsyVo0PWXKeAjMhgAXaxuCrjmy/j9BtuBTA==
X-Received: by 2002:a17:902:d642:b0:1d0:bb51:d780 with SMTP id y2-20020a170902d64200b001d0bb51d780mr994443plh.15.1701888234587;
        Wed, 06 Dec 2023 10:43:54 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w18-20020a170902e89200b001d0969c5b68sm140760plg.139.2023.12.06.10.43.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 10:43:53 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 6 Dec 2023 10:43:52 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 4.19 00/63] 4.19.301-rc2 review
Message-ID: <b396fc77-c541-4596-a48c-fcdbdfd79a61@roeck-us.net>
References: <20231205183236.587197010@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231205183236.587197010@linuxfoundation.org>

On Wed, Dec 06, 2023 at 04:22:09AM +0900, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.301 release.
> There are 63 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Dec 2023 18:32:16 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 147 pass: 147 fail: 0
Qemu test results:
	total: 439 pass: 439 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
