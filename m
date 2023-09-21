Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E0D20E7
	for <patches@lists.linux.dev>; Thu, 21 Sep 2023 16:03:11 +0000 (UTC)
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-79f7e7342e3so41280739f.1
        for <patches@lists.linux.dev>; Thu, 21 Sep 2023 09:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695312191; x=1695916991; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=stmDjRqrydw9T+1lCouVY3Uv1f4EVHPERdZg9Bbajbw=;
        b=Ul4i6m82vLrRuoCuptBGguJgXCXIFOJ3jq6t0LWv46J33lx+h92ZxEsdhbgRKVBNDF
         bs3dEs+W3rL/uTfSWcLiih/igAbcXPFBu2wHjcg/DgVbkrQ57um96+ihHjDUWokHez+s
         Djcf3wMVy/Z8Z0fqiJ0U7BFMkoWjSnHWjeSEfOJZyssRGFHiZNglNuZmzX/iPI9nU+AS
         aZj6OZG3DhxI4R4wVx9HC/v/SIBlx+YP9ZIbNjAg83ekNa/gqlAvpXNtTkx5UJeW/vXX
         oWMrSDXvHb1EZpE5zZC/wwbamNkVmm6VBSXZvb48f9hjuYinjHiD8mIQScqtsD3spJxE
         8UWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695312191; x=1695916991;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=stmDjRqrydw9T+1lCouVY3Uv1f4EVHPERdZg9Bbajbw=;
        b=VTku/mF/dvHOrMJdq2gvXxtD/o+NBzInt17NWcW1KJBn2YKrt2b4oHd0nyjJuxM3+n
         oUnK8LTk7EAuONglQlFoYMA4TH7cFHu+PAQ1MzAKiy9W1Vw62dagmbxsAOaVGtfAF5ku
         NG0zpYpMGIKEKGhukukNOYSLfB4tBrY704PbUdpnmtUcoet5q9tbyiu+5UuMVrVZH3FI
         vGXVpMD9w+YqQLX47P27cX1Q5C8oaaAd79NzIot5ZS2aQBLH6LZziBgpfAPDDTjyjUJk
         qm6zevoH1iug3pufy4PlVMs0RggwZm2L5pUcqJjOc9gGwR85DnB3Vn/H1T5ebdWiXhBR
         OApQ==
X-Gm-Message-State: AOJu0YxT9mf6vyyn5TFZejhrDFCvJ+UkT/nrz+nLAPJDBvr4MnTWq+8/
	k3YwRZdQI0A+JUpg2dZ0HsM=
X-Google-Smtp-Source: AGHT+IFiHZyMRpdGiZ1E6UXgm573zyR7TWSjF/T7qDc93cQOg6cZFDoXUiDGgaEVHX5802gBYd7LEQ==
X-Received: by 2002:a05:6e02:b24:b0:349:2cd0:4368 with SMTP id e4-20020a056e020b2400b003492cd04368mr7539506ilu.18.1695312190710;
        Thu, 21 Sep 2023 09:03:10 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u9-20020a92da89000000b0034e13ce8ddesm511420iln.21.2023.09.21.09.03.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 09:03:10 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 21 Sep 2023 09:03:09 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 000/139] 6.1.55-rc1 review
Message-ID: <7d99c7d8-cf39-4ab8-a385-36af98f4a30a@roeck-us.net>
References: <20230920112835.549467415@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230920112835.549467415@linuxfoundation.org>

On Wed, Sep 20, 2023 at 01:28:54PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.55 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 22 Sep 2023 11:28:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 156 fail: 1
Failed builds:
	powerpc:ppc32_allmodconfig
Qemu test results:
	total: 529 pass: 529 fail: 0

Building powerpc:ppc32_allmodconfig ... failed
--------------
Error log:
drivers/usb/gadget/udc/fsl_qe_udc.c: In function 'ch9getstatus':
drivers/usb/gadget/udc/fsl_qe_udc.c:1964:17: error: ISO C90 forbids mixed declarations and code

Guenter
