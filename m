Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B9A8F76
	for <patches@lists.linux.dev>; Fri,  9 Jun 2023 08:12:14 +0000 (UTC)
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-3f6dfc4e01fso14344445e9.0
        for <patches@lists.linux.dev>; Fri, 09 Jun 2023 01:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686298333; x=1688890333;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/K5tYpr0uyjRNSZAPyx3ZIoIIDJLXA5XyIkkuNX3V10=;
        b=U5smjNqwRLICYAf9BnfzzvQesG0TofUWx5lEm4axQW7kDdK+jGuIDIwUD+KBzbIwQo
         /FBIc1lk+eYZgHqtGv9FVW7FqxQg1EHGMDGpLJVUm6vsqOmfUP1cMZZAZxKaSOMjBEa8
         0xLDw3m2+L/PSX07fVXMkdznWZ0O7o+Fl7OC3n8BHa676nF3ASIGHpP7uQs8B83pGv9i
         iMAwimHfjgDoqO5x6Oi7SA++BpikpCguxB7yk4weYLWzuMirZTwcmWsFRQwGsxggesV+
         03lxkRASFO48RNQ7FsMhn81nd5lGqQ0lS8YXHIWOn/Xm/Z6v03aFC0HoLLv6it8eUCYt
         lu9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686298333; x=1688890333;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/K5tYpr0uyjRNSZAPyx3ZIoIIDJLXA5XyIkkuNX3V10=;
        b=RTYcpK5YtVwUpVB5YjQ2OGbo4BxsJBNRqmhQwlNoLk5rnjOqfJxOZBQjQ6RO2jzZHo
         qfyNW78fjJ3/85LTFbbUjzpK79Yje0FdC+TiOP/gc5DIXpBTpRLj2v+9KJiKiTbLGjPE
         fGDUUO2Fved0ro3cZCxFS3rXVXpUiAGFN3WYZssqmCIFunJBSrvcmbkyPvbqD0DPmzMs
         vGb5wfMlSzNb9p1feNVOLD1TDPt68gWESP9OcoWdmjL98JCXsAWWMFhl5igC3gI5bp25
         NG3W408mKHpTzlzIgVrow8Fwj9GXvS0bNzXKtyXrRbQWmA1UxrqPThuxTtLS5fV1UBb0
         nvFA==
X-Gm-Message-State: AC+VfDxBWB0tf9G8R6S8wbkzR/gb0oWaDQWFDVfhGnIe8EXXEbJf2jwb
	vC8n449tOUYgCG8q+TFU6Sk=
X-Google-Smtp-Source: ACHHUZ5pMVfMD2N6fxcWKg1ENmmI5IvXZhleR9/leoP5eQbaNK2wmzw/zgbW+vJt+ArN/b3USKzlCw==
X-Received: by 2002:a7b:cb0e:0:b0:3f4:2ae5:b35d with SMTP id u14-20020a7bcb0e000000b003f42ae5b35dmr518114wmj.40.1686298332758;
        Fri, 09 Jun 2023 01:12:12 -0700 (PDT)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id p18-20020a05600c205200b003f74eb308fasm1806222wmg.48.2023.06.09.01.12.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 01:12:12 -0700 (PDT)
Date: Fri, 9 Jun 2023 09:12:10 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/88] 4.19.285-rc1 review
Message-ID: <ZILe2u4BsXGwXXAc@debian>
References: <20230607200854.030202132@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607200854.030202132@linuxfoundation.org>

Hi Greg,

On Wed, Jun 07, 2023 at 10:15:17PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.285 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Build test (gcc version 11.3.1 20230511):
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

[1]. https://openqa.qa.codethink.co.uk/tests/3799


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
