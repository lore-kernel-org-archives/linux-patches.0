Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7090A381BA
	for <patches@lists.linux.dev>; Fri, 17 Nov 2023 19:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TUFplf1l"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-5bd6ac9833fso1678590a12.0
        for <patches@lists.linux.dev>; Fri, 17 Nov 2023 11:35:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700249751; x=1700854551; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dZRK1FfwsE2ENsrOhX95EMeeGskbRwU3bk+UNV3kNdg=;
        b=TUFplf1lZ8WH9cuhnTX0xZKh0uJPC3qWt93ZlGI3RqLpMKvu2/oOaekdVfQgGyj7W2
         cxL47mortbSahU1k04pBIQLiqKC9H97Z9DfUUB0GABDztJnGEa+pZspTA6+lezO17kH7
         hRB7BOMxqhD0f45BDLyIKskSVW4ifZsJi638psdZ9jzRZE+AW8pawYxQytpfpte2FZM+
         LE5KywcubSLcoXuuNyd1byl6UuNCjTnbJigT79SpMfmwpVAXNX4GuOaMKWdoW10bUnNZ
         fKeeAAc7+YMN516wBA23eOECzYAqm9wP3XknSk05bmY8rpL9fAkd2ERbZsvpm9BY7JKQ
         rwcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700249751; x=1700854551;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dZRK1FfwsE2ENsrOhX95EMeeGskbRwU3bk+UNV3kNdg=;
        b=w6T9vEClU5DgrF2vYpx4eheF4juYrR8/MzCTkerQn00wRGBzO3Zz2W27gYrIHs1IvZ
         bMIhy+VQBwo9DVTm0wySHnslP/q5lMCg4d5KV9NuGbHX7tF9jqPYwugDxJnJ9NGalxVB
         5+XwWnjZErb2IPVSU/NBx6vLSdlI9TD7utznik8JhAl/50x6GRGRPnbooLOz8Qj/yKq4
         zOevEGqMQaOFdVVVcrdPlBhVGIXKWaINnOaVbO/MSu/BfRYO1RAq99az/rlMhy3XK6ym
         prkZ2Yrgm76TxvE/za2GT98vRRCqnpYNSV3rPOH7qZOiBoKMwjiFqZ58Zn1n1Ful7cl1
         kzQQ==
X-Gm-Message-State: AOJu0YyjD7tDxkxdfBCBQsBgtC/vIYiqNojmKkWBBEJH9sPoI7Rm1bbW
	FHNVFI6SO4r91j30kyLG1PU7jxOrZ5XZz6HS44M=
X-Google-Smtp-Source: AGHT+IGNdFDzIdqjtmNoikmTPBIaCBLF2wsKTAAXbe641EHDgwT6fDW9TRc74V0eG80y4OaWMr3E+A/xV/2xOWJGqTQ=
X-Received: by 2002:a05:6a20:72a3:b0:189:2e8f:d357 with SMTP id
 o35-20020a056a2072a300b001892e8fd357mr97485pzk.49.1700249750688; Fri, 17 Nov
 2023 11:35:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231115203548.387164783@linuxfoundation.org> <04d4d38c-9130-4749-9ef8-569528939147@roeck-us.net>
In-Reply-To: <04d4d38c-9130-4749-9ef8-569528939147@roeck-us.net>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Fri, 17 Nov 2023 11:35:39 -0800
Message-ID: <CAJq+SaAruya2P9R8Y9wJc15e8p93G51zjh6dZNq5JxzDNaipiA@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/244] 5.15.139-rc1 review
To: Guenter Roeck <linux@roeck-us.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> > This is the start of the stable review cycle for the 5.15.139 release.
> > There are 244 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 17 Nov 2023 20:34:45 +0000.
> > Anything received after that time might be too late.
> >
> Build results:
>         total: 160 pass: 158 fail: 2
> Failed builds:
>         i386:tools/perf
>         x86_64:tools/perf
> Qemu test results:
>         total: 509 pass: 509 fail: 0
>
> Sam perf build failure as reported by others. Note that I see the
> same problem in the v5.10.y release candidate.
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
