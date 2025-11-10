Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7916324A05D;
	Mon, 10 Nov 2025 12:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762777370; cv=none; b=ciKjF0x03p/K6X3ZeEBqZ3b4glQ6su0HFHo9DKQpc+tbYB3b3S2uWfacavWkCdm9Xjs8RV6naA0CGcps6EDDqYY0qeCPfj0JdOUfnndQTzthcNB8o5e5c2cmgWpvNjPrMzZFX+/AwKX76bP0DCs6IMAn77Tgac+bS5HtmZ8mEbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762777370; c=relaxed/simple;
	bh=1txYqI0NfJPVjX1jc1VEjFEJz01cfG2RKB2vr99FxV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sxZJ0pWPdCBz6gMc6WLcqukAY3Yf+LkFKQufRO7rc3tHNCxBS+trjypMHYoB9hClbJjG9lZlHYvQI+wexr3HOAf+EdYFTHHNMHsl+05wpmpmdWvs4QDk7SJEFQldxadyCNrtXNCFKH0zs5w0R2VMmb8IGPBhOAAOwsuiRJRT6dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ueHf8Tj5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ueHf8Tj5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE34C116B1;
	Mon, 10 Nov 2025 12:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762777370;
	bh=1txYqI0NfJPVjX1jc1VEjFEJz01cfG2RKB2vr99FxV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ueHf8Tj52UolkHheEPDSjsiBK0FHsPX0Ju6hw72xSVhlQg4TzFUI0IrNr5S4CEZLr
	 08w4ibm7VSNAIM/CwEdBlqLQGAHbENrFAq+txXA7ln5lRmxF7sxqhkVep1eWVxg5Qp
	 cFckcOjTw/G9EG3nH5XXgcmqOeAAniPxyAATM1MOlfCZ+dAsEx29oRRlYBALQC8hFp
	 Tx6dU7IH72tB9B0Uc4nmc6CuDMnogwC6x1xhmIgNc5BJ3MUDBreswLKXLjn5jBTREX
	 Sq0VRBEkvzv4YYhXGXcjYBMoXRscOCRYC4r4Sf0igvymf29FTITu2VuuFB/vyNJIxS
	 hpguq+YJCJlig==
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
Subject: [PATCH 2/3] rust: net: phy: make example buildable
Date: Mon, 10 Nov 2025 13:22:22 +0100
Message-ID: <20251110122223.1677654-2-ojeda@kernel.org>
In-Reply-To: <20251110122223.1677654-1-ojeda@kernel.org>
References: <20251110122223.1677654-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This example can easily be made buildable, thus do so.

Making examples buildable prevents issues like the one fixed in the
previous commit.

Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/net/phy/reg.rs | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/rust/kernel/net/phy/reg.rs b/rust/kernel/net/phy/reg.rs
index 4e8b58711bae..165bbff93e53 100644
--- a/rust/kernel/net/phy/reg.rs
+++ b/rust/kernel/net/phy/reg.rs
@@ -25,7 +25,16 @@ pub trait Sealed {}
 ///
 /// # Examples
 ///
-/// ```ignore
+/// ```
+/// # use kernel::net::phy::{
+/// #     self,
+/// #     Device,
+/// #     reg::{
+/// #         C22,
+/// #         C45,
+/// #         Mmd, //
+/// #     }, //
+/// # };
 /// fn link_change_notify(dev: &mut Device) {
 ///     // read C22 BMCR register
 ///     dev.read(C22::BMCR);
-- 
2.51.2

