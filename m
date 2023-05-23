Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 200A94C7B
	for <patches@lists.linux.dev>; Tue, 23 May 2023 14:45:26 +0000 (UTC)
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-94a34d3e5ebso726466766b.3
        for <patches@lists.linux.dev>; Tue, 23 May 2023 07:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684853124; x=1687445124;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lZ4w9FZLzrevw3euUgZ/CnJwq2fkRa+GrhkB6vuUVZU=;
        b=DM09wBFceGQyjzVeQn88f9gT37GoP8CdPRKIqccyn5klXMCzMXmxgXiA33U1xBdApV
         phKL7Y6oJqHMuNyPNkbrA8fkuJoSJtclCT6DlV4sbNFhEYoRh71OR3w1YoSmECRVdrmX
         bJ+EqUNSt4SfVYAfMThw8o4+OOuqNeNXdCilulQS1pEFabKB0fed/m9nsAE3FHgf28Tt
         5s9oD0Ammk7IScrdsNQ9otYN9ftb17Wl/mIR2fwtLw0Ei+SJ5U4VKFjJriNnbE5Ef95u
         se6yubaEdwOhFET+po90z+DhM/u2x4CqHeuJOKgTgzofYW75jZE4kv8+8G3kvzEMoYIB
         CFhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684853124; x=1687445124;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lZ4w9FZLzrevw3euUgZ/CnJwq2fkRa+GrhkB6vuUVZU=;
        b=kl3IDr6fRlzTYFrmI3RfJvAddze+nnAC69QZG6B6y9L+XgPV0SJmh7i6FNZp62P216
         V5mjMiov8qXOHFLVOvamKrpmOnKG5mHR6Zvym6viNHl5K5cRHKRLGUD7Nkwl2MEmqdky
         vL4rEIHGF91wmKBZj7pJIGW2dJUOOmu7X4ubjLxF8FBEpi43aX58a4DeGOnLkDciy3sy
         kHGApHdBzcFbT09N0prp4cTefqrCns0lD3iu1sjDZHV52GmVBjg4enDtdZbKc3F99YIm
         SxAaQU9FRM6ocF8b4nDQTaSF+Ses0kSBxD1akLv5G1YbtoLarbdwTlkTpICMEcZDAoaW
         Mwng==
X-Gm-Message-State: AC+VfDyQvN7FNKZkZiv4BuYSYvfWFocQ36EaYNQ0PjzKB5n14yFqGRqa
	/MTYyAD84vif9emVH4kEHQt5mzP9cTXYZRQ=
X-Google-Smtp-Source: ACHHUZ5Uknm/33fO8x2pU4Gkt1Qyr7oafKZ5WmNy1nlRwLRdCV5Y5wya147tNmIt/yqie5nQUQ62+Nxb6oSmcW0=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a17:906:ad82:b0:96f:5864:eb73 with SMTP
 id la2-20020a170906ad8200b0096f5864eb73mr4342619ejb.9.1684853124405; Tue, 23
 May 2023 07:45:24 -0700 (PDT)
Date: Tue, 23 May 2023 14:44:16 +0000
In-Reply-To: <20230523144418.1250547-1-aliceryhl@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230523144418.1250547-1-aliceryhl@google.com>
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
Message-ID: <20230523144418.1250547-3-aliceryhl@google.com>
Subject: [PATCH v2 2/4] rust: sync: reword the `Arc` safety comment for `Sync`
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

The safety comment on `impl Sync for Arc` references the Send safety
comment. This commit avoids that in case the two comments drift apart in
the future.

Suggested-by: Andreas Hindborg <a.hindborg@samsung.com>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Andreas Hindborg <a.hindborg@samsung.com>
Reviewed-by: Boqun Feng <boqun.feng@gmail.com>
---
 rust/kernel/sync/arc.rs | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/rust/kernel/sync/arc.rs b/rust/kernel/sync/arc.rs
index 87a4c9ed712b..4d10f9868d9e 100644
--- a/rust/kernel/sync/arc.rs
+++ b/rust/kernel/sync/arc.rs
@@ -150,9 +150,11 @@ impl<T: ?Sized + Unsize<U>, U: ?Sized> core::ops::DispatchFromDyn<Arc<U>> for Ar
 // mutable reference, for example, when the reference count reaches zero and `T` is dropped.
 unsafe impl<T: ?Sized + Sync + Send> Send for Arc<T> {}
 
-// SAFETY: It is safe to send `&Arc<T>` to another thread when the underlying `T` is `Sync` for the
-// same reason as above. `T` needs to be `Send` as well because a thread can clone an `&Arc<T>`
-// into an `Arc<T>`, which may lead to `T` being accessed by the same reasoning as above.
+// SAFETY: It is safe to send `&Arc<T>` to another thread when the underlying `T` is `Sync`
+// because it effectively means sharing `&T` (which is safe because `T` is `Sync`); additionally,
+// it needs `T` to be `Send` because any thread that has a `&Arc<T>` may clone it and get an
+// `Arc<T>` on that thread, so the thread may ultimately access `T` using a mutable reference, for
+// example, when the reference count reaches zero and `T` is dropped.
 unsafe impl<T: ?Sized + Sync + Send> Sync for Arc<T> {}
 
 impl<T> Arc<T> {
-- 
2.40.1.698.g37aff9b760-goog

