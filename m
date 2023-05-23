Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59F91F933
	for <patches@lists.linux.dev>; Tue, 23 May 2023 16:42:05 +0000 (UTC)
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-6af93a6166fso394017a34.3
        for <patches@lists.linux.dev>; Tue, 23 May 2023 09:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684860125; x=1687452125;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RLkW4IB8Lte2u6vuIxUUWaT7tLfO+b0+5hxrFkp7bhc=;
        b=kUCgughpIJFzbxEq3AE8VPjotAe+3xTZO3xkUj0MrzsLSYwWZZPW9zcZrWxccfneBL
         dftkAjIooDR8R+BPmyfjy/ASOUghqozY2399/dpOglToYplavPxrkWg1RXRL+LBkfv4A
         URvpdv5cOxzh9MWWrbW0BIeGsIPKwXub2O73h8oMdM9BNWJNupCq2BPljuLmf+UAskhT
         0Z0Z1Oho8EA4zX2eKGym2lPeIm9NXdkqRQ6VqvI5aOwGeuqaEk1EeZmnVEMd6HA82KA3
         thoGkiVOC9+y2G8/Qfg6JynTBEYSbFqwsMKQyOCNK/ew5EM9d00V19Lm7X3OQHBZcENN
         qPCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684860125; x=1687452125;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RLkW4IB8Lte2u6vuIxUUWaT7tLfO+b0+5hxrFkp7bhc=;
        b=QYwbqFuNPr2TGXfZgam98CmdDwxd0fdXulVgLf8cM2os/C+4shGn18/k7mF2STHtuQ
         vN+5vnzW4STcUSc7GfxrlnOg6w/naXs3TkQ3bKdXcSTBzNOjjJKfqiGOu0DVQticKDn7
         vexLkbIIKplOiw1Ocg3/TqEx68IslKTheHCBIxQoIuIE5iEgDeROVNjPzKrLDNvJHwYW
         yUwRQAVmYVwFnRO49xH4wWBSbxOTdipVxFv4ImVG1nRNd7RLx9PhNW9dLEtwU5ezpRvG
         o+TBA/0xPvXi2ndwx4FpOMTx8GXv0EmOmTc4Ifrez7cpbk3NL+qtmHxmOzEXoxYu7ovG
         Y/2Q==
X-Gm-Message-State: AC+VfDxb51d6OiuUrRM1ShL/OBCl6IDLfRI3aW3s7MHcIT6lC40lnhX/
	b4ieayfoTe/S0qmddeVj9Qg=
X-Google-Smtp-Source: ACHHUZ6w8XkkZxBlj/4xxBGGIKniA/JPAVm0WZh2gsHnL+x26jh1QiAcslF8qeug9KexGdRKJc+Ydw==
X-Received: by 2002:a9d:6b8c:0:b0:6a4:19b2:d813 with SMTP id b12-20020a9d6b8c000000b006a419b2d813mr7614811otq.30.1684860124925;
        Tue, 23 May 2023 09:42:04 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id j9-20020a9d7389000000b006a3bd777dfdsm3576008otk.12.2023.05.23.09.42.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 May 2023 09:42:04 -0700 (PDT)
Message-ID: <c7c3c740-b534-6be1-aead-dc8dbba80882@gmail.com>
Date: Tue, 23 May 2023 13:29:07 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2 2/4] rust: sync: reword the `Arc` safety comment for
 `Sync`
Content-Language: en-US
To: Alice Ryhl <aliceryhl@google.com>, Miguel Ojeda <ojeda@kernel.org>,
 Wedson Almeida Filho <wedsonaf@gmail.com>,
 Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=c3=b6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 Andreas Hindborg <a.hindborg@samsung.com>
References: <20230523144418.1250547-1-aliceryhl@google.com>
 <20230523144418.1250547-3-aliceryhl@google.com>
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <20230523144418.1250547-3-aliceryhl@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/23/23 11:44, Alice Ryhl wrote:
> The safety comment on `impl Sync for Arc` references the Send safety
> comment. This commit avoids that in case the two comments drift apart in
> the future.
> 
> Suggested-by: Andreas Hindborg <a.hindborg@samsung.com>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> Reviewed-by: Andreas Hindborg <a.hindborg@samsung.com>
> Reviewed-by: Boqun Feng <boqun.feng@gmail.com>
> ---
> [...]
>   
> -// SAFETY: It is safe to send `&Arc<T>` to another thread when the underlying `T` is `Sync` for the
> -// same reason as above. `T` needs to be `Send` as well because a thread can clone an `&Arc<T>`
> -// into an `Arc<T>`, which may lead to `T` being accessed by the same reasoning as above.
> +// SAFETY: It is safe to send `&Arc<T>` to another thread when the underlying `T` is `Sync`
> +// because it effectively means sharing `&T` (which is safe because `T` is `Sync`); additionally,
> +// it needs `T` to be `Send` because any thread that has a `&Arc<T>` may clone it and get an
> +// `Arc<T>` on that thread, so the thread may ultimately access `T` using a mutable reference, for
> +// example, when the reference count reaches zero and `T` is dropped.
>   unsafe impl<T: ?Sized + Sync + Send> Sync for Arc<T> {}
>   
>   impl<T> Arc<T> {

Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
