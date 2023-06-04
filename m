Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A58C23C6
	for <patches@lists.linux.dev>; Sun,  4 Jun 2023 13:18:08 +0000 (UTC)
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-651ffcc1d3dso2003879b3a.3
        for <patches@lists.linux.dev>; Sun, 04 Jun 2023 06:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685884688; x=1688476688;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2antYKxvIwNmqy5CZTA/jD5hacvCwsyZLTjfiBAziik=;
        b=apiWE5SRBAi8uhX66jCjeKU/pAGIqPIf3sx18YKQoluVhZ1rMYOCMkyA44lGq0wu5M
         GAYpS89unkdusP6Qoy9ECNqoYMYNkiDLIQ2Omg5ZkGQ/UPGVKV9okfmQJ3ha7X204avg
         8gx807hiZF+r/V9wth0N3OXFnXr06vJcVfY28/jD98FdPfzCNcyB1O9sMN5CoBQP6Ugp
         aSuPZNfZyI2crv6+4mhh29PLrPef5a30qZQfT5/FKF5gvT+uBjn4ssurD1xMDjyujrK4
         VGD9wuLck5YZB7Ef2gFi4nUOKJmxNt2gKaeJHRG36oRCJKnfsfWTBlEwHKSJdRF2Nqlo
         VRxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685884688; x=1688476688;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2antYKxvIwNmqy5CZTA/jD5hacvCwsyZLTjfiBAziik=;
        b=FwdzS+79xtYOPjGElNHxlWWyo4Bi8Yf88RdD5lDvy9pncqzxYnoHEcw6ybB4tFiMlr
         UWiimc6oS+dK5Jj1Fc/eMUPxJJyKnd68JlJKRPy6Pf6de3j3LXH7qV95ZEMXpY2PpdIN
         fgpRqH2qHYusUwLb/nztOdtyi4EZ2x7/R8lIypKnFzSQEC1eFd8ne1VWGkENbHlUjhWQ
         yLIn0952eh6Vl8hmfKpcyS2UNXv7p6APF0/K/BsIrwUg9TEkbuRhmpI8mlZIE9DmIUVO
         /lN+m1xfpK1dNscGENb77uQOjLuTesTPm0dDoDDcUZPgwVi42PSnApQrTTTuL7mhIsty
         LR+Q==
X-Gm-Message-State: AC+VfDxXMVVBbNBxC+TaFAUFwVLvtkynEP8EGToF5T/oNcO16PWhYhtc
	XvNBcUjpOAIFFCvFCe1hIdg=
X-Google-Smtp-Source: ACHHUZ5tZkKgVKSpfQF4V5GjOlVhutEKUzrn1geCssyoRpjtBxkGmkQwJVBs4pJUDHofdpjPNuRqUQ==
X-Received: by 2002:a05:6a00:15cf:b0:653:a56:db9 with SMTP id o15-20020a056a0015cf00b006530a560db9mr5688123pfu.7.1685884688369;
        Sun, 04 Jun 2023 06:18:08 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w12-20020a63474c000000b005134fc049d7sm4152597pgk.31.2023.06.04.06.18.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jun 2023 06:18:07 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Sun, 4 Jun 2023 06:18:06 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/35] 5.15.115-rc3 review
Message-ID: <a298cb13-d3a8-4c2c-a17f-6570698d4e02@roeck-us.net>
References: <20230603143543.855276091@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230603143543.855276091@linuxfoundation.org>

On Sat, Jun 03, 2023 at 04:37:18PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.115 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 05 Jun 2023 14:35:25 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 499 pass: 499 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
