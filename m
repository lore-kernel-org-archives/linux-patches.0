Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7636FDF
	for <patches@lists.linux.dev>; Tue, 27 Jun 2023 21:33:55 +0000 (UTC)
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-543c6a2aa07so2684157a12.0
        for <patches@lists.linux.dev>; Tue, 27 Jun 2023 14:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687901635; x=1690493635;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l032ei3THBbpXbHFTtk6BrFOBjlXWcrXrnfyPyB3vBQ=;
        b=Z77Nls1HJMIAW5+Tn6vViEYrvA9hlHg9ugDlCaf+RjJnsmLa4xkVnmozjY4LsdCmpn
         yOfcpxU9+MbfFtNjRHXYD/o0Q/nu5Nzqd4hBthGTBkW0hUeKFiJgTyDpvSCvbkpfsF94
         D4YNRGsZUV4/xCHaJUw6Pxv+r0f9lHb22djLl6d+lZKq9w5WUjFfnEs+apu6ZUywY4Nd
         rVrLwQGWAgNmTKOhoHOThS2G/hZZ4aZcZDM1FerBuqyyLpv+nyFjEB/f+vt5e7IeKN8p
         VKLDkL9CEuO+I+qiE1n6TuUSvzKOAi9pzrLGiXUM5NAaziqXK5EATELV/KmOvGZx/Got
         iHVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687901635; x=1690493635;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l032ei3THBbpXbHFTtk6BrFOBjlXWcrXrnfyPyB3vBQ=;
        b=DT/POUj1sCuGVnQaELBmfbg5bwia5/yh7rE9trsV6QVQbR2n4hxJe/Es6KVligllxS
         2nfOt9M7lUOh3rkNQPBW4FWakXN4yHGw84xlk0k0YAw4N8C+OXw4c8qDd0Kkj+xuqyUP
         hYVcQlXZ3zjrltOTNh3OquBrzyvjXaHx2gveGnuUFAYVXDA6gOtbTSHYNx3HpptxWEHq
         q0jEO+XZCYAmAm4PH21vPt6gXIhtI5oZYOab/xnXHtLAnJBrrQ8qIdwSvZD5lbxfQJ/L
         NPejFuOsPxNl/P8cBOHuDxgdCC8KBKZZCLhslnHYnDML8jVu3/9ij2r8xZauFvaKAJcR
         bhSA==
X-Gm-Message-State: AC+VfDwYAaT6JcKhIFHNAUYhGnDt0qK3ANJy9d5sdtqLfsi7wZnOWNV9
	5bYKdU21EKwmAJNYx19MkAg=
X-Google-Smtp-Source: ACHHUZ7eMIKHXzr2r7w/oRls7XIv31Dp+9iIZUIiOXVsupTB2egnKnV3tw1oEbjR8X0QuT0Spq1CDw==
X-Received: by 2002:a17:903:2308:b0:1b8:142b:fb5a with SMTP id d8-20020a170903230800b001b8142bfb5amr4850131plh.53.1687901634743;
        Tue, 27 Jun 2023 14:33:54 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id jl21-20020a170903135500b001b414fae374sm6385023plb.291.2023.06.27.14.33.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jun 2023 14:33:54 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 27 Jun 2023 14:33:53 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 4.14 00/26] 4.14.320-rc1 review
Message-ID: <758158e4-a9da-40f2-bf05-2128c8bd2b8e@roeck-us.net>
References: <20230626180733.699092073@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230626180733.699092073@linuxfoundation.org>

On Mon, Jun 26, 2023 at 08:11:02PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.320 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Jun 2023 18:07:23 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 166 pass: 166 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
