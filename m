Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 791FF1F933
	for <patches@lists.linux.dev>; Tue, 23 May 2023 16:42:18 +0000 (UTC)
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-38ef6217221so4329020b6e.3
        for <patches@lists.linux.dev>; Tue, 23 May 2023 09:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684860137; x=1687452137;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oeg/x8ElLxAyFPJ7qiWHT0FiJCrJGSJu6Alu0egt5Uk=;
        b=Cuzse6fc6vWWICPMHp6WOgOCrjVqiwCLDc6cMmV4y6VpglijS/esr7OItyOfLSLFaD
         uzH3zg1NpiuhR1V02vDVsyTrkH5pvYCp44n3f011ZwSDfxi6t28+j+pm/uGMnix4H3J7
         wjgkOr+5ntWdGqLmRPqRIKtn1uQ+IlvSZXs3cZY9mf6oudHL6qMm3n9OI7bKA6EVkxhL
         5p6SfR+y59ac/lcVbmIlGNCFcZU3wfnhAN/AyRLM2Rcfptvo+790f53shNyOy6ciEIhU
         3WjhIvu5glppjnJaQ0WrUU6aZMh4aItHrDAi8rnvjwApp/EcnlcmCgbMe3eSnwDhiRoh
         NsBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684860137; x=1687452137;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oeg/x8ElLxAyFPJ7qiWHT0FiJCrJGSJu6Alu0egt5Uk=;
        b=Z12mf+me/7yL42nG/E05VgERyBiCa7T4XbtTsoxPvgdyqay8ZyLy1Djy1mWH5KI2Tw
         pR+eyA4c/dXAlzQrkCvP8Qh1Wj0+8JVFr9uPgTtzeO2vW+5+HBlGlsyQixCJt4qCdAnr
         ZhCoVjhaikqeE3+cxpD0Omj9BTjSfamscSzMokWSUEEGvCFRO+K/l2GlqDD9Rsmryx4B
         NUgXHntSAPcmdTMBNVlljlrGhix6Exbl12W/jiS7j1S5UItn79fRrY8M6obQGc8j2RAQ
         Mj53MqP+nNXCT6JKlNJx+aHx2JY8CHVVMjok894AxghXoNiNUWqH2Ui4zXTbC6CT3noq
         dNBA==
X-Gm-Message-State: AC+VfDyl0QV0I3ICid4vip6uofpvHdXKWYAfktK2l7C91UpKY7Gcg36K
	EpPOS3SUrVjMXYX9LG4LR0M=
X-Google-Smtp-Source: ACHHUZ4KiqUCV5vcGG9La2JI7FtHqJtRDi5PtpsZqmtFy+kGQcvvEiOyY34u3mTt2fU8dnHrZL8C1A==
X-Received: by 2002:a05:6808:191:b0:398:10ad:e857 with SMTP id w17-20020a056808019100b0039810ade857mr3427905oic.48.1684860137521;
        Tue, 23 May 2023 09:42:17 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id w81-20020acadf54000000b00398031b1014sm2887905oig.26.2023.05.23.09.42.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 May 2023 09:42:17 -0700 (PDT)
Message-ID: <83f2822e-f36c-0dbf-8226-cef3dc2ba072@gmail.com>
Date: Tue, 23 May 2023 13:41:35 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2 4/4] rust: task: add `Send` marker to `Task`
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
 <20230523144418.1250547-5-aliceryhl@google.com>
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <20230523144418.1250547-5-aliceryhl@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/23/23 11:44, Alice Ryhl wrote:
> When a type also implements `Sync`, the meaning of `Send` is just "this
> type may be accessed mutably from threads other than the one it is
> created on". That's ok for this type.
> 
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> Reviewed-by: Andreas Hindborg <a.hindborg@samsung.com>
> ---
> [...]
>   
> -// SAFETY: It's OK to access `Task` through references from other threads because we're either
> -// accessing properties that don't change (e.g., `pid`, `group_leader`) or that are properly
> +// SAFETY: By design, the only way to access a `Task` is via the `current` function or via an
> +// `ARef<Task>` obtained through the `AlwaysRefCounted` impl. This means that the only situation in
> +// which a `Task` can be accessed mutably is when the refcount drops to zero and the destructor
> +// runs. It is safe for that to happen on any thread, so it is ok for this type to be `Send`.
> +unsafe impl Send for Task {}
> +
> +// SAFETY: It's OK to access `Task` through shared references from other threads because we're
> +// either accessing properties that don't change (e.g., `pid`, `group_leader`) or that are properly
>   // synchronised by C code (e.g., `signal_pending`).
>   unsafe impl Sync for Task {}
>   

Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
