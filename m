Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E4E185E
	for <patches@lists.linux.dev>; Thu, 10 Nov 2022 11:01:51 +0000 (UTC)
Received: by mail-wr1-f46.google.com with SMTP id z14so1695789wrn.7
        for <patches@lists.linux.dev>; Thu, 10 Nov 2022 03:01:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qwVlhKyjAqadEs+EcXaVXZXm59VZBVI2UWpnsWBfohc=;
        b=ArAT78dtQ1LjisEGZG3pTBQt5HrIKKY04HEkhLvfGO/r/9e67iqQOAyWor/GxtaA4F
         ClSQKShwC+9MQp2KfENv2A/a0skEJw2MHN8enpTq/q40eEI0SvyEFsDWmeynwdRCRlTn
         sYmGCbiGz3Jgc6Uce+UQsTTtZUMJS2DJk+5K7Pi+PXgWRGc9m780827nEffQ/hPG2r0l
         4Dzc2WtERcC40Nljm+esM94mU0WWn9grwUqq9xTEQUmle8xGC4V11rqtI+TacBtoptlj
         ty5yLxhkKf7hNzDjVK9VqE3/jbPKKdK1qFpYmKDZ9DtcFUStQ6Va5HBsdioIT+DsoBOd
         tZNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qwVlhKyjAqadEs+EcXaVXZXm59VZBVI2UWpnsWBfohc=;
        b=A67hcanvBY/LujLaQWwVtXsjF3EIkLVdyFdqNi3AOdd7bcqf/UzhTyukBEzEYP4eWb
         IASKFBHlkqAhtTPcr6CNRohHY1wS2ZWC2vqBgqVWF/OLU93lsQUJEBu//X/ydHeC8LD0
         sRvhsWJ7hXJmwAcl8HopYcoILlnY1sdmwWzx+B2I9ge1uXush3m/rLiZPdGrKysgU+nE
         0p9Z2yFbww6TqBx1nS+B1agwyf3EXsrW+iRI42VmZX6Rsla17im/FI8vyspJF0fM0S8W
         9dO1vwW5atHGotRTevp8xK+764QHmRbt1DdmaAjbx2mruWO0LBXdwpMZ2tL9hhnluCqL
         JpkQ==
X-Gm-Message-State: ACrzQf23t/6ot4nuNWfviLVQKu/1ac2mXqX0l/yBlXdwtyqI0474NJY6
	nSipMNRJVOWSyk5luv1K0fo=
X-Google-Smtp-Source: AMsMyM661UjkKr37EV1uSH5xPOCcFl3fqWzZ+QPAv7YAdSe7Bt/HNMU7Wa2/TjPm/VlvVn+PbPTGAw==
X-Received: by 2002:a05:6000:1888:b0:236:8b32:cb47 with SMTP id a8-20020a056000188800b002368b32cb47mr39150806wri.601.1668078109562;
        Thu, 10 Nov 2022 03:01:49 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id o4-20020a05600c510400b003c6d21a19a0sm5274531wms.29.2022.11.10.03.01.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 03:01:49 -0800 (PST)
Date: Thu, 10 Nov 2022 11:01:47 +0000
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 5.15 000/144] 5.15.78-rc1 review
Message-ID: <Y2zaGx2TV0bGf3gM@debian>
References: <20221108133345.346704162@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>

Hi Greg,

On Tue, Nov 08, 2022 at 02:37:57PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.78 release.
> There are 144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
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

[1]. https://openqa.qa.codethink.co.uk/tests/2128
[2]. https://openqa.qa.codethink.co.uk/tests/2134

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
