Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E320C2C726
	for <patches@lists.linux.dev>; Tue, 16 May 2023 09:19:13 +0000 (UTC)
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-3f42b984405so54338505e9.3
        for <patches@lists.linux.dev>; Tue, 16 May 2023 02:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684228752; x=1686820752;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=y3MkdtHJ2Wn6h9YsBmYWmD4vsSF6yvzo+NF5U8NDuFA=;
        b=hFh/MCjLptpQwDMiF7H3IKYj9HR6c/PLjm63ECA5NSQN6FEIN8BL4ZOUSNRDwZekBA
         bs7Uyrpc1YT8AD74aMHC5fWvW3rdPBaK5gifHRuktsAcpSvmZnxKIREl/6y22XbB3eRe
         S0mz20yLu/ayAMLVszs6jFC5mCPnVp8bhmVkCZhVx7XTVNqScWDWSoPflEXChscKwRZr
         7YTqOYSJ+cUKWnN0ew8SpyHoejAgkEVeVQ7wBNux8XCNwcl/LoPY5wK/KBNvFW0WsO1m
         s6XUtWQMESkI8UBQT6oRX0ax7D/SfsJYmoi4kfI0YGnUCpdp2Fk6TmqPbjvjvBdRvBZp
         80kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684228752; x=1686820752;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y3MkdtHJ2Wn6h9YsBmYWmD4vsSF6yvzo+NF5U8NDuFA=;
        b=Va00bUhqZ5XDA5tkadd1vqRt3qSaKqUtZL1Jomu58LVR3sg0qn9qmNvbUeyFl1wbDN
         q2CCD8Y1GAZNd7TrmHaMBBPcJRLm0qvHOSfxqgTz3JxhyZGHDkkURCiWQiiDksgcdA9S
         iiOncYvnYLFFhnntQNJ6ssww59i1Wm+nyiHlT0LFe4b4Rqm005PV0Ae2Ef5/5+1BeZh9
         RCZfkxCf5NW0rHcKFH6J2E8RdCGn6sdyvYiOPtBiWrVRx/uufDmNQ2SWGuPIHNdzPIMj
         r3F5OkPFKaT25IISaTTiWtWL0IFA+gihUHJDwudRHmmxyIYY/agErbGJg9NRRljFu19Y
         dSJw==
X-Gm-Message-State: AC+VfDwN4kkAwbl2EIZJdY5RztSOmpQxnUkg6xlVzTK/BlU3Lqb0+sJ5
	v/PdObUYrBe8E/4OM+8Xu/bMNQ7mpWY=
X-Google-Smtp-Source: ACHHUZ505uRu6aCnAjzxPjg3zmhCDP2VDUbzyaYyhVG1tTnQMVN5NkjnjklVdIM7B2nUochZAOCRMA==
X-Received: by 2002:a05:600c:2149:b0:3f5:1240:ace4 with SMTP id v9-20020a05600c214900b003f51240ace4mr1589722wml.25.1684228752006;
        Tue, 16 May 2023 02:19:12 -0700 (PDT)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id v10-20020a05600c214a00b003f50e88ffb5sm1664081wml.24.2023.05.16.02.19.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 02:19:11 -0700 (PDT)
Date: Tue, 16 May 2023 10:19:10 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/242] 6.2.16-rc1 review
Message-ID: <ZGNKjkwrGvqGRv1U@debian>
References: <20230515161721.802179972@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230515161721.802179972@linuxfoundation.org>

Hi Greg,

On Mon, May 15, 2023 at 06:25:26PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.16 release.
> There are 242 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Build test (gcc version 12.2.1 20230511):
mips: 52 configs -> no failure
arm: 100 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/3537
[2]. https://openqa.qa.codethink.co.uk/tests/3538

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
