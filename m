Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCBAA2A1A4
	for <patches@lists.linux.dev>; Wed,  8 Nov 2023 14:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UGtGyHBA"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6bb4abb8100so5963047b3a.2
        for <patches@lists.linux.dev>; Wed, 08 Nov 2023 06:30:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699453826; x=1700058626; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oTzaAd+2ZeXUVNzWH6rbuqYoCosvVtTThNRJO7A65wk=;
        b=UGtGyHBAlSmEhCaDCOjh4hjMZiJE6qB0DsbqcPp6NvP94bvVa139IwbgGPwXwt7H2H
         VWzLX3n6yzO0SLPIud/htyWszaczhA7N3X0vkPT/oudTYEBLjW9+aF2C9QMK2ihGdLc5
         1RJUMnVwnJMH1o2oMs1SRkEFVxI9IayhCX/ImVs9OVU3mYp3I8ihmUdqY60XjqWKdmox
         yB/C0ka2rS/ZMTi5YgBeu1ZYLtA6cAbdCIeCoqid05MHosa/JVCSGN9xmMvV4IQuL1M0
         XtqNht6nruUYm6PtuYOq6y+CKjfriwkF7C1yHLJ6/dSWvsyW5vbOQf7eA4vnLVZ6JQ1k
         LWhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699453826; x=1700058626;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oTzaAd+2ZeXUVNzWH6rbuqYoCosvVtTThNRJO7A65wk=;
        b=eJvR5/ZJuOpUP4QWNFW+SpXif4ArrwsaLL0+DAKm+wfigh46uy6XvGusY1ebLP184u
         xfTg+ijeYhJmThJkDd/6UphD4B1tAwQ7yBfPXaz2J2w1H2RaLcTlWNqDd6NtDGrQiV8J
         6GGMYTaLxZp3OPtoM29lqMjkJwFAiF5V0lAtX2tpsNIdXRuWBqLcUUrAk2lxut9smjND
         SErx8RDhKUDU3pL8QeSz+ijcChgzIAwbg6ITgXaMkoH0k1Qgt6SGOd+FXQkzJf3fdGD8
         xVY3bFUhaKpIWEsMEC+1zkRHkLdwocc6hM7A7HnhSSB7sUkJpTNW7k9VSVTj3RElBaoB
         j63g==
X-Gm-Message-State: AOJu0YzcsNYvDtENe92ijTBAgRW8IePBkfVN5SfX+6RMgyiZhQLaHVEC
	bkm9fPtoP5Dgpyd+BtP8rW8=
X-Google-Smtp-Source: AGHT+IE1uqL8BwZwNN7KNjHJV5QEuRLukkj6KHdnddSGBgXFasdAN17kz17Qkm+qhcHYTLWZEPcjeA==
X-Received: by 2002:a05:6a20:1594:b0:152:1ce8:ce3a with SMTP id h20-20020a056a20159400b001521ce8ce3amr2278552pzj.18.1699453825902;
        Wed, 08 Nov 2023 06:30:25 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n1-20020aa78a41000000b0068fbaea118esm9077349pfa.45.2023.11.08.06.30.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Nov 2023 06:30:25 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 8 Nov 2023 06:30:24 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.15 000/125] 5.15.138-rc2 review
Message-ID: <7ae8d071-3541-485b-b45f-6e4eae527f43@roeck-us.net>
References: <20231107202324.434534294@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231107202324.434534294@linuxfoundation.org>

On Tue, Nov 07, 2023 at 09:24:45PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.138 release.
> There are 125 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Nov 2023 20:22:58 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 509 pass: 509 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
