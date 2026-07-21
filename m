Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C51388890;
	Tue, 21 Jul 2026 19:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662382; cv=none; b=C8hkZ3qOlo3sg52xtHIn8XB3RsuiwB7vZP0kQpsEG8E5BPxrmc/2265bB1iMOsVwaRobZ83n83mrFdlRQ9CR2JkNUvFwpcsgchkI/IN7hzUkK3yQEv8undpvbhc25lYfDZD2npcXrLkU6zVeUa/UkUDbR4Ya6e8Akr5zno90/yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662382; c=relaxed/simple;
	bh=T2bS1Vgih6PehUUVVqVlZgXq9w1IxJE78qfTZWufB9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MI2OAxWHUjrst28mDcksMtQEIrfvRDzcLdyU5Bx6NLr1Il3SGPkFswCpBeym3wcBYYp7aco1YlpFjmSBgWL7Auum/gSQpdEysay85+4x9B8Gr3pLNeKQIR/wJihT6iAAkxuBZzFm6s/U7lzZ27MlUM1Sbb76G7YaG+g4XdAnLFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ncZIQePs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ncZIQePs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 813E61F000E9;
	Tue, 21 Jul 2026 19:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662381;
	bh=E48J6DbLwLp4Hztf5q0eAr5eTgEGEYOYY7bDLZ4z8nU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ncZIQePsjMkgosBaOJ2Ha5vuQEYap9RL2i7Zj5GAxIiK6Z9ru747pgRktGvkY7ofC
	 j28/9gCa7PAsiMD5W2qsWKMqHtRr63SyIaQhW3olWk71S0+GZ7Lqq9Aw61yomx7Q33
	 yXw0d4+ZeojEvuNMq9qZIzRYpqtJsHrweXRWEyP8=
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
Subject: [PATCH 6.12 0424/1276] rust: alloc: fix assert in `Vec::reserve` doc test
Date: Tue, 21 Jul 2026 17:14:27 +0200
Message-ID: <20260721152455.589937779@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
index 28dc9ee02cb07f..df52ca6fd438e8 100644
--- a/rust/kernel/alloc/kvec.rs
+++ b/rust/kernel/alloc/kvec.rs
@@ -411,7 +411,7 @@ where
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



