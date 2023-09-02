Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE65217EF
	for <patches@lists.linux.dev>; Sat,  2 Sep 2023 04:18:32 +0000 (UTC)
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-7927f241772so94617339f.1
        for <patches@lists.linux.dev>; Fri, 01 Sep 2023 21:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693628311; x=1694233111; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y3ZAPzm/byo8bzgvBVYJx7YzDC8YUFaNQJpcKMLs7GI=;
        b=Is4rIIynAmJYXE60qfBQgd1GzAqtYFTG1ibcY26EPK39uJ653aNuY5+17iyrAWxVba
         obIqFPfgw4VIadTHaMrHvFcaLOFdrUlwzAxX7hVTLxsy4crKmnsa5zsqLHk8OiHOQAiR
         eB7ZhJvBeiYeBGyuxZV/13yIVvI3rKzoZDYMWp5PDaCryvpZJDOIRq/YoR45MihqvT5l
         2h2koyKr1UQMI8niDYLT0JcBa7yB9FP4Qp+6I5XkcpcUZ97ulGxIoZxdFdq2OrLNmF8P
         C8ENETFTPTr1ZDEhkNKNCWS9VNl8dvcSEA94j2un1RtPRSUXdNPLVfcDMJD7Y2IR+eWe
         SVVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693628311; x=1694233111;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y3ZAPzm/byo8bzgvBVYJx7YzDC8YUFaNQJpcKMLs7GI=;
        b=M11zW6p1hWt+ZTen1Q2lfZdgeOP6phocGaXLZE8+G7YVKHohcfhuIpYPtD7uS3jwHs
         zn7DghtTZiil694PkV5e4f3FcT7ZWUTNyfq+Lz7gVBlM7B37LO6p7ZxdUz2s/eaMkcP6
         pyXOA/AoEl/uNHuB0df3x3i0x3kczc0GnM3EpqwKxtPtfmUK3jY0Kq7Ll5uzgXGEhLzm
         xobeeisjpJ5pcJtU19wKpsI+i9lC6s+j+DhGI/3t+bVQKY1FRSgDT/7DaCwcp6lbneZG
         dYPe2NS8BHmDPtvJJJyNo7l/uOFuKykx/Re8FQVPOynbE2pD3RhGhz+0D7qUrOnPuvDH
         6PxQ==
X-Gm-Message-State: AOJu0Yx0UhEC8xACcplTp7wP3NT+VqhaDU0659JlRJ1qFQbWbq+eDyv2
	CjzbpPWhSNvS/j9VWIj50Ow=
X-Google-Smtp-Source: AGHT+IF2S0GeWeACLiKFPmwSv2CL9gN/paNG2t2aH21/luSmnw8w31dIwOrbMXIGpPKbBUXzg5iVyQ==
X-Received: by 2002:a05:6e02:1b82:b0:349:92d4:bfed with SMTP id h2-20020a056e021b8200b0034992d4bfedmr5608533ili.18.1693628311338;
        Fri, 01 Sep 2023 21:18:31 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id fh2-20020a056638628200b004302760aa6bsm1552793jab.4.2023.09.01.21.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Sep 2023 21:18:30 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 1 Sep 2023 21:18:28 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.10 00/11] 5.10.194-rc1 review
Message-ID: <604baaf6-fd80-4ea5-a52d-27d2f4df50d8@roeck-us.net>
References: <20230831110830.455765526@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230831110830.455765526@linuxfoundation.org>

On Thu, Aug 31, 2023 at 01:09:52PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.194 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Sep 2023 11:08:22 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 487 pass: 487 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
