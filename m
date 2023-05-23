Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F7734C7B
	for <patches@lists.linux.dev>; Tue, 23 May 2023 14:45:48 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-ba69d93a6b5so15071848276.1
        for <patches@lists.linux.dev>; Tue, 23 May 2023 07:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684853147; x=1687445147;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Cirt2ON6amstA/3YNx8Dl/DrSfD+lKUlEarHqMF6nxw=;
        b=DqYCWPhParszen3Hd8C6NALzsNq4RE0GYoUKErPQQT/Rk8O/vXKcFFl4bB4qWAWbtP
         kkux8OKOZOKVkJsvkJ2Ny+BMhW6JZ8Lp8rG5soKSuqkKXV72FR+NUz5qjTBaOP88KeGN
         H0AC4WDcLBg1UrXmePmLeZyRcirBCEwzjJ7wSBiRt+97j9WoXoaqf2oKm7wLH7DlYFfe
         1Pv8kbdl6HkciPp6/Wmquuc5gUJx5SC+dKxW9tuwanpD0iX6llPgQm/VSavm+1y3b3PR
         h/Y217d0niQUL9S2/ueC8YV1UCjcINwLp02CAsb6llA5VM/mPUIIgFMI864kmpC1XiE7
         d/Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684853147; x=1687445147;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Cirt2ON6amstA/3YNx8Dl/DrSfD+lKUlEarHqMF6nxw=;
        b=Pv3+gadW7gh8sHjvpAC2DR9iQR5I1uRBZ4NlEh6UvRWEpaOCJw5O+F1+RelAS6CQxa
         LONvJ2LPIR+EUySk0bD8YKPHZFC8c8af7l9NJ9phjCB+4G+6osIXNdr1L/9r++NxbDZn
         /4KQjSqr0B2gIbmXQpDmzK8cggWDBRAc/q6vFExfOEyi5fsUwMrbWreWrLfNjdmfJ5bV
         SV3VDL+G+QMNWSjRJgLleQrejrjI35Thux8evO/ornvZq0KFRSKejZTZjFFoDITDBi62
         UDcOWv95mY4V05XrkEidpwLn8Qzt/XKPQnHZk3IDAhhSEL4jM8BvYUu7Fs8smAOAm5rV
         /qmg==
X-Gm-Message-State: AC+VfDwbqeKV7fsJsRZOW9k3sZnMit/rCF+dqlYWzhdyjqm+DRdB8sd6
	Vw7Q6NcxpFklLc5i9SrE/Y2CKhBe7v3zRV0=
X-Google-Smtp-Source: ACHHUZ5HGv5J4DLwutjlh5WRFIrH9ud/Hd5FtZAOkFZuacDfLlkK3smnxJzIXubwF4Z90tgv7QY8eKQgKy5wLVk=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a25:949:0:b0:ba8:6422:bbec with SMTP id
 u9-20020a250949000000b00ba86422bbecmr8780701ybm.4.1684853147290; Tue, 23 May
 2023 07:45:47 -0700 (PDT)
Date: Tue, 23 May 2023 14:44:17 +0000
In-Reply-To: <20230523144418.1250547-1-aliceryhl@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230523144418.1250547-1-aliceryhl@google.com>
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
Message-ID: <20230523144418.1250547-4-aliceryhl@google.com>
Subject: [PATCH v2 3/4] rust: specify when `ARef` is thread safe
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

An `ARef` behaves just like the `Arc` when it comes to thread safety, so
we can reuse the thread safety comments from `Arc` here.

This is necessary because without this change, the Rust compiler will
assume that things are not thread safe even though they are.

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Andreas Hindborg <a.hindborg@samsung.com>
Reviewed-by: Boqun Feng <boqun.feng@gmail.com>
---
 rust/kernel/types.rs | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/rust/kernel/types.rs b/rust/kernel/types.rs
index 29db59d6119a..1e5380b16ed5 100644
--- a/rust/kernel/types.rs
+++ b/rust/kernel/types.rs
@@ -321,6 +321,19 @@ pub struct ARef<T: AlwaysRefCounted> {
     _p: PhantomData<T>,
 }
 
+// SAFETY: It is safe to send `ARef<T>` to another thread when the underlying `T` is `Sync` because
+// it effectively means sharing `&T` (which is safe because `T` is `Sync`); additionally, it needs
+// `T` to be `Send` because any thread that has an `ARef<T>` may ultimately access `T` using a
+// mutable reference, for example, when the reference count reaches zero and `T` is dropped.
+unsafe impl<T: AlwaysRefCounted + Sync + Send> Send for ARef<T> {}
+
+// SAFETY: It is safe to send `&ARef<T>` to another thread when the underlying `T` is `Sync`
+// because it effectively means sharing `&T` (which is safe because `T` is `Sync`); additionally,
+// it needs `T` to be `Send` because any thread that has a `&ARef<T>` may clone it and get an
+// `ARef<T>` on that thread, so the thread may ultimately access `T` using a mutable reference, for
+// example, when the reference count reaches zero and `T` is dropped.
+unsafe impl<T: AlwaysRefCounted + Sync + Send> Sync for ARef<T> {}
+
 impl<T: AlwaysRefCounted> ARef<T> {
     /// Creates a new instance of [`ARef`].
     ///
-- 
2.40.1.698.g37aff9b760-goog

