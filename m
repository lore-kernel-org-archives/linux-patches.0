Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72DC2DEA74;
	Tue, 21 Jul 2026 18:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660123; cv=none; b=XeBgL9sRKH/6xiHxr/jyFZPORBpfHfa5PnICV1eINoC5JbPRCTmBN5Dx6whtobIpZsfEroVthE9XN9cCtnY0LjifhlIf+snnEITyMON5JTBYkI7P9sxLl/QGtYqJ6OgZF9gNqNe7pTXT1KQoTWsZvxaYFtgL6n7G+8HKM6qy4yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660123; c=relaxed/simple;
	bh=jV1S8O5Atu3B7kULlLym8iz0Pa7mB8g6zwTkA6igW0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K/hbJgtWiAqPbsFHxuXNIVKlwtglmy9VAbOiFrub0gOHQDU0WkXUUa9tBG9E7qA8e5qduEDRA9RJG6enSD4gv/ndJL0EOzKIlGeFqHuNqnQ8Mjtph0b+dxl49nyu7Q6sZKN4b1TX0TtwUCnez55rNzdCru1cxwQjPydHJvsHjKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HkBKHmuQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HkBKHmuQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ED231F000E9;
	Tue, 21 Jul 2026 18:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660121;
	bh=t3lzwNFE1BgXVtBifY+fIjsFhhylgABaS3JpCR1+k0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HkBKHmuQbUXsaCKVTVoveuhsJzWUTcrQnx4lkQEDvNV1tith+6HNIJvfXqgqWaZaJ
	 5cZHTRee6tsOBHGFlQSVS+luQg+n3XdZKY8kbQ+Cf5dHxBP4xS+ykAItKcetnJeIZZ
	 GR8Cphm7quCRtz8pqUI4zNgV783fKGDosWYIpM5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Hsiu Che Yu <yu.whisper.personal@gmail.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0859/2077] rust: alloc: fix assert in `Vec::reserve` doc test
Date: Tue, 21 Jul 2026 17:08:52 +0200
Message-ID: <20260721152613.050632234@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hsiu Che Yu <yu.whisper.personal@gmail.com>

[ Upstream commit 75619f2df7a5da6ffb61eedc2a73fdf70c65471c ]

The assert in the doctest used `>= 10`, which only checks that the
capacity can hold `additional` elements, ignoring the existing length
of `v`. The correct check should ensure there is room for `additional`
*extra* elements on top of what is already in the vector.

Fix the assert to use `>= v.len() + 10` so the example accurately
reflects the actual semantics of the function.

Reported-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Closes: https://lore.kernel.org/rust-for-linux/CANiq72nkXWhjK9iFRrhGtkMZGsvNE_zVsu4JnxaFRfxWL7RRdg@mail.gmail.com/
Fixes: 2aac4cd7dae3d ("rust: alloc: implement kernel `Vec` type")
Signed-off-by: Hsiu Che Yu <yu.whisper.personal@gmail.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
Link: https://patch.msgid.link/20260427-doctest-kvec-reserve-v1-1-0623abcd9c2e@gmail.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/alloc/kvec.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/kernel/alloc/kvec.rs b/rust/kernel/alloc/kvec.rs
index 5c24fcf05bdfe6..0f7b43e81030cd 100644
--- a/rust/kernel/alloc/kvec.rs
+++ b/rust/kernel/alloc/kvec.rs
@@ -614,7 +614,7 @@ where
     ///
     /// v.reserve(10, GFP_KERNEL)?;
     /// let cap = v.capacity();
-    /// assert!(cap >= 10);
+    /// assert!(cap >= v.len() + 10);
     ///
     /// v.reserve(10, GFP_KERNEL)?;
     /// let new_cap = v.capacity();
-- 
2.53.0



