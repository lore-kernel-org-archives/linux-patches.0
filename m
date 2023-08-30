Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D5423D4
	for <patches@lists.linux.dev>; Wed, 30 Aug 2023 17:07:40 +0000 (UTC)
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-594ebdf7bceso48773047b3.2
        for <patches@lists.linux.dev>; Wed, 30 Aug 2023 10:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693415259; x=1694020059; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6/QyLvyKuwxXiEnwad4bzg5BcAD0WhpvsEjjdvqhUEc=;
        b=glm47eF88Nf+MUAakhzlxsjNJ48q2RbabIA7Kt7Rxljr3WA26BsO6IlQ/6lCdPYUHK
         NAJcYBOGAyvGFAiM8iOlBWDu7IFrr3u6LF6ye+WFOAf/io1MQSgtRDkINKwf09OQNS1E
         4lcz2jpZuBmr2HGywTJizSUErzT29kp3s2LbFjwHBTxteop5vdXwZ2CJlmKMHhPX+61Y
         ubt+57bAvkCXo+3jTYd5JCX7vye71TwL56X+PVCFeOwmce6s5sGtuU2DRbIuYnYoP2Gm
         eCXwtg3bolSBF9s4d8mG6zE14PotwFQuVgIfaZ+KmwEx6Ie1SGrTaGobVHgD+vMDpP3y
         SyIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693415259; x=1694020059;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6/QyLvyKuwxXiEnwad4bzg5BcAD0WhpvsEjjdvqhUEc=;
        b=c6UFSz0VjsuUb//iHnIL4JjJFIPwJN0B67SLejfCRMM8h/APRz6CqA/WrnEe3Jv621
         0suWi15oio0So0vaWbjJGgAY7V2soyR26nOSeIAyBaTBs7U+hM8RlLg25kOrnnQUItr7
         +T3fWePKByTfWtiFjJdImpR1R/abW68hm5akI32PL9oBqN8fa6K/ilXvX5IqcqHlwfHY
         YQjQ8uA/12qnmy1r+I+MdU3glaXjAWNWM9UkBmMzB/IdcqddzXg2Qlf1M0AHE4PUUvC1
         pAb0TogkfwjCiCXd/yTzBTUhofpi6rFIDNUYPx1xLZn7hMkmoA6zl3/NPs2qRbDJw+jg
         hv5w==
X-Gm-Message-State: AOJu0Yx9i7mYOMPkLbUh6dCG3YnXLia5NiNaBIuoGTNIevwM32SQrg4Q
	5TV2/LgIM13uPCd0Je6sOfA=
X-Google-Smtp-Source: AGHT+IGb94m8s+MO6RY5T6Hp4RPsq0KRT6JAcybsCcXeVXx0rtM+D5yP25Z7yLuaZhpkCRvd0V6QcQ==
X-Received: by 2002:a81:4943:0:b0:584:6239:8f36 with SMTP id w64-20020a814943000000b0058462398f36mr2771728ywa.14.1693415258980;
        Wed, 30 Aug 2023 10:07:38 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id i17-20020ac860d1000000b00405447ee5e8sm3811515qtm.55.2023.08.30.10.07.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Aug 2023 10:07:38 -0700 (PDT)
Message-ID: <95baa835-9940-a257-cf96-93c543aa389f@gmail.com>
Date: Wed, 30 Aug 2023 10:07:26 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 5.10 00/84] 5.10.193-rc1 review
Content-Language: en-US
To: Guenter Roeck <linux@roeck-us.net>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Manuel Lauss <manuel.lauss@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, Thomas Bogendoerfer <tsbogend@alpha.franken.de>
References: <20230828101149.146126827@linuxfoundation.org>
 <5b30ff73-46cb-1d1e-3823-f175dbfbd91b@roeck-us.net>
 <2023083014-barley-upscale-518e@gregkh>
 <64374066-4086-3e92-8650-ab1563350f0c@roeck-us.net>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <64374066-4086-3e92-8650-ab1563350f0c@roeck-us.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

+ Manuel,

On 8/30/23 09:01, Guenter Roeck wrote:
> On 8/30/23 03:52, Greg Kroah-Hartman wrote:
>> On Mon, Aug 28, 2023 at 09:42:11AM -0700, Guenter Roeck wrote:
>>> On 8/28/23 03:13, Greg Kroah-Hartman wrote:
>>>> This is the start of the stable review cycle for the 5.10.193 release.
>>>> There are 84 patches in this series, all will be posted as a response
>>>> to this one.  If anyone has any issues with these being applied, please
>>>> let me know.
>>>>
>>>> Responses should be made by Wed, 30 Aug 2023 10:11:30 +0000.
>>>> Anything received after that time might be too late.
>>>>
>>>
>>> FWIW, commit 619672bf2d04 ("MIPS: Alchemy: fix dbdma2") should be 
>>> reverted
>>> v5.10.y since it doesn't fix anything but breaks the build for 
>>> affected boards
>>> completely.
>>>
>>> arch/mips/alchemy/common/dbdma.c: In function 'au1xxx_dbdma_put_source':
>>> arch/mips/alchemy/common/dbdma.c:632:14: error: 
>>> 'dma_default_coherent' undeclared
>>>
>>> There is no 'dma_default_coherent' in v5.10.y.
>>
>> But that was added in 5.10.185, from back in June.  What changed to
>> suddenly cause this to fail now?
>>
> 
> Nothing. I started to build this configuration and tracked down the
> problem after the build failure was reported by others. Sorry, I didn't
> initially realize that this is an old problem.

We could back port 6d4e9a8efe3d59f31367d79e970c2f328da139a4 ("driver 
core: lift dma_default_coherent into common code") but that won't work 
too well on 4.14 or 4.19. I believe it would be simpler to adjust the 
branches with this patch, Manuel does that work?

diff --git a/arch/mips/alchemy/common/dbdma.c 
b/arch/mips/alchemy/common/dbdma.c
index e9ee9ab90a0c..101cccfaf757 100644
--- a/arch/mips/alchemy/common/dbdma.c
+++ b/arch/mips/alchemy/common/dbdma.c
@@ -29,8 +29,6 @@
   *  675 Mass Ave, Cambridge, MA 02139, USA.
   *
   */
-
-#include <linux/dma-map-ops.h> /* for dma_default_coherent */
  #include <linux/init.h>
  #include <linux/kernel.h>
  #include <linux/slab.h>
@@ -38,6 +36,7 @@
  #include <linux/interrupt.h>
  #include <linux/export.h>
  #include <linux/syscore_ops.h>
+#include <asm/dma-coherence.h>
  #include <asm/mach-au1x00/au1000.h>
  #include <asm/mach-au1x00/au1xxx_dbdma.h>

@@ -626,10 +625,10 @@ u32 au1xxx_dbdma_put_source(u32 chanid, dma_addr_t 
buf, int nbytes, u32 flags)
         /*
          * There is an erratum on certain Au1200/Au1550 revisions that 
could
          * result in "stale" data being DMA'ed. It has to do with the snoop
-        * logic on the cache eviction buffer.  dma_default_coherent is set
-        * to false on these parts.
+        * logic on the cache eviction buffer.  coherentio is set
+        * to IO_COHERENCE_DISABLED on these parts.
          */
-       if (!dma_default_coherent)
+       if (coherentio == IO_COHERENCE_DISABLED)
                 dma_cache_wback_inv(KSEG0ADDR(buf), nbytes);
         dp->dscr_cmd0 |= DSCR_CMD0_V;   /* Let it rip */
         wmb(); /* drain writebuffer */
@@ -689,10 +688,10 @@ u32 au1xxx_dbdma_put_dest(u32 chanid, dma_addr_t 
buf, int nbytes, u32 flags)
         /*
          * There is an erratum on certain Au1200/Au1550 revisions that 
could
          * result in "stale" data being DMA'ed. It has to do with the snoop
-        * logic on the cache eviction buffer.  dma_default_coherent is set
-        * to false on these parts.
+        * logic on the cache eviction buffer.  coherentio is set
+        * to IO_COHERENCE_DISABLED on these parts.
          */
-       if (!dma_default_coherent)
+       if (coherentio == IO_COHERENCE_DISABLED)
                 dma_cache_inv(KSEG0ADDR(buf), nbytes);
         dp->dscr_cmd0 |= DSCR_CMD0_V;   /* Let it rip */
         wmb(); /* drain writebuffer */


-- 
Florian

