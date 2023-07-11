Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5F6174E5
	for <patches@lists.linux.dev>; Tue, 11 Jul 2023 09:44:32 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-57704aa6c69so58754287b3.0
        for <patches@lists.linux.dev>; Tue, 11 Jul 2023 02:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689068672; x=1691660672;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DnWC54SA5C43dBWBZ5WUeTUepGdecHVPir9nVhbTPfs=;
        b=pFt/A5hE+tHwPhG/vQTUr4kvstBbCWSzSLnioI5Xu66+C+AWhzML21sFWR8XVStzeF
         0wRGxUkDMyyBLV3icf4r6VX2vGeeR4uCecxUxYvJ9zfs42pnWCSIGAAkxhpoeMJWP4oR
         Th52jB4y46IhDAv6CAQOCUzz6GVjHy+3AUSezWpl2nAhSHYYRPh3Y8DWkr0X97j9CcqX
         fbw9l15c8mpBVTeboeZOYwWazNhqnOvLa7kV1+K2XEhnjt+g3d7g7/jiuFcqxVyFT1m8
         T3Kc/xEiMt+wWCJGIJHLzWCKBxLAWqHOyDSTuXKA6hOOtxaUKLZDHbBhcJmmdT55KEjn
         KW4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689068672; x=1691660672;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DnWC54SA5C43dBWBZ5WUeTUepGdecHVPir9nVhbTPfs=;
        b=eZUolVyD6T07n4ksIg+UffnWnKVX5S8y1wBO9AhMpPkfneqqoW89N3DPbuoWQu8nbA
         krsKaIG0ZqOp9+9mzKMStFXZE97ltYiN4HyhooUkfGoaM98GdxARn7qqxMQpQ/QqkRAM
         p0la1PFhtZ26kipJptvM+Qzv2dgMC7xIdMyGd5lEiT7RZU5NltV18dnDoAWjtEcgzk5Z
         KgBuJadyGjIhFE+jrHtQUlnsirrXbv//CBbJgzkN+x1As47HX8SQ4Vjd8oeK61IUDL5N
         5uvR7BmM/eLED/L+UZkrF3/tHNXoTdPmR9wzImXyA3yYSqIvkKK6nVPlx7V35WowvStR
         QdsA==
X-Gm-Message-State: ABy/qLaNK5SAfkHpdNuDRep0bRWNzVhG63UdoVMUUGyf9sZCBmDjcAqb
	PZCkomIIJqDoIdnrtdDeDCcdkywuLgW/+uY=
X-Google-Smtp-Source: APBJJlE1heVdhciWDeiDz6Fk0FD2epw/QZh55eA7ghY22nT05sA9Hga/GURTh1B908T+JbpSXu2qKVF2avUaRag=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a81:4312:0:b0:579:fa4c:1f25 with SMTP id
 q18-20020a814312000000b00579fa4c1f25mr126504ywa.7.1689068671975; Tue, 11 Jul
 2023 02:44:31 -0700 (PDT)
Date: Tue, 11 Jul 2023 09:32:59 +0000
In-Reply-To: <20230711093303.1433770-1-aliceryhl@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230711093303.1433770-1-aliceryhl@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230711093303.1433770-6-aliceryhl@google.com>
Subject: [PATCH v3 5/9] rust: workqueue: define built-in queues
From: Alice Ryhl <aliceryhl@google.com>
To: rust-for-linux@vger.kernel.org, Tejun Heo <tj@kernel.org>, 
	Miguel Ojeda <ojeda@kernel.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, 
	"=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>, 
	Alice Ryhl <aliceryhl@google.com>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Wedson Almeida Filho <walmeida@microsoft.com>, 
	Martin Rodriguez Reboredo <yakoyoku@gmail.com>, Andreas Hindborg <nmi@metaspace.dk>
Content-Type: text/plain; charset="UTF-8"

From: Wedson Almeida Filho <walmeida@microsoft.com>

We provide these methods because it lets us access these queues from
Rust without using unsafe code.

These methods return `&'static Queue`. References annotated with the
'static lifetime are used when the referent will stay alive forever.
That is ok for these queues because they are global variables and cannot
be destroyed.

Signed-off-by: Wedson Almeida Filho <walmeida@microsoft.com>
Co-developed-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Andreas Hindborg (Samsung) <nmi@metaspace.dk>
Reviewed-by: Benno Lossin <benno.lossin@proton.me>
---
v2 -> v3:
 * Explain what a freezable workqueue is.
 * Add Reviewed-by from Gary, Andreas, Benno.

 rust/kernel/workqueue.rs | 71 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/rust/kernel/workqueue.rs b/rust/kernel/workqueue.rs
index 060d26dfcc7d..cad039dfc5a9 100644
--- a/rust/kernel/workqueue.rs
+++ b/rust/kernel/workqueue.rs
@@ -106,3 +106,74 @@ unsafe fn __enqueue<F>(self, queue_work_on: F) -> Self::EnqueueOutput
     where
         F: FnOnce(*mut bindings::work_struct) -> bool;
 }
+
+/// Returns the system work queue (`system_wq`).
+///
+/// It is the one used by `schedule[_delayed]_work[_on]()`. Multi-CPU multi-threaded. There are
+/// users which expect relatively short queue flush time.
+///
+/// Callers shouldn't queue work items which can run for too long.
+pub fn system() -> &'static Queue {
+    // SAFETY: `system_wq` is a C global, always available.
+    unsafe { Queue::from_raw(bindings::system_wq) }
+}
+
+/// Returns the system high-priority work queue (`system_highpri_wq`).
+///
+/// It is similar to the one returned by [`system`] but for work items which require higher
+/// scheduling priority.
+pub fn system_highpri() -> &'static Queue {
+    // SAFETY: `system_highpri_wq` is a C global, always available.
+    unsafe { Queue::from_raw(bindings::system_highpri_wq) }
+}
+
+/// Returns the system work queue for potentially long-running work items (`system_long_wq`).
+///
+/// It is similar to the one returned by [`system`] but may host long running work items. Queue
+/// flushing might take relatively long.
+pub fn system_long() -> &'static Queue {
+    // SAFETY: `system_long_wq` is a C global, always available.
+    unsafe { Queue::from_raw(bindings::system_long_wq) }
+}
+
+/// Returns the system unbound work queue (`system_unbound_wq`).
+///
+/// Workers are not bound to any specific CPU, not concurrency managed, and all queued work items
+/// are executed immediately as long as `max_active` limit is not reached and resources are
+/// available.
+pub fn system_unbound() -> &'static Queue {
+    // SAFETY: `system_unbound_wq` is a C global, always available.
+    unsafe { Queue::from_raw(bindings::system_unbound_wq) }
+}
+
+/// Returns the system freezable work queue (`system_freezable_wq`).
+///
+/// It is equivalent to the one returned by [`system`] except that it's freezable.
+///
+/// A freezable workqueue participates in the freeze phase of the system suspend operations. Work
+/// items on the workqueue are drained and no new work item starts execution until thawed.
+pub fn system_freezable() -> &'static Queue {
+    // SAFETY: `system_freezable_wq` is a C global, always available.
+    unsafe { Queue::from_raw(bindings::system_freezable_wq) }
+}
+
+/// Returns the system power-efficient work queue (`system_power_efficient_wq`).
+///
+/// It is inclined towards saving power and is converted to "unbound" variants if the
+/// `workqueue.power_efficient` kernel parameter is specified; otherwise, it is similar to the one
+/// returned by [`system`].
+pub fn system_power_efficient() -> &'static Queue {
+    // SAFETY: `system_power_efficient_wq` is a C global, always available.
+    unsafe { Queue::from_raw(bindings::system_power_efficient_wq) }
+}
+
+/// Returns the system freezable power-efficient work queue (`system_freezable_power_efficient_wq`).
+///
+/// It is similar to the one returned by [`system_power_efficient`] except that is freezable.
+///
+/// A freezable workqueue participates in the freeze phase of the system suspend operations. Work
+/// items on the workqueue are drained and no new work item starts execution until thawed.
+pub fn system_freezable_power_efficient() -> &'static Queue {
+    // SAFETY: `system_freezable_power_efficient_wq` is a C global, always available.
+    unsafe { Queue::from_raw(bindings::system_freezable_power_efficient_wq) }
+}
-- 
2.41.0.255.g8b1d071c50-goog

