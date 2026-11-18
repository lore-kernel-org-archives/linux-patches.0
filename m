Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025680;
	b=L9Q2ljOY/VGQtGNCZECQAyTSulhdDbJv41MP7G03BBRrigUDNQNvtrfb1Du3OCj+IPNk
	 1BBDVCh3ZFSHVx6PgCNUQVuxBK+kEouvlNcCAK3HSGaxZicIyYQ+2E2nRrEYoRMICDnh8
	 EOM5r649Tbq6jmak3vCxBTmW/w3G6qBhxi6EXS6fLF2CN/823voVC28E+/ROZitfKyg2h
	 JFu8PVfGFxW4QXgcjWrRQXjSHNOda4GAw55tKASWOHdrKv2aNQ3KCa1Wu8yppZKZR7UOE
	 YDmWCL+xiGJJvnDMyxzKve3j2POuFT3SMb+HaN/i2zKVVdYbIhi/1PPQ38kau8Sdb5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025680;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8kCp+QqasleY1udWH/CP3hp3wwROj8n58Rkej2J6lzA=;
	b=bnK+GHArnk/i1nIxFxYx62IPcI8G1PBsRZ9NodS2v8H1y1MgqZZuqMAYE3hfyCijM/PA
	 3aYsWLNuakG7amZFhMIyL2/yh7uWJ5yHExopKCH3UErA+y+AJQYrt9SXGxXfCidcZui8c
	 tvBRJbhntfgI/8tfy7SCkPmYPT5AgryUK4ZS6ys8ACLBo1RshFjR63mOFrm8ErlhFzJba
	 zY3Ug6v2lEeF+4wf9vQrpvK/vZ/geKtOBziawP97afBNv5Elcvg/vlgYMph7SM1KjKw9n
	 daP92AbBHbm1fuH9DiqLgTpSo0+f61XO1SNoO9otGY70/foEctrkPI67N5aStunEidw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aZrqeAn5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6317606A31C;
	Wed, 18 Nov 2026 18:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aZrqeAn5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDE511F000C5;
	Wed, 18 Nov 2026 18:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025680;
	bh=8kCp+QqasleY1udWH/CP3hp3wwROj8n58Rkej2J6lzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aZrqeAn5dPp5s4UU4OM+vMiFnnn2qM3g1Eg5Hn1b5wOl6uEm0DZaHMO1FWpT9GwUK
	 WTcIqGiXdkz96f7RG8oGOQYV1F/Awsf7mDj+qWKG57KChrvuZFnyvYapd6idR6S7Q9
	 UTlLrlqA4n07NSUwrpjq/3a9BkncNlVc3DEmtkao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Courbot <acourbot@nvidia.com>,
	Georgios Androutsopoulos <georgeandrout13@gmail.com>,
	Yury Norov <ynorov@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1166/2151] rust: bitmap: document panics in `next_bit` and `next_zero_bit`
Date: Wed, 18 Nov 2026 15:48:21 +0100
Message-ID: <20261118150204.626865498@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Georgios Androutsopoulos <georgeandrout13@gmail.com>

[ Upstream commit a73b4d1fa7d334a5f7de5bb0a14726530f66196e ]

`next_bit()` and `next_zero_bit()` use `bitmap_assert!()` to check
that `start` is less than `self.len()`, which panics when
`CONFIG_RUST_BITMAP_HARDENED` is enabled. However, neither function
has a `# Panics` section, and both document that `None` is returned
for exactly the input that triggers the panic.

Update the documentation of `next_bit()` and `next_zero_bit()` to add
the missing `# Panics` sections, add the missing blank doc comment line
before `Returns` in `next_zero_bit()`, and simplify the wording.

Fixes: 11eca92a2cae ("rust: add bitmap API.")
Closes: https://github.com/Rust-for-Linux/linux/issues/1252
Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
Signed-off-by: Georgios Androutsopoulos <georgeandrout13@gmail.com>
Signed-off-by: Yury Norov <ynorov@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/bitmap.rs | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/rust/kernel/bitmap.rs b/rust/kernel/bitmap.rs
index a00988bc8191a..b17a108db1004 100644
--- a/rust/kernel/bitmap.rs
+++ b/rust/kernel/bitmap.rs
@@ -477,7 +477,13 @@ pub fn last_bit(&self) -> Option<usize> {
 
     /// Finds next set bit, starting from `start`.
     ///
-    /// Returns `None` if `start` is greater or equal to `self.nbits`.
+    /// Returns `None` if no bits are set on or after the given index. The
+    /// index `start` must be in bounds.
+    ///
+    /// # Panics
+    ///
+    /// Panics if `CONFIG_RUST_BITMAP_HARDENED` is enabled and `start` is
+    /// out of bounds.
     #[inline]
     pub fn next_bit(&self, start: usize) -> Option<usize> {
         bitmap_assert!(
@@ -497,7 +503,14 @@ pub fn next_bit(&self, start: usize) -> Option<usize> {
     }
 
     /// Finds next zero bit, starting from `start`.
-    /// Returns `None` if `start` is greater than or equal to `self.len()`.
+    ///
+    /// Returns `None` if no bits are zero on or after the given index. The
+    /// index `start` must be in bounds.
+    ///
+    /// # Panics
+    ///
+    /// Panics if `CONFIG_RUST_BITMAP_HARDENED` is enabled and `start` is
+    /// out of bounds.
     #[inline]
     pub fn next_zero_bit(&self, start: usize) -> Option<usize> {
         bitmap_assert!(
-- 
2.53.0



