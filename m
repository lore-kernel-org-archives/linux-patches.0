Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3236618001
	for <patches@lists.linux.dev>; Fri, 16 Jun 2023 15:01:58 +0000 (UTC)
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-1a9d57f8f9fso583342fac.3
        for <patches@lists.linux.dev>; Fri, 16 Jun 2023 08:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686927717; x=1689519717;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dRcxXeLT1Jidp1YuQQcBi4VOs63S4oCIaCSoEGYplmw=;
        b=U55lKpSv4wxQWh4ybFDgFR24RjtdrByvyp1gYQKwCKozZx8QBVsd/BbuOpxEq/CGMX
         VMpMc7EgOuYR+CNa+Go8lM81tpF/8X8FkgwmSb8k5xP+mnAN6UirX1xu1kPTws11c0Dg
         Hsnan7rRfGppI2OYJiSQAU3w1I3Kiu6vwKwviZWnmz9Mwfzg45zmGhAH5bS/nef/0AHC
         uAy/ddilnfSG65/1+MT045cKlqPS5tubyrTtdXpkx06MxvL6qNwRyQPzOF6fD435/Al3
         yudVfX/MQOK2mrAqZkIFJmMB8jrMeH76Y51RuqlW/Vzw5hwHjgsurnhEQNcYRivYCtcp
         3muw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686927717; x=1689519717;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dRcxXeLT1Jidp1YuQQcBi4VOs63S4oCIaCSoEGYplmw=;
        b=J7zxB1zmPgugrycCfCgU7nYNJYgjrinN6zI/UuUvB+hxDlx4qTgohrZZ8RdxnngHLy
         2xwv9yC6JCaFKJrMXH9lDRV5NqCYtfd5KyEBS/Qi1b+BtYdJFuq5Z327270hniz1W02s
         FMobUqpP+ykFvRDFg2CNhYBilNpnboViF3O6vHfaruO0wtgaLjytHNyjjvLw8Vy+BO7C
         ZeiyhthahENmtdMxbYDnBaLU52ERu/6+dPgLPxjsyEs5lqkf/MlfmTjzWJi6jbTCo6Dw
         9dQQD9eOgRZUKp6RLho75YFnq5ILl61/AH0bFeADH3oKEm9dw/SsID1BFz0mJbrT5QEd
         VgLA==
X-Gm-Message-State: AC+VfDyT7UzCNZlc7akNPfQLyGOYdKj+q+mtpDqbMxhc4FyPYEloXLt7
	ZNTcfa0tcw+htfMFEKz02Ec=
X-Google-Smtp-Source: ACHHUZ5/iYdSXWj23TWLkv87RnWd7sL8N2fIpt8OrYc9krBD/0du53BXzas8RJnT0bcx4/ipIQRDRw==
X-Received: by 2002:a05:6870:d416:b0:19f:7b5b:2855 with SMTP id i22-20020a056870d41600b0019f7b5b2855mr2055436oag.15.1686927717282;
        Fri, 16 Jun 2023 08:01:57 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id os12-20020a0568707d0c00b001802d3e181fsm11640984oab.14.2023.06.16.08.01.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jun 2023 08:01:56 -0700 (PDT)
Message-ID: <8044dea1-3bd4-d3d1-0a7b-316df38f3276@gmail.com>
Date: Fri, 16 Jun 2023 11:16:15 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v2 10/11] kbuild: rust_is_available: check that output
 looks as expected
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
 <20230616001631.463536-11-ojeda@kernel.org>
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <20230616001631.463536-11-ojeda@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/15/23 21:16, Miguel Ojeda wrote:
> The script already checks for `$RUSTC` and `$BINDGEN` existing
> and exiting without failure. However, one may still pass an
> unexpected binary that does not output what the later parsing
> expects. The script still successfully reports a failure as
> expected, but the error is confusing. For instance:
> 
>      $ RUSTC=true BINDGEN=bindgen CC=clang scripts/rust_is_available.sh
>      scripts/rust_is_available.sh: 19: arithmetic expression: expecting primary: "100000 *  + 100 *  + "
>      ***
>      *** Please see Documentation/rust/quick-start.rst for details
>      *** on how to set up the Rust support.
>      ***
> 
> Thus add an explicit check and a proper message for unexpected
> output from the called command.
> 
> Similarly, do so for the `libclang` version parsing, too.
> 
> Link: https://lore.kernel.org/rust-for-linux/CAK7LNAQYk6s11MASRHW6oxtkqF00EJVqhHOP=5rynWt-QDUsXw@mail.gmail.com/
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
> [...]

Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
