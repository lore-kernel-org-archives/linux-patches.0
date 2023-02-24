Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390F417C7
	for <patches@lists.linux.dev>; Fri, 24 Feb 2023 03:47:21 +0000 (UTC)
Received: by mail-pg1-f182.google.com with SMTP id z10so6735331pgr.8
        for <patches@lists.linux.dev>; Thu, 23 Feb 2023 19:47:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gfsHFDoztEyExDTE48mR9wprB/0JEP2Okh27zvb0V6E=;
        b=OlUtEtHxCIaQ4JZceCw9Lsdoek6syFHGo3vXbYfI1iZrP4vhDJhbeOjnVwCbL33acw
         wahhYKacgQhZoB26GRDJ4dAAyc6ZbQe6T7NdG6xMNISv0Xw8vHBHVAHBKTrVwwx4pAtp
         sBG8nqTLvjaRSwnBacb2zyZjw9uS5EdRqIXePlU87truWlTNs0vFwImkkSnuD4+c7YcR
         1gg6gSOWqTAphbQmgmVKAB1Iv8XC6vX4HErEREdxbxme9xx0f59hs7rodni3lCSqK4nW
         /6aUFmOhaVZ/7agcl0WNGo569atl1XIApd6O+yOXHj4PpmYWaLf8N86C35sufH4Mhlnp
         vuLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gfsHFDoztEyExDTE48mR9wprB/0JEP2Okh27zvb0V6E=;
        b=HaUsHujvdFR69vSlDM2FMbiRRHyOZ5Mw+06w97AVO+HLWJfjbEmDw5Skbhogq2iQDC
         ntvNqTHVZYlXQCmxhscepZ66cL/+4QAXHR39AO+2/tew4jHsurwMbL+H2pDQ4MXNjhDb
         ZNgB8c+fEMJXLuX9DBqGZM8C6MFoX1uPM+R/aAcxdvEg8HoZh4MUX0ZWaugLKbZeFuHW
         VVDfhaq3zL4/8oCqThl9EzDw3P6D05wUgTPvkQ5ZgDtyOLca+hEcdkciU8d2PgXCEs4S
         LWaMQVh8ZYbVM+j5Jb4DyQpdLW+V4ac0oFOxE6YRbxxZHzHdKFEogRqLgqRmrDxIFljF
         7B2g==
X-Gm-Message-State: AO0yUKVNXhQ/AaFbqvLkEQw/BzU+wfiHZIcMgLSC1Aons39LjBNBIJh0
	qtFaouq3ck/4SBy3brC7XnVIN1XiGdkJMwyksuF/Pw==
X-Google-Smtp-Source: AK7set+00AVk9Ivh33Fzuydqi8cRJP76bKdTzhvJyh1xGFOyYTm1XhcTBF50FrrM0C1yyUj278zWkrxNIzR+Mdr7VV8=
X-Received: by 2002:a63:8c18:0:b0:502:f46f:c7c6 with SMTP id
 m24-20020a638c18000000b00502f46fc7c6mr1088379pgd.1.1677210441417; Thu, 23 Feb
 2023 19:47:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230223141539.591151658@linuxfoundation.org>
In-Reply-To: <20230223141539.591151658@linuxfoundation.org>
From: Slade Watkins <srw@sladewatkins.net>
Date: Thu, 23 Feb 2023 22:47:10 -0500
Message-ID: <CA+pv=HP81iuw4RNUMrrK0UH7jtcq40GunHseKFRH7h0U=ePYBw@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/19] 5.4.233-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

On Thu, Feb 23, 2023 at 9:16 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.233 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.

5.4.233-rc2 compiled and booted on my x86_64 test system. No errors
or regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

Thanks,
-- Slade
