Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A7F38C423;
	Thu, 12 Mar 2026 20:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346316; cv=none; b=uYc7tY+QijfNKkOZ0SieJBJ8pfHbjYDNjHY0X6P+HqyO16uBx2sy8yS0JHeaJmOXhhpfJ6Gczb1eWzOv0b+Nux2e+/REgeEQ27AHsWQ6PmJCcCDqql/vXg2hhyDyNdXpA0qvoun8sZnHZTBY0mWeItEPGvbRx9oVdrOugx94v9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346316; c=relaxed/simple;
	bh=gyasMLonZAcBXkUD+HZYJhWxksulQW4YYiZp2KXkWU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MArxGX4Ln2ArqYRC5SolWUzxtw1rxOAs4m//x1JngxtDF9KbXcBVyMN7a9XZhU78AO8D+FQHAdGXZKHSTZgzVLKyZqfBQ5akpoXktobN2vlfWwc+jvZbrKjxYn6CQ5SqqPhkZkYb5ji5s5ftJRJmlOONq9KU8ScyRcs5V7AON7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d/Ch12Kz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d/Ch12Kz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21D21C4CEF7;
	Thu, 12 Mar 2026 20:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346316;
	bh=gyasMLonZAcBXkUD+HZYJhWxksulQW4YYiZp2KXkWU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d/Ch12KzZufOxfWlveptSlXjalhSKpNKgppN/2H8wCAQcO9ewK45kwkf//swmBDOy
	 ctDFWzgMkUjjVVDSYSTg7njXSaLwAnff8L21b2foDU7e5imjEOISl5xMY+Z9HIxjfy
	 0A+rKoy8hQlb3zoQWrMaGzmU51r4MXT1g1HWh8rk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 004/265] KVM: arm64: Advertise support for FEAT_SCTLR2
Date: Thu, 12 Mar 2026 21:06:31 +0100
Message-ID: <20260312201018.304349696@linuxfoundation.org>
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

From: Oliver Upton <oliver.upton@linux.dev>

[ Upstream commit 075c2dc7367e7e80d83adae8db597e48ceb7ba94 ]

Everything is in place to handle the additional state for SCTLR2_ELx,
which is all that FEAT_SCTLR2 implies.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20250708172532.1699409-22-oliver.upton@linux.dev
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Stable-dep-of: f66857bafd4f ("KVM: arm64: Hide S1POE from guests when not supported by the host")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 5c09c788aaa61..784603a355487 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1559,8 +1559,10 @@ static u64 __kvm_read_sanitised_id_reg(const struct kvm_vcpu *vcpu,
 		val &= ~ID_AA64MMFR2_EL1_CCIDX_MASK;
 		break;
 	case SYS_ID_AA64MMFR3_EL1:
-		val &= ID_AA64MMFR3_EL1_TCRX | ID_AA64MMFR3_EL1_S1POE |
-			ID_AA64MMFR3_EL1_S1PIE;
+		val &= ID_AA64MMFR3_EL1_TCRX |
+		       ID_AA64MMFR3_EL1_SCTLRX |
+		       ID_AA64MMFR3_EL1_S1POE |
+		       ID_AA64MMFR3_EL1_S1PIE;
 		break;
 	case SYS_ID_MMFR4_EL1:
 		val &= ~ARM64_FEATURE_MASK(ID_MMFR4_EL1_CCIDX);
@@ -2521,6 +2523,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 					ID_AA64MMFR2_EL1_NV |
 					ID_AA64MMFR2_EL1_CCIDX)),
 	ID_WRITABLE(ID_AA64MMFR3_EL1, (ID_AA64MMFR3_EL1_TCRX	|
+				       ID_AA64MMFR3_EL1_SCTLRX	|
 				       ID_AA64MMFR3_EL1_S1PIE   |
 				       ID_AA64MMFR3_EL1_S1POE)),
 	ID_SANITISED(ID_AA64MMFR4_EL1),
-- 
2.51.0



