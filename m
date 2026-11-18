Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024277;
	b=KypWxdnI9X0XMxrb3V0vnF0dCdtZbggKy7IQCgqDCaXePhw29/hrhn3xAz1yPn+tgtVX
	 jKTcAF4qEntdwu6zIPNUy/8dnHLTmsC9D+FBLEY+7jxDNqPpRxwT0hCNkUhtUOG3k0WBD
	 fkoZijDy9+V4D0r+n1aidpGOIC9jTxcO1anp9ztuCFsqRmoSWCNWwYeHW/3YTbUoBWv9u
	 O1N4ROfFxZuYYB4sRn0W0jFIaeIJKOUv95LHvX005lf9ABOF7nixRKB/tsEC50SaHrPzw
	 nTtCpafJJaCYNb/ImwqfZ0o0lfctDSipghLvdtajUrvJ2rN7vGmZBRVPZ3/xd6oHF9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024277;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/93brYvZca6qRMuwafQrdzoQVnTB9/VMe7heGczdfTs=;
	b=Y4sZUR4L9V9BMFUc2eS8QxbskAH7FsyGlNoouijotX7A7JkZUhhQRcdHXUpRpNY4fplm
	 wxEqr4AHxr8TO+o+8rMFdETFT/1eNztzcJ6SPN0nN+gp+PET92HAAeuOe4Re1whGkvUss
	 xB8dQi7Rk8rgBmaXpe/QI1jb/FBQV0HE5Gbk6Xj+vkEUAXESD021v4hka7vcuem3L7rPf
	 5Q5tCsduvbYkWGM7hOxmDW9WTW0ovq5emSLP6L9mMJ0i82wPD4O4DvcxkMUFKU/PtonYN
	 2QUeT1lJ4wBe6/sy+9v8QLvgc6fLyFvKjgKMNcCs+PryMR0TcTU5ATJw3CLFgYdOE8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VGkF2vu5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B36606A32F;
	Wed, 18 Nov 2026 17:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VGkF2vu5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E0A1F000C4;
	Wed, 18 Nov 2026 17:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024276;
	bh=/93brYvZca6qRMuwafQrdzoQVnTB9/VMe7heGczdfTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VGkF2vu5zK8j3lFTusy28WOUdvGKYnO5HFizh3IA74kw4x21XmkJtLsEDI5KLXa5t
	 /4JivFsVwJjRp4ouDHuA4OWkdMWqCLgk4a+jJ8fr2nUr3LxvnANz3qyJ7JWLVtRPNx
	 HroR+mDELijiQ1Sgwv1r5pSlMq1qVn3tyFmGyEQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgios Androutsopoulos <georgeandrout13@gmail.com>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0668/2151] rust: clk: document overflow panics in `Hertz` constructors
Date: Wed, 18 Nov 2026 15:40:03 +0100
Message-ID: <20261118150146.157399846@linuxfoundation.org>
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
index 1e6c8c42fb3a3..14726ff9c9396 100644
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



