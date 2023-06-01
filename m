Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDCF921079
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 13:53:59 +0000 (UTC)
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-514b19ded99so719946a12.0
        for <patches@lists.linux.dev>; Thu, 01 Jun 2023 06:53:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685627638; x=1688219638;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kFZgiOUIu+kFD/tH5EFpQqSQN/mWPzP02CS5RCs3B9M=;
        b=MkzWTGF98V5rWGyl2PEut0MvVD60T25TsJG+nP3EJ0G5Xj9HN/47MO2rJK4nSC8lAD
         TJvZCwvsHZnHGDFiPXqerEKpexrbHyZ5jkHFur0RTDUcpye/mtH04woakV0u/oTzddFi
         ErxxJN1cTn+2gjmPjvFwUQd+aIbjKx6adZhQgUS1rFmnHk5ewCWxnCRVk26Do8jsKsXm
         kwmrZ5wO4mULuKacNSxdAF+hTBRIKHsiOx0dgijn4mDotI5LaPFPj1fzFl3IlRL5TpXy
         0qtu9up5ITib15C7+Z77VR0cIS8sBssQbXFZkrc6NmoyqwmKOmd2IQqBo5uEGjolxxCB
         Nc2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685627638; x=1688219638;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kFZgiOUIu+kFD/tH5EFpQqSQN/mWPzP02CS5RCs3B9M=;
        b=HPpWuH7bjt+fxEHf/LWrJjdJZ/+teZ7jg+Zh9zfNM2HuxdF8XHV5iHMIpfFEf/MF57
         ZseG6daomPNTI7pWDgJmDb7GKTDdUGb6O5ZGfSERxNSNZ3oC0IvI2u9mYz81nAhrn651
         wegklNbXwzAe2A1ggrDnymb3vwGK/nmyT/mLAsuiFdT5MSkaQt1qdNO36UO8uBVg7GSs
         KjuCKOGCl2nrgAVVPuFPlRoMP5WWXy/gjZ2467tKK8pqKp2cKbX1IgQvzvOLp58l7aqQ
         /dybkgGL1PdxpcG04fNSr9R0Fsd6wg8IA6Kcdgit079/nit0ltHKwiieadyjEbEK7YLT
         Xu2Q==
X-Gm-Message-State: AC+VfDzzWin/i0xI2Z/ozX1x9JXyV5HicV2TkGmaUupaiFY3D5eClp3X
	zlgFn3wKbe/udw/uYNktpmj0NEEQC69qaNg=
X-Google-Smtp-Source: ACHHUZ5xOb/B9cybQJo26BFDnCaofuwbd/HT1NJPNXV66I9mRscvFL3xGEVBJJEYGaMR9X34vY8CcFElhSj10Ww=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a50:f692:0:b0:510:b4dc:165a with SMTP id
 d18-20020a50f692000000b00510b4dc165amr3036075edn.5.1685627637870; Thu, 01 Jun
 2023 06:53:57 -0700 (PDT)
Date: Thu,  1 Jun 2023 13:49:42 +0000
In-Reply-To: <20230601134946.3887870-1-aliceryhl@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230601134946.3887870-1-aliceryhl@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230601134946.3887870-5-aliceryhl@google.com>
Subject: [PATCH v2 4/8] rust: workqueue: define built-in queues
From: Alice Ryhl <aliceryhl@google.com>
To: rust-for-linux@vger.kernel.org
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, Tejun Heo <tj@kernel.org>, 
	Lai Jiangshan <jiangshanlai@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>, 
	Alice Ryhl <aliceryhl@google.com>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Wedson Almeida Filho <walmeida@microsoft.com>, 
	Martin Rodriguez Reboredo <yakoyoku@gmail.com>
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
---
 rust/kernel/workqueue.rs | 65 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/rust/kernel/workqueue.rs b/rust/kernel/workqueue.rs
index 9c630840039b..e37820f253f6 100644
--- a/rust/kernel/workqueue.rs
+++ b/rust/kernel/workqueue.rs
@@ -105,3 +105,68 @@ unsafe fn __enqueue<F>(self, queue_work_on: F) -> Self::EnqueueOutput
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
2.41.0.rc0.172.g3f132b7071-goog

