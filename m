Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 995343D62
	for <patches@lists.linux.dev>; Fri, 16 Jun 2023 15:00:52 +0000 (UTC)
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-1a98a7fde3fso861047fac.3
        for <patches@lists.linux.dev>; Fri, 16 Jun 2023 08:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686927651; x=1689519651;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gbcAX6a1eicu6d3jk33i1zAfmDcjTd2pa8lrf0SUGvQ=;
        b=oAot7/Zp5mILgXcqyrtRgc6bTBbIhbsoKJj73kFHgJuD4WrzbiBkBme2A6CQZsaNtT
         rVcwh87oTEq+kXIpqLgMQ2MbuWIEAY3DcSuYM28gcKaIj7JX5K3c1Km9HZvHCY/qw4dW
         jk3Xl4iYIhAm/typevshEm9jvZOBddkT3JYk1qAqxhUjfiWLSCJLoeytOl74B8Po3Zpt
         1xSt+NXAJPiE2qHtHWwwibfvK26ffcFPpOi5b+YU3SzJV+FD8oM3zd0738qFeO8U/OEf
         rNB8kTD73ZQQR5EI3ubXI9cbisd8Ukl+xoiwOX3V4r8rfMx4Mlqtw7U9mxC2DSMBCSQj
         ItUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686927651; x=1689519651;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gbcAX6a1eicu6d3jk33i1zAfmDcjTd2pa8lrf0SUGvQ=;
        b=P4tnoStdnalo6tYSm3JsY7OzQzacg7TAB6Um6wVzWQAV1FYG2pnE2JXVBXPFiVI3TL
         xQO5cIf33ZwcStSuFZkGMqOTfWl8pL9xhlbu2JJoFxrDgSyZj7rr7m7dvjx74xqnz0FZ
         wLuf/FJEbvRF9UDSc5IH8lEZGap+ou6nh30mbLt9GItNI63wr9dzst5tHKu9YjRT5aQW
         WbEKi25cPipH7st5ILBBLMbM2sCJsZ8Ug8o4HTk7bv54Pwg6kpZpfWJfU9y9zRwOqm/n
         UgllSEbQfMpJv8m/mFbMiGYewqa59jcm8AxTPOR17Z7NJCyc9uIR7f3QOcPI4TXkA4i0
         JS9A==
X-Gm-Message-State: AC+VfDwLBrBCktoqRGkfjyB6Escay8JouypoYVIdVoRvEZvUfirgKJg5
	AvvHtT2/WEpLFtaX6hsSSOo=
X-Google-Smtp-Source: ACHHUZ466j1P5f7zSgTKQ27WFq3EVgQ+S7RfZBJhvqWaa4/+rm+bKYxB4YpejS+9SlXqCVx5d0hrtQ==
X-Received: by 2002:a05:6870:5b28:b0:1a6:4eb9:d10b with SMTP id ds40-20020a0568705b2800b001a64eb9d10bmr2147868oab.16.1686927651338;
        Fri, 16 Jun 2023 08:00:51 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id ve17-20020a0568710c1100b001a6a3f99691sm6211975oab.27.2023.06.16.08.00.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jun 2023 08:00:50 -0700 (PDT)
Message-ID: <022fc9e1-692f-754c-061a-0e4e7c380731@gmail.com>
Date: Fri, 16 Jun 2023 10:56:21 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v2 01/11] kbuild: rust_is_available: remove -v option
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
 <20230616001631.463536-2-ojeda@kernel.org>
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <20230616001631.463536-2-ojeda@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/15/23 21:16, Miguel Ojeda wrote:
> From: Masahiro Yamada <masahiroy@kernel.org>
> 
> The -v option is passed when this script is invoked from Makefile,
> but not when invoked from Kconfig.
> 
> As you can see in scripts/Kconfig.include, the 'success' macro suppresses
> stdout and stderr anyway, so this script does not need to be quiet.
> 
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> Reviewed-by: Miguel Ojeda <ojeda@kernel.org>
> Tested-by: Miguel Ojeda <ojeda@kernel.org>
> Reviewed-by: Nathan Chancellor <nathan@kernel.org>
> Link: https://lore.kernel.org/r/20230109061436.3146442-1-masahiroy@kernel.org
> [ Reworded prefix to match the others in the patch series. ]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
> 

Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
