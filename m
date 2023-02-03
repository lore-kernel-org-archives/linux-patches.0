Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4986E79C6
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 15:56:22 +0000 (UTC)
Received: by mail-ot1-f54.google.com with SMTP id n25-20020a9d7119000000b0068bd8c1e836so1472860otj.3
        for <patches@lists.linux.dev>; Fri, 03 Feb 2023 07:56:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iE1pKpiWh3rkANimRBhetH+fDbjSGx4Mt5I9hOjSbgk=;
        b=o1P4zQrbG/9qLAHCY57S2f0+H1Uz9Ki/jqBNkrNiJnw5a85Chyt5m08RZoPCyBu1TK
         8mPESisNocHPoc3bF+4h4EQ1Cl8ldm+GjD2rM1m3NYwQZykc1J2gCXt7y0WjtbEbG5Ni
         8H3Z4ZyDNzKMFXgjJRSWasGosZBnec3cCI6i5LaQ/q6f3r6S/LduQxZmDa8bL1R0aC5C
         P/GHjNKbsvEEieVmnjrzOd3KnrDlaUzRqsSSCNFfZOREcK6jP1Z/EqYJFOwh3b0ZhGYq
         KRbqKogaZen1RMEREqtncfe1ikQJRHJBCXHpgtJTy4YsD3AlcTxwDK5PQjHGEkQn2vOr
         2itQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iE1pKpiWh3rkANimRBhetH+fDbjSGx4Mt5I9hOjSbgk=;
        b=QSAl0ofKIAPIuxIVewOE1pN0uGr8/lS+6+zUdjCx7Tof/l5iFxK8SJNfqZ68ce7e8u
         tMRB6hO5Kxzh039xM+WqhwxfIQ+arG5fNWQslVkVXBDHmi6ikWl9bgKcW4GK6iYupeCX
         fEy9TjnL0Kt49U4eoNCrQiuV36Dbf/AQtfR5jVUDGUSLgpMmJ/OWvUwlrXQSPRaWOS+8
         5a/yM4K3gpf1iQztoZa7OGRVs+rlCDuss6D8qr2mDFw+qJLjKFribmcO0RKDGlhJdcnd
         X+6nkqc51YhJFWFZIB9HB5IVAYYA7q+RvAJlPE2/oMmDM0CdH7eSa31ejpZiVyNsrrjd
         kyRg==
X-Gm-Message-State: AO0yUKU46AKXa5v2ZoocV9ZFCChYK/emULLEDUuGjpII5HP2EUWVG7z6
	euUOxVOa+LHkEbYJTt0BYwU=
X-Google-Smtp-Source: AK7set8I2ugKmFE+rmPgMsepUryVPkqQN88t/SnyDwlij+DzqHItFPGHLEGCKjpKBrpNvjVBfD0sDg==
X-Received: by 2002:a9d:730c:0:b0:68a:443c:8c9e with SMTP id e12-20020a9d730c000000b0068a443c8c9emr5596265otk.4.1675439781369;
        Fri, 03 Feb 2023 07:56:21 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x9-20020a056830114900b0068d49f4d8dfsm1204742otq.63.2023.02.03.07.56.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 07:56:20 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 3 Feb 2023 07:56:19 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 000/134] 5.4.231-rc1 review
Message-ID: <20230203155619.GA3176223@roeck-us.net>
References: <20230203101023.832083974@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>

On Fri, Feb 03, 2023 at 11:11:45AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.231 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> Anything received after that time might be too late.
> 

Building ia64:defconfig ... failed
--------------
Error log:
<stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
arch/ia64/kernel/mca_drv.c: In function 'mca_handler_bh':
arch/ia64/kernel/mca_drv.c:179:9: error: implicit declaration of function 'make_task_dead'

Caused by "exit: Add and use make_task_dead.". Did that really have to be backported ?

Guenter
