Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A368F60
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 17:20:54 +0000 (UTC)
Received: by mail-ot1-f45.google.com with SMTP id e12-20020a0568301e4c00b0068bc93e7e34so1553251otj.4
        for <patches@lists.linux.dev>; Fri, 03 Feb 2023 09:20:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uBFW9j1K4ay/fyk8RRmaUzvcSTxtx0DjoFk98LpIzlE=;
        b=XzM5UMtU8zsLoV581At1cESCgD8+GnpzJIp0HACv5i81ScqYJts1PlErkyE7gqq2u8
         J0NmRUAVlw5TwxEbdG3JD5Vaz1ZLGUn542R79WI3IrTkeLYxNWUxMDxP7xJiFPRs404J
         a9fXZw8GDYe7/ARsERbsujmQmJ62+Sjt85oJFyOkd5bGEo7sCAQNK8PrfcIMv1XTNy8r
         EmXzjtGwjV2eIXiIjk2WQG7KyHsvblM3XP91hG8f8wHvnc7ta1zhzusI7Eq3uXztko6V
         Mb9pRcKIdrKx0TefqEX7qvYp/JUWPYPhZRr1VfgPnFqgumTSRWjkoVKWhD3Gqmzg/dhq
         wkdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uBFW9j1K4ay/fyk8RRmaUzvcSTxtx0DjoFk98LpIzlE=;
        b=df6ealJVYMXP7YtY0zN7OOPkhTAwepEUc3ADb/73YQGbYhiuol/q5jTH/AB83/IqsC
         VEj98BRLKt8B8DVB8pHsaVwmBFSTueaKK2EYDz/HKSa6TqN6qPikoDN8okq1GuwLxjpM
         Tuagnlqq19haQRldjcT7fr5Ds6azo39aMy7ibmoUuXJJsFxRDtVRsbyFJfHqOHookIdi
         B44Od4Bs1NNqU/hDzhiZenyljNQFLrAyS4HzSIo4OjUvSwZtGX0gtDE1Fq5PyBEC1qUP
         PkmbS3npUJW/6M3U2K7ns3v3FZGhEioJegUMvtY/ZQ64L2UlNJyU11IjTar5aOPLdEW4
         DwTQ==
X-Gm-Message-State: AO0yUKWtxfeGVVAQZNjZuwUoBt1rCpL6RJYoyZwbPFGrpr2G8svFZ67V
	hfQXg2zk2DckWSPyApi4t90=
X-Google-Smtp-Source: AK7set9AidXA4NehQTMKgjQrvwNVW3BN71g3Gde98+Im1ser4mqZiya9kyMtAVXwq04zVvTkZDAD/A==
X-Received: by 2002:a05:6830:26f0:b0:688:4670:e964 with SMTP id m48-20020a05683026f000b006884670e964mr5870691otu.27.1675444853908;
        Fri, 03 Feb 2023 09:20:53 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k5-20020a9d7dc5000000b0068bcb44e7f5sm1297480otn.68.2023.02.03.09.20.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 09:20:53 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 3 Feb 2023 09:20:52 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/79] 4.19.272-rc2 review
Message-ID: <20230203172052.GC1500930@roeck-us.net>
References: <20230203170324.096985239@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203170324.096985239@linuxfoundation.org>

On Fri, Feb 03, 2023 at 06:04:53PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.272 release.
> There are 79 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Feb 2023 17:03:03 +0000.
> Anything received after that time might be too late.
> 

Ah, I was too late. The ia64 problem reported against the 5.4.y
release candidate is seen in here and against v4.14.y as well.

Guenter
