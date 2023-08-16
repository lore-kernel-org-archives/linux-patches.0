Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4BA3D60
	for <patches@lists.linux.dev>; Wed, 16 Aug 2023 22:05:02 +0000 (UTC)
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1bde4403296so46305ad.0
        for <patches@lists.linux.dev>; Wed, 16 Aug 2023 15:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692223502; x=1692828302;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bBPTE28cAPKLWrgM2uUfeQITqXrIuPWTV58S91B8OJI=;
        b=vcF4yOPHfczBQYINY7p/sgfRsPapUuPOGiBbhWqQBEvOuthgZKjD4Qrc9YF8UQB7/q
         drD+D9rbfpd+7gugaFmaX0+38sAdlW7k8huZB13sEHUiXw/KBOboAOYQdaHK2kBRwebH
         kLAnbDdo5d5KTt2j/oPwMvE7ifJC209z/eNf7O6naxG1wOmO1rbPTIyCgQMWZVeMRRDD
         Sl6PXrPh5fGRikUQNbIRUvZfuxumaQcXPmBj40bKRPYqPKa+lUI5zwNAmgRP2P8z9OnT
         rdbZiKNvsVPkZq2IsNwU+RlLfDEZB37ClSv35srOVxcJ1u65ObX7u95ewKJJDVxnFvkZ
         UkOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692223502; x=1692828302;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bBPTE28cAPKLWrgM2uUfeQITqXrIuPWTV58S91B8OJI=;
        b=mDKvkz6GEujPBwrQ8oDEpLj1OP0alwYjjcHmUUtJxpb0+lDym2AqFtsYFnlclbwEJF
         nAL3ovKmfMufYsh5Offcf1NLneiVW4VO3P9XWUdsNKwm812siUGUdARgE2BYG16uuH69
         tMYZODOheieCAbtRefOuaFOIA5UOH0gAzAG0NSO0KtIrj0DdsDoeMTfExJTVvRgX77xG
         JhznQZYgY3vdptpU8n4KzmT1vfJzSOP5tQxI8plwl3tVa/7qA3kVeNhWjhl5D8iJqAP3
         tUo2RXNSsuGRyB+3j+oSukjL0KlYBpvOWHu3cVIe2V8EjXpa7j/OAR8iRq6htYH0qHcB
         I/Gw==
X-Gm-Message-State: AOJu0YyE9wVFtnJMlK8QfK4WWANE+LO+1tjw5ImUiheFnPlJQeuCeNWQ
	CK0WSWpw08DSbkm3V70R1n482Q==
X-Google-Smtp-Source: AGHT+IEuOUCO/H139rrEjwSPDvyEtzzmsDP4BDaEKor0UvpvxGlepYgrvvJV8S5/Zv9LowbS4wuvqg==
X-Received: by 2002:a17:902:d2c4:b0:1b8:698e:ac2f with SMTP id n4-20020a170902d2c400b001b8698eac2fmr44043plc.21.1692223501659;
        Wed, 16 Aug 2023 15:05:01 -0700 (PDT)
Received: from google.com ([2620:15c:2d3:205:abd7:243d:5e17:457d])
        by smtp.gmail.com with ESMTPSA id iw12-20020a170903044c00b001b9d7c8f44dsm13592911plb.182.2023.08.16.15.05.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Aug 2023 15:05:01 -0700 (PDT)
Date: Wed, 16 Aug 2023 15:04:57 -0700
From: Fangrui Song <maskray@google.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	akpm@linux-foundation.org, conor@kernel.org,
	ndesaulniers@google.com, trix@redhat.com,
	linux-riscv@lists.infradead.org, llvm@lists.linux.dev,
	patches@lists.linux.dev, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] lib/Kconfig.debug: Restrict DEBUG_INFO_SPLIT for RISC-V
Message-ID: <20230816220457.kqzlbiibeomvki4y@google.com>
References: <20230816-riscv-debug_info_split-v1-1-d1019d6ccc11@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230816-riscv-debug_info_split-v1-1-d1019d6ccc11@kernel.org>

On 2023-08-16, Nathan Chancellor wrote:
>When building for ARCH=riscv using LLVM < 14, there is an error with
>CONFIG_DEBUG_INFO_SPLIT=y:
>
>  error: A dwo section may not contain relocations
>
>This was worked around in LLVM 15 by disallowing '-gsplit-dwarf' with
>'-mrelax' (the default), so CONFIG_DEBUG_INFO_SPLIT is not selectable
>with newer versions of LLVM:
>
>  $ clang --target=riscv64-linux-gnu -gsplit-dwarf -c -o /dev/null -x c /dev/null
>  clang: error: -gsplit-dwarf is unsupported with RISC-V linker relaxation (-mrelax)
>
>GCC silently had a similar issue that was resolved with GCC 12.x.
>Restrict CONFIG_DEBUG_INFO_SPLIT for RISC-V when using LLVM or GCC <
>12.x to avoid these known issues.
>
>Link: https://github.com/ClangBuiltLinux/linux/issues/1914
>Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=99090
>Reported-by: kernel test robot <lkp@intel.com>
>Closes: https://lore.kernel.org/all/202308090204.9yZffBWo-lkp@intel.com/
>Signed-off-by: Nathan Chancellor <nathan@kernel.org>
>---
>Since this only impacts RISC-V, it seems reasonable that this would go
>in via their tree but I have added Andrew in case he wants to take it.
>---
> lib/Kconfig.debug | 5 +++++
> 1 file changed, 5 insertions(+)
>
>diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
>index d6798513a8c2..bd51274f4771 100644
>--- a/lib/Kconfig.debug
>+++ b/lib/Kconfig.debug
>@@ -355,6 +355,11 @@ endchoice # "Compressed Debug information"
> config DEBUG_INFO_SPLIT
> 	bool "Produce split debuginfo in .dwo files"
> 	depends on $(cc-option,-gsplit-dwarf)
>+	# RISC-V linker relaxation + -gsplit-dwarf has issues with LLVM and GCC
>+	# prior to 12.x:
>+	# https://github.com/llvm/llvm-project/issues/56642
>+	# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=99090
>+	depends on !RISCV || GCC_VERSION >= 120000
> 	help
> 	  Generate debug info into separate .dwo files. This significantly
> 	  reduces the build directory size for builds with DEBUG_INFO,
>
>---
>base-commit: 2ccdd1b13c591d306f0401d98dedc4bdcd02b421
>change-id: 20230816-riscv-debug_info_split-0713571a1ac2
>
>Best regards,
>-- 
>Nathan Chancellor <nathan@kernel.org>
>

LGTM as the author of the Clang mitigation
(https://github.com/llvm/llvm-project/issues/56642) and several recent
LLVM assembler side linker relaxation improvement (I continue updating
https://maskray.me/blog/2021-03-14-the-dark-side-of-riscv-linker-relaxation
about the complication of linker relaxation).

Reviewed-by: Fangrui Song <maskray@google.com>
