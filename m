Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A707F
	for <patches@lists.linux.dev>; Tue, 13 Dec 2022 00:25:16 +0000 (UTC)
Received: by mail-oi1-f176.google.com with SMTP id c129so12902295oia.0
        for <patches@lists.linux.dev>; Mon, 12 Dec 2022 16:25:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IWuVrJKzGO3J7zQt3sC4JYE8vUInb1HG8zTWsM3NQe8=;
        b=SBkdk72gLq8AoIWDYZs8QJzXR+EHvf9SatiYK8fTVceYdaWoVTU24iRpgeLLQdVZ9e
         WR4MuaZcsH8/WaoFbuObzCD3of0ypZCNJEJhwNT8fciuh26ZywN/zNI+FqLt2oN5wHI6
         vuzJWQ2BlzscyXolE+ahGRg8O4QtgAyVKlToZB1pESTJkbnp8aaXR1c6sYu+kL5XrIHI
         aGKW0fTzx60pmudeP+BEc1TtKmlKJoEjJP2eAhCtef7VqVh2graS//aDhuwZYQldEL5m
         8wPNURrMygXWRhMtdPjRCXMRzDe+xs8CU8TB4Mb5WDJedl+Jn9v6JZe1tWCUVdHq2lwg
         0zQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IWuVrJKzGO3J7zQt3sC4JYE8vUInb1HG8zTWsM3NQe8=;
        b=DavB6Ywpql3fEGlGjJIjtbMNxdNU/CzYk+ubD8IEZqpoePFcTpn9oxd98D0wLAGSho
         AsjNQ73shiXqcaB13ZqyRXAVN3jnvBuc+oPWthAYvbzyGQ2yJm104mq8Wb6SLKmeB/lI
         ON4uHTEcABz0K7hPvXinOXN4mkzMEzOTeXlmb6BSCzqpOFa1FX+EXAdOl+IPPvRQKVm8
         +HLVsLsXOwlCw1Q0NwYXjGEX8wxcI6edlGJOx0eZJShBvZPiy7Vr/PG2pbTErkSpFkIf
         YUp34rLYRGZx9UdfkCVSX6vMPL9FvC37kvz1adlVFU0TevpAgp/v8K1sES1qeFOKQqsk
         OGuA==
X-Gm-Message-State: ANoB5pkSmEfR46WGYt9CPJ4iL28On6SW4dmAO7tMK16NRzrEWIDYB6R3
	nTUkOVttVIcHUNpfdAao38Y=
X-Google-Smtp-Source: AA0mqf63VNtyZfShWDNsn7KB4a000kJ8JRcGDUS8Up9bCruEntxDSgHEtAR/e143uEslodrt/+WGDw==
X-Received: by 2002:a54:480b:0:b0:35e:8ab3:f213 with SMTP id j11-20020a54480b000000b0035e8ab3f213mr3284248oij.37.1670891115267;
        Mon, 12 Dec 2022 16:25:15 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v19-20020a056808005300b00359ad661d3csm4074983oic.30.2022.12.12.16.25.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 16:25:15 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 12 Dec 2022 16:25:14 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/123] 5.15.83-rc1 review
Message-ID: <20221213002514.GF2375064@roeck-us.net>
References: <20221212130926.811961601@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>

On Mon, Dec 12, 2022 at 02:16:06PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.83 release.
> There are 123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
