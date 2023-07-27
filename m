Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6708CEBE
	for <patches@lists.linux.dev>; Thu, 27 Jul 2023 00:03:17 +0000 (UTC)
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3461163c0b6so1257525ab.2
        for <patches@lists.linux.dev>; Wed, 26 Jul 2023 17:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690416196; x=1691020996;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GyRkc+BwxPYQKWVJ5OHqVWRTxIHN/8jDOBRCNFouIw8=;
        b=p5tGEaj5K6sEH/7kSN1m/FiFuDEWcPX2MbuJ+ZrXp/O0V+LknB/oO9PhwcxB5Uukbd
         TfbuVUJmdFR2gX8j8wWfy5QFeD0mDwzpxcHBdOYx8oQN0ntchorVSahpqTof+rHoyr9Y
         gSjxa8kpra0fhUR+Ep29mvlLBwQWvLgTxAdQnihseM43ubZvT/pv802mBsQt6gqJanfQ
         j7i2CjYi8BKnXfZQWZPTwZ3rEQO5tLN8vN3iC93S07AcP7N/PEawXQkNantfrH/dHyrl
         I9tUCtLVAUr+aTHPncxQ8FuGXtYD2FnWXJMMfnCXN3foM0Qrr+FEuGlcg8IxlQtdDr3c
         D1gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690416196; x=1691020996;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GyRkc+BwxPYQKWVJ5OHqVWRTxIHN/8jDOBRCNFouIw8=;
        b=X3MzSetT8pRWV4679DvDLykzNUrDqKvLKvDvJGKkQ5lAZefvvixv50sB6lFlBETPRN
         glchlbN9JY709fMPQJssmhidBYseIvg0W+MCDzwJeO0JEZ64VMBahoBPkBePwObYfY8K
         XoriO/NVs86ebyovfj/KGw1F8xg4b/rWOMULOpZLm1ynCgSgSCFcQyzdM3vkgdAAvLB/
         5/yc/M1ffdmKoap6ZpYT0F0oT0XXanC0aNHP6plNo6TV1oDFuscjfTkeSYOH3WDS9J4V
         FmgJYh9NN9sC2EsqX/WIg+4HdxhkxoMlvQ3dGA0veUEe7idEsQGUxun2jGpH7WCW0aEj
         XDag==
X-Gm-Message-State: ABy/qLaDRL9xA04Vm4Ua4X2+SQbxLiUxubi3FRVs14jYqQzPJ6ulZ9C1
	8sfclsZS0Xqgt/x1Rg/Z40o=
X-Google-Smtp-Source: APBJJlH6YYpgcmF9mbkLqCjZPmLJ+edFwQ9O8I9EQJGs+7uhgALL/Yk/LkqQbluAl35dkf4ljNFwkA==
X-Received: by 2002:a92:cd82:0:b0:348:d654:7ff6 with SMTP id r2-20020a92cd82000000b00348d6547ff6mr4041229ilb.4.1690416196362;
        Wed, 26 Jul 2023 17:03:16 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p14-20020a17090a4f0e00b00262e485156esm1700596pjh.57.2023.07.26.17.03.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jul 2023 17:03:15 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 26 Jul 2023 17:03:15 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.4 000/227] 6.4.7-rc1 review
Message-ID: <736c341d-ccd6-4c1f-9a1c-5c1465fac06e@roeck-us.net>
References: <20230725104514.821564989@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>

On Tue, Jul 25, 2023 at 12:42:47PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.7 release.
> There are 227 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jul 2023 10:44:26 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 522 pass: 522 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
