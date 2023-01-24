Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8268A31
	for <patches@lists.linux.dev>; Tue, 24 Jan 2023 02:49:54 +0000 (UTC)
Received: by mail-oi1-f171.google.com with SMTP id i9so8390190oif.4
        for <patches@lists.linux.dev>; Mon, 23 Jan 2023 18:49:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X86lwB3K6qQT9EBDO+x3sCvlNaBGJ0K6Kl/k/JA7UI8=;
        b=krA7WJ4TMyuOR3dd7H6AipFrcxlQqvEOz5xkhXQ0vxtvQ/ZtK2xMyAhUGtRsV1QoU6
         XJnZvEMyJfesK23PSSMC6a0FiphHXjM+ria+6RpyB+OpILLOBvOfim1p9vsMagm7i3O+
         cVkpvh025Cw2/gBAODAfah09Qvu5BEOZDu0QYhSw3rZHNdTOr+C/2aZL+NnTy8oMZBGw
         QbvRCwmJObF9bTknxUaHX6bc1GuSFM+5dHB9N247k1dTEX6sn0eG44aVGO19TqGu4C0o
         OqWPvwRi6ilw95sRgXiy9Ko+xg1RRLVfRENumexDuKNeQp9hV6ofEjWktC2xcqY1iyrX
         waKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X86lwB3K6qQT9EBDO+x3sCvlNaBGJ0K6Kl/k/JA7UI8=;
        b=Vv4lbkGdeX9J5fOrYV/KquLXyWhLhawaLv7gXP3sJ7RlMAx3IFT60T3cqEufroXuLM
         V6DB3u2PyD+OtAqeB4w5pnt8jYwZu5jybMyyV1t1wn37/6ri66/ozg9VELm8H8Kon7MQ
         S1FLoLBzXUgZst4OTgrplx7SeSP9yAb62mAFs3hD3JjeqZkF0BztamXdK8YxUgRlwxCk
         n1eHCDbA/9v8Sz689CJcJmYveTOA07EMnm65BXZn38/EnOEEdCXKhcokn8PTawSv/d3R
         PUZrJ0Zsafp67mwwQcBVdfOzcH45UYrLSJGF/JR7oyD5T2cG51apApOYvA4VW3wCSnE9
         LIFA==
X-Gm-Message-State: AFqh2kriNz2f3P14QX62GKL6fsP8eDF4iskkue3976YfEpsqYOgDr29A
	BLF0eZmQ0xLiZ7YYfiUFSk8=
X-Google-Smtp-Source: AMrXdXudWHmqckEuJORV+M8lJTUXqcJkZ8AuZq+6QGE547MiIpL2AbiKgFGPazKe2lYugY3Dc0f5WA==
X-Received: by 2002:a05:6808:2895:b0:35c:3a60:6ab7 with SMTP id eu21-20020a056808289500b0035c3a606ab7mr12982412oib.49.1674528593970;
        Mon, 23 Jan 2023 18:49:53 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r21-20020a056808211500b0036e3bb67a20sm488462oiw.38.2023.01.23.18.49.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 18:49:53 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 23 Jan 2023 18:49:52 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/188] 6.1.8-rc2 review
Message-ID: <20230124024952.GF1495310@roeck-us.net>
References: <20230123094931.568794202@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230123094931.568794202@linuxfoundation.org>

On Mon, Jan 23, 2023 at 10:52:24AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.8 release.
> There are 188 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Jan 2023 09:48:53 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 502 pass: 502 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
