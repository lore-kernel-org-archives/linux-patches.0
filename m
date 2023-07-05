Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B2911CAC
	for <patches@lists.linux.dev>; Wed,  5 Jul 2023 16:29:22 +0000 (UTC)
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-56fff21c2ebso83364747b3.3
        for <patches@lists.linux.dev>; Wed, 05 Jul 2023 09:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688574562; x=1691166562;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c16g6eMzqCK0SYk6E8OGHHMajgzH6fmnjeBUQ9qrX1Q=;
        b=bPE06tzT9OGv/gvHDk6pbK/39D1ftHxybosER+o3UY6xLv6VUdQ8NcAxCnhJ8ohuZ/
         bDwms4xU0jKEljgLQaENLNB2yhwRrzh055FiiQSswtDrPhk3GKg++PWAfpWBQnINGO6e
         O7hRQfLesNM3LvU/dSJf1U2Yck2jG5Z2RWudM61+aZYcWwcsz04QWQob9RlSP7agcxzX
         QzNmsVWz0/eiuK3OTdm9/1yx+NrBBVD8KwM/nXgj+kIAov4K4rJpUU7Rc1+klb6rYfgB
         Bh4RHXBY93QnEO3XIj9v/z+pTyS7JxiqJr6VZxSX9rG8j+Yz+YhmCGU2F7Ghw0s82z2+
         BTNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688574562; x=1691166562;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c16g6eMzqCK0SYk6E8OGHHMajgzH6fmnjeBUQ9qrX1Q=;
        b=louOUP3g+aXyQ/3ZkvESLdJoTlVyPfvqWsG5EdN8j98aKYdiZVALGH5nrFq+QUZU7q
         9suyJp269YSua1ne6LahsilmWQhwKxUOjxCRNxyQ8kc5DhzgT6XrGC5oaMNnUMxXvLfl
         5+LJ/GeHk1PTD5a+ijc1lFhvozx6wnfU4Em1WiTNnWKS8xbVZWMqAeuCq/OzZswNEVQM
         APwB+dmDHWGYdmROacN/O/gZWl4CAq/ScjXD/uANlooyXT7ksTR4zIT54o3MlSOPWJ9u
         FM1nIW3xIkUWKiEuHSgbcSkcLwwbO/gHe8y74ReBe3KJV2RrfSU1fi+l6t+QndDuuNiG
         /3rQ==
X-Gm-Message-State: ABy/qLab08hp+bVPNx0MPjeK/6YrPsyptZfEJEMxZ1tBoGdt4fCSOIW2
	FX2TwvjK2lFQIOKD2jY8nKY=
X-Google-Smtp-Source: APBJJlF6G3bTKJh1S8L6KJXSj9demLxxrndPMJDCKh/ndYD/P7dJpc3qEHhl6Szwry9sbW0MrywlWQ==
X-Received: by 2002:a0d:e8c4:0:b0:576:d65d:2802 with SMTP id r187-20020a0de8c4000000b00576d65d2802mr15962556ywe.3.1688574561786;
        Wed, 05 Jul 2023 09:29:21 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g2-20020a0ddd02000000b005772154dddbsm3751890ywe.24.2023.07.05.09.29.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jul 2023 09:29:21 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 5 Jul 2023 09:29:20 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.4 00/15] 6.4.2-rc2 review
Message-ID: <7586bad9-06f2-481b-a928-c3fa2a182887@roeck-us.net>
References: <20230704084611.900603362@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230704084611.900603362@linuxfoundation.org>

On Tue, Jul 04, 2023 at 09:48:24AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.2 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 06 Jul 2023 08:46:01 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 520 pass: 520 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
