Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A85F2F3D
	for <patches@lists.linux.dev>; Thu,  5 Jan 2023 11:13:51 +0000 (UTC)
Received: by mail-wr1-f42.google.com with SMTP id h16so35713569wrz.12
        for <patches@lists.linux.dev>; Thu, 05 Jan 2023 03:13:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CwU6hcrvMI9c/5uFhbY17AhB0HFfRSXkAWCAbwJ1PdY=;
        b=BJ5SzG5SArLNNG+L042aCBpgTUuo9+rEXqaXj/QbzBMUbkE64ZAPrUiX5iZZSjQxez
         5JzTIe8sKRX/uAS4NTWQXCbVfQkX2UBiwTx5nCuTvhDlIZx3JBjRn2cGzGJhhy5F+NRk
         qB4tDsKu0EO32evpGTq0wOQ9Gu4qY3TZolvDtakxI9QOvVxgsIzvyi6yINSv7RKrl5lK
         uEwkXkIm9o0tNM8OynYKc8nHgNVJe0OcncN6coSbZyk/cVIrjrtkabRbq9EjIeMugD1u
         9ZKK0dLFwaeWdlAeO9a4vla/NGR4ExYBfDqe7LZo6xoRfLhY+9QPHIRd0hPtallcXZuf
         zRyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CwU6hcrvMI9c/5uFhbY17AhB0HFfRSXkAWCAbwJ1PdY=;
        b=j+zB4qIG8/BRAUOloW298KxwF6WGr02F5dxB60MBmcXtjIZpN0ODqklZAAVXL6gAn7
         /wNMZZMjtii7IWdiuAaiF1oaHHOxo2SQNwK0CoSNcsVYm1kBhzYz4pabCXoKGhp6MHdz
         JiqNCdnMPp8a9J2G0w+E/oJ7w62oQEt7PLSGaWtMe087j0nfZPIbavHhNNz6S5A6HJWK
         DtjDVl7Ewsu9FHz2ic/nGEQTZhgJ/41PqX8cFQJeWCoFnsXH41QneYvz/I8CWFUbrLAa
         ygsePAtIrytt0ltCIhr6zXPKxTC6nhHlelisOf/1RdPNRubwcWPh0b1eAa2wPH7G/EIh
         1iVg==
X-Gm-Message-State: AFqh2krySWUWFYLAEkJxOpPDb8BUDLY8bwQr8qva2NFkolrP54tENJoc
	tnaJT7duz6Etdx7sAsMpmzg=
X-Google-Smtp-Source: AMrXdXv2OMLOoFH577XI8/5JyhX9U8H8+pJrDVVL5GIsPmb8gn4xABX5y8ojS3EZOdDR4faSNkJbOg==
X-Received: by 2002:a5d:43c7:0:b0:26b:c52e:f7c7 with SMTP id v7-20020a5d43c7000000b0026bc52ef7c7mr38143892wrr.29.1672917229418;
        Thu, 05 Jan 2023 03:13:49 -0800 (PST)
Received: from debian ([2a10:d582:3bb:0:63f8:f640:f53e:dd47])
        by smtp.gmail.com with ESMTPSA id f14-20020adfe90e000000b002365730eae8sm36392915wrm.55.2023.01.05.03.13.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 03:13:49 -0800 (PST)
Date: Thu, 5 Jan 2023 11:13:41 +0000
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/207] 6.1.4-rc1 review
Message-ID: <Y7aw5XsCzOTkVx4C@debian>
References: <20230104160511.905925875@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>

Hi Greg,

On Wed, Jan 04, 2023 at 05:04:18PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.4 release.
> There are 207 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Jan 2023 16:04:29 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221127):
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

[1]. https://openqa.qa.codethink.co.uk/tests/2556
[2]. https://openqa.qa.codethink.co.uk/tests/2570

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
