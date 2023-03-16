Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F568190
	for <patches@lists.linux.dev>; Thu, 16 Mar 2023 22:54:25 +0000 (UTC)
Received: by mail-io1-f51.google.com with SMTP id o12so1521720iow.6
        for <patches@lists.linux.dev>; Thu, 16 Mar 2023 15:54:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679007264;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=noRAcyDP/DNfjl0bH6mzBUk0AhaaiXFphuu8aQobzic=;
        b=bCd3ZHQvFPLCKPpUiTnkGXZoN0l5MvAEa7vxTv8HcSbImXe22JDL+GwJJLqBU2ttHc
         NhMOnOio1GkP37DahAgOd054DXQSQP5YBUYkIwwJ8w6iAJagtqiaPQy8LlUYw6Mfueg0
         lvIEuFPzNh5WSbN0OdMl9fA1/A7mi0lxPog/GSU5CaZLvuP+U7dpaH0QHA3WMzpc5iks
         xBEYKv5CxZKoQkqKl2XtYoB1VRnvqy0yy5dOGVe7uU95D9PXM89XrpBPjcWre1VPIULY
         pvQn3xDYNfJM0525t/OG2X8J892LrKDDIEOV91eaTUTB1qZjqDPQ4Cbw5qCseMXLjuo7
         dfrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679007264;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=noRAcyDP/DNfjl0bH6mzBUk0AhaaiXFphuu8aQobzic=;
        b=PJwd86IwyrPHG/T9IMt6qmHXJJX5HE+NCa3KXR0zZA1gfhlIf89KCHmCqECVd3eplA
         nWuwZwgYN5+AfhZS8P9OLjjlFhSlLWh2/x31WIxLFKXNgAPrl9Bhop03Z6iTXs5BDqyY
         knZM8YangsltLSG5HGGhh3Nme9Q/Ug9thXFfNskVyXMyjgujvcVIQ7zMHua6qX3AZbMG
         bYVWsbaIZfK70RDxb+w6MwWxR3HREjKk049pbWqfNfykN/nFg5fHufWzrMi+Xdb5B/R4
         kAwRigVMtqLvYGpmaKhqj/JLbMEeHw0KJO145+KFvKbW4ZKZCgq/af+Vxr+tjayBLQy4
         6BgA==
X-Gm-Message-State: AO0yUKXoZG3ONDOIX0aW3LmtaaHAfPQ4uw7T+PDO6ZQUMgJHBtoxsdp8
	YssV8Z/V1BIqp9LJPR3NZBo=
X-Google-Smtp-Source: AK7set8mOnMvwTH8RSo5A3TnDh8qw5vTt25VO9g2z9SUQRy2QvOHUI2jIlErP1F6HkLBUVAOxTQs5g==
X-Received: by 2002:a05:6602:4217:b0:74c:99e8:5a83 with SMTP id cb23-20020a056602421700b0074c99e85a83mr396639iob.9.1679007264248;
        Thu, 16 Mar 2023 15:54:24 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d4-20020a6b6804000000b0073f8a470bacsm126718ioc.16.2023.03.16.15.54.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 15:54:23 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 16 Mar 2023 15:54:22 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 00/55] 5.4.237-rc2 review
Message-ID: <88ed612e-8dd2-4322-a745-a2045d3e0500@roeck-us.net>
References: <20230316083403.224993044@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316083403.224993044@linuxfoundation.org>

On Thu, Mar 16, 2023 at 09:49:55AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.237 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 455 pass: 455 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
