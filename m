Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9810179FF
	for <patches@lists.linux.dev>; Tue, 28 Nov 2023 02:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KGjUvIh4"
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-3b84478dd51so2985693b6e.1
        for <patches@lists.linux.dev>; Mon, 27 Nov 2023 18:55:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701140110; x=1701744910; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Lp7jSBC47fByZPGqr9EnpWb3tiu6l+5NeCMTHc/fUb8=;
        b=KGjUvIh4NZr2D3oUJsP8n1FX53Zu/f7zRiZPDJueQ4LUVQjn+IMd/ANthl/Dw9KtWR
         02SNso9eex3F8+Wtlts64acPdMGlLLUR8z0TDPUwJ5ExQO4qt06NG6Tn0ZFTNza1iIT+
         wiU8zO93yI2/LedxtQPA4I2WocWZGpehjf7HJoaNFD1jcPk3viHPUZxsD5JJvLJ7Ymi/
         GEiWjTLtdqTuwKgXG6h9hhIxZSSRakTJeRTWTp+Z9Xq5+vJcPaG0VihFAt8SgLtOioPV
         /+4qGJIQ12TrcAN1ccMfalndxaJsKcOBq48bvXpJx6P9fvE8CRXipL2dAtOl8xAwd6Ba
         OzVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701140110; x=1701744910;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lp7jSBC47fByZPGqr9EnpWb3tiu6l+5NeCMTHc/fUb8=;
        b=bXqT3HOwzPAhIH7R8X3AbjjInbaiENEKouG+1XjvlT6LRQ4h39L3oqh+VwElkDRAK4
         CS9/22m4ebWwZ0R8q7zve8GDfO4RAkO5H6UIvZVcOAoT19laIc4hQbfqv46EKvuYbx7n
         X6p5KHLhYDO5EBXfxdHnMUrU0Pf+I2N2BXjH1tf9vX6HacFyrx/ZKyOzhqxCVM/w4Igh
         PajQfxVEmkNLbJngc3vR8HRNsl4nxbP9Fhk8X9D8YbxFxieStsZnRyGx/Rae0a3eUHIf
         ijkNe9gHeAZ0x7TPpiJlfCmi/maTrcAEybpsFOeVGfzw8Nx3s2Zs4Vfw+F4p5FHZHXln
         LdUQ==
X-Gm-Message-State: AOJu0Ywx1bmV32Be4ToNKw/Gtw8OkH5FWbyvu+gGMTPmtdcY5vjvWwSS
	ISRm3wZbVN2b5HOxmfk1+0M=
X-Google-Smtp-Source: AGHT+IHDA2R8rulOPMAOxsdEnIk3WJRN0edoR9iYypeCY58pkBvNjGmIFmkgLYaa30fHO9NPbr9gLg==
X-Received: by 2002:a05:6808:494:b0:3b8:4614:8b27 with SMTP id z20-20020a056808049400b003b846148b27mr15019973oid.50.1701140110712;
        Mon, 27 Nov 2023 18:55:10 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id bx17-20020a0568081b1100b003ae165739bbsm1693498oib.7.2023.11.27.18.55.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Nov 2023 18:55:10 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 27 Nov 2023 18:55:09 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/525] 6.6.3-rc4 review
Message-ID: <5ce1915f-45f4-4191-8f3c-c58bed478beb@roeck-us.net>
References: <20231126154418.032283745@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231126154418.032283745@linuxfoundation.org>

On Sun, Nov 26, 2023 at 03:46:18PM +0000, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.3 release.
> There are 525 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 28 Nov 2023 15:43:06 +0000.
> Anything received after that time might be too late.
> 

For v6.6.2-526-g0f3bc3a11114:

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 530 pass: 530 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
