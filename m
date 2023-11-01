Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D37E18E06
	for <patches@lists.linux.dev>; Wed,  1 Nov 2023 18:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kgm4ZnEW"
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-1eb39505ba4so81060fac.0
        for <patches@lists.linux.dev>; Wed, 01 Nov 2023 11:07:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698862026; x=1699466826; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8qGAFU8RofTfdc7krIYtNj5TsvDrrANjosLBZsqmPSg=;
        b=kgm4ZnEW1VEpTPHNCglxxbvKNph+o0xvQe60F0YuloTIf43fnlTx0vZChRe+0VfcI/
         fbvfiRGG+Uz0x0Xo5mi7FhI9hp1ZDUDxZmXWe/9gdziRfWBFAI/YxkYR2cLsqtG57uWH
         d7VB0Bby/3Hu69uMoHCUdJzV9l7DLMgsITnuzFLg5NdV8xN4pFnzBPhd+fAGf1mmUaXK
         sScktnSi4laGEpi1LQeSfQvAIW6KZfZmzFthZSBJ4BetZ7Lps+mj6RJgmeDYqWXKHIG+
         mvP1VAqvIWBcLA7tntSVUDSGE9aSeDJVc2CoSntyFhS4IfBZsiL/0n181FAmLa04sGEg
         l8Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698862026; x=1699466826;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8qGAFU8RofTfdc7krIYtNj5TsvDrrANjosLBZsqmPSg=;
        b=OwEOocW0+5hAs0nUtxSkHhOmCVRMQPy37Ieda1pa4JvJr25M47sy0AlFB6eBGaHpnr
         FW3LBSReVcevC67iyWxUDYgalY8kukb1m/iZaILcvhzK7qB7CRjpp2iBSPSNjmufqhnp
         QKP3gK11ufUFsIuk12ZB3W9UsVW7awhLDb+y//VJ6rY9hTYD2UsUXvY2SVAeltui1AKM
         JBUFThexN9567IkNXlDZxqKYYVsXanGp7WCcJciDREE14AaD7+BViu6DfzyIrDgQKW+H
         hmE1QIOis7ZJrK3LDcfANdE0VPZO59wUZuyE3VJjjm+nmCIU3SPHoSPPReI1plcdYEqO
         aMDw==
X-Gm-Message-State: AOJu0YzaoOjL0LZ7ysgVWPqs0Ou9HZWrClXGnDJD1U7G0DsoYJSHFfAf
	HD+gxpOD50HFiga/ZCwzjB0=
X-Google-Smtp-Source: AGHT+IGWuuZ+weVAWlYQ9v9BN9xCErlEHUbLjcz31NIuUgzDdabE1j35Q4hbQlt+6Vz+JaX0CWJ5IA==
X-Received: by 2002:a05:6870:f60c:b0:1d0:e372:6b06 with SMTP id ek12-20020a056870f60c00b001d0e3726b06mr17796629oab.25.1698862026157;
        Wed, 01 Nov 2023 11:07:06 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id ea9-20020a056870070900b001f006088c58sm306891oab.26.2023.11.01.11.07.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Nov 2023 11:07:05 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 1 Nov 2023 11:07:03 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.5 000/111] 6.5.10-rc2 review
Message-ID: <df19c43b-855b-4699-adc5-197add48beb4@roeck-us.net>
References: <20231101120147.190909952@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231101120147.190909952@linuxfoundation.org>

On Wed, Nov 01, 2023 at 01:03:25PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.10 release.
> There are 111 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Nov 2023 12:01:18 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 530 pass: 530 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
