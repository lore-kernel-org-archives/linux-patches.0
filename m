Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F147F;
	Sun, 16 Oct 2022 18:23:02 +0000 (UTC)
Received: by mail-ot1-f51.google.com with SMTP id r8-20020a056830120800b00661a0a236efso4660727otp.4;
        Sun, 16 Oct 2022 11:23:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:reply-to:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wW7XFUIrfwAYj9V0BgTRJZPYfpuX+5gjcsBRlqmRR3c=;
        b=JU3t4HRNM+9S9D0rHT+rK3o8ST81UnTQgBfh8fVYH3zJRD9lc2nScx9TUwfInn/Y8i
         rnwHf6LF7QiRhuKpEdiq2XMqHTQzkvUVNdQKsje4bUd1cvetdei5A8y8Avo9o3m6I9Je
         BVYCV8JMV62C1iAIhA0KspdlrHtyJW7XZwfkKCsnnY7KVg5AZKfBKd1ihwpDc/bCa7Nv
         wujlkxtEdHTXvFTIpi66WVhuwukKYgdonQuNuDsbwxcL5MYZVrbsBH78EOpx/mdO2lhS
         PWZFiuBx25QPV+ICluSljA3OV1Rbk9qkr43mjUusVk64uX6LlDq0As0Hoz6yguuboBfm
         TJ3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:reply-to:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wW7XFUIrfwAYj9V0BgTRJZPYfpuX+5gjcsBRlqmRR3c=;
        b=oZ34oLmygml/U6bbi6wONOBNmf6uN4XqgEQNnOEWF7ln4IBDDQiD/ORJ9U1AbC/qZk
         HtZ54AK7V5HjAgZTnvTCnDBkSyd7aEdFJAXSPzTpY6+aVKNs3spC/DUCExWgUz89sxAE
         UGN5IQV/1w+R90WQs7rtNgvJA0DpAWEu8SuahR2B9er/VRGkiOk92nwrprfTNYanJVUr
         xIxwaJo5ikjjPu3k/9mdQXiWvp5Nx5q94Ui+IqYQ1f49P+ZLZHp2QGXn/eEo9Ip03O+k
         EgMLi2iRenll3d1irgp2RQlf1DTBKXfqCKF0mH9oaP8JNxmkO8WwvSZ+n5rsu1u/fAf8
         N/kQ==
X-Gm-Message-State: ACrzQf2/fToC7RnwYLNqxQArYJP8ZxYukfqnphX3fNIbOQKYTsURqTcJ
	tAjgwM0fb8RwhbW76ORtbemxyxbXlMZ0NiRCVEg=
X-Google-Smtp-Source: AMsMyM4nQJlVhF5jmHJN1j7Nm7J+AvU6gMopIMylRr6DV6jrnlnjX8VOMlWRdql4oP0xaM689bT/msJw+xzE7e0xOuk=
X-Received: by 2002:a05:6830:141:b0:661:acd7:de with SMTP id
 j1-20020a056830014100b00661acd700demr3651892otp.367.1665944581210; Sun, 16
 Oct 2022 11:23:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221014204210.383380-1-nathan@kernel.org> <CAKwvOdmvqoO1220ac7RVbVzvmbJB0wYq5WOfuz=T8hd+CkijBg@mail.gmail.com>
 <CAK7LNAQvpSFUiX9=92UnoZpJs=uzaZqpGG-r1dyeWsRXpS5fmw@mail.gmail.com>
 <CA+icZUWfB1pxTFc2VX4_J2dqZZkZ=raC=EVKuPDP0EdBy777OQ@mail.gmail.com> <Y0xLdOM0TAbcJHop@spud>
In-Reply-To: <Y0xLdOM0TAbcJHop@spud>
Reply-To: sedat.dilek@gmail.com
From: Sedat Dilek <sedat.dilek@gmail.com>
Date: Sun, 16 Oct 2022 20:22:24 +0200
Message-ID: <CA+icZUWj52mQcQeSqCiD_DXrrj9YCLYfdNqvDpPMAF3s_6TMcw@mail.gmail.com>
Subject: Re: [PATCH v2] lib/Kconfig.debug: Add check for non-constant
 .{s,u}leb128 support to DWARF5
To: Conor Dooley <conor@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Nathan Chancellor <nathan@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Tom Rix <trix@redhat.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, linux-kbuild@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Sun, Oct 16, 2022 at 8:20 PM Conor Dooley <conor@kernel.org> wrote:
>
> On Sun, Oct 16, 2022 at 08:10:30PM +0200, Sedat Dilek wrote:
> > On Sun, Oct 16, 2022 at 8:04 PM Masahiro Yamada <masahiroy@kernel.org> wrote:
> > >
> > > On Sat, Oct 15, 2022 at 6:52 AM Nick Desaulniers
> > > <ndesaulniers@google.com> wrote:
> > > >
> > > > On Fri, Oct 14, 2022 at 1:48 PM Nathan Chancellor <nathan@kernel.org> wrote:
> > > > >
> > > > > When building with a RISC-V kernel with DWARF5 debug info using clang
> > > > > and the GNU assembler, several instances of the following error appear:
> > > > >
> > > > >   /tmp/vgettimeofday-48aa35.s:2963: Error: non-constant .uleb128 is not supported
> > > > >
> > > > > Dumping the .s file reveals these .uleb128 directives come from
> > > > > .debug_loc and .debug_ranges:
> > > > >
> > > > >   .Ldebug_loc0:
> > > > >           .byte   4                               # DW_LLE_offset_pair
> > > > >           .uleb128 .Lfunc_begin0-.Lfunc_begin0    #   starting offset
> > > > >           .uleb128 .Ltmp1-.Lfunc_begin0           #   ending offset
> > > > >           .byte   1                               # Loc expr size
> > > > >           .byte   90                              # DW_OP_reg10
> > > > >           .byte   0                               # DW_LLE_end_of_list
> > > > >
> > > > >   .Ldebug_ranges0:
> > > > >           .byte   4                               # DW_RLE_offset_pair
> > > > >           .uleb128 .Ltmp6-.Lfunc_begin0           #   starting offset
> > > > >           .uleb128 .Ltmp27-.Lfunc_begin0          #   ending offset
> > > > >           .byte   4                               # DW_RLE_offset_pair
> > > > >           .uleb128 .Ltmp28-.Lfunc_begin0          #   starting offset
> > > > >           .uleb128 .Ltmp30-.Lfunc_begin0          #   ending offset
> > > > >           .byte   0                               # DW_RLE_end_of_list
> > > > >
> > > > > There is an outstanding binutils issue to support a non-constant operand
> > > > > to .sleb128 and .uleb128 in GAS for RISC-V but there does not appear to
> > > > > be any movement on it, due to concerns over how it would work with
> > > > > linker relaxation.
> > > > >
> > > > > To avoid these build errors, prevent DWARF5 from being selected when
> > > > > using clang and an assembler that does not have support for these symbol
> > > > > deltas, which can be easily checked in Kconfig with as-instr plus the
> > > > > small test program from the dwz test suite from the binutils issue.
> > > > >
> > > > > Link: https://sourceware.org/bugzilla/show_bug.cgi?id=27215
> > > > > Link: https://github.com/ClangBuiltLinux/linux/issues/1719
> > > > > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > > >
> > > > Thanks for keeping these LLVM_IAS=0 builds alive a little longer.  My
> > > > hope is the GNU binutils can relax their requirement for debug info
> > > > sections to improve support for DWARF v5.
> > > >
> > > > Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> > >
> > >
> > > Applied to linux-kbuild.
> > > Thanks.
> > >
> >
> > [1] says:
> >
> > "This looks good to me! Feel free to submit with a:
> > Tested-by: Conor Dooley <conor.dooley@microchip.com>"
>
> Hey Sedat,
>
> I actually didn't take a proper look at the v2 at all... I didn't realise
> that Nathan dropped by T-b for v2 since he'd changed the patch enough to
> feel that he should.
>
> I'm not too worried about the removed T-b (espcially since Linus has
> just merged Masahiro's PR containing this change).
>
> Thanks though!
> Conor.
>

Yes, just saw the update on
https://github.com/torvalds/linux/commits/master first.

-Sedat-

> >
> > -sed@-
> >
> > [1] https://github.com/ClangBuiltLinux/linux/issues/1719#issuecomment-1261158627
> >
> > >
> > >
> > > > > ---
> > > > >
> > > > > v2:
> > > > >     - Rebase on commit bb1435f3f575 ("Kconfig.debug: add toolchain
> > > > >       checks for DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT") from the kbuild
> > > > >       tree.
> > > > >     - Limit CONFIG_AS_HAS_NON_CONST_LEB128 dependency to GNU as. There
> > > > >       is no point to applying this dependency to the integrated
> > > > >       assembler because it will always pass.
> > > > >     - Apply the CONFIG_AS_HAS_NON_CONST_LEB128 dependency to
> > > > >       CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT as well, due to the
> > > > >       aforementioned kbuild change.
> > > > >     - Move comment block to above CONFIG_AS_HAS_NON_CONST_LEB128, as the
> > > > >       configuration is now used in two places.
> > > > >     - Drop Conor's tested by, as the patch is different enough to
> > > > >       potentially require new testing.
> > > > >
> > > > > v1: https://lore.kernel.org/20220928182523.3105953-1-nathan@kernel.org/
> > > > >
> > > > >  lib/Kconfig.debug | 9 +++++++--
> > > > >  1 file changed, 7 insertions(+), 2 deletions(-)
> > > > >
> > > > > diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> > > > > index db8d9271cabf..5c1c63575895 100644
> > > > > --- a/lib/Kconfig.debug
> > > > > +++ b/lib/Kconfig.debug
> > > > > @@ -231,6 +231,11 @@ config DEBUG_INFO
> > > > >           in the "Debug information" choice below, indicating that debug
> > > > >           information will be generated for build targets.
> > > > >
> > > > > +# Clang is known to generate .{s,u}leb128 with symbol deltas with DWARF5, which
> > > > > +# some targets may not support: https://sourceware.org/bugzilla/show_bug.cgi?id=27215
> > > > > +config AS_HAS_NON_CONST_LEB128
> > > > > +       def_bool $(as-instr,.uleb128 .Lexpr_end4 - .Lexpr_start3\n.Lexpr_start3:\n.Lexpr_end4:)
> > > > > +
> > > > >  choice
> > > > >         prompt "Debug information"
> > > > >         depends on DEBUG_KERNEL
> > > > > @@ -253,7 +258,7 @@ config DEBUG_INFO_NONE
> > > > >  config DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT
> > > > >         bool "Rely on the toolchain's implicit default DWARF version"
> > > > >         select DEBUG_INFO
> > > > > -       depends on !CC_IS_CLANG || AS_IS_LLVM || CLANG_VERSION < 140000 || (AS_IS_GNU && AS_VERSION >= 23502)
> > > > > +       depends on !CC_IS_CLANG || AS_IS_LLVM || CLANG_VERSION < 140000 || (AS_IS_GNU && AS_VERSION >= 23502 && AS_HAS_NON_CONST_LEB128)
> > > > >         help
> > > > >           The implicit default version of DWARF debug info produced by a
> > > > >           toolchain changes over time.
> > > > > @@ -277,7 +282,7 @@ config DEBUG_INFO_DWARF4
> > > > >  config DEBUG_INFO_DWARF5
> > > > >         bool "Generate DWARF Version 5 debuginfo"
> > > > >         select DEBUG_INFO
> > > > > -       depends on !CC_IS_CLANG || AS_IS_LLVM || (AS_IS_GNU && AS_VERSION >= 23502)
> > > > > +       depends on !CC_IS_CLANG || AS_IS_LLVM || (AS_IS_GNU && AS_VERSION >= 23502 && AS_HAS_NON_CONST_LEB128)
> > > > >         help
> > > > >           Generate DWARF v5 debug info. Requires binutils 2.35.2, gcc 5.0+ (gcc
> > > > >           5.0+ accepts the -gdwarf-5 flag but only had partial support for some
> > > > >
> > > > > base-commit: bb1435f3f575b5213eaf27434efa3971f51c01de
> > > > > --
> > > > > 2.38.0
> > > > >
> > > >
> > > >
> > > > --
> > > > Thanks,
> > > > ~Nick Desaulniers
> > >
> > >
> > >
> > > --
> > > Best Regards
> > > Masahiro Yamada
