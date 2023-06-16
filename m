Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62751427C
	for <patches@lists.linux.dev>; Fri, 16 Jun 2023 15:01:37 +0000 (UTC)
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-6b2993c9652so685534a34.1
        for <patches@lists.linux.dev>; Fri, 16 Jun 2023 08:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686927696; x=1689519696;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OH4rIpmkTlQj1zVd/tpnXTRPRkAWVctrbRLNUrBxQLk=;
        b=pTHG6+yHehe+0dMBs8hYzxcGi9TMf96HLVOrjYSXaxJTAzZMN3nB1I9KrpkIzHQIW8
         hTdWWtbFywiY4YCXTnp6W3/6Vzw6yJlsCNLk7xNvHkEn7P9YYYByVCRtvi20Tif6X3wN
         SZe7LRLK4BWxEx0WLq252TyaC37nRYgn+uoGy20/FxSB0SNHXTGFD7Gw4tJYiAHqv8ym
         li0Klguo/FgcBFFd2xj9jPUUqD/GPTvfVfp1UHxn01raybpXXxC82gMJ4a8Q58rggkut
         /3ecAdMze/55Lsv7NDcWIUAMljYsAv7zS5Ykr8CsKZPgy+2BNy+Dw+R7r3tl9Fo/TyPs
         m0+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686927696; x=1689519696;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OH4rIpmkTlQj1zVd/tpnXTRPRkAWVctrbRLNUrBxQLk=;
        b=iyJd7V1kKHYmxAPGRhsLgWkXG6ER+cnkp9E5d6pf3YF2sSYuGZPEzQKgnlh0yceSA8
         WsFIi8giDuNz6LHTlWbuLOfm/FHGBMsEtiHg8DKEQAAQEpZDxpSly8e13Oa06OocZr/W
         dpjodh1+IsAXIPbaqrnARxyeija5iLHzYj7tMisssS0x6ITUCU+bMsCng1MGST8PnpVH
         tnVEsLM6m6BSIhD6Fr+M3/t0WSnAzTpOB2lH3krj1UFH+5AOSqrBQIzBDzlg+tGGbFKJ
         r0YMqyFzu00jgOZCemYiO98iUHLSldKgAohWAf08rgmMORV4MxZOK4X6nH6cRI11JK4i
         qO5Q==
X-Gm-Message-State: AC+VfDxvILnB70Qm1e2SBLNLTcF5rmjNJrI8gZUwxGMhziXfOsSku/0C
	fFJwoh63uFdvkBu6OdVgsLU=
X-Google-Smtp-Source: ACHHUZ5CZbY0+TIWlwiPELU/neFEnCMSAx7G5qnMowKHGtqEhUDVZpQPfFxLdTTuh/WOejw3V1eEmQ==
X-Received: by 2002:a05:6830:1e72:b0:6af:8e73:786b with SMTP id m18-20020a0568301e7200b006af8e73786bmr2461138otr.5.1686927696604;
        Fri, 16 Jun 2023 08:01:36 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id u11-20020a9d4d8b000000b006af78565d64sm7890159otk.46.2023.06.16.08.01.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jun 2023 08:01:36 -0700 (PDT)
Message-ID: <181163f9-49fb-f75f-38bd-92766d1a2982@gmail.com>
Date: Fri, 16 Jun 2023 11:10:49 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v2 07/11] kbuild: rust_is_available: fix confusion when a
 version appears in the path
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
 linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 Jordan Isaacs <mail@jdisaacs.com>, "Ethan D . Twardy"
 <ethan.twardy@gmail.com>, Tiago Lam <tiagolam@gmail.com>
References: <20230616001631.463536-1-ojeda@kernel.org>
 <20230616001631.463536-8-ojeda@kernel.org>
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <20230616001631.463536-8-ojeda@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/15/23 21:16, Miguel Ojeda wrote:
> `bindgen`'s output for `libclang`'s version check contains paths, which
> in turn may contain strings that look like version numbers [1][2]:
> 
>      .../6.1.0-dev/.../rust_is_available_bindgen_libclang.h:2:9: warning: clang version 11.1.0  [-W#pragma-messages], err: false
> 
> which the script will pick up as the version instead of the latter.
> 
> It is also the case that versions may appear after the actual version
> (e.g. distribution's version text), which was the reason behind `head` [3]:
> 
>      .../rust-is-available-bindgen-libclang.h:2:9: warning: clang version 13.0.0 (Fedora 13.0.0-3.fc35) [-W#pragma-messages], err: false
> 
> Thus instead ask for a match after the `clang version` string.
> 
> Reported-by: Jordan Isaacs <mail@jdisaacs.com>
> Closes: https://github.com/Rust-for-Linux/linux/issues/942 [1]
> Reported-by: Ethan D. Twardy <ethan.twardy@gmail.com>
> Closes: https://lore.kernel.org/rust-for-linux/20230528131802.6390-2-ethan.twardy@gmail.com/ [2]
> Reported-by: Tiago Lam <tiagolam@gmail.com>
> Closes: https://github.com/Rust-for-Linux/linux/pull/789 [3]
> Fixes: 78521f3399ab ("scripts: add `rust_is_available.sh`")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
> [...]

Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
