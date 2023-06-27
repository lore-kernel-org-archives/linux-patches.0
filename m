Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E5067473
	for <patches@lists.linux.dev>; Tue, 27 Jun 2023 21:35:10 +0000 (UTC)
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6682909acadso2709976b3a.3
        for <patches@lists.linux.dev>; Tue, 27 Jun 2023 14:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687901710; x=1690493710;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zmQ9zd7xQJwvNtpIkcfyPK6Njo2kIyN7smRGjB7ejEQ=;
        b=fPh6lHNmMZLYTTSo//0blngZIkfu79zQJYcYrEU3jeDEPQLY9/E05lfdk2ninoZoca
         p2i/MU4IhwuSxG/jRDxMCuvkOB/VTL5pl2nVmKLgIO24oNSQ2DLtNzHPJUXimm/8874H
         1k0NhVx2Rboi5+K8UlH4OZ/7fRcuX5AbNAelhYvqUp4YtMhGgwnvDfY9ArfdVrqsCqYm
         kGy7rUNWz+RPsA0YHNM6w/yx/qbtkww7W4zQGH2T/uuC5ex9ixy90FVo4kGR/WI8nWag
         MZNc69e5iioHr74UeeqgmkKN5EuZ2sUQrQNwGBiiCJKyddi3VvfP6HKBWHe55vjfOvpF
         9j4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687901710; x=1690493710;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zmQ9zd7xQJwvNtpIkcfyPK6Njo2kIyN7smRGjB7ejEQ=;
        b=A1wDDR/fxxeM7zrFkHxR2VqgHZLjG6j0yx0xJwwk4NH1ytwd0Py+Zmg2GVqjrbkCag
         spZXKJfy52wHDkRHbA6R2RcnEzsrPtK8ivRHffbiNyD1Fx9sKDR9qqqq7VnZqJqfCl5J
         LI9LNVEeOPldO1eJ0857wiIgu6pExaXoTMqo4GLeCGhpKVYTqaftZFdXBxv70NrHdoR4
         2qCirJbTxBGJumoHmlXlFWxMu4j0pTjS9a4mYsSh7W4TS5PTBmnPs8L0GAbswxztEUev
         knTaKC92NWbd8qi/e9GNC3+YH7pQjRcnxaeYKD8pkdxjUeQR9t2E06zs41rjRgOk4xeL
         7Lew==
X-Gm-Message-State: AC+VfDzyNgB4uHmDjxRnNxgOBhMONpMSgLu7LZl5dxmECJ9IHhaRRvXh
	7Lrd2nKdNF8To/RL5wJMw5c=
X-Google-Smtp-Source: ACHHUZ4au/NvssIowVsyZa3y2/EUVClG0VLbd5u4HwP5k/6eL+ZA3fLp+nQBjNPvHqalJw+5CpluCw==
X-Received: by 2002:a05:6a21:585:b0:10e:f369:2809 with SMTP id lw5-20020a056a21058500b0010ef3692809mr18579392pzb.21.1687901709902;
        Tue, 27 Jun 2023 14:35:09 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d25-20020aa78159000000b0064378c52398sm5809209pfn.25.2023.06.27.14.35.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jun 2023 14:35:09 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 27 Jun 2023 14:35:08 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.4 00/60] 5.4.249-rc1 review
Message-ID: <0876bd1a-b500-42ef-81a4-7bc35f31b927@roeck-us.net>
References: <20230626180739.558575012@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230626180739.558575012@linuxfoundation.org>

On Mon, Jun 26, 2023 at 08:11:39PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.249 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Jun 2023 18:07:23 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 455 pass: 455 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
