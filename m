Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C537C
	for <patches@lists.linux.dev>; Wed, 16 Nov 2022 11:06:03 +0000 (UTC)
Received: by mail-wr1-f44.google.com with SMTP id o4so29181352wrq.6
        for <patches@lists.linux.dev>; Wed, 16 Nov 2022 03:06:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BQx3mUtsIUh3Vy0b9GmrxhmpzLCHkLOldYvI6VMUkAY=;
        b=PagfyanFb0luTYvKTSg8oz5N/SnKghrXCv4UfuXCjAE15ywI3tvQZhnVNuAKBaUMqa
         4Wu5CDvGFIPSWneNKkM51lb3W9HOJ26l//zf2LbvAvqyAxl+LtEj9KQqeR/XR/Pf844y
         7pT6xeTirO7YEBQ7O9nFKIt3vVoiI5Ga2GITEP2sOEazgp1Tji2vJ6WL3UtQ/dnKmhSr
         5c/B3p6XyCgVD9G3hkRlKN5KItm2dzewleCyeJEs1cO/2pYJiFws5O4ybw6m6iTdRf4o
         SIyVmNfaRAgFdNbsMSGSpkUmWUjk+XqSU/IwYy9N/p0TMrAjPXpQauS5IY7mD0DHJ0pf
         IlKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BQx3mUtsIUh3Vy0b9GmrxhmpzLCHkLOldYvI6VMUkAY=;
        b=6IARtlMPuQOF2+QV/YBDhcw/Iw49hflXoo7s484noivj0SBIT/qfaTT2z2TJr4fABM
         eJbDWNv3R3wDfKgBimwPTnmh3pW3Eokffjh+0Ds+0Ia40aiyhTEBf6pGWDAhTAIFT275
         VPr/S0v4n9j1v0d7B3x3fUfXZKE7JolcGH4atZQsPzIcv22l5eUYtOMHXMFzEhF2g7K/
         /HLGdIRh43YaU6/hwFE4flkwxgkzni0m0gD4JRowGdqMIs09Aruy2M6YSODvfhapMYhv
         HaiqJ0auFDXgLZG5kQh2Gma+OYfi6qViviNDNbe68FsduxiGmO9s0uOGEjWuvEgxVZ+j
         6MFw==
X-Gm-Message-State: ANoB5pmgDpC2qiE9bvTyol/0zR3CGixSSqsIlyULey95eEurm//0XAqh
	MtQ3WjCtBwKAIYKkKT048rs=
X-Google-Smtp-Source: AA0mqf5+Askp+qzYt/NicE/3sALjyeDRdAyZXWwm1sSuh+ZpzsaN+OqOZ/IsCE/e4Bh3M+8bXo8p9A==
X-Received: by 2002:adf:e384:0:b0:230:e4e7:b191 with SMTP id e4-20020adfe384000000b00230e4e7b191mr12922337wrm.158.1668596761278;
        Wed, 16 Nov 2022 03:06:01 -0800 (PST)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id p15-20020a05600c468f00b003cfd10a33afsm1763981wmo.11.2022.11.16.03.06.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 03:06:00 -0800 (PST)
Date: Wed, 16 Nov 2022 11:05:59 +0000
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/130] 5.15.79-rc2 review
Message-ID: <Y3TEF6piNsjAXVAY@debian>
References: <20221115140300.534663914@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221115140300.534663914@linuxfoundation.org>

Hi Greg,

On Tue, Nov 15, 2022 at 03:04:00PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.79 release.
> There are 130 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 17 Nov 2022 14:02:33 +0000.
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

[1]. https://openqa.qa.codethink.co.uk/tests/2173
[2]. https://openqa.qa.codethink.co.uk/tests/2174

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
