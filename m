Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 848DA32D0E1;
	Mon, 27 Oct 2025 19:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593115; cv=none; b=i5t+o/D/htmP8xmngW7/x39sUENtcbMrOkLujnxjIo2ro3Ao86JeUh9MHCd69vTes+CJhMNvw5jcJw+xoH2xCt6MBZGMKlR0/66gvvNia+3lw15TdPHt71h3YUUAVchh27xuzjiMUAmPGwkNKDy5heJAOw9UdoCQvR8GwFtdmhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593115; c=relaxed/simple;
	bh=SNC8REIofvflG6hTr98U4lid7nVq2eL01PPC7PIyNN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GUuYRo5iYTant7ZS/7zQ48IJ8X2gCU53vv35GSuZEwcyvPRxEAC6Ev8YaFj7FYGpdcGB+Soe8JUm8sNh29/SmZUlyhLxEps3mFwzl+u9QL2gXrqjpEMOqdYZLlszbEoWSxQ72TX4jfnYCc2YHmVwi0SUrnUmu70gMeF/+LsVlRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1dWIcsPt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1dWIcsPt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1779EC4CEF1;
	Mon, 27 Oct 2025 19:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593115;
	bh=SNC8REIofvflG6hTr98U4lid7nVq2eL01PPC7PIyNN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1dWIcsPtdBZskKq2T1ak6dt1PhawgafGeWMUf0oA2uNhE1CVdWPeb6qRogR4YwxVV
	 jcouqAq13do42m5kdhy269ll1W7KvnyuiaZcXGkXLvt+IItFe91Vtz+uYTRgjvF3FP
	 pw2dPSCdyzwmoooIODfu8QAqBZLQ6gfcyaFW4wq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <tabba@google.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 019/184] arm64: sysreg: Correct sign definitions for EIESB and DoubleLock
Date: Mon, 27 Oct 2025 19:35:01 +0100
Message-ID: <20251027183515.451121628@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 696ab1f32a674..2a37d4c26d870 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1693,7 +1693,7 @@ UnsignedEnum	43:40	TraceFilt
 	0b0000	NI
 	0b0001	IMP
 EndEnum
-UnsignedEnum	39:36	DoubleLock
+SignedEnum	39:36	DoubleLock
 	0b0000	IMP
 	0b1111	NI
 EndEnum
@@ -2409,7 +2409,7 @@ UnsignedEnum	11:8	ASID2
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



