Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C42D3D62
	for <patches@lists.linux.dev>; Fri, 16 Jun 2023 15:01:00 +0000 (UTC)
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-6b28fc460bcso712581a34.1
        for <patches@lists.linux.dev>; Fri, 16 Jun 2023 08:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686927659; x=1689519659;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=U88tdfNVtbOWIg3yElvA/Pd2Mu59Yv00Wm7QJm0BpI8=;
        b=fd5NRQbNwFNBZqgRfAPNhSSQmAIH7Ulzp8MDABOLBQVW/DgYgvvnt8iMUCdskAyThj
         GC91fisA9oVh+fgns77IccmhuuUAleNPaLb7LNcVEIOz24SPbvQHkpI1SUy594WJYk3P
         Pzq14p9EnJ3X1DZ687E5I7bqyLxJZZT0v1TF0ErYBfonNLDg0N52LWnuvtNdMS5oVLkP
         g2EA+71X/jrnvP+zXWa/5z/geiDPpcff3Fsg/fDorb7fKWeqeMR+mX480MlthDfcm5LY
         SaFPO+HZXL3YkkVtBNLvAvlucGBgTJ5QMxDW7NncDhg/9KyRo+4wCNibIKqQ4Nls7M3B
         mIQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686927659; x=1689519659;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U88tdfNVtbOWIg3yElvA/Pd2Mu59Yv00Wm7QJm0BpI8=;
        b=VNSDBQa/Niuaz0TNnE6NjMaUwE0yvuwwDRnSefpGf521GB+pOjMOqLg7rQ6LXaAiQN
         DsobKRaxcACmmSpMcl8xyzsaSlsbLVdM0kvJXEWG3joV/Mrm+7Ur12t8OyuV45N8iZsn
         u1OPolOgIHSKLASRjzvT5ySJ8c0yV620BHxJm7Pg+ic5Kt9/yIbey2vvlwkcOMvZSOer
         10GKu2/edyI5EXvcaMVpSzpXxXf4col77xWdPlx4U/mSoMX+MTUq8JkhREuT2b24nFah
         X3GUx123n5nu7za+o9E0+gHynqt84ijJLS5XrnMr9W8cwG898aqJsO7P6AACFnYlggxS
         mvcw==
X-Gm-Message-State: AC+VfDy6diS+IZOf18N0QGeTPHV4wy0JXECA7S3pB3dNuc3CH/36GigX
	hqPMNXVf/jxzhrNzGanW758=
X-Google-Smtp-Source: ACHHUZ5i1jxlM5V4dv7IaIvZxykSltp2sgkfuVN1xlsYiSMEkPChpddWDIxxXP3Mcw8OLigetRoidw==
X-Received: by 2002:a9d:62d3:0:b0:6b2:ac44:bf88 with SMTP id z19-20020a9d62d3000000b006b2ac44bf88mr2737134otk.10.1686927659363;
        Fri, 16 Jun 2023 08:00:59 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id s10-20020a05683004ca00b006add66c7d73sm7126937otd.27.2023.06.16.08.00.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jun 2023 08:00:58 -0700 (PDT)
Message-ID: <ff363ce7-059e-6021-687b-794c532647de@gmail.com>
Date: Fri, 16 Jun 2023 10:58:27 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v2 02/11] kbuild: rust_is_available: fix version check
 when CC has multiple arguments
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
 Russell Currey <ruscur@russell.cc>
References: <20230616001631.463536-1-ojeda@kernel.org>
 <20230616001631.463536-3-ojeda@kernel.org>
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <20230616001631.463536-3-ojeda@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/15/23 21:16, Miguel Ojeda wrote:
> From: Russell Currey <ruscur@russell.cc>
> 
> rust_is_available.sh uses cc-version.sh to identify which C compiler is
> in use, as scripts/Kconfig.include does.  cc-version.sh isn't designed to
> be able to handle multiple arguments in one variable, i.e. "ccache clang".
> Its invocation in rust_is_available.sh quotes "$CC", which makes
> $1 == "ccache clang" instead of the intended $1 == ccache & $2 == clang.
> 
> cc-version.sh could also be changed to handle having "ccache clang" as one
> argument, but it only has the one consumer upstream, making it simpler to
> fix the caller here.
> 
> Signed-off-by: Russell Currey <ruscur@russell.cc>
> Fixes: 78521f3399ab ("scripts: add `rust_is_available.sh`")
> Link: https://github.com/Rust-for-Linux/linux/pull/873
> [ Reworded title prefix and reflow line to 75 columns. ]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
> [...]

Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
