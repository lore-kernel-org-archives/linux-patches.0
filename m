Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2EC014F7A
	for <patches@lists.linux.dev>; Tue, 29 Aug 2023 11:35:54 +0000 (UTC)
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-31ad779e6b3so3542582f8f.2
        for <patches@lists.linux.dev>; Tue, 29 Aug 2023 04:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693308952; x=1693913752;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xWhAtL2TKAqZhNqTfWPeRd6vPLlQaIg+ZlfW16RbgSE=;
        b=ZFXXSDF09zrHP4TQEdm1z/2f8J0GVa8l/tVn62bcGmv3gQzX8LR37g5UjPuwxAVoEu
         oTOrMiCH/Lc/RuzNtxFNIxaxFI/QIoZl+MngjhtTgtB68D7EKRFMYxIy7c9gv5u6J1GA
         gJz98LIbcQoDA3eu+2zmMuCZoi5RqlTFAhNgxPIVQkQoAvA04BfesckW1HlpKHDWXXjf
         wQri5WErEfU/wKrjIzr38oizGUPW8wTdUub05pcfC/CV4UDmz7d1mXEwGI1Rq7EkSuxZ
         BCA4MDuaDTzvohVb339hjbhVTUpT6opZDhk3v6OMZulymwgaP/w+nI9OE4v0B/PcP78P
         qcFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693308952; x=1693913752;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xWhAtL2TKAqZhNqTfWPeRd6vPLlQaIg+ZlfW16RbgSE=;
        b=g0Zq147Iq5/lb9R96PIz9krLoFyU0ZSBRf1nmkIC6wAY6Ccty55qNURBzvl3K6JSv6
         DVbFEDraXhw3/5Fosbsd/9oQTRhGiLlxme0kYO7VeHAAsLs+gU7QMRDgYBhZT620E3HQ
         /o1OqBjH3Zfhl7fHUiMCgc/w8EN9qf/fuUkrF0Vtj19JQ4cEwpodaPc8h90dOPqKFOt/
         /Hp5cglSpyZB+HxZUxf8uSbHMOmZith8882zeP1AHwpGKS6tvDROO+RCaA+QB6G4rUfG
         uFPgYM8NC/gKMUjiWJz8kY0lKpK7Cw/Y0jMakRlRtxr5uBb3UG76M4lb/LvWY+T38TtR
         1DJQ==
X-Gm-Message-State: AOJu0YwHKf/RAURMZuMLPW/6gfmhpxkK1Zlf69TJg/i8dTAj164UuxtY
	avQS5CyzxoO1D6GiL7qitU8=
X-Google-Smtp-Source: AGHT+IG1HNZ5VMTyMEpkNg73r5goCQlAVI6Pib8xIMrDC5m+I2nm2/1ePjQiKBmtjapVMFZeXlr/QQ==
X-Received: by 2002:adf:fc51:0:b0:314:1443:7fbe with SMTP id e17-20020adffc51000000b0031414437fbemr20697268wrs.36.1693308952394;
        Tue, 29 Aug 2023 04:35:52 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id z6-20020a5d4406000000b003143c6e09ccsm13507702wrq.16.2023.08.29.04.35.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Aug 2023 04:35:52 -0700 (PDT)
Date: Tue, 29 Aug 2023 12:35:50 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.4 000/158] 5.4.255-rc1 review
Message-ID: <ZO3YFi7KghBSABnH@debian>
References: <20230828101157.322319621@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230828101157.322319621@linuxfoundation.org>

Hi Greg,

On Mon, Aug 28, 2023 at 12:11:37PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.255 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 30 Aug 2023 10:11:30 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.4.1 20230829):
mips: 65 configs -> 3 failures
arm: 106 configs -> no failure
arm64: 2 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Note:

mips builds are failing with the error:

arch/mips/alchemy/common/dbdma.c:33:10: fatal error: linux/dma-map-ops.h: No such file or directory
   33 | #include <linux/dma-map-ops.h> /* for dma_default_coherent */
      |          ^~~~~~~~~~~~~~~~~~~~~

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/4837


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
