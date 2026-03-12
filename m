Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7DB43242AC;
	Thu, 12 Mar 2026 20:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347266; cv=none; b=Kn3o+K8+o8Xv8KpSrF1FuG0ufMBd4bZsaDgJBJu5OuTAvSDBNYN1fyPsFdcMx8bS+pBBRcyeQ0pKQvc2tVp9/NMFLJJRwB6THdCyqcpxDlrtvOci5yhsl5YZkdt/R6k0wazcuuKiW63zUi35Ax6T14CS9bTUOcyQLpGVJ+fqeMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347266; c=relaxed/simple;
	bh=yd7vG2vxTxdk6i35GKqO+OkY2LhwlRYAWtW7Scnp0mg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g8ueagscgTd47ai1FKQkqpKM3xvmKMptGOaSAPOTu+1HkkDZ+PE4Ciy4vbnKEDiqgi+u9tU9+stwPtgqEN90U+mGTDy1Cpdaxuv5/HqPCpupd0ZJ6MNxo7q3x09A21ts0BkQ9FMGydMuZxWjbxiU+rXZAG+cTayoCpx+KKefxMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=brQBO3iA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="brQBO3iA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EFDEC4CEF7;
	Thu, 12 Mar 2026 20:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773347266;
	bh=yd7vG2vxTxdk6i35GKqO+OkY2LhwlRYAWtW7Scnp0mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=brQBO3iAC7W829Jrz6PfyGBxXYvmaML6g/cQjTvQ6AfSGOcUQD0h7VoZYJR5r44K8
	 0NvH2XlzJGxewrLmZc1jgWZ9PXRXGrPpnbKsCcJOd0aaUQAF3qYW2hnLQo/Zey498R
	 BNu4/78FwJ+VQpZ+TSxiX+gyq9NEMYjmCBbBcvV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Wu <wuyifan50@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 247/265] selftest/arm64: Fix sve2p1_sigill() to hwcap test
Date: Thu, 12 Mar 2026 21:10:34 +0100
Message-ID: <20260312201027.260880820@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 265654ec48b9f..097bd51e14ca2 100644
--- a/tools/testing/selftests/arm64/abi/hwcap.c
+++ b/tools/testing/selftests/arm64/abi/hwcap.c
@@ -349,8 +349,8 @@ static void sve2_sigill(void)
 
 static void sve2p1_sigill(void)
 {
-	/* BFADD Z0.H, Z0.H, Z0.H */
-	asm volatile(".inst 0x65000000" : : : "z0");
+	/* LD1Q {Z0.Q}, P0/Z, [Z0.D, X0] */
+	asm volatile(".inst 0xC400A000" : : : "z0");
 }
 
 static void sveaes_sigill(void)
-- 
2.51.0



