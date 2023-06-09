Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6BF64A
	for <patches@lists.linux.dev>; Fri,  9 Jun 2023 00:26:09 +0000 (UTC)
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-53f70f7c2d2so227258a12.3
        for <patches@lists.linux.dev>; Thu, 08 Jun 2023 17:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686270369; x=1688862369;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SsLHpUV3U4RHcYmttv82/JvsSyFIcyIPeIQmZazPerg=;
        b=JVxMAS5Rql8+6bB8cFnlTJE1Y+0PDTB5UwnRSgYerzJLulSMpalR6I9yuAcrJp2oZG
         pyktcLw+3fZ6jEQx9/pTy5xKcYdSTO4jgULDn0kS3QgFQ68O9oouVPSDfGhPGqyBtK/t
         s1x53uaxxiVHwYGaLoSPg4ZRrcAxJdnrKLkRIiNMgAaDOr3ekZ6GOX2JWE8n721BeJc0
         bKnKNdgd2P7ouW95NZPekHQaIYaoeLoJnIwoHhg6hi8gYOluOWmJ3vMGPgnWJMnyppgw
         mOZpLLgzrdV1Yn213xCgdn6CtR/7I1GiyinI6EWoR/GgCQSLtIWI9wSG++l6V6XaYFDf
         fF0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686270369; x=1688862369;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SsLHpUV3U4RHcYmttv82/JvsSyFIcyIPeIQmZazPerg=;
        b=Chs68BaM8j/xQ6kEcONk4kuVT0G+jRcQ9lgwHBMbIJnjF2F4KA9eZ4GFw10L7vfGII
         BJvPRPAkU+6ExLZpIWeuOP6g2v6uQQ+LxHm1PbGXYZ/4hU7uh4id4iWCBLA0c9WaZR/a
         yo9rgPkWRF5miyk87F4Pt7Nvdk8ddfhoK381oqyX94eu14/m8hv82K9ZQJlEzLij4zd5
         ov8SAx5XZAG1C2Ni1FW77IhWYmOI2m/MbeBF5SF77wtk3Jw0WlOm9GK8dmMMiRYjTaEm
         1XDvmHck59+ELz98r30Gw0ruxoA0kWgOXVj7ulTySQtMJRiDZur2PTK19CZZh0a0HWam
         VaUA==
X-Gm-Message-State: AC+VfDw8xn4XO1wzqqenXfXMigO1DvXN4eUley92no4QsH66PzKMvS/b
	L7FqsGcrkNkhomB4O8XonT8=
X-Google-Smtp-Source: ACHHUZ5RHs5idAHmUIW80YZUdFMTvAyPG7GtZS73qmDLkqkEZVWKhZn3UsojLdEcAAL5NpXAKUMBew==
X-Received: by 2002:a05:6a21:6d91:b0:10d:3ff2:452b with SMTP id wl17-20020a056a216d9100b0010d3ff2452bmr5743417pzb.18.1686270369049;
        Thu, 08 Jun 2023 17:26:09 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s64-20020a635e43000000b0053efc8ac7e9sm1771643pgb.29.2023.06.08.17.26.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 17:26:08 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 8 Jun 2023 17:26:06 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.14 00/61] 4.14.317-rc1 review
Message-ID: <2ec644ea-e58e-44da-9bc8-25cf9a942714@roeck-us.net>
References: <20230607200835.310274198@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607200835.310274198@linuxfoundation.org>

On Wed, Jun 07, 2023 at 10:15:14PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.317 release.
> There are 61 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 09 Jun 2023 20:07:31 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 167 fail: 1
Failed builds:
	x86_64:tools/perf
Qemu test results:
	total: 430 pass: 430 fail: 0

I don't know what causes the perf build failure; there has been no change.
I suspect it is because I recently switched from Ubuntu 20.04 to 22.04.
I don't think it is worth bothering; I'll just stop build testing perf on
that branch.

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
