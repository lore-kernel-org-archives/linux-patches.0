Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 831F15258
	for <patches@lists.linux.dev>; Wed, 17 May 2023 09:59:18 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5618b2341d9so7338877b3.2
        for <patches@lists.linux.dev>; Wed, 17 May 2023 02:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684317557; x=1686909557;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=J+riL/nvu1twHwHqCACNcwNJex8EunROGCv0pZTyq3c=;
        b=3SFYtDlzFGF0m5RFD90h5jV9WZN4ZQwsCYqL/L/KzsZpuhNTLNtc4NH8KkUmRUjhHw
         yU+/GY4lHVLt8d1eTEBvKc6iGCGTvz6I045YZE8Ng2XHGgSWo+1d0F2TwuhQuaeomJDH
         i/6cV5XiGTYvBIxkfd7/+PUO2skxtNeaGRppfUZYo2OsYGRYf/AbtvCjVoszYi4K7rMv
         NyCLauJl4qVfLHNz0jiJglxu5L01hZP5yijMYDdXMXBUcLgeVuKltS5XBDCm6fa/qfAn
         Dbzm2INF6PUBvWIX8Q1PMEbamATl0vdm0foAco2RbUnHFx4WCbE6oar+BGe9b+EwsDiJ
         KJ+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684317557; x=1686909557;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J+riL/nvu1twHwHqCACNcwNJex8EunROGCv0pZTyq3c=;
        b=lWLaC9VY5EDU2GjrD4sIW4xAMjUGY1dn9po/IpyvEGKVh4zIUXxXzUGcfhKrnu4Xyx
         gaw8N29G0lR5fmUfjPg85+PWvCcHgLgBJveP40cL1PRPbdnYIQkHh+B4yE/gc2vcUwAh
         9JmRg0Ev+Vno4m+6aGQy3P+nJqz2orcJ1765kAzZqfuY9Flvt7KH3Q+cfJJSnzHy/duT
         wf74XhCB4f7wJasQPCIEel4dVgBoJ3JBxzSTyr6NxNErthy0bcfeb5NvSyWoy/FramtK
         mAyGzVXJzqzfsIn5aRFEvnuABAsJtGt4LctvoP6s80szlbQPrspGezDzuLi0FfF3+kWi
         DJHw==
X-Gm-Message-State: AC+VfDytbu3Abc4ns8umBGbJPMv2o1Z3sjM9J+HsW0sn68wcw1Ablxo6
	ILuuw4bKjPmc41hjKo2kGExTpbp2TTGUmZ8=
X-Google-Smtp-Source: ACHHUZ60EDILvcrgq8I5bNFxfKYG43DpQ8rRj9CmpjDxgovsZUytRTZqwAp2m8+fTB4YrFpINFTOmK2/L+22Ghk=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a81:400c:0:b0:560:c30c:75f7 with SMTP id
 l12-20020a81400c000000b00560c30c75f7mr15720009ywn.2.1684317557527; Wed, 17
 May 2023 02:59:17 -0700 (PDT)
Date: Wed, 17 May 2023 09:59:05 +0000
In-Reply-To: <20230517095905.3548100-1-aliceryhl@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230517095905.3548100-1-aliceryhl@google.com>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230517095905.3548100-2-aliceryhl@google.com>
Subject: [PATCH v1 2/2] rust: task: add `Send` marker to `Task`
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

When a type also implements `Sync`, the meaning of `Send` is just "this
type may be accessed mutably from threads other than the one it is
created on". That's ok for this type.

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
 rust/kernel/task.rs | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/rust/kernel/task.rs b/rust/kernel/task.rs
index 526d29a0ae27..4f1fe9aa9f6e 100644
--- a/rust/kernel/task.rs
+++ b/rust/kernel/task.rs
@@ -64,6 +64,11 @@ macro_rules! current {
 #[repr(transparent)]
 pub struct Task(pub(crate) Opaque<bindings::task_struct>);
 
+// SAFETY: The only situation in which this can be accessed mutably is when the refcount drops to
+// zero and the destructor runs. It is safe for that to happen on any thread, so it is ok for this
+// type to be `Send`.
+unsafe impl Send for Task {}
+
 // SAFETY: It's OK to access `Task` through references from other threads because we're either
 // accessing properties that don't change (e.g., `pid`, `group_leader`) or that are properly
 // synchronised by C code (e.g., `signal_pending`).
-- 
2.40.1.606.ga4b1b128d6-goog

