Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25A7A95E
	for <patches@lists.linux.dev>; Tue, 12 Sep 2023 19:49:13 +0000 (UTC)
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-68a3ced3ec6so5321591b3a.1
        for <patches@lists.linux.dev>; Tue, 12 Sep 2023 12:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694548153; x=1695152953; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zXtz6kUeyzBvqA0abDYiD1qX4EoG1vT0PHAg7mdRrOA=;
        b=W+bXH22GPluoXE8HBwsrU5+J7U25pDGr7Vnf7XWCgXDD3CGEKsMHp9cNz9RZ+aI1/N
         q/BHzFDfmWwxYwb2jlmbQINVcoCsQ5zQXpS8nIFzfcMJW/h8FQqDnLwoowRn9FyfzIRZ
         FFyDJprApzLD9Ifdzlhw2N8N5BXFDub4+2neb+4Z4juNKXEgDqzwm0PoNhKrazJk35lU
         sABmdCRUfQkb0eT3VtRYcyeu7x1121l3m53mVlmR1cU392yaSAeD0wUbi2uJzlBK+upO
         uOKXScc/2x0SHAZlpYAwDiYySrFrOZlfilKbDxP5fS6yt1qeryvgnkrdtg/s474i3y4C
         1prA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694548153; x=1695152953;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zXtz6kUeyzBvqA0abDYiD1qX4EoG1vT0PHAg7mdRrOA=;
        b=UYqyUAPG22eQyZ0vrCbyAOpGN5iYxDJ6a3nGO0uukZ5sSDlAXY2Z6yHF6PfmBwpr+8
         qWKYHkAAO38ufVzIxvKxL74ZAejeFPZ33TFQpVFuitX//Hyf8d8O3sxte0s6pDM9cBuX
         7Upn1D7giDx3EofcI7dYwOQDd1EDUoQs3tvIvPAG44AAOO9BJzwvHcPUrFSAJhuau//2
         e8L1gOHk7+DI+gmn1oWdwXp4ZxlxD7zSvj5BL0II1H5iUXvvc6K/B2mNa/sojkvL5V5n
         JjBZEUfcbqS2YdEDWMIDh/t7Gp53ySULT096vdokJ8tfebkgwNhhJWfkbmIERMmXQ3sJ
         5oKw==
X-Gm-Message-State: AOJu0YyHtcPYtAQY90xvSQqh2nD92Qy7Ktna9rdmv86olszj9Wed3NAh
	VXpA+snBWcqGlO5b4pCOw/M=
X-Google-Smtp-Source: AGHT+IGQGAAlkxVcbXgpeRdjUlyV5lOAHgZaQ4fT2dRzL337/7ncDt/qjvZswUeNAvL7v0AnlIEDWA==
X-Received: by 2002:a05:6a00:248a:b0:68c:dcc:3578 with SMTP id c10-20020a056a00248a00b0068c0dcc3578mr832412pfv.25.1694548152785;
        Tue, 12 Sep 2023 12:49:12 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id e9-20020aa78249000000b006829969e3b0sm7713640pfn.85.2023.09.12.12.49.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 12:49:12 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 12 Sep 2023 12:49:10 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.4 000/737] 6.4.16-rc1 review
Message-ID: <9becc541-29f1-42ea-8b7c-af5f64d8bcf5@roeck-us.net>
References: <20230911134650.286315610@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>

On Mon, Sep 11, 2023 at 03:37:39PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.16 release.
> There are 737 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Sep 2023 13:44:56 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 530 pass: 530 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
