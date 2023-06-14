Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D2482C9C
	for <patches@lists.linux.dev>; Wed, 14 Jun 2023 15:30:34 +0000 (UTC)
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-6b2b7ca1c5eso4921803a34.0
        for <patches@lists.linux.dev>; Wed, 14 Jun 2023 08:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686756633; x=1689348633;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AOA7Y2/g359kO/OUlQWs/60uYSwoJsQ+eNPsqyoLC6A=;
        b=IHExyYknCYaNR++NT7KWQAcnorzZ/DTyWryslqKrhqzx45SLH+A8LegSKtd3EzgkVb
         tW3J8S7+d3/pvpRchov+vmYHgtbiMVHn29z/umpYT47vj7CK/HzYW/cFAoxbL2vU3LRP
         ZeiwVtBi6+gu8+kamPFjkjMdrHQcpnpHI5O9YBAzV6oEpwFi8a1XCtPhjzuxplxJjrNn
         7eo7tVEd3ulkPJiC8e1ezn95zAaPHQvzylrdLKXTdcZa953ykg14xRkJihxaHXKtD2LH
         LSu/K2jGI5Lq8rbUCyKaWSNQ/emRuguhY6Ix9f7rYeZhxp18xsZVh7d09gQYar+nt+1F
         fOTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686756633; x=1689348633;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AOA7Y2/g359kO/OUlQWs/60uYSwoJsQ+eNPsqyoLC6A=;
        b=HSXxHsjOdmWFUTL7pa+ipiTS7TOpQH7gvFRbBUpTVkA/nvBtrhHuEvLtMPCLBvnYae
         VZ1K7YvzncUAI4K8iWhTksOmemeV7hj6y4gGCEVmQp7i/1NjC1rqzY/q4lEkMq2GlBPM
         zLsSdCf4rp5oOo9vrGMQ/ZTDkHy1nheZCJs/7pWMd/3V867OXl39HSHz7bfNxXF9F09t
         QFV/UOIbgKXHqQP9rbInzAa6NcsZHi3J30mxwDbjUlx/7kNZSCie0F4aqVmsGfaRdJRB
         DM0pSsc7qvRV59DB/mjkbm6GkzDxopESnwendC87rOPb62Ga4yvwKOP3MGS9iz+Apqy5
         M9jA==
X-Gm-Message-State: AC+VfDy7qqLEC35t7wcnAkGfllTMCzz2yqBuV6hyk0NIEbWTq0Vss2la
	59DhHQZOtwpDjPIQRXWUJRI=
X-Google-Smtp-Source: ACHHUZ6FakHIDN4yFpz0tDtI2ydPYV4hLaDjD7mRfadlZqUYSUOmebPcmNnoYLOzD1Zw1HQ8GyAjDA==
X-Received: by 2002:a9d:754c:0:b0:6b1:c635:b0fd with SMTP id b12-20020a9d754c000000b006b1c635b0fdmr12677424otl.32.1686756633095;
        Wed, 14 Jun 2023 08:30:33 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id y2-20020a056830108200b006b168e0a41fsm4739886oto.11.2023.06.14.08.30.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jun 2023 08:30:32 -0700 (PDT)
Message-ID: <7283dd30-79ac-b21b-3e99-2b8b0950879d@gmail.com>
Date: Wed, 14 Jun 2023 12:30:28 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] rust: make `UnsafeCell` the outer type in `Opaque`
To: Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho
 <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=c3=b6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
References: <20230614115328.2825961-1-aliceryhl@google.com>
Content-Language: en-US
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <20230614115328.2825961-1-aliceryhl@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/14/23 08:53, Alice Ryhl wrote:
> When combining `UnsafeCell` with `MaybeUninit`, it is idiomatic to use
> `UnsafeCell` as the outer type. Intuitively, this is because a
> `MaybeUninit<T>` might not contain a `T`, but we always want the effect
> of the `UnsafeCell`, even if the inner value is uninitialized.
> 
> Now, strictly speaking, this doesn't really make a difference. The
> compiler will always apply the `UnsafeCell` effect even if the inner
> value is uninitialized. But I think we should follow the convention
> here.
> 
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
> [...]

Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
