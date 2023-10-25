Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 025EC185C
	for <patches@lists.linux.dev>; Wed, 25 Oct 2023 02:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AqMQJda4"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-5a7c7262d5eso52608367b3.1
        for <patches@lists.linux.dev>; Tue, 24 Oct 2023 19:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698199369; x=1698804169; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UzyWXBCmC4hzArGvKMooFXAHa8LrB8TP9psqece/XB0=;
        b=AqMQJda4jyNPT5NSUTExdiWTOD6jrIqc5XO50x3xK7TFnOzGG1WpnXR6w0ylJvmwFC
         R0bzAnQ/5IACwAxWrUWD9R/r9HfE2EJ/g8hwS5QnUNfnA2RGW9F1gwi/unaherdYjhXj
         IFLuiO4+ltj3fx0Zajd0wYl3eHTSQl0vXnjPtjWd6Uw9zbxnF3BhPWHMJI7KBjj0kZot
         IYOpE8q4myJIEi0XPDxn8JvobFc0GJpvZIOsUQAE6YUxNHisPBFI1I6zCPJj1MyVEoac
         P6Bp3gDWSl4UMf7OLT/ha+kpFAFYETfJVgyO7PN+XNL5oWiJtZrkvqk31WRnA+ZcBKst
         tqzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698199369; x=1698804169;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UzyWXBCmC4hzArGvKMooFXAHa8LrB8TP9psqece/XB0=;
        b=s+u1k+1Y/utrt07hay1KKxP25Ef+oP+BHk9YgxoPqu3ZfUjOm0tBPOdzjFKTrxMa7z
         6hyZ7rhBnekiAds/YvKr0tiwPyhFoycz9vunCXB94HCUpMJ7ezwdYIUBsHJdvU7THkP8
         P2jYiMyWvEy9SjyRdU20Q83KXiNqI2C0AidgeXFI/5YLDcOHpCDpWA4s7bT8pXDI2AsK
         gDAuVJQhSuuUKIo0mR3wZe+CpKhvDRzUX2mEJ7W2t6FmtNqZHXiM3Ubx29txGp2+7qL2
         LdZdrBzEYwbKsWLpOZ1LT1irlDy9kQuJg6bvyjUJqSmdaveFa1xICK/rsmzTeeaNdZCj
         lcuQ==
X-Gm-Message-State: AOJu0YwuJVe/tvIUky2YkY20RN8MI8RmqkO/Fw/X5yTqUSMWKHHKOhkw
	wFd6ho3YNy9sKhsu479lvsw=
X-Google-Smtp-Source: AGHT+IH0ytejPRDM/KrWMr6ZjDK3z09hNvU4eo70YB+WQSeAks7/x7cG6b6uIarfWfY+P2kZ76zxPA==
X-Received: by 2002:a5b:9d2:0:b0:da0:5585:c00a with SMTP id y18-20020a5b09d2000000b00da05585c00amr2663910ybq.52.1698199368679;
        Tue, 24 Oct 2023 19:02:48 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w31-20020a25ac1f000000b00d9ab86bdaffsm4054992ybi.12.2023.10.24.19.02.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Oct 2023 19:02:47 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 24 Oct 2023 19:02:46 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 4.14 00/65] 4.14.328-rc2 review
Message-ID: <d06ceb71-52d9-4f03-ae46-4373d6175241@roeck-us.net>
References: <20231024083251.452724764@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231024083251.452724764@linuxfoundation.org>

On Tue, Oct 24, 2023 at 10:36:27AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.328 release.
> There are 65 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 26 Oct 2023 08:32:31 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 139 pass: 139 fail: 0
Qemu test results:
	total: 440 pass: 440 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
