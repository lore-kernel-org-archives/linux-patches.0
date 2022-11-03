Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E1F6FAE
	for <patches@lists.linux.dev>; Thu,  3 Nov 2022 12:19:13 +0000 (UTC)
Received: by mail-wr1-f53.google.com with SMTP id w14so2476350wru.8
        for <patches@lists.linux.dev>; Thu, 03 Nov 2022 05:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pWEEdx+YezyxuRtMmbkm1fJHcf2yNIYfElbdobSuFso=;
        b=iwQJR2zZTLZk8wrntXiB8t0NEqANsGyWryIoRf3TgA3FtibeBpZVi4wfh3fD+RE0BD
         bwtOCLa2WasQwykislqDTGdEIzNCoOYiCzjkZAoMa00ysFx+BU1PxC91OiO2iuHlTPZq
         5nSKMnJU1Rssd+6IV7AONkDs9n6XXn/bR9OmED4aqK2iCB8dpEYo9PvznhvH4wIe0BML
         Y9moTljsrZ4MhSNfRGdMsPLx4GFDR/rVo7QsuKyiTFzq6xYkaypE07ZVRMUxgFwuWkEI
         TxJnsQX/TFdiQ3XRrQAq83ejf/KdAt7dMZGnKeh96qclRijHSJhRZN5QqqRmokJfrQAJ
         4Kvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pWEEdx+YezyxuRtMmbkm1fJHcf2yNIYfElbdobSuFso=;
        b=0Ky/vefO1iN9HOBXII/CEA6Z67v5irXTsuYCbGFOUJFsPfGMZzs/RWAbIdNceoKnJT
         XquaVF3OhT+DZwhlgpbN5AyQlexFpMkJnq/gbHz4UHmtgD0taEKZoqXheWpzhXqqrWz1
         N1UP/Rqmkr8N7EfA39cwO45noM+kec/od25knbcwGoGvR9nQ8164Hu+ekAyJfo8ktvMG
         2uKBOqMvoURZXkkZrUWLmAmynuKHjHb+BYWvRQH9PhvhTY59StNvR7ollfx5cbzK1od+
         PN82uDxsCybBwnLRpkkIS53X1a9Hf+ePl+H1a1XCaNmg4pI3qIJjWDXV39DJNiPsjImz
         /j1Q==
X-Gm-Message-State: ACrzQf2EpTVaJUE4HEy4sO97cb1jc1uZ5OJX14ShUopVyZEdKFcE7pIT
	zEwKbWDFl+8QX6LuciThXY2e1Dt5no0=
X-Google-Smtp-Source: AMsMyM6KTzlYGsfMjXjk9fkYFRNYnIYq9dh98J9BC9AdhZ/rA5SWcPkmtZWzOvn6GBxd6A96pRyBdg==
X-Received: by 2002:a5d:4e4f:0:b0:236:7a40:ed01 with SMTP id r15-20020a5d4e4f000000b002367a40ed01mr18168993wrt.402.1667477951374;
        Thu, 03 Nov 2022 05:19:11 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id w16-20020a5d6810000000b0022e66749437sm746794wru.93.2022.11.03.05.19.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 05:19:11 -0700 (PDT)
Date: Thu, 3 Nov 2022 12:19:09 +0000
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 5.15 000/132] 5.15.77-rc1 review
Message-ID: <Y2OxvYHoM3fZIAYX@debian>
References: <20221102022059.593236470@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>

Hi Greg,

On Wed, Nov 02, 2022 at 03:31:46AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.77 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Nov 2022 02:20:38 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221016):
mips: 62 configs -> no failure
arm: 99 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/2092
[2]. https://openqa.qa.codethink.co.uk/tests/2095

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
