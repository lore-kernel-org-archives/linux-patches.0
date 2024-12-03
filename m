Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A99D1F7566;
	Tue,  3 Dec 2024 14:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237921; cv=none; b=gTYiIUaHBEXWpI7w3V1VSqcppDD++ivT4uFinsWZ9FlYR7UZ1XKRcFoiCjreTScFDh/uFzOYF3v+BzsIjxiHcR+rYU0phUKPCZBHLqP/0DXMuTzI3AZIWAqmq2t19HsrgclYVhkyWIaw8pjr39dmy+Rg4clkuZC7IjnYtZE96mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237921; c=relaxed/simple;
	bh=myDHcu0VlxiALjvtcrL6Ad36KlTj1dLc9NxuMVX9yN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hM2cctQLTno17YDpO99YRBML3zceDt+0txI/96PwSCgldmhPqNKDJbxRLxYlF7PO1DIp63k9nsY4bnOVTrdOcgRkYVCdm8wc/Rz3p4YIxnFKnCSgcuv4g0V9RAD8FhZ8UHGS4riH3gZtUcx/tYOo1ZPY7bvNpAt5pba/EXgGaj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vNFoJyS7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vNFoJyS7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7800EC4CED8;
	Tue,  3 Dec 2024 14:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237921;
	bh=myDHcu0VlxiALjvtcrL6Ad36KlTj1dLc9NxuMVX9yN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vNFoJyS79Bi6WtNFQd1eTJ32GkLtVieVesN8XqDK65eFmUnclNaJ7SNcY/R+4J9Lf
	 Ebyx/FU1H8HRIJ5kAiJ15Z20RItypVCsMGRtQm/87g6K1AOywkQYKQWlk7qLrE8Fkr
	 R6CgMe00FnYF3smhX+dMev+MKpXQkXnT4qvcR1U0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 066/817] kselftest/arm64: Fix encoding for SVE B16B16 test
Date: Tue,  3 Dec 2024 15:33:58 +0100
Message-ID: <20241203143958.265579018@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 41c245478e412..14e146a23879a 100644
--- a/tools/testing/selftests/arm64/abi/hwcap.c
+++ b/tools/testing/selftests/arm64/abi/hwcap.c
@@ -355,8 +355,8 @@ static void sveaes_sigill(void)
 
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



