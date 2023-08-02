Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B6417AD9
	for <patches@lists.linux.dev>; Wed,  2 Aug 2023 23:18:49 +0000 (UTC)
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3493967982aso1394045ab.1
        for <patches@lists.linux.dev>; Wed, 02 Aug 2023 16:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691018328; x=1691623128;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dU5fGRqdm19hvPL0a1DAQiQ08oJyXkJ/0ssHdzzPO4Y=;
        b=Q9K6SlDlz+RRbQbWapUgITtMzaNMwmw5Pclq1xeKV4eaUAFjrQUzykWiJmmumOgC60
         ZoAz00n8/GwwFgopzVwXjQ7lBlkM5c6tviVt7/aCzW8X/oY23dDMlcJXZ27SUKhB/Zen
         onPCRQvlaA51P5Hhqt2bqQEoZtp3zhbmdArOvblOMES32s/DKuCj/EP9n1fR6NDHEL5r
         ySHmMFIv9O+rTJX/DnAcSL1KDUEa3xlhBwMa+vZ/apX60qX1hszF8DfovjBNzI1JGfzb
         PhCJauoEDgk+EpI20ahC/eSxKhggDgPE4QgHaSDEJmkG1HCCq6Euwe2t3pzgaBL8HuLQ
         RMFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691018328; x=1691623128;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dU5fGRqdm19hvPL0a1DAQiQ08oJyXkJ/0ssHdzzPO4Y=;
        b=ISwfy6ziU6ulcIwYVLi1xwpIswPTfjTlJ8h8HxrryCyNO73BxTCEN8zube1AXFcfaa
         wWs61OGgDbYRDQBdh7VQDvuGELyJnBHBLGrBxGP98MSbytXwcDddup4cORz70ISDkuOQ
         sBiQiFIdfZHlwvZiMNp1fU2Bf17RKowiKfZQbkp3lDt/xjDXwU5wSDIkX6d17x+MMiWz
         iwcmon0xM0zn+FWHi4ENI+OHUBbIqzZbupUcBTLBZ/rKMLIplE1C5PCNzKAQS90ZA995
         lTtdQjO6YvZW2BNBJ6Jr62uKRFUOoKqy8XoOYAy2oGKqL1p5bFpFBUjMCqZswmcVMVdW
         tClw==
X-Gm-Message-State: ABy/qLYgYZdzdculUdwjQGL727aXBBAtWl3V/UB8sFZOMyvo2taLaAwF
	ZGBgolh5ZsMwOoBmVyCtVNg=
X-Google-Smtp-Source: APBJJlG1Hs4b2dgheEA+hX7osU1LmTU2OHY3ZEWy76O6oZxG3CN2XBwQW0IJMIXbzhyZ/jmoHaL61A==
X-Received: by 2002:a92:c5c5:0:b0:349:1d60:f038 with SMTP id s5-20020a92c5c5000000b003491d60f038mr9939581ilt.27.1691018328484;
        Wed, 02 Aug 2023 16:18:48 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t7-20020aa79387000000b00687087d3647sm10420128pfe.142.2023.08.02.16.18.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Aug 2023 16:18:48 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 2 Aug 2023 16:18:47 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.4 000/235] 6.4.8-rc2 review
Message-ID: <a7ba730b-bdf8-495b-9d4c-0aff09470bc3@roeck-us.net>
References: <20230802065501.780725463@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230802065501.780725463@linuxfoundation.org>

On Wed, Aug 02, 2023 at 09:42:04AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.8 release.
> There are 235 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Aug 2023 06:54:15 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 522 pass: 522 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
