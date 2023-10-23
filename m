Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0273D23C5
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 14:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ILPoNJ8w"
Received: by mail-yb1-f178.google.com with SMTP id 3f1490d57ef6-d9a58f5f33dso3125364276.1
        for <patches@lists.linux.dev>; Mon, 23 Oct 2023 07:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698071859; x=1698676659; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=GD6GktRQA8yNZ+0bir+1mpmuzkKcfcqAuwhKX54GTeM=;
        b=ILPoNJ8wC9kVfpGS8UTGsDmD967eTOG8nUqK+fA+e8cSym/wYu0D6rVEydQUD4vpCL
         m3S3VoykNs8ehO7M3xS0VdwSP7U18SSggtlbZuOvfz6TpxoVFXVhh3akgflnB1gJE3jN
         d//7CXSu73ygxtTvFGsNRpG0/XTlDcXieYnaBrQuoHsXCzyvRCVVxMy318Q8gXr+WSEl
         4v816DgspCGAmFqb2eQAjjJEmsEkVQAffVUsrPJGABQta6q5Sf8Y/2ds6h3A+riOuhXP
         7XE9Znc2TlAXVkFhmDmdlC6kMelfVGKLyA+gfh+7i97fDVqQQN1gx8ssm91DOmtB/E56
         Bx+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698071859; x=1698676659;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GD6GktRQA8yNZ+0bir+1mpmuzkKcfcqAuwhKX54GTeM=;
        b=mJJXFyIuzGfqwmWAs/gmDuaMAqI9zWLwh0XPXG2G0GNNbN33mv0znUkxHu6Ip0lhIx
         cfm5R8izxsN+vnsiNQPItCRUVVJFZTqDvXs2G6NzgMpJwUN3ZIxE3oXMSv1Zz+L0XN7q
         TgsVwMuhXcxGFhQMFRCfs4HRVOB7rC8Wr+irrqOstEMPp15vwGV5Y3EE1HXrLTfYvsoF
         rRU5eVvjWCzvDIjou3uVj+5VXrEQ14h2jRdc2iRfnV9go9Z0/7JpW98EteTjx2BmSdKx
         zbOtVHXGcX+I8JAqN26GzrUtLDj2h6DlJJzO51HJT1WhKo5W8cm8BCtFGuzNaWcvjXtV
         nZrQ==
X-Gm-Message-State: AOJu0Yz9TtX8ot0qyyQMp1H+8GcJc5z2AvLjmPxxDnd8c3YL8LqRs8H4
	H8oLznVM4ua6Gd73dXfilT4=
X-Google-Smtp-Source: AGHT+IHlNnVJG0aPd0n5jhr07oAGy616t7g1PbVB+dq4ioUiC/w/rkWTiYrDoff9rT4Sc1vxM33F4Q==
X-Received: by 2002:a05:6902:1890:b0:d9a:d196:67c1 with SMTP id cj16-20020a056902189000b00d9ad19667c1mr11112332ybb.10.1698071858942;
        Mon, 23 Oct 2023 07:37:38 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w10-20020a25ef4a000000b00d815cb9accbsm2727163ybm.32.2023.10.23.07.37.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Oct 2023 07:37:38 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <f3b2a4ac-042d-4c20-4020-3a09822811ac@roeck-us.net>
Date: Mon, 23 Oct 2023 07:37:36 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 4.14 00/66] 4.14.328-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
References: <20231023104810.781270702@linuxfoundation.org>
From: Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20231023104810.781270702@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/23/23 03:55, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.328 release.
> There are 66 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Oct 2023 10:47:57 +0000.
> Anything received after that time might be too late.
> 

Building s390:allmodconfig ... failed
--------------
Error log:
In file included from include/linux/kernel.h:10,
                  from arch/s390/pci/pci_dma.c:8:
arch/s390/pci/pci_dma.c: In function 'bitmap_vzalloc':
arch/s390/pci/pci_dma.c:536:15: error: implicit declaration of function 'check_mul_overflow'

Guenter

