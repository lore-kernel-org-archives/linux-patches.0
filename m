Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1DE217C7
	for <patches@lists.linux.dev>; Fri, 24 Feb 2023 04:29:45 +0000 (UTC)
Received: by mail-il1-f169.google.com with SMTP id r4so3985444ila.2
        for <patches@lists.linux.dev>; Thu, 23 Feb 2023 20:29:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bFcCAGcExvL1TUhy9/ONz2HJhq249qLecHd7Ujep69E=;
        b=EPK9SKNxDXpAG4KK7C0t7TYCyuqrFSIdMsrEL6J/boNFOE1e0mzeKA2JZ7ghjdDf2H
         ZrfHmp82vQ1f8ufVgQMotnh2cirtXi9o96qJ5SIQgceRU6jqeuWFlF4J4tcWTj0q2aWj
         TrBwKn97VsU0i7qe4a9zfKN4jvGfGkD3N+i2qt/+BSR+19uZWD36HI82/6wcFaQcOSZf
         qfjj/jUTId0oJYxl3QGoGYq84q2qS1n+plPz9rRc0jh2hRQJqr/RA1hT5Bi2yddb8G43
         Bux7Aca0CrOaeR48sH7YO4BC4CyCW3C5UketUD7IOHt4kIv+nI4dlBGiEx9M9NqRPS4q
         lDXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bFcCAGcExvL1TUhy9/ONz2HJhq249qLecHd7Ujep69E=;
        b=3ULbxzOVAV0bEHg80f0BffvBPWuQl6KXiD7YiBzgU4jrDKhrXUQUY5cilGdxxcArBt
         rR1HL/iF1JbpTk7RTju9NTH1n/bfzVXKN2ynmyRaOpMzdgokPbH69lHVEI5edvLKyJb/
         1p7ice3U6mO1lsHCYmhOgtkSSX3b/tQrwzyuq+z8yFN0XgTNmH6Z/s58nKdTevK8poK+
         v9geyxOwGd9kRFLFBNbzhQfPF9boAszHwfB0Ff5uL7yZsevJzFImLNXQZJfEWhwSF4gI
         FP/gEoyQ4TEYGKzaIuxrmJNBo3xa6gZPOHJ+VnxRHXuLk7NYpyHrtTYYCFovgr1i90+M
         lIgw==
X-Gm-Message-State: AO0yUKX5LgVVvRLVyoL9P+hWeK7cm6yG1fmopBuWGHE99uRxXU/Pr/tL
	ytkPD9vRV7iliLIWzTl42A4=
X-Google-Smtp-Source: AK7set80xtq++KVR8NwURwDqQiq7UYsT0qUlqRG4VROqQ1BSuWy/QeJAGfVR4Yro2p9h7zjMXHOa8Q==
X-Received: by 2002:a05:6e02:1849:b0:316:dc3a:fe80 with SMTP id b9-20020a056e02184900b00316dc3afe80mr10828322ilv.0.1677212984802;
        Thu, 23 Feb 2023 20:29:44 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s24-20020a02c518000000b003ad13752c9csm1999216jam.72.2023.02.23.20.29.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 20:29:44 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 23 Feb 2023 20:29:43 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 00/12] 6.2.1-rc2 review
Message-ID: <20230224042943.GE1354431@roeck-us.net>
References: <20230223141539.893173089@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230223141539.893173089@linuxfoundation.org>

On Thu, Feb 23, 2023 at 03:16:08PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.1 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 504 pass: 504 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
