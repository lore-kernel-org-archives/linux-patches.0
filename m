Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E635393
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 20:58:20 +0000 (UTC)
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-1d544a4a315so3775556fac.3
        for <patches@lists.linux.dev>; Mon, 11 Sep 2023 13:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694465899; x=1695070699; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oMQal+o8tzu4wFn4IrJDyy1kLd4NdYEV6e+c0EkXb2U=;
        b=FJyYqVNoUHQ+ER80H5YgcCXJ2o6KdeSJuqNQooSaBTtozA2BoSnsXzXgnV/8qsfWGV
         6vMloZSngjwlAH1w9FaaBsS6N4MJE3nP7bDIuydJHYyOmm3mYi7cX/Mn8k/7B+BRamCU
         m8ZHQDRh3OUofKfdQmVTSayGAH0snmPul19UHzc7oWbhJ68/g0AmQvumN/WNNCDJcEoY
         +TpfpYBGcBpvBkPi6m2Pux520bU4DEdhIA7KYeXD12Y0XQwh8TtKtWyqdUY6hQ8f2sKQ
         wJYjVcBe7sBBqNMg3+Vr6iODR7UcLAXt56ETdWgAIfNhoidPJUZYDkXqtlxhsjQlhYcc
         be5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694465899; x=1695070699;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oMQal+o8tzu4wFn4IrJDyy1kLd4NdYEV6e+c0EkXb2U=;
        b=OGMGFeNV/DVbxmmmtRxD9Uyl9XPeAkGlAf2Cd5pPxgchn0ZSKhBSuUyIbETgyi51HP
         rdCWkvkTwlupODbvHegV94xTg8dzDfNIOCLXcyIhyAcAiIGujWnuZDASRc8k4XeNjjQ3
         NbgFCBU+3MmxHzcsGstAI7v10ac1tgKHEYnduu+fVvLcl6yDURgqyn8woY0oo49qzBvW
         nAQ57Zql4HLrV43oQMBorPGG8Wn3X5daMQnapd0eHBS4sTg7K0g1+YbWfrJ+C8xWAPfm
         /GAdRTvhav+mUEi+Eh6jQ269W4x4xw4XCS6qDHVxQ5nU1eEiRPE5xu6NOoHWjO7wlrVG
         cL7w==
X-Gm-Message-State: AOJu0YyLTJTnTqhAtwJl1Mi5VHPNZS6zZiSUxtFf/vLnTS4zqDw4H1As
	ambmh4lK/7QiG/CeYPWDuxZcWg==
X-Google-Smtp-Source: AGHT+IGipFuT+lIDKb9srjnEvoHGQrqH1ObvhCRR6oL37gQQ6BLrvohv8vCYO/+DWVXIHIV0CjUoWw==
X-Received: by 2002:a05:6871:4181:b0:1d5:e2f2:c7d with SMTP id lc1-20020a056871418100b001d5e2f20c7dmr1494800oab.48.1694465899445;
        Mon, 11 Sep 2023 13:58:19 -0700 (PDT)
Received: from [192.168.17.16] ([138.84.45.186])
        by smtp.gmail.com with ESMTPSA id t34-20020a05687063a200b001d57c93ddbasm3750195oap.35.2023.09.11.13.58.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Sep 2023 13:58:18 -0700 (PDT)
Message-ID: <1ffe4f64-f238-859a-ab14-7559d03c4671@linaro.org>
Date: Mon, 11 Sep 2023 14:58:16 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH 6.1 000/600] 6.1.53-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org
References: <20230911134633.619970489@linuxfoundation.org>
Content-Language: en-US
From: =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello!

On 11/09/23 7:40 a. m., Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.53 release.
> There are 600 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Sep 2023 13:44:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.53-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

We're seeing this new warning:
-----8<-----
   /builds/linux/fs/udf/inode.c:892:6: warning: variable 'newblock' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
     892 |         if (*err < 0)
         |             ^~~~~~~~
   /builds/linux/fs/udf/inode.c:914:9: note: uninitialized use occurs here
     914 |         return newblock;
         |                ^~~~~~~~
   /builds/linux/fs/udf/inode.c:892:2: note: remove the 'if' if its condition is always false
     892 |         if (*err < 0)
         |         ^~~~~~~~~~~~~
     893 |                 goto out_free;
         |                 ~~~~~~~~~~~~~
   /builds/linux/fs/udf/inode.c:699:34: note: initialize the variable 'newblock' to silence this warning
     699 |         udf_pblk_t newblocknum, newblock;
         |                                         ^
         |                                          = 0
   1 warning generated.
----->8-----

That's with Clang 17 (and nightly) on:
* arm
* powerpc
* s390

Greetings!

Daniel Díaz
daniel.diaz@linaro.org

