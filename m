Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC1C449B3
	for <patches@lists.linux.dev>; Wed, 17 May 2023 20:31:32 +0000 (UTC)
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-50bc456a94dso1283226a12.1
        for <patches@lists.linux.dev>; Wed, 17 May 2023 13:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684355491; x=1686947491;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aOsrinT2/iaeBb0WCg7wbvs+eW6FJ9BpP6VKG3yyBao=;
        b=H6PERSAkTTYE2cWlo4VM3SlqSWM7x5pxRQ0xuWDg3VOBNyhF2hvGKULDhDPgLi2z3g
         B6Z0eUxWVpg5g5oXZLmaug777isU03Z+nfEJ5ms9qAPmuVNsFW1fc8qMU7nD99034pQy
         JBR5MzZlyYJrWwX4d7Pd79YdlG1fLg6EbSOgLlcg8D+RArG3dkHGoOpFv7Or62NCvRzf
         ULBHvzIUC6W1xuBIfvCrqHqTKetHK8rZJFGSh+P0Z8yHzoPYw5anwwjpuCKLIgGlnJaH
         caRHHNXst0n42JTDJdFiZhG2I1wLxulOebTtWnSeGO+dGTMUCBk6ViszJYZzaZ9AxwrI
         enWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684355491; x=1686947491;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aOsrinT2/iaeBb0WCg7wbvs+eW6FJ9BpP6VKG3yyBao=;
        b=PqSPsmIEfG1ujQg7voRoDRIrZgx1EGYQWDhNBkwBgkde32K77KOrAoFRYEVDWVhhBd
         0Yg2XokTAekYce0B+Nn7GsaQxw4DxJvCKbISAmk2F8bYc2fNz7eUt0VP/b9vnJizxNYp
         hnGplGeagmXQhrSUm6Hg8MzIGoXWtj2QHsnNNpu/AAkZ/Dm717LPCuoxNyi5p9A5ICpt
         EztRaHTFJRLwCLQ/4Ub9LbZS5ucwC0079Sd71t0dXtzV1X2Y4qmNBzu9rDzuWBwEfXoO
         +P/rzhjbd7pC2hq9DV0oFhcYZLNr5FTqEGPxUPm0S5LzDE8WMjUBWGCg5ITUVrLqk+E3
         yy2w==
X-Gm-Message-State: AC+VfDxncC/G7S/OmgTK2FHHnplpBY9BP6deCUSrU7KO9J8z3lbh6hgH
	VyqjSPNwmAimaPq229C6+u9caGJSJlEcLZ0=
X-Google-Smtp-Source: ACHHUZ7n3lEpyHrn8lVJb9kMGCyUFSu3fVlXDWiAjcH2k80JTEv/xTBS0iudv7fOHA1JEPF5qkMBmU5dogljNJM=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a50:f610:0:b0:50b:d648:a963 with SMTP id
 c16-20020a50f610000000b0050bd648a963mr1508053edn.6.1684355491066; Wed, 17 May
 2023 13:31:31 -0700 (PDT)
Date: Wed, 17 May 2023 20:31:16 +0000
In-Reply-To: <20230517203119.3160435-1-aliceryhl@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230517203119.3160435-1-aliceryhl@google.com>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230517203119.3160435-5-aliceryhl@google.com>
Subject: [PATCH v1 4/7] rust: workqueue: define built-in queues
From: Alice Ryhl <aliceryhl@google.com>
To: rust-for-linux@vger.kernel.org
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, Tejun Heo <tj@kernel.org>, 
	Lai Jiangshan <jiangshanlai@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>, 
	Alice Ryhl <aliceryhl@google.com>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
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
---
 rust/kernel/workqueue.rs | 65 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/rust/kernel/workqueue.rs b/rust/kernel/workqueue.rs
index e66b6b50dfae..22205d3bda72 100644
--- a/rust/kernel/workqueue.rs
+++ b/rust/kernel/workqueue.rs
@@ -97,3 +97,68 @@ pub unsafe trait WorkItem {
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
+pub fn system_freezable_power_efficient() -> &'static Queue {
+    // SAFETY: `system_freezable_power_efficient_wq` is a C global, always available.
+    unsafe { Queue::from_raw(bindings::system_freezable_power_efficient_wq) }
+}
-- 
2.40.1.606.ga4b1b128d6-goog

