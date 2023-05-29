Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194A879F0
	for <patches@lists.linux.dev>; Mon, 29 May 2023 17:34:24 +0000 (UTC)
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-256a41d3e81so355001a91.1
        for <patches@lists.linux.dev>; Mon, 29 May 2023 10:34:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685381663; x=1687973663;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wjXhXfKhF2yk36YQMCuS8AIma0LdxrDbNwpb9Q4Wbp4=;
        b=P4cNhvUPQQrPZ27uoNkGo6AyGHJtpXLSkcnhvCAk4czGo5S5rev3y4kaUEBHOp6T85
         HGUJPFyWPt90DuSjjbv1Z3nQHvSQRfx65OHpfnBrpb+RUKF7i2U3PkRGH0f1G3FtFE4k
         MsE8xSxZka1KjHDav9yn0kYCl9x1PhxxIr83/44H/gdgfkn/wmbVbXuf3AZtLQ4JLHSH
         NOktvReRq3IsCtUAh5N+chWtKpsVIiXZYky00FZkS5j87mFDfK85NOCrO/RmUrjM8GwS
         +0xTXJGTNyuehR5XdSItokcBM2HvNQGMsuN+1aE1r6Jg5vd1DYwbKat+J/AnxVs89X3A
         N9KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685381663; x=1687973663;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wjXhXfKhF2yk36YQMCuS8AIma0LdxrDbNwpb9Q4Wbp4=;
        b=Z7dKgLqiduHfWAkLvuk8IHPy5nIHt00dLQNi5SGDMvc1tpq39T64jvpFZXWc9lcpJz
         jCWQuGwgIPGaJtpYyuNpjqgAKizCbNjV4jinhLZfbetZTBozwkElxzP0cAinaSriUSN3
         r5UXzL6qPpIxcTjkXTAhrEKcoawTmHl2HjnhM+IlEwxzG2Y0UfE9sRUS1gIZafSnm3qd
         qW7jdTOymFvpl4cVQHj/2kz43umkIs7GtgiH6KK+Upa9DyAhJoUNyjxBJ8Jd5MljXy/g
         hYIcnIjyia0jIeBIDECl6bn4RjFASog75EKvn4UHtcxb+eyjXaw4/q1A6Uk8J92lT050
         jK8w==
X-Gm-Message-State: AC+VfDw+kl111vRsU8L3BFu0AdjV9fN7xyACZtmd+y93+VyKNtbqhauI
	+WSmj/DdcvNjrkcajhYAg8w=
X-Google-Smtp-Source: ACHHUZ6sPom/NcIrUcHdPzwJWrwk2F9VMAsUUJ1L2FYw2L/0c7UeGSjOZM9kKjWHoh+5L2cezAcRNw==
X-Received: by 2002:a17:902:6bc4:b0:1aa:cddd:57d8 with SMTP id m4-20020a1709026bc400b001aacddd57d8mr10626402plt.30.1685381663435;
        Mon, 29 May 2023 10:34:23 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c2-20020a170902b68200b001aaf2e7b06csm8451575pls.132.2023.05.29.10.34.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 10:34:22 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 29 May 2023 10:34:20 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 000/133] 4.19.284-rc2 review
Message-ID: <371de68a-36a9-4b87-a847-f8fba1516a23@roeck-us.net>
References: <20230529153919.729418186@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230529153919.729418186@linuxfoundation.org>

On Mon, May 29, 2023 at 04:40:38PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.284 release.
> There are 133 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 31 May 2023 15:39:00 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 431 pass: 431 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
