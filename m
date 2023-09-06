Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1128AEDB
	for <patches@lists.linux.dev>; Wed,  6 Sep 2023 17:24:46 +0000 (UTC)
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-68cbbff84f6so873589b3a.1
        for <patches@lists.linux.dev>; Wed, 06 Sep 2023 10:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694021086; x=1694625886; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rP07r7ZTWJgGRXxlI2x1G0RKq1bDbhNUk6IPeI6iQ/0=;
        b=hrbAWHWLZYFK7GDrwbcxvEVJ6gkTTIx7cO3c4OWFQmYObGU4G0I0Ax5MWsEKE7/YPC
         q8oJTYF0b1EkzSjsWhOL/leRXNYjSuxDclSJDRw/UnsytYBDshxkRJYRsET2n8uljUlY
         DYG/3BvWElFxlrXrNhubVcJSvCZnhs7Th6SHJZ7xB3F2vRFRBzR6Vg8bVGzoWApDwy/G
         q6km5X8LGP8xhU5upDpiFa/F0nSLjdFonhUGyAudVNxzPExOsz6VtipQHhUTNsNwLay7
         fDg5v5trJlqfAm+jMvSy5/sBUUM8ePhaBrMI4sb3Y4J0aqTgu5y2u/+uEaZpcUHPfB17
         kiOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694021086; x=1694625886;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rP07r7ZTWJgGRXxlI2x1G0RKq1bDbhNUk6IPeI6iQ/0=;
        b=ZjK44gAWK/45RPncJWk/7sIoH3WyEGBaMzqveOC9hJl60xFBeQFbUwVuQ7K0KUyQWB
         yPUt7KFu1EgxkvzQ3akBEI5Sho1pC89CLdSHfnl1UkYyPQFVBAQQvsTfPeI0ZFJ6yWij
         ZDBSgQf5tUMznj9XY0CFKF43+P4j6+q+k5+HnMul2DAuZsDclOXad4VK5PPM8619epJC
         emDUzdqAqt+Tgp+Qy320zxZGBO1Vbuih01zD2klbIB1NV0qp4GYjMlW1c1voIFNavWz5
         9EA/KDDckRpEvZJzW2TlkIT7G8ASQolcx86s2TR/9T1ZBJWb+ovsyb9+Nh+Tc0uxMptO
         zIjQ==
X-Gm-Message-State: AOJu0Yy/orFB4g0GcauxEPY+O92YZ6kLj/c6emCOZFsnniNASXVyYh4W
	z6w9XinxOrGTM6GJ0iifTBA=
X-Google-Smtp-Source: AGHT+IG9slQd52ZN23wso0dgHQ+v2qjo0+1OTbRqycbV/U7jJMnbbha0SCi6FsdN02O0kCVPsGUpIQ==
X-Received: by 2002:a05:6a00:1785:b0:68c:3ed9:d39c with SMTP id s5-20020a056a00178500b0068c3ed9d39cmr359339pfg.13.1694021086353;
        Wed, 06 Sep 2023 10:24:46 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v23-20020aa78097000000b0063f0068cf6csm11079717pff.198.2023.09.06.10.24.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Sep 2023 10:24:45 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 6 Sep 2023 10:24:45 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 00/31] 6.1.52-rc1 review
Message-ID: <bae0bda4-fa91-4f6f-ac7b-bd0fddb2db75@roeck-us.net>
References: <20230904182946.999390199@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230904182946.999390199@linuxfoundation.org>

On Mon, Sep 04, 2023 at 07:30:08PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.52 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 Sep 2023 18:29:29 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 523 pass: 523 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
