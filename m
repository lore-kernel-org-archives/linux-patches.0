Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D59BA2E
	for <patches@lists.linux.dev>; Mon, 17 Jul 2023 13:53:14 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-c5cea5773e8so4515583276.1
        for <patches@lists.linux.dev>; Mon, 17 Jul 2023 06:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689601994; x=1690206794;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7a5j4gvhnG5mrdZ/F4z3dJKPADNbpn8JJt+6WIEe8sU=;
        b=lK2MzwZAd8EF2hJ82Wrids5Yon9GdRQhhNLfZ2ksqHpFJYE6J0xTMaiMwll8uAghz1
         Q62+KB6AQNgPBSOKx8vtCAfk+h9fYbT/aJZn/4nhnPfduu7vlXDMKEg4WyZZ2FFixDoq
         oDgqbcwo0gIXZODKkk4NXKi3u+mZG5rGW28+W2IGOYejqkl9UHoT9i6jCSgrXCkd4SPQ
         i6d91L8Htl5aAkcJmprFUFouxpSIdoRyLSnLuX0qBZr0vhnT4QEuUyzkpgeOOV2dHqBb
         5gTDJFFnbQho1EeFjkMi82uQfx7G3caOKn/DQAw/gzC/yuy69GoBodepUdF460PeP/1Z
         CrYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689601994; x=1690206794;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7a5j4gvhnG5mrdZ/F4z3dJKPADNbpn8JJt+6WIEe8sU=;
        b=Ifqg0EdUoSjRFfwysVRKrJqyz+qYCFX8RqoWoPr+sezJKxCM/hB1nadQ1QrkybFiMh
         EKswckyfjgjZTPONOC/lEy/bC8kyw0s2d9Tm9Gl/G5W/U0ARWWjQiM6RM4DeOIqDq4Da
         1fTpVQ70hVD0ZKQinvm6FiqSiKbgI08yTQO0DozVzjGs80gDI73S1F2+nMT1riUfQYrL
         RkH35HmNK9yA6SjOue4hFQG8cZeagBEhwPfAtwPiQJPO4AJVVeAcbgKWe5i2ui340NFj
         s2MYHbvtLdab3YM99ur6CYLtHXL4pMBUy2i3FTBHVxEQ44jcW7gMwLhymZU/G1kCiECd
         7Npw==
X-Gm-Message-State: ABy/qLZWjxHViDv7xUBmg5vOGRTcbli39AT9Jc5yOPf/Vg6lzCR3xd+5
	E0dIZsuiIogCy+4uFEn1u/Xt9bGd1rMhBlc=
X-Google-Smtp-Source: APBJJlFqfJxS9tr9kwuqTLxh56qQM4RllSCU5YzQj4nW0duV/3DgusRHSW5nZK7P7bx+oV8x7DiAddAcyBASxqQ=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a25:2556:0:b0:c22:38c2:43de with SMTP id
 l83-20020a252556000000b00c2238c243demr96482ybl.11.1689601993768; Mon, 17 Jul
 2023 06:53:13 -0700 (PDT)
Date: Mon, 17 Jul 2023 13:53:11 +0000
In-Reply-To: <ZK3WUBTb1dHfjnh8@boqun-archlinux>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <ZK3WUBTb1dHfjnh8@boqun-archlinux>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230717135311.1841165-1-aliceryhl@google.com>
Subject: Re: [PATCH v3 4/9] rust: workqueue: add low-level workqueue bindings
From: Alice Ryhl <aliceryhl@google.com>
To: boqun.feng@gmail.com
Cc: alex.gaynor@gmail.com, aliceryhl@google.com, benno.lossin@proton.me, 
	bjorn3_gh@protonmail.com, gary@garyguo.net, jiangshanlai@gmail.com, 
	linux-kernel@vger.kernel.org, nmi@metaspace.dk, ojeda@kernel.org, 
	patches@lists.linux.dev, rust-for-linux@vger.kernel.org, tj@kernel.org, 
	wedsonaf@gmail.com, yakoyoku@gmail.com
Content-Type: text/plain; charset="UTF-8"

Boqun Feng <boqun.feng@gmail.com> writes:
>> +// SAFETY: Kernel workqueues are usable from any thread.
>> +unsafe impl Send for Queue {}
>> +unsafe impl Sync for Queue {}
> 
> I don't think "usable from any thread" is the accurate wording here, it
> sounds to me that there are types that cannot be used for a particular
> type of threads ;-)
> 
> Maybe
> 
> 	// SAFETY: Accesses to workqueues used by [`Queue`] are
> 	// thread-safe.
> 
> ?

Sure, I'll make that change in the next version.

Alice

