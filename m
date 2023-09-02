Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8212917EF
	for <patches@lists.linux.dev>; Sat,  2 Sep 2023 04:19:46 +0000 (UTC)
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-6bd0a96e63dso2130570a34.2
        for <patches@lists.linux.dev>; Fri, 01 Sep 2023 21:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693628385; x=1694233185; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d7S0xH93J57bQbZ8gK0TSumtLZ9W10T+zU+7G1px/6U=;
        b=Gq7jY7050yfs51lEw/0MeU+BKMofK0PTQ8qhXIrseHy271wiKiRUiYTm1+8IGXysw6
         Og3lA0IkdmZmTTNO/ajtaIc7nyFdaB2rYKaDD0Kqq8rSjR87jiIxKcZmUyKogtXaD6K6
         6clZZmuOPSiK7hoC4EtHK2yw7ZFgm4UcmB8bqcmdtriXZL1iR7vPxvXAXc0wJ6h4XAC3
         ykSbLbu8M5yF6jcj8mfPxzbmN/p2RF9ccuGpqb75j7StDhFJRX3RPjrDI1GixWHxXDS9
         kjCqayqret6dJiH0J7+Nbrk6rUkb9e2lh58ta23AD3m6BsCF7Bo2BXRR6QB2VDFV1jJU
         ydIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693628385; x=1694233185;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d7S0xH93J57bQbZ8gK0TSumtLZ9W10T+zU+7G1px/6U=;
        b=BJ9BFUE7mLAgeVa39plIx+WLGpHYQaKuCtmJeqUZsYP5LJDGj2j9YqzlLGBUFy6K1d
         mtx0SZ+NejngzGYnv6M1dcY6xOx18Z2/Jhzb2u8i9FJIYjUCjpnioAVE3UKZuSDeNtbN
         +C+X3329ThmYPRbf3P/YyVIefHbFU7l1oJELcT6SPJif35lt/MxCAGmQ6KXXPRt2NQIT
         7+QnzB970sP716v7ppB2eWI7Btfuanw6EE5EhX2iV/Tal21Bba05fJ8ulEy2aPuxAdNd
         zZ6BoVTAvEX67KxGD/tz0zE1IxszB3pxbortCFT5m1xNYQWovK6kW7ddAKBLlifB5Fj2
         lnaw==
X-Gm-Message-State: AOJu0YzKtXbjGHfLVX0tppTvW+aZ6cbxDvgKbpn/C4J+Tw2obc+SZeYj
	ecmI/Q21p/ZaNU/6GI+I0PY=
X-Google-Smtp-Source: AGHT+IE6GEQeoD25ayJeJNpJ2QZRre+vb/LDAWRd93Fydu+XeEcy0TpMJhgb1K8nCKQnBJ6qN0vefQ==
X-Received: by 2002:a05:6870:2185:b0:1bb:8d8f:9c6e with SMTP id l5-20020a056870218500b001bb8d8f9c6emr5169632oae.10.1693628385188;
        Fri, 01 Sep 2023 21:19:45 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w9-20020a02cf89000000b0042b3bf0baacsm1517014jar.138.2023.09.01.21.19.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Sep 2023 21:19:44 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 1 Sep 2023 21:19:43 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.4 0/9] 6.4.14-rc1 review
Message-ID: <dfd8aa56-dce0-4634-ab3c-93aefc4efd3e@roeck-us.net>
References: <20230831111127.667900990@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230831111127.667900990@linuxfoundation.org>

On Thu, Aug 31, 2023 at 01:11:27PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.14 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Sep 2023 11:11:18 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 522 pass: 522 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
