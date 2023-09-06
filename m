Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7064410962
	for <patches@lists.linux.dev>; Wed,  6 Sep 2023 17:25:09 +0000 (UTC)
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1bdbf10333bso425345ad.1
        for <patches@lists.linux.dev>; Wed, 06 Sep 2023 10:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694021109; x=1694625909; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TtFBuHMyCxNyxeApH/j4q1M9/7VaTqahchmwQtB5wY4=;
        b=c+iJ5/KGDM/I/PPXEwapow1kpESCgxcjoQ6bnSzajkU8/Oi5/YvHm/E7nw/8Hdr/Gj
         Y8sVmZv1AWAu6+aQTQmvfDMF7WgHFL4ga7KPCqPyLp7Y1e18AmSn46ixet7S1SCKAlpu
         7bwX+kNvzvak+USK9/CirrEwZc/sEP5dfCEiqThciIdPQRuGt+zL/z+BWkAFM98qNuZF
         eg/64aIH81chD3GzsNxfYxuj6rzkNozH7JUyX4G8U4c5FNNvS2sZbzcx53HzJ9+UnDGR
         s3vOQPYMsLvhjftEk3vPvjvFrR4L3ZTeYByAsGi4FomNLbpM9ndk7PFNhXq9cRPyR7jK
         vuhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694021109; x=1694625909;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TtFBuHMyCxNyxeApH/j4q1M9/7VaTqahchmwQtB5wY4=;
        b=Kur7v0ct7mVihGSJIlVu33jbubFvYrmBurFGhJqj3zKDu4GVdOvl3hZzguABAN3Gqd
         pIQJq2eQlKASzeM+JmnpurnKaZtD9yffZ1HScSQ7kLHEiQYRtw3wB4U6NWV1/0v6lwv/
         i3CGyyW6mWz5w5bN6ZMIERZyTLdZb+JacIe4KnFDwoBpJGzReUWmo8gzg2J+CJeSLXTI
         heYs+DhHNHLaByGru+508gc0iyO01VBOzZSoHLbyleiZZICOqPsK0oAi9+vUo3vJXozn
         lM+sHMcAQVzYcPktGpDBluS2C6MDbQNNZhPp0NbkKWpVDdxhjIkLUGZJ3AV3qevBqzGw
         yTLQ==
X-Gm-Message-State: AOJu0Yx6HdrYP+sxJRDG1ysO5AQLP4sUWQQS3hHHXi3rkkGDWdQX4l2g
	9hTjWcwuXAKYe2PbqZmsNOU=
X-Google-Smtp-Source: AGHT+IHiUGqLqClcNly8GWQ1LCsg0F2QHzXdqWOkKYboKfOPj11Hds+dP2qX1/OuWnUWPTzuQILbOg==
X-Received: by 2002:a17:902:ecc8:b0:1bc:7001:6e5e with SMTP id a8-20020a170902ecc800b001bc70016e5emr20699856plh.32.1694021108559;
        Wed, 06 Sep 2023 10:25:08 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id ja5-20020a170902efc500b001a183ade911sm11377213plb.56.2023.09.06.10.25.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Sep 2023 10:25:08 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 6 Sep 2023 10:25:07 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.5 00/34] 6.5.2-rc1 review
Message-ID: <b98a68ac-24a4-43e4-9d4e-a60c52d377e0@roeck-us.net>
References: <20230904182948.594404081@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230904182948.594404081@linuxfoundation.org>

On Mon, Sep 04, 2023 at 07:29:47PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.2 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 Sep 2023 18:29:29 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 524 pass: 524 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
