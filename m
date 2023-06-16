Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3749B1427C
	for <patches@lists.linux.dev>; Fri, 16 Jun 2023 15:01:31 +0000 (UTC)
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-1a98cf01151so911104fac.2
        for <patches@lists.linux.dev>; Fri, 16 Jun 2023 08:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686927690; x=1689519690;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I2cPag5aN0MWJAFLWvbMyNtH5T6S8+Vc3THjxE3SzjY=;
        b=W+p57BBqvE6vEIGynnEcGkcirKwbw1ptyeFjMPbtqTG3SGjnb3uYqiiHozshYO/6HJ
         1qSdqohr+yo7gI4nd9qLBvMJ+sCLfTeO4sEHGFm6vjR2Igrno7VnujIyGduO8yi/JUtm
         1XO3aFy44jOZJ5sC/rYkqm6LvdNuq+IwlAaE2Xu6DsyAbRLk2BPyG+avwAQStzkAaNoI
         ue4XvfU12TU28nWnesTeSGBXxVM4JREiOvCQCHrVrhh9mJAU25z8Z3+Wb5VZ8q0DaH1O
         R7ukxlytxBaetNWVGMm3fzaLe2x5VDh63rlk8HCdM1Ul8lFqd+lOoOHaN6UGbe3rrpCs
         9T7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686927690; x=1689519690;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I2cPag5aN0MWJAFLWvbMyNtH5T6S8+Vc3THjxE3SzjY=;
        b=LSaKj9bzUtQ9t32gpswuuYp0ECT2sdI9Iq1iHHrSTTDIWCtFVGnPx+QctDe6dbmCuz
         lVYmrNMJCImKIgeNDgtmhCSaLHCKEtf1EQ/FaznBKlwfcQyD0vePKV1cx2RA4eIDk08a
         dNbZ5kePTZRj1taypbeoN/dkq2SWqWQw6BmWRg2nTAOPTfbCTC8UqRsqiXvCq6rmizTi
         zDihgL5rJI1IoxHdXUr8hC4+8DTOT3r6c7r0st1TVbpn/DiuJqNjwDNM4guuANk4iDVl
         S71YnsNmf5Ly2cXo7hLV0fLCBh5VyityCavc9FE5QaDx2oifiEer0KzjUpDezxlbk+MT
         l8TA==
X-Gm-Message-State: AC+VfDxmsHs/0CNeT1VNWTd4P4Ndg8Dd8ztL71MBs6OCTmgatw5XArnB
	7lrRVcgp3W9pXLRZ0xEMASs=
X-Google-Smtp-Source: ACHHUZ5tmQXBdCH0Bmja7Xhdz4f/k6mMEDWuBdBMFjqEXJnnkwS+GUUn2WO6K4oJIq+FLAWB2rDn4g==
X-Received: by 2002:a05:6870:1a93:b0:1a2:f7ca:61af with SMTP id ef19-20020a0568701a9300b001a2f7ca61afmr2446890oab.2.1686927688697;
        Fri, 16 Jun 2023 08:01:28 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id l1-20020a05687040c100b001a2d569558dsm4155233oal.35.2023.06.16.08.01.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jun 2023 08:01:28 -0700 (PDT)
Message-ID: <f278ea82-e949-f4d2-a48e-e615fa5491f6@gmail.com>
Date: Fri, 16 Jun 2023 11:08:52 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v2 06/11] kbuild: rust_is_available: check that
 environment variables are set
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
 <20230616001631.463536-7-ojeda@kernel.org>
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <20230616001631.463536-7-ojeda@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/15/23 21:16, Miguel Ojeda wrote:
> Sometimes [1] users may attempt to setup the Rust support by
> checking what Kbuild does and they end up finding out about
> `scripts/rust_is_available.sh`. Inevitably, they run the script
> directly, but unless they setup the required variables,
> the result of the script is not meaningful.
> 
> We could add some defaults to the variables, but that could be
> confusing for those that may override the defaults (compared
> to their kernel builds), and `$CC` would not be a simple default
> in any case.
> 
> Therefore, instead, explicitly check whether the expected variables
> are set (`$RUSTC`, `$BINDGEN` and `$CC`). If not, print an explanation
> about the fact that the script is meant to be called from Kbuild,
> since that is the most likely cause for the variables not being set.
> 
> Link: https://lore.kernel.org/oe-kbuild-all/Y6r4mXz5NS0+HVXo@zn.tnic/ [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
> [...]

Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
