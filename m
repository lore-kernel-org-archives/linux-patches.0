Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C861E1CA
	for <patches@lists.linux.dev>; Thu, 10 Aug 2023 13:56:03 +0000 (UTC)
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1bd99c7b3e2so5666205ad.3
        for <patches@lists.linux.dev>; Thu, 10 Aug 2023 06:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691675763; x=1692280563;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=/qNf1jUmQ5AJ3ccwof1ni8PVa5vG7hwpnzsTFeeHHG0=;
        b=mQxrpYaxk7oymnkuSRRBt6hvoyB3PlaFaVSzOKMz2cuQ2wRS1xqg6/Ttw9afs2d7qD
         vgpvfEJFQfdNBJc3WXfwUtOY2rED0nAlpSyurnywHPr21PNbjeboPBz6axYAU/gL2Wxv
         /o5wqw8/I98QxnrDy+CdxnuFFq9PDi8A7iRna4BMmp03gCTjdX7JLACmjGseF7gdvpbq
         btONHKzb74515L6Q0uyneuNDekF9JpwzI8b4KdbQyhEh9jcUnh0f3aGt8aSziFJsw+na
         yLZydGT2gkd3Sw5+/NyqLCscM9R1pvIqWh04bNGRm4JGvSkbW1xqjhW0OxyDPQR68tCT
         Ogaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691675763; x=1692280563;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/qNf1jUmQ5AJ3ccwof1ni8PVa5vG7hwpnzsTFeeHHG0=;
        b=Y4BRI6X4wBOPGkX4RZpkWMn3HoaexIQLBF1lZzVDoye6kTZy73TpqwJDEAN5endMLX
         umdat/jgnPWVSjdH+z67D2wdNSzoUxK2oLtnKzrU/E8RCK8+lxvK9FaD36XAU7aByQS7
         r+2vK/GaH8w9rK4cGSeLPuSVxFea4W7GByRLtKPMbcapRa8bL2wX++8qeM+zPihmGRm4
         8TBW5LMoGAYSPsjtkjX6to28HsrMqfjHebb8O20PKMfW7SK+LhreNwoG8r4ubQbXXTzi
         3e2+nhoj0qcPsSfcSavxaTg1Y36BfA4Ghttjwu5G2zvR3CTaPCart26W/32HOlEHYl3H
         N9dw==
X-Gm-Message-State: AOJu0YyNXDLst2fKyZchK46VHOBFnL+yxe/kKKnuHC/api/+QMhNxXiO
	F9/zQPmtwPrzEmCNX+YlZlf1wfng634=
X-Google-Smtp-Source: AGHT+IHpn8ltlBnxjIjjir8pQSNqOUUTXlXgA/HNA4ErfhqunG4YVK+HSA0MsAc1vBuj2xsf0nKG/w==
X-Received: by 2002:a17:90a:4f86:b0:26b:e80:11de with SMTP id q6-20020a17090a4f8600b0026b0e8011demr1110779pjh.25.1691675763346;
        Thu, 10 Aug 2023 06:56:03 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x16-20020a170902821000b001b3fb2f0296sm1774123pln.120.2023.08.10.06.56.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Aug 2023 06:56:02 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <9d35afea-e1b4-72d0-9559-1eccdfd069a8@roeck-us.net>
Date: Thu, 10 Aug 2023 06:56:01 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 4.14 000/204] 4.14.322-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
References: <20230809103642.552405807@linuxfoundation.org>
From: Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20230809103642.552405807@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/9/23 03:38, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.322 release.
> There are 204 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Building sparc64:allnoconfig ... failed
--------------
Error log:
sparc64-linux-ld: init/main.o: in function `start_kernel':
main.c:(.init.text+0x77c): undefined reference to `arch_cpu_finalize_init'
make[1]: *** [Makefile:1049: vmlinux] Error 1
make: *** [Makefile:153: sub-make] Error 2
--------------
Building sparc64:tinyconfig ... failed
--------------
Error log:
sparc64-linux-ld: init/main.o: in function `start_kernel':
main.c:(.init.text+0x764): undefined reference to `arch_cpu_finalize_init'
make[1]: *** [Makefile:1049: vmlinux] Error 1
make: *** [Makefile:153: sub-make] Error 2
