Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9072E218594;
	Thu, 12 Dec 2024 15:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018837; cv=none; b=s6Op9f/4cTgBlq9FXpBnf2IY2WdpMt+9loD/uKchfw7YS2W+RShOkQR1rkrXG7Ko+TfXkGeRoOv286j85vtV7Z2/DE2UNy8bsErL5LpNvfoowpvDzNtzDBEloQTYS2X1/wgBIBQx6f0muJRLOQGiqD2fy18mb/VjmgJm5heq6Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018837; c=relaxed/simple;
	bh=PnWcS4DccGcHL/nSPPr47Ed9p0XS/MrivW1g9V74UdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ssC+ZjW+oGgkwfOBlA7fwuA4Jpr8O3pYMMjFs/a0m6YGQJdvM4SOlcO45DwIss7chjaBqp0KJNZMUns0kzvucb9QKLKMN+0XjvMmyZgTpJ+aZUxE8R3ZE7iSI7B41TvL/xs441HNTbksi0sqBSaAdc9V/R6shc5RRPcOezRJRBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sjVHlAsT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sjVHlAsT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F156CC4CECE;
	Thu, 12 Dec 2024 15:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018837;
	bh=PnWcS4DccGcHL/nSPPr47Ed9p0XS/MrivW1g9V74UdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sjVHlAsTQO1CODxqQ/oAl3+IiOkog3zwJX1wYvwR0jtbB1pNF6tZc2L8eTp6I5VmR
	 N4Tn7/anQWucVMhfxkIEYN9qBPEx/Y5IPdMf2xYKhsL0N7vxOBK5IZD6kZaPeew5g0
	 EmAXEPhPd0x9dEnF2USGTAOsVWaVue6OpqmehEAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Przywara <andre.przywara@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 047/772] kselftest/arm64: mte: fix printf type warnings about longs
Date: Thu, 12 Dec 2024 15:49:52 +0100
Message-ID: <20241212144351.882178036@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



