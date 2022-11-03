Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC866FAE
	for <patches@lists.linux.dev>; Thu,  3 Nov 2022 12:20:27 +0000 (UTC)
Received: by mail-wr1-f44.google.com with SMTP id h9so2562836wrt.0
        for <patches@lists.linux.dev>; Thu, 03 Nov 2022 05:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mw4/Yfvrzn2p7M0QFJNU9GmrUVeholUQiOtl00+DcHU=;
        b=DhKquTefpxZY3+yipjtQ1egrvF2ZYXjn2VQXNUVx4SmushbHOBXmli8ZgG9Nz/+jtr
         4Cvs1J+sVFgzt7j/9ti17tMqzdBou/v3NylqQ0sr3CwQpTQgJbGoMVxqRGmpYx1BbvA8
         XwRZ20b0HqmSy3I0p2Uqcx3aXooLzHGZWVyj7dIsyv+BrcyD0wXBTcclHscZw+Dvxwi4
         gpcxcRcXzA2rbYyniECLPbyfUvWjYpp7O/zE9jgAFAe4dc8NJluKaJwMH966pAAkW++B
         Hc8HgZw6fpMi9pgZuXNGDkXJpDP9z8fc5LyGqwwITcGfrXQEDwehM8j0nn5mNsBpViwh
         ikfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mw4/Yfvrzn2p7M0QFJNU9GmrUVeholUQiOtl00+DcHU=;
        b=tI0GqQQ8Aq4PKVV3D2CMz3ThVe2mAN6cyCiYeXgkQc97yr7UxTqa2gpWfGHPdJkRR8
         aAa4BTSxWIjhSqJ3ehP13m35aXMhNqZDFLr77hjcjjtRVJK3yjVmCNR22jsL9bzLD0i4
         b/2U/FnZbrj8zlAE2BXWqmxNoH8SX0sXeZvbEdv4b0Bc5kH1drryTkg3dLO6cXuiTu3Y
         X/sIMVO9X+FDnmaEI61fMqKd86gS34DnvnveXRG/bA5Lyf4hIg1sL4lk1yNn9q6Ir2/z
         EP7SUTnmufSFdNZK+6ZddyoSqVtb4QNF+wtW8K7l/Eh7AzFpjRJHU2a+5ExI+exARfXT
         BElA==
X-Gm-Message-State: ACrzQf1i86crtK8P6/qOWuKAE4wuBS8bVS3zmE+EfRkb9cGxhbI9xYOV
	egVw1RJSAtdbq1KzYa8NUic=
X-Google-Smtp-Source: AMsMyM7Ga5AcXFy9woPmxBiXYGjqxPJhkR+yThQ3lHxs6eqnpvgQFVxfUm3r0tbxywFQ4nRj1/kl9w==
X-Received: by 2002:adf:e3cc:0:b0:235:95b1:2124 with SMTP id k12-20020adfe3cc000000b0023595b12124mr18912757wrm.693.1667478025320;
        Thu, 03 Nov 2022 05:20:25 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id d19-20020adfa353000000b002366553eca7sm697825wrb.83.2022.11.03.05.20.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 05:20:25 -0700 (PDT)
Date: Thu, 3 Nov 2022 12:20:23 +0000
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 5.10 00/91] 5.10.153-rc1 review
Message-ID: <Y2OyB5m9padrnGr7@debian>
References: <20221102022055.039689234@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102022055.039689234@linuxfoundation.org>

Hi Greg,

On Wed, Nov 02, 2022 at 03:32:43AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.153 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Nov 2022 02:20:38 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20221016):
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

[1]. https://openqa.qa.codethink.co.uk/tests/2091
[2]. https://openqa.qa.codethink.co.uk/tests/2094


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
