Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E35C5CBC
	for <patches@lists.linux.dev>; Tue, 13 Dec 2022 15:32:12 +0000 (UTC)
Received: by mail-ed1-f43.google.com with SMTP id v8so18256505edi.3
        for <patches@lists.linux.dev>; Tue, 13 Dec 2022 07:32:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9LFcn2LS2h1mCkUkoHgPOjFPfjs4oxAUSgVBVj57pOE=;
        b=bwnC1QCUTzSNR0jnSkHm6+NJvylAT9qlE995YBiYZths7yzrOPGvqQLltEoONhJ2la
         GflqEwoVSojbh60Z0i73QDq8c/1RO0QSMenTMRqDWjDd+ngpMibFdBlnslXzUTDlHH2N
         svMaYW6+fZrBRJK2/mDNV1/rVtViogyVXdvXYhF+S3i/oIa8TmTydJfWi2ly3GtH6+Mb
         G0ZcpiHYvHSplWtGeQuMcqUVA8ycgFMhuTQ//DBDnN6Ctj3SBr+L2DNfltRja0fiZJFM
         XqFuJTBPm4t3pDIErWBXEa50bq2HgMiHyDNPVL+kJBXM2pc4RfcycXqZrLYhx5JVV1KV
         3oXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9LFcn2LS2h1mCkUkoHgPOjFPfjs4oxAUSgVBVj57pOE=;
        b=H3scSqEehx38sVEk9ZLj1WV9lAJMP8jB/wDHZpn9+HH0E+Hy8IjKmae5v6ce8XdUYH
         d643G6/N/ETlHNMI/knm22JhOTN87+aDthmHxHS0SJE05Nbp63xFoBON3SBBhlEfyJID
         QWcVl2vRJmaIg+tFS5XirecMtYKsv2yiF5OhaNy9QMUkamjAaSmIeu0VlzfdgW1ITGwo
         plZkC2zB1nCCs5GHuxz46oNeVTYXl9QqK5R8v9uUwl6iXs0VM7SDOriQlf2IDFGp7GcQ
         H3JGvGzVHXB/eCrTD9GwbNsM2HSPljhQ5C0pZ7q9mhTDdrvel1CxyHDPiz8ArDv4CSe3
         Xpsg==
X-Gm-Message-State: ANoB5pleMlnQMqWYvyoyWrdgpdaxmiHZF1X5bRNbEMd5PkWK3aSdPfFU
	HomJMqwpV7fuwQtTZRwImMhlu7OfL/pWhwKp8YA=
X-Google-Smtp-Source: AA0mqf679IR0szw2P7LGnGsO9Uvt78/3pJf6iUxIbum7zMS/JIZHte0W9eaVemwbp9x2EKxXCQd99qUcs19KL2jT5S0=
X-Received: by 2002:aa7:d841:0:b0:46d:692e:8572 with SMTP id
 f1-20020aa7d841000000b0046d692e8572mr7127576eds.25.1670945531147; Tue, 13 Dec
 2022 07:32:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221212130924.863767275@linuxfoundation.org> <Y5hqsggURI1Me1ik@debian>
In-Reply-To: <Y5hqsggURI1Me1ik@debian>
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date: Tue, 13 Dec 2022 15:31:35 +0000
Message-ID: <CADVatmPM4Q5A9jVO6-ixhqa2HWh4rWPKNpfwy75u69My=3Xhjw@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/106] 5.10.159-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net, 
	rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

On Tue, 13 Dec 2022 at 12:06, Sudip Mukherjee (Codethink)
<sudipm.mukherjee@gmail.com> wrote:
>
> Hi Greg,
>
> On Mon, Dec 12, 2022 at 02:09:03PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.159 release.
> > There are 106 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> > Anything received after that time might be too late.
>
> Build test (gcc version 11.3.1 20221127):
> mips: 63 configs -> no failure
> arm: 104 configs -> no failure
> arm64: 3 configs -> no failure
> x86_64: 4 configs -> no failure
> alpha allmodconfig -> no failure
> powerpc allmodconfig -> no failure
> riscv allmodconfig -> no failure
> s390 allmodconfig -> no failure
> xtensa allmodconfig -> no failure
>
> Boot test:
> x86_64: Booted on my test laptop. No regression.
> x86_64: Booted on qemu. No regression. [1]
>
> arm64: Booted on rpi4b (4GB model).
> Regression noticed:
> Failed to start Network Manager
>
> Will try a bisect and find which commit caused it.

Bisect pointed to 60aefe77fb48 ("net: broadcom: Add
PTP_1588_CLOCK_OPTIONAL dependency for BCMGENET under ARCH_BCM2835")


-- 
Regards
Sudip
