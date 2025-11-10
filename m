Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70FA51E492D;
	Mon, 10 Nov 2025 12:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762777368; cv=none; b=WHVxWT8XY2FiASbd7VPgsxrVAg35CfpjMoJaPjEwHUw4rPZn8qT8XMyktJWb0T8QclzQwBF/h17bX2MwR4Foz35AGrGe01h3M3vNswZGKImFt0QPff1br7sbqmQCh7wkE76WM/osgm5GYm+TY23+EUwk73fEBC7w4I8rOkZJEYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762777368; c=relaxed/simple;
	bh=xAU0mcHvvHztf6e/124K2Q7q7xiytklarHatnR9+c18=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tEgxZ40p/nLvVkJaJMuc8gqMspwR0LPg2bMvatxEoFFuxfoMLcvrlZc4eIRdXUUu0rNQl6woI7IWACFuszNbvCUe7yzN3KT35lXliJn8jECGxw8lb52HMv0MjYUBDWtqeITcIyP8tmUAkfuz6Agqitz9dQJKT1e2Q0/HMUhaG1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gTODCh0p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gTODCh0p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7610EC4CEFB;
	Mon, 10 Nov 2025 12:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762777366;
	bh=xAU0mcHvvHztf6e/124K2Q7q7xiytklarHatnR9+c18=;
	h=From:To:Cc:Subject:Date:From;
	b=gTODCh0pxTplVAfGXTvgpmRsM7WQ6QKHZ26CCFa/Bze/OIKiYAFRZyCUlrj5ZxzPb
	 1kkUPvVrtJeAy4Y3RPhKUtVspTaDidcosor9lTQuzZ1DZIdEEaZY0VOuthiGBoN2u5
	 4VnttDIO0PRluhFgiKw61fuBXbCskn0VtPVmkkjHJ2ERqmhdH/yJ02dKCBoMLNg/a1
	 dNiV8STiIhoeWJQLpVoyeQPHsMlTHRNlUWHlWWOTaRm6aDyChww6QiE3ZxIgQExaED
	 PwJOtkN6EAEAlxro58s1ySQMKzdH02eKHWn7xqbKj95btEfDi4HahUmBAVX+NxaMtr
	 mmOvS68wU7vMg==
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
Subject: [PATCH 1/3] rust: net: phy: fix example's references to `C{22,45}`
Date: Mon, 10 Nov 2025 13:22:21 +0100
Message-ID: <20251110122223.1677654-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The example refers to `phy::C{22,45}`, but there are no such items --
they are within `reg`.

Thus fix it.

Fixes: 5114e05a3cfa ("rust: net::phy unified genphy_read_status function for C22 and C45 registers")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
Please feel free to drop the Fixes tag -- I generally add them for
things that get actually rendered in the documentation, since the stable
team sometimes picks even typos, but it is of course not an bug on a
kernel feature, of course.

 rust/kernel/net/phy/reg.rs | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/rust/kernel/net/phy/reg.rs b/rust/kernel/net/phy/reg.rs
index a7db0064cb7d..4e8b58711bae 100644
--- a/rust/kernel/net/phy/reg.rs
+++ b/rust/kernel/net/phy/reg.rs
@@ -34,10 +34,10 @@ pub trait Sealed {}
 ///
 ///     // Checks the link status as reported by registers in the C22 namespace
 ///     // and updates current link state.
-///     dev.genphy_read_status::<phy::C22>();
+///     dev.genphy_read_status::<C22>();
 ///     // Checks the link status as reported by registers in the C45 namespace
 ///     // and updates current link state.
-///     dev.genphy_read_status::<phy::C45>();
+///     dev.genphy_read_status::<C45>();
 /// }
 /// ```
 pub trait Register: private::Sealed {

base-commit: e9a6fb0bcdd7609be6969112f3fbfcce3b1d4a7c
--
2.51.2
