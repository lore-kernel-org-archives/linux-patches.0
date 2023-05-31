Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43303C8FF
	for <patches@lists.linux.dev>; Wed, 31 May 2023 15:00:42 +0000 (UTC)
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-506a7b4f141so5168710a12.2
        for <patches@lists.linux.dev>; Wed, 31 May 2023 08:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685545240; x=1688137240;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=v7AwI9/GAng9F6JU881/rPRp6iZXP9LwiNNuLduw3ys=;
        b=OMfl8/Z1UwxPwIyaHYkJ8H7XXz53ExBje25D3fSggmAEgqJKexyNv/r05uILaNVDH3
         T5pW/a/d7fWKUhDGhaJRx9W6nzSAhQEKxq4NCO9CY3nxTH5muUNEJCcdJEwE4FDKS5YE
         mYtD4BXfm5MS0N3+F6W6wTY8BVSX/OtnsTIl/ym9yDrzKwkqbJuxky5teH0ZIc6hZGV+
         4zu2xJq1E0BdirdqaHNQC6za3BZrmsP+frmwlo6ZL3kMQZ+wZwP9hNv7crfRZDRjX8oC
         c0qI0l8MuhuhbctU5kMcULymtY0J4dWQT3OiUwRNBTlaEv30nTmYbag6K13T0WiAy6ga
         xXMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685545240; x=1688137240;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v7AwI9/GAng9F6JU881/rPRp6iZXP9LwiNNuLduw3ys=;
        b=IjaLruY5dVmytTWDcwaTpVClEw1w+0iw93ebXh5nMi9uRB2ZkBuhCUuGYCySlXdwFu
         8t3Y1SZrNtsNBG1LO8IKhoplB/La7WfZ+AfWhouI42dqzLXhjpkY27U42LvvA0BiFeRg
         +m1Sq8WDwwZ0Y/V3UlXEiMYI+xroByvrjAwfAkhPA3I0FDFvANju66X3wI7Z2g73NvVb
         OtGl/3p+ZnSRojwucAKbvP/DGw+PBTV+Y8O2pvoItZfOGfque2GnxihqoV3vzOxDFzgn
         UnE+5d/i7K5OpEnxMATNga0hRhyQ0BLLJikuHF8TiDezFrHNDjUvVnAz8gDVX9yYQZIU
         +L3g==
X-Gm-Message-State: AC+VfDw3Dhpdt2OXUNR/29Einaj9dC/ppofYxYgFzrHcD8XwfdxBZKGx
	EP7aTDr224iu99lcII30cBPNmJCgqMX7H1U=
X-Google-Smtp-Source: ACHHUZ68XPwYHak3RB9bb2krSE7KWIbi6M9HKaemsTXiQeyDGltkWQmmatoHjKKHCoSRCi/az8D3w9Kajgq9dOk=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a50:cdc1:0:b0:504:fcf5:63ee with SMTP id
 h1-20020a50cdc1000000b00504fcf563eemr1888238edj.0.1685545240591; Wed, 31 May
 2023 08:00:40 -0700 (PDT)
Date: Wed, 31 May 2023 14:59:36 +0000
In-Reply-To: <20230531145939.3714886-1-aliceryhl@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230531145939.3714886-1-aliceryhl@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230531145939.3714886-2-aliceryhl@google.com>
Subject: [PATCH v3 1/4] rust: sync: reword the `Arc` safety comment for `Send`
From: Alice Ryhl <aliceryhl@google.com>
To: rust-for-linux@vger.kernel.org
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, 
	"=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>, 
	Alice Ryhl <aliceryhl@google.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Andreas Hindborg <a.hindborg@samsung.com>, 
	Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Content-Type: text/plain; charset="UTF-8"

The safety comment on `impl Send for Arc` talks about "directly"
accessing the value, when it really means "accessing the value with a
mutable reference". This commit clarifies that.

Suggested-by: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Andreas Hindborg <a.hindborg@samsung.com>
Reviewed-by: Boqun Feng <boqun.feng@gmail.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Reviewed-by: Benno Lossin <benno.lossin@proton.me>
---
 rust/kernel/sync/arc.rs | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/rust/kernel/sync/arc.rs b/rust/kernel/sync/arc.rs
index e6d206242465..3ad831603cf4 100644
--- a/rust/kernel/sync/arc.rs
+++ b/rust/kernel/sync/arc.rs
@@ -146,8 +146,8 @@ impl<T: ?Sized + Unsize<U>, U: ?Sized> core::ops::DispatchFromDyn<Arc<U>> for Ar
 
 // SAFETY: It is safe to send `Arc<T>` to another thread when the underlying `T` is `Sync` because
 // it effectively means sharing `&T` (which is safe because `T` is `Sync`); additionally, it needs
-// `T` to be `Send` because any thread that has an `Arc<T>` may ultimately access `T` directly, for
-// example, when the reference count reaches zero and `T` is dropped.
+// `T` to be `Send` because any thread that has an `Arc<T>` may ultimately access `T` using a
+// mutable reference when the reference count reaches zero and `T` is dropped.
 unsafe impl<T: ?Sized + Sync + Send> Send for Arc<T> {}
 
 // SAFETY: It is safe to send `&Arc<T>` to another thread when the underlying `T` is `Sync` for the
-- 
2.41.0.rc0.172.g3f132b7071-goog

