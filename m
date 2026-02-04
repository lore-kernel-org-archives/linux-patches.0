Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5A12D5C91;
	Wed,  4 Feb 2026 15:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219212; cv=none; b=a0gdU3e0up0kNVYAvZhZN8jJ/f09ngRBd3dmBJlokJKtK5C6TZ6BB6EQH/f/kNLFopUP335DxMhKMQTbZdO7WxNhizyahowkdF45rvxT8NOLs2jrd/4Q+wkrWuy0ptvR6xkv+UdktOvCH3gXkphJ8FQo1IUl8agwXuKeRYOQqgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219212; c=relaxed/simple;
	bh=Z3ruvMwmxXj2pSm6nL9EquPaLTJGOJo9m0rJnD0CUR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N+rQjOH8yS2apVPkRcx8Mc9WNtkim0YJMADIUt4ODfA24SyNchsI7LKw/wkcfW6IqPBzridU6jJTZ4N20himmf4KrAsOaSyDbTgxvpTGLztWAp+3Nnl1OXyqaBgrd2NRrTjAvCvj42WOU9ttE8EkoPUul5KfxkqF09K5PNITt6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lJWeDKGT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lJWeDKGT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 850DDC4CEF7;
	Wed,  4 Feb 2026 15:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219212;
	bh=Z3ruvMwmxXj2pSm6nL9EquPaLTJGOJo9m0rJnD0CUR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lJWeDKGTop6+DboSxtifv7nvJBRhq7FMQKNULoOftjNGiKINILrDelQZcYwt8ufUm
	 VBy2/zTPfdlKCx7D8shzVgxhdu6dbUTJ+UZJYkwLbHjPYpW8sGadDXVtvQHo/Kp9Lf
	 QgNdUrb/dpdUKaVBzbpUFD/1Ieho9Y//98l/WvR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Hang Shu <m18080292938@163.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Gary Guo <gary@garyguo.net>
Subject: [PATCH 6.18 066/122] rust: rbtree: fix documentation typo in CursorMut peek_next method
Date: Wed,  4 Feb 2026 15:40:48 +0100
Message-ID: <20260204143854.231372144@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -835,7 +835,7 @@ impl<'a, K, V> Cursor<'a, K, V> {
         self.peek(Direction::Prev)
     }
 
-    /// Access the previous node without moving the cursor.
+    /// Access the next node without moving the cursor.
     pub fn peek_next(&self) -> Option<(&K, &V)> {
         self.peek(Direction::Next)
     }


