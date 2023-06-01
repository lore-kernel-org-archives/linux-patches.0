Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB8C23A1
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 14:58:21 +0000 (UTC)
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-39a53c7648fso784633b6e.1
        for <patches@lists.linux.dev>; Thu, 01 Jun 2023 07:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685631500; x=1688223500;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=R3xlSxMTcF87QzSJRGtR3aRtTi9/A1XGfTJRaxTHZ/A=;
        b=fXO2nt4DOPXlgg55dIYo1i7lx9PQKx6f6Gpm0Rz30qheWnJIe4t4diKELxC+EMXRPl
         C+Noee33vW4BzAGQQlGLAFj/kgiodUXGvnpaJCSPJUXZprlzOZ9+yoSnd4suYiwwOc13
         NZ0ekwF67I6viF3BTtiZ+9w8Ir548CDqvndoLfFr7nAfIJDX3FHCY5MKoDqs2PT/JXda
         bsSrz22wG3UMqXwtHua06wYFDH/Khw8mgsBBXKGbOKVa+y0jNhUGxQHJ8qG8g9MEqzKj
         1xqW56V8/hAsI+cjrM9r5aKqX2v9wmv1mO6B6ODJDOuybd3qyWV4YPxKr6J+9vcTrWPq
         AUiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685631500; x=1688223500;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R3xlSxMTcF87QzSJRGtR3aRtTi9/A1XGfTJRaxTHZ/A=;
        b=eFDMmbYtbh+ng3sDKLL5NDyRc7zTpmCPqLS1Glrx/zz3TZImWRfKafivWqeB25OQ46
         zhwWskCtbI2Az8AtKxgJTYQt5tzdF4hilGkdJfsCLMstTQLMjNEx4Gzif3KbXL/wAwwU
         NhmZqhfyMVb6JopDd51N5gNiYzWvamq5X8AfPHbNYvfoFwNVdqQ6ignIzMgkOeMwVEah
         sPLUz2kUiusoyFcJ+0CUH6ITm+/U0PfxFoR4OKJWaTFi3pHzGOO0VWwklDe1yngX43yX
         bJHIwL56xHNH3HZuWthyoMMRRbaT3KgnplTg+LzgOU52moYu/WqT4nIoXmkTgQ2xm+0q
         QtDA==
X-Gm-Message-State: AC+VfDwwaf/HN4GP3nfIUXmNBQUWWFndkgxL1EgxHaYVMfo3jg/VA+I9
	aYF+k0ujKa9RIOeT9HjTM3I=
X-Google-Smtp-Source: ACHHUZ7CNoLcRMmNdTH38tnwna/r/qhwjihgBIYPHH3F4/5lfaci8KOua5Jzv6Hpir4E3/bCTC69rQ==
X-Received: by 2002:aca:100f:0:b0:398:50f1:ad17 with SMTP id 15-20020aca100f000000b0039850f1ad17mr7309363oiq.4.1685631500443;
        Thu, 01 Jun 2023 07:58:20 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id a19-20020a05680802d300b00397c07e8061sm1738511oid.6.2023.06.01.07.58.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jun 2023 07:58:20 -0700 (PDT)
Message-ID: <91a968e2-7c18-1bd8-84a4-b9c1eb9cca91@gmail.com>
Date: Thu, 1 Jun 2023 11:50:52 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Subject: Re: [PATCH v2 5/8] rust: workqueue: add helper for defining
 work_struct fields
To: Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho
 <wedsonaf@gmail.com>, Tejun Heo <tj@kernel.org>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=c3=b6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
References: <20230601134946.3887870-1-aliceryhl@google.com>
 <20230601134946.3887870-6-aliceryhl@google.com>
Content-Language: en-US
In-Reply-To: <20230601134946.3887870-6-aliceryhl@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/1/23 10:49, Alice Ryhl wrote:
> The main challenge with defining `work_struct` fields is making sure
> that the function pointer stored in the `work_struct` is appropriate for
> the work item type it is embedded in. It needs to know the offset of the
> `work_struct` field being used (even if there are several!) so that it
> can do a `container_of`, and it needs to know the type of the work item
> so that it can call into the right user-provided code. All of this needs
> to happen in a way that provides a safe API to the user, so that users
> of the workqueue cannot mix up the function pointers.
> 
> There are three important pieces that are relevant when doing this:
> 
>   * The pointer type.
>   * The work item struct. This is what the pointer points at.
>   * The `work_struct` field. This is a field of the work item struct.
> 
> This patch introduces a separate trait for each piece. The pointer type
> is given a `WorkItemPointer` trait, which pointer types need to
> implement to be usable with the workqueue. This trait will be
> implemented for `Arc` and `Box` in a later patch in this patchset.
> Implementing this trait is unsafe because this is where the
> `container_of` operation happens, but user-code will not need to
> implement it themselves.
> 
> The work item struct should then implement the `WorkItem` trait. This
> trait is where user-code specifies what they want to happen when a work
> item is executed. It also specifies what the correct pointer type is.
> 
> Finally, to make the work item struct know the offset of its
> `work_struct` field, we use a trait called `HasWork<T, ID>`. If a type
> implements this trait, then the type declares that, at the given offset,
> there is a field of type `Work<T, ID>`. The trait is marked unsafe
> because the OFFSET constant must be correct, but we provide an
> `impl_has_work!` macro that can safely implement `HasWork<T>` on a type.
> The macro expands to something that only compiles if the specified field
> really has the type `Work<T>`. It is used like this:
> 
> ```
> struct MyWorkItem {
>      work_field: Work<MyWorkItem, 1>,
> }
> 
> impl_has_work! {
>      impl HasWork<MyWorkItem, 1> for MyWorkItem { self.work_field }
> }
> ```
> 
> Note that since the `Work` type is annotated with an id, you can have
> several `work_struct` fields by using a different id for each one.
> 
> Co-developed-by: Gary Guo <gary@garyguo.net>
> Signed-off-by: Gary Guo <gary@garyguo.net>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
> [...]

Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
