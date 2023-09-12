Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A4C23A6
	for <patches@lists.linux.dev>; Tue, 12 Sep 2023 05:14:49 +0000 (UTC)
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-99c3d3c3db9so686278766b.3
        for <patches@lists.linux.dev>; Mon, 11 Sep 2023 22:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694495687; x=1695100487; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZyqIIsunQYTKSmZgrrp/lV4JAtUjhb5FezapOWZ1nds=;
        b=lGad3s5R4ejdvfcWafvrWkrVuytd5xt0Mep9Zs/3+4iOoXJx6auuCcTQh8/8VlVlzs
         m2XBiacAV5R/EkXZI+NByIO0ikfBFboZOHaJLwQ9UU/U4krZtjllKD9HCB+CqceqV4kH
         TTYgeANnf6+fmRBkRzWkgYIPZNWfVDj10AYaJ3COv1tAlNaPO8B7oj6mWARNCxb794Mg
         DOK6T4mN6bvGIqi5J2JXliK/qOg/PYwjFFrMN69FYC42uOB75Aamtb1Xb39CAWcprd38
         ZdTb73SKL+08+Fso0TjTLdclkwjF+2QUP+jRo1ujmkV2xRGT2KzuA1te/NOwT8Yxn717
         wVjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694495687; x=1695100487;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZyqIIsunQYTKSmZgrrp/lV4JAtUjhb5FezapOWZ1nds=;
        b=FPc7p1+81crtojEqg4eBg2euuhgVwprQnFFZeTm80O7r21CwxtNycIshFIird7pNJF
         RcL6blylJ6OOzqaJPPOQj30pnh49yUcmDZZH/dN9OdLsuixOCC9jyMNkbLhpU+7binoc
         dgUFOguXQKxOC0B1rW8hPycFlkyEUqvgF3qfo7FLp4njd/1z0RC4IfAzsMjvJynhkitZ
         N9lC1t1vxDpT2bJEKgJT0RrI00p1+1GjH83oep7Vy3Oy29fVm5ucsr0Sse2KO0VYHG/v
         xt27DOK4SAcrPcOlBhkHdn5OqLcpXW/QjIdYFuAaGanezsjbZvonq1B+OSBJUY1/7259
         2Tvw==
X-Gm-Message-State: AOJu0YxkMk+Z4gktBSRg1/tlcpCBP6z6roBr+Anz62rbFANsVR7jzy/l
	w5x5uBWwTczONUfadKqlB9M=
X-Google-Smtp-Source: AGHT+IFv/3bDs9+/Wsozcj7o/1ImmwL4pLK/TANqGEeXohmyJfUBXGbX7E9QLdTEXXF5EfRlTE/IlQ==
X-Received: by 2002:a17:907:7899:b0:99c:ad52:b00 with SMTP id ku25-20020a170907789900b0099cad520b00mr8755557ejc.6.1694495687343;
        Mon, 11 Sep 2023 22:14:47 -0700 (PDT)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id hb19-20020a170906b89300b009a1fd22257fsm6218756ejb.207.2023.09.11.22.14.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Sep 2023 22:14:46 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
	by mailauth.nyi.internal (Postfix) with ESMTP id 551CA27C0054;
	Tue, 12 Sep 2023 01:14:44 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 12 Sep 2023 01:14:44 -0400
X-ME-Sender: <xms:xPP_ZDVQjqCnqE6tvCBFg7gBHJ3Gx0d4YTFJ2eYJ1J_UOULEYfsUbg>
    <xme:xPP_ZLngeWdfEH6yTo0MHbO3HOT4ydIZb0oQGND76cI0On8_3t6_8qVns2DVCVreL
    Nty4gBm67J0zYodwA>
X-ME-Received: <xmr:xPP_ZPY8tx6JL8LxbXeV3kt0c45RfigRdu_AxMRnkQlnxecWINRJj_au8Sc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedviedrudeihedgleduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehoqhhu
    nhcuhfgvnhhguceosghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhmqeenucggtffrrg
    htthgvrhhnpefhtedvgfdtueekvdekieetieetjeeihedvteehuddujedvkedtkeefgedv
    vdehtdenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomhepsghoqhhunhdomhgvshhmthhprghuthhh
    phgvrhhsohhnrghlihhthidqieelvdeghedtieegqddujeejkeehheehvddqsghoqhhunh
    drfhgvnhhgpeepghhmrghilhdrtghomhesfhhigihmvgdrnhgrmhgv
X-ME-Proxy: <xmx:xPP_ZOVkdYD9jAY7PwHPTMmrJfTVyNl51Vnrib7n_ELMl03hd4esxQ>
    <xmx:xPP_ZNl3AQCafge42uT9S1U3RP-ksycvV95Fb_zXViSQdVftuLXHdw>
    <xmx:xPP_ZLeZP31AVoC6HrFrML_K2kPLcg0YsBlvGXtIc5MG4WTds9ikzA>
    <xmx:xPP_ZDeI29Frbg1PXQ5xZ7SmbJZUSqqOVqduN3s8qDMgkQEVw7PGLw>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 12 Sep 2023 01:14:43 -0400 (EDT)
Date: Mon, 11 Sep 2023 22:14:41 -0700
From: Boqun Feng <boqun.feng@gmail.com>
To: Alice Ryhl <aliceryhl@google.com>
Cc: rust-for-linux@vger.kernel.org, Tejun Heo <tj@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v4 0/7] rust: workqueue: add bindings for the workqueue
Message-ID: <ZP_zwc6UuirLSstf@Boquns-Mac-mini.home>
References: <20230828104807.1581592-1-aliceryhl@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230828104807.1581592-1-aliceryhl@google.com>

On Mon, Aug 28, 2023 at 10:48:00AM +0000, Alice Ryhl wrote:
> This patchset contains bindings for the kernel workqueue.
> 
> One of the primary goals behind the design used in this patch is that we
> must support embedding the `work_struct` as a field in user-provided
> types, because this allows you to submit things to the workqueue without
> having to allocate, making the submission infallible. If we didn't have
> to support this, then the patch would be much simpler. One of the main
> things that make it complicated is that we must ensure that the function
> pointer in the `work_struct` is compatible with the struct it is
> contained within.
> 
> The original version of the workqueue bindings was written by Wedson,
> but I have rewritten much of it so that it uses the pin-init
> infrastructure and can be used with containers other than `Arc`.
> 
> This patchset depends on the patch [1] that changes `Opaque` to be
> `!Unpin` for correctness. The patchset is based on the rust-6.6 tag,
> since that tag includes that patch.
> 
> Changes v3 -> v4:
> 
>  * Use `offset_of!` macro from standard library, and drop patch with
>    custom implementation.
>  * Add name parameter to `work_struct` constructor, and drop patch with
>    __INIT_WORK_WITH_KEY.
>  * Various improvements to documentation and comments.
> 
> More detailed changelogs can be found on the individual patches.
> 

For the whole series:

Reviewed-by: Boqun Feng <boqun.feng@gmail.com>

Regards,
Boqun

> Previous versions:
> v1: https://lore.kernel.org/all/20230517203119.3160435-1-aliceryhl@google.com/
> v2: https://lore.kernel.org/all/20230601134946.3887870-1-aliceryhl@google.com/
> v3: https://lore.kernel.org/all/20230711093303.1433770-1-aliceryhl@google.com/
> 
> [1]: https://lore.kernel.org/all/20230630150216.109789-1-benno.lossin@proton.me/
> 
> Alice Ryhl (5):
>   rust: workqueue: add low-level workqueue bindings
>   rust: workqueue: add helper for defining work_struct fields
>   rust: workqueue: implement `WorkItemPointer` for pointer types
>   rust: workqueue: add `try_spawn` helper method
>   rust: workqueue: add examples
> 
> Wedson Almeida Filho (2):
>   rust: sync: add `Arc::{from_raw, into_raw}`
>   rust: workqueue: define built-in queues
> 
>  rust/bindings/bindings_helper.h |   1 +
>  rust/helpers.c                  |  13 +
>  rust/kernel/lib.rs              |   3 +
>  rust/kernel/sync/arc.rs         |  46 ++-
>  rust/kernel/workqueue.rs        | 679 ++++++++++++++++++++++++++++++++
>  scripts/Makefile.build          |   2 +-
>  6 files changed, 741 insertions(+), 3 deletions(-)
>  create mode 100644 rust/kernel/workqueue.rs
> 
> base-commit: 4af84c6a85c63bec24611e46bb3de2c0a6602a51
> -- 
> 2.42.0.rc1.204.g551eb34607-goog
> 
