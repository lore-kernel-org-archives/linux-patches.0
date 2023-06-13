Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3798E33E3
	for <patches@lists.linux.dev>; Tue, 13 Jun 2023 16:35:41 +0000 (UTC)
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-34057f5c089so5262535ab.2
        for <patches@lists.linux.dev>; Tue, 13 Jun 2023 09:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686674140; x=1689266140;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=2aVGCAfttGaEP+T5hFXH09b2R9I6QV7AaZOFPngkhMY=;
        b=AjVIGkaWmO1nZ9NVHq/qqhSokL2RvmRg57FyyLj+r55Q4PaXJW4Ht+C4nQFIBOdIV7
         xFlyK2GhB7vo1oGBUC8GAzzuLpB+xLvekmCpT3IDwqbsXPtGEDVDhtlJ9YGmWJ1BUEhG
         /0jj54hy+GvfPsW/WFs6LhLThXfK8e0fdGJlZDn6I0TK1mrW8N57uhHgY+9nZRGGa1J8
         dsN5/tL+L28kGWyXicBB4cxqsefgwI8pBtxwaddCZCw0PtzAs/BCgPnP9TzH0EjHsY0/
         GnfIfY3Bf0HaKAtd63OD5mQVgnxbNDApDWqcI6f7MfXhnpL6/dT0+Kwejiht8PmfqeK+
         Vrcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686674140; x=1689266140;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2aVGCAfttGaEP+T5hFXH09b2R9I6QV7AaZOFPngkhMY=;
        b=JBPINS9u3mA0t0tnxjudtrLHKjshjgRHAjhYxN/Hz4gYLAyyoitnxuPdIMavFdJwJS
         zZXvnB8G3BDvrRBTzF7fueMXSwkRofiX8wOEHQUyQRlXgXDrJSqyhbZKlPxK0EwUDoEu
         82/kct1cOfuA2dZc+IHHCNcyy8yoz0DksodG2sFmlNbaZW3ZkZtETfRSYgMwNLa/YJQr
         IkBMHaCTdc2Aq3FxCyTRgdJpH7aHKpQfkKMnOC1U/Y2VQxBnQp5faSUBAVLI7nA63frn
         upY+MMIAG9sUx55G+Kof0+hl8DdfP4gdOJASkPLjSWa2uMZDBwjdsLNNtUXItKciXPvL
         DoOA==
X-Gm-Message-State: AC+VfDzPAk9It4CSCrncHOuQCk4wjEGxAlu4ijGeBcUvXyafzpL7Bstm
	KbQ9OtfyIeTZ9WEAhmyOYWQ=
X-Google-Smtp-Source: ACHHUZ5ou41eckvYfJzBCPzcD/8kdC9EnK2SJ34PiiUY7kYzebcHK8C89YC/Y2wQQMhFyOY/F5gpgA==
X-Received: by 2002:a92:2908:0:b0:338:20f2:1fba with SMTP id l8-20020a922908000000b0033820f21fbamr10733181ilg.10.1686674140058;
        Tue, 13 Jun 2023 09:35:40 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g25-20020a633759000000b0051afa49e07asm9675143pgn.50.2023.06.13.09.35.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jun 2023 09:35:39 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <ab4e5232-ccc4-144a-cb72-2a0cce825f31@roeck-us.net>
Date: Tue, 13 Jun 2023 09:35:37 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 5.10 00/68] 5.10.184-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de
References: <20230612101658.437327280@linuxfoundation.org>
From: Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20230612101658.437327280@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/12/23 03:25, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.184 release.
> There are 68 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Jun 2023 10:16:41 +0000.
> Anything received after that time might be too late.
> 

Am I the only one seeing this problem ?

Build reference: v5.10.183-69-g32cae866b182
Compiler version: x86_64-linux-gcc (GCC) 11.3.0
Assembler version: GNU assembler (GNU Binutils) 2.39

Building x86_64:allyesconfig ... failed
--------------
Error log:
x86_64-linux-objcopy: vmlinux: unsupported relocation type 0x44
x86_64-linux-objcopy: vmlinux[.text]: relocation count is negative: bad value
make[3]: *** [arch/x86/boot/compressed/Makefile:114: arch/x86/boot/compressed/vmlinux.bin] Error 1
make[3]: *** Waiting for unfinished jobs....
Unsupported relocation type: unknown type rel type name (-1939958716)
make[3]: *** [arch/x86/boot/compressed/Makefile:122: arch/x86/boot/compressed/vmlinux.relocs] Error 1
make[3]: *** Deleting file 'arch/x86/boot/compressed/vmlinux.relocs'
make[2]: *** [arch/x86/boot/Makefile:115: arch/x86/boot/compressed/vmlinux] Error 2
make[1]: *** [arch/x86/Makefile:274: bzImage] Error 2
make: *** [Makefile:192: __sub-make] Error 2

It affects 5.4.y and 5.10.y for me.

Guenter

