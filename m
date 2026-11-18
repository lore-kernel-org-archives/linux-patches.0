Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020467;
	b=wbXYwUTvpB83w/qNGItnV/vNoSXdPN4X+RSn0ZZJgue4UdqTHAhdZkMnf2vd05Ghmwa2
	 /DIvqy0C5H284j2VM2aAWzMQMAPad9G2vB/XM+t53OtO/3OCvIhTR0PqNwv3KD8+crjEu
	 u6mozjPk4gqfgML1oxdEssQLPz/ZqeI5uYl4zFdTGP3J0nJRpPuwFAPOYrdzCdYL1njRI
	 My52IKjl+zaUPXUzV/wSoQuu37rONEUsqIRPWkJJlEIsnzG3F1lfLYLc4Ey21yydeIDFp
	 rfvydCTWn/gPf/QPIrx9JHaUF+G+T9sZTpLGIz+E7XPXHtzP29kYsDfWCzJaSoecnoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020467;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fSi4HSFL0G3jTKvTblG2LHYh1fSxzX50efw8qqP04i8=;
	b=0yVkxtvvVKK0w4aQI7A96ibURwfKy5cp1lI10zYHzTb/Abqf9A0IT8kOy9p5Nha/blLW
	 RBvz+LT940mSEv75sD/cgx4wIqU/Uakgv5Bqe46//FlMbq2Ih+/xJJezRPBoypxqaQXDk
	 XbhsbU6VesPXXtl+jKYn5mfO3wAT0Fuuuh4T47gXW9NTjxSAK64INjvJdFQO6gjRroVpP
	 VDlrBVgXCL5ZJjNIhOrfry0CHq8MdYHJyV97IcdczL+Z3TWkxdJqwSNOUAVCZGbmk6URP
	 Qf9LYTAnwYfTLYSUO/sDJohX2hxXj1hwwe+Y+L2yLhmQKU3M5vziRMUjonNcF745fow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mcNtvsWt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1988A606A320;
	Wed, 18 Nov 2026 16:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mcNtvsWt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AA461F000C6;
	Wed, 18 Nov 2026 16:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020467;
	bh=fSi4HSFL0G3jTKvTblG2LHYh1fSxzX50efw8qqP04i8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mcNtvsWtC+J8cQ5E6zVZ6gRC48LD+6YXSFCyhGnxLq2To/7r2P6hZlG65WZJ3iSp/
	 bGpJO5OVXJpbw00BCrGYcm0Bsw2r1Pl4ONKilTd867zDJbljhAu2N4QknXkEO4gCly
	 ewqM3xMclBy2HibhdSztFrei2Eq3Blj+/eavhczY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1925/2651] rust: zerocopy: fix link to upstream `README.md`
Date: Wed, 18 Nov 2026 15:52:45 +0100
Message-ID: <20261118150356.022613885@linuxfoundation.org>
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

From: Miguel Ojeda <ojeda@kernel.org>

[ Upstream commit d61be5c960e4b89b2e6fa8cedc1d9aa64401ae13 ]

Upstream moved the `zerocopy` crate into a `zerocopy/` subdirectory
of their repository in v0.8.51 [1]. However, in our v0.8.52 update,
the link was not updated.

Fix it by adding the subdirectory.

Fixes: 2808a3963988 ("rust: zerocopy: update to v0.8.52")
Link: https://github.com/google/zerocopy/pull/3434 [1]
Assisted-by: LLM
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Link: https://patch.msgid.link/20261013184809.35143-1-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/zerocopy-derive/README.md | 2 +-
 rust/zerocopy/README.md        | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/rust/zerocopy-derive/README.md b/rust/zerocopy-derive/README.md
index d62c798043424..49de31b8e0827 100644
--- a/rust/zerocopy-derive/README.md
+++ b/rust/zerocopy-derive/README.md
@@ -8,7 +8,7 @@ non-ASCII identifiers.
 
 For copyright details, please see:
 
-    https://github.com/google/zerocopy/blob/v0.8.54/README.md?plain=1
+    https://github.com/google/zerocopy/blob/v0.8.54/zerocopy/README.md?plain=1
     https://github.com/google/zerocopy/blob/v0.8.54/LICENSE-BSD
     https://github.com/google/zerocopy/blob/v0.8.54/LICENSE-APACHE
     https://github.com/google/zerocopy/blob/v0.8.54/LICENSE-MIT
diff --git a/rust/zerocopy/README.md b/rust/zerocopy/README.md
index 3d11a6502cf0c..8443f61660089 100644
--- a/rust/zerocopy/README.md
+++ b/rust/zerocopy/README.md
@@ -7,7 +7,7 @@ modified to tweak the SPDX license identifiers.
 
 For copyright details, please see:
 
-    https://github.com/google/zerocopy/blob/v0.8.54/README.md?plain=1
+    https://github.com/google/zerocopy/blob/v0.8.54/zerocopy/README.md?plain=1
     https://github.com/google/zerocopy/blob/v0.8.54/LICENSE-BSD
     https://github.com/google/zerocopy/blob/v0.8.54/LICENSE-APACHE
     https://github.com/google/zerocopy/blob/v0.8.54/LICENSE-MIT
-- 
2.53.0



