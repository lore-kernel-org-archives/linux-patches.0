Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9042D41B357;
	Wed,  4 Feb 2026 15:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218704; cv=none; b=FvVvdY+q5atC3K0JuNJUdSfI90AlPQc17Ud4g9fQQKkWhp6LY0LmCi3XuDwmfB5FYdKetkPaQPnmf550+hDj+zP77C9B6C7AJ+SiXZImz+uGdkvaBKYlWD7ogOCmkoayKRWrWbAwheTRh5cyUJJKkS75cuxAjPXYLjJyASxhHrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218704; c=relaxed/simple;
	bh=KQ1QqCki+7LjXp1LjosVRofyZ1LdkMf2M9ADwxoeL6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RXIlY+XM7KEEVEPRLHE9mafPg10IZP8a/AbtecTWb8Q/FkAyj75PLY/yN4Hvpwi2IC+t2AzzGpVeNEzT8o8hEtkd+LF+q54ZhMurIYyAwZVctRxwH0Zg/US6U84k37G5zwijc2UyaVMY6pyQv0McVRYZ0PESPli9rMAacEzZYZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gHnChmBm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gHnChmBm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 074B7C4CEF7;
	Wed,  4 Feb 2026 15:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218704;
	bh=KQ1QqCki+7LjXp1LjosVRofyZ1LdkMf2M9ADwxoeL6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gHnChmBmomYKGWh4G064e6vGQWstM2OmqJCF12nr+VoBts9E+GUS64Fq6xykN5YpK
	 uzMMGe1rOwWo+p2Wb9NSqsyPdOf9wust7VrRUG4PZjOoNKJkiyhNTmJTikiIKkVKnK
	 CyaEACHDvCxF3yMBBWNRU1824DnxKGmrT1BEhi7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Hang Shu <m18080292938@163.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Gary Guo <gary@garyguo.net>
Subject: [PATCH 6.12 36/87] rust: rbtree: fix documentation typo in CursorMut peek_next method
Date: Wed,  4 Feb 2026 15:40:34 +0100
Message-ID: <20260204143848.212769328@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hang Shu <m18080292938@163.com>

commit 45f6aed8a835ee2bdd0a5d5ee626a91fe285014f upstream.

The peek_next method's doc comment incorrectly stated it accesses the
"previous" node when it actually accesses the next node.

Fix the documentation to accurately reflect the method's behavior.

Fixes: 98c14e40e07a ("rust: rbtree: add cursor")
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Hang Shu <m18080292938@163.com>
Reported-by: Miguel Ojeda <ojeda@kernel.org>
Closes: https://github.com/Rust-for-Linux/linux/issues/1205
Cc: stable@vger.kernel.org
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://patch.msgid.link/20251107093921.3379954-1-m18080292938@163.com
[ Reworded slightly. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/rbtree.rs |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/rust/kernel/rbtree.rs
+++ b/rust/kernel/rbtree.rs
@@ -838,7 +838,7 @@ impl<'a, K, V> Cursor<'a, K, V> {
         self.peek(Direction::Prev)
     }
 
-    /// Access the previous node without moving the cursor.
+    /// Access the next node without moving the cursor.
     pub fn peek_next(&self) -> Option<(&K, &V)> {
         self.peek(Direction::Next)
     }


