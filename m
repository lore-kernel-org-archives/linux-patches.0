Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70FC71427C
	for <patches@lists.linux.dev>; Fri, 16 Jun 2023 15:01:44 +0000 (UTC)
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-55e1a9ff9d4so67036eaf.1
        for <patches@lists.linux.dev>; Fri, 16 Jun 2023 08:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686927703; x=1689519703;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vnS17URyKoXX82bjyvptn2/y/no/LqSPUxwsdFAi0+o=;
        b=UNgcpZ4I2DbFEtaOiJW5oc++TWDq0TFw4eTp2I1NlBs8kbKAjvinMsrW6s41n2edia
         NT9dn7D6bqZ2YGOKk9hGxRsrbJtX6TX0/uV1ZdsBIqvN0EHuDsjy243CfNwQpuWL3gYS
         90onoMzuWss0ta6AEjXmryFyiL14KpE4CgC/cVc6nz72IPZh3Ewo+Lqs9GCK+YuU1Efb
         BqpkiZMAVOw/QFSsvgGnJYNOlZ5IJkezHpJRGxu4SwMEm93v9RlEFubQmidjx878f2mU
         nyhL0TjZU8L9Kqq/ONM1eQniEBLAqURMkJ9+gJi0TGLc9XfxSJsKHWHfqY/xFHlpsIww
         Uz2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686927703; x=1689519703;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vnS17URyKoXX82bjyvptn2/y/no/LqSPUxwsdFAi0+o=;
        b=cvrt8h4NzAy/HM6z2sk2pHRa/U50Yurks7FbHKK4zNn2Rfr4CkON67jsZ8sVJ1MuD/
         sOc2G+u+lVuNnDPtGQ+kV/pOETjv49OtEmOnFyWkLNXszj6LHPHDxsx/0Z1FY0wElHaY
         /hqVNjZz5PveqwDnDEIV8Mqibmluqn7jtu+CUTquTKecjkbe8ulc0O6sr869f0sTKXHC
         12/3lPLUmYnk9ffdaEdgiTcUjRakjOpwwVwkkwlEZcKjmunNtDnA34Bm2SqxjwikBCik
         hYmye4HIW61qjeNo2ryscSLtqM+qApo53Iq8lLiteaOZxj8fSuRUONeJHDHP7WOTW7H3
         2qpA==
X-Gm-Message-State: AC+VfDzPb7IsTzi07wL1ammRENSvxRrN1oo7pqgL+/WTC+y/lFUJ57Ty
	kxnnG9KDJgzEuSZikCQR4Fg=
X-Google-Smtp-Source: ACHHUZ5aqF2rzLL7LJVdUWNYEW1f9IcXPk+Mb2UA7Vv54UBKJAa/5DNDz+HBuJl+MrG+sbpnt6D8Uw==
X-Received: by 2002:aca:f102:0:b0:39e:af33:2d with SMTP id p2-20020acaf102000000b0039eaf33002dmr766947oih.0.1686927703287;
        Fri, 16 Jun 2023 08:01:43 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id q8-20020a0568080a8800b0039c7c757dc1sm7818826oij.24.2023.06.16.08.01.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jun 2023 08:01:42 -0700 (PDT)
Message-ID: <dcc699f8-a770-cd55-7822-65c1d3daa275@gmail.com>
Date: Fri, 16 Jun 2023 11:12:10 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v2 08/11] kbuild: rust_is_available: normalize version
 matching
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
 <20230616001631.463536-9-ojeda@kernel.org>
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <20230616001631.463536-9-ojeda@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/15/23 21:16, Miguel Ojeda wrote:
> In order to match the version string, `sed` is used in a couple
> cases, and `grep` and `head` in a couple others.
> 
> Make the script more consistent and easier to understand by
> using the same method, `sed`, for all of them.
> 
> This makes the version matching also a bit more strict for
> the changed cases, since the strings `rustc ` and `bindgen `
> will now be required, which should be fine since `rustc`
> complains if one attempts to call it with another program
> name, and `bindgen` uses a hardcoded string.
> 
> In addition, clarify why one of the existing `sed` commands
> does not provide an address like the others.
> 
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
> [...]

Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
