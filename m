Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE787B
	for <patches@lists.linux.dev>; Tue, 25 Apr 2023 01:04:56 +0000 (UTC)
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-24b29812c42so3773071a91.0
        for <patches@lists.linux.dev>; Mon, 24 Apr 2023 18:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682384696; x=1684976696;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RrH16ZZyQmRjRRZjXjY81PGVGTn9lxMco03Ts+muwbs=;
        b=kZur4X0MVAHsbQQhlnQsmT6UpIoxeXRJdeilF3AeoK9FZqVBmGDj2QUh6VfrJtouE7
         UQ8G763+X9L4A3hEHj0Wgf7E76CqggVBNuUdlptDY8fv1EnqYeSRmd7kv1Qq7oFneZcn
         77E4la+GBSJz+1gvTujeei3pgH4tFmQHSJbe3/aNFfIOqT4DrwNLZ7nqhs5jKlF1yHui
         hIRWnX76qrUbvcmT6GYfL2heBOqu46aYsAg3whDB/0XG9SXcW15hK8kY31lwoly6JqU7
         U8dWTw8klEMkmwy/ONoedYDT+vyk1StLakuoxDFDU2jovs7eIhF8kSoLaia+nkLxEHvt
         0NDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682384696; x=1684976696;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RrH16ZZyQmRjRRZjXjY81PGVGTn9lxMco03Ts+muwbs=;
        b=HvkfTQm7qV0UfcxVe7cXVVdhsKc8TVjQYhJdziKPNg3k5ngvLiaRpjj56POHUiKy60
         z9UJFt2n/SIyfv58Ak0FOxvNAhyYjTixbpKfjzdNNTV49ftAJKJmgez8mAqmJrGLfFUO
         JWnJI/06XANv25pVhrVKkhfOSY8/gh2V/E39lihXjUDhovD7nIQpXGh5+eD2eicXj9Fw
         xiomhIDqUiRqs7f3nxXofhm7fXCwfg8JKZCpu883o5SxTnVV4JYIxWDqac1PLtFF2xS2
         P9qnWS4ot2llQkjR3p/efHh1mYMTc7SIM9Qbz81tV6rnGogLbEUs5OiFG8RtX9tM7XMD
         TzQA==
X-Gm-Message-State: AAQBX9evMlhPamuUlEYrVpAr20acQYEpsknn+eRWNT3jRdRjAXZOkVE6
	EDrLb6u/8DMHf8vdr8y/Fo4=
X-Google-Smtp-Source: AKy350ayqzJrx1r2NhqUtF3O5c0bef9JndvmvbeJVyu2Ak14rCrOwQ0DAqmjVPFBv+Gc9qQVtavBPA==
X-Received: by 2002:a17:90b:1117:b0:247:25d6:b849 with SMTP id gi23-20020a17090b111700b0024725d6b849mr15643534pjb.8.1682384696239;
        Mon, 24 Apr 2023 18:04:56 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z22-20020a17090abd9600b002340d317f3esm6893161pjr.52.2023.04.24.18.04.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 18:04:55 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 24 Apr 2023 18:04:54 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/68] 5.10.179-rc1 review
Message-ID: <71512b75-ccd2-4959-bb05-445c7f1f56cf@roeck-us.net>
References: <20230424131127.653885914@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230424131127.653885914@linuxfoundation.org>

On Mon, Apr 24, 2023 at 03:17:31PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.179 release.
> There are 68 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 485 pass: 485 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
