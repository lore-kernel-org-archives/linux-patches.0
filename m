Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D5F7E
	for <patches@lists.linux.dev>; Mon,  4 Sep 2023 00:29:28 +0000 (UTC)
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-1ccb6a69b13so865760fac.2
        for <patches@lists.linux.dev>; Sun, 03 Sep 2023 17:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693787367; x=1694392167; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gy5Sjqdfk2V0r51PCTu3C9haVoBFcraAmneb4UVU19U=;
        b=Eux0VvYYCzImm6x0Lo0FJmCilf0deDjPfnxExJLSKADcNL1fagNjW0to+DuWR6FLog
         qh/prNIHEdmgiu5/7jsXxpbbpGmZ9CeWz78I0NrkyKNf4v7ehKZpLIbyUwwuqAFBGQ8U
         d5CNqQPRZ1bgJpp/2Mk5RQTcwwQIpbFCC3iV/G13VGbp+1q+WCQB4QtoyhZEt7Zo5vuj
         7P8XDHUPmzkrUkv/OG3p+p7ov7+bMwiL+OKKr7HUxkAtHxoNqDEj2WU/OWmcfbz3a8Y0
         ju6F5wUQQZbgmR+fEP9xqd18URmE8aohxIj2whNMLjBeTXbkke1kTjdSjNA80RvMO/jL
         n7fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693787367; x=1694392167;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gy5Sjqdfk2V0r51PCTu3C9haVoBFcraAmneb4UVU19U=;
        b=fploTscLWhOfIGWMQnzOfMPmnwRZWIxwcYQVHduSVS0OQ7mlQeANwgZfCmmpnPihYf
         tvAj/dfE5l+91PBqU0fuGZqgiw0uBvSEoBAGJ4+SVYD7Phqe84ZEky3ls/wEN5ISUre7
         QAWZZX3Lf8CHP5jlY8lvjc2PWFAcJEU5ej29lsQe94qzbANuwlrHAoPGxXr3e91BApPG
         yVsSIwircBObXGx2LxGc+xHAHF3TQ5jJRRHxADkMW/nrqzoGKZsB2FjzcQ+mlRNseTGO
         5IbnWBWZhOjdBe3nnM6OmVG88esyIVNZDb2J8MMoe/+/r2JBho52sQHZi32JsXipJnfn
         TGUQ==
X-Gm-Message-State: AOJu0YyAm4AZbAjVI4bMPgQOEoQSYHmujkr4iVYrQcjxy2IGacpv8HAh
	0WXZ3xTdD2SkisES79EPc3A=
X-Google-Smtp-Source: AGHT+IGCDuOU6ZKDHAMJN3qwCQh0SSLDaW3mcfd+gdvDCLJaKZCieOBaxDqBhoVMKwSfvXgOteXNeQ==
X-Received: by 2002:a05:6871:720:b0:1b3:9e41:de07 with SMTP id f32-20020a056871072000b001b39e41de07mr11773582oap.36.1693787367366;
        Sun, 03 Sep 2023 17:29:27 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id eb49-20020a056870a8b100b001c4d922b4fasm4860255oab.8.2023.09.03.17.29.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Sep 2023 17:29:26 -0700 (PDT)
Message-ID: <8de45c09-cb53-4a18-a6f3-56a16553ae32@gmail.com>
Date: Sun, 3 Sep 2023 21:29:21 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/7] rust: workqueue: add helper for defining
 work_struct fields
To: Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org,
 Tejun Heo <tj@kernel.org>, Miguel Ojeda <ojeda@kernel.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>,
 Wedson Almeida Filho <wedsonaf@gmail.com>,
 Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20230828104807.1581592-1-aliceryhl@google.com>
 <20230828104807.1581592-5-aliceryhl@google.com>
Content-Language: en-US
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <20230828104807.1581592-5-aliceryhl@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/28/23 07:48, Alice Ryhl wrote:
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
