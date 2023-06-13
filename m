Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324B31361
	for <patches@lists.linux.dev>; Tue, 13 Jun 2023 23:09:21 +0000 (UTC)
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-665a18f5643so1745403b3a.0
        for <patches@lists.linux.dev>; Tue, 13 Jun 2023 16:09:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686697760; x=1689289760;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IatuP/RDnQdoeSej9nA4a4h6poVVsV21jA6QdT0KSvA=;
        b=AlxhtcdUzBSfoWiWYaHoSWjSxVYya0oPVN+K0WQ4WHUWKCvPaWc4+KrPEGoaLMf7Av
         KzUmZlK0GqrsQelDNDiMk5oOsjpOs497Xj0TbHlmBJwJJ4bMmhDqvNyZ5UVsNiPMuFr/
         hTEwTQ3rN08Gja711OBMQZUGmdwVKpqmPLA7IcYzmtLXL73wl7Qpfxo7p8lIf3Gp7lFV
         J4zaDDArTpSpGBxt/JvUQvCAEJsNxMZPh/sHh1DUEU/dEQtU9KW9SpX4uSKfQiMcmVo7
         pXPm3ZpXFGA2eWqvDc1mkpRu+J6nj5pp5bG/on3T5NsdjDZ/sWXlN4p9jKeNfQNjPVW/
         0j/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686697760; x=1689289760;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IatuP/RDnQdoeSej9nA4a4h6poVVsV21jA6QdT0KSvA=;
        b=hqbMG94ZA8wB4fuVWqljkIcstaIyJDj8JzKub4PxGcroaEfAxGk8T+d1Q9VGv2uUiX
         gSNWKPBKE/uE4KRE2jTIarFhdWdGFZ0U5ZzqbduK5do1qvAO/vQTstldzo8i9zM2z8zo
         6GUfvBYFFuQncu/dAf1wxmzum37zskXNPmyNefyAB+TDEjEJxJwzU/xLxYFK9MfT5HcG
         it5Q5e2E/mKwf/Hm+JiHKdIoH3utIKC/XLnz7oMTq8hwVGoq+vcu+jYZAxPAEbU/gZt6
         PyQIGMXftLKqySEiq5OkNrKFhRMsf+0QZMvI3dmBrmECfgc2a4mg/rlQ4hbIbpyxWfPx
         Gf+g==
X-Gm-Message-State: AC+VfDy28F3OvsICNfMr7IUqztqlTjsybM6NzbC/w8f6EjoGJfJ3mMJN
	J3lqpuFReDh3mAbJGdw0Tak=
X-Google-Smtp-Source: ACHHUZ7mWOoEGpFP4xKnizuy1KjMJQWYCAifyI5ZnxV2fbP3ZNi0aU9F6ElEOODsXRGwi/24MTwBog==
X-Received: by 2002:a05:6a20:12d2:b0:117:3c00:77ea with SMTP id v18-20020a056a2012d200b001173c0077eamr47033pzg.0.1686697760472;
        Tue, 13 Jun 2023 16:09:20 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x52-20020a056a000bf400b0065fd8075ba0sm6108588pfu.212.2023.06.13.16.09.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 16:09:19 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 13 Jun 2023 16:09:18 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 00/45] 5.4.247-rc1 review
Message-ID: <5d660acb-e5c5-456a-b4f3-35c93e0d2a10@roeck-us.net>
References: <20230612101654.644983109@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612101654.644983109@linuxfoundation.org>

On Mon, Jun 12, 2023 at 12:25:54PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.247 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Jun 2023 10:16:41 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 455 pass: 455 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
