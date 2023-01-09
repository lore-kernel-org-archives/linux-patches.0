Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F83923A3
	for <patches@lists.linux.dev>; Mon,  9 Jan 2023 22:47:56 +0000 (UTC)
Received: by mail-qv1-f46.google.com with SMTP id y8so7339705qvn.11
        for <patches@lists.linux.dev>; Mon, 09 Jan 2023 14:47:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LBwIrKNrBQ58CABRdm1FZ9+3BG53F5GnC8guZO8JvlQ=;
        b=WQP4dc5frgXFaI/DBFdNh2617YgOfnTShhCAbw5rAQZbV3AG/+s2HwF16HGQN37uxd
         p12hUvVWmifC0WZeQb5RpPCakTKShBcKnQEcHoKiX2YTrvv4XnnhVyFw8fN2fsxl2dGN
         u8ZHWYcm94rY5dH2nSwK6Tv6kmDCGtDDcUVuaaJFXSXsdY41Eeh4LNLxLR46hqva+Z+C
         ASSyh58IWToFyJSSurzVwqTv5TN/dZvnhefT2zmS4EM7wH7BKZgpI0OyJpbfcGm6Y2xO
         Jrm9MyhKAZuEQchI6ifaBoAUQBiQqwP+yWepzkdwUNFaHFOQOi0NbBMNldjTrY+5OUfG
         LMLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LBwIrKNrBQ58CABRdm1FZ9+3BG53F5GnC8guZO8JvlQ=;
        b=c70m6i4nxopgfyXVpO64ybmkUnamqmYWy3llkl60qSaq0Ooe0ifHtgSPUEUZDzypty
         BSD5av4tBMxHSNylfSt2Cdl1CvY2GgAgPrnXdkpIMQ3o5gNmKKA2xBB++jBRSwmyVORe
         MXahR00DwdGvbN4qQPT9gAy/K5ufRmggFRuyfpbYu2oft3rJHqfhWmmTFtAzZsX4L0De
         3wy5w5dji/VRQ0124eFUU4i2R2zzRauxmI3/SQ5dda7E4AiZp/2pUSh5iql3UXMp6cFT
         BwLVW6zvcUHuvMqj0F/xqyvsbG52KVyYoWMvDqgaM0gI9z0yCVId74fvEkdUA5ELuQVz
         CW9Q==
X-Gm-Message-State: AFqh2kpl+LIzSScVti9mU7jOWut4OCcOk2431spREgCbLcCg+lW4xQ3N
	GgoZ/BcItCE3nVIXShTU4Q0=
X-Google-Smtp-Source: AMrXdXv5Yifg7zs5JxtyY5Tk4iaopCPF7iKUQA9wWFiAHciED+QyS45qe4y8wLc9Qq73dQTF3PQxFQ==
X-Received: by 2002:a05:6214:b09:b0:51e:d2cd:dd7a with SMTP id u9-20020a0562140b0900b0051ed2cddd7amr88701477qvj.16.1673304475334;
        Mon, 09 Jan 2023 14:47:55 -0800 (PST)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id u15-20020a05620a454f00b006ce76811a07sm6197713qkp.75.2023.01.09.14.47.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 14:47:54 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
	by mailauth.nyi.internal (Postfix) with ESMTP id 08F9527C0054;
	Mon,  9 Jan 2023 17:47:53 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 09 Jan 2023 17:47:54 -0500
X-ME-Sender: <xms:mZm8Y4gVbetbXCNenWSSSDDs04hf6yE1u4ijKJL5Af8cstLeCVn-qg>
    <xme:mZm8YxB3IFA2-vlI0b_FD1yOPMLJlmocEfFls_e8iwTiwN-mSGN_CUBnWcmlCv6eB
    WC3h6r9IUzglKs-DA>
X-ME-Received: <xmr:mZm8YwFq6-Ly294Q_c1_GANpnEei4xhNmHrO7fz5yQoTwgBOitUgZjFIMuY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrkeejgddtvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeeuohhquhhn
    ucfhvghnghcuoegsohhquhhnrdhfvghnghesghhmrghilhdrtghomheqnecuggftrfgrth
    htvghrnhepffeljeelheevleetleetudfghfehvdekgfdvheefieffiefhiefgvddtuefh
    tdetnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghdpghhithhhuhgsrdgtohhmnecuve
    hluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsghoqhhunhdo
    mhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqieelvdeghedtieegqddujeejke
    ehheehvddqsghoqhhunhdrfhgvnhhgpeepghhmrghilhdrtghomhesfhhigihmvgdrnhgr
    mhgv
X-ME-Proxy: <xmx:mZm8Y5R0SPt_3FlmYkendUj3E08TU5HQ3v8Vj4DB8xyFL5zfJI6IsA>
    <xmx:mZm8Y1xfSiOPiiaKUUPcbE1fprR5UJfMPfT4Moqb3V1ZjpTqKayyYA>
    <xmx:mZm8Y37eDQoa5q0sSe5LUP6GWXnQE3GqBhJYpzELJqdUMdc_SGaUNg>
    <xmx:mZm8Y1gGeu0EatDYTykRXEIU4O4tDV0Etk3IdWbgXK0s8PQ6PRLLmg>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 9 Jan 2023 17:47:53 -0500 (EST)
Date: Mon, 9 Jan 2023 14:46:36 -0800
From: Boqun Feng <boqun.feng@gmail.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, linux-kbuild@vger.kernel.org,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Nicolas Schier <nicolas@fjasle.eu>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	Alexandru Radovici <msg4alex@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>
Subject: Re: [PATCH 3/6] kbuild: rust_is_available: add check for `bindgen`
 invocation
Message-ID: <Y7yZTBIF58+1Fj5m@boqun-archlinux>
References: <20230109204520.539080-1-ojeda@kernel.org>
 <20230109204520.539080-3-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230109204520.539080-3-ojeda@kernel.org>

On Mon, Jan 09, 2023 at 09:45:17PM +0100, Miguel Ojeda wrote:
> `scripts/rust_is_available.sh` calls `bindgen` with a special
> header in order to check whether the `libclang` version in use
> is suitable.
> 
> However, the invocation itself may fail if, for instance, `bindgen`
> cannot locate `libclang`. This is fine for Kconfig (since the
> script will still fail and therefore disable Rust as it should),
> but it is pretty confusing for users of the `rustavailable` target
> given the error will be unrelated:
> 
>     ./scripts/rust_is_available.sh: 21: arithmetic expression: expecting primary: "100000 *  + 100 *  + "
>     make: *** [Makefile:1816: rustavailable] Error 2
> 
> Instead, run the `bindgen` invocation independently in a previous
> step, saving its output and return code. If it fails, then show
> the user a proper error message. Otherwise, continue as usual
> with the saved output.
> 
> Since the previous patch we show a reference to the docs, and
> the docs now explain how `bindgen` looks for `libclang`,
> thus the error message can leverage the documentation, avoiding
> duplication here (and making users aware of the setup guide in
> the documentation).
> 
> Reported-by: Nick Desaulniers <ndesaulniers@google.com>
> Reported-by: fvalenduc (@fvalenduc)

Per Documentation/process/maintainer-tip.rst, the "Reported-by" tag does
require "Name <mailaddress>" format. Given we already have the GitHub
issue link, I wonder whether it's better we ask for the reporter's
email address (and real name) for the "Reported-by" field, and if they
prefer to not providing one, we just don't use the "Reported-by" tag
since we still have the GitHub issue link for their contribution.

Thoughts?

Regards,
Boqun

> Reported-by: Alexandru Radovici <msg4alex@gmail.com>
> Link: https://lore.kernel.org/rust-for-linux/CAKwvOdm5JT4wbdQQYuW+RT07rCi6whGBM2iUAyg8A1CmLXG6Nw@mail.gmail.com/
> Link: https://github.com/Rust-for-Linux/linux/issues/934
> Link: https://github.com/Rust-for-Linux/linux/pull/921
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>  scripts/rust_is_available.sh | 23 ++++++++++++++++++++++-
>  1 file changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/scripts/rust_is_available.sh b/scripts/rust_is_available.sh
> index c907cf881c2c..cd87729ca3bf 100755
> --- a/scripts/rust_is_available.sh
> +++ b/scripts/rust_is_available.sh
> @@ -108,8 +108,29 @@ if [ "$rust_bindings_generator_cversion" -gt "$rust_bindings_generator_min_cvers
>  fi
>  
>  # Check that the `libclang` used by the Rust bindings generator is suitable.
> +#
> +# In order to do that, first invoke `bindgen` to get the `libclang` version
> +# found by `bindgen`. This step may already fail if, for instance, `libclang`
> +# is not found, thus inform the user in such a case.
> +set +e
> +bindgen_libclang_output=$(LC_ALL=C "$BINDGEN" $(dirname $0)/rust_is_available_bindgen_libclang.h 2>&1 >/dev/null)
> +bindgen_libclang_code=$?
> +set -e
> +if [ $bindgen_libclang_code -ne 0 ]; then
> +	echo >&2 "***"
> +	echo >&2 "*** Running '$BINDGEN' to check the libclang version (used by the Rust"
> +	echo >&2 "*** bindings generator) failed with code $bindgen_libclang_code. This may be caused by"
> +	echo >&2 "*** a failure to locate libclang. See output and docs below for details:"
> +	echo >&2 "***"
> +	echo >&2 "$bindgen_libclang_output"
> +	echo >&2 "***"
> +	exit 1
> +fi
> +
> +# `bindgen` returned successfully, thus use the output to check that the version
> +# of the `libclang` found by the Rust bindings generator is suitable.
>  bindgen_libclang_version=$( \
> -	LC_ALL=C "$BINDGEN" $(dirname $0)/rust_is_available_bindgen_libclang.h 2>&1 >/dev/null \
> +	echo "$bindgen_libclang_output" \
>  		| grep -F 'clang version ' \
>  		| grep -oE '[0-9]+\.[0-9]+\.[0-9]+' \
>  		| head -n 1 \
> -- 
> 2.39.0
> 
