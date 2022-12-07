Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00DA82102
	for <patches@lists.linux.dev>; Wed,  7 Dec 2022 14:25:29 +0000 (UTC)
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-1433ef3b61fso21421651fac.10
        for <patches@lists.linux.dev>; Wed, 07 Dec 2022 06:25:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CNO7oy1kZ/LbkPvSex6hVFeb8qf9A9gkFQgfh2XVq/M=;
        b=ONffI2aXVriT9+sJJpAv8XUZUt6ZNdVOnfSfE73r3U6mJz8/s3mZCWCnhH8xmuNZ6u
         ARmTT9OtylpJJno0ZF48ayrSJh1USW6xWIVhxG+eCVR6rjgo4+bDdeQ0ylCmFGieBdQS
         0PSnzdZBROYfvazFWex5Buse9ddjpy7/4sbECbrMgZ9ZEVF5U6qIPON8e12Pt8Vue6lV
         TEp6XIVZLo0PkhfYBiaTdEDh6cgbEH+9h1QC21cvabHuHt2RzoFpHgp/V+HXF49+4MnH
         OSKoGRG+AbheDqiMSdOvfkwhjjdl7SnG8spiSn0dezH4CfArtarMo0NxfMep+bmjvXvb
         smtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CNO7oy1kZ/LbkPvSex6hVFeb8qf9A9gkFQgfh2XVq/M=;
        b=eEIJeAGnzniuLduQ785DEPlsKqJuLvnq603ipw5DANw2AxK8f7H7BMqj0B1XzLJjGw
         wScJM9S356EwOAbVNAkZ2ClspzU4ffjY2tJ1+O5e0AugF+BnoExEWF4lomXNnO0w1HZ1
         Bh9PShG2Xy/1Pdl9WcKA41StqTYq4ZzMWS8qw4+i4SXg8NEwDcFyLWWWDQymcCIucVBn
         HpRchQiXG4WzUreu5GiJgmGfAAttmkCFm+NVSG4BwSek/D2OOXN/bHDg7IfOPiz3ObMh
         cdkYXI9ykCQhyqccHYrXy2j0SKmeaqF5wTIPmbHyZzje+rntQD+6x3qg0BztQ8UIn4mU
         0kvQ==
X-Gm-Message-State: ANoB5pnLDxgh0XdNfP17HNxtepT0i0wZmZscN2bDh5enjOnJeGuE3bmL
	XmAAqpZpyzJcFH4PnMpBygQ=
X-Google-Smtp-Source: AA0mqf4DBQ3/oxfxenA+7m+wGzkIZJA2gjRBYzlrAKKmg+uSE0ATyn2afM3a9RiQyuxdd8vvXSmmXA==
X-Received: by 2002:a05:6870:d90e:b0:13c:ed73:847e with SMTP id gq14-20020a056870d90e00b0013ced73847emr52506663oab.63.1670423129004;
        Wed, 07 Dec 2022 06:25:29 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id cz41-20020a05687064a900b0013297705e5dsm6212167oab.28.2022.12.07.06.25.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 06:25:28 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 7 Dec 2022 06:25:27 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.14 00/83] 4.14.301-rc2 review
Message-ID: <20221207142527.GB319836@roeck-us.net>
References: <20221206124046.347571765@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206124046.347571765@linuxfoundation.org>

On Tue, Dec 06, 2022 at 01:41:52PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.301 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Dec 2022 12:40:31 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 422 pass: 422 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
