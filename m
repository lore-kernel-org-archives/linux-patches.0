Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8946F17E9
	for <patches@lists.linux.dev>; Sat, 29 Apr 2023 04:10:11 +0000 (UTC)
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-63b57c49c4cso559530b3a.3
        for <patches@lists.linux.dev>; Fri, 28 Apr 2023 21:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682741411; x=1685333411;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tjvvpGcIfO9/6mwyUZ95vKLipkSeEdsdP/+UUpT4GIo=;
        b=a+NtvOhsHC7mJJxkkpLs46QmV+56Hu0N3ksL8ctjHJmEF2j/cXPpztiDFHdoEk8T+z
         IIaS0wyJ57b/aPAD3TBxyzf2pTlVw2qD699BZrtDtolKCqHyHbhIGuHinTf//It14BXn
         G1Ql0qm7C2cxfJjU0Z0KCDyNETZe9pv2zn1uhbB7QENUmA3y8rQ444sz/Lx2S5mGGltk
         FWrbDpGiKGDtRNbxL6x6oqWPpfOW3oiy/I/OtUbw58vKrAeEbMDBda6fCBWhqnmRCoD6
         FBfQRc+sjUR59yBIT0OBBbgCvsnBnaFH2D8YnZO/n9A/cTsQh6FAYlpf/mZjSSJcHvvs
         8ZKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682741411; x=1685333411;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tjvvpGcIfO9/6mwyUZ95vKLipkSeEdsdP/+UUpT4GIo=;
        b=lwhcQ8ATEsFxEhGEKF9KXzIvaB5tfSxE8GzFTuD2BLGhWm7pMLVmJ6+105r0pUgCqr
         7IEeDg2kWEBn0fmr4PmAhdE+q1vjZQ1WB/wIoPl0ovRG9ZNhNDxvukfwt4faL0d9hyZl
         x7AyB9DTUPLMGnWRU3FFawYN1TE1gQMZEAk6Crp1MhSZNaZsE71+J4k6RpAKErM1ArNN
         coRqi0t5TLZjf9VP62Q/VvoNCG2XNX2AGJvY9dbm6x1by69q5YNfeylOWsaof9yQBma3
         fLcFOqzSzkIXwTiQUN6PqPdZNBKuD76M55szS7+aFm2YQsgRtJhY1HJz47mWCTiCFXdn
         XwsQ==
X-Gm-Message-State: AC+VfDwdM61QMQqmlVcde0sLCEh+dK8B8wabr0foWRUIvdP9iafVjBKz
	r8nEF9b5qHJzWPIPvR1llmA=
X-Google-Smtp-Source: ACHHUZ4uTBVDNMCrbDaI+hYI9X/r5lZTnpaCGyGxZyBeAFx3mUwPIccx6mCH5rvZjuI1aD9Hs5SMSQ==
X-Received: by 2002:a05:6a00:cd3:b0:63b:6d60:9a02 with SMTP id b19-20020a056a000cd300b0063b6d609a02mr10854773pfv.34.1682741410883;
        Fri, 28 Apr 2023 21:10:10 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p10-20020a62b80a000000b00636c4bd7c8bsm15785546pfe.43.2023.04.28.21.10.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Apr 2023 21:10:10 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 28 Apr 2023 21:10:09 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 00/15] 6.2.14-rc1 review
Message-ID: <35bdf66d-0615-4d2d-a9fc-a4d226c5b54e@roeck-us.net>
References: <20230428112040.137898986@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230428112040.137898986@linuxfoundation.org>

On Fri, Apr 28, 2023 at 01:27:44PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.14 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 30 Apr 2023 11:20:30 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 520 pass: 520 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
