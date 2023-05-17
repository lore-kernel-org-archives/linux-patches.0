Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36960111AD
	for <patches@lists.linux.dev>; Wed, 17 May 2023 20:08:38 +0000 (UTC)
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-96625ceef6cso132292066b.0
        for <patches@lists.linux.dev>; Wed, 17 May 2023 13:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684354116; x=1686946116;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8iJR0huTfHVTodkNfO2dbFSpbRb6U9pb/v/u0biFupw=;
        b=bWzM94fINtOQiMgIeij8r/YgZ5x9bR/Dr9fiTQjsYbOEc/EG/KK3e24KYDbSbKNXFq
         q0JETAcKy8aAdEveycELSQP0Ii/yRJnHVk4NKArscNFWSTQkCbq1VcORowwK/6Ou8Yb8
         0s6z4qC2HG4wsDP+zgctkD2KNiocsj8sZviKvuD+KSI518NxZvqsWzw8HUxm1BcPU4eJ
         S3tGklnk97V3591mhv9OhfHFl38eoUwDL0WA8VbW30AEVdqh1K736UaBB1EKE5aaAvRJ
         RpxcN2gss1FGPI7JNDtmlPhXfX8KVUsqBfnaRMg0dauYa+JFHyIAHP4RRisrg0k+L8XF
         1ugw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684354116; x=1686946116;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8iJR0huTfHVTodkNfO2dbFSpbRb6U9pb/v/u0biFupw=;
        b=eAcCvqwXlIzunoMyH9SJDf5yJyvgGDJ0ohnG383p7cNYGT4zNw8HmElRzrJqnG5dEL
         NeTLKGvj+IpZD75Wi+LndWvp4P1UKqo4XiEc7y9eY5cMXtiQ+w3rH0/wjpPMU6C0z/nH
         mrP4HkxuftwirMlB/gy0LjV7Pcgji/H5Je0t98kL0w21S/Yym0pD/hbYPVsoYkWiCyJO
         U/2sD214QERqkfcaPk3eQ+s8NQHAtyXiaAbmk96xQbiFQoLNRw0Woch/uW8Ov489zpqb
         lWwA+EQPOtGVqOmTBY4QK1eUyYLFB5EdXb4XnCXwWlzo/iqzgZalso4Er0o1wAIJiaN4
         I5eg==
X-Gm-Message-State: AC+VfDyACztCytuuQymigbrxa/nJG6wrx/QDdBe3cNVyEbcXiFW4fpyL
	mL0hWG082cEQKsh6nHfkd+x/R5xJEwuIyKU=
X-Google-Smtp-Source: ACHHUZ4YGLtjd/kuG8qRx/nnMKQbJbKmU6GNX6G9qK33HW2/6o/Jr8uWhpPLl4A/zXlgMGnERgXqzW6IE9wZdio=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a17:906:847a:b0:969:fc90:bf94 with SMTP
 id hx26-20020a170906847a00b00969fc90bf94mr9978929ejc.8.1684354116437; Wed, 17
 May 2023 13:08:36 -0700 (PDT)
Date: Wed, 17 May 2023 20:08:14 +0000
In-Reply-To: <20230517200814.3157916-1-aliceryhl@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230517200814.3157916-1-aliceryhl@google.com>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230517200814.3157916-2-aliceryhl@google.com>
Subject: [PATCH v1 2/2] rust: sync: implement `AsRef<T>` for `Arc<T>`
From: Alice Ryhl <aliceryhl@google.com>
To: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>, 
	Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Mark Rutland <mark.rutland@arm.com>, Alice Ryhl <aliceryhl@google.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Wedson Almeida Filho <walmeida@microsoft.com>
Content-Type: text/plain; charset="UTF-8"

This trait lets you use `Arc<T>` in code that is generic over smart
pointer types.

The `AsRef` trait should be implemented on all smart pointers. The
standard library also implements it on the ordinary `Arc`.

Co-developed-by: Wedson Almeida Filho <walmeida@microsoft.com>
Signed-off-by: Wedson Almeida Filho <walmeida@microsoft.com>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
 rust/kernel/sync/arc.rs | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/rust/kernel/sync/arc.rs b/rust/kernel/sync/arc.rs
index 274febe3bb06..9ec911e4a0c7 100644
--- a/rust/kernel/sync/arc.rs
+++ b/rust/kernel/sync/arc.rs
@@ -264,6 +264,12 @@ impl<T: ?Sized> Deref for Arc<T> {
     }
 }
 
+impl<T: ?Sized> AsRef<T> for Arc<T> {
+    fn as_ref(&self) -> &T {
+        self.deref()
+    }
+}
+
 impl<T: ?Sized> Clone for Arc<T> {
     fn clone(&self) -> Self {
         // INVARIANT: C `refcount_inc` saturates the refcount, so it cannot overflow to zero.
-- 
2.40.1.606.ga4b1b128d6-goog

