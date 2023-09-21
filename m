Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F865199B5
	for <patches@lists.linux.dev>; Thu, 21 Sep 2023 15:51:57 +0000 (UTC)
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-7927f24140eso43608639f.2
        for <patches@lists.linux.dev>; Thu, 21 Sep 2023 08:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695311516; x=1695916316; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HOWTj9FP0vaaz3q49p+fKdClapweM+Ed4jAzEAA9yno=;
        b=aIJs9PearT1f3eizW9dCqWqwmINSACOXd5kp/6lyZY22M/zFDn7uMCvgwEioqq+Jvw
         6uNngXRSVL8f/TSkdAVFw+CpTPaQc/9/GCNqOomYaRZsisOES3rj+hyIGw9vMwgKMGKF
         /VjbfgZDlidnmZUbpv8UllWc2e0QrZlqZTenAblLrz+OrxrPVGd0tnacGKDxMeqMllI9
         WE4V3fdvVICYKR40XWdAhl63vE+yUI6IzGXiBczdijWSSWConmLIsGWwyXwNMlnlfFQk
         8Dw9j4QIIrr37973pm0Smfid4huDG5fczvDKF3gUprZD8NtX4ANYEzkJi4P1MJdxlw85
         tqmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695311516; x=1695916316;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HOWTj9FP0vaaz3q49p+fKdClapweM+Ed4jAzEAA9yno=;
        b=qk98zj0rR1I5D/rS96HSsplTPOldv18mO9tpiH9nG2uCVRvw4BxhDPin/gAFBpU6sJ
         IjBKEfckkkwV5IixS1ozM2MkVzyG2sC4yRGRDImHXeS7PYnnN+r/XiUXeePtbUZt24xp
         3vD8u0qDqf33v4Ch71n3c3xiLznP6E7z+f2aXfPfkBK1ZAXk6I5NoXC6n9AyL5myYB10
         ZAAJPcbaxHOI2Bh4kxkSoz0wikFQMiNrgsTWKgx+7Gjhv3h7G7sUlCrdtWHzrKO2f7m4
         dNnb/W3Yyy3NxMiZ9NJ3ob/5hBv1zdmZ4/V8xzE+y0tVDDmqyBfadkGucHw9DU7Ano5E
         7hfA==
X-Gm-Message-State: AOJu0Yy5UQQM7875U8bhK+tZveiiB08XJujh2GsuJYd3YAKvWUAtmFqa
	4g1Pd3xs4N9F0zu23YLpjTw=
X-Google-Smtp-Source: AGHT+IE9zcw1DS9VmayNJucKFF84Njj6B5FeeIlhqZa34RI2TxAsXoEH16utjF2kucRF4hs8Dc6uRg==
X-Received: by 2002:a05:6602:22c2:b0:794:d833:4a8a with SMTP id e2-20020a05660222c200b00794d8334a8amr6096222ioe.0.1695311516461;
        Thu, 21 Sep 2023 08:51:56 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id eh3-20020a056638298300b0039deb26853csm430538jab.10.2023.09.21.08.51.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 08:51:55 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 21 Sep 2023 08:51:53 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 4.14 000/186] 4.14.326-rc1 review
Message-ID: <d68ca4b4-9c5a-4ca8-9205-4159bf75f2ff@roeck-us.net>
References: <20230920112836.799946261@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230920112836.799946261@linuxfoundation.org>

On Wed, Sep 20, 2023 at 01:28:23PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.326 release.
> There are 186 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 22 Sep 2023 11:28:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 139 pass: 139 fail: 0
Qemu test results:
	total: 440 pass: 440 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
