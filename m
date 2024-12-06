Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0174A1474AF;
	Fri,  6 Dec 2024 14:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496600; cv=none; b=p6JqRYxduxP5VhDNL0UFVD7WOBLApw18u+VCo0upVas+kf1GsWLdKuswMlwyR2CK6Xh3QU7C3bTam+5z7oM+giubXLov26eLJsVDddsV8vLAg1LFbjSQ+UfTeb35s8EDfPuMhwNlpFyfT6nr7aPbFntcnu1+ZdvBuYh2sfTxoqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496600; c=relaxed/simple;
	bh=8ad87CGldUXPW12wUbPuH5N65Ybgiu4JEgKuxmMYO8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sv1oHp3APx+8o0AgVT/yAhD56hIppmWn58ha/yJtVclydk1Xw7sRDVDNbD1jw1wjo7sx0IqWt2o/hTItrsA+vdB9o88RWZYcpXbv6f8ceTAx76yfpbuFTSsX24ZIpnz+vZJCkSCFWmPQEV2cOVsuKLo9y0gagc24L7H6Q3OU+RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=slwiWH5S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="slwiWH5S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64257C4CED1;
	Fri,  6 Dec 2024 14:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496599;
	bh=8ad87CGldUXPW12wUbPuH5N65Ybgiu4JEgKuxmMYO8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=slwiWH5S0NjEN3CM2X6njteYbKbnbcpEbMYEKV5z/iK5YwzO+2gWsKKR1Vunxhzad
	 ieO0zxATBktOWlFNS667DKMFh7+BtZ9K/e8q97Bc20kGhcT48n5RdYRI9txxIyABG9
	 qZxkEAgHMLjv6IRVOzl8Zdp2/vtN5FZuDKqYidIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Przywara <andre.przywara@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 051/676] kselftest/arm64: mte: fix printf type warnings about longs
Date: Fri,  6 Dec 2024 15:27:50 +0100
Message-ID: <20241206143655.345861590@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2b1425b92b699..a3d1e23fe02af 100644
--- a/tools/testing/selftests/arm64/mte/check_tags_inclusion.c
+++ b/tools/testing/selftests/arm64/mte/check_tags_inclusion.c
@@ -65,7 +65,7 @@ static int check_single_included_tags(int mem_type, int mode)
 			ptr = mte_insert_tags(ptr, BUFFER_SIZE);
 			/* Check tag value */
 			if (MT_FETCH_TAG((uintptr_t)ptr) == tag) {
-				ksft_print_msg("FAIL: wrong tag = 0x%x with include mask=0x%x\n",
+				ksft_print_msg("FAIL: wrong tag = 0x%lx with include mask=0x%x\n",
 					       MT_FETCH_TAG((uintptr_t)ptr),
 					       MT_INCLUDE_VALID_TAG(tag));
 				result = KSFT_FAIL;
@@ -97,7 +97,7 @@ static int check_multiple_included_tags(int mem_type, int mode)
 			ptr = mte_insert_tags(ptr, BUFFER_SIZE);
 			/* Check tag value */
 			if (MT_FETCH_TAG((uintptr_t)ptr) < tag) {
-				ksft_print_msg("FAIL: wrong tag = 0x%x with include mask=0x%x\n",
+				ksft_print_msg("FAIL: wrong tag = 0x%lx with include mask=0x%lx\n",
 					       MT_FETCH_TAG((uintptr_t)ptr),
 					       MT_INCLUDE_VALID_TAGS(excl_mask));
 				result = KSFT_FAIL;
-- 
2.43.0



