Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D29D30F80D;
	Mon, 13 Oct 2025 15:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368870; cv=none; b=IWFl/WAKYULpyT2Qph5aO8FifFzFWNyKeyRnkwwUTdlWal6e1THzQ63GHLc3mlYLdbx/ynLfd5dJd/1wCnTqS7eLHzAzRB82X9gF195ppGFoah9OU+/+oUFbV7At7HxAZ+sIb97F6FYoSgBQ5jeTU4ehpOoaMVDZ7m1dfZQelFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368870; c=relaxed/simple;
	bh=DXVM05JLiVKYbbYlirY4cXwYnLuZ4KMIY4BxD6nlNNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gndPFX0ljHfDmPVEpn0w1ZmKoaPOmBJcHfjuEK/lNTnzeUhzYySx601kVxf3004UxHjpOZsZT39aCjk2g8z2jLdSsy4NehpCmQubux7qEwqCamGt8eOWav09WtaUXMewnJv3HhK29NfSDAkFf4xc8U7ZdBjTz8TZsVDt2o+vJeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DluiS9hB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DluiS9hB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8785C4CEE7;
	Mon, 13 Oct 2025 15:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368870;
	bh=DXVM05JLiVKYbbYlirY4cXwYnLuZ4KMIY4BxD6nlNNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DluiS9hB4PAscg8xSxQjaGUM1P9nGzqnYyOySJhDuveLtQM00WtKVmiNl09ZceYiX
	 3e6DI02erxa4ZzXzXNpXykxvP3ev4wmztkhnvHO7vE4CEscqSKJHXEr0fqSf4av4js
	 YlvC6n5qS5aJ//apqwhQHo/HK64gJtp1zDfFOos4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baptiste Lepers <baptiste.lepers@gmail.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 046/563] rust: cpumask: Mark CpumaskVar as transparent
Date: Mon, 13 Oct 2025 16:38:27 +0200
Message-ID: <20251013144412.962211397@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

From: Baptiste Lepers <baptiste.lepers@gmail.com>

[ Upstream commit 23fca458f6ab18927e50c2134fb7b60297f18b4e ]

Unsafe code in CpumaskVar's methods assumes that the type has the same
layout as `bindings::cpumask_var_t`. This is not guaranteed by
the default struct representation in Rust, but requires specifying the
`transparent` representation.

Fixes: 8961b8cb3099a ("rust: cpumask: Add initial abstractions")
Signed-off-by: Baptiste Lepers <baptiste.lepers@gmail.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/cpumask.rs | 1 +
 1 file changed, 1 insertion(+)

diff --git a/rust/kernel/cpumask.rs b/rust/kernel/cpumask.rs
index 3fcbff4386705..05e1c882404e4 100644
--- a/rust/kernel/cpumask.rs
+++ b/rust/kernel/cpumask.rs
@@ -212,6 +212,7 @@ impl Cpumask {
 /// }
 /// assert_eq!(mask2.weight(), count);
 /// ```
+#[repr(transparent)]
 pub struct CpumaskVar {
     #[cfg(CONFIG_CPUMASK_OFFSTACK)]
     ptr: NonNull<Cpumask>,
-- 
2.51.0



