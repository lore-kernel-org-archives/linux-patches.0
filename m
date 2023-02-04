Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB167C
	for <patches@lists.linux.dev>; Sat,  4 Feb 2023 23:01:37 +0000 (UTC)
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-16346330067so11076806fac.3
        for <patches@lists.linux.dev>; Sat, 04 Feb 2023 15:01:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cVsHER4Yof2lEQueL0RY30lS4pwURHfmMFaF6gV4zLU=;
        b=AKHSK8YJPv5+ZblpmnNjZfbfGIygi+MUXqZwYQUoUr3M7DZYyshlclnDCBTwBiwtY+
         sFHe79+66hDBDiKYUHzbUqWgqaJrzRqoM04V3PtAmXlQ5bROrxvkJgqow1X7rlSTbNQU
         O0BxdJYx4PgLyUyyZNU4HZAIoDYmAXAQsdbqslyQDrpEmrO7A+uzlu4/B7SIrUh+iS5y
         mzc0z8kpBKcD/kaa6r5wWYHWewwByOHViJqDupa3uxXLTFfYiWJ72Bld8yrurLOFnghZ
         4atotDXmP7Az/sWBjgB72EdqZj62hsLS3q5EH81kdKQDWGTRSfq26ijM4V0yCGcFHVOB
         uIaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cVsHER4Yof2lEQueL0RY30lS4pwURHfmMFaF6gV4zLU=;
        b=OUNao64D+Rki5w+BCd1EWoE8EaEHwkDZKVS7jsMLXZeSEpccGQN/28Ck99Cil9G9ns
         9NKw6dwsnS5Xh/hoilSDeYF1kmljApXe9BZsXDJMYCb5VA2HNadJqOs2pkapAqplObW8
         23MRqeAfVo3T3gjX4TiVCfdMm5+3m8oJlwzXMhaIwjpD6g5EAq2s3ZW+LZjT6jJ5Zag2
         BCdGZagRyf1gyPNzSIUMmWbfb5DdRLSSOGf55lTRuzBxFNQIka+NAzKHc/R40Ui0QxsN
         P/nMJVUwe5+B1hHo2S8oENj0xq78yEPr6S/3i4lByF8UfNMrsJhBU6j3jRfOZAWz3bKW
         S8HQ==
X-Gm-Message-State: AO0yUKUFmONux7nB62XWPPDT4ewAaIH6PVeoZehAw04uVn2xgPufWR65
	a3MYG96pEV6aS6W1A4s4ifQ=
X-Google-Smtp-Source: AK7set8s0K8k078nldDtTg/8E3XYe4g3PJLVfwGzAGIl2kWCyreMQ3fCjWhjngjbdOmVmKar/JyPGA==
X-Received: by 2002:a05:6870:562b:b0:163:263f:84ce with SMTP id m43-20020a056870562b00b00163263f84cemr8367716oao.27.1675551696860;
        Sat, 04 Feb 2023 15:01:36 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j21-20020a4a7515000000b0051a5b963423sm1954928ooc.33.2023.02.04.15.01.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Feb 2023 15:01:36 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Sat, 4 Feb 2023 15:01:34 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.14 00/62] 4.14.305-rc2 review
Message-ID: <20230204230134.GA114073@roeck-us.net>
References: <20230204143556.057468358@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230204143556.057468358@linuxfoundation.org>

On Sat, Feb 04, 2023 at 03:42:23PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.305 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 06 Feb 2023 14:35:41 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 425 pass: 425 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
