Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F7E81365
	for <patches@lists.linux.dev>; Sat,  4 Feb 2023 01:48:39 +0000 (UTC)
Received: by mail-oo1-f54.google.com with SMTP id bb32-20020a056820162000b0051a698e1174so49107oob.10
        for <patches@lists.linux.dev>; Fri, 03 Feb 2023 17:48:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9W/qk0n/CPhDpra9Z2blMDuqhiMKXk82qamoSsWubKk=;
        b=H1Snbxx+lr32UlIiWM9csNOvM9VWm4O3vDUNTNdzKVOLys1M27TF2f9LYlkcjELfZ+
         6ZBN8pTqyWAaD/d3TyRZjNe4cILDlFimkGT97L26o+X8RJdm+ZaYbpL1Pc9iqfMj4VC5
         b1wAe5oLd7DGBnTsEokLG3EpGElZiNpIRGp3/BaJLoYijMXfUKFRxTXderNM5FJC9ccE
         5i0xm5QFPuxs0ZEQlqWWYqEABt+97Cj3CIc/z6GbS3PSPJPna/6LGhNuWYZHCyzzYsBa
         l1PdfXp2Dw6t3JsLXx6eHiZSsMdYGIV8eT2TMvux0HIuNA/PdOMAL0ssXIUrSain8yw/
         V+eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9W/qk0n/CPhDpra9Z2blMDuqhiMKXk82qamoSsWubKk=;
        b=vRpmycJfyOpL6RU6KQDOsZ8/edeUzhoG28E07tOxhnxB6Mqb1022bsBYHu3U+ogEWd
         0wqlmSzoRL15cJj+RsKxY6ntZ7EIZdXcKPLgblP0OBfc5z9ZaXyHQvM8DiM0JaklQGK9
         c4cp09Mx0t3MH+T0KN+CIqhdnpiO2B8ZC2gTEUMTsT9luRgjFiUuRxbR1zx9/qCa28B3
         dh9ykCuLy2OlbAqj36w5g8Lzv3jOWRPg59zd1isKEQ4hnD4Fbd6Z4S/bIkQtZJlykbbs
         xc25sUTFwW8mj+jwajz+Nu+qtmyXKQVFUV7os2+CYzkHVCDJYj+0Che+C7EfoJ29fyC6
         H0Yg==
X-Gm-Message-State: AO0yUKWSB/AXD8UizCkA0C3u9iH4EHIefmmmkkjFu+PP+rN9tnJZL6PW
	9mjUZ8FGOXLOa79hF4mkGJM=
X-Google-Smtp-Source: AK7set8gqlr7FWMhAyZFBDLub7uhKpdVOKB3YOGmesWRAaxUOH/qmAHmIyXi47Rjig9AVbhN0iHQvg==
X-Received: by 2002:a4a:3346:0:b0:4fa:325e:ebb0 with SMTP id q67-20020a4a3346000000b004fa325eebb0mr6994130ooq.5.1675475318462;
        Fri, 03 Feb 2023 17:48:38 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l12-20020a4ac60c000000b00517587f8817sm1604408ooq.19.2023.02.03.17.48.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 17:48:37 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 3 Feb 2023 17:48:36 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.14 00/62] 4.14.305-rc1 review
Message-ID: <20230204014836.GA3089769@roeck-us.net>
References: <20230203101012.959398849@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203101012.959398849@linuxfoundation.org>

On Fri, Feb 03, 2023 at 11:11:56AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.305 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 167 fail: 1
Failed builds:
	ia64:defconfig
Qemu test results:
	total: 425 pass: 425 fail: 0

ia64 build error as reported separately.

Guenter
