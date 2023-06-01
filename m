Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14CED23A1
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 14:58:26 +0000 (UTC)
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-39a55e5cfc0so757729b6e.3
        for <patches@lists.linux.dev>; Thu, 01 Jun 2023 07:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685631506; x=1688223506;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Z5oZUj4BYKrYj6C7jgvhC/0+X5rQBbpEc43xWYXfb/U=;
        b=XpocVGWaQaH7hZ1qQXktHst2OfMpF2MYFFtqMgh7rNtfKBftvJlk6Rak6hg+4uqwSS
         +mNWfJJoFH7vJAUf+OGs4znG+e0xZpMKIADb0D0AUd3rCZj08qbc7cgmfnZAbMTEE1M8
         Jv6S3oYSchdsPXEPz1+HrnJDp1o2Ls4BTRhDPdiCE5WX8LudSB/sJoZL7gdwSmjj0KM2
         qaYLaBMnyNLlUr7/0qYyojcLFxFiLAabaxxueI3Q53dVaGOA6xNcAL0hvlaB0lvzTqRw
         lsDeJ3T9gQ6tfmooUSTulkrUzxwX13sqOHuFc5zTfv/e5uM4W/vWhRoW4I9aD0MgAaav
         +nRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685631506; x=1688223506;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z5oZUj4BYKrYj6C7jgvhC/0+X5rQBbpEc43xWYXfb/U=;
        b=kG/lqlQhA7T05dTnuBP+CDIZZtIA5YyoD1L1+aLF2hEYI6kCFhqxChE50bOXzrAm2J
         PZkg/+bgwPBm/rgYkfU3sl0ogDZd3u6v5Yb4CRuNOryQrch9Qz5jOccE2fZM1myKEGlh
         WZAL9vOtBJ4wtntttqagC9/bJYUU8D/FL/h8YeO1iKkm1wUVaM+nCgjiDbl39ojmKJ6x
         tWO6MxdLHbkx5Ny0NuKfNIn/SpOCSW3fSxw11f7n9Ozv8lPMHrTNP80NBba/ROmvuES2
         x+YTkUXRbxPX2bPC1VhliwtkWLLpD0T8/TIPW9HajF7Wl20h5GakhPcTygI2QCpuKI3X
         +lBw==
X-Gm-Message-State: AC+VfDxmDOWSjvm5gRkCQxSKEdCSN/3rpv5ojId8qIABbyDRk8V7inff
	ht1z9/YNDRxmumklek6uN3g=
X-Google-Smtp-Source: ACHHUZ7MUVW4BH/e/4fAJO7/o//9I5SsPNDyrMCqnuoPtnvdBnyUeYLgcNuBIidEY0gR6WFFd7JGsg==
X-Received: by 2002:a05:6808:2a63:b0:398:4870:d2ed with SMTP id fu3-20020a0568082a6300b003984870d2edmr7739673oib.13.1685631506012;
        Thu, 01 Jun 2023 07:58:26 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id z13-20020a056808064d00b0039a4f37eaf4sm1705146oih.55.2023.06.01.07.58.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jun 2023 07:58:25 -0700 (PDT)
Message-ID: <4f2915e9-270e-a2a8-d73e-32f8935d27a0@gmail.com>
Date: Thu, 1 Jun 2023 11:51:45 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH v2 6/8] rust: workqueue: implement `WorkItemPointer` for
 pointer types
Content-Language: en-US
To: Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho
 <wedsonaf@gmail.com>, Tejun Heo <tj@kernel.org>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=c3=b6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
References: <20230601134946.3887870-1-aliceryhl@google.com>
 <20230601134946.3887870-7-aliceryhl@google.com>
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <20230601134946.3887870-7-aliceryhl@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/1/23 10:49, Alice Ryhl wrote:
> This implements the `WorkItemPointer` trait for the pointer types that
> you are likely to use the workqueue with. The `Arc` type is for
> reference counted objects, and the `Pin<Box<T>>` type is for objects
> where the caller has exclusive ownership of the object.
> 
> Co-developed-by: Gary Guo <gary@garyguo.net>
> Signed-off-by: Gary Guo <gary@garyguo.net>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
> [...]

Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
