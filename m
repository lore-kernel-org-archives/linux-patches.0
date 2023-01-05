Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5C5EB27
	for <patches@lists.linux.dev>; Thu,  5 Jan 2023 19:13:19 +0000 (UTC)
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-14fb3809eaeso37954709fac.1
        for <patches@lists.linux.dev>; Thu, 05 Jan 2023 11:13:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l1yEfcKH3h4k7bsnfnEIFWm2A0AEAGBTq2L3pGIOHTQ=;
        b=q3dH2bGhc9ZqFyavB/p3WoehLk4YVFRc6q5xUb33k935303gQW9C98wLmPq6WAPfQB
         /BHvIxCIj7CFRxYm4u9tk3TRMbFaP4+lXz/7TOg4zzqSYm9QXZEHZsEIXOMhJl7M/nnI
         eRIvRYauk6ZptnxdVuSVRNtoQCx78BvrWOSxJX+Q37gsAhM9xLyWcVESbk/86BNMsHzh
         TpjqSX7HsAZO8kkIURmWKSjd7Jty8V9Y2O7D58wnpKnRB+h6+cSs70GOUWG0w61vqF2n
         YCZgtNiPqxKg6WRKrG6rerl7IDpDq3mvt7n+Fc7vAUxHe9n+zqdCoKnXhd7lndeQ5PoA
         HwHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l1yEfcKH3h4k7bsnfnEIFWm2A0AEAGBTq2L3pGIOHTQ=;
        b=Ff8wFYNW/w4ATrwnrZc9Ol6UaO/evmZSrLB42St+HkNN760v5YBHUHXyFYFIa7AwXa
         y+X7dHU4BCCUWHl4wA7BKagpeAWgUHHS+nDqEkgpQShAh/MAHYAycc9RzIPAwtPNn2CY
         R+mDm+WsOOGUcMrMf1SWg1mMPl+RNEUPIZPF35wZPeImBEiDAjDa78fJJGLWhSAYG5Pc
         P9rdf5RWr9MWP6ezARfb1rklq1CNIy6ZnriY/CE/CtaarNNfNdFk4aLRI2VCa/E+gC48
         Hygh/9Ka3dKvtcrjfttgmM7G1d3C9DMKSs2gWkNz2CpWJjSP+bK0quLQSCe30q9YTt81
         lX5w==
X-Gm-Message-State: AFqh2kp1QrMRkfP3LyAXzvMKcTagoEJTINglOM7EzmDoVyxfj+TZTZAt
	NVx1tBIi6V5v/8bAvTEd8Po=
X-Google-Smtp-Source: AMrXdXvZ6qeozbL87px31h3sndWRTgoAZ+uKYjaMWzH3aQRttuQcghrK6kJ7HKWUUo/Xj2zdYLe+sA==
X-Received: by 2002:a05:6871:230a:b0:150:703d:1488 with SMTP id sf10-20020a056871230a00b00150703d1488mr11934013oab.7.1672945998869;
        Thu, 05 Jan 2023 11:13:18 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s24-20020a056870ea9800b0014c7958c55bsm17452362oap.42.2023.01.05.11.13.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 11:13:18 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 5 Jan 2023 11:13:16 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.9 000/251] 4.9.337-rc1 review
Message-ID: <20230105191316.GA2928293@roeck-us.net>
References: <20230105125334.727282894@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>

On Thu, Jan 05, 2023 at 01:52:17PM +0100, Greg Kroah-Hartman wrote:
> -------------------------------------------
> NOTE:
> 
> This is going to be the LAST 4.9.y release to be made by the stable/LTS
> kernel maintainers.  After this release, it will be end-of-life and you
> should not use it at all.  You should have moved to a newer kernel
> branch by now (as seen on the https://kernel.org/category/releases.html
> page), but if NOT, and this is going to be a real hardship, please
> contact me directly.
> -------------------------------------------
> 
> This is the start of the stable review cycle for the 4.9.337 release.
> There are 251 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 07 Jan 2023 12:52:55 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 395 pass: 395 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
