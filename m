Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1152DDDC8
	for <patches@lists.linux.dev>; Wed, 12 Jul 2023 20:46:30 +0000 (UTC)
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-1b00b0ab0daso5913609fac.0
        for <patches@lists.linux.dev>; Wed, 12 Jul 2023 13:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689194790; x=1691786790;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hjYp/GGGt1suSt9XKydx09ugNwhwrtHkiMgpJkM/lOc=;
        b=ncfNislj9zkZDbzfooNQKCoi3fZ/tNoj/jW86RpRgvnL/xWidIpWcLH6ayF7AetyXO
         qAHUWsEqwvY/NGG3fsTp3T5S1FjT/PNbxOToVwEQ82BTZcQAerhxx85WCv+6o+sVl5oF
         XmOVP70uv/1ZWlrvgrOlOXDPHUprmR+TjTvWD8V9/i5t9gafRdk/jZI6bg0k1+FuwnIr
         KDe5lzQr+yOdL9AFvjfJwOFbG9AxD/BxnV7lqt9o4cpBP1ytub13wm+8xwY46e7QiBIF
         FJcf4gGhW5HVpz9WAXW8y74oeWD0SGnqtQNxrrbAWkLXZPuzgApTeQiyIVeFFzaghT2V
         I36Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689194790; x=1691786790;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hjYp/GGGt1suSt9XKydx09ugNwhwrtHkiMgpJkM/lOc=;
        b=GXfMwzNwdclpNIPsq0FEXmvZVmUaUZTUNrm3Y+sn0oAz4WwBzX8/JWLQLgjMXquu0G
         YifG6MjFSzAkrenDcQB2yGsYMDw3bMitAgO7RXfVDytRVcq3Z0Axzg9/mp2txYtkW5k2
         yH208qgiAvFp00cPT1X2s/R5B+2tP6K4rUTVs5BsRGNEqRdhAk2Bd8M1gOz2o8q9dfTp
         Ukab+yOxqRu59zklHZbnWVz2BpZzi2uQDjkmWR9X5UUor+bi7mVN9hjIN+moSLwfQ0LN
         euB05kAIesIMmCYim7ltw3WVhjbxPVTi9EVzB82nnTI1sr6DaaJTt8F+0M7hBrJF5Pn5
         95wg==
X-Gm-Message-State: ABy/qLaaQLZoyQwJInEs2oIOr29dUXUmOcLUDQVU0FOgAiEnM25FYY44
	qD0B+JloSH3cBanxoOO00Qk=
X-Google-Smtp-Source: APBJJlGB8IZyS5AEyRlG5pMJgxfMJIQfz18Bl/ywWLjb12fdCb0ahZIw7N3RXMtz/5OOeQxQTXct2g==
X-Received: by 2002:a05:6870:e313:b0:1b7:8950:f583 with SMTP id z19-20020a056870e31300b001b78950f583mr297915oad.33.1689194789797;
        Wed, 12 Jul 2023 13:46:29 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id ds53-20020a0568705b3500b001a6d15fc52fsm2397384oab.4.2023.07.12.13.46.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jul 2023 13:46:29 -0700 (PDT)
Message-ID: <4b92e8be-32c8-0ac4-723f-59f2fc42e6b3@gmail.com>
Date: Wed, 12 Jul 2023 17:33:12 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v3 2/9] rust: sync: add `Arc::{from_raw, into_raw}`
Content-Language: en-US
To: Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org,
 Tejun Heo <tj@kernel.org>, Miguel Ojeda <ojeda@kernel.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>,
 Wedson Almeida Filho <wedsonaf@gmail.com>,
 Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=c3=b6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 Wedson Almeida Filho <walmeida@microsoft.com>
References: <20230711093303.1433770-1-aliceryhl@google.com>
 <20230711093303.1433770-3-aliceryhl@google.com>
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <20230711093303.1433770-3-aliceryhl@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/11/23 06:32, Alice Ryhl wrote:
> From: Wedson Almeida Filho <walmeida@microsoft.com>
> 
> These methods can be used to turn an `Arc` into a raw pointer and back,
> in a way that preserves the metadata for fat pointers.
> 
> This is done using the unstable ptr_metadata feature [1]. However, it
> could also be done using the unstable pointer_byte_offsets feature [2],
> which is likely to have a shorter path to stabilization than
> ptr_metadata.
> 
> Link: https://github.com/rust-lang/rust/issues/81513 [1]
> Link: https://github.com/rust-lang/rust/issues/96283 [2]
> Signed-off-by: Wedson Almeida Filho <walmeida@microsoft.com>
> Co-developed-by: Alice Ryhl <aliceryhl@google.com>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> Reviewed-by: Gary Guo <gary@garyguo.net>
> ---
> [...]

Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
