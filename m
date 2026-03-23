Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A016317A305;
	Mon, 23 Mar 2026 15:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278050; cv=none; b=mvrFPQ46Qv6sAKspW85x/ezoGauLMnlWh0cgfSx2EPB/KvNQmhC26/M+y7erh4O+CHJl1IDNj8wMBkef1ja/MNbYFG49ubxgPs37y8jx6R7VAd8Qiqff0OZfEljGR7RgJDEEVuHpyWJUzYV5KvRQRti/seyT2Q24Y8+8BaWxPXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278050; c=relaxed/simple;
	bh=YK1+wrbkE5bxMdkRAdicFDfu3u5MdddT9hCORbGWWz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EipJtKdA8GRuEbXcJNr3ANGz5gzT1fnQ+gg7rmgbJgH8plswfcR6fis+lzY4vJ3bO2NlneYxjpsLva3ut8OVEc5twgMXVW+8ujtp4SFm2228ZdVbsTSrTXgiTLyeN27LclwYuOmORwuZCe4GSQQl4UVybjlgx0fYDZUrhnAYSzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g6Z2QqeJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g6Z2QqeJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 227C6C4CEF7;
	Mon, 23 Mar 2026 15:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278050;
	bh=YK1+wrbkE5bxMdkRAdicFDfu3u5MdddT9hCORbGWWz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g6Z2QqeJewY3RcUll4/0PutZICPID+ieb+PxnJeO7iPGjXHTxqiwKdqRKWonAs7sb
	 FymWJDlXg2OUJzAiayBNzYc022e6Rsr7b2d2oCZrzO3He/He63v507wgROljy+f6s9
	 ZzvFFY/FWmFw6ocBNQAwrlMn2ak01FRQ12K+ewuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Wu <wuyifan50@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 183/567] selftest/arm64: Fix sve2p1_sigill() to hwcap test
Date: Mon, 23 Mar 2026 14:41:43 +0100
Message-ID: <20260323134538.380801558@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e3d262831d919..311a2a65f7cf2 100644
--- a/tools/testing/selftests/arm64/abi/hwcap.c
+++ b/tools/testing/selftests/arm64/abi/hwcap.c
@@ -216,8 +216,8 @@ static void sve2_sigill(void)
 
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



