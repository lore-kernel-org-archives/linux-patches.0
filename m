Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922CE17D4
	for <patches@lists.linux.dev>; Wed, 19 Apr 2023 03:04:12 +0000 (UTC)
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-6a5f21a231eso885203a34.1
        for <patches@lists.linux.dev>; Tue, 18 Apr 2023 20:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681873451; x=1684465451;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vqy9obDZIsKYRaRdBaeKmhCuZAq4kt0Nx5h/9mD9nOE=;
        b=A64I/55zfIX2eYL+tHsfpsyxyfgA2xV5F3MS0SNYQswNukj4eB6KIIlmgLRfpcAqU9
         pR7BuUAgrPi44s5prY4B4GzdMpWASzgt2JzlE0suzXJtxqjwesWGcQdy8oTB0BG+uGBg
         jxB8F/ss4HIxsiYf8jhyP0jbY3FL/Ovynxka2eXx5KZggmGXr77mhxUv/jMl52FRWO8P
         esSVv+kauIhzSA/V3sPnW9wABzFQHh5DhRa8x61okbcHMm89ewhC8O4COCJfONREw/CI
         I2cpqev2uPqgFeQzXmXSo6C9gBZyE6x66oXlT5fyI7TsTrRMQLd9+LxUWjJICRY7Zkoa
         dg2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681873451; x=1684465451;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vqy9obDZIsKYRaRdBaeKmhCuZAq4kt0Nx5h/9mD9nOE=;
        b=Z8QOkzqufClTwXXz16NQb/5th5wR9Teb8WxSDq1MspsmWXN7X2b5RXh1IK9E9YgpiC
         FsYghEaVSO8cYE0S5ANgqQLkuyUODZv+BPyRkrTbIT0Jux2aNkzclZeU3HQzuuu8pk/D
         PeNk7JLa2XG1ZMSkzYapDWRkOjdtTy//cuZO49wAJSyVGr4mEaFxlr1LYit+oOxExayz
         Bmta/Pu4VEv0HRaYN574qHirJm/dU7WOmgUqeo6ORuHC7ehqzpsRJXvZUPCe3HW5mliA
         6vHI0ttplWboN58v7P2uzd7VOH3l8Zhej9mcWxal+CZLPz7qAu9ThvgI4A/6zieLR3yv
         l9Rw==
X-Gm-Message-State: AAQBX9ekSEdq3HjUO96tO8GKesJW0TG4wF6X/c2O25ySkyCaLwnvdkWh
	JB6bnWpIK6PBEWbLDEG9o/k=
X-Google-Smtp-Source: AKy350YFiI0NAWpwFzIrAkC63w04jgUXNL65RJ+sEzA6dY6uIMTvDW8Is0ssPCsKpreiaWSlI48ExQ==
X-Received: by 2002:a05:6830:4da:b0:6a5:f6f6:4ebf with SMTP id s26-20020a05683004da00b006a5f6f64ebfmr2356875otd.37.1681873451795;
        Tue, 18 Apr 2023 20:04:11 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id v16-20020a05683011d000b0069457b86060sm6391395otq.47.2023.04.18.20.04.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 20:04:11 -0700 (PDT)
Message-ID: <d96b061f-737c-5f8c-0856-47faa3852074@gmail.com>
Date: Tue, 18 Apr 2023 23:51:34 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 1/3] rust: alloc: clarify what is the upstream version
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
 <20230418214347.324156-2-ojeda@kernel.org>
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <20230418214347.324156-2-ojeda@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/18/23 18:43, Miguel Ojeda wrote:
> It may be unclear for readers which upstream Rust version these files
> are based on. They may be unaware that they are intended to match the
> minimum (and only, so far) supported version of Rust in the kernel.
> 
> Thus clarify it.
> 
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>  rust/alloc/README.md | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/rust/alloc/README.md b/rust/alloc/README.md
> index c89c753720b5..eb6f22e94ebf 100644
> --- a/rust/alloc/README.md
> +++ b/rust/alloc/README.md
> @@ -10,6 +10,9 @@ upstream. In general, only additions should be performed (e.g. new
>  methods). Eventually, changes should make it into upstream so that,
>  at some point, this fork can be dropped from the kernel tree.
>  
> +The Rust upstream version on top of which these files are based matches
> +the output of `scripts/min-tool-version.sh rustc`.
> +
>  
>  ## Rationale
>  

Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
