Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62C312B74
	for <patches@lists.linux.dev>; Thu,  5 Oct 2023 22:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KL37+KSJ"
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-351367c8fcdso6105195ab.3
        for <patches@lists.linux.dev>; Thu, 05 Oct 2023 15:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696544263; x=1697149063; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZMZ74v+Yhyq1HY+EmpusGwpg/BnsW21vrUBe3zi75ls=;
        b=KL37+KSJvQuGX95nUPhc4pw+oSlvFVzGoZWza2qZ112gwT2X7tRf+XdN6VRjqV8Lts
         Zc8PHLSe7KjklSv7CS8/ojxdz3tOnb7nA5bZR6d26MFuMZlTVjh1FMHRuhCZfMUjbW1f
         qZIHiVlCT6VJ5fQTXw+UZuMyKV210YDxMvUO3Fdt8LZ8af1XX6P6Bui23fdfg583U/Yo
         6mzFIYTXbEqlqhlvwuMFGPJJW8g081WHB8b7rI2R/9FMqCB9Nh+9vzrovDJhIqUC9RHQ
         m2lC+qEgXgpXeT6crA16NtrWivd2JWcvyQJfamAEQSP4QyhzUJsGijUDgUeUaJIl9Yc2
         77Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696544263; x=1697149063;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZMZ74v+Yhyq1HY+EmpusGwpg/BnsW21vrUBe3zi75ls=;
        b=F+cGl9b20kqKhpTIn3ermKkj4+FrmnYqicwMIhHhM1USDtyBYhBXKdjeLGwRCa0GNi
         mc6nPpCCKEQQv0WvyLLVu+130OBBTdL5deC0QrDbznwb9mSt3VbnnvmWEJtckh9qWqa7
         Wvgmg5TRcCmZzEQtllTfDFkrvcy004tT1HuEHz0i0uxoPgj2zEXG5hfyq9rQj2AXqeAO
         S/0DS5m+SHIJZe0gzU6hwdrlB+kTevSoWUIWebN+GJEHZc3XjByXQaoiy/dcAxU6skou
         qoEDTddI6JYn1xqnFdSOAvLuKtHi1gl3SEDxlN+G4M434CmVUBWsPKiMIXEDjG1cgf5q
         bM+A==
X-Gm-Message-State: AOJu0Yy4uKD/c0w4ZttdoT8jNyAVq30Ko/AXPmuW/p/adqb4FVI+tKOp
	01U6o/i11uIcwAXEavNhRQ0=
X-Google-Smtp-Source: AGHT+IGUGVJz/GNNgv+cXAuGwffVpynGpod5hzwXjfvFDEGr4+P5Kypb4VCM+EBlbmNL479zwOftpg==
X-Received: by 2002:a05:6e02:1d11:b0:352:a306:9ad1 with SMTP id i17-20020a056e021d1100b00352a3069ad1mr7957475ila.0.1696544262787;
        Thu, 05 Oct 2023 15:17:42 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c6-20020a92cf06000000b0035262e1080esm677764ilo.0.2023.10.05.15.17.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Oct 2023 15:17:42 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 5 Oct 2023 15:17:41 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 000/259] 6.1.56-rc1 review
Message-ID: <1c112633-ff1d-42db-a1f7-0c6b218d2eed@roeck-us.net>
References: <20231004175217.404851126@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>

On Wed, Oct 04, 2023 at 07:52:53PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.56 release.
> There are 259 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Oct 2023 17:51:12 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 155 fail: 2
Failed builds:
	i386:tools/perf
	x86_64:tools/perf
Qemu test results:
	total: 529 pass: 529 fail: 0

Guenter
