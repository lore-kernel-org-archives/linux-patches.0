Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCDF97B
	for <patches@lists.linux.dev>; Sat, 11 Mar 2023 03:39:34 +0000 (UTC)
Received: by mail-ot1-f46.google.com with SMTP id r23-20020a05683001d700b00690eb18529fso4040866ota.1
        for <patches@lists.linux.dev>; Fri, 10 Mar 2023 19:39:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678505974;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZvG0fhpZYyqoSE8gxi/ypMj2Bt0f69C0fDXhG9bXUlU=;
        b=mqy3zdXzEccpTUHXzl1xGiCbl4+PMZAIxCaFoQSxpBHZBH1TvLeltI/0TE8hmJBbZv
         JpZDLLmQBjqWXT41O+ExYFWP5fpu5ecXW6YAY90Kxi5MwA58WtbEka4ruY2PFfO3RZgD
         yIxlCK+2EpnLRx4FN1gH9gF09bx9Lldht8u/sVZdEdR9wOZ+1k67m8xtJ9F+W6dpA8uO
         OhJM0Vm+gaa9MU9P/BbmSHlVpuIYe9T/UL9Y7HBdiMUc1y8Wwyd0CA7ByRNwYBOSHa+1
         +B6BlQTEEw+FfhCJZ5yG5mpt/W4m55Gj/s4LIJksQGoZKvClB5E1stRs2L7M4kAEtNSp
         AGuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678505974;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZvG0fhpZYyqoSE8gxi/ypMj2Bt0f69C0fDXhG9bXUlU=;
        b=FnYw+IylxncxvNAhuLRen5HNiqu7gNhyeZ9GlaciBZ29GEhtdtOIv3p5ssi17Zqjwy
         1fQqoJQzA7sy9Z5JOGuIzlivdF2JeB1IyoDhCHUtjub5QxwQCCiKi5hLOUqr6zOhQOJO
         sXwoVZiOtR0sLgRqdi9nSwuY5bp+UMx3TMrLn+eMRF294ko3P+QQKZdW/pTKF0fVEtmw
         um3Y+ktaGD5IQ9sDMXIH05YwkkxtwMprzAPzo6VV7pnbJ5fyugVZfkwMtAy8hpitUD38
         aNeWJEH//F9AbmwPusyyjHkQpJgqRPYUFHwLC4N+UIJlFZnyRc++l6i38IiM8y4AkjM+
         61hw==
X-Gm-Message-State: AO0yUKXF20ABkrLdiVilux3RGPXDTgtH0k6Tt7d/2DYoUOkQ4ob0K38q
	z/Ha+WJGMJohszQWHKSjDZI=
X-Google-Smtp-Source: AK7set9cU7DqEJRaba4YNUbGH+3H4wrWnLIIwhCcgT6i2BfUfQAvtSNE19Bzrz9MW95r0C2kZlbbyw==
X-Received: by 2002:a05:6830:438e:b0:68d:b394:458f with SMTP id s14-20020a056830438e00b0068db394458fmr14820314otv.17.1678505974030;
        Fri, 10 Mar 2023 19:39:34 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i6-20020a4aa6c6000000b00524f47b4682sm670656oom.10.2023.03.10.19.39.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 19:39:33 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 10 Mar 2023 19:39:32 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/200] 6.1.17-rc1 review
Message-ID: <277fbe49-d6b3-4bfe-a769-a172f09d06d0@roeck-us.net>
References: <20230310133717.050159289@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>

On Fri, Mar 10, 2023 at 02:36:47PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.17 release.
> There are 200 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 516 pass: 516 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
