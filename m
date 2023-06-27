Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851B61386
	for <patches@lists.linux.dev>; Tue, 27 Jun 2023 08:38:05 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-57325434999so58971127b3.1
        for <patches@lists.linux.dev>; Tue, 27 Jun 2023 01:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687855084; x=1690447084;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZX1lTnuqVI3xAbN0fkRezsoOIB0K6fV+WnbtqyeDXzY=;
        b=NKcD/UfQpGef7fdG3Tncm/U34Ba3BIuBrO0YDK445gyZQVjIL/6eUBqRmFl8t0vS/s
         c+Lkpdamq7kXAJasvS1boxlS4oEC4i8uvpZ3+Iee1hyKcQmLXyAIWDKmOfUHJLieaYsa
         o7Rsc1rnc/8w3lXhV9mMCOiS5gNBgSEEDcoNMTlXcP2d1ILVJXZbXRmkv8a7/HXV0PFX
         uqnuARTlCnK4ui11KrIKZhbF3bM92C+b/D/D6PX6dz1P19awu1TUX8O+5vXX8vtD0U/S
         wovBmhW7jVUbVYX88X/dtseKjkz6PUxwBB0bvVR+Se/V/MFWahX7DB88KGYdy4A1uMye
         IY3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687855084; x=1690447084;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZX1lTnuqVI3xAbN0fkRezsoOIB0K6fV+WnbtqyeDXzY=;
        b=RJXsmwX7+SfPnRV4kJX2LQc0bOImS4fogE7BhL0ZOui2G06epo8U2SrL1YNAXQDUfo
         QofL8oosTNujLxp1s8noRZODFui23W/THO/o/wFUniautBOWDUG5PX3Kx8NBkXYMI6Xu
         q7k4xHZ7fjF2rczqesGA39UrThwrV2+zD2q6asCLbu8LEhs1csb2GOY8vju/8fxntcGg
         WL5TLU2rJ2MmEHMApbYS2yWwqfUifdYXrBpIXr1OMO91rWG8y6OEgiyVblSV+E4P7GWD
         hdEh6vRPwgewg8ONXUgaLBEpbjD+adOewwmitlv9QS6xCcxrzVIZMOcF5TQNpjZ/8xIw
         CfoA==
X-Gm-Message-State: AC+VfDyZ5JLskUlD+LxIt+TI4BzsO9qF596aAj7nN1Gg7csVj2ycW2p+
	oKZxJz9Wb6eAZaLMiQZB/dI+8caUycmLpws=
X-Google-Smtp-Source: ACHHUZ7sJFtiw5uGwhdVMFxKYmXzmNFpEiedpDpJFFo2lYQOaQ0104CTQKmue7tZvryVzKj88m1TeFAxt/7aCus=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a25:d886:0:b0:bc4:5077:f59e with SMTP id
 p128-20020a25d886000000b00bc45077f59emr14311498ybg.13.1687855084298; Tue, 27
 Jun 2023 01:38:04 -0700 (PDT)
Date: Tue, 27 Jun 2023 08:38:01 +0000
In-Reply-To: <kHwlRfK_EtV6I7xbaDgyCbR2Xz0cHmM4Sh_edMi-Wr0JaJNlvVEQH9ZOqWuSr5hBx6cu8nreQdIlWNrHLQ6ehUT4hWtgBalWeQpcVVlBOQ0=@proton.me>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <kHwlRfK_EtV6I7xbaDgyCbR2Xz0cHmM4Sh_edMi-Wr0JaJNlvVEQH9ZOqWuSr5hBx6cu8nreQdIlWNrHLQ6ehUT4hWtgBalWeQpcVVlBOQ0=@proton.me>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230627083801.1737103-1-aliceryhl@google.com>
Subject: Re: [PATCH v2 8/8] rust: workqueue: add examples
From: Alice Ryhl <aliceryhl@google.com>
To: benno.lossin@proton.me
Cc: alex.gaynor@gmail.com, aliceryhl@google.com, bjorn3_gh@protonmail.com, 
	boqun.feng@gmail.com, gary@garyguo.net, jiangshanlai@gmail.com, 
	linux-kernel@vger.kernel.org, ojeda@kernel.org, patches@lists.linux.dev, 
	rust-for-linux@vger.kernel.org, tj@kernel.org, wedsonaf@gmail.com
Content-Type: text/plain; charset="UTF-8"

Benno Lossin <benno.lossin@proton.me> writes:
> On 01.06.23 15:49, Alice Ryhl wrote:
>> This adds two examples of how to use the workqueue. The first example
>> shows how to use it when you only have one `work_struct` field, and the
>> second example shows how to use it when you have multiple `work_struct`
>> fields.
>> 
>> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> 
> Reviewed-by: Benno Lossin <benno.lossin@proton.me>
> 
> I really like that you added these examples!
> Is there some particular reason you decided to not use
> 0 as the first index in the second example? (you can keep
> it this way)

In my head, it felt more natural for the first field to be called 1 and
the second field to be called 2. But it doesn't really matter which
numbers you use.

Alice

