Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B69FA101ED
	for <patches@lists.linux.dev>; Wed, 17 May 2023 20:42:30 +0000 (UTC)
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-394440f483fso727916b6e.3
        for <patches@lists.linux.dev>; Wed, 17 May 2023 13:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684356150; x=1686948150;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IKmc4/mY2T8M2vtBoa3KRIY5AIQ1sNsQWDEPH950Scs=;
        b=eUGiJbnfLgkPtl6HyfdqGOEGxQmhF6+mgHDX4SBK74DqCsMAtewI0AtjeOiTs3oNqq
         4DB7ue0e5qRJccB4bfIXxaZyaPoxol+uXIQfhHJf2LkbDwxCV9fMguKjOXpb4uQL3pPM
         dIZKc1l6DfNpP4fum/8/L07J1kyQSb7rR03oaAfGT/fy2PpYT+WRXnIW8ODOgBYgOLhQ
         MOpXPBwJ3D7sdNEXc0wsZlJ7/3dNQLaKOf68ifgkOjxwE0c1c8KECZ00ltgkejzykvx0
         M0UXVwBqnwENbA8nfmusa/2ON7UtyaA6xxzfg87HGQX9qnEfLh9zntDfeFNqnAdiRyuO
         ZNPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684356150; x=1686948150;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IKmc4/mY2T8M2vtBoa3KRIY5AIQ1sNsQWDEPH950Scs=;
        b=cVyPYJCm8X+Ciydg6/3FfZ027VvLZtkqiY756VoxaymiUqw6Jj2FnHmBnu/1ff4C5I
         0PQRVJ9grN4oi1BWEzg0En9byLekQWFUB1RWzbkxGQJdH4Sl720j5jhOCSNJ8Jz4VfIP
         fLY/kXDRaulPeoBpSNY1vyW55VX/VsTpJePvPmYLTMwdnSptW9vW+98tjRiB9TAF153J
         hJPa/ZOSVSQ2Lht6sz/8S/EXWiWzV8D0t6pDBJyFCsKd+oWzfonBR+I3JRyEGEQ6hSYu
         gGxLpTwNfffnd58fqruvKb2XTIzzKuLHGEXo5rsEaW/6B/avc11AxN4n7rr1fhW9twze
         pwpw==
X-Gm-Message-State: AC+VfDy6vp9Dw5Ee2C8JtAiOCSp+JzlvvC+M2nWCQVi2esM0OhkVBpAc
	TINHc5nT4sPX5A6dzF8sE6g=
X-Google-Smtp-Source: ACHHUZ41+outjsfJKy4Z+3zXxQQv9yrO3qwXSk9TUPgATnMrC9PcekqE5qHFLmEcRTICyBwlKGf1sA==
X-Received: by 2002:a05:6808:99c:b0:395:7577:1533 with SMTP id a28-20020a056808099c00b0039575771533mr39910oic.37.1684356149776;
        Wed, 17 May 2023 13:42:29 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id q66-20020acac045000000b0038c0cf168afsm10424955oif.7.2023.05.17.13.42.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 May 2023 13:42:29 -0700 (PDT)
Message-ID: <6a8183b8-0e81-9f2f-f79f-74ca5beb3ef4@gmail.com>
Date: Wed, 17 May 2023 17:42:22 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v1 2/2] rust: sync: implement `AsRef<T>` for `Arc<T>`
Content-Language: en-US
To: Alice Ryhl <aliceryhl@google.com>, Miguel Ojeda <ojeda@kernel.org>,
 Wedson Almeida Filho <wedsonaf@gmail.com>,
 Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=c3=b6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>, Will Deacon <will@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Mark Rutland <mark.rutland@arm.com>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev, Wedson Almeida Filho <walmeida@microsoft.com>
References: <20230517200814.3157916-1-aliceryhl@google.com>
 <20230517200814.3157916-2-aliceryhl@google.com>
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <20230517200814.3157916-2-aliceryhl@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/17/23 17:08, Alice Ryhl wrote:
> [...]
>   
> +impl<T: ?Sized> AsRef<T> for Arc<T> {
> +    fn as_ref(&self) -> &T {
> +        self.deref()
> +    }
> +}
> +
>   impl<T: ?Sized> Clone for Arc<T> {
>       fn clone(&self) -> Self {
>           // INVARIANT: C `refcount_inc` saturates the refcount, so it cannot overflow to zero.

Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
