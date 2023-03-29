Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com [209.85.219.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38477882B
	for <patches@lists.linux.dev>; Wed, 29 Mar 2023 21:47:09 +0000 (UTC)
Received: by mail-yb1-f182.google.com with SMTP id p15so21206974ybl.9
        for <patches@lists.linux.dev>; Wed, 29 Mar 2023 14:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680126428;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pB+5qmzYeF4gfMXOeV33fr2Zf6v5XzvIxr1hkkgBRCY=;
        b=TqUeTWMt+zvoZh7VgjNstvdzz3di09QXLIAIDUDqKcsytBx0Con3h/YEyN+tXonV4I
         bA6edFVySz++7jzTi7SgK8Ze5KXw8sT8dw2Zxesp0jPyuztF3xWWfo6atfeZ+7drBnNX
         BEV6DUxbFoMN8eYle3VhB6Qb2GvjIWmQqzTL5dXLhskMfD4xv9YgVS1j8EzzDNenXb6Z
         KYkZu7QAGd716MO1cMHtKgjIbiySwiVCG4pOSc249OHq8LA+ABNXIkgw85ftfyYksat+
         8P6NWxKbdt/1c7sJtqZa1Gf8DPOf7WhjW0wB1bJBNyhii3fcSvhdFKxkDbeXaVz/SWzf
         OxgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680126428;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pB+5qmzYeF4gfMXOeV33fr2Zf6v5XzvIxr1hkkgBRCY=;
        b=xOJE0Mcr17WuPpDrDidrADLoraCxD8/HCrPvkrzx+8T5laLZucKZsbCnbphqQlNEhC
         HB0to+CTT2f7N7oQAtcbp+LPqpWeCoxi0H+8b+mZfOTPpxGoojb8EMMF8eBOyYrTPMlQ
         ukJny+6Qw2rPWi9Lhz7Kcfnv2wNeUXhMTKIaNLL/Z0cE3NCfE8JfnKVXKXZF43batT3v
         HmTSrM1QGQdcbVGLlPi/0mixQj5EeaFLppKHbXdPG8d0QMePFzWYFXLTb5mYUeE4/blm
         +9wdlQksvZ8H50HqSdWiUsmJbgObHNQrU+MWPVHE400Gk+hCmsMBt5F0zSJjWN1Uph8b
         wRHA==
X-Gm-Message-State: AAQBX9eu0vqMH9/tftMoSEItCryEl0Wao9E7eWHwQBToLV0MB7l8RMyl
	mGJeLPeSPsQVrfFxYh9DWVKsBEOjzY4=
X-Google-Smtp-Source: AKy350aC7+F0BTGZwir9fMbQQL4MqV7EQadoU98pfpSMRMcuq4ke9nc1/BtjyZnxtIBExdhqEPrDXQ==
X-Received: by 2002:a25:ac1b:0:b0:b72:df13:fda with SMTP id w27-20020a25ac1b000000b00b72df130fdamr18541814ybi.42.1680126428064;
        Wed, 29 Mar 2023 14:47:08 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id e60-20020a25a3c2000000b00b7767ca74a3sm3670713ybi.64.2023.03.29.14.47.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 14:47:07 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 29 Mar 2023 14:47:05 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/240] 6.2.9-rc1 review
Message-ID: <430f447d-fb8f-408d-b9f0-28db4556a646@roeck-us.net>
References: <20230328142619.643313678@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>

On Tue, Mar 28, 2023 at 04:39:23PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.9 release.
> There are 240 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 30 Mar 2023 14:25:33 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 520 pass: 520 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
