Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D6D17D4
	for <patches@lists.linux.dev>; Wed, 19 Apr 2023 03:34:14 +0000 (UTC)
Received: by mail-pj1-f41.google.com with SMTP id w11so28497657pjh.5
        for <patches@lists.linux.dev>; Tue, 18 Apr 2023 20:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681875253; x=1684467253;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RfBfcpS+L63GdTTNo+3CNcyPC/4C30kAdFfVzUywa8E=;
        b=LNr3G2rN6WuwmVXL/AnNLsAvn7Q8CFUyy1X9HAt4E3FSphBYD0hbrBQ2fSyLc4aR4v
         VxS5dd2N3amFj9wrTZrcsPF5Y8YqN/91b0gBtc8gXGESK+wemCX3LlM5EUAW7N0O3s9y
         sk6lEHkmJbFAq0Yd8xutBqYlfNXrEnEm+6dJiCyQ0adLIspxrx/0orhyqpP7cC3eCnnf
         uDi4Uz1PHaxHzea3C8901BQ2mxeXqdNufvA2qzT+1BY7KoOunpzaCF4Dbf/0Iow9931O
         LQoyMi3lGdfMOAqAB2YEtTEPqMoxRRoWRcLCMbcvWgt5iFF4tMI40xQqQ4B3bBgsmB1K
         /y9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681875253; x=1684467253;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RfBfcpS+L63GdTTNo+3CNcyPC/4C30kAdFfVzUywa8E=;
        b=AHaovrXo9eT8ATYEGf4G7Xth0hTGneBv46skbpDkHM0Bu/u/Lh+AJG5Pei7u4gs7g7
         RIAR4BwUs5VxjZq/Br9ETx/Ya1k3agsSfDbhLr1udhT0PpMMJPt7aut0KSYNYNtQaxNX
         QKZKLHhVXkTWGagtuXhmQecTCyu1rwDt4Iu/B9qtcKfXWEtGGPIyDop5xgRlyLasMhJm
         pZ11CFe6sFTZGqPqK1KyzvNuswRDWIWMigvjMmYTLVWfrQ6VgvyVOFgQ1w6TjSOfc1ly
         40aDgsjSnf5O/Qlg9I4zI9vpXbSzr2+nt9qkY7/pBWUHeP+P8z8N8Fa8VnP+yxnwTibL
         mcyA==
X-Gm-Message-State: AAQBX9eMMvjanjZOnLcgRKDYkPNg8P5Az1QKuoz7K1TToG6k9Idqg3JU
	MYFyPPra0Crnfvcsh6uZOuGYZjJEg7o=
X-Google-Smtp-Source: AKy350bvqjqUG+U16npP4rvjE4Y900PulxQTY52CJ8wAT4yDxw565HXPW1SyFJIoQxVrLUGGZCjkaA==
X-Received: by 2002:a05:6a20:430c:b0:ef:7b11:3ae with SMTP id h12-20020a056a20430c00b000ef7b1103aemr2022568pzk.52.1681875253457;
        Tue, 18 Apr 2023 20:34:13 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v26-20020a63481a000000b0051f14839bf3sm2216130pga.34.2023.04.18.20.34.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 20:34:13 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 18 Apr 2023 20:34:12 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 00/92] 5.4.241-rc1 review
Message-ID: <931f7cb4-923b-4ab8-8b44-fd4a9d24c210@roeck-us.net>
References: <20230418120304.658273364@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230418120304.658273364@linuxfoundation.org>

On Tue, Apr 18, 2023 at 02:20:35PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.241 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 455 pass: 455 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
