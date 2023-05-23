Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C026C4C7B
	for <patches@lists.linux.dev>; Tue, 23 May 2023 14:44:26 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-ba8338f2103so13585962276.1
        for <patches@lists.linux.dev>; Tue, 23 May 2023 07:44:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684853065; x=1687445065;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yPN2BpzOKR7Rs0wxh0Zdg1UkwhhxDvNrZrq1CaLSSZQ=;
        b=B7M4fxocDWncwNJOfecUOc8pS/sCVvN9OXU6KGy4jrD0ZzyajwUU2BDl1AikpLbEIh
         KSyWuw2wF3Cp5ZRDPAOaiNnn80ftEkOCAg6a8n6b/cDc1+ruQaE7BFWieqx7Nfaxbl0P
         rrLSe/jYHNRr2mRLZym1dcwVfPvD2kjh8n6g6t0mXyWe/MTU+l6gMqEr7LaZ0wzSSgAj
         B+OSQ+yfQ3ugA56jl33nP5KbTNVE9BYVwjP3ma/9YBy3U9UnKSnGtW6OFJ7o3R5PZQVa
         pCZJoHuoOremB/BNh1N8aKjD3J+eUzUl3Ki58VQbA2V7tURIp2lwdAWPe7HUBMUp1RI7
         hJQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684853065; x=1687445065;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yPN2BpzOKR7Rs0wxh0Zdg1UkwhhxDvNrZrq1CaLSSZQ=;
        b=AfEOcIyY+GyR11VpvpqLc8iokVx4KyCibQ/Rogwcj3xq0vLqxyqOY6LiBIZD16Zdyk
         dAYNhJTCq6mlMBjp6i9nMNy5zF2f4rRkXpl0BfCynyRKIIUhqmlf3btgcGrskEeHypJd
         NVqPZaupRmgxWZv7kMreYivS36sWMYkUdFhZqZn3/nO6gYP6W7NZzSXG/riSJDbfANsM
         mAJ1wdg/SMvn+8efRdx3lG/JnSoFTTi4qeZYn/gQOXLaZ8hLBdcgk1K2YGtykqe6SpF0
         CaEjRDLFbAewh3J6O8ZR/hjsKU3nq+Tu6CkFipmDrDRmOJaFB0YhH5R8J/jwvea+Gzee
         SfvA==
X-Gm-Message-State: AC+VfDxyRVmsSz7mCREsVuSPhO1AyPFt9XKp0+2Z2/0C2I8cc2h3cXj6
	xRoSDNJL8ns0Wfg5mlKS4LcQ6BSKtHp5U58=
X-Google-Smtp-Source: ACHHUZ656OnC2srdDMtzUpWdENlFVaUBI5YJEFeGiZxbSyebkOl0dnFJTs2fWDoVRQLUxZB9CaeyTKcu1gllt+0=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a05:6902:1895:b0:ba8:4ba3:5b54 with SMTP
 id cj21-20020a056902189500b00ba84ba35b54mr6433268ybb.11.1684853065789; Tue,
 23 May 2023 07:44:25 -0700 (PDT)
Date: Tue, 23 May 2023 14:44:14 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
Message-ID: <20230523144418.1250547-1-aliceryhl@google.com>
Subject: [PATCH v2 0/4] Update thread safety markers
From: Alice Ryhl <aliceryhl@google.com>
To: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>, 
	Alice Ryhl <aliceryhl@google.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

In Rust, the `Send` and `Sync` traits are used to mark in what ways a
specific type is thread safe. In this patch series, I add some missing
thread safety markers and improve the documentation related to them.
This change will let you compile some code that would currently fail to
compile even though it doesn't actually violate any thread safety rules.

You can find a definition of what these marker traits mean at [1].

[1]: https://stackoverflow.com/a/68708557/1704411

Alice Ryhl (4):
  rust: sync: reword the `Arc` safety comment for `Send`
  rust: sync: reword the `Arc` safety comment for `Sync`
  rust: specify when `ARef` is thread safe
  rust: task: add `Send` marker to `Task`

 rust/kernel/sync/arc.rs | 12 +++++++-----
 rust/kernel/task.rs     | 10 ++++++++--
 rust/kernel/types.rs    | 13 +++++++++++++
 3 files changed, 28 insertions(+), 7 deletions(-)


base-commit: ac9a78681b921877518763ba0e89202254349d1b
-- 
2.40.1.698.g37aff9b760-goog

