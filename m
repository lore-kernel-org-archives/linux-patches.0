Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3973D1CCA;
	Tue, 21 Jul 2026 18:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656985; cv=none; b=c/Gi1YsBmlFkP/Gqsp70I7spvWTX3GZb3OaYisZBCqwXrfDJZ5v4tkSXPbESd17RIWP87/vVzwZK/ItDg8DxxL0tdNi4dTD7nk9Zrl6fp/PJTMxWKsnEhJWKm2ufdrvwG+X1xb1lWzDYX3gvGLPFnceG4vwNLK7KmFLRFGCxFQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656985; c=relaxed/simple;
	bh=kbqkW/bnuILlMfq/lIb8Ekp3/9EI8tek4BetqbzPFnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EE+h9pV/VffBzESDF1WfOiWzRltS+0DXxOX4DoFl6B5NN9jFEgoQCPvDjkuLYYJ+seNgZShNUWF6Kv4S3oKyXoBlLfV4Ufo7sJS9W8CsRFf1m26hZN2DHqZJi0vKSUVbqJ1pHmHvPtpjWxMdR+T+8Vh5kPXBW22E7zvOh7NJw0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YdjFJZhP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YdjFJZhP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79E3C1F000E9;
	Tue, 21 Jul 2026 18:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656984;
	bh=EMwWIx5Va8lyfGGymQGItIS3jb84gmWojjJdb3cL0zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YdjFJZhPAaMLsyKqWaTjD9o5/xvgmBC/FxAxLzuUk46BazvdZlAC84Lz9/66BEVZl
	 4oD+5uZORVQYXcNnYTTWYj5HHb+W/X7Q0CgBVWFW8cvBqIZ1hL11oN8vuhzZrqU6Ae
	 GAocnC3AmfwveYIqFIjvso9sUamhp3iyWjwM/oLI=
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
Subject: [PATCH 6.18 0592/1611] rust: alloc: fix assert in `Vec::reserve` doc test
Date: Tue, 21 Jul 2026 17:11:48 +0200
Message-ID: <20260721152528.699747428@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index b6a97b8fb51211..223c5ae0f83153 100644
--- a/rust/kernel/alloc/kvec.rs
+++ b/rust/kernel/alloc/kvec.rs
@@ -611,7 +611,7 @@ where
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



