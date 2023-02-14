Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63737C5C2
	for <patches@lists.linux.dev>; Tue, 14 Feb 2023 18:07:49 +0000 (UTC)
Received: by mail-ot1-f41.google.com with SMTP id x24-20020a9d4598000000b00690bf2011b2so458391ote.6
        for <patches@lists.linux.dev>; Tue, 14 Feb 2023 10:07:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=h4OOqypcztMGdRZMWdYWIa8wO6PV1EB/xigL2lXgd6c=;
        b=TH83SksMB4qG/bSenItHJFZ5leEGwcp0TZYW/00oaEIdnzmacod2Q7ODIwP1T/PjuL
         84KTWNa7rjbqdg+1cMpCnwwueIqosK0qxjeO7/oeXcyh7gfLCkqpISllCXWPMw4C2hQN
         IhbeF2bdDvjtxi8rVuLOqyBPsr9S1VmF43kfHzE/SCLT1rS9Qk/IzDzSNaDR9ACMHefD
         RJoIf3Hd+suzqERiO4EqR07iIQOlks7cKk3lQcbjMubgSYgyQWwSBhVaDDAZJWH7989a
         VBV+FxjV271ytZLfA5kbhGA/zOGwBacjV8cB6Z/XHuqK7Yh+QnufazgnmscHSxXKbBmw
         D2Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h4OOqypcztMGdRZMWdYWIa8wO6PV1EB/xigL2lXgd6c=;
        b=6nxcaY5AzTUlE1ApDi6sc6l78dlMPXoZTEmCqFcz6ZXI+vQiDRLAZg5iLnDJreolkT
         uFCMpJ3fR63+ph9bivKRyR9SgQ0QcXEaoKHefgddYTRfQ24of5hLpAwg/FNTdTrh1x73
         yCTjeG//vBxcKs7s155vxnKAbQTqZn19djLnAQIWaPjFM712ZQnk2v5nnvEakDJ3wcMZ
         GzS5Ib6NkpE2R89kjOhp84GHIe6WugD2lwJuP9eIhJIFx1BpuWeBkJz3s8ej+0qTtYqn
         tmLQfB04w9pR40s8KIcXA1ahrm3Kez6hSF4QBH+NBQcDYPAqTMRydvAaPMQfpXTa/eX2
         nu/Q==
X-Gm-Message-State: AO0yUKU+tXYOhfARyzGcYdBgUCQl7xeF/hTHwsvUkcRsLY/a+5y0RI2a
	+JECTNFmlzAbI66e4ittVMc=
X-Google-Smtp-Source: AK7set+EvvMCmu2Iz3by706vIrjihoJBYEIp3M/kj7rOLONkNS4XfgbyPMUg/wq8oznsjQECnnKZ4Q==
X-Received: by 2002:a9d:7e8d:0:b0:68d:3d9b:fb10 with SMTP id m13-20020a9d7e8d000000b0068d3d9bfb10mr1470704otp.11.1676398068482;
        Tue, 14 Feb 2023 10:07:48 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id dj6-20020a0568303a8600b0068d542f630fsm6553081otb.76.2023.02.14.10.07.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Feb 2023 10:07:47 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <8c06157f-a482-a7f7-8218-863db3dfe268@roeck-us.net>
Date: Tue, 14 Feb 2023 10:07:45 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 000/134] 5.10.168-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de
References: <20230214172549.450713187@linuxfoundation.org>
From: Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20230214172549.450713187@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/23 09:41, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.168 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Feb 2023 17:25:19 +0000.
> Anything received after that time might be too late.
> 

Still observed for ppc:ppc32_allmodconfig:

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

Guenter

