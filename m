Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 379D753A0
	for <patches@lists.linux.dev>; Fri,  2 Jun 2023 08:32:29 +0000 (UTC)
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-9737cde2ce8so221567366b.1
        for <patches@lists.linux.dev>; Fri, 02 Jun 2023 01:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685694748; x=1688286748;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UCvZzCkceHQLAgJOLe2xH1CLoNBzC2CyR2ZyQ8lcY28=;
        b=vMeWSqL3Od3di5QPH5Kan+qcApYKF+tB2LUmi5cBJpdaXtIajcgcY82pUCGxV9/E9O
         l83Mia6kVBsNnWW0gUN41tYRkgJuhByMib9C3r3rLzUkhd5czH8LspvHQEIJt8BGG/El
         3wIjVe+m7HziZNlCGORm1zCQoSBxp846WS1T0sSDEyiwufOhu5+H0aPT4m+bnN48QcOP
         mf6gQgXakNuZxlD66VCC7zYACTumfAIRWf42SNIIh9Em5JxCoFThclfGUAlgRoNsC9Mu
         CDA2S83mEM1Jn6zR7QM6ej0NxRGuMJlhffn7/3+qnABZges3Sxykx7RFJ1JJ3QyNbvdF
         PxuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685694748; x=1688286748;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UCvZzCkceHQLAgJOLe2xH1CLoNBzC2CyR2ZyQ8lcY28=;
        b=gvRoxdeQavT1vhZp1KQyh7WcvEQ3GQWwS6/KkZ1hSghpSkoCC2G54X/5x/9GAkoCCu
         JAiXydaE2qM5k0IwcpLkn5GgB1Se0fU2W5iIq7PgwKBj/xap42G6CiaQye7pQE9M8RBf
         eo17TGn24A7bR/sxAW6e3xkl0YjipT1EXji6KVqeXbfHmsad5kuBlNGP9oh2E302wNjt
         +WSlwfj6YE8nb+Al1f4fY7WKLJ78Ez/zOkx0oKgc/sBCNAvI+HVwqIqSy2sqSQxWETik
         A52NO/2FgVrRJiBvUsBAHt8g8ZAYSTYTWh/AQ7dhNXjTpasXmlaAC+rqj3jiQJofQ3pN
         bkUQ==
X-Gm-Message-State: AC+VfDxzkd4G6avCK/LWKr1kbyXwE8RFESOGcWFP+v6xLPBTC6hUuzUl
	peQMc+r7Aj+hgQn3onoUOCSVrQ0g/wmv2wo=
X-Google-Smtp-Source: ACHHUZ6zF59pjH4cZ+4lTs/BOFGMVHIV1FDOPjf1rZP8tce1rNk0I9uT+7UxQeB08cq3R/FFSW8QgcsRPG1tS/Q=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a17:907:2cd5:b0:96f:5028:76e3 with SMTP
 id hg21-20020a1709072cd500b0096f502876e3mr1631473ejc.1.1685694748236; Fri, 02
 Jun 2023 01:32:28 -0700 (PDT)
Date: Fri,  2 Jun 2023 08:32:25 +0000
In-Reply-To: <20230601183002.237a31fa.gary@garyguo.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230601183002.237a31fa.gary@garyguo.net>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230602083226.1034597-1-aliceryhl@google.com>
Subject: Re: [PATCH v2 4/8] rust: workqueue: define built-in queues
From: Alice Ryhl <aliceryhl@google.com>
To: gary@garyguo.net
Cc: alex.gaynor@gmail.com, aliceryhl@google.com, benno.lossin@proton.me, 
	bjorn3_gh@protonmail.com, boqun.feng@gmail.com, jiangshanlai@gmail.com, 
	linux-kernel@vger.kernel.org, ojeda@kernel.org, patches@lists.linux.dev, 
	rust-for-linux@vger.kernel.org, tj@kernel.org, walmeida@microsoft.com, 
	wedsonaf@gmail.com, yakoyoku@gmail.com
Content-Type: text/plain; charset="UTF-8"

Gary Guo <gary@garyguo.net> writes:
> On Thu,  1 Jun 2023 13:49:42 +0000
> Alice Ryhl <aliceryhl@google.com> wrote:
>> From: Wedson Almeida Filho <walmeida@microsoft.com>
>> 
>> We provide these methods because it lets us access these queues from
>> Rust without using unsafe code.
>> 
>> These methods return `&'static Queue`. References annotated with the
>> 'static lifetime are used when the referent will stay alive forever.
>> That is ok for these queues because they are global variables and cannot
>> be destroyed.
>> 
>> Signed-off-by: Wedson Almeida Filho <walmeida@microsoft.com>
>> Co-developed-by: Alice Ryhl <aliceryhl@google.com>
>> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
>> Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
> 
> This looks fine to me, so:
> 
> Reviewed-by: Gary Guo <gary@garyguo.net>
> 
> Just one question about style: would people prefer:
> 
> 	kernel::workqueue::system().enqueue(...)
> 
> or
> 
> 	use kernel::workqueue::Queue;
> 	Queue::system().enqueue(...)
> 
> ?

I prefer the first version.

Alice
