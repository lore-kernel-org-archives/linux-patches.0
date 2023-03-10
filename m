Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4CE320B
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 21:02:38 +0000 (UTC)
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-1755e639b65so7285935fac.3
        for <patches@lists.linux.dev>; Fri, 10 Mar 2023 13:02:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678482158;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uNCf0p/OxNkXhVGTn1gmXHIJuyHGde9FheDas3x21Z4=;
        b=DyYvUHHEPXN/ZJoVZntBBAEO8/voZRsXZmZed3MoiD2XY12tlMMgMCFg3c74Q+V5XR
         DKsQnvM36We2j82RhKgTye++/72xp14D/n+C3tO3bXreqVRFNRD6UcTDq7NptnJ1ykhh
         An6mC6LFAFOkaTiePEJJCDAm0yBvaf6Nejfe7SVwq6khqQxqv1SrtaZkGxPZyRvF455W
         CEachZIQXGf6+MncS6J5kcr3cXAqTw6U6TXMF+flZqXrvfODGz02kjU+ystBZM3jBWY+
         AVdr9Hm5yn7PEmEITAIUCLQMb/IBDuDE4GM4aNGt6aMQP43cDyh8zpQYhnFwu7FyLkNj
         fL5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678482158;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uNCf0p/OxNkXhVGTn1gmXHIJuyHGde9FheDas3x21Z4=;
        b=s0Un452X8uB+Jw4lkFoXZ9RqQNJD/flTtBeCMRpEyKkpQmttkzuKx/XHQ/TyILMMuL
         nNRBlhKbLUNSSWDLE1bpKpSVHfDyst+n8sav295/yZ4g2kqtCU8/prMa8GsL0oTh96iv
         LaHYj5mqlM9K+W2RSDOjYXmO0xv3fDo53jvCNv8hHTTIo05zDuQ3OF/7GbdEw59vv4WH
         RLClgZ+ZxN+3zmfXENwtWxkaU2JdyhonG0Jc3gZp+vMNiWjMXtaNFLBpIlLPElVdX6D7
         o8dkExKIg3pagPMSqEz6tBPYZkSbYHM0zftjbMp1SoHPxGsJfegdjVeJe9JTTmxgnSzC
         Ec/g==
X-Gm-Message-State: AO0yUKV7NsthALP/PXNxh0ryEG5ZiUVvFw4c1kNE9jBTWem4yXijsTZY
	BteaopdxA6mMqv/d9b/As1k=
X-Google-Smtp-Source: AK7set9sDHtIeZ0zmP0d8H6D0hxiogGVVaj+uGRiBCLi9j/ogBVX0lW97t7gEn59+9YMSMiZFEfijw==
X-Received: by 2002:a05:6870:a110:b0:176:3f89:3940 with SMTP id m16-20020a056870a11000b001763f893940mr17042469oae.5.1678482158118;
        Fri, 10 Mar 2023 13:02:38 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s2-20020a4ae542000000b00524f381f681sm357469oot.27.2023.03.10.13.02.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 13:02:37 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 10 Mar 2023 13:02:35 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/529] 5.10.173-rc1 review
Message-ID: <7c6de5b8-dbc2-41b3-9e1f-5edb2876337b@roeck-us.net>
References: <20230310133804.978589368@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>

On Fri, Mar 10, 2023 at 02:32:23PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.173 release.
> There are 529 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> Anything received after that time might be too late.
> 

s390:

drivers/s390/block/dasd_diag.c:656:23: error: initialization of 'int (*)(struct dasd_device *, __u8)' {aka 'int (*)(struct dasd_device *, unsigned char)'} from incompatible pointer type 'int (*)(struct dasd_device *, __u8,  __u8)' {aka 'int (*)(struct dasd_device *, unsigned char,  unsigned char)'} [-Werror=incompatible-pointer-types]
  656 |         .pe_handler = dasd_diag_pe_handler,

This problem affects the v5.4.y and v5.10.y release candidates.

Guenter
