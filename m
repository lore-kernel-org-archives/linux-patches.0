Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4F4AD4E
	for <patches@lists.linux.dev>; Thu, 16 Mar 2023 23:20:28 +0000 (UTC)
Received: by mail-il1-f176.google.com with SMTP id l9so1897569iln.1
        for <patches@lists.linux.dev>; Thu, 16 Mar 2023 16:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679008827;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kiT7fkFtVF0n3Eq41iQuXy9kvWS5g2M36ZfkL5aFQ4E=;
        b=SjOfvPAcNU2JoOc5taB73FlbEMLaMF/wcBaDJ2xDjr2xAPPZfbn3ZPpDyWzNBOcZ7m
         77b3/ULninLGOEMXibzJG+vykBdar3XKRT+M3KONQZON+DyVv5fHZibT9B8y5MYWWLXt
         kVn6DRLW5XPcLuMZPPRxnKo7cOKYMadKUtYT1CaDY2ZxhzMJ9PEpfdyQgovQMsiUzBmv
         pOXXs6KXXkAxkxj7Mm7jMl+78uvXmqXi6Av323147yM/6Hhe/6U5G+c3iiv2muQlxzif
         84XT3VxK76dm6SE16FXo08reEcmzDbyaGIswWLXFlHz31NAMyhIIWrsvoyNuaG4dPdcX
         7ewQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679008827;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kiT7fkFtVF0n3Eq41iQuXy9kvWS5g2M36ZfkL5aFQ4E=;
        b=tymL3R7gI4vC0/8z4XM41z4d5zuxCyiOWILmkDJRCaIxgRhE8psAdz66c1yz7o/IC3
         GRHJ2tbO6RfKga0v9MWktrTb0KBmgvxo4Ox2B6+Yurebq376TvKLgJx3EWI+MDOlVswY
         QHXn7cHYPCOrRvHo/Z+sxm1MTCPTHb7ep6lCqLdDoXe9IvlJ5qdj4XpwsEZvLOaF0X1p
         PppxvfhWyYckaGXTLqmXSPltSg1H2md5to/FgvSuK9yo9omcVsGK8Sq4GkvUHSqjXUTs
         n8Oce6ahqC+/lWGd5wXFV8nFpr30bdsoxQxqDQikfivYMmBAm04dGM8cZGugIfc9CYLH
         aEiw==
X-Gm-Message-State: AO0yUKXJ47c09RlMETLNCw5UnXIYQavofJfpYHi8oNWJPE2YvRhpUrgg
	yIPPfFB4qYbG0CcDSodG3x8=
X-Google-Smtp-Source: AK7set+D8b2k+mSFHjgu55zS+J/u1/lj+YDkGFZsjTYSNGF+c5zs+jS1nHlSWOBjMQOPN1w9VJ70Tw==
X-Received: by 2002:a92:dacb:0:b0:317:99b9:3d1c with SMTP id o11-20020a92dacb000000b0031799b93d1cmr8521841ilq.26.1679008827541;
        Thu, 16 Mar 2023 16:20:27 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 3-20020a921803000000b00322f1b34d92sm171453ily.35.2023.03.16.16.20.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 16:20:27 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 16 Mar 2023 16:20:26 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/140] 6.1.20-rc2 review
Message-ID: <3633184a-6d1f-40ff-99dd-80b5ef17f5a0@roeck-us.net>
References: <20230316083444.336870717@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316083444.336870717@linuxfoundation.org>

On Thu, Mar 16, 2023 at 09:50:22AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.20 release.
> There are 140 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 516 pass: 516 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
