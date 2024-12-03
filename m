Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5492F23CE;
	Tue,  3 Dec 2024 16:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241768; cv=none; b=tBihf/dYmGC54Nyflt1G3bIBsOXLkCF0zGs5JVwapt3GakROOt8bIHcL9afAlMp38azV2fphHKJcJ7RNyxyN0l97G7hDwQz/EndyW9FMfw4Rg1wG+31CDS2Sc8sKOEQiEL2c3sSQWBhB6iBU57HLK8U9XJqD1TfF3+coKYekrIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241768; c=relaxed/simple;
	bh=3DnlRcsqReq0DrkxWbuXDKE44LutTlCreFWBfh7pMaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eR1p8KxkHnx4dPO1+IGqtEjoZ7EDWbhlduXnNusgsRpz7aSxGN3UvPa09oC5jsZ5vY4JDYP4xDNs/fcnAEnsMvZMnJhF1rnnnNtsuYYTEcFXynJyUxD60oDVkGZu7KBYkXHnTjV+TeBAJyoNMMUmzzsKIOaDh4DYkctnU6zjeUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UjJKwn42; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UjJKwn42"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C289BC4CECF;
	Tue,  3 Dec 2024 16:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241768;
	bh=3DnlRcsqReq0DrkxWbuXDKE44LutTlCreFWBfh7pMaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UjJKwn42YnvRj0HQkt+pUkEro5XSryBl6LJLyFQs81EmRIbQnvrZa76qALT/vMDSN
	 /mdPGVBJ+XkykPVNgmd1oIaTd83Om4wus0orS0vFJS1oc3HA5ixS9Knu7E07LjZORK
	 xClzQqSMuka/nDgk6b+qMlEqzNDBe/ti0PGBL2tQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trevor Gross <tmgross@umich.edu>,
	Alice Ryhl <aliceryhl@google.com>,
	Gary Guo <gary@garyguo.net>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 479/826] rust: rbtree: fix `SAFETY` comments that should be `# Safety` sections
Date: Tue,  3 Dec 2024 15:43:26 +0100
Message-ID: <20241203144802.447171452@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

[ Upstream commit 8333ff4d0799aafbe4275cddcbaf45e545e4efba ]

The tag `SAFETY` is used for safety comments, i.e. `// SAFETY`, while a
`Safety` section is used for safety preconditions in code documentation,
i.e. `/// # Safety`.

Fix the three instances recently added in `rbtree` that Clippy would
have normally caught in a public item, so that we can enable checking
of private items in one of the following commits.

Fixes: 98c14e40e07a ("rust: rbtree: add cursor")
Reviewed-by: Trevor Gross <tmgross@umich.edu>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Tested-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://lore.kernel.org/r/20240904204347.168520-14-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/rbtree.rs | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/rust/kernel/rbtree.rs b/rust/kernel/rbtree.rs
index 25eb36fd1cdce..d03e4aa1f4812 100644
--- a/rust/kernel/rbtree.rs
+++ b/rust/kernel/rbtree.rs
@@ -884,7 +884,8 @@ fn get_neighbor_raw(&self, direction: Direction) -> Option<NonNull<bindings::rb_
         NonNull::new(neighbor)
     }
 
-    /// SAFETY:
+    /// # Safety
+    ///
     /// - `node` must be a valid pointer to a node in an [`RBTree`].
     /// - The caller has immutable access to `node` for the duration of 'b.
     unsafe fn to_key_value<'b>(node: NonNull<bindings::rb_node>) -> (&'b K, &'b V) {
@@ -894,7 +895,8 @@ unsafe fn to_key_value<'b>(node: NonNull<bindings::rb_node>) -> (&'b K, &'b V) {
         (k, unsafe { &*v })
     }
 
-    /// SAFETY:
+    /// # Safety
+    ///
     /// - `node` must be a valid pointer to a node in an [`RBTree`].
     /// - The caller has mutable access to `node` for the duration of 'b.
     unsafe fn to_key_value_mut<'b>(node: NonNull<bindings::rb_node>) -> (&'b K, &'b mut V) {
@@ -904,7 +906,8 @@ unsafe fn to_key_value_mut<'b>(node: NonNull<bindings::rb_node>) -> (&'b K, &'b
         (k, unsafe { &mut *v })
     }
 
-    /// SAFETY:
+    /// # Safety
+    ///
     /// - `node` must be a valid pointer to a node in an [`RBTree`].
     /// - The caller has immutable access to the key for the duration of 'b.
     unsafe fn to_key_value_raw<'b>(node: NonNull<bindings::rb_node>) -> (&'b K, *mut V) {
-- 
2.43.0



