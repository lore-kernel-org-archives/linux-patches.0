Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09DB315AE9
	for <patches@lists.linux.dev>; Thu, 15 Jun 2023 13:50:52 +0000 (UTC)
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-1a9b0ec6f4cso244100fac.0
        for <patches@lists.linux.dev>; Thu, 15 Jun 2023 06:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686837052; x=1689429052;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DojIv4w46I2F3FeQItbDQQuCHIMIGT7OLbgfH+JlnwQ=;
        b=N0XpOh5s++xYT1PbPTgq5mjgxoPU2+YVe7NxEp5HUoBbHK2MA+Kv2aVJ+WPbbIUI3R
         5TWJJ4jOL4FlRKUCZ037736XNKUUXR4SY4IoGu/D0uysuncG5HFJOt9p+hfIM24sK47n
         cz489yggWXEL4wUMrJEiLY/hAfu1G41MQhPYw1qk8YSVvmWZLM8Wl0pEaAIGiLHAaM7P
         5YtztyAR+QKrYxYTv8YgA9+GuynMP1f7sOuBmegdbs6sXOH/Rzl54DsybpRaVxtfLKO/
         9foNFgIfR+N8vHZnFO087fjJ6bnq44R3m2wyXqVSOhWMIm/rDw/TFngSqkDW8N28YSTi
         eZDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686837052; x=1689429052;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DojIv4w46I2F3FeQItbDQQuCHIMIGT7OLbgfH+JlnwQ=;
        b=GGXS/Yd62KojHl5gw/ngrDi9f1nglvSfmbtjhIWUYJT1b23sUUNV7yM2+Z0cfZbj9K
         FwsNOf5XxWzFIZSIStbzlrF9t1oLrHyMgG8JKcK6xGf88WQX2h9Qx/U7CBz+4I/MMlkb
         0IddvQWR8C07SMN09C7Y+n+C/wEka9c2fKmsl4wZ8VNyncxL6XLlPX5QGBguMLNIPqL6
         czDmEWeGXAQIphde+BJsd8+X+RWuqxfThNJ7UrQPmkFUjDxIjbNJ9OTp0/do8EQi3CUG
         SvteHQBzMGk11746SdD28Jak0oW7j6lH3Lx92sVajQIYv+3Eaf1bOuQMWbvIU1xomGTV
         A1ew==
X-Gm-Message-State: AC+VfDxiECaoAg0rl0twG6a1GrYPNWBxVlFAfNIa99TjxcCNBD0DB3ti
	jl6xtpjiZjcxt4/efYg3XpQ=
X-Google-Smtp-Source: ACHHUZ4QA5CeMfItNvb6CUzhgyiSshhiQxO/S1j7j7mulYZ+gEs9Qgp4gDjmd0Bcx6LPRvCKV7QNaw==
X-Received: by 2002:a05:6870:b791:b0:19e:fae6:c9ab with SMTP id ed17-20020a056870b79100b0019efae6c9abmr14852503oab.57.1686837051941;
        Thu, 15 Jun 2023 06:50:51 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id t14-20020a4ad0ae000000b0054fd0b7af2bsm5988465oor.31.2023.06.15.06.50.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jun 2023 06:50:51 -0700 (PDT)
Message-ID: <0b7d1e30-52ea-c4cc-d0fd-f879cd67ef3b@gmail.com>
Date: Thu, 15 Jun 2023 10:50:46 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 5/6] rust: support running Rust documentation tests as
 KUnit ones
Content-Language: en-US
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, David Gow <davidgow@google.com>,
 Brendan Higgins <brendan.higgins@linux.dev>,
 Wedson Almeida Filho <wedsonaf@gmail.com>,
 Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=c3=b6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>,
 Alice Ryhl <aliceryhl@google.com>, Andreas Hindborg <nmi@metaspace.dk>,
 Philip Li <philip.li@intel.com>, kunit-dev@googlegroups.com,
 linux-kselftest@vger.kernel.org, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20230614180837.630180-1-ojeda@kernel.org>
 <20230614180837.630180-6-ojeda@kernel.org>
 <49dad8fe-c509-6c43-559e-13a82563d3d0@gmail.com>
 <CANiq72mq4wYJ77qDKYWTO=FkA1AYat2rJd63Gps9aUrP82c9dQ@mail.gmail.com>
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <CANiq72mq4wYJ77qDKYWTO=FkA1AYat2rJd63Gps9aUrP82c9dQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/15/23 06:23, Miguel Ojeda wrote:
> On Thu, Jun 15, 2023 at 5:52 AM Martin Rodriguez Reboredo
> <yakoyoku@gmail.com> wrote:
>>
>> I can't remember that if this panic it will mention the path on it.
>> Though if it does, then use something more explicit than
>> `.unwrap()`.
> 
> It doesn't print it, and I am happy to make things more explicit, but
> in which case(s) do you see it failing?
> 
>> Please do not use unwrap here, one can easily create a path that
>> it's not compliant under `rust/test/doctests/kernel` and get no
>> clue about where this script has failed. Use `.expect()` or
>> something else instead.
> 
> The folder is removed every time, so that should not happen I think.
> Yes, you can still hack things and call the script manually, but I
> wouldn't call that "easily".

Ah, you are right, I've forgot that the folder was deleted and
remade, and because of that an error is more likely to occur at that
stage and not while `scripts/rustdoc_test_{builder,gen}.rs` is
running. Thus.

Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>

> 
> Nevertheless, I am happy to change it if we think there is a risk,
> e.g. `rustdoc` changing the pattern (though we pin the version so
> far).
> 
> Thanks for taking a look Martin!
> 
> Cheers,
> Miguel
