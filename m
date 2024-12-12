Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689A12358A6;
	Thu, 12 Dec 2024 16:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021841; cv=none; b=aS/qFWafzKfERcvAf9KJmUk4L5eVX1nZTh/8ast1z/qzvD6GUPMHEJxhKl1WJckAuHbOVRKLWEUpO3I05D7px8Y/4m/zyRQ7d4JhvBPHNJASz/XBIr4g0w0NIABT1sXo1QiqRzmdNV49iUhmsOM5Jwh08gRdfI5qpJNXA5F7FjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021841; c=relaxed/simple;
	bh=VdaOEmcH189KEFVjhdKmNeITIMsfl/ARkpNOfsda7DI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AUXaXqHjUCrQdi8C1SLRMFu3k5jWXTYSzKYEurQhVVnUCJYsEKukfykT/08BH98f90s8186dCzZsANR3zAEZVypSGlQpk74R4O17xAsjJTxygCIYYvoG6I+t3cX3Ibs9m+A1cEVS6bGmsT31pI8PITOPUoFRpa1r2eegykxYC+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=16XF9UJK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="16XF9UJK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC891C4CECE;
	Thu, 12 Dec 2024 16:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021841;
	bh=VdaOEmcH189KEFVjhdKmNeITIMsfl/ARkpNOfsda7DI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=16XF9UJKryb7mpKj5iN8ZEiYiKQ13PLSiOZkSRqlJpwEuiF96t35DpkKAM0ejjB4N
	 GsmsXkf18o/odNzR0e/vYREA9Itrrm7ihqOBHeacWDZvFeKojrVhquHxTnjJw3/Foc
	 c9ng3LKS/rRD7kpT7SpQ4vQ0d2glF/lsxhM1yheg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Przywara <andre.przywara@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 077/565] kselftest/arm64: mte: fix printf type warnings about longs
Date: Thu, 12 Dec 2024 15:54:32 +0100
Message-ID: <20241212144314.532820285@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit 96dddb7b9406259baace9a1831e8da155311be6f ]

When checking MTE tags, we print some diagnostic messages when the tests
fail. Some variables uses there are "longs", however we only use "%x"
for the format specifier.

Update the format specifiers to "%lx", to match the variable types they
are supposed to print.

Fixes: f3b2a26ca78d ("kselftest/arm64: Verify mte tag inclusion via prctl")
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20240816153251.2833702-9-andre.przywara@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/arm64/mte/check_tags_inclusion.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/arm64/mte/check_tags_inclusion.c b/tools/testing/selftests/arm64/mte/check_tags_inclusion.c
index deaef1f610768..74a3727f640de 100644
--- a/tools/testing/selftests/arm64/mte/check_tags_inclusion.c
+++ b/tools/testing/selftests/arm64/mte/check_tags_inclusion.c
@@ -57,7 +57,7 @@ static int check_single_included_tags(int mem_type, int mode)
 			ptr = (char *)mte_insert_tags(ptr, BUFFER_SIZE);
 			/* Check tag value */
 			if (MT_FETCH_TAG((uintptr_t)ptr) == tag) {
-				ksft_print_msg("FAIL: wrong tag = 0x%x with include mask=0x%x\n",
+				ksft_print_msg("FAIL: wrong tag = 0x%lx with include mask=0x%x\n",
 					       MT_FETCH_TAG((uintptr_t)ptr),
 					       MT_INCLUDE_VALID_TAG(tag));
 				result = KSFT_FAIL;
@@ -89,7 +89,7 @@ static int check_multiple_included_tags(int mem_type, int mode)
 			ptr = (char *)mte_insert_tags(ptr, BUFFER_SIZE);
 			/* Check tag value */
 			if (MT_FETCH_TAG((uintptr_t)ptr) < tag) {
-				ksft_print_msg("FAIL: wrong tag = 0x%x with include mask=0x%x\n",
+				ksft_print_msg("FAIL: wrong tag = 0x%lx with include mask=0x%lx\n",
 					       MT_FETCH_TAG((uintptr_t)ptr),
 					       MT_INCLUDE_VALID_TAGS(excl_mask));
 				result = KSFT_FAIL;
-- 
2.43.0



