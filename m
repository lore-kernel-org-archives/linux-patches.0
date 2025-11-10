Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6DA24A05D;
	Mon, 10 Nov 2025 12:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762777374; cv=none; b=p/iHLRh/XFhehIuDVxeCWSHZVDJI6Zf9twKWKnk9/kmBEhQLYDBXA98yGfLO7WDv2qiNTupKwVAp00jylKXZ604gGmPS+5S4wdN51JbVeyd0uQ4VkOdX5zXtoL8R7XnwYNU6wffDk5AMAHS3ZC/D6+buWE1UISKMP5aQrSvuXcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762777374; c=relaxed/simple;
	bh=YY2a8MiBu+A34uZZx2cYOxj0iHaCwvR13+I+yYMoUD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VlhQx3khBg35LLkt773N+OLSOPGDIen1Bdf8GNvnJhD0clO4tXaPeIvbBXCMLMPQLTXyTV7htrJAjHUA0sulJQKNtCJNBVxfifFALtdSVFHBGVOgET/zIZIZEOhKd6jVgc3mSz9PS8fN8BDzMeRKtZOb5D+H7V3+GPIGxKk8ivo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YsRhTAKR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YsRhTAKR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5982C116B1;
	Mon, 10 Nov 2025 12:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762777374;
	bh=YY2a8MiBu+A34uZZx2cYOxj0iHaCwvR13+I+yYMoUD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YsRhTAKR3zbhaM6X1BTHuRO0XzAgsA86oI/tbEnLhh1PFWnaSEJV9KsqagvI9Nj0J
	 pXKe6Si103MnmI/jN9NmhJGW1VXriJjhtH7ODREevN/520zFKW9XwOdrlOVd1diZDw
	 qHaiQH8JgO1gq5+w2dmc9C2S3E7GUqzsp+sjEYdEUdMIknNepSb3cha31mPCg7yYTm
	 1pPZq0fFKugldsKiztMKH6qwuNkzRotx+8dF5eAQax1ySc0kSI6W0NFWVKBYihLPua
	 H1Sc0WsnbjevWQa0oDGUO0H08RaQITzHh6L0ve0rAqS7HHmtQi/2/0CmSk4/WuV6c2
	 V2vNXsmoCdp6A==
From: Miguel Ojeda <ojeda@kernel.org>
To: FUJITA Tomonori <fujita.tomonori@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Trevor Gross <tmgross@umich.edu>,
	netdev@vger.kernel.org,
	rust-for-linux@vger.kernel.org,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Danilo Krummrich <dakr@kernel.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 3/3] rust: net: phy: follow usual comment conventions
Date: Mon, 10 Nov 2025 13:22:23 +0100
Message-ID: <20251110122223.1677654-3-ojeda@kernel.org>
In-Reply-To: <20251110122223.1677654-1-ojeda@kernel.org>
References: <20251110122223.1677654-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Examples should aim to follow the usual conventions, which makes
documentation more consistent with code and itself, and it should also
help newcomers learn them more easily.

Thus change the comments to follow them.

Link: https://docs.kernel.org/rust/coding-guidelines.html#comments
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/net/phy/reg.rs | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/rust/kernel/net/phy/reg.rs b/rust/kernel/net/phy/reg.rs
index 165bbff93e53..5a7b808915f9 100644
--- a/rust/kernel/net/phy/reg.rs
+++ b/rust/kernel/net/phy/reg.rs
@@ -36,9 +36,9 @@ pub trait Sealed {}
 /// #     }, //
 /// # };
 /// fn link_change_notify(dev: &mut Device) {
-///     // read C22 BMCR register
+///     // Read C22 BMCR register.
 ///     dev.read(C22::BMCR);
-///     // read C45 PMA/PMD control 1 register
+///     // Read C45 PMA/PMD control 1 register.
 ///     dev.read(C45::new(Mmd::PMAPMD, 0));
 ///
 ///     // Checks the link status as reported by registers in the C22 namespace
-- 
2.51.2

