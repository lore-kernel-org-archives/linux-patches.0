Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF75171D3
	for <patches@lists.linux.dev>; Fri, 16 Jun 2023 15:01:07 +0000 (UTC)
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-39a3f165ac5so670495b6e.3
        for <patches@lists.linux.dev>; Fri, 16 Jun 2023 08:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686927666; x=1689519666;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aQBQg8OJ1UpfkeRTq/gJupGVgO7j6NLxmO6HZvrEVGw=;
        b=niqXxyx9qWp8kGundlpHNdA2v+eaZgN7tlhzLoYTfWzYkjgc9Vwg8LEVSjolfkAUEM
         jdrRHttQJyq8ugkx0LAYo1JHc8b9Nw+yseEHrqbkiKPJo8HbGcU/yrhaf1oYDo2o1Gyb
         +zEgqe6L94epQndjvu3AhT7WvtQvoeDP9Ijz5OOV5HSa0htd/grbEhZD5LQV7aj9/mqk
         fDoQlDl2kGfp5wcoR7x7ZVH9wdhhGiNvVd+6Gx8p4iv3ThNdcXfCkMZskYy+fiDmxQp+
         /gYJqej1MGP03q0+0lPUuy+D0Cqx4EM2mRjCbiylXaXCX84NQoMxIZlI/oITDlCbC9ZA
         yjJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686927666; x=1689519666;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aQBQg8OJ1UpfkeRTq/gJupGVgO7j6NLxmO6HZvrEVGw=;
        b=bKxRuBmSdy5tkonI8fezC8i96ZZpFfPEEcY/bt7ZMGg/fGcPC+hbabTcloCUCyAbnJ
         KkmsOvLcjVgu5H3i6neEoUJNGAvR0zF1VEuWwfr4UPvqdbz9EntnMFtpD1YsYMhkUNv6
         MnWvlLsV4Gsm2qw0hZ4GhO+A4J6DjVrajQP3OUKG8RSRw+RMqlbCpNxD1S7xc5vDQL8+
         CWryFfMUUMFRetmzYD635Kg9BfKFKRlkI+bkUFZCj82RP+vBddxrngUeXcD5GJgJ/N6N
         mI+crXVRx4n9hxbdRUIBs5uottDFxua4BQGUgIwRDO1dbJa6w14vWizgWpAmZQbMxi0E
         6zpA==
X-Gm-Message-State: AC+VfDwaKbgdlX7u1FGTOq7vZyN+2uwAsIzJOdmQxQSPUfjizv97PanF
	WmPBso4EBZW7o1jxOGz9QJQ=
X-Google-Smtp-Source: ACHHUZ6q71Qwdads9516QkoF/PU3flnagm4LfFfVYLH/yE2zqzRHTYjIcJFGLsv6Tel261eGyWVeuQ==
X-Received: by 2002:a05:6808:2907:b0:396:3969:a4a6 with SMTP id ev7-20020a056808290700b003963969a4a6mr2504687oib.18.1686927666357;
        Fri, 16 Jun 2023 08:01:06 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id k8-20020a544408000000b00399dff24197sm7925282oiw.5.2023.06.16.08.01.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jun 2023 08:01:05 -0700 (PDT)
Message-ID: <f94cc2ce-156d-0d8b-16c9-0512ea4fcee2@gmail.com>
Date: Fri, 16 Jun 2023 11:00:10 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v2 03/11] docs: rust: add paragraph about finding a
 suitable `libclang`
Content-Language: en-US
To: Miguel Ojeda <ojeda@kernel.org>, Masahiro Yamada <masahiroy@kernel.org>,
 Wedson Almeida Filho <wedsonaf@gmail.com>,
 Alex Gaynor <alex.gaynor@gmail.com>
Cc: Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <ndesaulniers@google.com>,
 Nicolas Schier <nicolas@fjasle.eu>, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=c3=b6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>,
 Alice Ryhl <aliceryhl@google.com>, Andreas Hindborg <nmi@metaspace.dk>,
 linux-kbuild@vger.kernel.org, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20230616001631.463536-1-ojeda@kernel.org>
 <20230616001631.463536-4-ojeda@kernel.org>
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <20230616001631.463536-4-ojeda@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/15/23 21:16, Miguel Ojeda wrote:
> Sometimes users need to tweak the finding process of `libclang`
> for `bindgen` via the `clang-sys`-provided environment variables.
> 
> Thus add a paragraph to the setting up guide, including a reference
> to `clang-sys`'s relevant documentation.
> 
> Link: https://lore.kernel.org/rust-for-linux/CAKwvOdm5JT4wbdQQYuW+RT07rCi6whGBM2iUAyg8A1CmLXG6Nw@mail.gmail.com/
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
> [...]

Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
