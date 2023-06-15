Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D829A625
	for <patches@lists.linux.dev>; Thu, 15 Jun 2023 03:52:06 +0000 (UTC)
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-6b1fa5a04e9so269014a34.1
        for <patches@lists.linux.dev>; Wed, 14 Jun 2023 20:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686801125; x=1689393125;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XvOg6IfbDqELoJ+xhmzfRwP+bYiifV5+pLJQKyD2w2k=;
        b=mc/lDSJlyiOvuCU0/kkMoWp3+Qa3gQ1ViKUT8uc95AOn+AXSA5VSlE9WJ1HQsI7IRr
         KsmRtH32ZHgQ4Hlv1g/oF8L2iDIIx7orxQ5HMr3hX7c/wVvv3Zb3KLCqtLi/xaYUs1Jc
         h5iBQaoFu/IzLJ8Xyuu7R16T4cTqd4AapakxQRGDTODajej2QnBCVWmUigc+nMjqpqL5
         nwj/W2K5CfTbZd+1mQUX42cy4tjkMzMnBj6Cc1eUPQM1hxf6QaKXCHH3b7yEUPBFf1gl
         3kLL4Si6UgrroKc/LniXIXnP9lNLVwR4AMPQf+W2WQ9GcKfzDJzxy60Z8VNK9EctvHwd
         6RtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686801125; x=1689393125;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XvOg6IfbDqELoJ+xhmzfRwP+bYiifV5+pLJQKyD2w2k=;
        b=Ed8eoaltcbsNJpS1secRGgq2ll1ArtIASM76bCafh8m/DYOyRj6Ga3PgxSLKZXEco7
         IUaQvJ84EvjLf99Qd4+HSh1gSf2/lx/UqtTiWbdDBhXcqf3+C2w6m55Wq08ThzHr7YM2
         gEPGZmLxwg1cCkPQG//vU0CsNFAt0xhlNfXO/OSpq2BhMJUGgvCjSnI29CYgFD8Am+ez
         pvieYI9vQhjJRSUQMWh1NoKmdeTr0RjeuDuL5ld6Wd9tJB6NlAmlIJ42uqt6r6n+/FpA
         xZ1ca90+fQ+hOJ4Y//qD9WB94/rP82mylFxZii4loz/ALEHkYx1pFLhDvlz9pQZfppuh
         /rJQ==
X-Gm-Message-State: AC+VfDxo9nOvJblwFT24PD3MUOduxLMytEnC8Ca3BuwH3k0szMGOkf/V
	t3OzDqLv3wqclT4p3xNxkKU=
X-Google-Smtp-Source: ACHHUZ65QNp1nT4Po7nJM3CDNMKAiSKyD8qHADr54qw8cYq2P0sGXMiG2Eur0+P3JLDKa0U6gGnshw==
X-Received: by 2002:a05:6830:6112:b0:6b4:293e:b99a with SMTP id ca18-20020a056830611200b006b4293eb99amr2953804otb.9.1686801125584;
        Wed, 14 Jun 2023 20:52:05 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id c8-20020a9d4808000000b006b296562566sm6338554otf.79.2023.06.14.20.52.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jun 2023 20:52:05 -0700 (PDT)
Message-ID: <2b4b23ce-316e-b998-7faf-e529b121a8b4@gmail.com>
Date: Wed, 14 Jun 2023 22:03:33 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 1/6] rust: init: make doctests compilable/testable
Content-Language: en-US
To: Miguel Ojeda <ojeda@kernel.org>, David Gow <davidgow@google.com>,
 Brendan Higgins <brendan.higgins@linux.dev>,
 Wedson Almeida Filho <wedsonaf@gmail.com>,
 Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=c3=b6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>, Alice Ryhl <aliceryhl@google.com>,
 Andreas Hindborg <nmi@metaspace.dk>, Philip Li <philip.li@intel.com>,
 kunit-dev@googlegroups.com, linux-kselftest@vger.kernel.org,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
References: <20230614180837.630180-1-ojeda@kernel.org>
 <20230614180837.630180-2-ojeda@kernel.org>
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <20230614180837.630180-2-ojeda@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/14/23 15:08, Miguel Ojeda wrote:
> Rust documentation tests are going to be build/run-tested
> with the KUnit integration added in a future patch, thus
> update them to make them compilable/testable so that we
> may start enforcing it.
> 
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
> [...]
>   //! #     pub unsafe fn destroy_foo(_ptr: *mut foo) {}
>   //! #     pub unsafe fn enable_foo(_ptr: *mut foo, _flags: u32) -> i32 { 0 }
>   //! # }
> +//! # trait FromErrno {
> +//! #     fn from_errno(errno: core::ffi::c_int) -> Error {
> +//! #         // Dummy error that can be constructed outside the `kernel` crate.
> +//! #         Error::from(core::fmt::Error)
> +//! #     }
> +//! # }
> +//! # impl FromErrno for Error {}
>   //! /// # Invariants
>   //! ///
>   //! /// `foo` is always initialized
> [...]

Little question, what's the purpose of `FromErrno` here?
