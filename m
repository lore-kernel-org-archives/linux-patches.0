Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F68B17C7
	for <patches@lists.linux.dev>; Fri, 24 Feb 2023 04:28:18 +0000 (UTC)
Received: by mail-il1-f171.google.com with SMTP id h10so2439935ila.11
        for <patches@lists.linux.dev>; Thu, 23 Feb 2023 20:28:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=acQVstA40t9a/GI3I9ir5bu5ueJ+oOf7iOm5v8V7hj4=;
        b=K9mtWAgHoWDFEvqYNe8yyfThWHZJhDSdFFMBCxW4kwEr15rN+6cQ/toP1P49iRK1On
         BuyawCO46cGuUoPjs45jq41YUUVlKE9Uwu19nrAblx+qVJO3zHi4ubcmzDyP7MzfU8k3
         AS2HQvCf2Q9nRdW5XkD+zBXblHfzkDR/3wfR/WKtsp1uQLmw0fib7/R7JGfLlZfH7s6G
         yN0MVEBG9+1UGNn6SLV/T+0hqJcn8oVI3DlqssEgy5N3/gxVMa8FmmLQSmvcACsnTiuU
         pyhO+8CLY7EdnxlGQAbaubJzYXIMuen4tROGbHY+opWjxnpJ/jv0V5MAHa2kiSUUQTzI
         YCHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=acQVstA40t9a/GI3I9ir5bu5ueJ+oOf7iOm5v8V7hj4=;
        b=W35JruQT+qt4eBqZkyP1pYAikjUOHBzxv6uSnv9zUfyTC0sIHi8eQI61ZM5pFmA4Dr
         v5SRuNfBt3o3bqgc8suntqNqcakqmk25S3tDOXxFfyRb2FSYvEEn3d8kyKqCuy+tzJgl
         h4NbYIoC2d2AnUpHYO4MJXSjcjbZ4gWqHHV4OfAkotU+oTGyXGndLLyxVZZyyFs/sP2T
         HMQ+TP83tfc2gxuG68XZEkiKpcydyNUDnbmbiH8SPY0GYESeWj+c3+2vbjzcmt+ofiKY
         aOXqA60RFblB357bvg6RGL7ypQTLX6sk/3gmRPufkZb47HnOxbe5gnkwj7r3sakF/MA+
         mnuw==
X-Gm-Message-State: AO0yUKWOYjEux2MbLCrcOlXsI5UtkmKH3rIM5RATMECKnD9URwf7wPmc
	YXRK3yNl/KcNQE3a3k3ZDD0=
X-Google-Smtp-Source: AK7set/PgAmpJJPnVH6rSe4VB4EH2LcUE1RnGs52yQpFjvcENddYqJ/W3Yrqr+KeL4aQzSLXdVo6cw==
X-Received: by 2002:a05:6e02:8b1:b0:314:1cff:75a8 with SMTP id a17-20020a056e0208b100b003141cff75a8mr10261682ilt.26.1677212897961;
        Thu, 23 Feb 2023 20:28:17 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a18-20020a92c712000000b003157ff12248sm3875327ilp.41.2023.02.23.20.28.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 20:28:17 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 23 Feb 2023 20:28:16 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 00/19] 5.4.233-rc2 review
Message-ID: <20230224042816.GB1354431@roeck-us.net>
References: <20230223141539.591151658@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230223141539.591151658@linuxfoundation.org>

On Thu, Feb 23, 2023 at 03:16:36PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.233 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 450 pass: 450 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
