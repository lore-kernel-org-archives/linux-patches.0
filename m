Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C81077B
	for <patches@lists.linux.dev>; Wed, 18 Jan 2023 01:40:04 +0000 (UTC)
Received: by mail-oi1-f178.google.com with SMTP id r205so27503180oib.9
        for <patches@lists.linux.dev>; Tue, 17 Jan 2023 17:40:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Kxxd3xqe9c7nfQjsQfb2u+lISPgW9CFdGJBHNXsa12I=;
        b=lhrPFZ+V7iW7YE5t9PVcYLfGAYbd4HlJC6RK4v5DwsEVjKldo2M6wZF1Kj07hRl/Il
         dzQDvfIcBpCihnxGnrSYVDeigAKFHM4jA3NYx7ZKMbA2+QV45aEUVFCOyPaY0ast/J3y
         zKKL5ZQsZ1qrl2pabTYSxRR/u2KB3biuoKxwRa8r5U72bubq0ddmCyvuG6sKwrlRkY6Y
         cmPfmaL8qkTYnbqPhNG8ZHkM3Feug6IM/SV/4KqucOMxYBq1jSUtImQcnxN9O4oapKTD
         U/AdBVYgr7qjsQ5gLn5dSCb8tstqjY/UQ6Px2YUha/i/W3eDTtvy3WtmHSnTm1rtuQ1M
         xP4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Kxxd3xqe9c7nfQjsQfb2u+lISPgW9CFdGJBHNXsa12I=;
        b=goqsmbyye1sHr8M/5xiXJVDgv8Ycf24NZnobMI7p0MaPXDFjr/j23HdPWfP/Xf4U3T
         AgVZleljU4l5z43xGr3BhjwSYBxdj24+xc+26O1xRB1wSvxgyCFnW1F68BKLg+DroqWh
         31iWfZ/mo29+9bG5H5IIZyHNqnN/A4rOe3VKDNO53NXxYAGdOtzAsK39vaa+Yw7CTqAY
         3xtyGc+OfVUIUAezsRzzWklc1GxcStdfuPUjTPC4Ajv1UOuc7Z8gq9qAhpj9SLfUgivV
         hoBclkdgDkNAI3uZtdb7pfYZ4e3oIxedMIiysdcuwwDq1e1N6VhPhpPaiobW6saRL/Of
         jenQ==
X-Gm-Message-State: AFqh2krKHlSXI/UOsxVtLaKgWFtMw2GU0LdwMa6Om9rpvqbez+/oQ9Yf
	IJ/EPycAm6gj/COnTR4Nl9A=
X-Google-Smtp-Source: AMrXdXv4dCHXlEiFmxGcr2aZsuMqf9K2MlzBM9YjNQEgyRzmhETdhQGuVjBWFv/jm+ZJiFRl74sFwQ==
X-Received: by 2002:a05:6808:8db:b0:364:e248:1d70 with SMTP id k27-20020a05680808db00b00364e2481d70mr5564435oij.1.1674006003968;
        Tue, 17 Jan 2023 17:40:03 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id bk33-20020a0568081a2100b0035a2f3e423esm15351850oib.32.2023.01.17.17.40.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 17:40:03 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 17 Jan 2023 17:40:02 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/176] 6.1.7-rc2 review
Message-ID: <20230118014002.GF1727121@roeck-us.net>
References: <20230117124546.116438951@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230117124546.116438951@linuxfoundation.org>

On Tue, Jan 17, 2023 at 01:48:13PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.7 release.
> There are 176 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Jan 2023 12:45:11 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 502 pass: 502 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
