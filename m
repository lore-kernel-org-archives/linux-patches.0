Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0C88C0C
	for <patches@lists.linux.dev>; Mon, 29 May 2023 15:20:27 +0000 (UTC)
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1b024e29657so15870995ad.3
        for <patches@lists.linux.dev>; Mon, 29 May 2023 08:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685373627; x=1687965627;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gvc0Sypc7fVXcvgTsHV4j3N88EBzVEma04rOGpLqnUU=;
        b=MENfSFGTaCBdxZAFqE4sG0TtxWV15Fno/PeOwVzCXbN8GeB47TYDzyOfRUj/U5z2Ux
         1H08GDzKA5tTGK+zXkZyUQvknW1HYerlxtcZScLUorKhgzXl5J7xHQhb55WswLega4dx
         pF5irxc1i97I8vZqcvYN5PJL8bQdNEGlM8LsE5Re8ew1IlfqYCMPi8Bwp1cFMXWLT8FX
         UrlTD5ifd4HZ6SmeRTE2vwYo8ENcwUzqND33PRxSbroBqzyxlnSI29kwm5Rc2G2ZRZBb
         lI0TEPeZfCA8gYMdUF6pKctS9CYM5PyhYyG/RDzSs7mMpGdsFY/K7Sjof2xfSbPC6S/Y
         rybA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685373627; x=1687965627;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gvc0Sypc7fVXcvgTsHV4j3N88EBzVEma04rOGpLqnUU=;
        b=anf+nsbet5tRa+/C4jp97fkiHVIxtZe82BiPFlB1Rr24gPmhZ/lpKuPnmsVVjb4PQJ
         UX6aaB5nvMMXorFwkRc99JApQOQpnYHRGAb2RwsI5I92+mZF+I34LS6XPGzdp2olMkeQ
         fy0ehu/6e4MWoKMJlMmRuylbrCU6fpkvB9EtM9hib8gcTSb3wG8sUCfUnn7wl66kOxm5
         uYnHXUceaEwyxENZr9dCkCHkz5Z1dzdyFnJKT4jl7fwSHKaWCdhoACSIEN5ffWLLva8r
         nNwj4wYedt5bJmfPk4eH3zuwbJjHBBhgkjPodhubRhPTHFPL9DA4O8pE46nQAtC7fKrP
         MWSg==
X-Gm-Message-State: AC+VfDw7PsoIHsTSD9LtyOpMqm61seSspCdlWQ7J14Rd9CzqzoKCl0Gr
	RgbboYaNHvF8MlsnRxqynlw=
X-Google-Smtp-Source: ACHHUZ59ESDKQoF2T4ui0T0ADbVS1ZkuYfAEn3lC7NGBQz1TnVvi1bwsZY9nbiys8LXpzliPh0jcWw==
X-Received: by 2002:a17:902:cecd:b0:1af:a2a4:837f with SMTP id d13-20020a170902cecd00b001afa2a4837fmr12174462plg.26.1685373627117;
        Mon, 29 May 2023 08:20:27 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id jo8-20020a170903054800b001ac937171e4sm3510861plb.254.2023.05.29.08.20.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 May 2023 08:20:26 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <bb173e8e-c275-e153-83cd-019861b30e09@roeck-us.net>
Date: Mon, 29 May 2023 08:20:23 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Content-Language: en-US
To: Naresh Kamboju <naresh.kamboju@linaro.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Linus Walleij <linus.walleij@linaro.org>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>
References: <20230528190833.565872088@linuxfoundation.org>
 <e98d3b88-980b-4487-baf8-4685cfe62209@roeck-us.net>
 <468bc707-0814-4d83-9087-74768d98203a@roeck-us.net>
 <CA+G9fYspKgo+qF5Onq_HDz1-w6NscULrFUSw=YKp+1e=4NkBBQ@mail.gmail.com>
From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 4.19 000/132] 4.19.284-rc1 review
In-Reply-To: <CA+G9fYspKgo+qF5Onq_HDz1-w6NscULrFUSw=YKp+1e=4NkBBQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/29/23 07:28, Naresh Kamboju wrote:
> On Mon, 29 May 2023 at 19:19, Guenter Roeck <linux@roeck-us.net> wrote:
>>
>> On Mon, May 29, 2023 at 06:48:10AM -0700, Guenter Roeck wrote:
>>> On Sun, May 28, 2023 at 08:08:59PM +0100, Greg Kroah-Hartman wrote:
>>>> This is the start of the stable review cycle for the 4.19.284 release.
>>>> There are 132 patches in this series, all will be posted as a response
>>>> to this one.  If anyone has any issues with these being applied, please
>>>> let me know.
>>>>
>>>> Responses should be made by Tue, 30 May 2023 19:08:13 +0000.
>>>> Anything received after that time might be too late.
>>>>
>>>
>>> Building s390:defconfig ... failed
>>> Building s390:allnoconfig ... failed
>>> Building s390:tinyconfig ... failed
> 
> We do noticed these set of build failures,
> 
> Seems like the following commit might have caused this
> build break
> 
>   drivers: provide devm_platform_ioremap_resource()
>    [ Upstream commit 7945f929f1a77a1c8887a97ca07f87626858ff42 ]
> 
> 

Yes. devm_ioremap_resource() is only defined with CONFIG_HAS_IOMEM,
That dependency was added to platform.c with commit 837ccda3480d
("drivers: depend on HAS_IOMEM for devm_platform_ioremap_resource()")
which wasn't backported.

Guenter

>>>
>>> --------------
>>> Error log:
>>> s390-linux-ld: drivers/base/platform.o: in function `devm_platform_ioremap_resource':
>>> drivers/base/platform.c:97: undefined reference to `devm_ioremap_resource'
>>> madrivers/base/platform.cke[1]: *** [Makefile:1061: vmlinux] Error 1
>>> make: *** [Makefile:153: sub-make] Error 2
>>
>> This also affects um:defconfig.
>>
>> Guenter
> 
> - Naresh

