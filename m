Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39152EBE
	for <patches@lists.linux.dev>; Thu, 27 Jul 2023 00:02:26 +0000 (UTC)
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-686ed1d2594so398921b3a.2
        for <patches@lists.linux.dev>; Wed, 26 Jul 2023 17:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690416146; x=1691020946;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T5wWjdrwKhVRVEE6nQr8L88YliKH3+1GB9KWcwTuWbs=;
        b=a9hgsVAdwLsCgAg/5xgi5IAvJPBN48C1EUx+SCnSxz85ekjTrxZkaZp9R42tJMgSjO
         oJDap7cN22A9WEhQUWDBIf5RlLB6sTvkq+nAenxcHhIe9PQQYb+RXsbVExiQdToH5PIQ
         JOarIyjZqtoKV1WW8GHYoSn+d6YYn1snZ7IEopqjgbL9fK0USH/pokwXoFC2YugGbCP/
         F4Jk33mnuVA9XwkNCYJ9BZKrjbeZVVthpZ4z5bSnSVcU7SwpWxB3Rc6kab+i5mrSyewY
         zNuepNNv6DgUYedWUnAQb29WrlLtkgIoEJa2lefMdat87wC1oNvXA8IeKE/02UkK9Iya
         IqHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690416146; x=1691020946;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T5wWjdrwKhVRVEE6nQr8L88YliKH3+1GB9KWcwTuWbs=;
        b=J+waEXwX92s2G5EFrGrL2AyVIuSfE7iJtHcZ1kI5zsKUBgHSs2Vb/K1NinHk18ajBh
         mBnk3eFhIX3sok0KDVNH1M51Edxy+oZlAsD5bXBncnlTuY3/WeFdc8H9SYFrfkhMz4xT
         muDGrQLiOrjhJQyTxOVCN0tqJiRvCGAtbkYXQB0A6jmV8M1gN85ZfXKFbNGS38Qt1Pb3
         ZCkK+45fH9aVzpPsEda63x8bVgBLyR2rFXTyWthizUdX/81c9hVFITfnJbuESWKc7Em2
         ZKvA0HVhNXlsOQpS47/px6ONDZ+aMroYC7oxaNwGHgBEa/Pt3Uum0G3yQ494xUtPl8Z1
         9IAQ==
X-Gm-Message-State: ABy/qLazdPMClrFLlloAiLDQUzeLNKA5mxdkA54jGeHsLoLmnc2IuLG/
	yF5XriznQAOEmGNQga+cz/4=
X-Google-Smtp-Source: APBJJlEX3tbTv3XuSjbLHFzzYqV6bEk5Pdr+SjNgG6iRnw2HQyDwehAtTdwxG2+SmSUMACmnGiNDpg==
X-Received: by 2002:a05:6a20:3d10:b0:133:71e4:c172 with SMTP id y16-20020a056a203d1000b0013371e4c172mr4484438pzi.15.1690416146378;
        Wed, 26 Jul 2023 17:02:26 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 17-20020aa79211000000b0066a31111cc5sm154771pfo.152.2023.07.26.17.02.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jul 2023 17:02:25 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 26 Jul 2023 17:02:25 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.15 00/78] 5.15.123-rc1 review
Message-ID: <5f0df923-d2c7-4e0e-8715-fff8d6b52aeb@roeck-us.net>
References: <20230725104451.275227789@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230725104451.275227789@linuxfoundation.org>

On Tue, Jul 25, 2023 at 12:45:51PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.123 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jul 2023 10:44:26 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 501 pass: 501 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
