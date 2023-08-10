Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74151E1D2
	for <patches@lists.linux.dev>; Thu, 10 Aug 2023 16:15:23 +0000 (UTC)
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1bc3bec2c95so15930985ad.0
        for <patches@lists.linux.dev>; Thu, 10 Aug 2023 09:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691684123; x=1692288923;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZVqbHV+QG5GsPVQyZyu89m2UgvCEHBysqsbECKUvsgM=;
        b=VwzCKhaPMwglG5KggDpTUmyhicW2VNofcGN0/8+GUvXD8mnw2q8UG219D52DCMxIZb
         9sscV2l8e1CL429IVvICiz9LQfhRfjIQgV4cxPkz89gw1kcR7lL+YdcPUGHnS0uX3H/u
         8lXDHXLey+VJNEERD5qbDg65u78bHoq/cHP4ed2IAljq2JWAhXCY0qXmxEvUX0CRFgz/
         3KzqD48KU99lSbwL5nCqWslPv6VDP3vo4hqgtpIOIFUkS48n5/eoy1F2R/+r+TyV0uPy
         h7gYiYggyONGtlUEVOQCVkvzsNeb1/20NNPZjx88TseY/1G52GldN+LPferx0Ia17ujM
         E7dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691684123; x=1692288923;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZVqbHV+QG5GsPVQyZyu89m2UgvCEHBysqsbECKUvsgM=;
        b=jnW/yYg20M7HGGdYZoRTWg1b6O2kHdUQmGJJk1eQ6IWomtLXnrrWc5YkGWwbr/7CZ+
         6jcdd/m3zfzMpwpQ8ArKzcfoYSRDRED6q4x0lmVfZ8zN0AEF3j4Mq8IWBifOEivPHEsz
         p7QLQG/pMyklFUxWwdrjZRUf9MbQevcMFLlxNqHX3odD+Q1SAk/gaDqCbEIXAYHCNuAg
         msqNadHmvpcx8UXfNtc25qLLcITgLNEMZyTyQMB2A774FbgyXXILtbncdlRYlYgAyvtq
         wPWAW6XcX/eY+ddbIaBKWMaDMHdQ5qp7uS/XBuRNFFQqYqGoqMAtd0XF6R2skvp+RdED
         OZ9w==
X-Gm-Message-State: AOJu0Ywb60VDKtg97VlPVuLo8aXWdpoqaiFDIxY0We2chEXVgyR3NMoG
	Dd1r8zT+5NDp+JaOUzUIXFw=
X-Google-Smtp-Source: AGHT+IHX/AxNqI+XLXc2Gd770eCbj0++Kc5KbY5XG3Wg/eCIjosP5SBsbkuvKoQ00716dbJaa2oq7A==
X-Received: by 2002:a17:902:ce8f:b0:1bc:7312:78e2 with SMTP id f15-20020a170902ce8f00b001bc731278e2mr3226286plg.5.1691684122928;
        Thu, 10 Aug 2023 09:15:22 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c1-20020a170902b68100b001b53be3d942sm1957928pls.232.2023.08.10.09.15.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Aug 2023 09:15:22 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 10 Aug 2023 09:15:21 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.4 000/165] 6.4.10-rc1 review
Message-ID: <f110a9c9-5be2-447a-b8b8-be79a078426e@roeck-us.net>
References: <20230809103642.720851262@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>

On Wed, Aug 09, 2023 at 12:38:51PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.10 release.
> There are 165 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Aug 2023 10:36:10 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 522 pass: 522 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
