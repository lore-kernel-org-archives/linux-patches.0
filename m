Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61489D2F2
	for <patches@lists.linux.dev>; Tue,  4 Apr 2023 21:23:19 +0000 (UTC)
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-177b78067ffso36207214fac.7
        for <patches@lists.linux.dev>; Tue, 04 Apr 2023 14:23:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680643398;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M4HDAQLxCV64quuxVRbO0mmi1IW8Im9RB/8o5GYuqDc=;
        b=JZPRAhpHmUZQIQZ3jxNY0S7j5eAxdxa8wciV3T0/xIrHOiu/DHGI/zjGy1pPd9ttMC
         FjTWZ+V8i2CxEt7Jgq3UDQ76tOWBhPw9YYNAK1q8YF1oNa2aVhz6HMpim5j6ZPN1scrt
         rjIvGp2Xkc+IRzueCCjgNq4l//Mbh+DPU7dClPVCacL6Ea2xXZgOE1/qHcArPo/neNrO
         qHTujyDYG0Jjiz69kC/WLEAWwnZl/+Mtqh9g/1IcGwJYpcl+9AwsrWXbMJfhLqNyAYZo
         f8Kvc3SZ/BZ0G0oE2aZr/BPr9LJ/xZQkB5uqzEctHzfIn3GgSh4ZGNss7QDzvxmeVTg6
         04lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680643398;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M4HDAQLxCV64quuxVRbO0mmi1IW8Im9RB/8o5GYuqDc=;
        b=OVUTOuJbGsrfGcBAFNlPRermnD4wNwayQnz/Msle6Sh8Nag73l0JPGslc4iwQZHFWq
         oIam3DsLr61wq7JyAJVSWbV3VI4FkNVZovCN5Xgegc709q2cri70FdyuEbhFufC7vWE6
         SEXAtOxH5ZCESHsMSTaAaL6d1dBXc2pFX20bG9WnZMV3bLMEvypPuKYuxxyG0qyIle9f
         Sp1ogKvCy9b2MnDoipnYabQ3E0IQmaAQ9Csgd30ckBPUPJ2Qy/0kDbzfwztVW82L5Bmg
         GJb4yDh8SES3ev8dzubemRQwXdpPYkyMMhjE49SETeVS2NbP8lhLdzh3yLOi3sJ5EgJy
         Mqcg==
X-Gm-Message-State: AAQBX9dJ9+4rv5h/F2y1ZPMf1ih3IB5l4AVfuHVSFKV27Wk0GsaDiVDA
	DVKLySPpMcLWDmKY8x0bdlg=
X-Google-Smtp-Source: AKy350bSdPzwRwUrZRCs/Fry6tr2SlqbFV9okJHWz30oT9AT7+0YH20XOqyLKzCvoKtgk4TB3pqOxA==
X-Received: by 2002:a05:6870:b48c:b0:17f:5b32:c492 with SMTP id y12-20020a056870b48c00b0017f5b32c492mr3092693oap.43.1680643398564;
        Tue, 04 Apr 2023 14:23:18 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l11-20020a056870218b00b001777244e3f9sm5286273oae.8.2023.04.04.14.23.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 14:23:18 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 4 Apr 2023 14:23:17 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/181] 6.1.23-rc1 review
Message-ID: <23e8a91c-21f5-49e4-ab51-43a2f9c07604@roeck-us.net>
References: <20230403140415.090615502@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>

On Mon, Apr 03, 2023 at 04:07:15PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.23 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.
> 

FWIW, this is for -rc1:

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 519 pass: 519 fail: 0

I'll test -rc2 tonight.

Guenter
