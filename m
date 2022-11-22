Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F789ED0
	for <patches@lists.linux.dev>; Tue, 22 Nov 2022 16:58:57 +0000 (UTC)
Received: by mail-oi1-f176.google.com with SMTP id c129so16516116oia.0
        for <patches@lists.linux.dev>; Tue, 22 Nov 2022 08:58:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=Bt8Ttpp6RbBrNJPZBjc452dc15WNtqXh5ouNAwptrR8=;
        b=IMUaGlI5ct9+fTRZFPz5w3/ewKXGBmwF/9xJ9eRKHJ6lzzRfTs4f8VfKzaQhPcxCaW
         wJoXG5N6/3PVCuU0EjvNBxboe7qXbT8RAh+HInM3no5X+7ADBJ16oFMD4MyXpCjFezBG
         CMOBNINgmES71Grrrsx+0nBIUqSc2K61GRmnQVP6U1o09f+s6g5PCiLa6J4tSC/Iuib6
         A6WZhPdGOg7JJskOTQLjfd/OOCdIVPDlCHd0YGmgDyzNFJQXx30DtO0SWO9bpyp0Xe19
         I7t4UwUC8sQS+gzaTAQhGYqFEYEqrrNd8gBQrztW5QA2/Gmrknq4/xX2bFLqVJSAo/fp
         VSoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Bt8Ttpp6RbBrNJPZBjc452dc15WNtqXh5ouNAwptrR8=;
        b=78Ll7DF0/NBxZeOHlD62/epCz6Y8URlqvSRzdf1LZwv7+Tbl3BnaHcGPeEomKZgNU8
         UmfB08Z2cxl1BCT9m9jYNwiynOqaSABGLgsfH6F4aNmNJBq0aikJOpQs9AgaWljB9v9l
         fICZ5i1FDhe4NfiiBQHNUW2Z7o26wjfdwIiDamq7p4sf/rQbVmXYllaLxPa/ulnzLKYu
         Qaa39jd+orDXgcv04FZtIgLfFTyQbqmURi1vM9X7twpAGJ/x+zmlfo3NXYk8KFzDJTdh
         ea0WpKNDg6ZNp17RqKMATETpGtg5hwm/fxq3iLGwwBpegNKeeRllkkg8anj0MIpEhv7/
         Spzw==
X-Gm-Message-State: ANoB5pnkc5006BHADqIVpzQ5MmRLPctcCM0kdQQ3MsjeKdrFQEDZbQzo
	U/Bk5cYu0San30QOMnhkw14=
X-Google-Smtp-Source: AA0mqf7I0kCnZpHhGo+5q4TZb+OVIaKeQcdzSim4jf4oSAmlCOKoBOJt7PIVYVSMiAMlDF+VNLWnuQ==
X-Received: by 2002:a05:6808:218:b0:35a:202f:1bcf with SMTP id l24-20020a056808021800b0035a202f1bcfmr3442263oie.32.1669136336404;
        Tue, 22 Nov 2022 08:58:56 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l10-20020a056871068a00b0013d7fffbc3csm7700496oao.58.2022.11.22.08.58.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Nov 2022 08:58:55 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <4edd6e3e-b37e-f5ed-8bdc-47c5b0cf2e9d@roeck-us.net>
Date: Tue, 22 Nov 2022 08:58:52 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 4.19 00/34] 4.19.266-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de
References: <20221121124150.886779344@linuxfoundation.org>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20221121124150.886779344@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/21/22 04:43, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.266 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Nov 2022 12:41:40 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 423 pass: 423 fail: 0


Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter

