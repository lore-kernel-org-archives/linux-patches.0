Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E3610EA
	for <patches@lists.linux.dev>; Sat, 25 Nov 2023 05:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OBbe1J+q"
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-3b85d0148e0so117662b6e.0
        for <patches@lists.linux.dev>; Fri, 24 Nov 2023 21:45:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1700891113; x=1701495913; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9YtcVT0tO/faU6pBapwW4pF/eOnwAU4GwA3kQ7ou57Q=;
        b=OBbe1J+qZ/gj9A9YQ4R3r8jsof/gRnhwQajgK5BnmbOUpj4Cqnbd2caFQwwzGkNNkf
         kZ1XkD57a80VD8YceRJwfNC6S09JJk/OKQ43m8Llz1q94o69kQ562bvBB7/D5yhHYDNE
         9zYuy65ABY0g3ww4YngovyzDAC8OOnxZef7/gJ/DnZKg7GcbIHXSdxp24JsrKdqPH1dd
         Ch8lWzahDZdPyHkweUeoCat2lzNfz4/howheobCfp7OaM4uMkpdCBWJ4pWB1xFVsFUf8
         EYRfP7Qf2UixnPybPyCDs5yZQor69mDCXCNWeK4380yTgsZXuwsfz9pdcEK21Ch6WCXA
         8w1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700891113; x=1701495913;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9YtcVT0tO/faU6pBapwW4pF/eOnwAU4GwA3kQ7ou57Q=;
        b=Cf2n8bOcQBw6gGIsemxox6Ry6yAZ/KeHyAbx7zLjVG9rtBc1i8PAG8NLtefqpG3kb+
         8xF07PkN39ihHKdiEFPC+T9ATCHOA/RUBDdsPHXkj0n9PJR3DQqIhUgb+4N2xZX72FNJ
         RjjmZi/KqI5MwGc8rzeeVNO1GcALJBwhzXux78kRB2aaNfPT839fqoab8y95Efi8Oz7O
         y3wwK8gEiujTPBB8rLPkgT93xeaoN1jUYHcjiIQwu7ZLg0N3f1n02sAwSEOQFnakS6hK
         udy4AAFYBppL/A86CTdozHJ/tryYtmWGRFWs8D4jXjAPn3YwSl1Tk0a6+dr5T8P/KCoW
         oD5w==
X-Gm-Message-State: AOJu0YyArRI1iUUykBo/xAaQDKgfyqh8xsVGqDxm7Uj23ZwDpIT+Fezp
	taksqHagghxrj41kbsqToQceZPAVBKwFkimOoCy2j4hR
X-Google-Smtp-Source: AGHT+IF8hKgzamcS6ks5XPNrfLtxKvTT7kP1+08AKQ7V7ZC2VsynTR7rqVJLUmxGjFzLY3gdcJkZOw==
X-Received: by 2002:a05:6808:2111:b0:3b8:3826:6dcd with SMTP id r17-20020a056808211100b003b838266dcdmr727299oiw.25.1700891113007;
        Fri, 24 Nov 2023 21:45:13 -0800 (PST)
Received: from [192.168.17.16] ([138.84.62.70])
        by smtp.gmail.com with ESMTPSA id bc10-20020a056808170a00b003b85ad8e75asm163754oib.6.2023.11.24.21.45.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Nov 2023 21:45:12 -0800 (PST)
Message-ID: <81a11ebe-ea47-4e21-b5eb-536b1a723168@linaro.org>
Date: Fri, 24 Nov 2023 23:45:09 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/297] 5.15.140-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, jack@suse.cz, chrubis@suse.cz
References: <20231124172000.087816911@linuxfoundation.org>
From: =?UTF-8?Q?Daniel_D=C3=ADaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello!

On 24/11/23 11:50 a. m., Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.140 release.
> There are 297 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 26 Nov 2023 17:19:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.140-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

We are noticing a regression with ltp-syscalls' preadv03:

-----8<-----
   preadv03 preadv03
   preadv03_64 preadv03_64
   preadv03.c:102: TINFO: Using block size 512
   preadv03.c:87: TPASS: preadv(O_DIRECT) read 512 bytes successfully with content 'a' expectedly
   preadv03.c:87: TPASS: preadv(O_DIRECT) read 512 bytes successfully with content 'a' expectedly
   preadv03.c:87: TPASS: preadv(O_DIRECT) read 512 bytes successfully with content 'b' expectedly
   preadv03.c:102: TINFO: Using block size 512
   preadv03.c:77: TFAIL: Buffer wrong at 0 have 62 expected 61
   preadv03.c:77: TFAIL: Buffer wrong at 0 have 62 expected 61
   preadv03.c:66: TFAIL: preadv(O_DIRECT) read 0 bytes, expected 512
   preadv03.c:102: TINFO: Using block size 512
   preadv03.c:77: TFAIL: Buffer wrong at 0 have 62 expected 61
   preadv03.c:77: TFAIL: Buffer wrong at 0 have 62 expected 61
   preadv03.c:66: TFAIL: preadv(O_DIRECT) read 0 bytes, expected 512
   preadv03.c:102: TINFO: Using block size 512
   preadv03.c:87: TPASS: preadv(O_DIRECT) read 512 bytes successfully with content 'a' expectedly
   preadv03.c:87: TPASS: preadv(O_DIRECT) read 512 bytes successfully with content 'a' expectedly
   preadv03.c:87: TPASS: preadv(O_DIRECT) read 512 bytes successfully with content 'b' expectedly
   preadv03.c:102: TINFO: Using block size 512
   preadv03.c:77: TFAIL: Buffer wrong at 0 have 62 expected 61
   preadv03.c:77: TFAIL: Buffer wrong at 0 have 62 expected 61
   preadv03.c:66: TFAIL: preadv(O_DIRECT) read 0 bytes, expected 512
   preadv03.c:102: TINFO: Using block size 512
   preadv03.c:77: TFAIL: Buffer wrong at 0 have 62 expected 61
   preadv03.c:77: TFAIL: Buffer wrong at 0 have 62 expected 61
   preadv03.c:66: TFAIL: preadv(O_DIRECT) read 0 bytes, expected 512
----->8-----

This is seen in the following environments:
* dragonboard-845c
* juno-64k_page_size
* qemu-arm64
* qemu-armv7
* qemu-i386
* qemu-x86_64
* x86_64-clang

and on the following RC's:
* v5.10.202-rc1
* v5.15.140-rc1
* v6.1.64-rc1

(Note that the list might not be complete, because some branches failed to execute completely due to build issues reported elsewhere.)

Bisection in linux-5.15.y pointed to:

   commit db85c7fff122c14bc5755e47b51fbfafae660235
   Author: Jan Kara <jack@suse.cz>
   Date:   Fri Oct 13 14:13:50 2023 +0200

       ext4: properly sync file size update after O_SYNC direct IO
       
       commit 91562895f8030cb9a0470b1db49de79346a69f91 upstream.


Reverting that commit made the test pass.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Greetings!

Daniel Díaz
daniel.diaz@linaro.org

