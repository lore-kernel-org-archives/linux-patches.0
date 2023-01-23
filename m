Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C791F7C
	for <patches@lists.linux.dev>; Mon, 23 Jan 2023 11:21:19 +0000 (UTC)
Received: by mail-wr1-f45.google.com with SMTP id r9so10456564wrw.4
        for <patches@lists.linux.dev>; Mon, 23 Jan 2023 03:21:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NQ6F7ByEyXvgljzDRhRD+1sz/yBJjJzITDLGLQ6hLZU=;
        b=M6pzUXi97lLe5CYbkWn2+KGor77imMV4cmfzdqss7U3wsnK9vCQAZibugu9ETkXaT6
         ltol4zbtJtGjQyO2QpmVOm4p/7R2QnACbsOpwsnEsiBPP7kFUQS4moq1XlUw6WK7tjFE
         D3E0If3TNy/GE2TAippT7pK0p5hoPpAkbViFRHg4vT5TxVChjnTmnODRTmfGv4O0+yOq
         2nzHk2j1QlDUHlI1JJ7lxY4cSdKXXnk4GpJQnBhYo3OXpCmTs5iHEefAWAFhoWeafU4Q
         Rab/PgbnXM71qHEcPGpVb8LbFKmmkMx6ip4ymRajcmB49YVxkWJQkc4H3NkvtMz4sh/t
         KX3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NQ6F7ByEyXvgljzDRhRD+1sz/yBJjJzITDLGLQ6hLZU=;
        b=zytCfGb0U+7rxd/TPNNfIXHeTseHmCj+X1KR/nks3jNNt/Epj4RVIMtE4chrPJuKB+
         UkALEe0K/tV1KHB8k7FGoPJrBTWQ3IbGSGEhB29T8lanHq2RTDBGWhgRpNvmrDGgFlTS
         NwZb9l7PnmQeWAx4I9zInVW5P9z6Xifh21cu6Tpe0mr7KS61BNtWJgiVFgceBhhE7bdc
         uJC6HFGC/k7WnwY8wsP/WlRZ3tW2K0vD4oJzHLXk4GTbtvZ4RmgZhBZuUFY/YepdDrSj
         rhmnbDodj8417rgZY9K26BKC4AQvyoz1HO9f/2QB3ov4asxBDJDcCvh/aa2YeeaK4/EQ
         WWxw==
X-Gm-Message-State: AFqh2krGSU7EgS7k0p/rXY+Xd3UxEcasBu8zDW7ltTc3zm4RRpqijwdu
	adIweieGhtDt5i/2Wq9gFW6oAxSJ2TM=
X-Google-Smtp-Source: AMrXdXvk1U0ANXNTh0jAyGxCB5b5XB0odlB2XbaDvisVSZcyC1Nw5JvRCfNbrL9ll7DlBXzERy67Sw==
X-Received: by 2002:a5d:5107:0:b0:2be:1b37:7f46 with SMTP id s7-20020a5d5107000000b002be1b377f46mr16759745wrt.71.1674472877971;
        Mon, 23 Jan 2023 03:21:17 -0800 (PST)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id o2-20020a5d58c2000000b002bdbead763csm31343788wrf.95.2023.01.23.03.21.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 03:21:17 -0800 (PST)
Date: Mon, 23 Jan 2023 11:21:15 +0000
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/37] 4.19.271-rc1 review
Message-ID: <Y85tq8crdNCZLGZy@debian>
References: <20230122150219.557984692@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230122150219.557984692@linuxfoundation.org>

Hi Greg,

On Sun, Jan 22, 2023 at 04:03:57PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.271 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 24 Jan 2023 15:02:08 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20230113):
mips: 63 configs -> no  failure
arm: 115 configs -> no failure
arm64: 2 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/2694


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
