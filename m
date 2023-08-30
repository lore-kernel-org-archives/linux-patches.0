Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343C0EA1
	for <patches@lists.linux.dev>; Wed, 30 Aug 2023 02:24:48 +0000 (UTC)
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-34de98e01d4so5257675ab.0
        for <patches@lists.linux.dev>; Tue, 29 Aug 2023 19:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693362287; x=1693967087; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lIPqgFvDaI9bwZtognGowvWWbSTHbXBUdbdWIzJhIjY=;
        b=lXmmk3hRrhVszVBVNKYAoRmpFo+eZftqBd0JZ8ZEA024CoeOTJc3fTKcRnJhoNMHqv
         oRgV/JfJfx9+MVxk0lfLsrF89wp0DHZw1Oq+SzKIFt3S8v/j74LDPcRfp8Pvc3bYU1Cs
         +dl5pSG3sQ06xX45QI+R7Tsr6nQjJyfiIdtY20gkxru7INVcBYLBNDOMnNiRVRgynvGI
         9YDg6P+Bdmn2OGcW1ORb61BS3xlZhA51Ps/PV9avv1ANDwqjZw4pdgu79hYPpIvV9jaC
         AmLY6Fd/tjX20TvCZaXPl3wR2zr0h2ml1Xv3nLEbRq+hoMuNQgi+4TjDAwQ/xT3L/i7z
         7KMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693362287; x=1693967087;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lIPqgFvDaI9bwZtognGowvWWbSTHbXBUdbdWIzJhIjY=;
        b=Wsnv0BfZ3W7uKHNaCobytHAAufRrDS08wmcUOBnpN+WXquEjaarto0XVu1ba6u1aFK
         E1FH66HEYsSPwyA3lKZWFwv/sSwq5YteuQlMhaqlnJb0UPbkCFtdEjXVYVfjuTCZdCIa
         ORyTD4S6fl+cyO3j77EpoXq1ys424/MUS8FruYQBCSGtYKTcG8SwNLGkuIASqi4iDXnn
         tskwYUWH95PVDTZ7uGbWUJtZDHNUZbDv5STUajJ5GYWMqLWCYIJ4WhEyq0ufcgA9MWkc
         FNj4DPWCD8NnHn/TTD0y+MKjkgAmvE6pxnhbJuuiUnI7rh7ajAfY0PzLg5dg3c81jRO4
         KmKw==
X-Gm-Message-State: AOJu0Ywaey8n9/MLskeJhJR/PqK/t28G84Kgy3J6OnGWMj96sQG8KpCn
	t2JkXTPMRpOePsTUh2OyLIo=
X-Google-Smtp-Source: AGHT+IHqfFMD5BTfKENln/kG2oDw8tsQJmbAo9w8IHgr0LcdjC8+0MpqVAkynVn2NOAHHvxjv40C/g==
X-Received: by 2002:a92:de08:0:b0:34b:b16d:aa38 with SMTP id x8-20020a92de08000000b0034bb16daa38mr1206283ilm.29.1693362287171;
        Tue, 29 Aug 2023 19:24:47 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v2-20020a92c6c2000000b0034ab6f53e23sm3492402ilm.28.2023.08.29.19.24.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Aug 2023 19:24:46 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 29 Aug 2023 19:24:45 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.15 00/89] 5.15.129-rc1 review
Message-ID: <f2b014ac-707e-4c78-836d-b0ccf46a4de6@roeck-us.net>
References: <20230828101150.163430842@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230828101150.163430842@linuxfoundation.org>

On Mon, Aug 28, 2023 at 12:13:01PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.129 release.
> There are 89 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 30 Aug 2023 10:11:30 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 501 pass: 501 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
