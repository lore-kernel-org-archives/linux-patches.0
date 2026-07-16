Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B8441E6D4;
	Thu, 16 Jul 2026 13:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209001; cv=none; b=QPgs86dG8G0YqBJa1aDG9EMGuIZ4b9ssWEmwzpEei6O53bMrt7YvunhXvxOsYz3QT9/gbKsjuIDtU8qlY9eRCX18Rk9i6O/oRODwTf3XE74hYY1F6NvTFUPkTqrW8DxitX0t+PmxJDI411QTRFGqu7V8GuM2pzILp4Ontrub6a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209001; c=relaxed/simple;
	bh=6X8PpLPqa4fhydxuhgV9OY62xQi0MXe/YLnTowvMgcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s16gttYN9XLolxFT9v3nJK6wyVUG6BWUrffbMSw5ZvkWhpMeqzU2uoy3ml7qVECqrfBdD5mx6n92RWwOk0pycteYQlCCoyHhcbQlQzkzzvs0CvHifiwAIbdZScoBxzs9XDHzcrpnIc9caLQVxxWMJfNyxo4VsYEsFNnJiKCOP+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lq7tdJud; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lq7tdJud"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 912AE1F000E9;
	Thu, 16 Jul 2026 13:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209000;
	bh=iAwSMhtvFSNlmNKBaYyFiJnTBRpqQZ7ZmBiKLBBrN4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lq7tdJudmUUivntzK7JPFrj3+vC2HKN6tSvFyFlNm1snqhllCImSISq3a8XQurJ1U
	 Pmft/n3+6yYhJd7UIieIOb7VNM1cN1rY5v+SeMDEh0gek7vD1zulEBTBdudxj6zXT9
	 +e5UJzjjzCpzQLxg3vAFRe8GPS/VWbkoAp0yxcsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gary Guo <gary@garyguo.net>,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 002/518] rust: str: clean unused import for Rust >= 1.98
Date: Thu, 16 Jul 2026 15:24:30 +0200
Message-ID: <20260716133047.830656300@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

From: Miguel Ojeda <ojeda@kernel.org>

[ Upstream commit 3fff4271809b57182c4011811e96556bdd4cb2f9 ]

Starting with Rust 1.98.0 (expected 2026-08-20), the compiler has changed
how the resolution algorithm works [1] in upstream commit c4d84db5f184
("Resolver: Batched import resolution."), and it now spots:

    error: unused import: `flags::*`
     --> rust/kernel/str.rs:7:9
      |
    7 |         flags::*,
      |         ^^^^^^^^
      |
      = note: `-D unused-imports` implied by `-D warnings`
      = help: to override `-D warnings` add `#[allow(unused_imports)]`

It happens to not be needed because the `prelude::*` already provides
the flags.

Thus clean it up.

Cc: stable@vger.kernel.org # Needed in 6.18.y and later (prelude added to `str`).
Link: https://github.com/rust-lang/rust/pull/145108 [1]
Reviewed-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Link: https://patch.msgid.link/20260609104152.261145-2-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/str.rs | 1 -
 1 file changed, 1 deletion(-)

diff --git a/rust/kernel/str.rs b/rust/kernel/str.rs
index a7fccd4c4f3b18..4517c1bc547afb 100644
--- a/rust/kernel/str.rs
+++ b/rust/kernel/str.rs
@@ -4,7 +4,6 @@
 
 use crate::{
     alloc::{
-        flags::*,
         AllocError,
         KVec, //
     },
-- 
2.53.0



