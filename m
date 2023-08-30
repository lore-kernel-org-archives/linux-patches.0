Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED11EA1
	for <patches@lists.linux.dev>; Wed, 30 Aug 2023 02:02:04 +0000 (UTC)
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-794c7d95ba5so96215239f.0
        for <patches@lists.linux.dev>; Tue, 29 Aug 2023 19:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693360923; x=1693965723; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VzaCa6AYBSBoE/Kttz1x5kMRIdSD5l8LHkogURtv0zk=;
        b=QFWJ9s4z5m/96Qm5HZ3b0gz2mG0PJfAUpqcclFcW5n43qE5wNpGPCDInYjn2Whgepv
         yI5ePs6DRHV3HHiVN5PShPYDkjVcz2MqdSf9z2BMlRVhUxpPhi23Wxctf2+cWwb/H1Tz
         LOeIpa882LBWUpxydG+eMM4mFoRCTuSoxPedZ2DQmyLQE3i4oyCgZzgg61+x1cLTpLV2
         A5aU/u1nSQQIuw/889Ax7BkKF3e/s6nNOAIN5Hoc4tvesNq8tZhxaTJaVsfoOvQt1Lzh
         O3UjeD+jsd8XBzubAFk2C9RNWKrYW3/S8S4nIc5d1OQRrmrAJs1zQgV9DwXA92EEYxwU
         vMzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693360923; x=1693965723;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VzaCa6AYBSBoE/Kttz1x5kMRIdSD5l8LHkogURtv0zk=;
        b=QuevOZ62Cj1vyxiSE+AShce1jk+Kq6YkHnQoZtT6sH3vzGjarXZ+HCM73SL6AR/l2s
         ZxYXLkYrO3E3HJ1IPb8QZQoKWH55YStEOmget3XOM7iygUb+BJHjQWykHrD9jnXAWdqw
         oh1Oxc8RwoVIyX5nsBs+PeiuLvxyZrHfeNBuetIwWvauKL9uAcrThz9S4ywZL7naCqo6
         QBhM86W5AdjF3xqFiy6X+wgSYionqOnMjgJ4nQsrsjfEh8PwV/mfkSp5Kout6tXrznWf
         vLTYDC4s+uX+VkQ/Gmna7xvlynsqrTWwKUv+7kx4Ojk+fFq09ixB/QTG+MNsheM+PLcn
         pRrQ==
X-Gm-Message-State: AOJu0YyZ2UMxjxqxBAPqdFrU/cyenJ4v0pfLADZzNaqfme4E3UW7kxYC
	v9xA+qnNVQz06N6ksmzO2nA=
X-Google-Smtp-Source: AGHT+IHyb7Gsd4x3gdyIIKw65Mk9SF6V6Ao7oPxVn5+vnoaq6hc6nBOJeeGBgUlBPcUDX+Ki6C03ow==
X-Received: by 2002:a6b:e513:0:b0:791:3db9:c97b with SMTP id y19-20020a6be513000000b007913db9c97bmr1107620ioc.17.1693360923624;
        Tue, 29 Aug 2023 19:02:03 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y17-20020a02a391000000b0042b48e5da4bsm3396429jak.134.2023.08.29.19.02.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Aug 2023 19:02:03 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 29 Aug 2023 19:02:02 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.4 000/158] 5.4.255-rc1 review
Message-ID: <7df7ee08-71b7-4542-a3c5-195bf39916be@roeck-us.net>
References: <20230828101157.322319621@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230828101157.322319621@linuxfoundation.org>

On Mon, Aug 28, 2023 at 12:11:37PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.255 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 30 Aug 2023 10:11:30 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 152 fail: 2
Failed builds:
	mips:mtx1_defconfig
	mips:db1xxx_defconfig
Qemu test results:
	total: 455 pass: 455 fail: 0

Same mips build failures as with v4.14.y..v5.10.y. Not new, so

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
