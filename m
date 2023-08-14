Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A14AAC140
	for <patches@lists.linux.dev>; Mon, 14 Aug 2023 18:24:20 +0000 (UTC)
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-79095499a16so173094239f.2
        for <patches@lists.linux.dev>; Mon, 14 Aug 2023 11:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692037459; x=1692642259;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4ZDklDNQJpAN7KPXalyCNclz9eeHqWLCM+NxvkRxFaU=;
        b=N8H07U/I5GgzIPOK/S65R903olCLdbQCoQiVfM96zFvIejZvc9WeofRmF0Sh2RGzHL
         zCzXQx9wc9OX4cLfVps5UWq7AdjdiTuam4qlB8ixt6/0/a0iBUTs/rbVJL1m0/5qDUg8
         aDmPOTSThu2b2Svgde38PC/J/MIAaWZWKS0B64IKtJP1DpTlK2ZuNKll/dGiFQPFjyR+
         lT3vswl9TXWYeLrTE77QpaEGJrfXAV+8FjKd2JOIrbAOoHyYLtAs8CmsCNkLd9zB+r+c
         6MUDEV/qq33wTkk02gtwG2TMeV6R1IwoFAoJGquqWbaYi4/Jt5aTMSM2KnLrIABsLcHh
         PtHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692037459; x=1692642259;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4ZDklDNQJpAN7KPXalyCNclz9eeHqWLCM+NxvkRxFaU=;
        b=E+OKiHGIO5kXbUlZbR48H+WYkWjA9yJ8eEwelRj1qLZz+V7+BX43bFbU2iksfOZ59M
         pRC3jxkprGhrge5EPtTrhA/IhFMHupweHguKN+H1vdxr7K0aYp6Ur7dTONhIOyJNJW8v
         YOdMUCn7FynXZvMm0sJGcHvr1pS6J78mGHU5eF3X04/At/7t090wWvOS7DoOeMHbJcwL
         Kw095XrKn96+d95fRUmBvoQtWVMAzed5C8uBr/pq0OOPk+jnfOWSUmDgwOVrc8vRlPSD
         sloESnpbkjWeY9eQQFNT3a9Wdt/ZbfS7KwzD2QiARabr9SXBzssnzbRmFDyKE+4Z27/k
         F6dg==
X-Gm-Message-State: AOJu0YwySLsB+t+VhfOAw2a2OXOGkEHvB/cG1bejCutP+meOWB4Ehmml
	DCDasZkS0JRiO1lgi/x0+FU=
X-Google-Smtp-Source: AGHT+IENfY1ebaSlzPk7gUjp6hvKBvoVikVUlX5UkJWyd7QkXd7OH+A+7T2kh2EcgCiPHcNzRq+IaA==
X-Received: by 2002:a05:6e02:2190:b0:349:5059:a017 with SMTP id j16-20020a056e02219000b003495059a017mr17071139ila.17.1692037459496;
        Mon, 14 Aug 2023 11:24:19 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b9-20020a92ce09000000b003491422ca27sm3322585ilo.45.2023.08.14.11.24.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Aug 2023 11:24:19 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 14 Aug 2023 11:24:18 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.10 00/68] 5.10.191-rc1 review
Message-ID: <a6891135-ad39-42a0-a361-c94564804f87@roeck-us.net>
References: <20230813211708.149630011@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230813211708.149630011@linuxfoundation.org>

On Sun, Aug 13, 2023 at 11:19:01PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.191 release.
> There are 68 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 15 Aug 2023 21:16:53 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 487 pass: 487 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
