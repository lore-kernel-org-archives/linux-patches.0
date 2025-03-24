Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2DF1F4E5B;
	Mon, 24 Mar 2025 21:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742850286; cv=none; b=FoZyC+7DGgQAWGHPKS7E7lBRz9CQkTCVixpU4p36F96yKWArEnt8HO/rh1zj87xlNtAGq8VEzpBGLVutQqVuqdekGaoX7/yQGlFXDuOMmYshzox9sdSGS87i2G5gL7sBOVedDVkPrIbdBxPaSoZTSKTH0oA9lSbqJ4TXuIdpfC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742850286; c=relaxed/simple;
	bh=mHKeb8XQeBT7AknJSDbq+TI1Xp0mqj3SSJYVGRZPVMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mRB28WQS9dXV8yByz1HRdsm4pUohrxgqxiDRiZvesdQTDGpaeJmzicasC9/a0B3Mkf+YGXhbBy4by0YRDC1RbZ33NjIfElk8r68AXAYt6bvhe9afubb/gnrGQvRzuNm8WsGF1IA4cEVM5ns+N1UYS8pdPYknCFs9PWqzQ3JcpmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KO2bVP0Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KO2bVP0Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4481C4CEDD;
	Mon, 24 Mar 2025 21:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742850285;
	bh=mHKeb8XQeBT7AknJSDbq+TI1Xp0mqj3SSJYVGRZPVMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KO2bVP0QCbiSlPBF7HbKfjISsbwpN3I2YuiLadpf+X4lQlNaC6Ko6SDimMgEEr02x
	 9OsH5OhSEz6w5GwNSleBC2ilKo8kcMJLI2zoadcmIQkh5zbQ7OConF5HpSGyURasnj
	 fKxA8UwZisYul/Y4iaC6GOO55VLcV0VNn94wx09PD0lrmd7WecbysC6RdjgFcVqtFd
	 tkh8uIItoqd7A1HzE+N27OqejS/3KaMwo01+3YMbQ0edwN+X9eel+bRomgBu82TrsE
	 q84sJAdU6apr0YRk0M57ZSaY+3CXK7fnVHmYFbCOnzpwBdU4ag+YQ6S2M8ZsuLoi+O
	 cJ5lr1bxLBrxQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 08/10] rust: platform: fix docs related to missing Markdown code spans
Date: Mon, 24 Mar 2025 22:03:55 +0100
Message-ID: <20250324210359.1199574-9-ojeda@kernel.org>
In-Reply-To: <20250324210359.1199574-1-ojeda@kernel.org>
References: <20250324210359.1199574-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert `TODO` from documentation to a normal comment, and put code in
block.

This was found using the Clippy `doc_markdown` lint, which we may want
to enable.

Fixes: 683a63befc73 ("rust: platform: add basic platform device / driver abstractions")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/platform.rs | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/rust/kernel/platform.rs b/rust/kernel/platform.rs
index 1297f5292ba9..2426eaf915bb 100644
--- a/rust/kernel/platform.rs
+++ b/rust/kernel/platform.rs
@@ -147,10 +147,11 @@ macro_rules! module_platform_driver {
 ///```
 pub trait Driver {
     /// The type holding driver private data about each device id supported by the driver.
-    ///
-    /// TODO: Use associated_type_defaults once stabilized:
-    ///
-    /// type IdInfo: 'static = ();
+    // TODO: Use associated_type_defaults once stabilized:
+    //
+    // ```
+    // type IdInfo: 'static = ();
+    // ```
     type IdInfo: 'static;

     /// The table of OF device ids supported by the driver.
--
2.49.0
