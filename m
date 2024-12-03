Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2BF120B800;
	Tue,  3 Dec 2024 15:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240099; cv=none; b=XPSbjf7VGk7PyjRev+xHVLnLQPR1ATGPHGS5SmvRQQS6OKO6VBSYP3n4y6o589UqC70MsPM5PnJWNZYzeFjf6aAb7v9z5HAQTBZ8yeYKIv7Y7aigcA7uit0b+/Nj2fK+fpZZxLviWiP4emxwEP0jZFaigYeXjjKRUXKUJLq7+QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240099; c=relaxed/simple;
	bh=R7BFgU5HdzB0kCYeV/N/TgYzIYRimelw6pXuhSqb0kg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xzr+J+r78uM9q4WJObVlWinEJ1mAaQe+La0BxQq//2LW7jkOB+WncUmwUvv+IHsUHTiNbOnw6c8mGwTL2TJe2n8QTPaWr9wccm9jfHg4EwAGQFn+zZIPTAXSrQj6OqrHUb5zh3A4Tp9ELpGsn1FvOEFYnjHdKYNeYB7DjQMKCVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cp5zNTFU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cp5zNTFU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D0AC4CED8;
	Tue,  3 Dec 2024 15:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240099;
	bh=R7BFgU5HdzB0kCYeV/N/TgYzIYRimelw6pXuhSqb0kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cp5zNTFUMJ2NFw3ex+J6z+nSPKnG3dZqt9r7FFAgMQbbPK878fOyvqtlIEfQ2jLpH
	 S5TItWDuWtdTVgY2s1YOj/BzDYWs4468kdo0ZeM4eP7MxnuTuXEs8Hpp7r6dzf5RY5
	 FGbFstScONvGGJyZPd+dIn9XsgWRhLYkL8nz+5eA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 022/826] kselftest/arm64: Fix encoding for SVE B16B16 test
Date: Tue,  3 Dec 2024 15:35:49 +0100
Message-ID: <20241203144744.324877848@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 69c0d824779843b51ca2339b2163db4d3b40c54c ]

The test for SVE_B16B16 had a cut'n'paste of a SME instruction, fix it with
a relevant SVE instruction.

Fixes: 44d10c27bd75 ("kselftest/arm64: Add 2023 DPISA hwcap test coverage")
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20241028-arm64-b16b16-test-v1-1-59a4a7449bdf@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/arm64/abi/hwcap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/arm64/abi/hwcap.c b/tools/testing/selftests/arm64/abi/hwcap.c
index 7e95ba5fd4962..265654ec48b9f 100644
--- a/tools/testing/selftests/arm64/abi/hwcap.c
+++ b/tools/testing/selftests/arm64/abi/hwcap.c
@@ -361,8 +361,8 @@ static void sveaes_sigill(void)
 
 static void sveb16b16_sigill(void)
 {
-	/* BFADD ZA.H[W0, 0], {Z0.H-Z1.H} */
-	asm volatile(".inst 0xC1E41C00" : : : );
+	/* BFADD Z0.H, Z0.H, Z0.H */
+	asm volatile(".inst 0x65000000" : : : );
 }
 
 static void svepmull_sigill(void)
-- 
2.43.0



