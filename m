Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95CCA190
	for <patches@lists.linux.dev>; Fri, 19 May 2023 00:28:46 +0000 (UTC)
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-6ab094a7c04so1180336a34.3
        for <patches@lists.linux.dev>; Thu, 18 May 2023 17:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684456125; x=1687048125;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=g0FW87Ad2wDL1UfeV2RlzAG0cVfqHerhHQgQeOdxHK4=;
        b=WLApfqNQH/ETesilNBi6QxjO3TlZ/XBRyrkQMVK9P3pLHy8ePwx6VybPFIibyYE6P6
         mBqjA+EXm6G6UCPDLsbXxOgXoOcwBoofn4OET/dvVV1YFVfMNJEOoQ1iwFQrWclWYsxj
         NUVTg61kp/cQUGhqo2h9/+MdDouI5diQf9ih/ITMS+Nd5qLgNy0MSNbkIlVI8oMjmeaT
         /WEg6wEB/6xwYcP9kaheO6aOYtHeeuB83pNFrJvyTco4LRMwYbsmBR3UJbyoY7NgYOsv
         UFqWbcB4439XheWeRZTnSJQWGoOca+exKC6fitHmfnR8CCgvoVYs5D/HbV9sZSdnj946
         98Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684456125; x=1687048125;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g0FW87Ad2wDL1UfeV2RlzAG0cVfqHerhHQgQeOdxHK4=;
        b=RaL8ZtGmagEhwMhx8p75rhrnBt9BueZjGDlD5Skwr6zUn6xiyyyieevL0Ry9k2mIn4
         fmCg/4ZdGsM6byFJF11nkWnIfzv44E16779u5ulBR2hekEbA0ntkAR28f3gQ3bw63x2o
         y8KS6aHRuwVZYQGWSWktpm3lbamc5lzwz9XJ+aFNgaZ35q2an2zjB3dOD5wLuc5kZfXR
         axeHZfk2sHhGamWGjxh8DwS3IXs7V/UOa5hv8f/Zz5009IrObZ6wcPsT783CAcOVofPE
         z7O/xPJW5pisvuu983wse9t8ms9Eozsze3MaXHNMwygMBYNtQNnPvqZOVEmYOsLXd91h
         I/6A==
X-Gm-Message-State: AC+VfDy2FbH9vUKdVaNXXVw2WpwtVNGNkpbJlmybUJ8Row0pl1nLwoRt
	3zPQ7AypsZ8UpY3PhgAwGSk=
X-Google-Smtp-Source: ACHHUZ4aY+D9M3ZLWMlGNCruJ9dojNg3iJsmIhdgDtLKKuECuHKjpanQhyKUmpFjxxieBeb0WCZSFQ==
X-Received: by 2002:aca:2303:0:b0:383:e7c8:4000 with SMTP id e3-20020aca2303000000b00383e7c84000mr301287oie.13.1684456125715;
        Thu, 18 May 2023 17:28:45 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id x14-20020a4ae78e000000b0054c9382b871sm975602oov.12.2023.05.18.17.28.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 May 2023 17:28:45 -0700 (PDT)
Message-ID: <eaab4e67-5a29-4914-3306-b09b21c4b46a@gmail.com>
Date: Thu, 18 May 2023 11:51:40 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Subject: Re: [PATCH v1 2/7] rust: add offset_of! macro
To: Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho
 <wedsonaf@gmail.com>, Tejun Heo <tj@kernel.org>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=c3=b6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
References: <20230517203119.3160435-1-aliceryhl@google.com>
 <20230517203119.3160435-3-aliceryhl@google.com>
Content-Language: en-US
In-Reply-To: <20230517203119.3160435-3-aliceryhl@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/17/23 17:31, Alice Ryhl wrote:
> From: Wedson Almeida Filho <walmeida@microsoft.com>
> 
> This macro is used to compute the offset of a field in a struct.
> 
> This commit enables two unstable features that are necessary for using
> the macro in a constant. However, this is not a problem as the macro
> will become available from the Rust standard library soon [1]. The
> unstable features can be disabled again once that happens.
> 
> The macro in this patch does not support sub-fields. That is, you cannot
> write `offset_of!(MyStruct, field.sub_field)` to get the offset of
> `sub_field` with `field`'s type being a struct with a field called
> `sub_field`. This is because `field` might be a `Box<SubStruct>`, which
> means that you would be trying to compute the offset to something in an
> entirely different allocation. There's no easy way to fix the current
> macro to support subfields, but the version being added to the standard
> library should support it, so the limitation is temporary and not a big
> deal.
> 
> Link: https://github.com/rust-lang/rust/issues/106655 [1]
> Signed-off-by: Wedson Almeida Filho <walmeida@microsoft.com>
> Co-developed-by: Alice Ryhl <aliceryhl@google.com>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
> [...]

Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
