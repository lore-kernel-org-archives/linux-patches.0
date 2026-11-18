Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017055;
	b=nhdWwkEjdzc1dhdyn/gY5Dn7g32HZ4FO8nTG6wAp9n03P+PSNW216DApjWXJYa8fXEYQ
	 zf0jt2hPpQATeR+8xrPaCW7CuP+TQRKwrP4DhrScd3d4q68W+q8zvrwRSTK8WuDCJxWFJ
	 k5MTghKgtU40NT7InGFHsjdLdcXELrkxtqxNfQx1WVurpGiKwg2nYdUS7jixWWXYpvOTc
	 Xw04zCrMWAVE0vhgDWBTwHc/Zg5iJiazmTq8r6wdCc1NJufeoWbz98zyursEGFtu70L24
	 vYpzuaFbm0ww+9ABvYzmtaLVpb/c1G9YcdPRMzUz4K9OGCVpUhNI19dq+WvEsny4uMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017055;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5cH8j/i8O33zWxdtifdE1gVoM/3K6tqe/x4bJBx9Ky4=;
	b=QedjxFwZIpimJlgXGeZ/PpmP7Nd6CgdL7ZHa3N7EQ4zJAU9QpNjtPwoE70FAM5cw41Yx
	 m9i/31FdnSYk4390tC+rHiO/ENJBGMaXLGbiL2AI5dpMZIepT6TQEyvR6P3PvaA7G1HwM
	 L8alkSMeCNoRv5XdS0+GvZHCYqMFHTtAesrFWswp7onBiaN83sLEDX5EO/V9nN2PE7oCG
	 lt5hnVVWNr2J9q9WKDC/kipvRGmbtHz9V+OXbBDX1eIxBkte5Jh5Rlk1W13ha5rGOP66g
	 jH6TFK+ugk6iTPdY3sLRdJTkRO77rvfUjwvd0/h/wVfGsV8v0kPnzDxjaoswGmvB96A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LYe+nK9G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23FD0606A31C;
	Wed, 18 Nov 2026 15:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LYe+nK9G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75CB51F000C4;
	Wed, 18 Nov 2026 15:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017055;
	bh=5cH8j/i8O33zWxdtifdE1gVoM/3K6tqe/x4bJBx9Ky4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LYe+nK9Gdrdvl88N2Jjcd2UM8hWAGRtpll5Myao/0P9BUdYJIjDTiDdNYLvfyfO6Z
	 rV3f3Bf2AUPibKStd8AWl0pwWYsjgcCv5yxpo7nA8/hYVv2yzbD+soaEzK3hGmIYxB
	 SsIDjEJPWJf/zGFKYoWgGGJMTxJRnBDDHO69W19I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgios Androutsopoulos <georgeandrout13@gmail.com>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0749/2651] rust: clk: document overflow panics in `Hertz` constructors
Date: Wed, 18 Nov 2026 15:33:09 +0100
Message-ID: <20261118150314.847276287@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Georgios Androutsopoulos <georgeandrout13@gmail.com>

[ Upstream commit 45a68afbd4b632538a0956ba783fca45b8ceb446 ]

`Hertz::from_khz()`, `from_mhz()` and `from_ghz()` multiply their
argument by 1_000, 1_000_000 and 1_000_000_000 respectively without
checking for overflow. When `CONFIG_RUST_OVERFLOW_CHECKS` is enabled,
each panics once its argument exceeds `c_ulong::MAX` divided by that
factor. None of the three documents this. The panic occurs only at
runtime, when the argument is not a constant expression.

Add the missing `# Panics` sections stating the bound for each unit.

Fixes: d01d70205601 ("rust: clk: Add initial abstractions")
Signed-off-by: Georgios Androutsopoulos <georgeandrout13@gmail.com>
Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
Acked-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/clk.rs | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/rust/kernel/clk.rs b/rust/kernel/clk.rs
index 7abbd0767d8cf..f04f5c4a03d64 100644
--- a/rust/kernel/clk.rs
+++ b/rust/kernel/clk.rs
@@ -35,16 +35,31 @@ impl Hertz {
     const GHZ_TO_HZ: c_ulong = 1_000_000_000;
 
     /// Create a new instance from kilohertz (kHz)
+    ///
+    /// # Panics
+    ///
+    /// Panics if `CONFIG_RUST_OVERFLOW_CHECKS` is enabled and `khz` is greater
+    /// than `c_ulong::MAX / 1_000`.
     pub const fn from_khz(khz: c_ulong) -> Self {
         Self(khz * Self::KHZ_TO_HZ)
     }
 
     /// Create a new instance from megahertz (MHz)
+    ///
+    /// # Panics
+    ///
+    /// Panics if `CONFIG_RUST_OVERFLOW_CHECKS` is enabled and `mhz` is greater
+    /// than `c_ulong::MAX / 1_000_000`.
     pub const fn from_mhz(mhz: c_ulong) -> Self {
         Self(mhz * Self::MHZ_TO_HZ)
     }
 
     /// Create a new instance from gigahertz (GHz)
+    ///
+    /// # Panics
+    ///
+    /// Panics if `CONFIG_RUST_OVERFLOW_CHECKS` is enabled and `ghz` is greater
+    /// than `c_ulong::MAX / 1_000_000_000`.
     pub const fn from_ghz(ghz: c_ulong) -> Self {
         Self(ghz * Self::GHZ_TO_HZ)
     }
-- 
2.53.0



