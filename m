Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA19F33F0
	for <patches@lists.linux.dev>; Thu, 29 Dec 2022 13:44:08 +0000 (UTC)
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-14455716674so21700692fac.7
        for <patches@lists.linux.dev>; Thu, 29 Dec 2022 05:44:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p5TdyggQQ831ouqpy9GdepiRIBVOP4+BVRsOEdk0o6M=;
        b=XyxYblCiZYIjAfnLhUh2kjW/c9ssR/PFbnnsxxGBGgJETUFgP9SK9EnMI+TvkfU72Q
         8PmD3QHrKOfdW6M5Yv/HEqCjyvlB2pqED9h6Zgcl1OEij7dM2POWoqPOmtzRlvdl88yi
         VWhuHzhTnLEyGqraKZaDx9mJ47Yr8Q25x1ufPJS2SsizQi9jjYqEGWVbJ1hgUZu4pNEC
         mbZs4kJM78CmG1yZRzqp304kajshuszUUQ8hVB0MBD0hFYc54SesLDgtF+TgI8f89vQV
         JkzBsnJzIweoFbs3rCNWgmZDg7PS17xlh5QZjyrpvMLbVde8skWYKGmXMhc7VzMUI6NB
         EcbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p5TdyggQQ831ouqpy9GdepiRIBVOP4+BVRsOEdk0o6M=;
        b=JAWXoXSm/Lu6KyfrTv8+YL+e3uvY30NtojBhEg4/XDF/grDFIzSD9RD4GN8USAQnFV
         tfvtKbvxm/6Rwls7D8O8Q81KgciyWbN1KzxQm/8Y35sIalRZxR9bSeNG388Qw0AIByKL
         0F+AaRAxQ44N7K4NAMkhnLIJ5YKsydS+zRYLJZpPrA2I7H8n79rb/qXWXtytvhUDANpt
         UhxUlTAAoAjlzFsX4NL+5PoBzHpVPNEdMlSv5wW7F8h3yBZcO463MO4+xjdBuazabYIg
         ugFDH9SaDtdmuLn2WSjmJwLySAj0Ck8qUq0fTSxJhkUlI4rT5iu+jYDAJrGG3QBEeyt+
         2ojg==
X-Gm-Message-State: AFqh2kqLjFwo5Nm3AoBy91zasLYmuqWQRshKbtMJz/VbxPgdY5R/PA8u
	MhsTS4wq0Kc+sQx925AVZL0=
X-Google-Smtp-Source: AMrXdXtI/wi1CpRUU4wui3GW6T680nHk/LXELiCQc3j3TJAPRrBg910RqlomTfOYb2bwIq15N7pnJQ==
X-Received: by 2002:a05:6870:d393:b0:144:1a42:fcfc with SMTP id k19-20020a056870d39300b001441a42fcfcmr21118284oag.28.1672321447925;
        Thu, 29 Dec 2022 05:44:07 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l8-20020a056870204800b001417f672787sm8529365oad.36.2022.12.29.05.44.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Dec 2022 05:44:07 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 29 Dec 2022 05:44:06 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 0000/1146] 6.1.2-rc1 review
Message-ID: <20221229134406.GC16547@roeck-us.net>
References: <20221228144330.180012208@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>

On Wed, Dec 28, 2022 at 03:25:39PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.2 release.
> There are 1146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Dec 2022 14:41:29 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 153 fail: 2
Failed builds:
	arm:allmodconfig
	arm64:allmodconfig
Qemu test results:
	total: 500 pass: 500 fail: 0

Build errors as reported.

Guenter
