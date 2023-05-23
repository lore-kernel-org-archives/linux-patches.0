Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14FCF4C7B
	for <patches@lists.linux.dev>; Tue, 23 May 2023 14:46:02 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-ba83fed50e1so10480261276.1
        for <patches@lists.linux.dev>; Tue, 23 May 2023 07:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684853162; x=1687445162;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=r16leosVab/uLX7D74lYCjCyQd2teI7cw9N2TnAgQsA=;
        b=Hd/uUrDISL30aYgFZm7tT9bNmVfu5Hj5bE8z8pqztEcp7fh7IokeZvyVl4+oOgQpv2
         1msJ8stWSASsldMCECBLTZSZbmB67D/T7j1oTM2DeUMplouDBShHymsHyviGEf60tBiM
         d5vZPUEHKU0E12wSNBYOP4P1NYGjDUM5j4FC2jB/qherVgJcq2o2o9Lx9KuA3cUjjFbh
         fGZSVMVBEzRtgYXzq81Yb06w9UEFGdV9cfI9x14itoTZcmT+hYvViRiWZtK/VEhv4HGE
         vpDT/Rx7Cux0WO7uyvBET3G0qLUukSAXX6k4OFRmxbn4iL0lJKuXNJeqS7trW8tXqQhC
         akzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684853162; x=1687445162;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r16leosVab/uLX7D74lYCjCyQd2teI7cw9N2TnAgQsA=;
        b=GaykksZDsrlGFHhFtueRNvGtmHGsokBaklALAcwB1Y81v+cqKQ8lg/9u3suR7wi8gi
         bEHCbypGaifLm5UCOGCDc4XXXNmsPSsAwGvj6CYWVv/sf0EFcv+WwfpszAr6Fn9tbjuu
         qWrqYtOG0dCNOqqto/qH0NBJvopucGkgtyvtu0WuiqXWinX8XkwXaSCNxXneBzu9gFV5
         0DpFM5j7NBcSFDZ5R+fltTVC6/Ji1P44Qig/fCVR+Mya9mkWajonrK4SXL6I5Kc8nmjG
         RGd9yhuOX0kf9vqnkOgR8KX+lW02VQchx35xdITWAlYTRL82Js4k4xvPVpM67s8IzdWj
         F5SQ==
X-Gm-Message-State: AC+VfDxY2wiBGq30suFPlkebEB/5FJMMBrnnWYj2eGYJfZOwB/hp42X/
	TloXgwdb6fltSjslriCDPaCJce73FcxudJc=
X-Google-Smtp-Source: ACHHUZ5GGO9M9zi95iQU/We2rgCa/AZ2NpDuHENeetlWQiYs4A5/3srhvSG4IjsY4UStilvM/k6fLMYqCtGwmFY=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a25:9989:0:b0:ba2:2d0e:a752 with SMTP id
 p9-20020a259989000000b00ba22d0ea752mr8278874ybo.6.1684853162123; Tue, 23 May
 2023 07:46:02 -0700 (PDT)
Date: Tue, 23 May 2023 14:44:18 +0000
In-Reply-To: <20230523144418.1250547-1-aliceryhl@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230523144418.1250547-1-aliceryhl@google.com>
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
Message-ID: <20230523144418.1250547-5-aliceryhl@google.com>
Subject: [PATCH v2 4/4] rust: task: add `Send` marker to `Task`
From: Alice Ryhl <aliceryhl@google.com>
To: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>, 
	Alice Ryhl <aliceryhl@google.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Andreas Hindborg <a.hindborg@samsung.com>
Content-Type: text/plain; charset="UTF-8"

When a type also implements `Sync`, the meaning of `Send` is just "this
type may be accessed mutably from threads other than the one it is
created on". That's ok for this type.

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Andreas Hindborg <a.hindborg@samsung.com>
---
 rust/kernel/task.rs | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/rust/kernel/task.rs b/rust/kernel/task.rs
index 526d29a0ae27..7eda15e5f1b3 100644
--- a/rust/kernel/task.rs
+++ b/rust/kernel/task.rs
@@ -64,8 +64,14 @@ macro_rules! current {
 #[repr(transparent)]
 pub struct Task(pub(crate) Opaque<bindings::task_struct>);
 
-// SAFETY: It's OK to access `Task` through references from other threads because we're either
-// accessing properties that don't change (e.g., `pid`, `group_leader`) or that are properly
+// SAFETY: By design, the only way to access a `Task` is via the `current` function or via an
+// `ARef<Task>` obtained through the `AlwaysRefCounted` impl. This means that the only situation in
+// which a `Task` can be accessed mutably is when the refcount drops to zero and the destructor
+// runs. It is safe for that to happen on any thread, so it is ok for this type to be `Send`.
+unsafe impl Send for Task {}
+
+// SAFETY: It's OK to access `Task` through shared references from other threads because we're
+// either accessing properties that don't change (e.g., `pid`, `group_leader`) or that are properly
 // synchronised by C code (e.g., `signal_pending`).
 unsafe impl Sync for Task {}
 
-- 
2.40.1.698.g37aff9b760-goog

