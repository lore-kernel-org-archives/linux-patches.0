Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6358AEC3
	for <patches@lists.linux.dev>; Wed, 21 Jun 2023 00:39:37 +0000 (UTC)
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6687446eaccso2615874b3a.3
        for <patches@lists.linux.dev>; Tue, 20 Jun 2023 17:39:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687307977; x=1689899977;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kH35UreoOLAI7AawrIwf/RQ6GEC527GKJ67uTzyFpEk=;
        b=Tuq+knsGDvhVVnmMBJYyWidndARcXkKhQWqhBhbR07ZRjAu1YT8M9+cFIE3zTmR9zA
         grrclbAQ+cM0y+smI9+13t/O/xsv1G7Q1aTHWjPJy2/30wq+T+M8y6YF6qgYRWyA9DBM
         XbXFJ6Cw8/bMbNnA/NZG+gh5SNvKFHKf6SXF/4BormdarJKjGrTfzf99I0HR66WOett0
         iKdFRGvILf6iUa6oO/aYciEvAB+nO0p5uyDqoNkeabfOqH2EN5fopystJk5Ae13qJbU/
         ZvtpHezv5PJqDsQhlOt7ojV0Ctk7aOHYo0nwItjkp1lQaCrQ0Wvmw9PDtDBA6RQ0q09V
         4hMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687307977; x=1689899977;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kH35UreoOLAI7AawrIwf/RQ6GEC527GKJ67uTzyFpEk=;
        b=StrGPJxuFLRH2kBCqmFj8ZdRxdRXyHlprNs9tXy/Eq+gK2q45XJD+COckFoNMgiZlZ
         IokxIuKTEG8Fgghy+j5Pw/L14cQrSpZCLsv82JbeEqQKBvnAaarpPeQQZ3Q9WxlbXb+R
         gh9B8ZePMfpbeFCXYBI10CfdJh6J3ErfWNMJLsdX7SV+VIA6JFeaXYRNC8MHiwDgSX6b
         h9S4UhTPTmFi7BPPylQeH7S9BVh0Dv0Rjq+TzNaKFB8VU67JPccLZL6+X6kJsWKeqAlN
         pKsFh1IBmZTfWK1XkReJ77V4vGpgoj+g9fjLNonTCe1J1vN0Y+VF4mT/YWjF5l5h3Iew
         f/DQ==
X-Gm-Message-State: AC+VfDzwYtDUlXUrMCZd7E8WNlN06ydHFg+Z1flYE8E77jI9hwjqAXXX
	pwxofC9qAP/tKkoSTm5LjS8=
X-Google-Smtp-Source: ACHHUZ5Z6dKRWRT7aq3orpUPjjYQhFpNGLFpgjH07jyu/7RmToyIpFvqL7y2AZmfFNW25yckE4PJRA==
X-Received: by 2002:a05:6a20:734f:b0:10c:3cf3:ef7e with SMTP id v15-20020a056a20734f00b0010c3cf3ef7emr18580445pzc.42.1687307976785;
        Tue, 20 Jun 2023 17:39:36 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g7-20020a635207000000b00528db73ed70sm1932060pgb.3.2023.06.20.17.39.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jun 2023 17:39:35 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 20 Jun 2023 17:39:34 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/166] 6.1.35-rc1 review
Message-ID: <01eae2e5-cd22-4c46-a021-3670302e8dbd@roeck-us.net>
References: <20230619102154.568541872@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230619102154.568541872@linuxfoundation.org>

On Mon, Jun 19, 2023 at 12:27:57PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.35 release.
> There are 166 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jun 2023 10:21:12 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 519 pass: 519 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
