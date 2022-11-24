Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C267E
	for <patches@lists.linux.dev>; Thu, 24 Nov 2022 02:37:21 +0000 (UTC)
Received: by mail-oi1-f174.google.com with SMTP id n205so340751oib.1
        for <patches@lists.linux.dev>; Wed, 23 Nov 2022 18:37:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dOr7hS6kCz8bfDkfaoa3RQ9RQBpOFJbxgrrQiNWeWfQ=;
        b=ce1V6RurKafMdFGURc9GX8hSOEQfJHbwfrf5SyqVr3rk9vFSja3VMjVCPT7UV8TDyd
         zfXDARhJZ+T3kFQXjcOQXjTkia5oKA/FV+KaLHEMX6jzIuqHcmTXQRpdaS3D0EWyeeHE
         6Q8J+sqAhmM0Uo6k4wOehNEOf+k429gBciDIeKHtG18k7UHmf4SzFBU4Rg1ZHp09fGQA
         vH4bS4xawCkVtwcRaD6qCA5KNLXaBYblzt5RL0+irw+AqUzZAoeNIRyu8iBmRs9Fvg4b
         zJr49WOttx3gZJXsjjORcfqYMpePy+9yu62NbM3s81TAkC1mcheHi+UA/QrF8ljvsDct
         byFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dOr7hS6kCz8bfDkfaoa3RQ9RQBpOFJbxgrrQiNWeWfQ=;
        b=2kHiowIp7pkIfTip4ExcF18cRUgEOlEIqNS1/W9ItqVcTJhxlLudnQ6DkERpU6EVBZ
         ZK7XOeccJcAmrK24FTKttgXNVlgPeDT0fV4etpc8ygq7iax1A3S/+V+XxfEhAcGpADt4
         InLPo8zfJQsx2jkcVuMAIdu5UbcVgwPX6VECOev4nlzDtuNL/X6HGnPI/RSbDkbMjYx0
         y4NQ0Pgj/OzfIM/0TeNO7gmbUXLXB9e3Kce3JfvQqcn4Nqpy0JJhY3FuBHtxOIXmoBoj
         P4KwsRwcVDQEkhk3e+wxfaJvzSz9fEgJ2Jk7MauakJfBPEe9ASEP0jStqInH4SA99hCX
         222g==
X-Gm-Message-State: ANoB5pn8PsqHX1mH1PGLKJM5HPXdXDycMEc6fjlZPoRxZpJBdujY5yLW
	8j4cEqjAS2+Qlwzy/mBqXW0kzCEBBfE=
X-Google-Smtp-Source: AA0mqf726kfRM60ypC4Yhn3kXbY9mMqf7W58ljcoLHyQDZnURHFng7fkTSAomOc8hXcfNObMshegpQ==
X-Received: by 2002:a05:6808:f8e:b0:35a:6005:3d90 with SMTP id o14-20020a0568080f8e00b0035a60053d90mr5400422oiw.127.1669257440790;
        Wed, 23 Nov 2022 18:37:20 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q11-20020a9d630b000000b0066da36d2c45sm8101067otk.22.2022.11.23.18.37.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 18:37:20 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 23 Nov 2022 18:37:19 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/149] 5.10.156-rc1 review
Message-ID: <20221124023719.GE2576375@roeck-us.net>
References: <20221123084557.945845710@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>

On Wed, Nov 23, 2022 at 09:49:43AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.156 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 475 pass: 475 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
