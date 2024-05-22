Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949001422DA;
	Wed, 22 May 2024 17:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716399458; cv=none; b=UO0wIHGMfJKEJOHvTO+Hxo05usNcP/QBmTsptilY7dioO3n1ZkzGa1xQP5laNQuVIhwtVrzT0iyXGlE4Zwj+qh0x84Kz424MMZO0weGhfATmqb97QBQgIdK3YV8rtQC9k2Bxbo/XIDMBYzdo0g8JxcnRAJgTLxfezUnCHNhOIGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716399458; c=relaxed/simple;
	bh=INBHA3bI3vCMfeir9qL60G3mFBmSUpGFnM+cd8pQn40=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=As/bUqEJ4EGIFXHEON2ruW9nn9QGFIFj2xJy3YwWDkP4jpzJ+zrPdUohJusCpkjT3/tXge13tXVuhhVAAsFFC2INu8uEtGl3jL+cCo/ybLI/jCehG2dJzK5TE9NOCiWoSqLuHbLPWJWOUfLZ/h0GW2o/KxWfd17Oq2qTpjDrRDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nowz4AjP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nowz4AjP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD3CC32789;
	Wed, 22 May 2024 17:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716399458;
	bh=INBHA3bI3vCMfeir9qL60G3mFBmSUpGFnM+cd8pQn40=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=nowz4AjPKh4J5uHYZtL39AXtz5n0MY0sDDKRbujY0MdlSYYSP5EICeq5e3mVe9RJf
	 k3dTGzjg4KTi7wwzzWN5+2tM040hWgKrC5TTU9XjkKtplFeiZx1e05mSJyezUcVh9Q
	 veTQ0YMTgFstByO+yP+YCoAfQY5HELCJFIWuTl+t72T6qLgQug+LLty4sQfmfaBU/j
	 rNAfFjZ3vzLcEsM3gtdrOV2yMk+lqRW3f/aSO5lxsBRxHQRgNiETrvbgEVvP1vBGlv
	 IFiZvEf+ZMFlAXNxz3zEoTs/LihelfxuYpGaju0es2XMkJBkJw5wp/uG7oSDioV/MD
	 zeSvrYU2eIGxg==
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2e576057c56so62330021fa.3;
        Wed, 22 May 2024 10:37:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCX8IJbZq81qhirtJE2IP0cmis6hXiTPYXsgAEekVVOG2FiFsotXFFHXhaHQ8GLx74d2Yg/e5atan+ceZCQJVBGN1E5U8Sk4ot4XdCQhhNe2DIwXuBOAKvaldjGx2qevvOM6W3Y/JbgKKwyE1uVrsF382GohKGwJq9U=
X-Gm-Message-State: AOJu0YzGOkmlorBNLocbkDnzELZ8KoVpTrPRNEFDk5ZFw0kdnU4JsjBq
	7Lq3Fv+VmZ13nrTclQfeGmoSOQ41Po6VzoNiQU37otGdnY5DZeryWSh6/SWDowOw9S0ZhFwoPO1
	+ZTahyHalcQgBWzPWTTSpiqYn/qQ=
X-Google-Smtp-Source: AGHT+IEWRiF1CdpdViUGf00ZGZBrVc0BULdw9lD78Wn2v4SoT9QgUivX5gdbLStUJcs+nFqN5irhqOJSiw0oo0/4Ygc=
X-Received: by 2002:a2e:a312:0:b0:2e9:5011:f6ca with SMTP id
 38308e7fff4ca-2e95011f72fmr4024551fa.33.1716399456541; Wed, 22 May 2024
 10:37:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240522-efi-zboot-lds-add-discard-sections-to-discard-v1-1-6b415efa0f85@kernel.org>
In-Reply-To: <20240522-efi-zboot-lds-add-discard-sections-to-discard-v1-1-6b415efa0f85@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Wed, 22 May 2024 19:37:25 +0200
X-Gmail-Original-Message-ID: <CAMj1kXG-Ck3y1STD9GeS6gyqUgOL6ch3jjCtdZjN_w+LScOzpw@mail.gmail.com>
Message-ID: <CAMj1kXG-Ck3y1STD9GeS6gyqUgOL6ch3jjCtdZjN_w+LScOzpw@mail.gmail.com>
Subject: Re: [PATCH] efi/libstub: zboot.lds: Discard .discard sections
To: Nathan Chancellor <nathan@kernel.org>
Cc: Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
	Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, linux-efi@vger.kernel.org, 
	loongarch@lists.linux.dev, llvm@lists.linux.dev, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Wed, 22 May 2024 at 19:32, Nathan Chancellor <nathan@kernel.org> wrote:
>
> When building ARCH=loongarch defconfig + CONFIG_UNWINDER_ORC=y using
> LLVM, there is a warning from ld.lld when linking the EFI zboot image
> due to the use of unreachable() in number() in vsprintf.c:
>
>   ld.lld: warning: drivers/firmware/efi/libstub/lib.a(vsprintf.stub.o):(.discard.unreachable+0x0): has non-ABS relocation R_LARCH_32_PCREL against symbol ''
>
> If the compiler cannot eliminate the default case for any reason, the
> .discard.unreachable section will remain in the final binary but the
> entire point of any section prefixed with .discard is that it is only
> used at compile time, so it can be discarded via /DISCARD/ in a linker
> script. The asm-generic vmlinux.lds.h includes .discard and .discard.*
> in the COMMON_DISCARDS macro but that is not used for zboot.lds, as it
> is not a kernel image linker script.
>
> Add .discard and .discard.* to /DISCARD/ in zboot.lds, so that any
> sections meant to be discarded at link time are not included in the
> final zboot image. This issue is not specific to LoongArch, it is just
> the first architecture to select CONFIG_OBJTOOL, which defines
> annotate_unreachable() as an asm statement to add the
> .discard.unreachable section, and use the EFI stub.
>
> Closes: https://github.com/ClangBuiltLinux/linux/issues/2023
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Thanks, I'll take this as a fix.


> ---
>  drivers/firmware/efi/libstub/zboot.lds | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/firmware/efi/libstub/zboot.lds b/drivers/firmware/efi/libstub/zboot.lds
> index ac8c0ef85158..af2c82f7bd90 100644
> --- a/drivers/firmware/efi/libstub/zboot.lds
> +++ b/drivers/firmware/efi/libstub/zboot.lds
> @@ -41,6 +41,7 @@ SECTIONS
>         }
>
>         /DISCARD/ : {
> +               *(.discard .discard.*)
>                 *(.modinfo .init.modinfo)
>         }
>  }
>
> ---
> base-commit: 15aa8fb852f995dd234a57f12dfb989044968bb6
> change-id: 20240522-efi-zboot-lds-add-discard-sections-to-discard-5fe29bf42d6a
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>
