Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8011017C2
	for <patches@lists.linux.dev>; Wed,  9 Nov 2022 02:57:38 +0000 (UTC)
Received: by mail-oi1-f171.google.com with SMTP id s206so17556869oie.3
        for <patches@lists.linux.dev>; Tue, 08 Nov 2022 18:57:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iJErdUK5o9mibyZrEQBlebD3V73lwZxdQmiFFeKypDc=;
        b=cxvE645d6ZevrZLbmZvMxsjd3cqTz0o/iXXcdie78CwwBRqdqRpI1zOwcPg5/v4rT8
         XVliTnezXrjNxL1BHaj1GGsLCJ2gK+Hq86RP9r5X+v/49OXPp5NWUfBXGGmppqgbhpl1
         1AXLKRfUYgx4Q9doEWINs/n15qZHVYLxMkDTbPEl+Af+sEEyvAByyXwDXD1sG4Hf8wiL
         lfrQzhVOnfuPjn9Ya7hCmnQZT5wWpwi4zOA12qKqnugztK1HXPY1V1WyLnMYdXuAtpW4
         Y0g9aJPUcPlF0yLyOtbyjOz0QXuucifi3MSZiROprYEnND3pgIt6M/hV9mNIglBPJdlT
         eJBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iJErdUK5o9mibyZrEQBlebD3V73lwZxdQmiFFeKypDc=;
        b=ca+KcgmhHOtJ9bC1c9fjFsMdk/bul6RQQlpEj/uunm9AW7ZKc1TdbxA+Sqo3fmIrox
         WejQ2MjE/TjgViY1PRoTIoXcA4lpNKzshtqsNSoeJyjacEzlvF3diaZ2+m7EUEpZpVx/
         Nm8OqP1sY+4WjJJsHuzFwnCJi7MWa8TR9v6btAOpxtgQfIdxgeSy/Re/9qbvcTIXW/0D
         Z8lVvU2s3N4cM0xOWe0bqeBNRErB5h+gs96IMVFfnwhi1vGgqF/A0EBy6QxUO56FfBEy
         4qcr8oqss+Cy8dyWgqLIwy/JQbj+1/eTP2SNBHVH5xHl5ZYu3cGeBzX0h367Cv6U5vJU
         qSzw==
X-Gm-Message-State: ACrzQf2zliB6WuZCNUhV6txs9lgVkSoah8pjgfyUSCNmJEt32ozdv/jS
	TJ/e5nq1Zalo7fTu5yzmx1oXJpbDZN8=
X-Google-Smtp-Source: AMsMyM5/aajF9t2757MwPaWryHE7aggFsXua3cSEN2e7XoZSTua0L7ZWwOdXQ7txykN4CzYIXxjHtA==
X-Received: by 2002:a05:6808:1a85:b0:359:b07f:4f7a with SMTP id bm5-20020a0568081a8500b00359b07f4f7amr31159881oib.166.1667962657484;
        Tue, 08 Nov 2022 18:57:37 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m6-20020a4a9506000000b0049201e2b8f4sm3810626ooi.4.2022.11.08.18.57.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 18:57:37 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 8 Nov 2022 18:57:36 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net
Subject: Re: [PATCH 4.19 00/48] 4.19.265-rc1 review
Message-ID: <20221109025736.GE2033086@roeck-us.net>
References: <20221108133329.533809494@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108133329.533809494@linuxfoundation.org>

On Tue, Nov 08, 2022 at 02:38:45PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.265 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 423 pass: 423 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
