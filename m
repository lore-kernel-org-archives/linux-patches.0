Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6111A2CA6
	for <patches@lists.linux.dev>; Tue, 14 Feb 2023 06:51:07 +0000 (UTC)
Received: by mail-oo1-f46.google.com with SMTP id b10-20020a4a9fca000000b004e6f734c6b4so1427076oom.9
        for <patches@lists.linux.dev>; Mon, 13 Feb 2023 22:51:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=yvq9znrsaeT0s6kLPSd/jHF4Qd9ENE08EIFLbXY0LXk=;
        b=q0LuA5Y9nEDyM3ZoLAmcnc7hVijUd25jjosSs5PlJWHVK6yaxfLxEpSBXGJ/OPdrs6
         EvfwID2A5cdqDUOoA2qfkAqYTj2crcY8x6mFi03YJW5jT0delO+tUrTRZNLhgMn9YZtk
         axH7+pOU6i2rydTav6Wagg6XoY4zrZ3M034ydptUdh6hSy4jGYTP7vMrEjbMNGk1+U7y
         IbWy5qHrHXKe14zZN6mjXhF07wkhA6Ank1Wfl2tDSMjPYqf5DLOXOORMiebqS1s1+pk2
         XUlQnWVIOgdMqu8meDGb0W95ILDU5Ly0PpHoq7WJ0idbRLVV+xzExYQZTDigwdS7p79L
         ex1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yvq9znrsaeT0s6kLPSd/jHF4Qd9ENE08EIFLbXY0LXk=;
        b=3H6JVrQ3i8BlUO3MqsLvIplA9WsoNwtp/07rR08UsM2fILOpwkbaBVSkIzQpcRov64
         T1mx2Ukaa+1ItJ2VYrR4B01uBL8EX6ZaQH0ARwV4htK77miPIKj6Inu4cihwuXqZGcDp
         XjK19GceBMXSyWReR+EontQgif3SyNNNmVIgYId/6uazVvN6HnyGJXX7lzULGV7GQTyu
         C8U+3tn/iKjIOxZ6y1+rcJDGS7syGvWqZant4Wz8RXnN8CUIXElEXtPf7RzWMAtaSNgU
         ZrDNtbpiHpMnI+NpIX3xjeGutbxBnsD1c2WbQjuoSkLZdBpCLXxFqcNxQTYhHBYWLXzy
         59fw==
X-Gm-Message-State: AO0yUKW6DeC4BzKhct0kK3MpoypfTekXSbeOh+QWey23t5NrmESTebb5
	HKLQgQKP9u/lsK/v/Nuc+SU=
X-Google-Smtp-Source: AK7set8ijbZaBZDPDYwn2kwd/smm4clfzk1Wq2sRMvzi0qoWqKKXci2PLJnZketilEqvVD277ahJIg==
X-Received: by 2002:a4a:c407:0:b0:51a:7af8:457b with SMTP id y7-20020a4ac407000000b0051a7af8457bmr616119oop.1.1676357466424;
        Mon, 13 Feb 2023 22:51:06 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b19-20020a4ae213000000b0051a2a5c8ac6sm5608166oot.36.2023.02.13.22.51.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Feb 2023 22:51:06 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <8e573eb4-d6bd-ec44-153e-3ee143b3d6b2@roeck-us.net>
Date: Mon, 13 Feb 2023 22:51:03 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 000/139] 5.10.168-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de
References: <20230213144745.696901179@linuxfoundation.org>
From: Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/13/23 06:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.168 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Feb 2023 14:46:51 +0000.
> Anything received after that time might be too late.
> 

Building powerpc:ppc32_allmodconfig ... failed
--------------
Error log:
In file included from arch/powerpc/net/bpf_jit_comp.c:16:
arch/powerpc/net/bpf_jit32.h:131:8: error: redefinition of 'struct codegen_context'
   131 | struct codegen_context {
       |        ^~~~~~~~~~~~~~~
In file included from arch/powerpc/net/bpf_jit32.h:13,
                  from arch/powerpc/net/bpf_jit_comp.c:16:
arch/powerpc/net/bpf_jit.h:124:8: note: originally defined here
   124 | struct codegen_context {
       |        ^~~~~~~~~~~~~~~
arch/powerpc/net/bpf_jit_comp.c:18:20: error: redefinition of 'bpf_flush_icache'
    18 | static inline void bpf_flush_icache(void *start, void *end)
       |                    ^~~~~~~~~~~~~~~~
In file included from arch/powerpc/net/bpf_jit32.h:13,
                  from arch/powerpc/net/bpf_jit_comp.c:16:
arch/powerpc/net/bpf_jit.h:139:20: note: previous definition of 'bpf_flush_icache' with type 'void(void *, void *)'
   139 | static inline void bpf_flush_icache(void *start, void *end)
       |                    ^~~~~~~~~~~~~~~~
make[3]: *** [scripts/Makefile.build:286: arch/powerpc/net/bpf_jit_comp.o] Error 1

Guenter

