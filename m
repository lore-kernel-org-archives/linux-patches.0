Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58503625
	for <patches@lists.linux.dev>; Thu, 15 Jun 2023 03:52:13 +0000 (UTC)
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-1a83bfe7ca0so1049947fac.0
        for <patches@lists.linux.dev>; Wed, 14 Jun 2023 20:52:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686801132; x=1689393132;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Cb+dev0gi3mOMoRwFhsdS2OBBCly4pJkh/R4J7IbY+Y=;
        b=duuH4kCz0axWUugesyNEbfAcxNNK6xxrhiicP4rIRpHV/4McQs7u01KdFYhipuSAs1
         7nDTNHg/cA6fsfj6MbQYZmSPvYM3GzklsgkXFS30iJI+uVQl5ZHtubD9m2rURYjmXEwM
         ISKhebj8DWINJ58qW1mFlUSeeGm3kMNe5592NaHDrFC+NR9zTwDQXGKREoKrzR73auC2
         xmTl36iu0vFJWzgLTYMPZNKlcw80DOqjZj5bBA5o3Y8dKSidawbghKWevxQkqs/UsF2N
         ZG0Vnn6+IAycTwdxZ//bkpg2/KdnZf5Hu1FyLdX7PFaP+NWDexVAEabA3jkiCR7Khz3K
         WLdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686801132; x=1689393132;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Cb+dev0gi3mOMoRwFhsdS2OBBCly4pJkh/R4J7IbY+Y=;
        b=Hvv0onuOTqcdeiH+dTaT1HfU/94L9Ou4s/HwrBzQNFmKtkqwS4JQNAtC1hw31xjfL0
         gmtqQe5QaLVeR+Ld9LHQOL+altbmqGmf9MYHczT80i/0w4z9UmvRXS9Od0GpNkhib4bO
         CI/yPcmDcNyi1P9WD5ZnRUZDxlQBLAx+1pGEnC5zmh07dW3Ms0544xLSjxQh0nyO/mqI
         EQ3Gzwhwg1mLKB8KqWacafcXOumvLQsudmuk6ws8XOb3bozr+fA/ct87kOJKgcS+RpY0
         5tC+SaGvDrnzdo7YMmSdn5CO3G7Q3eSfVErSfxGjTny9XntpPGMWpILRWnf6c+4dSsPI
         nlsA==
X-Gm-Message-State: AC+VfDxtA5lZCqdgd6cdg/gDhyRyiJIuASZwi9yP8qMDxf86eir07mAe
	beRtGh9cuPaGJ4mGDNIUO7U=
X-Google-Smtp-Source: ACHHUZ4xd4qQiOULvIWnC2Pwt8SpZGQsc1HXIoSJymjTcE7P2FOSgLsK70rNERPHvqAsONGm/ndlKA==
X-Received: by 2002:a05:6870:7715:b0:1a6:8f83:bcd7 with SMTP id dw21-20020a056870771500b001a68f83bcd7mr8351111oab.53.1686801132318;
        Wed, 14 Jun 2023 20:52:12 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id y17-20020a4ade11000000b00555907ad82esm5650922oot.14.2023.06.14.20.52.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jun 2023 20:52:11 -0700 (PDT)
Message-ID: <78df9732-6b70-3e75-75a3-303fd1477c71@gmail.com>
Date: Wed, 14 Jun 2023 22:04:04 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 2/6] rust: str: make doctests compilable/testable
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
 <20230614180837.630180-3-ojeda@kernel.org>
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <20230614180837.630180-3-ojeda@kernel.org>
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

Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
