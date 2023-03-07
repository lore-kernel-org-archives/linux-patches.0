Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D62B4AD49;
	Tue,  7 Mar 2023 15:53:19 +0000 (UTC)
Received: by mail-ed1-f45.google.com with SMTP id x3so54029367edb.10;
        Tue, 07 Mar 2023 07:53:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678204398;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FbORSBmkQrLEmoZGhwNznCeqxIz2MuR1XxIOCZR3nXQ=;
        b=LHl+IqsRYoXaT/jnjjMST41FLhNvRXYr/KW4/+7fhr8jNjCvoT1m360Cu9uXCswPLi
         Pa1CxXAhTl2ejsNLh5d+GFeJVDcFPUtpmQsAd94963HrdPhMMmfZyCSGvIj3n3hfn7YO
         Kx16FzgAvsJvmOoSi1ZuTW7o5igQXS/2914sdW4cZewKl6/mYNDaVGAhqHA5tpM9jeOQ
         LA602Td0TnhJE+yBeeIJWMBBE1/EshZN7U4kVnywQEACivmW3y2GrouU7tR84FgwUf1b
         WFi/xQJ5HHlIeI0tinlqZ+HtP/KXX5HK43GHTSs3riKxS41Xr4uUK/x61aNsdRHF9Rm1
         E1Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678204398;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FbORSBmkQrLEmoZGhwNznCeqxIz2MuR1XxIOCZR3nXQ=;
        b=Dn4bdu1wtP93BqXtMAjr+lfPu+ZQQqLsESI5wZ9fXqEU62cyAacvecjYX6Yki0Jiiu
         AhIMaHZ3Hb5RN3Ly/R14EM9VbupvaBLtXg0aFkkvriKo1Oq3RfgWMSIs8PqiAjYiBHRr
         CQwEZhpRdBR6t2FweFfX1ac7BeHUsDXMf50el3xFsWz/HPUH6B+HphRKKjhTIPazq/66
         tdvjUuqKUjitZnsg5b2k1IXWrgZGamMLl8lz19Rb6WmaHzi22+KM3d+XouUHbADT01p5
         t4AmaMqeXPbT83EbLpNrxjC87FR6L2nmzt35WR0J5DfIFfvJFraqY4NARYpHNLqHr75j
         E50w==
X-Gm-Message-State: AO0yUKWv8pC21VCCkMq1wNJRVpS2d2GYufYbvjXFXWB5KDq1gADy3QdD
	gtKKi+BmxnkfPUSqGA5zNA3X2Wqtg6s2uWpKpKI=
X-Google-Smtp-Source: AK7set99z92G0FN+SKgWFgDLiv0SyLbzEnnFyaKA6fumwU4j834OdcY2abcOQ2uUeaELFijo76SjrETugT6WReZO6cg=
X-Received: by 2002:a17:906:5910:b0:8b1:78b8:4207 with SMTP id
 h16-20020a170906591000b008b178b84207mr7407686ejq.3.1678204398010; Tue, 07 Mar
 2023 07:53:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230307-bpf-kfuncs-warray-bounds-v1-1-00ad3191f3a6@kernel.org>
In-Reply-To: <20230307-bpf-kfuncs-warray-bounds-v1-1-00ad3191f3a6@kernel.org>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Tue, 7 Mar 2023 07:53:06 -0800
Message-ID: <CAADnVQ+UOoDXYKyrw0FoSajeVOXO+2LAFv9Ouu5VPtMeF6vVuA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: Increase size of BTF_ID_LIST without
 CONFIG_DEBUG_INFO_BTF again
To: Nathan Chancellor <nathan@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, 
	Stanislav Fomichev <sdf@google.com>, Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Tom Rix <trix@redhat.com>, bpf <bpf@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>, clang-built-linux <llvm@lists.linux.dev>, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 7, 2023 at 7:14=E2=80=AFAM Nathan Chancellor <nathan@kernel.org=
> wrote:
>
> After commit 66e3a13e7c2c ("bpf: Add bpf_dynptr_slice and
> bpf_dynptr_slice_rdwr"), clang builds without CONFIG_DEBUG_INFO_BTF

please don't break commit subj into multiple lines.
I've fixed it manually this time while applying.

> warn:
>
>   kernel/bpf/verifier.c:10298:24: warning: array index 16 is past the end=
 of the array (that has type 'u32[16]' (aka 'unsigned int[16]')) [-Warray-b=
ounds]
>                                      meta.func_id =3D=3D special_kfunc_li=
st[KF_bpf_dynptr_slice_rdwr]) {
>                                                      ^                  ~=
~~~~~~~~~~~~~~~~~~~~~~~
>   kernel/bpf/verifier.c:9150:1: note: array 'special_kfunc_list' declared=
 here
>   BTF_ID_LIST(special_kfunc_list)
>   ^
>   include/linux/btf_ids.h:207:27: note: expanded from macro 'BTF_ID_LIST'
>   #define BTF_ID_LIST(name) static u32 __maybe_unused name[16];
>                             ^
>   1 warning generated.
>
> A warning of this nature was previously addressed by
> commit beb3d47d1d3d ("bpf: Fix a BTF_ID_LIST bug with
> CONFIG_DEBUG_INFO_BTF not set") but there have been new kfuncs added

and here.

> since then.
>
> Quadruple the size of the CONFIG_DEBUG_INFO_BTF=3Dn definition so that
> this problem is unlikely to show up for some time.
>
> Link: https://github.com/ClangBuiltLinux/linux/issues/1810
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  include/linux/btf_ids.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/linux/btf_ids.h b/include/linux/btf_ids.h
> index 3a4f7cd882ca..00950cc03bff 100644
> --- a/include/linux/btf_ids.h
> +++ b/include/linux/btf_ids.h
> @@ -204,7 +204,7 @@ extern struct btf_id_set8 name;
>
>  #else
>
> -#define BTF_ID_LIST(name) static u32 __maybe_unused name[16];
> +#define BTF_ID_LIST(name) static u32 __maybe_unused name[64];
>  #define BTF_ID(prefix, name)
>  #define BTF_ID_FLAGS(prefix, name, ...)
>  #define BTF_ID_UNUSED
>
> ---
> base-commit: 36e5e391a25af28dc1f4586f95d577b38ff4ed72
> change-id: 20230307-bpf-kfuncs-warray-bounds-c2040e8ee7ee
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>
