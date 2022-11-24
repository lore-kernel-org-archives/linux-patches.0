Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D63197E
	for <patches@lists.linux.dev>; Thu, 24 Nov 2022 02:36:48 +0000 (UTC)
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-14263779059so614807fac.1
        for <patches@lists.linux.dev>; Wed, 23 Nov 2022 18:36:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xGSTj1CNxP9OD7Gaq7hokMZxT8fLBPdy9uv3vJ9zQ2I=;
        b=gR/iyFQdEl29PJOXaK8phjF+4oy5R7htq+2ofBhGsWCXAspBiCjoFViLlzJi4qj/t+
         R/TD1taf7qK0eLTEYgb+eqs7PmISbzByHE8oXQ+LI6xy5/U+FgXdXbFRQyq1/xLuzn/B
         jzymDmcuvfkU29faWSmIdZzMmw2O/Drs9TP4ZWHKfikArizvj5iqmc3v0VdYrjihGbWA
         PVT/qnebzm+uhBVVbjtFq7JZsLK/1j0gZqv4pXqZv/GibCRkigvxUbJySLM/DgJQVuTe
         d07iFVGAwkEK7UTqM1zl4YXwX7fKkOZTyIKbQw02i2Hg90i1w5FiCGrggeSQMhmPNqB2
         mYtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xGSTj1CNxP9OD7Gaq7hokMZxT8fLBPdy9uv3vJ9zQ2I=;
        b=34Lx9c6rj8yggIoEF1APKz1L8UcVO53dW8A3gLWLksHTvrB17zvKfbxrGqp6RlP/fg
         oiVkvYQQUgA1C2aZ30ONJB/QikmdhK0pVfUw+Xt6ct966dMtJotWgPlHCWH9A5KtOaRS
         EM4qG46zkgL9mLbK2ezbdCx0YekOZSAOznPUV/eEquTgZ2r6kBloHxK69U5XsnHrHeV+
         g/W+Mz19Zhz+EIwDWtfuDW4SIAPFSPa62vZU0d/97OtMahGmRNTppfJ3sAc4TjZmicyw
         n/yuO1KMPpvn8NS7+f4hkXKwOlW2MJqxDbRPQjyXSxjvSx4IKIiNcT4Ch592YEmafwqI
         5tsQ==
X-Gm-Message-State: ANoB5pmjNJMauRSSsqG9I6xpSkhhUUpB7x/auhAtxHoOVyp4sb+Fv0kH
	yIzfDnRuX3svvXN20+GGFVA=
X-Google-Smtp-Source: AA0mqf63ryiDNShByjbNu2s2PvzAsd+Y3ODXQFdSrrXR4oNePankXbhXAYbHH3vX1wYpRgqLMfJL3g==
X-Received: by 2002:a05:6870:7d0e:b0:142:821a:590e with SMTP id os14-20020a0568707d0e00b00142821a590emr15549099oab.55.1669257408508;
        Wed, 23 Nov 2022 18:36:48 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s7-20020aca4507000000b0035a81480ffcsm7213716oia.38.2022.11.23.18.36.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 18:36:48 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 23 Nov 2022 18:36:47 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 000/156] 5.4.225-rc1 review
Message-ID: <20221124023647.GD2576375@roeck-us.net>
References: <20221123084557.816085212@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>

On Wed, Nov 23, 2022 at 09:49:17AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.225 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 161 pass: 161 fail: 0
Qemu test results:
	total: 447 pass: 447 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
