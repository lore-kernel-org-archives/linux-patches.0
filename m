Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D411A947F
	for <patches@lists.linux.dev>; Sat, 17 Jun 2023 15:33:55 +0000 (UTC)
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-6b45e465d4fso611279a34.3
        for <patches@lists.linux.dev>; Sat, 17 Jun 2023 08:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687016035; x=1689608035;
        h=in-reply-to:references:message-id:to:from:subject:cc:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eIrXu2yfb9Pam+bpdsMdAx2WWEzIapMDlsAs1QsbBws=;
        b=RBZwfxwyvUmlx7gfaQja0EIyLztHe3BBUZtCltHvzg1JOEml2iTtCdo/pr3V/Dnua9
         qGM2FmKPCVsX2/2Fjbs60I8YYyMvq7C5o4kKo+/q3YpC3GveuIiQeGTD/FMg6w+RKqFV
         0ebDTbFibZEMMgur9SAVFAvLlQ26gZaWVfFMPHY9BW8SA+G8spyrFul4hiZpMBAzVI65
         o1FXpATjrIN6T0ClfgpDB5AO4pZ8kZSoKTTvazBlFmmtG5JLQs02am/UbfWrr/jFgAt5
         kTGr2pRP76Z2JCS31DazLoSsJK+EpcNhxhSSSY4v5EssrtM6dvZx6LYGOIgGCYLwF1qE
         RAaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687016035; x=1689608035;
        h=in-reply-to:references:message-id:to:from:subject:cc:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=eIrXu2yfb9Pam+bpdsMdAx2WWEzIapMDlsAs1QsbBws=;
        b=fK8w7P7fTCItf3GJJwIMPmnpwr8qBpFjI90CyNyYKgzJFl8A907G3chz9xFMxZ+84i
         pnOhFQXFfJ7CmjJR9spi6ZHB4sv0t0CAPOxIfDMBPsUFcpcb6duGQhv7vS3RPFMhefM9
         4iAXkLlHRupdROABqdorP2IY0r98eCz2BF2LEzxyp+VoWrpKZamXJ5j8VUppuUz9d1ij
         8VQpfYTDoZFDP6Tp+TpR0VNFRcztVm44HvSI6Vw0/XqhvJuUYUchlPlY8u54C2mB9QsV
         rEbm5KHXvf9FepQqHkwoaqUFJ4v4oNP6AOXwMeDhvW3g7yMh+z9G0kPRVW6rKREAAsJG
         gpMw==
X-Gm-Message-State: AC+VfDxQA65dbWQZg3zgea0ypTPSqTiP2UeIXH4nCujMfnVMLz4/Bl0h
	VVGphpmWAPegCeVDE9wkqDo=
X-Google-Smtp-Source: ACHHUZ4cTukZlbOT2Rzej4qrlx/YeNZFj5PqAaaj504WWtITW+WCdZ/wmMf5sdoXCfsGaSEUg7HjFw==
X-Received: by 2002:a05:6830:43:b0:6ac:86bf:f621 with SMTP id d3-20020a056830004300b006ac86bff621mr2754731otp.7.1687016034741;
        Sat, 17 Jun 2023 08:33:54 -0700 (PDT)
Received: from localhost ([2600:1700:f3b0:64c0::35])
        by smtp.gmail.com with ESMTPSA id k1-20020a056830168100b006addf2a4110sm8614459otr.55.2023.06.17.08.33.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Jun 2023 08:33:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 17 Jun 2023 10:33:51 -0500
Cc: "Nathan Chancellor" <nathan@kernel.org>, "Nick Desaulniers"
 <ndesaulniers@google.com>, "Nicolas Schier" <nicolas@fjasle.eu>, "Boqun
 Feng" <boqun.feng@gmail.com>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, "Benno Lossin"
 <benno.lossin@proton.me>, "Alice Ryhl" <aliceryhl@google.com>, "Andreas
 Hindborg" <nmi@metaspace.dk>, <linux-kbuild@vger.kernel.org>,
 <rust-for-linux@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <patches@lists.linux.dev>, "Jordan Isaacs" <mail@jdisaacs.com>, "Tiago Lam"
 <tiagolam@gmail.com>
Subject: Re: [PATCH v2 07/11] kbuild: rust_is_available: fix confusion when
 a version appears in the path
From: "Ethan D. Twardy" <ethan.twardy@gmail.com>
To: "Miguel Ojeda" <ojeda@kernel.org>, "Masahiro Yamada"
 <masahiroy@kernel.org>, "Wedson Almeida Filho" <wedsonaf@gmail.com>, "Alex
 Gaynor" <alex.gaynor@gmail.com>
Message-Id: <CTF19P8FLNUZ.3OA1ANA7IUG87@hackbook>
X-Mailer: aerc 9999
References: <20230616001631.463536-1-ojeda@kernel.org>
 <20230616001631.463536-8-ojeda@kernel.org>
In-Reply-To: <20230616001631.463536-8-ojeda@kernel.org>

On Thu Jun 15, 2023 at 7:16 PM CDT, Miguel Ojeda wrote:
> ---
>  scripts/rust_is_available.sh | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/scripts/rust_is_available.sh b/scripts/rust_is_available.sh
> index 7e0368babe64..810691af66eb 100755
> --- a/scripts/rust_is_available.sh
> +++ b/scripts/rust_is_available.sh
> @@ -157,9 +157,7 @@ fi
>  # of the `libclang` found by the Rust bindings generator is suitable.
>  bindgen_libclang_version=3D$( \
>  	echo "$bindgen_libclang_output" \
> -		| grep -F 'clang version ' \
> -		| grep -oE '[0-9]+\.[0-9]+\.[0-9]+' \
> -		| head -n 1 \
> +		| sed -nE 's:.*clang version ([0-9]+\.[0-9]+\.[0-9]+).*:\1:p'
>  )
>  bindgen_libclang_min_version=3D$($min_tool_version llvm)
>  bindgen_libclang_cversion=3D$(get_canonical_version $bindgen_libclang_ve=
rsion)

Reviewed-By: Ethan Twardy <ethan.twardy@gmail.com>
Tested-By: Ethan Twardy <ethan.twardy@gmail.com>
