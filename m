Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D0F48BEB
	for <patches@lists.linux.dev>; Tue,  6 Dec 2022 15:11:42 +0000 (UTC)
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-144b21f5e5fso5776126fac.12
        for <patches@lists.linux.dev>; Tue, 06 Dec 2022 07:11:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=U2aqfWiC18IWaJPfen75guUebWdcC57mYfUOjSginJ8=;
        b=X7P/ipumWPrS53pnFJPhLt9S4ZXC7xstFKw+LYRBYGoL8V0635Ef1gkYhcHKzrb5f+
         MnlhsS3zuxOw6FgQJzYWNFVPlP72Fxi3cjXv0Mn02oa0Kpc0I7OoLMMnHcbfzjJjWoBD
         FCxxZhOh322UZ9AEOQpL5Bj3+/3JUvzcZ9/g/bM9Azk0VvxCsY3epXqZT6C9GI1dg2jh
         B+4hTmqjjLQkq4dd/+Bycm6d0CWrvTterUKqz1nvNKCBibmHtLrpHgNQHwpFts0k1/EO
         1ZdnlgJs/mT8Id2NlA0DXnbbio5r/chWWGhX3/lmUpe2WPR2x/nkGEQQbXnqLEStA55o
         MH8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U2aqfWiC18IWaJPfen75guUebWdcC57mYfUOjSginJ8=;
        b=SWnq/LnLsOUiVrGMewal5y49c3zwhCO1gMFCRy9lp2FZgVaH2jEIC/m9m41D55XPiB
         ZS6wRkKg7BBSf/4qerxxywtrtuQi39yo481Hc4/tclLxr9wiLb9FmWvfmQOMYGWiRt2f
         fy2TqSBNuRuIqkB5TLe7jXE4tRZnw2lAGLZBV4V2R8JfVt/77Q3zivoHjbKvRi/xzV7Z
         HfjPEx8OXWEW6kUvOMPO4iTIm5hPiHLgCMdGHU9r66a0cVZWsvk4sTpzxiKvTrip4CA9
         /YUvhJF6eIL6M+NFQ/kY4WjQx2VARqc6tcV2UkqP8wE5tvLG/hcX7yTtOek17LhNDl10
         UiQw==
X-Gm-Message-State: ANoB5pmORZn1+A/H5O9zt8h5Q21CM4VqjSl648o4uQN8831u6/yX2PKl
	eiyqPZ0xNujC/lbh2ZI10Lk=
X-Google-Smtp-Source: AA0mqf5k6TyODTmFnas1gSjxxVcp5bgqj2cC6uaE41NtITw/OPvmc0Mnf/joQBZzQK8uqXxfMoApAg==
X-Received: by 2002:a05:6870:9d95:b0:13b:a163:ca6 with SMTP id pv21-20020a0568709d9500b0013ba1630ca6mr53683510oab.125.1670339501593;
        Tue, 06 Dec 2022 07:11:41 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id ce11-20020a056830628b00b00670461b8be4sm2200619otb.33.2022.12.06.07.11.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Dec 2022 07:11:41 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <792a6fba-aa15-2e2a-7527-99ab1116a01d@roeck-us.net>
Date: Tue, 6 Dec 2022 07:11:39 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de
References: <20221206124052.595650754@linuxfoundation.org>
From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.15 000/123] 5.15.82-rc2 review
In-Reply-To: <20221206124052.595650754@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/6/22 04:42, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.82 release.
> There are 123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Dec 2022 12:40:31 +0000.
> Anything received after that time might be too late.
> 

arch/riscv/kernel/smp.c: In function 'handle_IPI':
arch/riscv/kernel/smp.c:195:44: error: 'cpu' undeclared (first use in this function)
   195 |                         ipi_cpu_crash_stop(cpu, get_irq_regs());
       |                                            ^~~
arch/riscv/kernel/smp.c:195:44: note: each undeclared identifier is reported only once for each function it appears in
arch/riscv/kernel/smp.c:217:22: error: 'old_regs' undeclared (first use in this function)
   217 |         set_irq_regs(old_regs);
       |                      ^~~~~~~~

This is with v5.15.81-124-g9269e46bc838.

The backport of commit 9b932aadfc47d seems wrong. The original version introduces
the cpu variable in handle_IPI(). The backport doesn't, and removes old_regs
instead.

Backport:

  void handle_IPI(struct pt_regs *regs)
  {
-       struct pt_regs *old_regs = set_irq_regs(regs);
         unsigned long *pending_ipis = &ipi_data[smp_processor_id()].bits;
         unsigned long *stats = ipi_data[smp_processor_id()].stats;

Original:

void handle_IPI(struct pt_regs *regs)
  {
-       unsigned long *pending_ipis = &ipi_data[smp_processor_id()].bits;
-       unsigned long *stats = ipi_data[smp_processor_id()].stats;
+       unsigned int cpu = smp_processor_id();
+       unsigned long *pending_ipis = &ipi_data[cpu].bits;
+       unsigned long *stats = ipi_data[cpu].stats;

Upstream includes commit 7ecbc648102f which removes the old_regs variable.
That doesn't mean it can be removed in the backport.

Guenter

