Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24B033E7
	for <patches@lists.linux.dev>; Tue, 31 Jan 2023 11:46:16 +0000 (UTC)
Received: by mail-wm1-f53.google.com with SMTP id j32-20020a05600c1c2000b003dc4fd6e61dso5384658wms.5
        for <patches@lists.linux.dev>; Tue, 31 Jan 2023 03:46:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Vq6HyzZQz16acVezHP9SWCf3XDSeGmT7X5o85bGVUXI=;
        b=O3K4OC2d1o7wCk5uvlizgzHRkdNRc6DX0k1b00MbHp12QYEWZihnzSfFBwZ5Oqcafq
         23Ic2mZD8xDbezEYL92zKoPxPoG70eruVVDuQGJXP7/qpJP9+dwd87wLV++tAnYeXKyE
         6QY2729ZAB9rTFOfmAIdzemrV0iQ1i3ILP3AZwnZjnSGqWam9JFQUByBhIFygL1nz0x8
         R+/CL2n6IcQrRBCWMorLCo7XvKBgMOh1Q37V7kuxgnyt1F74abFNRSOJzq0OD1XkYgco
         ofmqqU0k1KN6YEOY9qeR1uQ1b1Q2jHujoXgh20lGnVJfrdR56WJK2mR5udBR6Ng7XI3k
         Vitg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vq6HyzZQz16acVezHP9SWCf3XDSeGmT7X5o85bGVUXI=;
        b=Coy5eZCXZ1ZqV3JDShYRbrTdOplXjN6dWrD2Swxyu12Bqd/VV3n5EeZz++n3c5lreW
         uDRgcQD6vhO4P34EJDkRDms8DT9Z6uS/NeH2lJ9gGR+Yeq3ejCLMyZy+23GMHOSIkrD+
         RbrwG5ZAZLVnEPSV3lYjG/Gfc44SMjhFgWJ/LWbJuTFI4qj/ImWy40C5vWrhncujmP5O
         cStEAhtlQSSd6DtFmtmMtwrpTCe5QQrYKsRLOkjL7WfG3ehizjZ0R/vnYCaHd9kLqLXm
         IKnrZdMXbBF7T5lEnPXIwDTG3keWycLNSZLQmnujABUhq8utf/+VZT2KjztO9zAzqhlW
         h1zg==
X-Gm-Message-State: AFqh2kqZZh4CkfzIbVKuY+QzfI0P/vVoC1Nnah8nvfbbkcdPhOE3XzmP
	pQV7lr50e4BwqYdKhwY9Y5Y=
X-Google-Smtp-Source: AMrXdXu/k4+Ms+DPozoJf6nMbT8xOFk8bn1foiMZqp1W7W3R3cVBaz/D3DJiguCZcxcC1UEggGVkCA==
X-Received: by 2002:a05:600c:255:b0:3da:f9b7:74c7 with SMTP id 21-20020a05600c025500b003daf9b774c7mr52369687wmj.13.1675165574753;
        Tue, 31 Jan 2023 03:46:14 -0800 (PST)
Received: from debian ([2a10:d582:3bb:0:63f8:f640:f53e:dd47])
        by smtp.gmail.com with ESMTPSA id p9-20020a05600c358900b003dc1f466a25sm19860084wmq.25.2023.01.31.03.46.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 03:46:14 -0800 (PST)
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
X-Google-Original-From: Sudip Mukherjee <sudip@debian>
Date: Tue, 31 Jan 2023 11:46:12 +0000
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/143] 5.10.166-rc1 review
Message-ID: <Y9j/hCr0GJjyDr1j@debian>
References: <20230130134306.862721518@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>

Hi Greg,

On Mon, Jan 30, 2023 at 02:50:57PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.166 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Feb 2023 13:42:39 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20230113):
mips: 63 configs -> no failure
arm: 104 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/2767
[2]. https://openqa.qa.codethink.co.uk/tests/2770


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
