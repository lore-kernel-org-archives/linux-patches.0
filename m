Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5291EBE
	for <patches@lists.linux.dev>; Thu, 27 Jul 2023 00:02:49 +0000 (UTC)
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-686ba97e4feso449316b3a.0
        for <patches@lists.linux.dev>; Wed, 26 Jul 2023 17:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690416169; x=1691020969;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XF/zbO8J5jCFWkkfTUlV3SZYG3BARK5otb0ix5VC2cc=;
        b=Fjx3QVVUlzQ2Ro8/dFitccgjryvoqQDcbuyomOXbxAfGnU4NQbaoeR4+UN45wJ3JKX
         9WYUS5Aa0wvaMOqOV4GNVNYr3coawlE00tx2yt4ZUw+u5OkyBqmMSte+kVnPRYIJTOtI
         HHOXyVCDil2h+RPszoHa/SSRIlZ3pezmFy38nkO18v5BH727g46DSdVbaf1673U4rOz2
         doBBoSV8FjV94FC4/7A0gla1bqUBzzqkjlyo7vcw13LJBUdFzZbRVTH/cd7nNjJfDsHk
         d9I79iHGH5HC5mxbt0YYz7i9kqCZQ1cQ0suufgYmDUKHOaoUb8/z62WhXRejMyLP4kOI
         0c8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690416169; x=1691020969;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XF/zbO8J5jCFWkkfTUlV3SZYG3BARK5otb0ix5VC2cc=;
        b=jmxvw4zpNjEDovVia119t+YsmULI9qxE63aiijyUthRHrluWTJ2/XdACxl771eoCoa
         Xhp3KXFrqX4hDxx6ncdtGoSt8dVIoRBC9lRwYvl5qFSPfEe1DVDOXWgm7hZq4qkMQENN
         tTuF2jYuEGuf1NhDUnu90k7/tATqCY3E3Zy9EyaVtQn6KRJT3GSkA7PaY0f9iro/SLlT
         G2BYmTtH3rm8vdqjVzXY1npA7VNbnms2pqsQRlegMLDG/AndxBmSRUwp3CBbL3/r+nP3
         /LxhNRRhBkMGp5Tb/wvUDhRtGZms+vyNxsB1C8iSeJPzIV1nb7Cb7TCT0tjl0XZhucHc
         0ebw==
X-Gm-Message-State: ABy/qLYW2K+i07WgHioy+hy2UNkiMqPBGqh51u99OW+MO5Jx/yfi1TTm
	ZeEMBM6OCuNJbSEC6m9OTF2dipYw90w=
X-Google-Smtp-Source: APBJJlGQ7HZ0lhbjH/Vo4xT37Es8W6rvUtN5Cs2TMrz/X4BShdvD/LaYRUHeYwf1w842kAco0FafUA==
X-Received: by 2002:a17:90b:2394:b0:262:fe45:860b with SMTP id mr20-20020a17090b239400b00262fe45860bmr3491997pjb.0.1690416168999;
        Wed, 26 Jul 2023 17:02:48 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id ne11-20020a17090b374b00b00268160c6bb8sm126776pjb.31.2023.07.26.17.02.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jul 2023 17:02:48 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 26 Jul 2023 17:02:47 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 000/183] 6.1.42-rc1 review
Message-ID: <c76caf84-55be-4fec-b41c-18e0585bb325@roeck-us.net>
References: <20230725104507.756981058@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230725104507.756981058@linuxfoundation.org>

On Tue, Jul 25, 2023 at 12:43:48PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.42 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jul 2023 10:44:26 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 521 pass: 521 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
