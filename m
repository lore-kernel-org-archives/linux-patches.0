Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E57321576E;
	Mon, 27 Oct 2025 19:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592790; cv=none; b=gjUTn8BKbu6zq2Kw0GGWneSEBnoufeIhSK6bHwei6b0Zl5nD1vrrVGjZVh4xV1CqM6vlahrU6ky8qtirintxBjQB5txWKYwobCavZJv00kBYqXtOQb4+QlxjfbXuuukbnS1lIlAIoYyY5YgjbPoZT65eXF0guYxkuPLk1NRPUoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592790; c=relaxed/simple;
	bh=NhiCV4be9oOTw1f02Jnnp0NNng5V6tqdp6dtVp67BPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZGcPiycKwhKRdbCazOVSDUtqNxPFHj8U+UcJEs5TM3R61iTfBQiV2D+9p/4Z7lvbrpDi+TD/RxiMLPVKXtLDOu1mxo0RrVJm2XrprCPCntekEdMyY961hqk+rbR989MBRS4GRfz7vgyBjfjhgE+E+awH7RyVos3Go4iaAwhPNyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XVlKJLpK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XVlKJLpK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A68CAC4CEF1;
	Mon, 27 Oct 2025 19:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592790;
	bh=NhiCV4be9oOTw1f02Jnnp0NNng5V6tqdp6dtVp67BPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XVlKJLpK+QNnYoH7xD2Ly3cQ0I3g2Z50gbZhXwl9MyfwtA11N0CJMcZcfhKG5PdlZ
	 4soruJADZm33mswO9EQf6OoYtco+RYFZU2Y+VXcsBMbocmdWyCMcKEr/7zrz/z6sZX
	 wX4venZjr35G7kSRMbufG1SayQvmS/dmf0RL09BQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <tabba@google.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 013/117] arm64: sysreg: Correct sign definitions for EIESB and DoubleLock
Date: Mon, 27 Oct 2025 19:35:39 +0100
Message-ID: <20251027183454.299225872@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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

From: Fuad Tabba <tabba@google.com>

[ Upstream commit f4d4ebc84995178273740f3e601e97fdefc561d2 ]

The `ID_AA64MMFR4_EL1.EIESB` field, is an unsigned enumeration, but was
incorrectly defined as a `SignedEnum` when introduced in commit
cfc680bb04c5 ("arm64: sysreg: Add layout for ID_AA64MMFR4_EL1"). This is
corrected to `UnsignedEnum`.

Conversely, the `ID_AA64DFR0_EL1.DoubleLock` field, is a signed
enumeration, but was incorrectly defined as an `UnsignedEnum`. This is
corrected to `SignedEnum`, which wasn't correctly set when annotated as
such in commit ad16d4cf0b4f ("arm64/sysreg: Initial unsigned annotations
for ID registers").

Signed-off-by: Fuad Tabba <tabba@google.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/tools/sysreg | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 362bcfa0aed18..5127d3d3b8677 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1213,7 +1213,7 @@ UnsignedEnum	43:40	TraceFilt
 	0b0000	NI
 	0b0001	IMP
 EndEnum
-UnsignedEnum	39:36	DoubleLock
+SignedEnum	39:36	DoubleLock
 	0b0000	IMP
 	0b1111	NI
 EndEnum
@@ -1861,7 +1861,7 @@ UnsignedEnum	11:8	ASID2
 	0b0000	NI
 	0b0001	IMP
 EndEnum
-SignedEnum	7:4	EIESB
+UnsignedEnum	7:4	EIESB
 	0b0000	NI
 	0b0001	ToEL3
 	0b0010	ToELx
-- 
2.51.0



