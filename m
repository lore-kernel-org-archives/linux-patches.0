Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B03CAD49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 15:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678202847;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d7tFpiKXqynWtvnyoZW3Uouf3NrvbrWsNMhlga+8JZ4=;
	b=PSRRrtxjPD6HwS+/CpbrKVKvBR/0sA/WDHXm07Y7XLmdLGQa8RSEgmT/f3xMu5+0NKeOj9
	tSEu68I3VL3qUqiZn+xOwu5DYr7oy7mACyIKTyKqm9qVdLYmwtByK9Odm3OF2yN7Zy8Dbq
	bttXDz16xJlzWjh4JBoILE16IfWSpho=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-41-RHAzF4sxMYmEv8OIRpiGHw-1; Tue, 07 Mar 2023 10:27:12 -0500
X-MC-Unique: RHAzF4sxMYmEv8OIRpiGHw-1
Received: by mail-qk1-f200.google.com with SMTP id x5-20020a05620a01e500b007428997e800so7587867qkn.10
        for <patches@lists.linux.dev>; Tue, 07 Mar 2023 07:27:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678202825;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d7tFpiKXqynWtvnyoZW3Uouf3NrvbrWsNMhlga+8JZ4=;
        b=mvwxImM1RaGdUM7pKZeBTVVOnqUarOXVFCs3n6JskTqlkVtQf8IgP9b6BiJOHXCiW9
         z9xoY3tlJsgFNi1bvHoTrKgk4Zyhv52BwdZOpwInMdtW5rE7RpVwzcMuoeiJ/Yv19wig
         IboiKMrsbmckV4Emiwr2ZqNIvaihcC1A8q42VUEFI6QWccPA0or8quSwtcyLZQe9mm0w
         hUwROE27/tGASw2rTMTkevIgxwV3cnpxC7+FPYopYLkJOv7FjMrtm0WxBflRwgsJ0crj
         uvCXLq4EZrDGRf7Kt6Gm3MOs1LF0dZvELBWQ6N0H9KWi6Y0oPSXt5oTK5n60oawRphWG
         0u2g==
X-Gm-Message-State: AO0yUKUKgrBYdquV+85xXjEg73o4OI4nUrFB2HKqkzXnYtwn0sM0Ds/G
	fFBZsnrdaD+CcxwPKdRFGs8h9pE2PiakkZM+Y8qPqqw6rmk3Uwqr9Vra/xJd67S01wZQC2gBmNF
	tzCtgY1nADddhYGpp+HEOt/ld8heB6Dpi88xQd2/8faLC4P66/LivPP70503OlYzSSbMx1QY0
X-Received: by 2002:a05:622a:134b:b0:3b6:3260:fa1d with SMTP id w11-20020a05622a134b00b003b63260fa1dmr24994804qtk.45.1678202824865;
        Tue, 07 Mar 2023 07:27:04 -0800 (PST)
X-Google-Smtp-Source: AK7set9E77kRVz6L/w5+ZV6JnWce7W5sJvJS0bvPmMpm2NcunH+obLSA1UxzvjjWrf8oYrOuYT2pSA==
X-Received: by 2002:a05:622a:134b:b0:3b6:3260:fa1d with SMTP id w11-20020a05622a134b00b003b63260fa1dmr24994738qtk.45.1678202824456;
        Tue, 07 Mar 2023 07:27:04 -0800 (PST)
Received: from [192.168.1.19] (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id v25-20020ac87499000000b003bfc0cca1b7sm9718293qtq.49.2023.03.07.07.27.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Mar 2023 07:27:03 -0800 (PST)
Subject: Re: [PATCH bpf-next] bpf: Increase size of BTF_ID_LIST without
 CONFIG_DEBUG_INFO_BTF again
To: Nathan Chancellor <nathan@kernel.org>, ast@kernel.org,
 daniel@iogearbox.net, andrii@kernel.org
Cc: martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
 john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
 haoluo@google.com, jolsa@kernel.org, ndesaulniers@google.com,
 bpf@vger.kernel.org, linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
 patches@lists.linux.dev
References: <20230307-bpf-kfuncs-warray-bounds-v1-1-00ad3191f3a6@kernel.org>
From: Tom Rix <trix@redhat.com>
Message-ID: <58eb6412-9d32-1175-94fa-af620ab80f4e@redhat.com>
Date: Tue, 7 Mar 2023 07:26:59 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20230307-bpf-kfuncs-warray-bounds-v1-1-00ad3191f3a6@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US


On 3/7/23 7:14 AM, Nathan Chancellor wrote:
> After commit 66e3a13e7c2c ("bpf: Add bpf_dynptr_slice and
> bpf_dynptr_slice_rdwr"), clang builds without CONFIG_DEBUG_INFO_BTF
> warn:
>
>    kernel/bpf/verifier.c:10298:24: warning: array index 16 is past the end of the array (that has type 'u32[16]' (aka 'unsigned int[16]')) [-Warray-bounds]
>                                       meta.func_id == special_kfunc_list[KF_bpf_dynptr_slice_rdwr]) {
>                                                       ^                  ~~~~~~~~~~~~~~~~~~~~~~~~
>    kernel/bpf/verifier.c:9150:1: note: array 'special_kfunc_list' declared here
>    BTF_ID_LIST(special_kfunc_list)
>    ^
>    include/linux/btf_ids.h:207:27: note: expanded from macro 'BTF_ID_LIST'
>    #define BTF_ID_LIST(name) static u32 __maybe_unused name[16];
>                              ^
>    1 warning generated.
>
> A warning of this nature was previously addressed by
> commit beb3d47d1d3d ("bpf: Fix a BTF_ID_LIST bug with
> CONFIG_DEBUG_INFO_BTF not set") but there have been new kfuncs added
> since then.
>
> Quadruple the size of the CONFIG_DEBUG_INFO_BTF=n definition so that
> this problem is unlikely to show up for some time.
>
> Link: https://github.com/ClangBuiltLinux/linux/issues/1810
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

This has a better commit message, let's use this one.

FWIW, gcc 13 -Warray-bounds, did not catch this.

Reviewed-by: Tom Rix <trix@redhat.com>

> ---
>   include/linux/btf_ids.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/linux/btf_ids.h b/include/linux/btf_ids.h
> index 3a4f7cd882ca..00950cc03bff 100644
> --- a/include/linux/btf_ids.h
> +++ b/include/linux/btf_ids.h
> @@ -204,7 +204,7 @@ extern struct btf_id_set8 name;
>   
>   #else
>   
> -#define BTF_ID_LIST(name) static u32 __maybe_unused name[16];
> +#define BTF_ID_LIST(name) static u32 __maybe_unused name[64];
>   #define BTF_ID(prefix, name)
>   #define BTF_ID_FLAGS(prefix, name, ...)
>   #define BTF_ID_UNUSED
>
> ---
> base-commit: 36e5e391a25af28dc1f4586f95d577b38ff4ed72
> change-id: 20230307-bpf-kfuncs-warray-bounds-c2040e8ee7ee
>
> Best regards,

