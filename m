Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C91110950
	for <patches@lists.linux.dev>; Tue, 18 Jul 2023 15:29:42 +0000 (UTC)
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-5833695cc67so26622427b3.3
        for <patches@lists.linux.dev>; Tue, 18 Jul 2023 08:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689694181; x=1692286181;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qylrI5TVxU4cjjQW7fNvxJOIHj9MYnraRBa50qVPFyU=;
        b=pV8EZ+o+R4DDtyzjL1tW2pf9JAE46kSrFekAdm7F94LK3aTvu2h3WE6Ll0ioFcfloy
         VOsRl81VvhyO73TtpIOTtwQV8FqiLmmQpESRIt4nswjirGZROjBdOkOrvrx3KOagX0aR
         QOshAYkCDSmkl7CrVwlTjXoG0OxsBbcWpHBXiXYKUQXW8ZGKyfJ6z6CVS7dJwp3IyKR+
         Jz+67+1JLjJoVf0nmaQMcgxHGZhRcWcugY2DxOBy0yQ6LRUx+gIC5t/6DEpqYCV37jhq
         e/wys9JzECOw9u/kQP+gNc8qoJnSHL+JfL50eZcMyVYDbJEaFd+azoVBIWMvlRnXbTL3
         +FdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689694181; x=1692286181;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qylrI5TVxU4cjjQW7fNvxJOIHj9MYnraRBa50qVPFyU=;
        b=lsr6V4HqMZmK7AA2jqfO9BWK5tW5ri2OcLK4E0xusn7wLDXpU8RE+/JwvNKmA3WBin
         c6QBPFbgdXuy5sBXjacAu3v3Is5l28TfdVa6SSuoRng3KsyzrbZn/fNSH/4a+8lZMQHa
         N4BxmQYas44dtbs0rx1MulaclfZi0NJ5EqDDj1QIxC8C5I8GSvk5q4OCb1Oh6o7qWUjf
         aOfui8Kvdm546jGlowN8L+T58sfcgoEZKVHLxgo1XjZxPiCfrGYWHkODboyyqChytjk3
         dAWh6jlXd4B1B59gVEAteAvtnyLCH7E+C6SAr92crCZK3AJEd6ufCYSb4JjqzVu96if2
         899g==
X-Gm-Message-State: ABy/qLaU1Jt+VI3Mm8nYKjNKpb/lMrqYLV8oSuPrvVFe553q2hAIIPmU
	d0kcMeOhoTwJ2Jbd4k8Xj2k=
X-Google-Smtp-Source: APBJJlFeVMHJEtLwJn3T5TqvKGlyTvt33hQh2T67a7plN4OTVLB/h0F3UrVYdbxGwbIqHs8H2BdMGQ==
X-Received: by 2002:a0d:d647:0:b0:573:2e7a:1733 with SMTP id y68-20020a0dd647000000b005732e7a1733mr16851699ywd.45.1689694181332;
        Tue, 18 Jul 2023 08:29:41 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z80-20020a0dd753000000b00583414320d2sm508081ywd.111.2023.07.18.08.29.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jul 2023 08:29:40 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 18 Jul 2023 08:29:39 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.4 000/801] 6.4.4-rc3 review
Message-ID: <971fab95-7839-48cb-b3af-3ca18113ef4f@roeck-us.net>
References: <20230717201608.814406187@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230717201608.814406187@linuxfoundation.org>

On Mon, Jul 17, 2023 at 10:34:36PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.4 release.
> There are 801 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 Jul 2023 20:14:44 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 522 pass: 522 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
