Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD3B7C
	for <patches@lists.linux.dev>; Fri, 19 May 2023 00:29:02 +0000 (UTC)
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-19615d6ef9eso2120934fac.0
        for <patches@lists.linux.dev>; Thu, 18 May 2023 17:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684456141; x=1687048141;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aDDGhb2tP3weqUqGG82IgcfaUKcieKnb282RlrBpvQU=;
        b=Byy52s7YiQhc7aLKZrpXOblT/FGqzVIjsqC3ILab2cJF5ap8JRenYERpxX+po9pyuJ
         sdSLu1krHqbEFTSQ6IOmwh7FUgQ7BTbKqEpfigaqsSiqdpsaZxQJqtBK6Yl8ZTatVnK9
         q/QiX8r0SaRtdi4suPa8SZGfOZMSgZQj5LHERZhsq5rWUYCMtdPK29SDKVmANX5K4U7c
         eDn7fLVZMLIa8yOyx7RgD/VreWCqyFp0yoQc0DYs1QUkSeVto8kQSnnhiQiWebGe/SzT
         UyD9vyvdYT/tMT7zzL5d9K3NiPs6ZEGRjA0nrB3uttA0+gcw6aPPHUweM0VFqCg8HnfF
         hZvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684456141; x=1687048141;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aDDGhb2tP3weqUqGG82IgcfaUKcieKnb282RlrBpvQU=;
        b=VLfOTqmxY85L2izy31HlsjfL0oO8G5LaZI9MtsSkEnaevIEQf3aqKktdihTS3l45cK
         xwtM+WYjOXZqhVbXiC6MWgU6sPnPTVNMALBDKV0zFIBKzCIyFWfM0dq3Id3v0DcVDLXJ
         3Aw250lt+4qMFKkAjj1XrEtpv0kKKZfkuVgFlA3f/UJrleOA55m5L++T0UJTbHBobyuN
         kPetMrXGloVu8QfoTy58OIoZ7bYP9Q4ZfR5qTfii6H6vIrYCdFI5xC9EINz5wmp71cOE
         u3tiEog1AEusroUohWAs8dWPX6sZOe2L7N+elboNNaSLM5Nl5WGj3Bx2ypNeYNTDOI4u
         l3CQ==
X-Gm-Message-State: AC+VfDwrRwPlV5qx4WDDVUOD0VU6FpVw8hy3A2PRozLOndYkr+I9lsl9
	85X/3Ib8/GL4xj1jMyZJPpc=
X-Google-Smtp-Source: ACHHUZ4U+xZ+vqs7U0w4Iqbls0uuY33cIaeXPyACjkhJUWJ5J/uRkbAua7xSsY1HehroT7UGDLAcXg==
X-Received: by 2002:a05:6870:702a:b0:187:dbb8:f5fc with SMTP id u42-20020a056870702a00b00187dbb8f5fcmr277067oae.35.1684456141266;
        Thu, 18 May 2023 17:29:01 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id q7-20020a056870028700b0019a291d1672sm1392042oaf.26.2023.05.18.17.28.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 May 2023 17:29:00 -0700 (PDT)
Message-ID: <cfbc1af4-d099-73c0-3b8e-91c3ae98f783@gmail.com>
Date: Thu, 18 May 2023 20:18:54 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v1 5/7] rust: workqueue: add helper for defining
 work_struct fields
Content-Language: en-US
To: Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho
 <wedsonaf@gmail.com>, Tejun Heo <tj@kernel.org>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=c3=b6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
References: <20230517203119.3160435-1-aliceryhl@google.com>
 <20230517203119.3160435-6-aliceryhl@google.com>
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <20230517203119.3160435-6-aliceryhl@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/17/23 17:31, Alice Ryhl wrote:
> The main challenge with defining `work_struct` fields is making sure
> that the function pointer stored in the `work_struct` is appropriate for
> the work item type it is embedded in. It needs to know the offset of the
> `work_struct` field being used (even if there are several!) so that it
> can do a `container_of`, and it needs to know the type of the work item
> so that it can call into the right user-provided code. All of this needs
> to happen in a way that provides a safe API to the user, so that users
> of the workqueue cannot mix up the function pointers.
> 
> There are three important pieces that are relevant when doing this. This
> commit will use traits so that they know about each other according to
> the following cycle:
> 
>   * The pointer type. It knows the type of the work item struct.
>   * The work item struct. It knows the offset of its `work_struct` field.
>   * The `work_struct` field. It knows the pointer type.
> 
> There's nothing special about making the pointer type know the type of
> the struct it points at. Pointers generally always know that
> information.
> 
> However, making the `work_struct` field know about the pointer type is
> less commonly seen. This is done by using a generic parameter: the
> `work_struct` field will have the type `Work<T>`, where T will be the
> pointer type in use. The pointer type is required to implement the
> `WorkItemAdapter` trait, which defines the function pointer to store in
> the `work_struct` field. The `Work<T>` type guarantees that the
> `work_struct` inside it uses `<T as WorkItemAdapter>::run` as its
> function pointer.
> 
> Finally, to make the work item struct know the offset of its
> `work_struct` field, we use a trait called `HasWork<T>`. If a type
> implements this trait, then the type declares that, at the given offset,
> there is a field of type `Work<T>`. The trait is marked unsafe because
> the OFFSET constant must be correct, but we provide an `impl_has_work!`
> macro that can safely implement `HasWork<T>` on a type. The macro
> expands to something that only compiles if the specified field really
> has the type `Work<T>`. It is used like this:
> 
> ```
> struct MyWorkItem {
>      work_field: Work<Arc<MyWorkItem>>,
> }
> 
> impl_has_work! {
>      impl HasWork<Arc<MyWorkItem>> for MyWorkItem { self.work_field }
> }
> ```
> 
> So to summarize, given a pointer to an allocation containing a work
> item, you can use the `HasWork<T>` trait to offset the pointer to the
> `work_struct` field. The function pointer in the `work_struct` field is
> guaranteed to be a function that knows what the original pointer type
> was, and using that information, it can undo the offset operation by
> looking up what the offset was via the `HasWork<T>` trait.
> 
> This design supports work items with multiple `work_struct` fields by
> using different pointer types. For example, you might define structs
> like these:
> 
> ```
> struct MyPointer1(Arc<MyWorkItem>);
> struct MyPointer2(Arc<MyWorkItem>);
> 
> struct MyWorkItem {
>      work1: Work<MyPointer1>,
>      work2: Work<MyPointer2>,
> }
> ```
> 
> Then, the wrapper structs `MyPointer1` and `MyPointer2` will take the
> role as the pointer type. By using one or the other, you tell the
> workqueue which `work_struct` field to use. This pattern is called the
> "newtype" pattern.
> 
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
> [...]

Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
