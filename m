Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D22C1E9B3D;
	Tue, 11 Nov 2025 01:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825285; cv=none; b=sZ1tYl4ztysWCrAGOYP87Yfg+MRiRqw3C3SrTEX5guU8wrqdEYAQ6TTBHC1wlgyEyiL3/1Qt98n5a8KWuSeKFOe6kTtsLfLw5o+hMFux4Ht1V+2WrEHM517939YDuRlVKI5nsqBlHRQeOV/6EXVorZimr4jlIyIoogpPl9I6tnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825285; c=relaxed/simple;
	bh=6MrKhXiVwGNm1qHIOKUGf7nnxNKRKtHqJKSF9iHgdkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BQRUdKgDqi0u5ivVGcVd5rqu4g3FeSW5tdqXbVQtz4j9c0NaPtnxOqdLXcpxhiGxQfemCU7xLCEH16lLZ0JN1wohQJAAEEx3ZtJiInX7hER6+imFa1hfyMXqSLWmC1kzVUMxUXL7+JjyPAP9in2hNlwIp7avYAzeJKNs6aJ1ilw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZyHTDGzZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZyHTDGzZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27EB5C16AAE;
	Tue, 11 Nov 2025 01:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825285;
	bh=6MrKhXiVwGNm1qHIOKUGf7nnxNKRKtHqJKSF9iHgdkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZyHTDGzZgu7qdbtQgJAsR4zkdsXc5U9MWCnWDlPVguDBBBQTF56EQbBa7RzStNSoD
	 fm4Y23K9484bbbFR/DN3cmnyyL5FyAg1+U/KjkyHy/geDUMnHatResEHztQJweFxTq
	 KWKKpqew6a75Ukb74D9Q5oyQnELnC4AGWtlLLAZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.17 738/849] rust: condvar: fix broken intra-doc link
Date: Tue, 11 Nov 2025 09:45:08 +0900
Message-ID: <20251111004554.282781730@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

commit 09b1704f5b02c18dd02b21343530463fcfc92c54 upstream.

The future move of pin-init to `syn` uncovers the following broken
intra-doc link:

    error: unresolved link to `crate::pin_init`
      --> rust/kernel/sync/condvar.rs:39:40
       |
    39 | /// instances is with the [`pin_init`](crate::pin_init!) and [`new_condvar`] macros.
       |                                        ^^^^^^^^^^^^^^^^ no item named `pin_init` in module `kernel`
       |
       = note: `-D rustdoc::broken-intra-doc-links` implied by `-D warnings`
       = help: to override `-D warnings` add `#[allow(rustdoc::broken_intra_doc_links)]`

Currently, when rendered, the link points to a literal `crate::pin_init!`
URL.

Thus fix it.

Cc: stable@vger.kernel.org
Fixes: 129e97be8e28 ("rust: pin-init: fix documentation links")
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Link: https://patch.msgid.link/20251029073344.349341-1-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/sync/condvar.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/kernel/sync/condvar.rs b/rust/kernel/sync/condvar.rs
index c6ec64295c9f..aa5b9a7a726d 100644
--- a/rust/kernel/sync/condvar.rs
+++ b/rust/kernel/sync/condvar.rs
@@ -36,7 +36,7 @@ macro_rules! new_condvar {
 /// spuriously.
 ///
 /// Instances of [`CondVar`] need a lock class and to be pinned. The recommended way to create such
-/// instances is with the [`pin_init`](crate::pin_init!) and [`new_condvar`] macros.
+/// instances is with the [`pin_init`](pin_init::pin_init!) and [`new_condvar`] macros.
 ///
 /// # Examples
 ///
-- 
2.51.2



