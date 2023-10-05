Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1410612B74
	for <patches@lists.linux.dev>; Thu,  5 Oct 2023 22:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HP5gAFpi"
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-351367c940cso6351185ab.2
        for <patches@lists.linux.dev>; Thu, 05 Oct 2023 15:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696544292; x=1697149092; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m3ykGcA4xlf9dRz1IpNQ+ZCL6mA883W90HgWdDG0/kg=;
        b=HP5gAFpik1VEeY04L23AVawINMRcC56VaTEBTssyRPH8PjFywGPIKPr4TTM6tgbOU0
         AoVSA3vMFulIQv4KCQL2/112WkFOGSMt7W8E78gl6BwnlFIEh/6Nuu72bhl4E6NEtydX
         YU4ckpBKpLbd1qVNNIh3oihR8a6AXTt/bvSA4ab87AlfBBKrkxuO4mon+07DfADGJ77K
         oHAxdbdfCrCVZaJtR4ASplLnH6oqpuqoh3ZFVQLxbJf0nTjti1dj+E5Sb7egZTMbUzR2
         RsyQrcvW4H2XdmNOwdL5MMMk2Su5c2IOko8pKte+2lNemtiAabp14U8Ps24dZrNdYb6y
         D0AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696544292; x=1697149092;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m3ykGcA4xlf9dRz1IpNQ+ZCL6mA883W90HgWdDG0/kg=;
        b=lUfOeUyfpyukT0MDYR1QWseZoYNVhoNak+Lxaob2BVzLfZnqDMAD/5nMdvsWG93KV5
         3bkL/rkT47jkNttT9yUVzWGpTPi2bR79MkcOCPDQBGy5ey1Z4QV+DHGxKbr7VrCW1Pbz
         8umN7yrk1zdEgNdwWowq1OxI53jAlsBLRc0HlP5XoHYFg5ASIHJ9AHBu7d5HQnhbMwHe
         l67LkWTRmyE5Mfe1qxNj/gfBZZj/GNUnGbagNx7wwFaRWMTTZLX1UvkhsS8oGEpbasLn
         A7U1iHHgY7UZbCX2u27BSem1rPQjP6sAKC8ZYTAmXi5+5ver74/lZ/uMVBzIVSFXSzCu
         wYXw==
X-Gm-Message-State: AOJu0YyeKrMCqsrIySmozodI2XLYERtFNsVPW10JhoKr5/7pinFeZX98
	DFtocq63cHIObZsyuB6ZtiU=
X-Google-Smtp-Source: AGHT+IErM//mCsTqWqkcMqsDDVLGCeMiV7qRXjuFjI+2a6TGcaV2A0gyWKlRlyxwHXpRXsi4aaE4xg==
X-Received: by 2002:a05:6e02:1d9b:b0:34c:b981:52d4 with SMTP id h27-20020a056e021d9b00b0034cb98152d4mr7851116ila.31.1696544292193;
        Thu, 05 Oct 2023 15:18:12 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h26-20020a02c4da000000b00439f4bf154csm42651jaj.46.2023.10.05.15.18.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Oct 2023 15:18:11 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 5 Oct 2023 15:18:10 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.15 000/183] 5.15.134-rc1 review
Message-ID: <67d917e7-c5ca-4215-a92e-96fd52fc4c31@roeck-us.net>
References: <20231004175203.943277832@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231004175203.943277832@linuxfoundation.org>

On Wed, Oct 04, 2023 at 07:53:51PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.134 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Oct 2023 17:51:12 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 158 fail: 2
Failed builds:
	i386:tools/perf
	x86_64:tools/perf
Qemu test results:
	total: 509 pass: 509 fail: 0

Guenter
