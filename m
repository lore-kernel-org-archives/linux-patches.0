Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1C038BF75;
	Tue, 10 Mar 2026 11:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141303; cv=none; b=Ksw7B9h7GI1F0BwM7RDPlIO8tpS/uczsf+EQTjG1itE6yNj00qC384vMl4Wp9JwuUcvU5wHZkZ66HnXVBgx60Tsnr5+uCNO1JTIuzhu2wuR8zrPtqMbZQtHNLWoSBt50oCzs/VOvRBsc1pobj2wvEsmec0inbot/HGkjezS+orU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141303; c=relaxed/simple;
	bh=28JPysTZEQkN33lWposklK4+9ocCHdkpWB3plu6rkaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X4nrp0lKsSKIbksjXE5/vMupnCkDCnkpBFgsqRIsdJbmE6aR/O5yX4ep02GINIoDls8F6E6SmLDlljelmfUwPNefDEl/5XJ2BSW1FlFtJKalwoQl2GcsLw5FnGhNlfQnKMKruqtC04h0eydW15t23zEGUswXdxnw3T4Hr8F9UVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KgRgTFMQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KgRgTFMQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D2DAC2BC9E;
	Tue, 10 Mar 2026 11:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141303;
	bh=28JPysTZEQkN33lWposklK4+9ocCHdkpWB3plu6rkaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KgRgTFMQrIsn25fIjgtIqSuRF3bcNTYY/XDFAx37uE0UogwZa4hYdeMKc3D2UI54D
	 nf9dxrfWK4HiJ99FLnC2IKjitvmYvYvp0xyu8Hj6mUm/Y2B5m5RkWzx4kcfhArfWfn
	 4O6oyz4YSbTY6JZU9oG4vpuLMJWwOaSxwhDXSDw0rkrzLphesAy6zcRfHNxij847Uf
	 ymVKMxawImesRWJAB2nVbIoD5JTCUJDHIyH9fJig2ewei08v/e7xNIbNfImLJcXC0S
	 NsYS0IkTmRlo8wKl2sBe0tRGpP3ushS1nV/llu/kpgEa3ajLCW/PEtudUgP+ZTckSL
	 5p34kaZzw0E7A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yifan Wu <wuyifan50@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 308/311] selftest/arm64: Fix sve2p1_sigill() to hwcap test
Date: Tue, 10 Mar 2026 07:05:55 -0400
Message-ID: <012f16c0f3c2eb8c5e575ec2007dc9e2c3f3be12.1773140656.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Yifan Wu <wuyifan50@huawei.com>

[ Upstream commit d87c828daa7ead9763416f75cc416496969cf1dc ]

The FEAT_SVE2p1 is indicated by ID_AA64ZFR0_EL1.SVEver. However,
the BFADD requires the FEAT_SVE_B16B16, which is indicated by
ID_AA64ZFR0_EL1.B16B16. This could cause the test to incorrectly
fail on a CPU that supports FEAT_SVE2.1 but not FEAT_SVE_B16B16.

LD1Q Gather load quadwords which is decoded from SVE encodings and
implied by FEAT_SVE2p1.

Fixes: c5195b027d29 ("kselftest/arm64: Add SVE 2.1 to hwcap test")
Signed-off-by: Yifan Wu <wuyifan50@huawei.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/arm64/abi/hwcap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/arm64/abi/hwcap.c b/tools/testing/selftests/arm64/abi/hwcap.c
index c41640f18e4ec..62ea450f2ccc0 100644
--- a/tools/testing/selftests/arm64/abi/hwcap.c
+++ b/tools/testing/selftests/arm64/abi/hwcap.c
@@ -473,8 +473,8 @@ static void sve2_sigill(void)
 
 static void sve2p1_sigill(void)
 {
-	/* BFADD Z0.H, Z0.H, Z0.H */
-	asm volatile(".inst 0x65000000" : : : "z0");
+	/* LD1Q {Z0.Q}, P0/Z, [Z0.D, X0] */
+	asm volatile(".inst 0xC400A000" : : : "z0");
 }
 
 static void sve2p2_sigill(void)
-- 
2.51.0

