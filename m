Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7302F1FAD
	for <patches@lists.linux.dev>; Thu, 30 Mar 2023 12:18:45 +0000 (UTC)
Received: by mail-wm1-f43.google.com with SMTP id d11-20020a05600c3acb00b003ef6e6754c5so7881769wms.5
        for <patches@lists.linux.dev>; Thu, 30 Mar 2023 05:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metaspace-dk.20210112.gappssmtp.com; s=20210112; t=1680178723;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=Wyt/QKbfFqwXxgXngsVcjXvUcjSi2SpEjcCROkpNZHw=;
        b=Eqmfhnq5IEFLLhAjAZRIobhW/2B13mAKES+/WX/G7vJ9k6+u98ggyXukQa0h3R3Pf3
         hjsG7bZivizU1puj66d5NNFYaW+jHoYbxNV/lTSLJgMMevl4Go5+ZPboncgUDRXv+Pb5
         GkG6JqvpkWG3I7zPRYUM/oVw8aPAfOctlVnYhW3XV6iph4MfSFnbNkEfkkUtUh3+FKZp
         d9vZsJt5qH/TE/5iu76QwFEFI3Y6o0Et9QWOv86TCtRi04gMXrYrQfxpDNocZPH0N5AI
         +FBeoAHbfb91soVmz+IvymSJvF+YbDnt0hX2v2zuIdsuZ1JNTbWQnLcpZ2QItLZ9R6eX
         MdDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680178723;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wyt/QKbfFqwXxgXngsVcjXvUcjSi2SpEjcCROkpNZHw=;
        b=CL768RoEYiW+77NxlpaJqpOW/P6xGu1aQGTdWf3fxfKRwHd74S9zaAdCAf5zMDUVn8
         5QraBSCtN85gg9jPIm+cDXZwixkI9fJXClnWOjkq5Cx3BPXJp6QBp7WwTTkMNuD8cHMc
         tgPYkBvFrV0jl96DZ/vYfN36LpIhYhzm6bPt0O2XNWqhyxVpRfOOA21RYcRKzgzV4mkz
         81MT6UOa/C/9HQw9WySMtMo6u/rGqNs0AbKakEBj+x0GX3ol2rJLFkJUtfPGy6XQ1Odz
         ILucYt43QW6oyOfquNYOz3fW2tQBcJP+EBLGaMhQ2/rPLa5BukpThx+smy2ofj0M0tHl
         VETA==
X-Gm-Message-State: AO0yUKWB+1wLBtpTeHmr/arp3dqOob6s4hf1NK8c1uRN0+lqaFwy6jUM
	J7IECKur1A0rKcJeHZtsOpV2KQ==
X-Google-Smtp-Source: AK7set8KZRCKiYFEeuKZGefi283mvYKlXVix1qHiiGvficshl2fwJ0ohFCGwM+wM6kXCzp8F9AjUWQ==
X-Received: by 2002:a7b:cbc2:0:b0:3df:de28:f819 with SMTP id n2-20020a7bcbc2000000b003dfde28f819mr18146008wmi.15.1680178723657;
        Thu, 30 Mar 2023 05:18:43 -0700 (PDT)
Received: from localhost ([165.225.194.194])
        by smtp.gmail.com with ESMTPSA id n23-20020a05600c3b9700b003ede04deb14sm5744936wms.48.2023.03.30.05.18.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 05:18:43 -0700 (PDT)
References: <20230329223239.138757-1-y86-dev@protonmail.com>
 <20230329223239.138757-3-y86-dev@protonmail.com>
User-agent: mu4e 1.9.18; emacs 28.2.50
From: Andreas Hindborg <nmi@metaspace.dk>
To: y86-dev@protonmail.com
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
 Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng
 <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?=
 Roy Baron
 <bjorn3_gh@protonmail.com>, Alice Ryhl <alice@ryhl.io>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
Subject: Re: [PATCH v3 02/13] rust: sync: add `assume_init` to `UniqueArc`
Date: Thu, 30 Mar 2023 14:18:06 +0200
In-reply-to: <20230329223239.138757-3-y86-dev@protonmail.com>
Message-ID: <87y1ne4el9.fsf@metaspace.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


y86-dev@protonmail.com writes:

> From: Benno Lossin <y86-dev@protonmail.com>
>
> Adds the `assume_init` function to `UniqueArc<MaybeUninit<T>>` that
> unsafely assumes the value to be initialized and yields a value of type
> `UniqueArc<T>`. This function is used when manually initializing the
> pointee of an `UniqueArc`.
>
> Signed-off-by: Benno Lossin <y86-dev@protonmail.com>
> ---

Reviewed-by: Andreas Hindborg <a.hindborg@samsung.com>

