Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 130944C7B
	for <patches@lists.linux.dev>; Tue, 23 May 2023 14:45:07 +0000 (UTC)
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-9715654ab36so92635166b.0
        for <patches@lists.linux.dev>; Tue, 23 May 2023 07:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684853105; x=1687445105;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qdVRg6LoNElWahe9YlmLHc0fO9VPVtOwab5a4NPQ+t0=;
        b=L+ydM2ZMhTGwNMwmjmnRmRfMJfy783Y8dALDZDlyzR0avEpxlOnKtSq5GYMkYzb317
         vtIYmC0LT38gm6XodkzGrp11N2LZSJzXE2oX4+W0z/RRuSLisAL86VqLi7RA5QO8f8GZ
         MxaI60HRLpFzgsFuRKnLFYwHloYozwkZC6aKvzAr95gWRC27FvpWdG3aAxjmKIqnSmbw
         p1oYFQpe3C9rz5RILbQYi1dfGzQIBcN6VOtGm7F2Kkm2Uaml0QsfDRilvm4+zqsDKcZW
         G511w179klPw2ryx75gy6gXzIM9R+enCxH/3gS0BhdyC4bXWrH8OjIEVk2y5yvwAQAE+
         6usg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684853105; x=1687445105;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qdVRg6LoNElWahe9YlmLHc0fO9VPVtOwab5a4NPQ+t0=;
        b=cXiYlBKC1yB6H6XOIJcCiiSGZ7ZqRsCkE2ekI3Dl+REw3l6Owz8U2/bWmrk6vYDvie
         Nzoa0M+C4vQpSzjs0PCv7HH5WPFSSpUPZyHptRVWZgYBbNQ7+pXzV6IiidO/aovpbwXJ
         l2pH5Tf3opOQ6nBitdgwpPmN+ziuSyxr6y1wBj/k0t2Rpdc5FuLTZTYsYqoZiep8a52X
         2XoR9VCxv9FgM/1Ps9NMyYajTYvnDVL+j1+J0dcPXJsVuSKYVqRmf77oLKhQ3FBGvIos
         TnozjalxCgoXn74KRK5IxB5Rw2WdomgZ6NagQuGcTdTQKNLrJ429FPumBV2u8Ezkcmlz
         D5bw==
X-Gm-Message-State: AC+VfDwHgiSpnemx+fpkNWXX+ChjEpHLHhM5FmAgEp9sT6iMzYVxaXRA
	AGUKoB0yyCylVlAPrHaQZEXknb1gh9XpPFk=
X-Google-Smtp-Source: ACHHUZ5EOxmKcPckGGYoWG+E6eScW9ff6mALx3v5X3xhD+aggfd1Uq5KEgyfu4kvGgNrs8PkLoMCyDXlb999Xwc=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a17:906:8453:b0:965:ecf8:4af5 with SMTP
 id e19-20020a170906845300b00965ecf84af5mr5174037ejy.12.1684853105342; Tue, 23
 May 2023 07:45:05 -0700 (PDT)
Date: Tue, 23 May 2023 14:44:15 +0000
In-Reply-To: <20230523144418.1250547-1-aliceryhl@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230523144418.1250547-1-aliceryhl@google.com>
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
Message-ID: <20230523144418.1250547-2-aliceryhl@google.com>
Subject: [PATCH v2 1/4] rust: sync: reword the `Arc` safety comment for `Send`
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

The safety comment on `impl Send for Arc` talks about "directly"
accessing the value, when it really means "accessing the value with a
mutable reference". This commit clarifies that.

Suggested-by: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Andreas Hindborg <a.hindborg@samsung.com>
Reviewed-by: Boqun Feng <boqun.feng@gmail.com>
---
 rust/kernel/sync/arc.rs | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/rust/kernel/sync/arc.rs b/rust/kernel/sync/arc.rs
index e6d206242465..87a4c9ed712b 100644
--- a/rust/kernel/sync/arc.rs
+++ b/rust/kernel/sync/arc.rs
@@ -146,8 +146,8 @@ impl<T: ?Sized + Unsize<U>, U: ?Sized> core::ops::DispatchFromDyn<Arc<U>> for Ar
 
 // SAFETY: It is safe to send `Arc<T>` to another thread when the underlying `T` is `Sync` because
 // it effectively means sharing `&T` (which is safe because `T` is `Sync`); additionally, it needs
-// `T` to be `Send` because any thread that has an `Arc<T>` may ultimately access `T` directly, for
-// example, when the reference count reaches zero and `T` is dropped.
+// `T` to be `Send` because any thread that has an `Arc<T>` may ultimately access `T` using a
+// mutable reference, for example, when the reference count reaches zero and `T` is dropped.
 unsafe impl<T: ?Sized + Sync + Send> Send for Arc<T> {}
 
 // SAFETY: It is safe to send `&Arc<T>` to another thread when the underlying `T` is `Sync` for the
-- 
2.40.1.698.g37aff9b760-goog

