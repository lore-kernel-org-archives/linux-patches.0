Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380D46ADB
	for <patches@lists.linux.dev>; Fri,  7 Apr 2023 23:24:32 +0000 (UTC)
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-517c01edaaaso19494a12.3
        for <patches@lists.linux.dev>; Fri, 07 Apr 2023 16:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680909871; x=1683501871;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/k8Ld9z1xCEc4BHtSmCo5AXFhJJw0OpZKpMkjzbxFWI=;
        b=EAizk1c7O9PSk8Lcp5k9X8nBk8poWUZJYgJ1zQSs3cXVB4sXVf+Y1AsOx+AtDFsFAW
         2dDCeU+lW16NjIoR0dsKQDmfA2fZMyCUTowQojsK1V6H+uuZoDeYt3HZshvgoqNwsxiV
         oul25JbSjwDfzn6VUTVySwfuUNKg+iqkbVRWtj9X1mP9Hvn5MMN/DkkdQDLzuJcMsZoq
         Gg/YBtLlopy1oaBW4cdsA0gSXw38fJUu/cLsrPsV5NRkjRN3Yy9L/IOAOe0s7ZHghlpH
         SYIrj1xKNzQZGH2vcfR2x8LZ9HAhdVhUbnMZajyEeB/Bf0ujei+4U7/SvSO1dQk/Fu3y
         KTlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680909871; x=1683501871;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/k8Ld9z1xCEc4BHtSmCo5AXFhJJw0OpZKpMkjzbxFWI=;
        b=3/zUnp0grpg2vi/KdIBGpAO3iATk6X6hXzJ/E40LfPE+qcSQYyTExryVjOv9uh5qsF
         MowqY7e0iVq+bNj7ooYYJG078orsNTqaE/UFapVCkt3ai7JsAS0NsiFmC9FxYeqgx/uH
         o6v1ST4/qB3ySrtnck8LHkir6R/wJsr7Ifka70rIkbMEfZRa6zy6nl19KQPRYzuvChwc
         v8qg2Py5dwY8mHjw7223j9oYslUHD0FsxfwCKriqFc9o1he9dQeairM3w22PzTFmaEdJ
         g4JTvsuj+gBD2PO5MTSEGIdYuZcgGZ8XNu+SqH3RALHozLXjpWaaZYSOGFa479KcMtGT
         lhCA==
X-Gm-Message-State: AAQBX9dhBM3QTGF9gE+MSxPQ5Iu/l9l+Stq1HLBLfl23HhouZUZ/CVTd
	k9K0PyQpjIjHB+3j+BrJ0phaoA==
X-Google-Smtp-Source: AKy350ZVzfdilh3sQ5mgS8FjOciG5ROpRCAvfvKR/AT1puPgkgbSm11Om9eOeamlMjtON4N/OSg76Q==
X-Received: by 2002:a62:6417:0:b0:62d:b4ae:e48c with SMTP id y23-20020a626417000000b0062db4aee48cmr270792pfb.23.1680909871377;
        Fri, 07 Apr 2023 16:24:31 -0700 (PDT)
Received: from google.com ([2620:15c:2d1:203:5eb4:e720:fec7:a2d3])
        by smtp.gmail.com with ESMTPSA id p14-20020a63e64e000000b004fb8732a2f9sm3162486pgj.88.2023.04.07.16.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Apr 2023 16:24:30 -0700 (PDT)
Date: Fri, 7 Apr 2023 16:24:26 -0700
From: Nick Desaulniers <ndesaulniers@google.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: mpe@ellerman.id.au, kernel test robot <lkp@intel.com>,
	masahiroy@kernel.org, patches@lists.linux.dev, npiggin@gmail.com,
	linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] powerpc/32: Include thread_info.h in head_booke.h
Message-ID: <ZDCmKoworvEhxKCu@google.com>
References: <20230406-wundef-thread_shift_booke-v1-1-8deffa4d84f9@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230406-wundef-thread_shift_booke-v1-1-8deffa4d84f9@kernel.org>

On Thu, Apr 06, 2023 at 10:51:30AM -0700, Nathan Chancellor wrote:
> When building with W=1 after commit 80b6093b55e3 ("kbuild: add -Wundef
> to KBUILD_CPPFLAGS for W=1 builds"), the following warning occurs.
> 
>   In file included from arch/powerpc/kvm/bookehv_interrupts.S:26:
>   arch/powerpc/kvm/../kernel/head_booke.h:20:6: warning: "THREAD_SHIFT" is not defined, evaluates to 0 [-Wundef]
>      20 | #if (THREAD_SHIFT < 15)
>         |      ^~~~~~~~~~~~
> 
> THREAD_SHIFT is defined in thread_info.h but it is not directly included
> in head_booke.h, so it is possible for THREAD_SHIFT to be undefined. Add
> the include to ensure that THREAD_SHIFT is always defined.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Link: https://lore.kernel.org/202304050954.yskLdczH-lkp@intel.com/
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Thanks for the patch!
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
>  arch/powerpc/kernel/head_booke.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/powerpc/kernel/head_booke.h b/arch/powerpc/kernel/head_booke.h
> index 37d43c172676..b6b5b01a173c 100644
> --- a/arch/powerpc/kernel/head_booke.h
> +++ b/arch/powerpc/kernel/head_booke.h
> @@ -5,6 +5,7 @@
>  #include <asm/ptrace.h>	/* for STACK_FRAME_REGS_MARKER */
>  #include <asm/kvm_asm.h>
>  #include <asm/kvm_booke_hv_asm.h>
> +#include <asm/thread_info.h>	/* for THREAD_SHIFT */
>  
>  #ifdef __ASSEMBLY__
>  
> 
> ---
> base-commit: b0bbe5a2915201e3231e788d716d39dc54493b03
> change-id: 20230406-wundef-thread_shift_booke-e08d806ed656
> 
> Best regards,
> -- 
> Nathan Chancellor <nathan@kernel.org>
> 
> 
