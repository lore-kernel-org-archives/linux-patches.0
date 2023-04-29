Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8258A17E9
	for <patches@lists.linux.dev>; Sat, 29 Apr 2023 04:11:34 +0000 (UTC)
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-63b35789313so522838b3a.3
        for <patches@lists.linux.dev>; Fri, 28 Apr 2023 21:11:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682741494; x=1685333494;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uM5ip230fvATVmYJPL2FSyjUbKLn9DaZqVGs1xpi0Rg=;
        b=BksPkaF0efR76Dr9Ie6iPQrdx6ISDdtWMBi5Qcr3Xs7zU9kIMwI9ZJAoD0FYdFLA1F
         ph0KzvWRdsKX2slYiUOEYV4tU5FSBnAuz7cNvqFNgUFT2nr/cxrx4aX+YwkoPfjRJjYW
         GdBiP5NfpdTjG2jjBLyzl47iIP8S8b/OWNLawck76Dl1HrgHPejZKYJiw5Dh99PV3W/9
         At/wDAyA37RQq/qInywo4VgUI/ADMJ/4aj1QnyGvXNJAsm3/nhMdl3SHK/aCYlkC1WJB
         +JXUhc3tRQSG6p7JHFl0nMHQ0k6ai9Q7IIWz2MojUjUrTyLz9VFxKehZTrEkbylOHzIo
         zyBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682741494; x=1685333494;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uM5ip230fvATVmYJPL2FSyjUbKLn9DaZqVGs1xpi0Rg=;
        b=SuY/FSn9lCdp9xPoAvcLNsyLc5Y5xBIFbMQsdXkNQDGo+qD45i7EP6OQIRfuMdQwI1
         myxzykyDTaL64ySD3bu7OLZm6ShB5ljKpvnWCj/8160JTV7jEkwgN6i+LcbDcjeJiE+W
         EipkHz7bL2fIkQqYn7VPiXb5xFN+OIFhNyXu6DCaCB7WMZ3bOIcs9cnNqgvWt0MuWlVQ
         nXW8O4tXJ36bUl05Wh/zLsyJvHV4bpc9I/GmnoqxFXX2V6qBqOikovVm0Sgue1DDcyKw
         45xma8ZNejwws7DprRKrGUGwxRBN222ST4nu9JgQE2ajQNVw3fLuBEQScHdLiFm3NrA5
         dA6g==
X-Gm-Message-State: AC+VfDwg6iOvNegK7Nhm9I0GS5enFYamzHy+3WNWXeCXvek1/qQBL7nG
	ChrEBO0151fne/+RNAdgMXM=
X-Google-Smtp-Source: ACHHUZ6Inn8+YKKAvslaBaLlFpQcEWOiDz02qwGoOVyKUKvhXSxgQY01DkkgjizxtNS9NVfSncl3QQ==
X-Received: by 2002:a05:6a00:10c4:b0:638:edbc:74ca with SMTP id d4-20020a056a0010c400b00638edbc74camr10250690pfu.0.1682741493979;
        Fri, 28 Apr 2023 21:11:33 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u20-20020aa78494000000b0063b7c42a070sm15944038pfn.68.2023.04.28.21.11.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Apr 2023 21:11:33 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 28 Apr 2023 21:11:32 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/16] 6.1.27-rc1 review
Message-ID: <d85a23c6-8146-4f80-af05-c1b5abc907f1@roeck-us.net>
References: <20230428112040.063291126@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230428112040.063291126@linuxfoundation.org>

On Fri, Apr 28, 2023 at 01:27:52PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.27 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 30 Apr 2023 11:20:30 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 519 pass: 519 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
