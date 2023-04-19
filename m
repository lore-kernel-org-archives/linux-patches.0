Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C030317D4
	for <patches@lists.linux.dev>; Wed, 19 Apr 2023 03:04:18 +0000 (UTC)
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-38dfa504415so940735b6e.0
        for <patches@lists.linux.dev>; Tue, 18 Apr 2023 20:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681873458; x=1684465458;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BZz6i90ANSJNgGgyhyyDzRsyGMboVoftdzyUn+nlq38=;
        b=f1Ju3t7tMOnR01DfyqMznkIKJVQ0iTwOqES2zUGkyyOdIsYbY1wU/rNCN76G6sh8cj
         XUdolT6KDcC1fL+mM+f55MW1PTfIWVHP0asirXp0i//JnmMiicUMNgQ4EtCxVRXus5t3
         kBwiCIyBMXpEvao3Gg2qztOANNJ0hvPW0oOTXbDVTz6AACvap3SCaEitTVmmnimRA7Ep
         iqkFwe6DfReOwdV+ctY5rW5C3Jw3pwBTahptLcwcibjGf1KhP7M6SXnqV8U5Xxd6JU6K
         ZtX7lsgLv1haHU9tT0HDQJ9cqB2wZfcDHJF0+ZhMcbCk14UsdaWvguqKwTj8tOeCmYxd
         68ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681873458; x=1684465458;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BZz6i90ANSJNgGgyhyyDzRsyGMboVoftdzyUn+nlq38=;
        b=CPrbwGbrh5uBLPbpn+qZGRmLR3ijjEEPIkob2p795+arM6IZi2JzlNYCTXfg9ED7lA
         dwld026Y4mU8xGaSBihFjr7Do9GFKKqu0eXYdidjJ89M6wANvwe1unDf7XkauTN/td+l
         ppqlbFV/VjT6+eVtP/ALYse+OY8Kausc/TXPaxgHaEzf2sp9KOBNsAbVVENU9dEE5ip6
         C4Om4fCokWD6BAmDiR+VqsxdT/8Yq/G/Bxpu/HF1Dz/GWX4QAop2/UBjWc/TFElapeY3
         UGr/DcpJhpozwvPVtAG4biqYASjqPfjJ5N4mnBI59NmMGxENO4RWxZszNRdDd29DE4Ir
         ObtQ==
X-Gm-Message-State: AAQBX9eprAKKOSfqkvUWymLcgArm1R6evSEFjlZAcLqjh7bO7CKNBnQ0
	kRqxyJBU2xXCTq5DqS1PW4U=
X-Google-Smtp-Source: AKy350YIz34xLTEyr0mRlCYOMVaBn45XWhTy9z47u+61z8vbKc8AvNm/axZZabVX4nZ/QjP+YZgneA==
X-Received: by 2002:a54:4386:0:b0:38b:e6:3d95 with SMTP id u6-20020a544386000000b0038b00e63d95mr2002371oiv.40.1681873457848;
        Tue, 18 Apr 2023 20:04:17 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id bo34-20020a05680822a200b0038e29fb9ac9sm1533969oib.44.2023.04.18.20.04.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 20:04:17 -0700 (PDT)
Message-ID: <1a52e123-3cda-83cb-64ee-580b306badb7@gmail.com>
Date: Tue, 18 Apr 2023 23:51:52 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 2/3] rust: arc: fix intra-doc link in `Arc<T>::init`
Content-Language: en-US
To: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho
 <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=c3=b6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>, Josh Stone <jistone@redhat.com>,
 William Brown <william.brown@suse.com>,
 Georgy Yakovlev <gyakovlev@gentoo.org>,
 Jan Alexander Steffens <jan.steffens@gmail.com>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
References: <20230418214347.324156-1-ojeda@kernel.org>
 <20230418214347.324156-3-ojeda@kernel.org>
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <20230418214347.324156-3-ojeda@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/18/23 18:43, Miguel Ojeda wrote:
> `Arc<T>::init` refers to `Arc<T>::pin_init` via an intra-doc link
> using the text `pin_init`, rather than more explicitly, which makes
> `rustdoc` point it to the `pin_init!` macro instead.
> 
> This is required for the compiler upgrade since the newer `rustdoc`
> would trigger the `broken_intra_doc_links` lint [1], but in this case
> the macro was not the intended target to begin with, and so the actual
> fix is to make it point to the right place, regardless of the upgrade.
> 
> Thus make it more explicit.
> 
> Fixes: 92c4a1e7e81c ("rust: init/sync: add `InPlaceInit` trait to pin-initialize smart pointers")
> Link: https://github.com/rust-lang/rust/issues/106142 [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>  rust/kernel/sync/arc.rs | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/rust/kernel/sync/arc.rs b/rust/kernel/sync/arc.rs
> index e6d206242465..1b0734fdf6a7 100644
> --- a/rust/kernel/sync/arc.rs
> +++ b/rust/kernel/sync/arc.rs
> @@ -185,7 +185,7 @@ impl<T> Arc<T> {
>  
>      /// Use the given initializer to in-place initialize a `T`.
>      ///
> -    /// This is equivalent to [`pin_init`], since an [`Arc`] is always pinned.
> +    /// This is equivalent to [`Arc<T>::pin_init`], since an [`Arc`] is always pinned.
>      #[inline]
>      pub fn init<E>(init: impl Init<T, E>) -> error::Result<Self>
>      where

Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
