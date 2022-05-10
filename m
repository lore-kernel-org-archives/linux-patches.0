Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B2621FC4
	for <patches@lists.linux.dev>; Tue, 10 May 2022 06:41:07 +0000 (UTC)
Received: by mail-pg1-f176.google.com with SMTP id 202so13869676pgc.9
        for <patches@lists.linux.dev>; Mon, 09 May 2022 23:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/R+BdsTsM0mS0BJ099mIwAuGA4DmGK3MfyL1tsHDy88=;
        b=nR1unFNNL1Eu03i3ou8IfrgVFIKZGS6y8ycxMlqK7mWPArORl3ugMcJOdXGJBGNpS9
         xwcx7T+TagvrwtOKBZDuE++qmcknw4S+oyv28BiIYLs6wCJDubWGyGxAc/BMGN4deE0l
         3ZZEu7GhKyQtk5WhYIFkaPkJ3YcJxj6zz9fQJnvSFWQyTc2HnYuII/tkqc1bBHPFuX0d
         /xNpON7BvlHLKgljUZ+f5PTXeaGHDf84HNUmp+FcK3XI1F5u8lm3B5Boky+dNAMQugja
         aINmQH7M3Wuu37O1ZL3U9KxSVrYCx3C9dgoX3XOkCVMQeIVmDRMSfYSqCUJpPtF4p8eV
         DTCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/R+BdsTsM0mS0BJ099mIwAuGA4DmGK3MfyL1tsHDy88=;
        b=pj8khNVrrfbtx8R3b9otWwuMLkq2fV+AV6nOpANrreN/6ggF/ymLTRwvIL604Epbov
         IPPkUO+h9yHArZctph9QL5R3CuAgTh1MJvmVRAhjMkyg8slmk8DyDitFTitvrWqsoDZb
         1Ra2T9lDKSNezFW6LSIfoUGaGtmIRRzo6lyS0hCABcemKeifu9yoE/TbTy6n+kFCY59f
         xWVvy9PA4lQuim57UzVQba0nqbeEX9iGu8d2HwH/5BlyJxjLszGX2kdEC4c4ZBpS0STV
         98hG5pHVvkfseGcyb5yWaw7/0ScmSf/DorNcrCGUmpivFo6KaeBPxQsxDWbx+N3Coe/M
         4ERQ==
X-Gm-Message-State: AOAM533Q1phXYx4qkvwwBm9oU2kGTrEn7fKw0b3uL72bRdzZniSqF6Bp
	5BRum9Ee4HgtHtIf62Y93L4ICPhLErr7mw==
X-Google-Smtp-Source: ABdhPJwMh3hdgkArGl0lsMSGCf/c/FWcT/W63T69K0ggo5K+yprCQbawWGx2A2ypR1pBvqgzRy5v/Q==
X-Received: by 2002:a63:da13:0:b0:3c6:4c0:e2f9 with SMTP id c19-20020a63da13000000b003c604c0e2f9mr15718593pgh.493.1652164866540;
        Mon, 09 May 2022 23:41:06 -0700 (PDT)
Received: from google.com ([2620:15c:2ce:200:9543:36e:1e36:a909])
        by smtp.gmail.com with ESMTPSA id g12-20020a17090a4b0c00b001cd498dc153sm1602382pjh.3.2022.05.09.23.41.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 23:41:06 -0700 (PDT)
Date: Mon, 9 May 2022 23:41:02 -0700
From: Fangrui Song <maskray@google.com>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: Nathan Chancellor <nathan@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Paul Mackerras <paulus@samba.org>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>, linuxppc-dev@lists.ozlabs.org,
	llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH 1/2] powerpc/vdso: Remove unused ENTRY in linker scripts
Message-ID: <20220510064102.pvk3dvqnpihgo3bd@google.com>
References: <20220509204635.2539549-1-nathan@kernel.org>
 <20220509204635.2539549-2-nathan@kernel.org>
 <ea0096e5-e1cb-a25d-e5b1-1774c0614397@ozlabs.ru>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ea0096e5-e1cb-a25d-e5b1-1774c0614397@ozlabs.ru>

On 2022-05-10, Alexey Kardashevskiy wrote:
>
>
>On 5/10/22 06:46, Nathan Chancellor wrote:
>>When linking vdso{32,64}.so.dbg with ld.lld, there is a warning about
>>not finding _start for the starting address:
>>
>>   ld.lld: warning: cannot find entry symbol _start; not setting start address
>>   ld.lld: warning: cannot find entry symbol _start; not setting start address
>>
>>Looking at GCC + GNU ld, the entry point address is 0x0:
>>
>>   $ llvm-readelf -h vdso{32,64}.so.dbg &| rg "(File|Entry point address):"
>>   File: vdso32.so.dbg
>>     Entry point address:               0x0
>>   File: vdso64.so.dbg
>>     Entry point address:               0x0
>>
>>This matches what ld.lld emits:
>>
>>   $ powerpc64le-linux-gnu-readelf -p .comment vdso{32,64}.so.dbg
>>
>>   File: vdso32.so.dbg
>>
>>   String dump of section '.comment':
>>     [     0]  Linker: LLD 14.0.0
>>     [    14]  clang version 14.0.0 (Fedora 14.0.0-1.fc37)
>>
>>   File: vdso64.so.dbg
>>
>>   String dump of section '.comment':
>>     [     0]  Linker: LLD 14.0.0
>>     [    14]  clang version 14.0.0 (Fedora 14.0.0-1.fc37)
>>
>>   $ llvm-readelf -h vdso{32,64}.so.dbg &| rg "(File|Entry point address):"
>>   File: vdso32.so.dbg
>>     Entry point address:               0x0
>>   File: vdso64.so.dbg
>>     Entry point address:               0x0
>>
>>Remove ENTRY to remove the warning, as it is unnecessary for the vDSO to
>>function correctly.

LGTM. e_entry for the vDSO (generally all shared objects, unless invoked
directly as the main executable) is unnecessary.

>Sounds more like a bugfix to me - _start is simply not defined, I 
>wonder why ld is not complaining.

This is a loose behavior in GNU ld. I know this but did not bother
filing a feature request.

Now that you mentioned it:) https://sourceware.org/bugzilla/show_bug.cgi?id=29136 (ld: ENTRY(no_such_symbol) in -shared mode does not report a warning)

>
>Tested-by: Alexey Kardashevskiy <aik@ozlabs.ru>
>Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>
>
>
>>
>>Signed-off-by: Nathan Chancellor <nathan@kernel.org>
>>---
>>  arch/powerpc/kernel/vdso/vdso32.lds.S | 1 -
>>  arch/powerpc/kernel/vdso/vdso64.lds.S | 1 -
>>  2 files changed, 2 deletions(-)
>>
>>diff --git a/arch/powerpc/kernel/vdso/vdso32.lds.S b/arch/powerpc/kernel/vdso/vdso32.lds.S
>>index 58e0099f70f4..e0d19d74455f 100644
>>--- a/arch/powerpc/kernel/vdso/vdso32.lds.S
>>+++ b/arch/powerpc/kernel/vdso/vdso32.lds.S
>>@@ -13,7 +13,6 @@ OUTPUT_FORMAT("elf32-powerpcle", "elf32-powerpcle", "elf32-powerpcle")
>>  OUTPUT_FORMAT("elf32-powerpc", "elf32-powerpc", "elf32-powerpc")
>>  #endif
>>  OUTPUT_ARCH(powerpc:common)
>>-ENTRY(_start)
>>  SECTIONS
>>  {
>>diff --git a/arch/powerpc/kernel/vdso/vdso64.lds.S b/arch/powerpc/kernel/vdso/vdso64.lds.S
>>index 0288cad428b0..1a4a7bc4c815 100644
>>--- a/arch/powerpc/kernel/vdso/vdso64.lds.S
>>+++ b/arch/powerpc/kernel/vdso/vdso64.lds.S
>>@@ -13,7 +13,6 @@ OUTPUT_FORMAT("elf64-powerpcle", "elf64-powerpcle", "elf64-powerpcle")
>>  OUTPUT_FORMAT("elf64-powerpc", "elf64-powerpc", "elf64-powerpc")
>>  #endif
>>  OUTPUT_ARCH(powerpc:common64)
>>-ENTRY(_start)
>>  SECTIONS
>>  {
>
