Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3D7175A60;
	Sat, 28 Feb 2026 17:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301373; cv=none; b=h1GYMi8oWNM3NxjhG5TROtw4wfFrVYDY1k1D6XVQwKz6OOyaozVMGVgrLqIGipbrRD+BHK/ZXHctxzOezDaRxmwKi45LBIf/aqjxyyfUE32+GBfXKDXd+bhGJk8SCPw+wNp5bA2CvLFVhnznUVtU8/l+8BWmjGeqFKmQ+OZOj50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301373; c=relaxed/simple;
	bh=OaCouxSx0lKU05Hau1lvpeNDX2VRaZRCsIhjdSs/cBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lgr2XYKMT6SOv2EY+8uHIxW5/p2zJJ/GLJ9sE88uNzFe2zyR7qzS6g7LiGq6ROhEqFld65nCVGjTUiP5l0KaAbw4Zi0f2VRxZ4y9QUjmq8nbpdC2sa3Vu/zgp+TJ9dQu2r3JfTxPGKaf8ZUQWFoM9XA7QhIiDYNI+1du5qwinNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JNM7OrOq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JNM7OrOq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BD03C19424;
	Sat, 28 Feb 2026 17:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301373;
	bh=OaCouxSx0lKU05Hau1lvpeNDX2VRaZRCsIhjdSs/cBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JNM7OrOq5H1MxgMwGrXJe04gOZtQF/IWhLYjsq20PBh+VsMAbSq4i7BPWlEj3f7OP
	 FxuI7S9aMuRyHvYgpBLPrufvYg77BEmN0NwGfbZ2zLFfrFKynwbJtVTNTN3GKLM1xV
	 S2PXEEWXlxxTrzfHJ4WbvcxBMSa5oK8Mb7aKknTm192dUT8YciFClUnH8ex2JmdsL2
	 hSxmltvIN0ZKdSWJxSlQq28pC2fT3sPmJ1jeSCx+Q9dxOKJn45qqMzWKJ47QiTsN8z
	 eUgYdwasE5lkUYh9MVnUPR0pIe7o6gD8cloxbQEQr16JkUfSZI8uZa8xL3pWBFrC11
	 HUElQza3Xq6kw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Dirk Behme <dirk.behme@de.bosch.com>,
	stable@vger.kernel.org,
	Alice Ryhl <aliceryhl@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 562/752] drm/tyr: fix register name in error print
Date: Sat, 28 Feb 2026 12:44:33 -0500
Message-ID: <20260228174750.1542406-562-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Dirk Behme <dirk.behme@de.bosch.com>

[ Upstream commit 793e8f7d52814e096f63373eca643d2672366a5a ]

The `..IRQ..` register is printed here. Not the `..INT..` one.
Correct this.

Cc: stable@vger.kernel.org
Fixes: cf4fd52e3236 ("rust: drm: Introduce the Tyr driver for Arm Mali GPUs")
Link: https://lore.kernel.org/rust-for-linux/A04F0357-896E-4ACC-BC0E-DEE8608CE518@collabora.com/
Signed-off-by: Dirk Behme <dirk.behme@de.bosch.com>
Link: https://patch.msgid.link/20260119070838.3219739-1-dirk.behme@de.bosch.com
[aliceryhl: update commit message prefix]
[aliceryhl: add cc stable as per Miguel's suggestion]
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tyr/driver.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tyr/driver.rs b/drivers/gpu/drm/tyr/driver.rs
index d5625dd1e41c8..0052ebe957199 100644
--- a/drivers/gpu/drm/tyr/driver.rs
+++ b/drivers/gpu/drm/tyr/driver.rs
@@ -76,7 +76,7 @@ fn issue_soft_reset(dev: &Device<Bound>, iomem: &Devres<IoMem>) -> Result {
         dev_err!(dev, "GPU reset failed with errno\n");
         dev_err!(
             dev,
-            "GPU_INT_RAWSTAT is {}\n",
+            "GPU_IRQ_RAWSTAT is {}\n",
             regs::GPU_IRQ_RAWSTAT.read(dev, iomem)?
         );
 
-- 
2.51.0

