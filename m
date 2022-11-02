Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD9B324F2B
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 20:44:50 +0000 (UTC)
Received: by mail-oo1-f42.google.com with SMTP id g10-20020a4ab4ca000000b00481082808cbso13238ooo.10
        for <patches@lists.linux.dev>; Wed, 02 Nov 2022 13:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y0WD9bpr5JJ4KMTp6S73EYzDW3o9+WWWOCwWgbVamhs=;
        b=bX2scgkU89yPPrGITD1zuDsTAQZrcYmRLSebrCdqpJjiiTHjf9dlynwCzD/ng83v/v
         SwsWGsuiy+mQ7zStPGfvev2A7jtrewIp9hTHsHG/LIJR/J3SCt/yaw9rMcXuTvYFXL4L
         VxErbNO8QN2CDs2zXvrBVy8ksu+GSFnvs4j+STEXS3996ZMTQIXf2W9yqPezeEN0q5Zs
         FJzPoyAfiBdbXvtta3lN79U/Ek3bDFyGvTvYgc+qpBhSGgU/1txeNFA4gip8VWqSGkL2
         1Dly2ooS5m//DBecZIeYHizM6f0RV6ZcjnDh5DOiKREuw9kkOEjnonx+zvs51/zn7jmM
         dEJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y0WD9bpr5JJ4KMTp6S73EYzDW3o9+WWWOCwWgbVamhs=;
        b=5BvsgxnIjgPEAR/k9T1A4lQcIBkF+U+bPh5VG456mUI1K6HvLLEhC/tlLwu1SH7Yu7
         6Dv+9PHRPcXqMF6RnlN+Ewt4L/046TpV7xyfbdtEoDTt3Z6csa9ec5fFooCJx/JgNhdF
         8600ulOqlBcs8jvLmpaarwW3ol9NQJCU86eh9fQ/5/mCPsQ9rQNN39FUdE3lhnUcMSqV
         vRHqVRU/zHcurnr0N4kCYJLTk561g5kJ+9Y9s9rn1gu17qEtJ9PmMN9Cm1zk/t9jcNgp
         gAGbeK9qFtCKhncTnrJNwmC0g1N9evkSFmQrik0sMab2RfaiWy/0ktfeaw6z6BRAqGge
         6wMA==
X-Gm-Message-State: ACrzQf0EjF3MAIkHfForrqIzFdVwvTzod/X2J3kieOtXX8kRyHKpNIGb
	lfQqR0m4XbZQJViHRi5sDTY=
X-Google-Smtp-Source: AMsMyM5XkIVQhWcZiwMbOcFf0NQqDRncK5bZ4Le/9dK640e9I9W12PLvo/VHlfyVRd7s+aUtzVD5+Q==
X-Received: by 2002:a4a:bf16:0:b0:481:1436:49ac with SMTP id r22-20020a4abf16000000b00481143649acmr11389981oop.28.1667421889773;
        Wed, 02 Nov 2022 13:44:49 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o37-20020a05687096a500b00131c3d4d38fsm6496841oaq.39.2022.11.02.13.44.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 13:44:49 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 2 Nov 2022 13:44:48 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net
Subject: Re: [PATCH 4.9 00/44] 4.9.332-rc1 review
Message-ID: <20221102204448.GB2089083@roeck-us.net>
References: <20221102022049.017479464@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102022049.017479464@linuxfoundation.org>

On Wed, Nov 02, 2022 at 03:34:46AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.332 release.
> There are 44 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Nov 2022 02:20:38 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 164 pass: 164 fail: 0
Qemu test results:
	total: 395 pass: 395 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
